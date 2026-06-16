import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'request_retry.dart';
import 'global.dart';
import 'endpoints.dart';

class WebService {
  Dio get dio => _dio;

  late Dio _dio;

  late Future<RefreshTokenResult> Function()? _refreshToken;
  late Map<String, dynamic> _header;
  static late String _baseUrl;

  Future<void> initial({
    required String baseUrl,
    Future<RefreshTokenResult> Function()? refreshToken,
    Map<String, dynamic>? header,
  }) async {
    _baseUrl = baseUrl;
    if (header != null) _header = header;
    if (refreshToken != null) _refreshToken = refreshToken;

    _dio = Dio()
      ..options.baseUrl = _baseUrl
      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.sendTimeout = Endpoints.sendTimeout
      ..options.headers = header
      ..interceptors.addAll([
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseMessage: true,
            printRequestData: true,
            printResponseData: true,
          ),
        ),
        MiddlewareInspector(
          baseUrl: _baseUrl,
          refreshToken: _refreshToken,
          header: _header,
        ),
        ErrorInterceptor(),
      ]);
  }
}

class MiddlewareInspector extends QueuedInterceptorsWrapper {
  final Future<RefreshTokenResult> Function()? refreshToken;
  final Map<String, dynamic> header;
  final String baseUrl;

  MiddlewareInspector({
    required this.baseUrl,
    required this.refreshToken,
    required this.header,
  });

  DioException get _errorNetwork => DioException(
        requestOptions: RequestOptions(path: "Connection problem"),
        type: DioExceptionType.connectionError,
        error: GEasyHelper.errorNetwork,
        message: GEasyHelper.errorNetwork,
      );

  DioException _error(String error) => DioException(
        requestOptions: RequestOptions(path: error),
        type: DioExceptionType.badResponse,
        error: error,
        message: error,
      );

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers = header;
    if (kIsWeb && options.data == null) {
      options.sendTimeout = null;
    }

    if (options.data is FormData) {
      FormData formData = FormData();
      formData.fields.addAll(options.data.fields);

      for (MapEntry mapFile in options.data.files) {
        formData.files.add(MapEntry(
          mapFile.key,
          mapFile.value.clone(),
        ));
      }
      options.data = formData;
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.data is FormData) {
      FormData formData = FormData();
      formData.fields.addAll(response.data.fields);
      for (MapEntry mapFile in response.data.files) {
        formData.files.add(MapEntry(
          mapFile.key,
          mapFile.value.clone(),
        ));
      }
      response.data = formData;
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 403 &&
        "${err.response?.data}".contains(
            "<html>\r\n<head><title>403 Forbidden</title></head>\r\n<body>\r\n<center><h1>403 Forbidden</h1></center>\r\n<hr><center>nginx</center>\r\n</body>\r\n</html>\r\n")) {
      // .contains("<head><title>403 Forbidden</title></head>")) {
      return handler.next(_error(GEasyHelper.vpnError));
    } else if (err.type == DioExceptionType.connectionError) {
      return handler.next(_errorNetwork);
    } else if (err.type == DioExceptionType.unknown &&
        err.error != null &&
        (err.error is SocketException || err.error is HttpException)) {
      return handler.next(_errorNetwork);
    } else if (err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionTimeout) {
      return handler.next(_errorNetwork);
    } else if (err.requestOptions.uri.toString().contains("auth/refresh")) {
      return handler.reject(err);
    } else if (err.response?.statusCode == 401) {
      if (refreshToken != null) {
        final result = await refreshToken!();

        if (result.status) {
          err.requestOptions.headers
              .update(HttpHeaders.authorizationHeader, (value) => result.token);
          var res = await RequestRetry()(
            options: err.requestOptions,
            header: result.header,
            baseUrl: baseUrl,
          );
          if (GEasyHelper.check(res.statusCode)) {
            return handler.resolve(res);
          } else {
            return handler.reject(_error(res.data.toString()));
          }
        }

        /// Navigate to login page.
        return handler.reject(err);
      } else {
        return handler.reject(err);
      }
    } else {
      return handler.reject(err);
    }
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final status = response.statusCode;
    final isValid = status != null && status >= 200 && status < 300;
    if (!isValid) {
      throw DioException.badResponse(
        statusCode: status!,
        requestOptions: response.requestOptions,
        response: response,
      );
    }
    super.onResponse(response, handler);
  }
}

class RefreshTokenResult {
  final String? token;
  final String? refreshToken;
  final String? message;
  final bool status;
  final Map<String, dynamic>? header;

  RefreshTokenResult(
      {this.token,
      this.refreshToken,
      this.message,
      required this.status,
      this.header})
      : assert((status && token != null && header != null) || (!status));

  @override
  String toString() {
    return 'RefreshTokenResult{token: $token, refreshToken: $refreshToken, message: $message, status: $status, header: $header}';
  }
}

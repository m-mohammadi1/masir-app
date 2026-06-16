import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

class RequestRetry {
  Future<Response> call(
      {required RequestOptions options,required String baseUrl, Map<String, dynamic>? header}) async {
    final Dio dio = Dio(BaseOptions(baseUrl:baseUrl ))
      ..interceptors.add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseMessage: true,
            printRequestData: true,
            printResponseData: true,
          ),
        ),
      );
    return await dio.request(
      options.path,
      data: options.data,
      options: Options(
        contentType: options.contentType,
        headers: header ?? options.headers,
        method: options.method,
        validateStatus: (status) => true,
        receiveTimeout: options.receiveTimeout,
        sendTimeout: options.sendTimeout,
        responseType: options.responseType,
        extra: options.extra,
      ),
      cancelToken: options.cancelToken,
      onReceiveProgress: options.onReceiveProgress,
      onSendProgress: options.onSendProgress,
      queryParameters: options.queryParameters,
    );
  }
}

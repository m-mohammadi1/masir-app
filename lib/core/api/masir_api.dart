import 'package:dartz/dartz.dart';
import 'package:easy_helper/easy_helper.dart';
import 'package:injectable/injectable.dart';

import '/core/services/service_locator.dart';

/// Why a request failed, in a form screens can show.
class ApiError {
  final String message;
  final int? status;
  final Map<String, String> fields;

  const ApiError(this.message, {this.status, this.fields = const {}});

  /// No response at all: offline, DNS, timeout.
  bool get offline => status == null;

  /// Persian copy for the errors students can run into.
  String get friendly => _friendly[message] ?? (offline ? message : (RegExp(r'[a-zA-Z]').hasMatch(message) ? genericMessage : message));

  static const _friendly = {
    'invalid credentials': 'نام کاربری یا رمز درست نیست. دوباره امتحان کن.',
    'verification failed': 'این کد درست نیست. دوباره بزنش.',
    'phone already exists': 'با این شماره قبلاً ثبت‌نام شده؛ از «ورود» وارد شو.',
    'username taken': 'این نام کاربری رو قبلاً یکی گرفته.',
    'invite code unusable': 'این کد کار نمی‌کنه. از مؤسسه‌ت دوباره بپرس.',
    'too many requests': 'یه کم صبر کن و دوباره امتحان کن.',
    'not subscribed': 'این واحد با اشتراک باز می‌شه.',
    'unit is locked': 'اول واحدهای قبلی رو تموم کن.',
    'course not found': 'این دوره پیدا نشد.',
    'institute not found': 'این مؤسسه پیدا نشد.',
    'payment not found': 'این پرداخت پیدا نشد.',
    'course is free': 'این دوره رایگانه و اشتراک نمی‌خواد.',
  };

  static const genericMessage = 'یه چیزی این وسط خراب شد، چند لحظه دیگه دوباره امتحان کن.';

  factory ApiError.from(Object e) {
    if (e is DioException) {
      final res = e.response;
      if (res == null) return const ApiError('به سرور وصل نشدیم! اینترنتت رو یه نگاه بنداز.');
      final data = res.data;
      var msg = genericMessage;
      final fields = <String, String>{};
      if (data is Map) {
        if (data['message'] is String && (data['message'] as String).isNotEmpty) msg = data['message'];
        final errs = data['errors'] ?? data['data'];
        if (errs is Map) {
          errs.forEach((k, v) => fields['$k'] = '$v');
        }
      }
      return ApiError(msg, status: res.statusCode, fields: fields);
    }
    return ApiError(e.toString());
  }
}

typedef Res<T> = Either<ApiError, T>;

/// Thin JSON client for the app API (`/v1/app/`). Responses are wrapped in
/// `{message, data}`; [parse] receives `data`.
@lazySingleton
class MasirApi {
  Dio get _dio => inject<WebService>().dio;

  Future<Res<T>> _run<T>(Future<Response<dynamic>> Function() call, T Function(dynamic data) parse) async {
    try {
      final res = await call();
      final body = res.data;
      final data = body is Map ? body['data'] : body;
      return Right(parse(data));
    } catch (e) {
      return Left(ApiError.from(e));
    }
  }

  Future<Res<T>> get<T>(String path, T Function(dynamic data) parse, {Map<String, dynamic>? query}) =>
      _run(() => _dio.get(path, queryParameters: query), parse);

  Future<Res<T>> post<T>(String path, T Function(dynamic data) parse, {Object? body}) =>
      _run(() => _dio.post(path, data: body ?? {}), parse);

  Future<Res<T>> put<T>(String path, T Function(dynamic data) parse, {Object? body}) =>
      _run(() => _dio.put(path, data: body ?? {}), parse);

  Future<Res<T>> patch<T>(String path, T Function(dynamic data) parse, {Object? body}) =>
      _run(() => _dio.patch(path, data: body ?? {}), parse);

  Future<Res<T>> delete<T>(String path, T Function(dynamic data) parse) =>
      _run(() => _dio.delete(path), parse);
}

/// JSON helpers for models.
typedef J = Map<String, dynamic>;

J asMap(dynamic v) => v is Map ? v.cast<String, dynamic>() : <String, dynamic>{};
List<J> asList(dynamic v) => v is List ? v.map(asMap).toList() : <J>[];
String str(dynamic v) => v?.toString() ?? '';
String? strOrNull(dynamic v) => v == null || '$v'.isEmpty ? null : '$v';
int toInt(dynamic v) => v is int ? v : (v is num ? v.toInt() : int.tryParse('$v') ?? 0);
bool toBool(dynamic v) => v == true;
DateTime? date(dynamic v) => v == null ? null : DateTime.tryParse('$v')?.toLocal();

/// Items of a paginated list (`{items, meta}`) or a bare list.
List<J> items(dynamic data) => data is Map ? asList(data['items']) : asList(data);

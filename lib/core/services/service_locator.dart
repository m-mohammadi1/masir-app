import 'dart:io';

import 'package:easy_helper/easy_helper.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'hive_service.dart';
import 'service_locator.config.dart';

final _getIt = GetIt.instance;

T inject<T extends Object>() => _getIt.call();

@InjectableInit(initializerName: 'initial', preferRelativeImports: true)
Future<void> setup() async => _getIt.initial();

const String _baseUrl = "https://api.getmasir.com/v1/app/";

bool _haveFormData = false;

Map<String, dynamic> _header(bool haveFormData) => {
  HttpHeaders.contentTypeHeader: haveFormData
      ? 'multipart/form-data'
      : 'application/json',
  HttpHeaders.acceptHeader: 'application/json',
  if (HiveService.token != null)
    HttpHeaders.authorizationHeader: 'Bearer ${HiveService.token}',
};

void updateHeader() {
  inject<WebService>().initial(
    baseUrl: _baseUrl,
    header: _header(_haveFormData),
  );
}

void updateFormDataHeader(bool isHave) {
  _haveFormData = isHave;
  inject<WebService>().initial(
    baseUrl: _baseUrl,
    header: _header(_haveFormData),
  );
}

@module
abstract class AppModule {
  @Singleton(signalsReady: true, order: 0)
  @preResolve
  Future<WebService> get webService => Future.value(
    WebService()..initial(
      baseUrl: _baseUrl,
      header: _header(_haveFormData),
      refreshToken: () async {
        final Dio dio = Dio(BaseOptions(baseUrl: _baseUrl))
          ..interceptors.add(
            LogInterceptor(requestBody: true, responseBody: true),
          );
        try {
          if (HiveService.token == null) {
            return RefreshTokenResult(
              status: false,
              token: HiveService.token ?? '',
              refreshToken: HiveService.refreshToken ?? '',
            );
          } else if (HiveService.refreshToken != null) {
            HiveService.token = HiveService.refreshToken;
            final response = await dio.post(
              'auth/refresh',
              options: Options(headers: _header(false)),
            );
            if (GEasyHelper.check(response.statusCode)) {
              HiveService.token = response.data['data']['access_token'];
              HiveService.refreshToken = response.data['data']['refresh_token'];
              return RefreshTokenResult(
                status: true,
                token: HiveService.token ?? '',
                refreshToken: HiveService.refreshToken ?? '',
                header: _header(_haveFormData),
              );
            } else {
              return RefreshTokenResult(
                status: false,
                token: HiveService.token ?? '',
                refreshToken: HiveService.refreshToken ?? '',
                message: response.data,
              );
            }
          } else {
            return RefreshTokenResult(
              status: false,
              token: '',
              refreshToken: '',
            );
          }
        } on Exception catch (e) {
          HiveService.logout();
          // CustomNavigator.pushNamedAndRemoveUntil(WelcomePage.routeName);

          return RefreshTokenResult(
            status: false,
            token: HiveService.token ?? '',
            refreshToken: HiveService.refreshToken ?? '',
            message: e.toString(),
          );
        }
      },
    ),
  );

  @Singleton(signalsReady: true, order: 1)
  @preResolve
  Future<IRestfulApi> get restfulApi =>
      Future.value(DioRestfulApi(webService: inject()));

  @Named('Http')
  @Singleton(signalsReady: true, order: 1)
  @preResolve
  Future<IRestfulApi> get httpRestfulApi =>
      Future.value(DioRestfulApi(webService: inject()));
}

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:easy_helper/easy_helper.dart' as _i669;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/about_us/data/datasource/about_us_remote_data_source.dart'
    as _i670;
import '../../features/about_us/data/repository/about_us_repository_impl.dart'
    as _i821;
import '../../features/about_us/domain/repository/about_us_repository.dart'
    as _i511;
import '../../features/about_us/domain/usecases/about_us_usecase.dart' as _i280;
import '../../features/about_us/presentation/bloc/about_us_bloc.dart' as _i240;
import '../../features/auth/data/datasource/auth_remote_data_source.dart'
    as _i24;
import '../../features/auth/data/repository/auth_repository_impl.dart' as _i409;
import '../../features/auth/domain/repository/auth_repository.dart' as _i961;
import '../../features/auth/domain/usecases/auth_usecase.dart' as _i436;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/edit_profile/data/datasource/edit_profile_remote_data_source.dart'
    as _i687;
import '../../features/edit_profile/data/repository/edit_profile_repository_impl.dart'
    as _i859;
import '../../features/edit_profile/domain/repository/edit_profile_repository.dart'
    as _i119;
import '../../features/edit_profile/domain/usecases/edit_profile_usecase.dart'
    as _i894;
import '../../features/edit_profile/presentation/bloc/edit_profile_bloc.dart'
    as _i84;
import '../../features/otp/data/datasource/otp_remote_data_source.dart'
    as _i476;
import '../../features/otp/data/repository/otp_repository_impl.dart' as _i653;
import '../../features/otp/domain/repository/otp_repository.dart' as _i929;
import '../../features/otp/domain/usecases/otp_usecase.dart' as _i635;
import '../../features/otp/presentation/bloc/otp_bloc.dart' as _i1015;
import '../../features/otp/presentation/bloc/otp_form/otp_form_bloc.dart'
    as _i1022;
import '../../features/quiz/data/datasource/quiz_remote_data_source.dart'
    as _i425;
import '../../features/quiz/data/repository/quiz_repository_impl.dart' as _i625;
import '../../features/quiz/domain/repository/quiz_repository.dart' as _i488;
import '../../features/quiz/domain/usecases/quiz_usecase.dart' as _i177;
import '../../features/quiz/presentation/bloc/quiz_bloc.dart' as _i505;
import '../../features/register/data/datasource/register_remote_data_source.dart'
    as _i1026;
import '../../features/register/data/repository/register_repository_impl.dart'
    as _i554;
import '../../features/register/domain/repository/register_repository.dart'
    as _i240;
import '../../features/register/domain/usecases/register_usecase.dart' as _i73;
import '../../features/register/presentation/bloc/register_bloc.dart' as _i771;
import 'service_locator.dart' as _i105;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initial({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i1022.OtpFormBloc>(() => _i1022.OtpFormBloc());
    await gh.singletonAsync<_i669.WebService>(
      () => appModule.webService,
      signalsReady: true,
      preResolve: true,
    );
    gh.factory<_i24.AuthRemoteDataSource>(
      () => _i24.AuthRemoteDataSourceImpl(restfulApi: gh<_i669.IRestfulApi>()),
    );
    gh.factory<_i476.OtpRemoteDataSource>(
      () => _i476.OtpRemoteDataSourceImpl(restfulApi: gh<_i669.IRestfulApi>()),
    );
    gh.factory<_i425.QuizRemoteDataSource>(
      () => _i425.QuizRemoteDataSourceImpl(restfulApi: gh<_i669.IRestfulApi>()),
    );
    gh.factory<_i687.EditProfileRemoteDataSource>(
      () => _i687.EditProfileRemoteDataSourceImpl(
        restfulApi: gh<_i669.IRestfulApi>(),
      ),
    );
    gh.factory<_i1026.RegisterRemoteDataSource>(
      () => _i1026.RegisterRemoteDataSourceImpl(
        restfulApi: gh<_i669.IRestfulApi>(),
      ),
    );
    gh.factory<_i240.RegisterRepository>(
      () => _i554.RegisterRepositoryImpl(
        remoteDataSource: gh<_i1026.RegisterRemoteDataSource>(),
      ),
    );
    gh.factory<_i488.QuizRepository>(
      () => _i625.QuizRepositoryImpl(
        remoteDataSource: gh<_i425.QuizRemoteDataSource>(),
      ),
    );
    gh.factory<_i670.AboutUsRemoteDataSource>(
      () => _i670.AboutUsRemoteDataSourceImpl(
        restfulApi: gh<_i669.IRestfulApi>(),
      ),
    );
    gh.factory<_i929.OtpRepository>(
      () => _i653.OtpRepositoryImpl(
        remoteDataSource: gh<_i476.OtpRemoteDataSource>(),
      ),
    );
    gh.factory<_i73.RegisterUseCase>(
      () => _i73.RegisterUseCase(repository: gh<_i240.RegisterRepository>()),
    );
    gh.factory<_i511.AboutUsRepository>(
      () => _i821.AboutUsRepositoryImpl(
        remoteDataSource: gh<_i670.AboutUsRemoteDataSource>(),
      ),
    );
    gh.factory<_i119.EditProfileRepository>(
      () => _i859.EditProfileRepositoryImpl(
        remoteDataSource: gh<_i687.EditProfileRemoteDataSource>(),
      ),
    );
    gh.factory<_i961.AuthRepository>(
      () => _i409.AuthRepositoryImpl(
        remoteDataSource: gh<_i24.AuthRemoteDataSource>(),
      ),
    );
    gh.factory<_i436.AuthUseCase>(
      () => _i436.AuthUseCase(repository: gh<_i961.AuthRepository>()),
    );
    gh.factory<_i177.QuizUseCase>(
      () => _i177.QuizUseCase(repository: gh<_i488.QuizRepository>()),
    );
    gh.factory<_i771.RegisterBloc>(
      () => _i771.RegisterBloc(registerUseCase: gh<_i73.RegisterUseCase>()),
    );
    gh.factory<_i280.AboutUsUseCase>(
      () => _i280.AboutUsUseCase(repository: gh<_i511.AboutUsRepository>()),
    );
    gh.factory<_i635.OtpUseCase>(
      () => _i635.OtpUseCase(repository: gh<_i929.OtpRepository>()),
    );
    gh.factory<_i240.AboutUsBloc>(
      () => _i240.AboutUsBloc(aboutUsUseCase: gh<_i280.AboutUsUseCase>()),
    );
    gh.factory<_i894.EditProfileUseCase>(
      () => _i894.EditProfileUseCase(
        repository: gh<_i119.EditProfileRepository>(),
      ),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(authUseCase: gh<_i436.AuthUseCase>()),
    );
    gh.singleton<_i505.QuizBloc>(
      () => _i505.QuizBloc(quizUseCase: gh<_i177.QuizUseCase>()),
    );
    gh.factory<_i1015.OtpBloc>(
      () => _i1015.OtpBloc(otpUseCase: gh<_i635.OtpUseCase>()),
    );
    gh.factory<_i84.EditProfileBloc>(
      () => _i84.EditProfileBloc(
        editProfileUseCase: gh<_i894.EditProfileUseCase>(),
      ),
    );
    await gh.singletonAsync<_i669.IRestfulApi>(
      () => appModule.restfulApi,
      signalsReady: true,
      preResolve: true,
    );
    await gh.singletonAsync<_i669.IRestfulApi>(
      () => appModule.httpRestfulApi,
      instanceName: 'Http',
      signalsReady: true,
      preResolve: true,
    );
    return this;
  }
}

class _$AppModule extends _i105.AppModule {}

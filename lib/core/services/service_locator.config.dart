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
import '../../features/auth/domain/usecases/login_usecase.dart' as _i188;
import '../../features/auth/domain/usecases/submit_register_usecase.dart'
    as _i804;
import '../../features/auth/domain/usecases/submit_username_usecase.dart'
    as _i672;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/auth/presentation/bloc/login/login_bloc.dart' as _i208;
import '../../features/auth/presentation/bloc/submit_register/submit_register_bloc.dart'
    as _i369;
import '../../features/auth/presentation/bloc/submit_username/submit_username_bloc.dart'
    as _i386;
import '../../features/edit_profile/data/datasource/edit_profile_remote_data_source.dart'
    as _i687;
import '../../features/edit_profile/data/repository/edit_profile_repository_impl.dart'
    as _i859;
import '../../features/edit_profile/domain/repository/edit_profile_repository.dart'
    as _i119;
import '../../features/edit_profile/domain/usecases/edit_password_usecase.dart'
    as _i190;
import '../../features/edit_profile/domain/usecases/edit_profile_usecase.dart'
    as _i894;
import '../../features/edit_profile/presentation/bloc/edit_password/edit_password_bloc.dart'
    as _i258;
import '../../features/edit_profile/presentation/bloc/edit_profile_bloc.dart'
    as _i84;
import '../../features/institute/data/datasource/institute_remote_data_source.dart'
    as _i435;
import '../../features/institute/data/repository/institute_repository_impl.dart'
    as _i278;
import '../../features/institute/domain/repository/institute_repository.dart'
    as _i768;
import '../../features/institute/domain/usecases/enter_institute.dart' as _i733;
import '../../features/institute/domain/usecases/get_announcement.dart'
    as _i212;
import '../../features/institute/domain/usecases/get_announcements.dart'
    as _i96;
import '../../features/institute/domain/usecases/get_institute_detail.dart'
    as _i461;
import '../../features/institute/domain/usecases/get_notifications.dart'
    as _i903;
import '../../features/institute/domain/usecases/get_wallet.dart' as _i150;
import '../../features/institute/domain/usecases/join_institute.dart' as _i611;
import '../../features/institute/domain/usecases/mark_notification_read.dart'
    as _i917;
import '../../features/institute/presentation/bloc/announcement_detail/announcement_detail_bloc.dart'
    as _i235;
import '../../features/institute/presentation/bloc/announcements/announcements_bloc.dart'
    as _i920;
import '../../features/institute/presentation/bloc/institute_detail/institute_detail_bloc.dart'
    as _i723;
import '../../features/institute/presentation/bloc/join_institute/join_institute_bloc.dart'
    as _i993;
import '../../features/institute/presentation/bloc/notifications/notifications_bloc.dart'
    as _i281;
import '../../features/institute/presentation/bloc/wallet/wallet_bloc.dart'
    as _i376;
import '../../features/main/data/datasource/main_remote_data_source.dart'
    as _i551;
import '../../features/main/data/repository/main_repository_impl.dart'
    as _i1026;
import '../../features/main/domain/repository/main_repository.dart' as _i1055;
import '../../features/main/domain/usecases/course_detail_usecase.dart'
    as _i380;
import '../../features/main/domain/usecases/courses_usecase.dart' as _i617;
import '../../features/main/domain/usecases/institutes_usecase.dart' as _i80;
import '../../features/main/domain/usecases/main_usecase.dart' as _i47;
import '../../features/main/domain/usecases/my_subscriptions_usecase.dart'
    as _i671;
import '../../features/main/domain/usecases/outline_course_usecase.dart'
    as _i578;
import '../../features/main/domain/usecases/quiz_submit_usecase.dart' as _i714;
import '../../features/main/domain/usecases/subscribe_course_usecase.dart'
    as _i497;
import '../../features/main/domain/usecases/units_usecase.dart' as _i435;
import '../../features/main/presentation/bloc/course_detail/course_detail_bloc.dart'
    as _i635;
import '../../features/main/presentation/bloc/courses/courses_bloc.dart'
    as _i953;
import '../../features/main/presentation/bloc/institutes/institutes_bloc.dart'
    as _i1061;
import '../../features/main/presentation/bloc/main_bloc.dart' as _i1014;
import '../../features/main/presentation/bloc/my_subscriptions/my_subscriptions_bloc.dart'
    as _i1032;
import '../../features/main/presentation/bloc/outline_course/outline_course_bloc.dart'
    as _i448;
import '../../features/main/presentation/bloc/quiz_submit/quiz_submit_bloc.dart'
    as _i842;
import '../../features/main/presentation/bloc/subscribe_course/subscribe_course_bloc.dart'
    as _i519;
import '../../features/main/presentation/bloc/units/units_bloc.dart' as _i85;
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
import '../../features/teacher/data/datasource/teacher_remote_data_source.dart'
    as _i531;
import '../../features/teacher/data/repository/teacher_repository_impl.dart'
    as _i274;
import '../../features/teacher/domain/repository/teacher_repository.dart'
    as _i717;
import '../../features/teacher/domain/usecases/get_institute_teachers.dart'
    as _i289;
import '../../features/teacher/domain/usecases/get_teacher.dart' as _i969;
import '../../features/teacher/presentation/bloc/institute_teachers/institute_teachers_bloc.dart'
    as _i224;
import '../../features/teacher/presentation/bloc/teacher_detail/teacher_detail_bloc.dart'
    as _i773;
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
      () => appModule.webService(),
      signalsReady: true,
      preResolve: true,
    );
    gh.factory<_i435.InstituteRemoteDataSource>(
      () => _i435.InstituteRemoteDataSourceImpl(
        restfulApi: gh<_i669.IRestfulApi>(),
      ),
    );
    gh.factory<_i24.AuthRemoteDataSource>(
      () => _i24.AuthRemoteDataSourceImpl(restfulApi: gh<_i669.IRestfulApi>()),
    );
    gh.factory<_i551.MainRemoteDataSource>(
      () => _i551.MainRemoteDataSourceImpl(restfulApi: gh<_i669.IRestfulApi>()),
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
    gh.factory<_i531.TeacherRemoteDataSource>(
      () => _i531.TeacherRemoteDataSourceImpl(
        restfulApi: gh<_i669.IRestfulApi>(),
      ),
    );
    gh.factory<_i670.AboutUsRemoteDataSource>(
      () => _i670.AboutUsRemoteDataSourceImpl(
        restfulApi: gh<_i669.IRestfulApi>(),
      ),
    );
    gh.factory<_i1055.MainRepository>(
      () => _i1026.MainRepositoryImpl(
        remoteDataSource: gh<_i551.MainRemoteDataSource>(),
      ),
    );
    gh.factory<_i717.TeacherRepository>(
      () => _i274.TeacherRepositoryImpl(
        remoteDataSource: gh<_i531.TeacherRemoteDataSource>(),
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
    gh.factory<_i768.InstituteRepository>(
      () => _i278.InstituteRepositoryImpl(
        remoteDataSource: gh<_i435.InstituteRemoteDataSource>(),
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
    gh.factory<_i289.GetInstituteTeachersUseCase>(
      () => _i289.GetInstituteTeachersUseCase(
        repository: gh<_i717.TeacherRepository>(),
      ),
    );
    gh.factory<_i969.GetTeacherUseCase>(
      () => _i969.GetTeacherUseCase(repository: gh<_i717.TeacherRepository>()),
    );
    gh.factory<_i436.AuthUseCase>(
      () => _i436.AuthUseCase(repository: gh<_i961.AuthRepository>()),
    );
    gh.factory<_i188.LoginUseCase>(
      () => _i188.LoginUseCase(repository: gh<_i961.AuthRepository>()),
    );
    gh.factory<_i804.SubmitRegisterUseCase>(
      () => _i804.SubmitRegisterUseCase(repository: gh<_i961.AuthRepository>()),
    );
    gh.factory<_i672.SubmitUsernameUseCase>(
      () => _i672.SubmitUsernameUseCase(repository: gh<_i961.AuthRepository>()),
    );
    gh.factory<_i177.QuizUseCase>(
      () => _i177.QuizUseCase(repository: gh<_i488.QuizRepository>()),
    );
    gh.factory<_i380.CourseDetailUseCase>(
      () => _i380.CourseDetailUseCase(repository: gh<_i1055.MainRepository>()),
    );
    gh.factory<_i617.CoursesUseCase>(
      () => _i617.CoursesUseCase(repository: gh<_i1055.MainRepository>()),
    );
    gh.factory<_i80.InstitutesUseCase>(
      () => _i80.InstitutesUseCase(repository: gh<_i1055.MainRepository>()),
    );
    gh.factory<_i47.MainUseCase>(
      () => _i47.MainUseCase(repository: gh<_i1055.MainRepository>()),
    );
    gh.factory<_i671.MySubscriptionsUseCase>(
      () =>
          _i671.MySubscriptionsUseCase(repository: gh<_i1055.MainRepository>()),
    );
    gh.factory<_i578.OutlineCourseUseCase>(
      () => _i578.OutlineCourseUseCase(repository: gh<_i1055.MainRepository>()),
    );
    gh.factory<_i714.QuizSubmitUseCase>(
      () => _i714.QuizSubmitUseCase(repository: gh<_i1055.MainRepository>()),
    );
    gh.factory<_i497.SubscribeCourseUseCase>(
      () =>
          _i497.SubscribeCourseUseCase(repository: gh<_i1055.MainRepository>()),
    );
    gh.factory<_i435.UnitsUseCase>(
      () => _i435.UnitsUseCase(repository: gh<_i1055.MainRepository>()),
    );
    gh.factory<_i733.EnterInstituteUseCase>(
      () => _i733.EnterInstituteUseCase(
        repository: gh<_i768.InstituteRepository>(),
      ),
    );
    gh.factory<_i212.GetAnnouncementUseCase>(
      () => _i212.GetAnnouncementUseCase(
        repository: gh<_i768.InstituteRepository>(),
      ),
    );
    gh.factory<_i96.GetAnnouncementsUseCase>(
      () => _i96.GetAnnouncementsUseCase(
        repository: gh<_i768.InstituteRepository>(),
      ),
    );
    gh.factory<_i461.GetInstituteDetailUseCase>(
      () => _i461.GetInstituteDetailUseCase(
        repository: gh<_i768.InstituteRepository>(),
      ),
    );
    gh.factory<_i903.GetNotificationsUseCase>(
      () => _i903.GetNotificationsUseCase(
        repository: gh<_i768.InstituteRepository>(),
      ),
    );
    gh.factory<_i150.GetWalletUseCase>(
      () => _i150.GetWalletUseCase(repository: gh<_i768.InstituteRepository>()),
    );
    gh.factory<_i611.JoinInstituteUseCase>(
      () => _i611.JoinInstituteUseCase(
        repository: gh<_i768.InstituteRepository>(),
      ),
    );
    gh.factory<_i917.MarkNotificationReadUseCase>(
      () => _i917.MarkNotificationReadUseCase(
        repository: gh<_i768.InstituteRepository>(),
      ),
    );
    gh.factory<_i771.RegisterBloc>(
      () => _i771.RegisterBloc(registerUseCase: gh<_i73.RegisterUseCase>()),
    );
    gh.factory<_i1061.InstitutesBloc>(
      () => _i1061.InstitutesBloc(
        institutesUseCase: gh<_i80.InstitutesUseCase>(),
      ),
    );
    gh.factory<_i280.AboutUsUseCase>(
      () => _i280.AboutUsUseCase(repository: gh<_i511.AboutUsRepository>()),
    );
    gh.factory<_i448.OutlineCourseBloc>(
      () => _i448.OutlineCourseBloc(
        outlineCourseUseCase: gh<_i578.OutlineCourseUseCase>(),
      ),
    );
    gh.factory<_i376.WalletBloc>(
      () => _i376.WalletBloc(getWalletUseCase: gh<_i150.GetWalletUseCase>()),
    );
    gh.factory<_i224.InstituteTeachersBloc>(
      () => _i224.InstituteTeachersBloc(
        getInstituteTeachersUseCase: gh<_i289.GetInstituteTeachersUseCase>(),
      ),
    );
    gh.factory<_i240.AboutUsBloc>(
      () => _i240.AboutUsBloc(aboutUsUseCase: gh<_i280.AboutUsUseCase>()),
    );
    gh.factory<_i773.TeacherDetailBloc>(
      () => _i773.TeacherDetailBloc(
        getTeacherUseCase: gh<_i969.GetTeacherUseCase>(),
      ),
    );
    gh.factory<_i993.JoinInstituteBloc>(
      () => _i993.JoinInstituteBloc(
        joinInstituteUseCase: gh<_i611.JoinInstituteUseCase>(),
      ),
    );
    gh.factory<_i519.SubscribeCourseBloc>(
      () => _i519.SubscribeCourseBloc(
        subscribeCourseUseCase: gh<_i497.SubscribeCourseUseCase>(),
      ),
    );
    gh.factory<_i842.QuizSubmitBloc>(
      () => _i842.QuizSubmitBloc(
        quizSubmitUseCase: gh<_i714.QuizSubmitUseCase>(),
      ),
    );
    gh.factory<_i723.InstituteDetailBloc>(
      () => _i723.InstituteDetailBloc(
        getInstituteDetailUseCase: gh<_i461.GetInstituteDetailUseCase>(),
      ),
    );
    gh.factory<_i190.EditPasswordUseCase>(
      () => _i190.EditPasswordUseCase(
        repository: gh<_i119.EditProfileRepository>(),
      ),
    );
    gh.factory<_i894.EditProfileUseCase>(
      () => _i894.EditProfileUseCase(
        repository: gh<_i119.EditProfileRepository>(),
      ),
    );
    gh.factory<_i953.CoursesBloc>(
      () => _i953.CoursesBloc(coursesUseCase: gh<_i617.CoursesUseCase>()),
    );
    gh.factory<_i281.NotificationsBloc>(
      () => _i281.NotificationsBloc(
        getNotificationsUseCase: gh<_i903.GetNotificationsUseCase>(),
        markNotificationReadUseCase: gh<_i917.MarkNotificationReadUseCase>(),
      ),
    );
    gh.factory<_i386.SubmitUsernameBloc>(
      () => _i386.SubmitUsernameBloc(
        submitUsernameUseCase: gh<_i672.SubmitUsernameUseCase>(),
      ),
    );
    gh.factory<_i85.UnitsBloc>(
      () => _i85.UnitsBloc(unitsUseCase: gh<_i435.UnitsUseCase>()),
    );
    gh.factory<_i369.SubmitRegisterBloc>(
      () => _i369.SubmitRegisterBloc(
        submitRegisterUseCase: gh<_i804.SubmitRegisterUseCase>(),
      ),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(authUseCase: gh<_i436.AuthUseCase>()),
    );
    gh.factory<_i635.CourseDetailBloc>(
      () => _i635.CourseDetailBloc(
        courseDetailUseCase: gh<_i380.CourseDetailUseCase>(),
      ),
    );
    gh.factory<_i235.AnnouncementDetailBloc>(
      () => _i235.AnnouncementDetailBloc(
        getAnnouncementUseCase: gh<_i212.GetAnnouncementUseCase>(),
        markNotificationReadUseCase: gh<_i917.MarkNotificationReadUseCase>(),
      ),
    );
    gh.factory<_i258.EditPasswordBloc>(
      () => _i258.EditPasswordBloc(
        editPasswordUseCase: gh<_i190.EditPasswordUseCase>(),
      ),
    );
    gh.factory<_i208.LoginBloc>(
      () => _i208.LoginBloc(loginUseCase: gh<_i188.LoginUseCase>()),
    );
    gh.factory<_i1014.MainBloc>(
      () => _i1014.MainBloc(mainUseCase: gh<_i47.MainUseCase>()),
    );
    gh.factory<_i505.QuizBloc>(
      () => _i505.QuizBloc(quizUseCase: gh<_i177.QuizUseCase>()),
    );
    gh.factory<_i920.AnnouncementsBloc>(
      () => _i920.AnnouncementsBloc(
        getAnnouncementsUseCase: gh<_i96.GetAnnouncementsUseCase>(),
      ),
    );
    gh.factory<_i1032.MySubscriptionsBloc>(
      () => _i1032.MySubscriptionsBloc(
        mySubscriptionsUseCase: gh<_i671.MySubscriptionsUseCase>(),
      ),
    );
    gh.factory<_i84.EditProfileBloc>(
      () => _i84.EditProfileBloc(
        editProfileUseCase: gh<_i894.EditProfileUseCase>(),
      ),
    );
    gh.singleton<_i669.IRestfulApi>(
      () => appModule.restfulApi(gh<_i669.WebService>()),
    );
    return this;
  }
}

class _$AppModule extends _i105.AppModule {}

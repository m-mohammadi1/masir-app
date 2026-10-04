import 'package:flutter/material.dart';
import '/not_found_page.dart';
import 'package:go_router/go_router.dart';
import '/core/helper/route_args.dart';
import '/splash_screen.dart';
import 'package:easy_helper/easy_helper.dart';
import 'features/about_us/presentation/page/about_us_page.dart';
import 'features/auth/presentation/page/auth_screen.dart';
import 'features/edit_profile/presentation/page/edit_profile_page.dart';
import 'features/home/page/detail_course_page.dart';
import 'features/intro/presentation/page/intro_screen.dart';
import 'features/institute/presentation/page/announcement_detail_page.dart';
import 'features/institute/presentation/page/institute_announcements_page.dart';
import 'features/institute/presentation/page/institute_courses_page.dart';
import 'features/institute/presentation/page/institute_home_page.dart';
import 'features/institute/presentation/page/institute_inbox_page.dart';
import 'features/institute/presentation/page/institute_me_page.dart';
import 'features/teacher/presentation/page/institute_teachers_page.dart';
import 'features/teacher/presentation/page/teacher_page.dart';
import 'features/institute/presentation/shell/institute_shell.dart';
import 'features/institute/presentation/transitions/threshold_page.dart';
import 'features/main/presentation/page/institutes_page.dart';
import 'features/main/presentation/page/main_page.dart';
import 'features/main/presentation/page/outline_page.dart';
import 'features/otp/presentation/page/otp_screen.dart';
import 'features/quiz/presentation/page/unit_page.dart';
import 'features/register/presentation/page/register_page.dart';

const String initialRoute = SplashScreen.routeName;

String currentRoute = initialRoute;

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: CustomNavigator.navigatorKey,
  initialLocation: initialRoute,
  observers: [LifecycleNavigatorHandler()],
  routes: [
    GoRoute(
      path: SplashScreen.routeName,
      builder: (context, state) {
        return SplashScreen();
      },
    ),
    GoRoute(
      path: IntroScreen.routeName,
      builder: (context, state) {
        return IntroScreen();
      },
    ),
    GoRoute(
      path: AuthScreen.routeName,
      builder: (context, state) => AuthScreen(),
    ),
    GoRoute(
      path: OtpScreen.routeName,
      builder: (context, state) {
        return OtpScreen(
          phoneNumber: (state.extra as Map<String, String>)['phoneNumber']!,
          inviteCode: (state.extra as Map<String, String>)['inviteCode']!,
        );
      },
    ),

    GoRoute(
      path: RegisterPage.routeName,
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: MainPage.routeName,
      builder: (context, state) => MainPage(),
      routes: [
        GoRoute(
          path: InstitutesPage.routeName,
          builder: (context, state) => InstitutesPage(),
        ),
        GoRoute(
          path: DetailCoursePage.routeName,
          builder: (context, state) {
            final extra = state.extra;
            if (extra is Map) {
              return DetailCoursePage(
                id: extra['id'] as String,
                themePreset: extra[kThemePresetArg] as String?,
              );
            }
            return DetailCoursePage(id: extra as String);
          },
        ),
        GoRoute(
          path: OutlinePage.routeName,
          builder: (context, state) {
            final extra = state.extra as Map<String, String>;
            return OutlinePage(
              id: extra['id']!,
              title: extra['title']!,
              moduleId: extra['moduleId'],
              themePreset: extra[kThemePresetArg],
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: UnitPage.routeName,
      // Opening a node feels like zooming into it, and closing it zooms back
      // out to the roadmap.
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, String>?;
        return CustomTransitionPage<Object?>(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 420),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          child: UnitPage(
            unitId: extra?['id'] ?? '',
            unitType: extra?['type'] ?? '',
            unitTitle: extra?['title'] ?? '',
            status: extra?['status'] ?? '',
            themePreset: extra?[kThemePresetArg],
          ),
          transitionsBuilder: (context, animation, secondary, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.06),
                  end: Offset.zero,
                ).animate(curved),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.94, end: 1).animate(curved),
                  child: child,
                ),
              ),
            );
          },
        );
      },
    ),
    GoRoute(
      path: EditProfilePage.routeName,
      builder: (context, state) => EditProfilePage(),
    ),
    GoRoute(
      path: AboutUsPage.routeName,
      builder: (context, state) => AboutUsPage(),
    ),
    GoRoute(
      path: '/teachers/:userId',
      builder: (context, state) => const TeacherPage(),
    ),
    ShellRoute(
      pageBuilder: (context, state, child) {
        return thresholdPage(
          context,
          state,
          InstituteShell(
            instituteId: state.pathParameters['instituteId'] ?? '',
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/i/:instituteId/home',
          builder: (context, state) => const InstituteHomePage(),
        ),
        GoRoute(
          path: '/i/:instituteId/courses',
          builder: (context, state) => const InstituteCoursesPage(),
        ),
        GoRoute(
          path: '/i/:instituteId/teachers',
          builder: (context, state) => const InstituteTeachersPage(),
        ),
        GoRoute(
          path: '/i/:instituteId/me',
          builder: (context, state) => const InstituteMePage(),
        ),
        GoRoute(
          path: '/i/:instituteId/announcements',
          builder: (context, state) => InstituteAnnouncementsPage(
            instituteId: state.pathParameters['instituteId'] ?? '',
          ),
        ),
        GoRoute(
          path: '/i/:instituteId/announcements/:announcementId',
          builder: (context, state) => AnnouncementDetailPage(
            instituteId: state.pathParameters['instituteId'] ?? '',
            announcementId: state.pathParameters['announcementId'] ?? '',
          ),
        ),
        GoRoute(
          path: '/i/:instituteId/inbox',
          builder: (context, state) => InstituteInboxPage(
            instituteId: state.pathParameters['instituteId'] ?? '',
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const NotFoundPage(),
  redirect: (context, state) {
    //   if (state.matchedLocation.contains("/protected")) {
    //     if (authService.state.status) {
    //       return state.path;
    //     } else {
    //       return AuthPage.routeName;
    //     }
    //   }
    //
    //   return null;
  },
);

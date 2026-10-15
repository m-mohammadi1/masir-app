import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/app/masir/masir_shell.dart';
import '/app/masir/vitrine_page.dart';
import '/app/onboarding/intro_page.dart';
import '/app/onboarding/login_page.dart';
import '/app/onboarding/register_page.dart';
import '/app/onboarding/splash_page.dart';
import '/app/onboarding/welcome_page.dart';
import '/app/routes.dart';
import '/app/screens.dart';
import '/app/state/nav.dart';
import '/core/services/hive_service.dart';
import '/design/design.dart';

final rootKey = GlobalKey<NavigatorState>();

const _public = {Routes.splash, Routes.intro, Routes.register, Routes.login};

/// Tabs switch without a slide.
Page<void> _tab(GoRouterState s, Widget child) => NoTransitionPage(key: s.pageKey, child: child);

final GoRouter appRouter = GoRouter(
  navigatorKey: rootKey,
  initialLocation: Routes.splash,
  debugLogDiagnostics: kDebugMode,
  redirect: (context, state) {
    final path = state.uri.path;
    if (!HiveService.isLogged && !_public.contains(path)) return Routes.intro;
    if (path == '/' ) return HiveService.isLogged ? Routes.vitrine : Routes.intro;
    return null;
  },
  routes: [
    GoRoute(path: '/', redirect: (_, _) => Routes.splash),
    GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
    GoRoute(path: Routes.intro, builder: (_, _) => const IntroPage()),
    GoRoute(path: Routes.register, builder: (_, _) => const RegisterPage()),
    GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),
    GoRoute(
      path: Routes.welcome,
      builder: (_, state) {
        final x = extraOf(state);
        return WelcomePage(
          instituteId: '${x['institute_id'] ?? ''}',
          brand: x['brand'] is Brand ? x['brand'] as Brand : null,
          name: '${x['name'] ?? ''}',
        );
      },
    ),

    // Masir space: three tabs that keep their own stacks.
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => MasirShell(shell: shell),
      branches: [
        StatefulShellBranch(routes: [GoRoute(path: Routes.vitrine, builder: (_, _) => const VitrinePage())]),
        StatefulShellBranch(routes: [GoRoute(path: Routes.myInstitutes, builder: (_, _) => const MyInstitutesPage())]),
        StatefulShellBranch(routes: [GoRoute(path: Routes.profile, builder: (_, _) => const ProfilePage())]),
      ],
    ),
    GoRoute(path: Routes.explore, builder: (_, state) => ExplorePage(topic: '${extraOf(state)['topic'] ?? ''}')),
    GoRoute(path: Routes.inbox, builder: (_, _) => const InboxPage()),
    GoRoute(path: Routes.subscriptions, builder: (_, _) => const SubscriptionsPage()),

    // Institute space.
    GoRoute(
      path: '/enter/:id',
      pageBuilder: (context, state) => thresholdPage(state, state.pathParameters['id']!),
    ),
    // One institute shell at a time; entering another institute replaces it.
    ShellRoute(
      builder: (context, state, child) => InstituteShell(
        key: ValueKey('inst-${state.pathParameters['id']}'),
        instituteId: state.pathParameters['id']!,
        location: state.uri.path,
        child: child,
      ),
      routes: [
        GoRoute(path: '/i/:id/home', pageBuilder: (_, s) => _tab(s, InstituteHomePage(instituteId: s.pathParameters['id']!))),
        GoRoute(path: '/i/:id/courses', pageBuilder: (_, s) => _tab(s, InstituteCoursesPage(instituteId: s.pathParameters['id']!))),
        GoRoute(path: '/i/:id/teachers', pageBuilder: (_, s) => _tab(s, InstituteTeachersPage(instituteId: s.pathParameters['id']!))),
        GoRoute(path: '/i/:id/me', pageBuilder: (_, s) => _tab(s, InstituteMePage(instituteId: s.pathParameters['id']!))),
      ],
    ),
    GoRoute(
      path: '/i/:id/announcements',
      builder: (_, s) => AnnouncementsPage(instituteId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/i/:id/announcements/:aid',
      builder: (_, s) => AnnouncementDetailPage(instituteId: s.pathParameters['id']!, announcementId: s.pathParameters['aid']!),
    ),
    GoRoute(path: '/teachers/:userId', builder: (_, s) => TeacherPageView(userId: s.pathParameters['userId']!)),

    // Detail layer: keeps the colour of the space it was opened from.
    GoRoute(path: '/course/:id', builder: (_, s) => CourseDetailPage(courseId: s.pathParameters['id']!)),
    GoRoute(path: '/course/:id/roadmap', builder: (_, s) => RoadmapPage(courseId: s.pathParameters['id']!)),
    GoRoute(
      path: '/unit/:id',
      pageBuilder: (context, s) => unitPage(s, s.pathParameters['id']!),
    ),
    GoRoute(path: '/unit/:id/review', builder: (_, s) => QuizReviewPage(unitId: s.pathParameters['id']!)),
    GoRoute(
      path: Routes.payment,
      builder: (_, s) => PaymentResultPage(paymentId: s.uri.queryParameters['payment_id'] ?? ''),
    ),
  ],
  errorBuilder: (context, state) => const NotFoundView(),
);

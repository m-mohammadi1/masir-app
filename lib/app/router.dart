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
import '/app/state/route_settle.dart';
import '/core/services/hive_service.dart';
import '/design/design.dart';

final rootKey = GlobalKey<NavigatorState>();

const _public = {Routes.splash, Routes.intro, Routes.register, Routes.login};

/// Institute tabs are peers: the new tab fades in (motion.md §4).
Page<void> _tab(GoRouterState s, Widget child) =>
    masirFadeThroughPage(s, child, duration: MasirMotion.short);

final GoRouter appRouter = GoRouter(
  navigatorKey: rootKey,
  observers: [RouteMotion.instance],
  initialLocation: Routes.splash,
  debugLogDiagnostics: kDebugMode,
  redirect: (context, state) {
    final path = state.uri.path;
    if (!HiveService.isLogged && !_public.contains(path)) return Routes.intro;
    if (path == '/') {
      return HiveService.isLogged ? Routes.vitrine : Routes.intro;
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', redirect: (_, _) => Routes.splash),
    GoRoute(
      path: Routes.splash,
      pageBuilder: (_, s) => masirFadeThroughPage(s, const SplashPage()),
    ),
    GoRoute(
      path: Routes.intro,
      pageBuilder: (_, s) => masirFadeThroughPage(s, const IntroPage()),
    ),
    GoRoute(
      path: Routes.register,
      pageBuilder: (_, s) => masirPage(s, const RegisterPage()),
    ),
    GoRoute(
      path: Routes.login,
      pageBuilder: (_, s) => masirPage(s, const LoginPage()),
    ),
    GoRoute(
      path: Routes.welcome,
      pageBuilder: (_, state) {
        final x = extraOf(state);
        return masirFadeThroughPage(
          state,
          WelcomePage(
            instituteId: '${x['institute_id'] ?? ''}',
            brand: x['brand'] is Brand ? x['brand'] as Brand : null,
            name: '${x['name'] ?? ''}',
          ),
        );
      },
    ),

    // Masir space: three tabs that keep their own stacks.
    StatefulShellRoute(
      pageBuilder: (context, state, shell) =>
          masirFadeThroughPage(state, MasirShell(shell: shell)),
      navigatorContainerBuilder: (context, shell, children) =>
          MasirTabStack(index: shell.currentIndex, children: children),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.vitrine,
              builder: (_, _) => const VitrinePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.myInstitutes,
              builder: (_, _) => const MyInstitutesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.profile,
              builder: (_, _) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: Routes.explore,
      pageBuilder: (_, state) => masirPage(
        state,
        ExplorePage(topic: '${extraOf(state)['topic'] ?? ''}'),
      ),
    ),
    GoRoute(
      path: Routes.inbox,
      pageBuilder: (_, s) => masirPage(s, const InboxPage()),
    ),
    GoRoute(
      path: Routes.subscriptions,
      pageBuilder: (_, s) => masirPage(s, const SubscriptionsPage()),
    ),

    // Institute space.
    GoRoute(
      path: '/enter/:id',
      pageBuilder: (context, state) =>
          thresholdPage(state, state.pathParameters['id']!),
    ),
    // One institute shell at a time; entering another institute replaces it.
    ShellRoute(
      // The threshold covers the switch, so the shell fades in under it.
      pageBuilder: (context, state, child) => masirFadeThroughPage(
        state,
        InstituteShell(
          key: ValueKey('inst-${state.pathParameters['id']}'),
          instituteId: state.pathParameters['id']!,
          location: state.uri.path,
          child: child,
        ),
      ),
      routes: [
        GoRoute(
          path: '/i/:id/home',
          pageBuilder: (_, s) =>
              _tab(s, InstituteHomePage(instituteId: s.pathParameters['id']!)),
        ),
        GoRoute(
          path: '/i/:id/courses',
          pageBuilder: (_, s) => _tab(
            s,
            InstituteCoursesPage(instituteId: s.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/i/:id/teachers',
          pageBuilder: (_, s) => _tab(
            s,
            InstituteTeachersPage(instituteId: s.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: '/i/:id/me',
          pageBuilder: (_, s) =>
              _tab(s, InstituteMePage(instituteId: s.pathParameters['id']!)),
        ),
      ],
    ),
    GoRoute(
      path: '/i/:id/announcements',
      pageBuilder: (_, s) =>
          masirPage(s, AnnouncementsPage(instituteId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/i/:id/announcements/:aid',
      pageBuilder: (_, s) => masirPage(
        s,
        AnnouncementDetailPage(
          instituteId: s.pathParameters['id']!,
          announcementId: s.pathParameters['aid']!,
        ),
      ),
    ),
    GoRoute(
      path: '/teachers/:userId',
      pageBuilder: (_, s) =>
          masirPage(s, TeacherPageView(userId: s.pathParameters['userId']!)),
    ),

    // Detail layer: keeps the colour of the space it was opened from.
    GoRoute(
      path: '/course/:id',
      pageBuilder: (_, s) =>
          masirPage(s, CourseDetailPage(courseId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/course/:id/roadmap',
      pageBuilder: (_, s) =>
          masirPage(s, RoadmapPage(courseId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/unit/:id',
      pageBuilder: (context, s) => unitPage(s, s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/unit/:id/review',
      pageBuilder: (_, s) =>
          masirPage(s, QuizReviewPage(unitId: s.pathParameters['id']!)),
    ),
    GoRoute(
      path: Routes.payment,
      // Back from the bank: a peer screen, not a step forward.
      pageBuilder: (_, s) => masirFadeThroughPage(
        s,
        PaymentResultPage(paymentId: s.uri.queryParameters['payment_id'] ?? ''),
      ),
    ),
  ],
  errorBuilder: (context, state) => const NotFoundView(),
);

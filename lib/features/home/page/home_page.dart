import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/services/hive_service.dart';
import '/core/services/service_locator.dart';
import '/widgets/custom_button.dart';
import '/widgets/custom_text.dart';
import '../../main/data/models/courses_model.dart';
import '../../main/data/models/my_subscriptions_model.dart';
import '../../main/data/models/request_courses_model.dart';
import '../../main/presentation/bloc/courses/courses_bloc.dart';
import '../../main/presentation/bloc/my_institutes/my_institutes_bloc.dart';
import '../../main/presentation/bloc/my_subscriptions/my_subscriptions_bloc.dart';
import '../../main/presentation/page/institutes_page.dart';
import '../../main/presentation/page/outline_page.dart';
import 'detail_course_page.dart';
import '/core/theme/theme_context.dart';
import '/widgets/custom_error.dart';

/// The student's "home" once inside an institute: a header for the current
/// institute plus the courses that institute has published. The institute
/// itself is chosen once (defaults to the one the student registered with)
/// and can only be changed from Profile → "تغییر مؤسسه".
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final myInstitutesBloc = inject<MyInstitutesBloc>();
  final coursesBloc = inject<CoursesBloc>();
  final mySubscriptionsBloc = inject<MySubscriptionsBloc>();
  bool _noInstituteFound = false;

  @override
  void initState() {
    super.initState();
    // Always fetched regardless of which institute is "current" — a
    // student can be subscribed to a course from an institute other than
    // the one selected right now, and we still want that course to show
    // up (marked as already registered) instead of silently vanishing.
    mySubscriptionsBloc.add(MySubscriptionsEvent.mySubscriptions());
    // Also always fetched (not just as a first-time fallback): it's the
    // only place we can resolve an institute's *name* for the "other
    // institute" label on a subscribed course that isn't part of the
    // currently selected institute.
    myInstitutesBloc.add(MyInstitutesEvent.myInstitutes());
    if (HiveService.hasCurrentInstitute) {
      _loadCourses(HiveService.currentInstituteId!);
    }
  }

  void _onReturnedFromInstitutePicker() {
    if (!mounted) return;
    if (HiveService.hasCurrentInstitute) {
      setState(() => _noInstituteFound = false);
      _loadCourses(HiveService.currentInstituteId!);
    } else {
      setState(() {});
    }
  }

  void _loadCourses(String instituteId) {
    coursesBloc.add(
      CoursesEvent.courses(
        params: RequestCoursesModel(instituteId: instituteId),
      ),
    );
  }

  Future<void> _bootstrapFromMyInstitutes(List data) async {
    if (!mounted) return;
    // Now that MyInstitutesBloc is always fetched (also used for the
    // "other institute" name label below), only actually auto-select an
    // institute from it the first time — never override one the student
    // already has selected.
    if (HiveService.hasCurrentInstitute) return;
    if (data.isEmpty) {
      setState(() => _noInstituteFound = true);
      return;
    }
    final institute = data.first;
    final id = institute.id ?? '';
    if (id.isEmpty) return;
    await HiveService.setCurrentInstitute(
      id: id,
      name: institute.name,
      slug: institute.slug,
    );
    if (!mounted) return;
    setState(() {});
    _loadCourses(id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyInstitutesBloc, MyInstitutesState>(
      bloc: myInstitutesBloc,
      listener: (context, state) {
        state.whenOrNull(
          success: (isLoading, data) => _bootstrapFromMyInstitutes(data),
        );
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              context.appSize.width.w,
              60.h,
              _InstituteHeader(
                hasInstitute: HiveService.hasCurrentInstitute,
                name: HiveService.currentInstituteName,
                logoUrl: HiveService.currentInstituteLogoUrl,
              ),
              20.h,
              CustomText(
                "دوره‌های این مؤسسه",
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              8.h,
              CustomText("دوره‌هایی که این مؤسسه منتشر کرده است."),
              16.h,
              _buildCoursesList(),
              20.h,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoursesList() {
    if (_noInstituteFound) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            CustomText(
              "هنوز به مؤسسه‌ای متصل نیستید.",
              color: context.colors.inkMuted,
            ),
            12.h,
            OutlinedButton(
              onPressed: () => CustomNavigator.pushNamed(
                InstitutesPage.routeName,
              ).then((_) => _onReturnedFromInstitutePicker()),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.colors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: CustomText("انتخاب مؤسسه"),
            ),
          ],
        ),
      );
    }
    if (!HiveService.hasCurrentInstitute) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CustomLoading()),
      );
    }
    return BlocBuilder<MyInstitutesBloc, MyInstitutesState>(
      bloc: myInstitutesBloc,
      builder: (context, myInstitutesState) {
        // Only used to resolve a *name* for the obvious "other institute"
        // label below — never to decide which courses to show.
        final instituteNameById = <String, String>{
          for (final institute
              in myInstitutesState.whenOrNull(
                    success: (isLoading, data) => data,
                  ) ??
                  const [])
            if (institute.id != null && (institute.name ?? '').isNotEmpty)
              institute.id!: institute.name!,
        };

        return BlocBuilder<MySubscriptionsBloc, MySubscriptionsState>(
          bloc: mySubscriptionsBloc,
          builder: (context, subState) {
            final subscriptions =
                subState.whenOrNull(success: (isLoading, data) => data) ??
                const <MySubscriptionsModel>[];
            final subscriptionByCourseId = <String, MySubscriptionsModel>{
              for (final sub in subscriptions)
                if (sub.courseId != null) sub.courseId!: sub,
            };

            return BlocBuilder<CoursesBloc, CoursesState>(
              bloc: coursesBloc,
              builder: (context, state) {
                return state.when(
                  loading: (_) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CustomLoading()),
                  ),
                  error: (_, message) => CustomError(message: message),
                  success: (isLoading, data) {
                    // Courses from another institute are never fetched or
                    // shown here on their own — the institute-scoped list
                    // only ever contains this institute's own courses. The
                    // *only* exception is a course the student is already
                    // registered in ("my courses"): that must never just
                    // disappear because of an institute mismatch, so it's
                    // folded back in here, but clearly labeled with its
                    // real institute so it's obvious why it's showing up.
                    final byId = <String, CoursesModel>{
                      for (final course in data)
                        if (course.id != null) course.id!: course,
                    };
                    for (final sub in subscriptions) {
                      final course = sub.coursesModel;
                      if (course?.id != null && !byId.containsKey(course!.id)) {
                        byId[course.id!] = course;
                      }
                    }
                    final merged = byId.values.toList()
                      ..sort((a, b) {
                        final aRank = subscriptionByCourseId.containsKey(a.id)
                            ? 0
                            : 1;
                        final bRank = subscriptionByCourseId.containsKey(b.id)
                            ? 0
                            : 1;
                        return aRank.compareTo(bRank);
                      });

                    if (merged.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CustomText(
                            "هنوز دوره‌ای منتشر نشده است.",
                            color: context.colors.inkMuted,
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: merged.map((course) {
                        final isOtherInstitute =
                            course.instituteId != null &&
                            course.instituteId !=
                                HiveService.currentInstituteId;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _InstituteCourseTile(
                            course: course,
                            subscription: subscriptionByCourseId[course.id],
                            otherInstituteName: isOtherInstitute
                                ? (instituteNameById[course.instituteId] ??
                                      "مؤسسه‌ی دیگر")
                                : null,
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

class _InstituteHeader extends StatelessWidget {
  final bool hasInstitute;
  final String? name;
  final String? logoUrl;

  const _InstituteHeader({required this.hasInstitute, this.name, this.logoUrl});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: context.colors.border),
          boxShadow: [
            BoxShadow(
              color: context.colors.ink.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 52,
                height: 52,
                color: context.colors.primaryTint,
                child: (logoUrl != null && logoUrl!.isNotEmpty)
                    ? Image.network(
                        logoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.school_rounded, color: context.colors.primary),
                      )
                    : Icon(Icons.school_rounded, color: context.colors.primary),
              ),
            ),
            12.w,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasInstitute ? (name ?? '') : 'در حال آماده‌سازی...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.colors.ink,
                    ),
                  ),
                  4.h,
                  Text(
                    "شما اکنون در این مؤسسه هستید",
                    style: TextStyle(fontSize: 12, color: context.colors.inkMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstituteCourseTile extends StatelessWidget {
  final CoursesModel course;

  /// The student's subscription to this course, if any. Its presence is
  /// what makes the tile read as "already registered" instead of showing
  /// a price/register affordance.
  final MySubscriptionsModel? subscription;

  /// Set only when this course doesn't belong to the currently selected
  /// institute (it's only ever shown here because the student is already
  /// registered in it) — an obvious label so it's clear why a course from
  /// another institute is mixed into this list.
  final String? otherInstituteName;

  const _InstituteCourseTile({
    required this.course,
    this.subscription,
    this.otherInstituteName,
  });

  void _open() {
    if (subscription != null) {
      CustomNavigator.pushNamed(
        OutlinePage.routeName,
        arguments: {"id": course.id ?? '', "title": course.title ?? ''},
      );
    } else {
      CustomNavigator.pushNamed(
        DetailCoursePage.routeName,
        arguments: course.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSubscribed = subscription != null;
    final isFree = course.price == null || course.price == 0;
    final progress = subscription?.courseProgressPercent;
    final hasCover = course.coverUrl != null && course.coverUrl!.isNotEmpty;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSubscribed
                ? context.colors.success.withValues(alpha: 0.45)
                : context.colors.border,
            width: isSubscribed ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: context.colors.ink.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OnClick(
              onTap: _open,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 12px of breathing room around the cover on every side
                  // (via the card's own padding) plus rounded corners of
                  // its own, and the badge floats just outside the corner
                  // instead of overlapping it — nothing feels cramped or
                  // clipped anymore.
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: hasCover
                            ? Image.network(
                                course.coverUrl!,
                                fit: BoxFit.cover,
                                width: 76,
                                height: 76,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.menu_book_rounded,
                                  size: 34,
                                  color: context.colors.white.withValues(alpha: 0.9),
                                ),
                              )
                            : Icon(
                                Icons.menu_book_rounded,
                                size: 34,
                                color: context.colors.white.withValues(alpha: 0.9),
                              ),
                      ),
                      if (isSubscribed)
                        Positioned(
                          top: -6,
                          right: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.colors.success,
                              border: Border.all(
                                color: context.colors.surface,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 13,
                              color: context.colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  12.w,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          course.title ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: context.colors.ink,
                          ),
                        ),
                        if (otherInstituteName != null) ...[
                          4.h,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.inkFaint.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: context.colors.border),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.apartment_rounded,
                                  size: 11,
                                  color: context.colors.inkMuted,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "دوره‌ی مؤسسه‌ی $otherInstituteName",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: context.colors.inkMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if ((course.description ?? '').isNotEmpty) ...[
                          4.h,
                          Text(
                            course.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              color: context.colors.inkMuted,
                            ),
                          ),
                        ],
                        if (isSubscribed && progress != null) ...[
                          8.h,
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: progress / 100.0,
                              minHeight: 6,
                              backgroundColor: context.colors.border,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.colors.success,
                              ),
                            ),
                          ),
                          4.h,
                          Text(
                            "$progress٪ پیشرفت",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: context.colors.inkMuted,
                            ),
                          ),
                        ] else ...[
                          6.h,
                          Text(
                            isFree ? "رایگان" : "${course.price} تومان",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: context.colors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            12.h,
            // A real, full-width call-to-action instead of a small pill —
            // impossible to miss, and its color alone signals state.
            SizedBox(
              width: double.infinity,
              height: 46,
              child: CustomButton(
                onTap: _open,
                backgroundColor: isSubscribed ? context.colors.success : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSubscribed
                          ? Icons.play_circle_fill_rounded
                          : Icons.arrow_back_ios_new_rounded,
                      size: isSubscribed ? 18 : 14,
                      color: context.colors.white,
                    ),
                    const SizedBox(width: 8),
                    CustomText(
                      isSubscribed
                          ? "ادامه یادگیری"
                          : (isFree ? "شروع رایگان" : "مشاهده و ثبت‌نام"),
                      color: context.colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

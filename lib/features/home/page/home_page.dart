import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/core/helper/custom_colors.dart';
import '/core/services/hive_service.dart';
import '/core/services/service_locator.dart';
import '/widgets/custom_text.dart';
import '../../main/data/models/courses_model.dart';
import '../../main/data/models/request_courses_model.dart';
import '../../main/presentation/bloc/courses/courses_bloc.dart';
import '../../main/presentation/bloc/my_institutes/my_institutes_bloc.dart';
import '../../main/presentation/page/institutes_page.dart';
import 'detail_course_page.dart';

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
  bool _noInstituteFound = false;

  @override
  void initState() {
    super.initState();
    if (HiveService.hasCurrentInstitute) {
      _loadCourses(HiveService.currentInstituteId!);
    } else {
      // First time in the app (or an older account created before this
      // feature existed): fall back to the institute the student is
      // already linked to.
      myInstitutesBloc.add(MyInstitutesEvent.myInstitutes());
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
              color: AppColor.inkMuted,
            ),
            12.h,
            OutlinedButton(
              onPressed: () => CustomNavigator.pushNamed(
                InstitutesPage.routeName,
              ).then((_) => _onReturnedFromInstitutePicker()),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColor.border),
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
            if (data.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CustomText(
                    "هنوز دوره‌ای منتشر نشده است.",
                    color: AppColor.inkMuted,
                  ),
                ),
              );
            }
            return Column(
              children: data
                  .map(
                    (course) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _InstituteCourseTile(course: course),
                    ),
                  )
                  .toList(),
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
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColor.border),
          boxShadow: [
            BoxShadow(
              color: AppColor.ink.withValues(alpha: 0.06),
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
                color: AppColor.primaryTint,
                child: (logoUrl != null && logoUrl!.isNotEmpty)
                    ? Image.network(
                        logoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.school_rounded, color: AppColor.primary),
                      )
                    : Icon(Icons.school_rounded, color: AppColor.primary),
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
                      color: AppColor.ink,
                    ),
                  ),
                  4.h,
                  Text(
                    "شما اکنون در این مؤسسه هستید",
                    style: TextStyle(fontSize: 12, color: AppColor.inkMuted),
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

  const _InstituteCourseTile({required this.course});

  @override
  Widget build(BuildContext context) {
    final isFree = course.price == null || course.price == 0;
    return OnClick(
      onTap: () => CustomNavigator.pushNamed(
        DetailCoursePage.routeName,
        arguments: course.id,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.border),
            boxShadow: [
              BoxShadow(
                color: AppColor.ink.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              Container(
                width: 88,
                height: 88,
                color: AppColor.primary.withValues(alpha: 0.55),
                child: (course.coverUrl != null && course.coverUrl!.isNotEmpty)
                    ? Image.network(
                        course.coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.menu_book_rounded,
                          color: AppColor.white.withValues(alpha: 0.85),
                        ),
                      )
                    : Icon(
                        Icons.menu_book_rounded,
                        color: AppColor.white.withValues(alpha: 0.85),
                      ),
              ),
              12.w,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColor.ink,
                        ),
                      ),
                      if ((course.description ?? '').isNotEmpty) ...[
                        4.h,
                        Text(
                          course.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColor.inkMuted,
                          ),
                        ),
                      ],
                      8.h,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryTint,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isFree ? "رایگان" : "${course.price} تومان",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              8.w,
            ],
          ),
        ),
      ),
    );
  }
}

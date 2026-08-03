import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/presentation/bloc/courses/courses_bloc.dart';
import 'package:mohammad/features/main/presentation/bloc/my_subscriptions/my_subscriptions_bloc.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/helper/custom_colors.dart';
import '../widgets/home_item.dart';
import 'detail_course_page.dart';

class CoursesScreen extends StatefulWidget {
  static const String routeName = "/courses";
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final coursesBloc = inject<CoursesBloc>();
  final mySubscriptions = inject<MySubscriptionsBloc>();

  @override
  void initState() {
    super.initState();
    coursesBloc.add(CoursesEvent.courses());
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          context.appSize.width.w,
          CustomAppBar(title: "دوره‌ها"),
          8.h,
          CustomText("همه دوره‌های منتشرشده"),
          20.h,
          Expanded(
            child: BlocBuilder<CoursesBloc, CoursesState>(
              bloc: coursesBloc,
              builder: (context, state) {
                return state.when(
                  loading: (_) => CustomLoading(),
                  error: (_, message) => CustomError(message: message),
                  success: (isLoading, data) {
                    return ListView.separated(
                      itemCount: data.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      separatorBuilder: (_, __) => SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final course = data[index];
                        final isFree =
                            course.price == null || course.price == 0;
                        return OnClick(
                          onTap: () {
                            CustomNavigator.pushNamed(
                              DetailCoursePage.routeName,
                              arguments: course.id,
                            );
                          },
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColor.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColor.border),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColor.ink.withValues(alpha: 0.06),
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    height: 160,
                                    alignment: Alignment.center,
                                    color: AppColor.primary.withValues(
                                      alpha: 0.55,
                                    ),
                                    child:
                                        course.coverUrl != null &&
                                            course.coverUrl!.isNotEmpty
                                        ? Image.network(
                                            course.coverUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Icon(
                                              Icons.menu_book_rounded,
                                              size: 48,
                                              color: AppColor.white.withValues(
                                                alpha: 0.85,
                                              ),
                                            ),
                                          )
                                        : Icon(
                                            Icons.menu_book_rounded,
                                            size: 48,
                                            color: AppColor.white.withValues(
                                              alpha: 0.85,
                                            ),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          course.title ?? "",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.ink,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        if (course.description != null &&
                                            course.description!.isNotEmpty) ...[
                                          SizedBox(height: 6),
                                          Text(
                                            course.description!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppColor.inkMuted,
                                            ),
                                            textAlign: TextAlign.right,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                        SizedBox(height: 10),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColor.primaryTint,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              isFree
                                                  ? "رایگان"
                                                  : "${course.price} تومان",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: AppColor.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          20.h,
        ],
      ),
    );
  }
}

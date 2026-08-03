import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/helper/custom_colors.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/data/models/course_detail_model.dart';
import 'package:mohammad/features/main/data/models/request_course_detail_model.dart';
import 'package:mohammad/features/main/data/models/request_subscribe_course_model.dart';
import 'package:mohammad/features/main/presentation/bloc/my_subscriptions/my_subscriptions_bloc.dart';
import 'package:mohammad/features/main/presentation/bloc/subscribe_course/subscribe_course_bloc.dart';
import 'package:mohammad/features/main/presentation/page/outline_page.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '../../main/data/models/my_subscriptions_model.dart';
import '../../main/presentation/bloc/course_detail/course_detail_bloc.dart';

class DetailCoursePage extends StatefulWidget {
  final String id;
  static const String routeName = "/detail-course";

  const DetailCoursePage({super.key, required this.id});

  @override
  State<DetailCoursePage> createState() => _DetailCoursePageState();
}

class _DetailCoursePageState extends State<DetailCoursePage> {
  final coursesBloc = inject<CourseDetailBloc>();
  final mySubsBloc = inject<MySubscriptionsBloc>();
  final subscribeCourseBloc = inject<SubscribeCourseBloc>();

  @override
  void initState() {
    super.initState();
    mySubsBloc.add(MySubscriptionsEvent.mySubscriptions());
    coursesBloc.add(
      CourseDetailEvent.courseDetail(
        params: RequestCourseDetailModel(id: widget.id),
      ),
    );
  }

  late CourseDetailModel dataModel;

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
          BlocBuilder<CourseDetailBloc, CourseDetailState>(
            bloc: coursesBloc,
            builder: (context, state) {
              return state.when(
                loading: (_) => CustomLoading(),
                error: (_, message) => CustomError(message: message),
                success: (isLoading, data) {
                  dataModel = data;
                  final isFree =
                      data.coursesModel?.price == null ||
                      data.coursesModel?.price == 0;
                  return Column(
                    children: [
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.surface,
                            border: Border.all(
                              color: AppColor.primary.withValues(alpha: 0.2),
                            ),
                            borderRadius: BorderRadius.circular(16),
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
                                color: AppColor.primary.withValues(alpha: 0.55),
                                child:
                                    data.coursesModel?.coverUrl != null &&
                                        data.coursesModel!.coverUrl!.isNotEmpty
                                    ? Image.network(
                                        data.coursesModel!.coverUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Center(
                                          child: Icon(
                                            Icons.play_circle_fill,
                                            size: 48,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    CustomText(
                                      data.coursesModel?.title ?? "",
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.ink,
                                      textAlign: TextAlign.right,
                                    ),
                                    if (data.coursesModel?.description !=
                                            null &&
                                        data
                                            .coursesModel!
                                            .description!
                                            .isNotEmpty) ...[
                                      SizedBox(height: 6),
                                      CustomText(
                                        data.coursesModel!.description!,
                                        fontSize: 13,
                                        color: AppColor.inkMuted,
                                        textAlign: TextAlign.right,
                                        maxLines: 2,
                                        // overflow: TextOverflow.ellipsis,
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: CustomText(
                                          isFree
                                              ? "رایگان"
                                              : "${data.coursesModel?.price} تومان",
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColor.surface,
                                  border: Border.all(
                                    color: AppColor.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          CustomText(
                                            "${data.unitCount}",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                          4.h,
                                          CustomText("واحد", fontSize: 15),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          CustomText(
                                            "${data.pathCount}",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                          4.h,
                                          CustomText("مسیر", fontSize: 15),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          CustomText(
                                            "${data.moduleCount}",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                          4.h,
                                          CustomText("فصل", fontSize: 15),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              20.h,
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Spacer(),
          BlocBuilder<CourseDetailBloc, CourseDetailState>(
            bloc: coursesBloc,
            builder: (context, sts) {
              return BlocBuilder<MySubscriptionsBloc, MySubscriptionsState>(
                bloc: mySubsBloc,
                builder: (context, subState) {
                  return BlocConsumer<
                    SubscribeCourseBloc,
                    SubscribeCourseState
                  >(
                    bloc: subscribeCourseBloc,
                    listener: (context, state) {
                      state.whenOrNull(
                        error: (isLoading, message) {
                          CustomToast.toast(context, message);
                        },
                        success: (isLoading, data) {
                          mySubsBloc.values.add(
                            MySubscriptionsModel(id: widget.id),
                          );
                        },
                      );
                    },
                    builder: (context, state) {
                      return CustomButton(
                        title: mySubsBloc.values.isEmpty
                            ? "ثبت نام دوره"
                            : mySubsBloc.values.any(
                                (element) => element.courseId == widget.id,
                              )
                            ? "شروع یادگیری"
                            : "خطای ناشناخته",
                        onTap: () {
                          if (mySubsBloc.values.isEmpty) {
                            subscribeCourseBloc.add(
                              SubscribeCourseEvent.subscribeCourse(
                                params: RequestSubscribeCourseModel(
                                  id: widget.id,
                                ),
                              ),
                            );
                          } else if (mySubsBloc.values.any(
                            (element) => element.courseId == widget.id,
                          )) {
                            CustomNavigator.pushNamed(
                              OutlinePage.routeName,
                              arguments: {
                                "id": dataModel.coursesModel?.id ?? "",
                                "title": dataModel.coursesModel?.title ?? "",
                              },
                            );
                          }
                        },
                        loading:
                            sts.isLoading ||
                            subState.isLoading ||
                            state.isLoading,
                        enable: !sts.isLoading && !subState.isLoading,
                      );
                    },
                  );
                },
              );
            },
          ),
          30.h,
        ],
      ),
    );
  }
}

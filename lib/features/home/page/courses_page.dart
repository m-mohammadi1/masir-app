import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/presentation/bloc/my_subscriptions/my_subscriptions_bloc.dart';
import 'package:mohammad/widgets/custom_button.dart';
import 'package:mohammad/widgets/custom_text.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../main/presentation/page/outline_page.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  final mySubscriptionsBloc = inject<MySubscriptionsBloc>();

  @override
  void initState() {
    super.initState();
    mySubscriptionsBloc.add(MySubscriptionsEvent.mySubscriptions());
  }

  String _toPersianDigits(String input) {
    const persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    return input.split('').map((c) {
      if (RegExp(r'[0-9]').hasMatch(c)) {
        return persianDigits[int.parse(c)];
      }
      return c;
    }).join();
  }

  String _formatJalaliDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      final jalali = Jalali.fromDateTime(dateTime);
      final year = jalali.year.toString();
      final month = jalali.month.toString().padLeft(2, '0');
      final day = jalali.day.toString().padLeft(2, '0');
      return _toPersianDigits("$year/$month/$day");
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          context.appSize.width.w,
          60.h,
          CustomText("دوره های من", fontWeight: FontWeight.bold, fontSize: 20),
          8.h,
          CustomText("دوره هایی که در آن ثبت نام کرده اید."),
          20.h,
          Expanded(
            child: BlocBuilder<MySubscriptionsBloc, MySubscriptionsState>(
              bloc: mySubscriptionsBloc,
              builder: (context, state) {
                return state.when(
                  loading: (_) => CustomLoading(),
                  error: (_, message) => CustomError(message: message),
                  success: (isLoading, data) {
                    return ListView.separated(
                      itemCount: data.length,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      separatorBuilder: (_, __) => SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final subscription = data[index];
                        final course = subscription.coursesModel;
                        final progress =
                            subscription.courseProgressPercent ?? 0;
                        return Directionality(
                          textDirection: TextDirection.ltr,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Color(0xffE7DEF8),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              course?.title ?? "",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff2F2146),
                                              ),
                                            ),
                                            if (course?.publishedAt != null &&
                                                course!
                                                    .publishedAt!
                                                    .isNotEmpty) ...[
                                              SizedBox(height: 4),
                                              Text(
                                                "تاریخ ثبت‌نام: ${_formatJalaliDate(course.publishedAt!)}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xff6E6884),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 14),
                                      Container(
                                        width: 64,
                                        height: 64,
                                        decoration: BoxDecoration(
                                          color: Color(0xff9B8FD8),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child:
                                            course?.coverUrl != null &&
                                                course!.coverUrl!.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.network(
                                                  course.coverUrl!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      Icon(
                                                        Icons.play_circle_fill,
                                                        size: 30,
                                                        color: Colors.white70,
                                                      ),
                                                ),
                                              )
                                            : SizedBox(),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "%",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff6E6884),
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: progress / 100.0,
                                            minHeight: 8,
                                            backgroundColor: Color(0xffE7DEF8),
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Color(0xff7C3AED),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 48,
                                    child: CustomButton(
                                      onTap: () {
                                        CustomNavigator.pushNamed(
                                          OutlinePage.routeName,
                                          arguments: {
                                            "id": "${course?.id}",
                                            "title": "${course?.title}",
                                          },
                                        );
                                      },
                                      title: "ادامه یادگیری",
                                    ),
                                  ),
                                ),
                              ],
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

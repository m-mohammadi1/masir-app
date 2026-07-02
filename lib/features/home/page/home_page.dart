import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '../../main/presentation/page/institutes_page.dart';
import '../../main/presentation/page/my_institutes_page.dart';
import '../widgets/course_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            context.appSize.width.w,
            60.h,
            CustomText(
              "کاوش",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            8.h,
            CustomText("دوره هایی که در آن ثبت نام کرده اید."),
            20.h,

            CourseCard(
              title: 'مؤسسات من',
              description: "مؤسساتی که به آن‌ها متصل هستید",
              icon: Icons.apartment_rounded,
              onTap: () {
                CustomNavigator.pushNamed(MyInstitutesPage.routeName);

              },
            ),
            12.h,

            CourseCard(
              title: 'مؤسسات',
              description: "مؤسسات آموزشی را کاوش کنید",
              icon: Icons.maps_home_work_outlined,
              onTap: () {
                CustomNavigator.pushNamed(InstitutesPage.routeName);
              },
            ),
            12.h,
            CourseCard(
              title: 'دوره ها',
              description: "همه دوره‌های منتشرشده",
              icon: Icons.school_outlined,
              onTap: () {
                CustomNavigator.pushNamed(InstitutesPage.routeName);

              },
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: CustomText(
            //     "دوره های من",
            //     fontWeight: FontWeight.bold,
            //     fontSize: 20,
            //   ),
            // ),
            // 8.h,
            // SizedBox(
            //   height: 280,
            //   child: ListView.builder(
            //     itemCount: 3,
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) => HomeItem(),
            //   ),
            // ),
            // 20.h,
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: CustomText(
            //     "کلاس های من",
            //     fontWeight: FontWeight.bold,
            //     fontSize: 20,
            //   ),
            // ),
            // 8.h,
            // SizedBox(
            //   height: 280,
            //   child: ListView.builder(
            //     itemCount: 3,
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) => HomeItem(),
            //   ),
            // ),
            // 20.h,
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: CustomText(
            //     "آموزش های رایگان",
            //     fontWeight: FontWeight.bold,
            //     fontSize: 20,
            //   ),
            // ),
            // 8.h,
            // SizedBox(
            //   height: 280,
            //   child: ListView.builder(
            //     itemCount: 3,
            //     padding: const EdgeInsets.symmetric(horizontal: 16),
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) => HomeItem(),
            //   ),
            // ),
            20.h,
          ],
        ),
      ),
    );
  }
}

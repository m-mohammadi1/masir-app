import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '../widgets/home_item.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          60.h,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomText(
              "دوره های من",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          8.h,
          SizedBox(
            height: 280,
            child: ListView.builder(
              itemCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => HomeItem(),
            ),
          ),
          20.h,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomText(
              "کلاس های من",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          8.h,
          SizedBox(
            height: 280,
            child: ListView.builder(
              itemCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => HomeItem(),
            ),
          ),
          20.h,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomText(
              "آموزش های رایگان",
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          8.h,
          SizedBox(
            height: 280,
            child: ListView.builder(
              itemCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => HomeItem(),
            ),
          ),
          20.h,
        ],
      ),
    );
  }
}

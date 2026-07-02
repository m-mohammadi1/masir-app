import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/presentation/bloc/my_subscriptions/my_subscriptions_bloc.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '../widgets/home_item.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final mySubscriptionsBloc = inject<MySubscriptionsBloc>();

  @override
  void initState() {
    super.initState();
    mySubscriptionsBloc.add(MySubscriptionsEvent.mySubscriptions());
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
          CustomText(
            "دوره های من",
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
                    return ListView.builder(
                      itemCount: data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return CustomText("text");
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

import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';

import '../bloc/my_institutes/my_institutes_bloc.dart';

class MyInstitutesPage extends StatefulWidget {
  static const String routeName = "/my-institutes";

  const MyInstitutesPage({super.key});

  @override
  State<MyInstitutesPage> createState() => _MyInstitutesPageState();
}

class _MyInstitutesPageState extends State<MyInstitutesPage> {
  final bloc = inject<MyInstitutesBloc>();

  @override
  void initState() {
    super.initState();
    bloc.add(MyInstitutesEvent.myInstitutes());
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomAppBar(title: "مؤسسات من"),
          8.h,
          CustomText("مؤسساتی که به آن‌ها متصل هستید"),
          20.h,
          Expanded(
            child: BlocBuilder<MyInstitutesBloc, MyInstitutesState>(
              bloc: bloc,
              builder: (context, state) {
                return state.when(
                  loading: (isLoading) => CustomLoading(),
                  error: (isLoading, message) => CustomError(message: message),
                  success: (isLoading, data) {
                    return ListView.separated(
                        itemCount: data.length,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        separatorBuilder: (_, __) => SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final institute = data[index];
                          return Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 10,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          children: [
                                            CustomText(
                                              institute.name ?? "",
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                            CustomText(
                                              institute.slug ?? "",
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  12.w,
                                  ClipOval(
                                    child: Container(
                                      width: 64,
                                      height: 64,
                                      color: Colors.grey[200],
                                      child: Icon(
                                        Icons.apartment_rounded,
                                        size: 30,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

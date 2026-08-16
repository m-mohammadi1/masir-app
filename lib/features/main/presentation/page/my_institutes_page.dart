import 'package:easy_helper/easy_helper.dart' hide CustomError;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';

import '../bloc/my_institutes/my_institutes_bloc.dart';
import '/core/theme/theme_context.dart';
import '/widgets/custom_error.dart';
import '/widgets/empty_widget.dart';
import '/widgets/skeleton.dart';

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
                  loading: (isLoading) => const SkeletonList(),
                  error: (isLoading, message) => CustomError(
                    message: message,
                    retry: () => bloc.add(MyInstitutesEvent.myInstitutes()),
                  ),
                  success: (isLoading, data) {
                    if (data.isEmpty) {
                      return const EmptyWidget(
                        text: 'مؤسسه‌ای ندارید',
                        description: 'هنوز به هیچ مؤسسه‌ای متصل نشده‌اید.',
                        icon: Icons.apartment_outlined,
                      );
                    }
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
                              color: context.colors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: context.colors.border),
                              boxShadow: [
                                BoxShadow(
                                  color: context.colors.ink.withValues(alpha: 0.06),
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
                                            color: context.colors.ink,
                                          ),
                                          CustomText(
                                            institute.slug ?? "",
                                            fontSize: 14,
                                            color: context.colors.ink,
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
                                    color: context.colors.borderF9,
                                    child: Icon(
                                      Icons.apartment_rounded,
                                      size: 30,
                                      color: context.colors.inkMuted,
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
        ],
      ),
    );
  }
}

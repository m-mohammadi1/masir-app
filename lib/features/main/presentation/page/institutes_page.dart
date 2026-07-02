import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/presentation/bloc/institutes/institutes_bloc.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';

class InstitutesPage extends StatefulWidget {
  static const String routeName = "/institutes";
  const InstitutesPage({super.key});

  @override
  State<InstitutesPage> createState() => _InstitutesPageState();
}

class _InstitutesPageState extends State<InstitutesPage> {
  final bloc = inject<InstitutesBloc>();

  @override
  void initState() {
    super.initState();
    bloc.add(InstitutesEvent.institutes());
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomAppBar(title: "مؤسسات"),
          8.h,
          CustomText("مؤسسات آموزشی را کاوش کنید"),
          20.h,
          Expanded(
            child: BlocBuilder<InstitutesBloc, InstitutesState>(
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
                                    Text(
                                      institute.name ?? "",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
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
                                  child: institute.logoUrl != null && institute.logoUrl!.isNotEmpty
                                      ? Image.network(
                                          institute.logoUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Icon(
                                            Icons.school,
                                            size: 30,
                                            color: Colors.grey[500],
                                          ),
                                        )
                                      : Icon(
                                          Icons.school,
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

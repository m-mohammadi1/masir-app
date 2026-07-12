import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/data/models/request_outline_course_model.dart';
import 'package:mohammad/features/main/presentation/bloc/outline_course/outline_course_bloc.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_page.dart';
import 'package:mohammad/features/quiz/presentation/page/unit_page_args.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';

class OutlinePage extends StatefulWidget {
  final String title, id;
  static const String routeName = "/outline";

  const OutlinePage({super.key, required this.title, required this.id});

  @override
  State<OutlinePage> createState() => _OutlinePageState();
}

class _OutlinePageState extends State<OutlinePage> {
  final bloc = inject<OutlineCourseBloc>();

  @override
  void initState() {
    super.initState();
    bloc.add(
      OutlineCourseEvent.outlineCourse(
        params: RequestOutlineCourseModel(id: widget.id),
      ),
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'html':
        return 'درس';
      case 'practice':
        return 'تمرین';
      case 'quiz':
        return 'آزمون';
      case 'audio':
        return 'صوتی';
      default:
        return type;
    }
  }

  void _onUnitTap({
    required String? id,
    required String? type,
    required String? title,
    required String? status,
    required bool locked,
  }) {
    if (locked || id == null || id.isEmpty) return;

    CustomNavigator.pushNamed(
      UnitPage.routeName,
      arguments: UnitPageArgs(
        unitId: id,
        unitType: type ?? '',
        unitTitle: title ?? '',
        status: status ?? '',
      ).toMap(),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'html':
        return Icons.description_outlined;
      case 'practice':
        return Icons.fact_check_outlined;
      case 'quiz':
        return Icons.help_outline;
      case 'audio':
        return Icons.headphones_outlined;
      default:
        return Icons.article_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BaseScreen(
        body: Column(
          children: [
            CustomAppBar(title: widget.title),
            20.h,
            BlocBuilder<OutlineCourseBloc, OutlineCourseState>(
              bloc: bloc,
              builder: (context, state) {
                return state.when(
                  loading: (_) => CustomLoading(),
                  error: (_, message) => CustomError(message: message),
                  success: (isLoading, data) {
                    final courseProgress = data.courseProgressPercent ?? 0;
                    final modules = data.modules ?? [];
                    return Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                "پیشرفت دوره",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff2F2146),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xff7C3AED),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomText(
                                  "%$courseProgress",

                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: courseProgress / 100.0,
                              minHeight: 6,
                              backgroundColor: Color(0xffE7DEF8),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xff7C3AED),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: ListView.separated(
                              padding: EdgeInsets.only(bottom: 20),
                              itemCount: modules.length,
                              separatorBuilder: (_, __) => SizedBox(height: 14),
                              itemBuilder: (context, moduleIndex) {
                                final module = modules[moduleIndex];
                                final paths = module.paths ?? [];
                                return Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: CustomText(
                                          module.title ?? "",

                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xff2F2146),
                                        ),
                                      ),
                                      ...paths.map((path) {
                                        final units = path.units ?? [];
                                        final pathProgress =
                                            path.pathProgressPercent ?? 0;
                                        final pathLocked = path.locked ?? false;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                  ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomText(
                                                        path.title ?? "",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color(
                                                          0xff2F2146,
                                                        ),
                                                      ),
                                                      CustomText(
                                                        "$pathProgress%",
                                                        fontSize: 12,
                                                        color: Color(
                                                          0xff6E6884,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 6),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                    child: LinearProgressIndicator(
                                                      value:
                                                          pathProgress / 100.0,
                                                      minHeight: 4,
                                                      backgroundColor: Color(
                                                        0xffE7DEF8,
                                                      ),
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(Color(0xff7C3AED)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            ...units.map((unit) {
                                              final unitLocked =
                                                  unit.locked ?? false;
                                              final unitType = unit.type ?? "";
                                              final unitStatus =
                                                  unit.status ?? "";
                                              final isCompleted =
                                                  unitStatus == "completed";
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 5,
                                                    ),
                                                child: OnClick(
                                                  onTap: () => _onUnitTap(
                                                    id: unit.id,
                                                    type: unitType,
                                                    title: unit.title,
                                                    status: unitStatus,
                                                    locked: unitLocked,
                                                  ),
                                                  child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 12,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: isCompleted
                                                        ? Color(0xffE8F5E9)
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    border: Border.all(
                                                      color: isCompleted
                                                          ? Color(0xffA5D6A7)
                                                          : Color(0xffE7DEF8),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 40,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                          color: isCompleted
                                                              ? Color(
                                                                  0xffC8E6C9,
                                                                )
                                                              : unitLocked
                                                              ? Color(
                                                                  0xffF5F3F8,
                                                                )
                                                              : Color(
                                                                  0xffF3EBFF,
                                                                ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                        child: Icon(
                                                          isCompleted
                                                              ? Icons
                                                                    .check_circle_outline
                                                              : unitLocked
                                                              ? Icons
                                                                    .lock_outline
                                                              : _getTypeIcon(
                                                                  unitType,
                                                                ),
                                                          size: 20,
                                                          color: isCompleted
                                                              ? Color(
                                                                  0xff4CAF50,
                                                                )
                                                              : unitLocked
                                                              ? Color(
                                                                  0xff9E96B0,
                                                                )
                                                              : Color(
                                                                  0xff7C3AED,
                                                                ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CustomText(
                                                              unit.title ?? "",
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: unitLocked
                                                                  ? Color(
                                                                      0xff9E96B0,
                                                                    )
                                                                  : Color(
                                                                      0xff2F2146,
                                                                    ),
                                                            ),
                                                            SizedBox(height: 2),
                                                            CustomText(
                                                              _getTypeLabel(
                                                                unitType,
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: Color(
                                                                  0xff6E6884,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (unitLocked) ...[
                                                        SizedBox(width: 8),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 10,
                                                                vertical: 4,
                                                              ),
                                                          decoration: BoxDecoration(
                                                            color: Color(
                                                              0xffF3EBFF,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          child: CustomText(
                                                            "قفل",
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: Color(
                                                              0xff7C3AED,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                                ),
                                              );
                                            }),
                                            SizedBox(height: 8),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

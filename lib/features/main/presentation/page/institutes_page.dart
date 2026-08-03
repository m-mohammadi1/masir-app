import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/presentation/bloc/institutes/institutes_bloc.dart';
import 'package:mohammad/widgets/base_screen.dart';
import 'package:mohammad/widgets/custom_app_bar.dart';
import 'package:mohammad/widgets/custom_text.dart';
import '/core/helper/custom_colors.dart';
import '/core/services/hive_service.dart';
import '../../data/models/institutes_model.dart';
import '../bloc/my_institutes/my_institutes_bloc.dart';

/// Doubles as the "switch institute" screen: every institute is tappable,
/// selecting one makes it the student's current institute app-wide.
class InstitutesPage extends StatefulWidget {
  static const String routeName = "/institutes";
  const InstitutesPage({super.key});

  @override
  State<InstitutesPage> createState() => _InstitutesPageState();
}

class _InstitutesPageState extends State<InstitutesPage> {
  final bloc = inject<InstitutesBloc>();
  final myInstitutesBloc = inject<MyInstitutesBloc>();

  @override
  void initState() {
    super.initState();
    bloc.add(InstitutesEvent.institutes());
    myInstitutesBloc.add(MyInstitutesEvent.myInstitutes());
  }

  Future<void> _selectInstitute(InstitutesModel institute) async {
    final id = institute.id ?? '';
    if (id.isEmpty) return;
    await HiveService.setCurrentInstitute(
      id: id,
      name: institute.name,
      slug: institute.slug,
      logoUrl: institute.logoUrl,
    );
    if (!mounted) return;
    CustomToast.toast(context, "«${institute.name ?? ''}» مؤسسه فعلی شما شد");
    CustomNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomAppBar(title: "تغییر مؤسسه"),
          8.h,
          CustomText("مؤسسه‌ای را انتخاب کنید تا دوره‌های آن را ببینید"),
          20.h,
          Expanded(
            child: BlocBuilder<MyInstitutesBloc, MyInstitutesState>(
              bloc: myInstitutesBloc,
              builder: (context, myState) {
                final myIds =
                    myState.whenOrNull(
                      success: (isLoading, data) =>
                          data.map((e) => e.id ?? '').toSet(),
                    ) ??
                    <String>{};

                return BlocBuilder<InstitutesBloc, InstitutesState>(
                  bloc: bloc,
                  builder: (context, state) {
                    return state.when(
                      loading: (isLoading) => CustomLoading(),
                      error: (isLoading, message) =>
                          CustomError(message: message),
                      success: (isLoading, data) {
                        return ListView.separated(
                          itemCount: data.length,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          separatorBuilder: (_, __) => SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final institute = data[index];
                            final isCurrent =
                                institute.id != null &&
                                institute.id == HiveService.currentInstituteId;
                            final isMine = myIds.contains(institute.id);
                            return OnClick(
                              onTap: () => _selectInstitute(institute),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isCurrent
                                        ? AppColor.primaryTint
                                        : AppColor.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isCurrent
                                          ? AppColor.primary
                                          : AppColor.border,
                                      width: isCurrent ? 1.5 : 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.ink.withValues(
                                          alpha: 0.06,
                                        ),
                                        blurRadius: 10,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: Container(
                                          width: 56,
                                          height: 56,
                                          color: AppColor.borderF9,
                                          child:
                                              institute.logoUrl != null &&
                                                  institute.logoUrl!.isNotEmpty
                                              ? Image.network(
                                                  institute.logoUrl!,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      Icon(
                                                        Icons.school,
                                                        size: 26,
                                                        color:
                                                            AppColor.inkMuted,
                                                      ),
                                                )
                                              : Icon(
                                                  Icons.school,
                                                  size: 26,
                                                  color: AppColor.inkMuted,
                                                ),
                                        ),
                                      ),
                                      12.w,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              institute.name ?? "",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: AppColor.ink,
                                              ),
                                            ),
                                            if (isMine || isCurrent) ...[
                                              4.h,
                                              Text(
                                                isCurrent
                                                    ? "مؤسسه فعلی شما"
                                                    : "عضو این مؤسسه هستید",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: isCurrent
                                                      ? AppColor.primary
                                                      : AppColor.success,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if (isCurrent)
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: AppColor.primary,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

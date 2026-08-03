import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohammad/core/services/service_locator.dart';
import 'package:mohammad/features/main/data/models/request_my_institutes_model.dart';
import 'package:mohammad/features/main/presentation/bloc/my_institutes/my_institutes_bloc.dart';

import '../../../../core/helper/custom_colors.dart';
import '../../../../core/services/hive_service.dart';
import '../../../../widgets/custom_text.dart';
import '../../../auth/domain/entities/submit_username.dart';
import '../../../auth/presentation/page/auth_screen.dart';
import '../../../edit_profile/presentation/page/edit_profile_page.dart';
import '../../../../widgets/exit_modal.dart';
import '../../../../widgets/base_modal.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final myInstitutesBloc = inject<MyInstitutesBloc>();

  @override
  void initState() {
    super.initState();
    myInstitutesBloc.add(MyInstitutesEvent.myInstitutes());
  }

  @override
  Widget build(BuildContext context) {
    final user = HiveService.user;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            context.appSize.width.w,
            60.h,
            CustomText("پروفایل", fontWeight: FontWeight.bold, fontSize: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildProfileCard(user),
                  16.h,
                  _buildInstitutesSection(),
                  16.h,
                  _buildLogoutButton(),
                  40.h,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(User? user) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.ink.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            user?.name ?? "نام تنظیم نشده",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.ink,
            ),
          ),
          SizedBox(height: 20),
          _buildInfoRow(
            label: "شماره موبایل",
            value: user?.phone ?? "---",
          ),
          SizedBox(height: 12),
          _buildInfoRow(
            label: "نام کاربری",
            value: user?.username ?? "---",
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () => CustomNavigator.pushNamed(EditProfilePage.routeName),
              icon: Icon(
                Icons.edit_outlined,
                size: 18,
                color: AppColor.ink,
              ),
              label: Text(
                "ویرایش پروفایل",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColor.ink,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColor.border, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: AppColor.ink,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColor.inkMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildInstitutesSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.ink.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "مؤسسات من",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColor.ink,
            ),
          ),
          SizedBox(height: 16),
          BlocBuilder<MyInstitutesBloc, MyInstitutesState>(
            bloc: myInstitutesBloc,
            builder: (context, state) {
              return state.when(
                loading: (_) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: AppColor.primary),
                  ),
                ),
                error: (_, message) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ),
                success: (isLoading, data) {
                  if (data.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          " مؤسسه‌ای یافت نشد",
                          style: TextStyle(
                            color: AppColor.inkMuted,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: data.map((institute) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColor.borderF9,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              institute.slug ?? "",
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColor.inkMuted,
                              ),
                            ),
                            Text(
                              institute.name ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColor.ink,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton.icon(
          onPressed: () => showCustomModal(
            context: context,
            scrollControlDisabledMaxHeightRatio: .4,
            callBack: (_) {},
            child: ExitModal(
              text: "میخواهید از حساب کاربری خود خارج شوید؟",
              exitAction: () {
                HiveService.logout();
                CustomNavigator.go(AuthScreen.routeName);
              },
            ),
          ),
          icon: Icon(
            Icons.logout_rounded,
            size: 20,
            color: AppColor.ink,
          ),
          label: Text(
            "خروج",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColor.ink,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColor.border, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:easy_helper/easy_helper.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/hive_service.dart';
import '../../../../widgets/custom_text.dart';
import '../../../about_us/presentation/page/about_us_page.dart';
import '../../../auth/domain/entities/submit_username.dart';
import '../../../auth/presentation/page/auth_screen.dart';
import '../../../edit_profile/presentation/page/edit_profile_page.dart';
import '../../../main/presentation/page/institutes_page.dart';
import '../../../../widgets/exit_modal.dart';
import '../../../../widgets/base_modal.dart';
import '/core/theme/theme_context.dart';
import '/widgets/chunky_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = HiveService.user;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: [
        56.h,
        const CustomText('پروفایل', fontWeight: FontWeight.w800, fontSize: 28),
        20.h,
        _ProfileHero(user: user),
        20.h,
        _buildCurrentInstitute(),
        20.h,
        _SettingsRow(
          icon: Icons.edit_rounded,
          label: 'ویرایش پروفایل',
          onTap: () => CustomNavigator.pushNamed(EditProfilePage.routeName),
        ),
        12.h,
        _SettingsRow(
          icon: Icons.info_rounded,
          label: 'درباره‌ی مسیر',
          onTap: () => CustomNavigator.pushNamed(AboutUsPage.routeName),
        ),
        12.h,
        _SettingsRow(
          icon: Icons.logout_rounded,
          label: 'خروج از حساب',
          danger: true,
          onTap: () => showCustomModal(
            context: context,
            scrollControlDisabledMaxHeightRatio: .4,
            callBack: (_) {},
            child: ExitModal(
              text: 'می‌خواهی از حساب کاربری‌ات خارج شوی؟',
              exitAction: () {
                HiveService.logout();
                CustomNavigator.go(AuthScreen.routeName);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentInstitute() {
    final c = context.colors;
    final hasInstitute = HiveService.hasCurrentInstitute;
    final logoUrl = HiveService.currentInstituteLogoUrl;
    return ChunkyBox(
      fill: c.surface,
      edge: c.lip,
      borderColor: c.border,
      padding: const EdgeInsets.all(16),
      onTap: () => CustomNavigator.pushNamed(
        InstitutesPage.routeName,
      ).then((_) => setState(() {})),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              width: 48,
              height: 48,
              color: c.primaryTint,
              child: (logoUrl != null && logoUrl.isNotEmpty)
                  ? Image.network(
                      logoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Icon(Icons.school_rounded, color: c.primary),
                    )
                  : Icon(Icons.school_rounded, color: c.primary),
            ),
          ),
          12.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  'آخرین مؤسسه',
                  fontSize: 12,
                  color: c.inkMuted,
                ),
                2.h,
                CustomText(
                  hasInstitute
                      ? (HiveService.currentInstituteName ?? '')
                      : 'هنوز انتخاب نشده',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Icon(Icons.swap_horiz_rounded, color: c.primary),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  final User? user;
  const _ProfileHero({required this.user});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final name = user?.name?.trim();
    final hasName = name != null && name.isNotEmpty;
    return ChunkyBox(
      fill: c.primary,
      edge: c.primaryEdge,
      radius: 24,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 4,
              ),
            ),
            child: CustomText(
              hasName ? name.characters.first : 'م',
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: c.primary,
            ),
          ),
          16.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  hasName ? name : 'نام تنظیم نشده',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: c.onPrimary,
                  maxLines: 1,
                ),
                6.h,
                if (user?.phone != null)
                  CustomText(
                    user!.phone!,
                    fontSize: 13,
                    color: c.onPrimary.withValues(alpha: 0.85),
                  ),
                if (user?.username != null)
                  CustomText(
                    '@${user!.username}',
                    fontSize: 13,
                    color: c.onPrimary.withValues(alpha: 0.85),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tone = danger ? c.coral : c.primary;
    return ChunkyBox(
      fill: c.surface,
      edge: danger ? c.coralEdge.withValues(alpha: 0.4) : c.lip,
      borderColor: danger ? c.coral.withValues(alpha: 0.4) : c.border,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: danger ? c.coralSoft : c.primaryTint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: tone),
          ),
          14.w,
          Expanded(
            child: CustomText(
              label,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: danger ? c.coral : c.ink,
            ),
          ),
          Icon(Icons.chevron_left_rounded, color: c.locked),
        ],
      ),
    );
  }
}

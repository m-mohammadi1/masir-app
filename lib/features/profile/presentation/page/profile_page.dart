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
import '/core/helper/jalali_format.dart';
import '/core/theme/institute_presets.dart';
import '/widgets/brand_media.dart';
import '/widgets/list_row.dart';
import '/widgets/masir_card.dart';
import '/widgets/masir_page.dart';
import '/widgets/section_header.dart';
import '/core/theme/masir_style.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = HiveService.user;
    return MasirPage.tab(
      title: 'پروفایل',
      children: [
        _ProfileHero(user: user),
        const SizedBox(height: MasirSpace.section),
        const SectionHeader('مؤسسه‌ی فعلی'),
        _buildCurrentInstitute(),
        const SizedBox(height: MasirSpace.section),
        const SectionHeader('حساب'),
        ListRow.menu(
          icon: Icons.edit_rounded,
          title: 'ویرایش پروفایل',
          onTap: () => CustomNavigator.pushNamed(EditProfilePage.routeName),
        ),
        const SizedBox(height: MasirSpace.md),
        ListRow.menu(
          icon: Icons.info_rounded,
          title: 'درباره‌ی مسیر',
          onTap: () => CustomNavigator.pushNamed(AboutUsPage.routeName),
        ),
        const SizedBox(height: MasirSpace.md),
        ListRow.menu(
          icon: Icons.logout_rounded,
          title: 'خروج از حساب',
          danger: true,
          onTap: () => showCustomModal(
            context: context,
            scrollControlDisabledMaxHeightRatio: .4,
            callBack: (_) {},
            child: ExitModal(
              text: 'می‌خواهی از حسابت خارج شوی؟',
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
    return ListRow(
      leading: InstituteLogo(
        logoUrl: HiveService.currentInstituteLogoUrl,
        name: HiveService.currentInstituteName ?? '',
        preset: presetFor(null),
        size: 40,
        ring: false,
      ),
      title: hasInstitute
          ? (HiveService.currentInstituteName ?? '')
          : 'هنوز انتخاب نشده',
      subtitle: 'آخرین مؤسسه‌ای که وارد شدی',
      trailing: Icon(Icons.swap_horiz_rounded, color: c.primary),
      onTap: () => CustomNavigator.pushNamed(
        InstitutesPage.routeName,
      ).then((_) => setState(() {})),
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
    final on = c.onPrimary;
    return MasirCard.brand(
      padding: const EdgeInsets.all(MasirSpace.xl - MasirSpace.xs),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: c.white,
              shape: BoxShape.circle,
              border: Border.all(color: on.withValues(alpha: 0.5), width: 4),
            ),
            child: CustomText.display(
              hasName ? name.characters.first : 'م',
              color: c.primary,
            ),
          ),
          const SizedBox(width: MasirSpace.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText.title(
                  hasName ? name : 'نامت را تنظیم کن',
                  color: on,
                  maxLines: 1,
                ),
                const SizedBox(height: MasirSpace.xs),
                if (user?.phone != null)
                  CustomText.caption(
                    faDigits(user!.phone),
                    color: on.withValues(alpha: 0.85),
                  ),
                if (user?.username != null)
                  CustomText.caption(
                    '@${user!.username}',
                    color: on.withValues(alpha: 0.85),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import '../../domain/entities/wallet_card.dart';

class WalletCardModel extends WalletCardEntity {
  const WalletCardModel({
    super.instituteId,
    super.name,
    super.slug,
    super.logoUrl,
    super.coverUrl,
    super.themePreset,
    super.memberSince,
    super.segment,
    super.nextAction,
  });

  @override
  WalletCardModel fromJson(Map<String, dynamic> json) {
    final institute = json['institute'] as Map<String, dynamic>? ?? {};
    final action = json['next_action'];
    return WalletCardModel(
      instituteId: institute['id']?.toString(),
      name: institute['name']?.toString(),
      slug: institute['slug']?.toString(),
      logoUrl: institute['logo_url']?.toString(),
      coverUrl: institute['cover_url']?.toString(),
      themePreset: institute['theme_preset']?.toString(),
      memberSince: json['member_since']?.toString(),
      segment: json['segment']?.toString(),
      nextAction: action is Map<String, dynamic>
          ? WalletNextAction(
              courseId: action['course_id']?.toString(),
              courseTitle: action['course_title']?.toString(),
              moduleTitle: action['module_title']?.toString(),
              unitId: action['unit_id']?.toString(),
              unitTitle: action['unit_title']?.toString(),
              progressPercent: (action['progress_percent'] as num?)?.toInt() ?? 0,
            )
          : null,
    );
  }
}

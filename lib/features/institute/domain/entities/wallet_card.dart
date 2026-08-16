import 'package:easy_helper/easy_helper.dart';

class WalletNextAction {
  final String? courseId;
  final String? courseTitle;
  final String? moduleTitle;
  final String? unitId;
  final String? unitTitle;
  final int progressPercent;

  const WalletNextAction({
    this.courseId,
    this.courseTitle,
    this.moduleTitle,
    this.unitId,
    this.unitTitle,
    this.progressPercent = 0,
  });
}

abstract class WalletCardEntity extends BaseResult {
  final String? instituteId;
  final String? name;
  final String? slug;
  final String? logoUrl;
  final String? coverUrl;
  final String? themePreset;
  final String? memberSince;
  final String? segment;
  final WalletNextAction? nextAction;

  const WalletCardEntity({
    this.instituteId,
    this.name,
    this.slug,
    this.logoUrl,
    this.coverUrl,
    this.themePreset,
    this.memberSince,
    this.segment,
    this.nextAction,
  });

  @override
  List<Object?> get props => [
    instituteId,
    name,
    slug,
    logoUrl,
    coverUrl,
    themePreset,
    memberSince,
    segment,
    nextAction,
  ];
}

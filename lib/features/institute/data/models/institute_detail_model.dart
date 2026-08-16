import '../../domain/entities/institute_detail.dart';

class InstituteDetailModel extends InstituteDetailEntity {
  const InstituteDetailModel({
    super.id,
    super.name,
    super.slug,
    super.type,
    super.description,
    super.intro,
    super.logoUrl,
    super.coverUrl,
    super.themePreset,
    super.foundedYear,
    super.links,
    super.topic,
    super.courseCount,
    super.studentCount,
    super.membership,
  });

  InstituteDetailModel copyWith({InstituteMembership? membership}) {
    return InstituteDetailModel(
      id: id,
      name: name,
      slug: slug,
      type: type,
      description: description,
      intro: intro,
      logoUrl: logoUrl,
      coverUrl: coverUrl,
      themePreset: themePreset,
      foundedYear: foundedYear,
      links: links,
      topic: topic,
      courseCount: courseCount,
      studentCount: studentCount,
      membership: membership ?? this.membership,
    );
  }

  @override
  InstituteDetailModel fromJson(Map<String, dynamic> json) {
    final linksRaw = json['links'];
    final topicRaw = json['topic'];
    final membershipRaw = json['membership'] as Map<String, dynamic>? ?? {};
    return InstituteDetailModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      type: json['type']?.toString(),
      description: json['description']?.toString(),
      intro: json['intro']?.toString(),
      logoUrl: json['logo_url']?.toString(),
      coverUrl: json['cover_url']?.toString(),
      themePreset: json['theme_preset']?.toString(),
      foundedYear: (json['founded_year'] as num?)?.toInt(),
      links: linksRaw is List
          ? linksRaw
                .whereType<Map<String, dynamic>>()
                .map(
                  (e) => InstituteLink(
                    kind: e['kind']?.toString(),
                    url: e['url']?.toString(),
                  ),
                )
                .toList()
          : const [],
      topic: topicRaw is Map<String, dynamic>
          ? InstituteTopic(
              id: topicRaw['id']?.toString(),
              slug: topicRaw['slug']?.toString(),
              name: topicRaw['name']?.toString(),
            )
          : null,
      courseCount: (json['course_count'] as num?)?.toInt() ?? 0,
      studentCount: (json['student_count'] as num?)?.toInt() ?? 0,
      membership: InstituteMembership(
        isMember: membershipRaw['is_member'] == true,
        memberSince: membershipRaw['member_since']?.toString(),
      ),
    );
  }
}

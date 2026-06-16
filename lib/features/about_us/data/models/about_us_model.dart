import '/features/about_us/domain/entities/about_us.dart';

class AboutUsModel extends AboutUsEntity {
  const AboutUsModel({super.id});

  @override
  AboutUsModel fromJson(Map<String, dynamic> json) {
    return AboutUsModel(id: json['id']);
  }

  Map<String, dynamic> toJson() => {"id": id};

  AboutUsModel copyWith(String? id) {
    return AboutUsModel(id: id ?? this.id);
  }
}

import 'package:easy_helper/easy_helper.dart';

abstract class InstitutesEntity extends BaseResult {
  final String? id;
  final String? name;
  final String? slug;
  final String? type;
  final String? description;
  final String? logoUrl;

  const InstitutesEntity({
    this.id,
    this.name,
    this.slug,
    this.type,
    this.description,
    this.logoUrl,
  });

  @override
  List<Object?> get props => [id, name, slug, type, description, logoUrl];
}

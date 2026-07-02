import 'package:easy_helper/easy_helper.dart';

abstract class MyInstitutesEntity extends BaseResult {
  final String? id;
  final String? name;
  final String? slug;

   const MyInstitutesEntity({this.id, this.name, this.slug});

   @override
   List<Object?> get props => [id,name,slug];
 }

import 'package:easy_helper/easy_helper.dart';

abstract class MainEntity extends BaseResult {
   final String? id;
   final String? name;
   final String? slug;

   const MainEntity({this.id, this.name, this.slug});

   @override
   List<Object?> get props => [id,name,slug];
 }

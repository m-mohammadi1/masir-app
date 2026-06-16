import 'package:easy_helper/easy_helper.dart';

abstract class EditProfileEntity extends BaseResult {
   final String? id;

   const EditProfileEntity({this.id});

   @override
   List<Object?> get props => [id];
 }

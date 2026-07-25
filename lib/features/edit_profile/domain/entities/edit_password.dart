import 'package:easy_helper/easy_helper.dart';

abstract class EditPasswordEntity extends BaseResult {
   final String? id;

   const EditPasswordEntity({this.id});

   @override
   List<Object?> get props => [id];
 }

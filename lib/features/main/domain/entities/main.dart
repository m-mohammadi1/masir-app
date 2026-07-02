import 'package:easy_helper/easy_helper.dart';

abstract class MainEntity extends BaseResult {
   final String? id;

   const MainEntity({this.id});

   @override
   List<Object?> get props => [id];
 }

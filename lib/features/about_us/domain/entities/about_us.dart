import 'package:easy_helper/easy_helper.dart';

abstract class AboutUsEntity extends BaseResult {
   final String? id;

   const AboutUsEntity({this.id});

   @override
   List<Object?> get props => [id];
 }

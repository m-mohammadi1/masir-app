import 'package:easy_helper/easy_helper.dart';

abstract class MySubscriptionsEntity extends BaseResult {
   final String? id;

   const MySubscriptionsEntity({this.id});

   @override
   List<Object?> get props => [id];
 }

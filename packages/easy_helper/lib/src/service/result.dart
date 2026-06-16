import 'package:equatable/equatable.dart';

abstract class BaseResult extends Equatable {
  const BaseResult();

  BaseResult fromJson(Map<String, dynamic> json) => BaseResult.fromJson(json);

  factory BaseResult.fromJson(Map<String, dynamic> json) {
    return BaseResult.fromJson(json);
  }

  List<BaseResult> listFromJson(List<dynamic> json) {
    return List<BaseResult>.from(json.map((e) => fromJson(e)));
  }
}

class EmptyResult extends BaseResult {
  const EmptyResult();

  @override
  EmptyResult fromJson(dynamic json) {
    return EmptyResult();
  }

  @override
  List<Object?> get props => [];
}

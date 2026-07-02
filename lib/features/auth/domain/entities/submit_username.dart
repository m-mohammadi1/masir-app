import 'package:easy_helper/easy_helper.dart';

abstract class UserEntity extends BaseResult {
  final String? id;
  final String? phone;
  final String? username;
  final String? name;

  const UserEntity({this.id, this.phone, this.username, this.name});

  @override
  List<Object?> get props => [id, phone, username, name];
}

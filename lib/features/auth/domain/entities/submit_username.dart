import 'package:easy_helper/easy_helper.dart';
import 'package:hive_ce/hive.dart';

part  'submit_username.g.dart';

@HiveType(typeId: 1)
class User extends BaseResult {

  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? phone;

  @HiveField(2)
  final String? username;

  @HiveField(3)
  final String? name;

  const User({this.id, this.phone, this.username, this.name});

  @override
  List<Object?> get props => [id, phone, username, name];
}

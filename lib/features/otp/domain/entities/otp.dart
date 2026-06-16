import 'package:easy_helper/easy_helper.dart';
import 'package:hive_ce/hive.dart';
import '../../../../core/services/hive_service.dart';

part 'otp.g.dart';

abstract class OtpEntity extends BaseResult {
  final User? user;
  final String? accessToken;

  const OtpEntity({this.user, this.accessToken});

  @override
  List<Object?> get props => [user, accessToken];
}

@HiveType(typeId: 0)
class User extends BaseResult {
  @HiveField(0)
  final String? uuid;

  @HiveField(1)
  final String? firstName;

  @HiveField(2)
  final String? lastName;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final String? mobile;

  @HiveField(5)
  final String? gender;

  @HiveField(6)
  final String? avatar;


  const User({
    this.uuid,
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.gender,
    this.avatar,
  });

  @override
  User fromJson(Map<String, dynamic> json) {
    final user = User(
      uuid: json['uuid'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'],
      mobile: json['mobile'] as String?,
      gender: json['gender'] as String?,
    );
    HiveService.setUser(user);
    return user;
  }

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'mobile': mobile,
    'gender': gender,
    'avatar': avatar,
  };

  @override
  List<Object?> get props => [
    uuid,
    firstName,
    lastName,
    email,
    mobile,
    gender,
    avatar,
  ];
}
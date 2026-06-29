import '/features/auth/domain/entities/auth.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    super.message,
  });

  @override
  AuthModel fromJson(Map<String, dynamic> json) {
    return AuthModel(
      message: json['message'],
      // isNewUser: json['is_new_user'],
      // channel: json['channel'],
      // identifier: json['identifier'],
    );
  }

  // Map<String, dynamic> toJson() => {
  //   "user_id": userId,
  //   "is_new_user": isNewUser,
  //   "channel": channel,
  //   "identifier": identifier,
  // };
}

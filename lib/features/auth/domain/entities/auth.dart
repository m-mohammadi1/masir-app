import 'package:easy_helper/easy_helper.dart';

abstract class AuthEntity extends BaseResult {
  final String? userId;
  final bool? isNewUser;
  final String? identifier, channel;

  const AuthEntity({
    this.userId,
    this.isNewUser,
    this.identifier,
    this.channel,
  });

  @override
  List<Object?> get props => [userId, isNewUser, identifier, channel];
}

import 'package:sunnah_academy/src/core/debugging/loggable.dart';

class AuthInfo {
  final String id;
  final String token;

  const AuthInfo({
    required this.id,
    required this.token,
  });

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    return AuthInfo(
      id: json['id'] ?? json["data"]['id'] ?? json["user"]["id"],
      token: json['token'] ?? json['data']['token'] ?? json['user']['token'],
    );
  }
  Map<String, dynamic> toJson() {
    logInfo("now we are converting to json");
    logInfo("id: $id token: $token");
    return {
      'id': id,
      'token': token,
    };
  }
}

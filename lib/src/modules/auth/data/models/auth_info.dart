class AuthInfo {
  final String id;
  final String token;

  const AuthInfo({
    required this.id,
    required this.token,
  });

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    return AuthInfo(
      id: json["user"]['id'].toString(),
      token: json['token'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'token': token,
    };
  }
}

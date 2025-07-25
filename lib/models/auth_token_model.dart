class AuthTokenModel {
  final String token;

  AuthTokenModel({required this.token});

  AuthTokenModel copyWith({String? token}) =>
      AuthTokenModel(token: token ?? this.token);

  factory AuthTokenModel.fromMap(Map<String, dynamic> json) =>
      AuthTokenModel(token: json["token"]);

  Map<String, dynamic> toMap() => {"token": token};
  
  // AuthTokenModel authTokenModelFromMap(String str) =>
  //     AuthTokenModel.fromMap(json.decode(str));

  // String authTokenModelToMap(AuthTokenModel data) => json.encode(data.toMap());
}

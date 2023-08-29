class AuthRequest {
  String _email;
  String _password;

  AuthRequest({
    required String email,
    required String password,
  }) : _email = email,
        _password = password;

  String get getEmail => _email;

  String get getPassword => _password;

  // create an athlete object from a json object and returns the athlete
  factory AuthRequest.fromJson(Map<String, dynamic> json) => AuthRequest(
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "email": _email,
    "password": _password,
  };

}

class SignUpUserRequest {
  int? _id;
  String _name;
  String _email;//TODO change datatype
  String _password;

  SignUpUserRequest({
    int? id,
    required String name,
    required String email,
    required String password,
  }) : _id = id,
        _name = name,
        _email = email,
        _password = password;

  int? get getId => _id;

  String get getName => _name;

  String get getEmail => _email;

  String get getPassword => _password;

  // create an athlete object from a json object and returns the athlete
  factory SignUpUserRequest.fromJson(Map<String, dynamic> json) => SignUpUserRequest(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    //"id": _id,
    "name": _name,
    "email": _email,
    "password": _password,
  };

}
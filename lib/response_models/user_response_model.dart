import 'dart:convert';

class UserResponse {
  int _id;
  String _name;
  String _email;
  String? _profilePicture;

  UserResponse({
    required int id,
    required String name,
    required String email,
    String? profilePicture,
  }) : _id = id,
        _name = name,
        _email = email,
        _profilePicture = profilePicture;

  int get getId => _id;

  String get getName => _name;

  String get getEmail => _email;

  String? get getProfilePicture => _profilePicture;

  // create an athlete object from a json object and returns the athlete
  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    profilePicture: json["profilePicture"],
  );

  static UserResponse fromJsonString(String jsonStr) {
    return UserResponse.fromJson(json.decode(jsonStr));
  }

  static String toJsonString(UserResponse user) {
    return jsonEncode(user.toJson());
  }

  Map<String, dynamic> toJson() => {
    "id": _id,
    "name": _name,
    "email": _email,
    "profilePicture": _profilePicture,
  };

}
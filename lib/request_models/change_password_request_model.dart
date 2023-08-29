
class ChangePasswordRequest {
  int _userId;
  String _oldPassword;//TODO change datatype
  String _newPassword;

  ChangePasswordRequest({
    required int userId,
    required String oldPassword,
    required String newPassword,
  }) : _userId = userId,
        _oldPassword = oldPassword,
        _newPassword = newPassword;

  int? get getId => _userId;

  String get getNewPassword => _newPassword;

  String get getOldPassword => _oldPassword;

  // create an athlete object from a json object and returns the athlete
  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => ChangePasswordRequest(
    userId: json["user_id"],
    oldPassword: json["old_password"],
    newPassword: json["new_password"],
  );

  Map<String, dynamic> toJson() => {
    //"user_id": _userId,
    "oldPassword": _oldPassword,
    "newPassword": _newPassword,
  };

}
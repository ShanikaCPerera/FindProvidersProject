
class ResetPasswordRequest {
  String _email;
  String _otp;
  String _newPassword;

  ResetPasswordRequest({
    required String email,
    required String otp,
    required String newPassword,
  }) : _email = email,
        _otp = otp,
        _newPassword = newPassword;

  String? get getEmail => _email;

  String get getOtp => _otp;

  String get getNewPassword => _newPassword;

  // create an athlete object from a json object and returns the athlete
  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => ResetPasswordRequest(
    email: json["email"],
    otp: json["otp"],
    newPassword: json["newPassword"],
  );

  Map<String, dynamic> toJson() => {
    //"user_id": _userId,
    "otp": _otp,
    "newPassword": _newPassword,
  };

}
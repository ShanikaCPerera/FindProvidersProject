class UpdateUserRequest {
  int _userId;
  String _name;

  UpdateUserRequest({
    required int userId,
    required String name,
  }) : _userId = userId,
        _name = name;

  int get getUserId => _userId;

  String get getName => _name;

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => UpdateUserRequest(
    userId: json["euserId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "userName": _name,
  };
}
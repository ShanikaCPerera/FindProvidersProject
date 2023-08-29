class SpecialityResponse {
  int _id;
  String _name;

  SpecialityResponse({
    required int id,
    required String name,
  }) : _id = id, _name = name;

  int get getId => _id;

  String get getName => _name;

  // create an athlete object from a json object and returns the athlete
  factory SpecialityResponse.fromJson(Map<String, dynamic> json) => SpecialityResponse(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": _id,
    "name": _name,
  };

  static List<SpecialityResponse> specialityListFromJson(List<dynamic> parsedJson) {
    List<SpecialityResponse> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      SpecialityResponse result = SpecialityResponse.fromJson(parsedJson[i]);
      temp.add(result);
    }
    return temp;
  }
}
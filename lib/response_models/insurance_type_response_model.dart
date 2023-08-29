class InsuranceTypeResonse {
  int _id;
  String _name;

  InsuranceTypeResonse({
    required int id,
    required String name,
  }) : _id = id, _name = name;

  int get getId => _id;

  String get getName => _name;

  // create an athlete object from a json object and returns the athlete
  factory InsuranceTypeResonse.fromJson(Map<String, dynamic> json) => InsuranceTypeResonse(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": _id,
    "name": _name,
  };

  static List<InsuranceTypeResonse> insTypeListFromJson(List<dynamic> parsedJson) {
    List<InsuranceTypeResonse> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      InsuranceTypeResonse result = InsuranceTypeResonse.fromJson(parsedJson[i]);
      temp.add(result);
    }
    return temp;
  }

}

class FindProviderResultHealthProvider {

  int _id;
  double _distance;

  FindProviderResultHealthProvider({
    required int id,
    required double distance,
  }) : _id = id, _distance = distance ;

  int get getId => _id;

  double get getDistance => _distance;

  // create an athlete object from a json object and returns the athlete
  factory FindProviderResultHealthProvider.fromJson(Map<String, dynamic> json) => FindProviderResultHealthProvider(
    id: json["id"],
    distance: json["distance"],
  );

  Map<String, dynamic> toJson() => {
    "id": _id,
    "distance": _distance,
  };

  static List<FindProviderResultHealthProvider> healthProviderResultListFromJson(List<dynamic> parsedJson) {
    List<FindProviderResultHealthProvider> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      FindProviderResultHealthProvider result = FindProviderResultHealthProvider.fromJson(parsedJson[i]);
      temp.add(result);
    }
    return temp;
  }

  static List<Map<String, dynamic>> healthProviderResultListToJson(List<FindProviderResultHealthProvider> resultList) {
    List<Map<String, dynamic>> temp = [];
    for (int i = 0; i < resultList.length; i++) {
      Map<String, dynamic> result = resultList[i].toJson();
      temp.add(result);
    }
    return temp;
  }

}
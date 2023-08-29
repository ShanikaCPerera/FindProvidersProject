import 'dart:convert';

class LoiRequest {

  String _name;
  double _longitude;
  double _latitude;
  int _athleteId;

  LoiRequest({
    required String name,
    required double longitude,
    required double latitude,
    required int athleteId,
  }) : _name = name, _longitude = longitude, _latitude = latitude, _athleteId=athleteId;

  String get getName => _name;

  double get getLongitude => _longitude;

  double get getLatitude => _latitude;

  int get getAthleteId => _athleteId;

  factory LoiRequest.fromJson(Map<String, dynamic> json) => LoiRequest(
    name: json["name"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    athleteId: json["athleteId"],
  );

  Map<String, dynamic> toJson() => {
    "athleteId": _athleteId,
    "loiName": _name,
    "latitude": _latitude,
    "longitude": _longitude,
  };

  static List<LoiRequest> loiFromJson(String str) =>
      List<LoiRequest>.from(json.decode(str).map((x) => LoiRequest.fromJson(x)));

  static List<LoiRequest> loiListFromJson(List<dynamic> parsedJson) {
      List<LoiRequest> temp = [];
      for (int i = 0; i < parsedJson.length; i++) {
        LoiRequest result = LoiRequest.fromJson(parsedJson[i]);
        temp.add(result);
      }
      return temp;
  }
}
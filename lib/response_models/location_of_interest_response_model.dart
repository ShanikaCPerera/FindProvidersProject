import 'dart:convert';

class LocationOfInterestResponse {

  int _id;
  String _name;
  double _longitude;
  double _latitude;
  //int _athleteId;

  LocationOfInterestResponse({
    required int id,
    required String name,
    required double longitude,
    required double latitude,
    //required int athleteId,
  }) : _id = id, _name = name, _longitude = longitude, _latitude = latitude ;

  int get getId => _id;

  String get getName => _name;

  double get getLongitude => _longitude;

  double get getLatitude => _latitude;

  //int get getAthleteId => _athleteId;

  factory LocationOfInterestResponse.fromJson(Map<String, dynamic> json) => LocationOfInterestResponse(
    id: json["loiId"],
    name: json["loiName"],
    longitude: json["longitude"],
    latitude: json["latitude"],
  );

  Map<String, dynamic> toJson() => {
    "id": _id,
    "name": _name,
    "longitude": _longitude,
    "latitude": _latitude,
  };

  static List<LocationOfInterestResponse> loiFromJson(String str) =>
      List<LocationOfInterestResponse>.from(json.decode(str).map((x) => LocationOfInterestResponse.fromJson(x)));

  static List<LocationOfInterestResponse> loiListFromJson(List<dynamic> parsedJson) {
      List<LocationOfInterestResponse> temp = [];
      for (int i = 0; i < parsedJson.length; i++) {
        LocationOfInterestResponse result = LocationOfInterestResponse.fromJson(parsedJson[i]);
        temp.add(result);
      }
      return temp;
  }
}
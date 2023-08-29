
import 'dart:convert';

class HealthProviderResponse {

  int _id;
  String _name;
  String _address;
  String _city;
  String _state;
  int _zip;
  double _distance;

  HealthProviderResponse({
  required int id,
  required String name,
  required String address,
  required String city,
  required String state,
  required int zip,
  required double distance,
  }) : _id = id, _name = name, _address = address, _city = city, _state = state , _zip = zip, _distance = distance ;

  int get getId => _id;

  String get getName => _name;

  String get getAddress => _address;

  String get getCity => _city;

  String get getState => _state;

  int get getZip => _zip;

  double get getDistance => _distance;

  factory HealthProviderResponse.fromJson(Map<String, dynamic> json) => HealthProviderResponse(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    zip: json["zip"],
    distance: json["distance"] + 0.0,
  );

  factory HealthProviderResponse.fromJsonForSavedResult(Map<String, dynamic> json) => HealthProviderResponse(
    id: json['athleteHCProvider']["id"],
    name: json['athleteHCProvider']["name"],
    address: json['athleteHCProvider']["address"],
    city: json['athleteHCProvider']["city"],
    state: json['athleteHCProvider']["state"],
    zip: json['athleteHCProvider']["zip"],
    distance: json["distance"]+0.0,
  );

  Map<String, dynamic> toJson() => {
    "id": _id,
    "name": _name,
    "address": _address,
    "city": _city,
    "state": _state,
    "zip": _zip,
    "distance": _distance,
  };

  static List<HealthProviderResponse> healthProviderListFromJson(List<dynamic> parsedJson) {
  List<HealthProviderResponse> temp = [];
  for (int i = 0; i < parsedJson.length; i++) {
    HealthProviderResponse result = HealthProviderResponse.fromJson(parsedJson[i]);
  temp.add(result);
  }
  return temp;
  }

  static List<HealthProviderResponse> healthProviderListFromJsonForSavedResult(List<dynamic> parsedJson) {
    List<HealthProviderResponse> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      HealthProviderResponse result = HealthProviderResponse.fromJsonForSavedResult(parsedJson[i]);
      temp.add(result);
    }
    return temp;
  }

  static List<HealthProviderResponse> healthProviderListFromJsonStr(String str) =>
      List<HealthProviderResponse>.from(json.decode(str).map((x) => HealthProviderResponse.fromJson(x)));

  static String healthProviderToJsonSTr(List<HealthProviderResponse> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

}
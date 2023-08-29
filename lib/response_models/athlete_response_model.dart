
import 'dart:convert';

import 'find_provider_result_response_model.dart';
import 'location_of_interest_response_model.dart';

class AthleteResponse {

  int _id;
  String _fname;
  String _lname;
  String? _profilePic;//TODO change datatype
  DateTime _dob;
  int _gender;
  int _classification;
  String _email;
  List<LocationOfInterestResponse>? _loiList;
  List<FindProviderResultResponse>? _providerResultList;

  AthleteResponse({
    required int id,
    required String fname,
    required String lname,
    String? profilePic,//TODO change datatype
    required DateTime dob,
    required int gender,
    required int classification,
    required String email,
    List<LocationOfInterestResponse>? loiList,
    List<FindProviderResultResponse>? providerResultList,
  }) : _id = id,
        _fname = fname,
        _lname = lname,
        _profilePic = profilePic,
        _dob = dob ,
        _gender = gender,
        _classification = classification,
        _email = email,
        _loiList = loiList,
        _providerResultList = providerResultList;

  int get getId => _id;

  String get getFname => _fname;

  String get getLname => _lname;

  String? get getProfilePicture => _profilePic;

  DateTime get getDob => _dob;

  int get getGender => _gender;

  int get getClassification => _classification;

  String get getEmail => _email;

  List<LocationOfInterestResponse>? get getLoiList => _loiList;

  List<FindProviderResultResponse>? get getProviderResultList => _providerResultList;

  String AthleteAsName() {
    return "$_fname $_lname";
  }

  // create an athlete object from a json object and returns the athlete
  factory AthleteResponse.fromJson(Map<String, dynamic> json) => AthleteResponse(
    id: json["athleteId"],
    fname: json["firstName"],
    lname: json["lastName"],
    profilePic: json["profilePicture"],
    dob: DateTime.parse(json["dob"]),
    gender: json["gender"],
    classification: json["classification"],
    email: json["email"],
    loiList: json["loiList"] != null ? LocationOfInterestResponse.loiListFromJson(json["loiList"]) : null,
    providerResultList: json["searchResults"] != null ? FindProviderResultResponse.providerResultListFromJson(json["searchResults"]) : null,
  );

  // create an athlete object from a json object and returns the athlete
  factory AthleteResponse.fromJsonForProfile(Map<String, dynamic> json) => AthleteResponse(
    id: json['athlete']["athleteId"],
    fname: json['athlete']["firstName"],
    lname: json['athlete']["lastName"],
    profilePic: json['athlete']["profilePicture"],
    dob: DateTime.parse(json['athlete']["dob"]),
    gender: json['athlete']["gender"],
    classification: json['athlete']["classification"],
    email: json['athlete']["email"],
    loiList: json["loiList"] != null ? LocationOfInterestResponse.loiListFromJson(json["loiList"]) : null,
    providerResultList: json["searchResults"] != null ? FindProviderResultResponse.providerResultListFromJson(json["searchResults"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "athleteId": _id,
    "firstName": _fname,
    "lastName": _lname,
    "profilePicture": _profilePic,
    "dob": _dob,
    "gender": _gender,
    "classification": _classification,
    "email": _email,
    "loi_list": _loiList,
    "provider_result_list": _providerResultList,
  };

  static List<AthleteResponse> athleteListFromJson(List<dynamic> parsedJson) {
    List<AthleteResponse> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      AthleteResponse result = AthleteResponse.fromJson(parsedJson[i]);
      temp.add(result);
    }
    return temp;
  }

  static List<AthleteResponse> athleteListFromJsonStr(String str) =>
      List<AthleteResponse>.from(json.decode(str).map((x) => AthleteResponse.fromJson(x)));

  static String athleteToJsonStr(List<AthleteResponse> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

}
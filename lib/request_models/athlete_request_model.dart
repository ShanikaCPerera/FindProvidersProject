import 'package:intl/intl.dart';

class AthleteRequest {
  int? _id;
  String _fname;
  String _lname;
  String? _profilePic;//TODO change datatype
  DateTime _dob;
  int _gender;
  int _classification;// the grade
  String _email;

  AthleteRequest({
    int? id,
    required String fname,
    required String lname,
    String? profilePic,//TODO change datatype
    required DateTime dob,
    required int gender,
    required int classification,
    required String email,
  }) : _id = id,
        _fname = fname,
        _lname = lname,
        _profilePic = profilePic,
        _dob = dob ,
        _gender = gender,
        _classification = classification,
        _email = email;

  int? get getId => _id;

  String get getFname => _fname;

  String get getLname => _lname;

  String? get getProfilePicture => _profilePic;

  DateTime get getDob => _dob;

  int get getGender => _gender;

  int get getClassification => _classification;

  String get getEmail => _email;

  // create an athlete object from a json object and returns the athlete
  factory AthleteRequest.fromJson(Map<String, dynamic> json) => AthleteRequest(
    id: json["id"],
    fname: json["fname"],
    lname: json["lname"],
    profilePic: json["profile_pic"],
    dob: DateTime.parse(json["dob"]),
    gender: json["gender"],
    classification: json["classification"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "firstName": _fname,
    "lastName": _lname,
    "email": _email,
    "dob": DateFormat('yyyy-MM-dd').format(_dob),
    "gender": _gender,
    "classification": _classification,
  };

}
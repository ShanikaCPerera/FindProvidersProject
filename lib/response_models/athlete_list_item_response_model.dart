import 'dart:convert';

class AthleteResponse {

  int _id;
  String _fname;
  String _lname;
  String? _profilePic;//TODO change datatype
  DateTime _dob;
  int _gender;
  int _classification;// the grade
  String _email;
  //List<LocationOfInterestResponse> _loiList;
  //List<FindProviderResultResponse>? _providerResultList;

  AthleteResponse({
    required int id,
    required String fname,
    required String lname,
    String? profilePic,//TODO change datatype
    required DateTime dob,
    required int gender,
    required int classification,
    required String email,
    //required List<LocationOfInterestResponse> loiList,
    //List<FindProviderResultResponse>? providerResultList,
  }) : _id = id,
        _fname = fname,
        _lname = lname,
        _profilePic = profilePic,
        _dob = dob ,
        _gender = gender,
        _classification = classification,
        _email = email;
        //_loiList = loiList,
        //_providerResultList = providerResultList;

  int get getId => _id;

  String get getFname => _fname;

  String get getLname => _lname;

  String? get getProfilePicture => _profilePic;

  DateTime get getDob => _dob;

  int get getGender => _gender;

  int get getClassification => _classification;

  String get getEmail => _email;

  //List<LocationOfInterestResponse> get getLoiList => _loiList;

  //List<FindProviderResultResponse>? get getProviderResultList => _providerResultList;

  String AthleteAsName() {
    return "$_fname $_lname";
  }

  // create an athlete object from a json object and returns the athlete
  factory AthleteResponse.fromJson(Map<String, dynamic> json) => AthleteResponse(
    id: json["athleteId"],
    fname: json["firstName"],
    lname: json["lastName"],
    profilePic: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fHww&w=1000&q=80", //TODO
    dob: DateTime.parse(json["dob"]),
    gender: json["gender"],
    classification: json["classification"],
    email: json["email"],
    //loiList: LocationOfInterestResponse.loiListFromJson(json["locationOfInterests"]),
    //providerResultList: FindProviderResultResponse.providerResultListFromJson(json["athleteSearchResults"]),
  );

  Map<String, dynamic> toJson() => {
    "id": _id,
    "fname": _fname,
    "lname": _lname,
    "profile_pic": _profilePic,
    "dob": _dob,
    "gender": _gender,
    "classification": _classification,
    "email": _email,
    //"loi_list": _loiList,
    //"provider_result_list": _providerResultList,
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
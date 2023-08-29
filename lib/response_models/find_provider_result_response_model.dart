
class FindProviderResultResponse{

  int _id;
  String _name;
  DateTime _savedDateTime;
  int _providerResultCount;
  //List<HealthProviderResponse>? _providerList;

  FindProviderResultResponse({
    required int id,
    required String name,
    required DateTime savedDateTime,
    required int providerResultCount,
    //List<HealthProviderResponse>? providerList,
  }) : _id = id,
        _name = name,
        _savedDateTime = savedDateTime,
        _providerResultCount = providerResultCount;
        //_providerList = providerList;

  int get getId => _id;

  String get getName => _name;

  DateTime get getSavedDateTime => _savedDateTime;

  int get getProviderResultCount => _providerResultCount;

  //List<HealthProviderResponse>? get getProviderResultList => _providerList;

  factory FindProviderResultResponse.fromJson(Map<String, dynamic> json) => FindProviderResultResponse(
    id: json["resultId"],
    name: json["name"],
    savedDateTime: DateTime.parse(json["savedDate"]),
    providerResultCount: json["resultCount"],
    //providerList: HealthProviderResponse.healthProviderListFromJson(json["healthCareProviders"]),
  );

  Map<String, dynamic> toJson() => {
    "resultId": _id,
    "name": _name,
    "savedDate": _savedDateTime,
    "resultCount": _providerResultCount,
    //"provider_list": _providerList,
  };

  static List<FindProviderResultResponse> providerResultListFromJson(List<dynamic> parsedJson) {
    List<FindProviderResultResponse> temp = [];
    for (int i = 0; i < parsedJson.length; i++) {
      FindProviderResultResponse result = FindProviderResultResponse.fromJson(parsedJson[i]);
      temp.add(result);
    }
    return temp;
  }
}
//import 'package:low_ses_health_resource_app/request_models/find_provide_request.dart';

import '../response_models/find_provider_result_health_provider_model.dart';

class ProviderListRequest {
  int _athleteId;
  bool _email;
  bool _save;
  String? _listName;
  //List<int> _providerIdList = [];
  List<FindProviderResultHealthProvider> _providerList = [];

  ProviderListRequest({
    required int athleteId,
    required bool email,
    required bool save,
    String? listName,
    required List<FindProviderResultHealthProvider> providerList
  }) : _athleteId = athleteId, _email = email, _save = save, _listName = listName, _providerList = providerList;

  List<FindProviderResultHealthProvider> get getProviderList => _providerList;

  // factory ProviderListRequest.fromJson(Map<String, dynamic> json) => ProviderListRequest(
  //   athleteId: json["athleteId"],
  //   email: json["email"],
  //   save: json["save"],
  //   listName: json["name"],
  //   providerIdList: List<int>.from(json["healthCareProviderList"]),
  // );

  // Map<String, dynamic> ProviderListRequestModel.toJson(ProviderListRequestModel data) =>
  //     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  Map<String, dynamic> toJson() => {
    "email": _email,
    "save": _save,
    "athleteId" : _athleteId,
    "name": _listName,
    "healthCareProviderList": FindProviderResultHealthProvider.healthProviderResultListToJson(_providerList),
  };

  // static String athleteToJson(List<Athlete> data) =>
  //     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

}



import 'package:low_ses_health_resource_app/response_models/location_of_interest_response_model.dart';
import 'package:low_ses_health_resource_app/services/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../request_models/loi_request_model.dart';

class LoiBloc {
  final _repository = Repository();
  final _loiListFetcher = PublishSubject<List<LocationOfInterestResponse>>();

  Future<bool> createLoi(LoiRequest loiRequest) async {
    bool response = await _repository.createNewLoi(loiRequest);
    return response;
  }

  // Future<List<LocationOfInterestResponse>> fetchLoiList(int athleteId) async {
  //   List<LocationOfInterestResponse> loiList = await _repository.fetchLoiList(athleteId).catchError((e){throw e;});
  //   return loiList;
  // }

  Future<dynamic> fetchLoiList(int athleteId) async {
    List<LocationOfInterestResponse> loiList = await _repository.fetchLoiList(athleteId).catchError((e){throw e;});
    _loiListFetcher.sink.add(loiList);
  }

  Stream<List<LocationOfInterestResponse>> get athleteLoiList => _loiListFetcher.stream;

  Future<bool> deleteLoi(int loiId) async {
    bool response = await _repository.deleteLoi(loiId).catchError((e){throw e;});
    return response;
  }

  dispose() {
  }
}

//giving access to a single instance of the MoviesBloc class to the UI screen
//final loiBloc = LoiBloc();
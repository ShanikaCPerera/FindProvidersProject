import 'package:low_ses_health_resource_app/request_models/athlete_request_model.dart';
import 'package:low_ses_health_resource_app/request_models/upload_image_request_model.dart';
import 'package:low_ses_health_resource_app/services/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:low_ses_health_resource_app/response_models/athlete_response_model.dart';

class AthleteBloc {
  final _repository = Repository();
  //PublishSubject object whose responsibility is to add the data which it got from the server
  // in the form of ItemModel object and pass it to the UI screen as a stream
  // the StreamController
  final _athleteListFetcher = PublishSubject<List<AthleteResponse>>();
  final _athleteFetcher = PublishSubject<AthleteResponse>();

  fetchAthlete(int athleteId) async {
    AthleteResponse athlete = await _repository.fetchAthlete(athleteId).catchError((e){throw e;});
    _athleteFetcher.sink.add(athlete);
  }

  Future<dynamic> fetchAllAthletes() async {
    List<AthleteResponse> athleteModelList = await _repository.fetchAthletes().catchError((e){throw e;});
    _athleteListFetcher.sink.add(athleteModelList);
  }

  //Observable replaced by Stream
  //function allAthletes() to pass the ItemModel object as stream
  Stream<List<AthleteResponse>> get allAthletes => _athleteListFetcher.stream;
  Stream<AthleteResponse> get athlete => _athleteFetcher.stream;

  Future<bool> newAthlete(AthleteRequest newAthleteRequest) async {
    bool response = await _repository.newAthlete(newAthleteRequest).catchError((e){throw e;});
    return response;
  }

  Future<bool> updateAthlete(AthleteRequest updateAthleteRequest) async {
    bool response = await _repository.updateAthlete(updateAthleteRequest).catchError((e){throw e;});
    return response;
  }

  Future<bool> uploadProfileImage(UploadImageRequest uploadAthleteImageRequest) async {
    bool response = await _repository.uploadAthleteProfileImage(uploadAthleteImageRequest).catchError((e){throw e;});
    return response;
  }

  Future<bool> deleteAthlete(int athleteId) async {
    bool response = await _repository.deleteAthlete(athleteId).catchError((e){throw e;});
    return response;
  }

  dispose() {
    _athleteListFetcher.close();
    _athleteFetcher.close();
  }
}

//giving access to a single instance of the AthleteBloc class to the UI screen
//but this cause "Bad state: Cannot add new events after calling close" when we dispose so creating an instance when creating the widget
//final athlete_bloc = AthleteBloc();
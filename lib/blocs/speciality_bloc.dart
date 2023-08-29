import 'package:low_ses_health_resource_app/services/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../response_models/speciality_response_model.dart';

class SpecialityBloc {
  final _repository = Repository();
  //PublishSubject object whose responsibility is to add the data which it got from the server
  // in the form of ItemModel object and pass it to the UI screen as a stream
  // the StreamController
  final _specialityFetcher = PublishSubject<List<SpecialityResponse>>();

  fetchAllSpecialities() async {
    List<SpecialityResponse> specialityModelList = await _repository.fetchSpecialities().catchError((e){throw e;});
    _specialityFetcher.sink.add(specialityModelList);
  }

  //Observable replaced by Stream
  //function allSpecialities() to pass the ItemModel object as stream
  Stream<List<SpecialityResponse>> get allSpecialities => _specialityFetcher.stream;

  dispose() {
    _specialityFetcher.close();
  }
}

//giving access to a single instance of the MoviesBloc class to the UI screen
//final specialityBloc = SpecialityBloc();
import 'package:low_ses_health_resource_app/services/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../response_models/insurance_type_response_model.dart';

class InsuranceTypeBloc {
  final _repository = Repository();
  //PublishSubject object whose responsibility is to add the data which it got from the server
  // in the form of ItemModel object and pass it to the UI screen as a stream
  // the StreamController
  final _insTypeFetcher = PublishSubject<List<InsuranceTypeResonse>>();

  fetchAllInsTypes() async {
    List<InsuranceTypeResonse> insTypeModelList = await _repository.fetchInsuranceTypes().catchError((e){throw e;});
    _insTypeFetcher.sink.add(insTypeModelList);
  }

  //Observable replaced by Stream
  //function allInsuranceTypes() to pass the ItemModel object as stream
  Stream<List<InsuranceTypeResonse>> get allInsuranceTypes => _insTypeFetcher.stream;

  dispose() {
    _insTypeFetcher.close();
  }
}

//giving access to a single instance of the MoviesBloc class to the UI screen
//final insTypeBloc = InsuranceTypeBloc();
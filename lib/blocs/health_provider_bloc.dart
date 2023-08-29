import 'package:low_ses_health_resource_app/request_models/find_provider_request_model.dart';
import 'package:low_ses_health_resource_app/request_models/providers_list_request_model.dart';
import 'package:low_ses_health_resource_app/services/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:low_ses_health_resource_app/response_models/health_provider_response_model.dart';


class HealthProviderBloc {
  final _repository = Repository();
  //PublishSubject object whose responsibility is to add the data which it got from the server
  // in the form of ItemModel object and pass it to the UI screen as a stream
  // the StreamController
  final _healthProviderFetcher = PublishSubject<List<HealthProviderResponse>>();
  final _savedHealthProviderFetcher = PublishSubject<List<HealthProviderResponse>>();

  fetchFilteredHealthProviders(FindProviderRequest findProviderRequest) async {
    List<HealthProviderResponse> healthProviderModelList = await _repository.fetchFilteredHealthProviderList(findProviderRequest).catchError((e){throw e;});
    _healthProviderFetcher.sink.add(healthProviderModelList);
  }

  //TODO
  fetchSavedHealthProviders(int resultId) async {
    List<HealthProviderResponse> savedHealthProviderList = await _repository.fetchSavedHealthProviders(resultId).catchError((e){throw e;});
    _savedHealthProviderFetcher.sink.add(savedHealthProviderList);
  }

  //Observable replaced by Stream
  //function allHealthProviders() to pass the ItemModel object as stream
  Stream<List<HealthProviderResponse>> get filteredHealthProviders => _healthProviderFetcher.stream;
  Stream<List<HealthProviderResponse>> get savedHealthProviders => _savedHealthProviderFetcher.stream;

  Future<bool> saveEmailFilteredProviders(ProviderListRequest providerListRequest) async {
    bool response = await _repository.saveEmailProviderResult(providerListRequest);
    return response;
  }

  dispose() {
    _healthProviderFetcher.close();
    _savedHealthProviderFetcher.close();
  }
}

//giving access to a single instance of the MoviesBloc class to the UI screen
//final healthProviderBloc = HealthProviderBloc();
import 'package:low_ses_health_resource_app/services/repository.dart';
import '../request_models/auth_request_model.dart';

class AuthBloc {
  final _repository = Repository();

  Future<bool> fetchAuthResponse(AuthRequest authRequestModel) async {
    bool success = await _repository.fetchAuthResponse(authRequestModel).catchError((e){throw e;});
    return success;
  }

  dispose() {
  }
}

//giving access to a single instance of the AuthBloc class to the UI screen
final authBloc = AuthBloc();
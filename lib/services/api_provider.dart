import 'dart:async';
import 'dart:io';
import 'package:low_ses_health_resource_app/response_models/athlete_response_model.dart';
import 'package:low_ses_health_resource_app/response_models/health_provider_response_model.dart';
import 'package:low_ses_health_resource_app/request_models/athlete_request_model.dart';
import 'package:low_ses_health_resource_app/request_models/find_provider_request_model.dart';
import 'package:low_ses_health_resource_app/services/network_handler.dart';
import '../request_models/reset_password_request_model.dart';
import '../response_models/insurance_type_response_model.dart';
import '../response_models/location_of_interest_response_model.dart';
import '../response_models/speciality_response_model.dart';
import '../response_models/user_response_model.dart';
import '../request_models/auth_request_model.dart';
import '../request_models/change_password_request_model.dart';
import '../request_models/loi_request_model.dart';
import '../request_models/providers_list_request_model.dart';
import '../request_models/update_user_request_model.dart';
import '../request_models/upload_image_request_model.dart';
import '../request_models/user_request_model.dart';
import 'auth_service.dart';

class ApiProvider {

  final networkHandler = NetworkHandler();
  final String BASE_URL = "10.0.2.2:7143";

  String _urlFormatter(String path) {
    String url = "https://$BASE_URL$path";
    return url;
  }

  Uri _uriFormatter({required String path, Map<String, dynamic>? queryParameters}) {
    Uri uri = Uri.https(BASE_URL, path, queryParameters);
    return uri;
  }

  String _jwtFormatter(String token) {
    return "Bearer $token";
  }

  //-----------------------------------Authentication--------------------------------------------

  Future<bool> authenticate(AuthRequest authRequestModel) async {
    String path = "/api/Auth/sign-in";
    String jwtToken = "";
    String refreshToken = "";
    final uri = _uriFormatter(path:path);

    try{
      var response = await networkHandler.post(
        uri: uri,
        body: authRequestModel.toJson(),
        jwtToken: ""
      );

      //store the tokens for the first time
      jwtToken = _jwtFormatter(response['token']);
      refreshToken = response['refreshToken'];
      authService.storeAccessTokenData(jwtToken);
      authService.storeRefreshTokenData(refreshToken);

      return true;

    } catch (e) {
      rethrow;
    }

  }

  //-----------------------------------User Endpoints---------------------------------------------------

  Future<bool> signUpUser(SignUpUserRequest userRequestModel) async {
    String path = "/api/Auth/sign-up";
    final uri = _uriFormatter(path:path);

    try {
      var response = await networkHandler.post(
        uri: uri,
        body: userRequestModel.toJson(),
      );

      return true;

    } catch (e) {
      rethrow;
    }
  }

  Future<UserResponse> fetchUser(String email) async {
    String path = "/api/User/get-user";
    final queryParameters = {
      'email': email,
    };
    final uri = _uriFormatter(
        path:path,
        queryParameters: queryParameters
    );
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      final responseBody = await networkHandler.get(
          uri:uri,
          jwtToken: jwtToken!,
          refreshToken: refreshToken!
      );
      return UserResponse.fromJson(responseBody);

    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateUserBasicData(UpdateUserRequest updateUserRequest) async {
    String path = "/api/User/update-user";
    final queryParameters = {
      'id': updateUserRequest.getUserId.toString(),
    };
    final uri = _uriFormatter(
        path:path,
        queryParameters: queryParameters
    );
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      var response = await networkHandler.post(
        uri: uri,
        body: updateUserRequest.toJson(),
        jwtToken: jwtToken!,
        refreshToken: refreshToken!
      );

      return true;

    } catch (e){
      rethrow;
    }

  }

  Future<bool> changeUserPassword(ChangePasswordRequest changePwRequestModel) async {
    String path = "/api/Auth/change-password/";
    final queryParameters = {
      'id': changePwRequestModel.getId.toString(),
    };
    final uri = _uriFormatter(
        path:path,
        queryParameters: queryParameters
    );
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      var response = await networkHandler.put(
        uri: uri,
        body: changePwRequestModel.toJson(),
        jwtToken: jwtToken!,
        refreshToken: refreshToken!,
      );

      return true;

    } catch (e){
      rethrow;
    }
  }

  Future<bool> forgotPassword(String userEmail) async {
    String path = "/api/Auth/forgot-password";
    final queryParameters = {
      'email': userEmail,
    };
    final uri = _uriFormatter(
        path:path,
        queryParameters: queryParameters
    );

    try {
      var response = await networkHandler.post(
        uri: uri,
      );

      return true;

    } catch (e){
      rethrow;
    }
  }

  Future<bool> resetUserPassword(ResetPasswordRequest resetPwRequestModel) async {
    String path = "/api/Auth/reset-password";
    final queryParameters = {
      'email': resetPwRequestModel.getEmail,
    };
    final uri = _uriFormatter(
        path:path,
        queryParameters: queryParameters
    );

    try {
      var response = await networkHandler.post(
        uri: uri,
        body: resetPwRequestModel.toJson(),
      );

      return true;

    } catch (e){
      rethrow;
    }
  }

  Future<bool> uploadUserProfileImage(UploadImageRequest imageUploadRequest) async{
    String path = "/api/User/upload-user-profile-picture";
    final queryParameters = {
      'id': imageUploadRequest.getEntityId.toString(),
    };
    final uri = _uriFormatter(
        path:path,
        queryParameters: queryParameters
    );
    String? jwtToken;
    String? refreshToken;

    try{
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      var response = await networkHandler.patchImage(
          uri:uri,
          imageUploadRequest: imageUploadRequest,
          jwtToken: jwtToken!,
          refreshToken: refreshToken!
      );

      return true;

    } catch (e) {
      rethrow;
    }
  }

  //-------------------------------------Athlete Endpoints-------------------------------------------------

  Future<bool> createNewAthlete(AthleteRequest athleteRequestModel) async {
    String path = "/api/Athlete/add-athlete";
    final uri = _uriFormatter(path:path);
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      var response = await networkHandler.post(
        uri: uri,
        body: athleteRequestModel.toJson(),
        jwtToken: jwtToken!,
        refreshToken: refreshToken!
      );

      return true;

    } catch (e){
      rethrow;
    }
  }

  Future<bool> updateAthlete(AthleteRequest athleteRequestModel) async {
    String path = "/api/Athlete/update-athlete";
    final queryParameters = {
      'id': athleteRequestModel.getId.toString(),
    };
    final uri = _uriFormatter(path:path, queryParameters: queryParameters);
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      var response = await networkHandler.put(
        uri: uri,
        body: athleteRequestModel.toJson(),
        jwtToken: jwtToken!,
        refreshToken: refreshToken!
      );

      return true;

    } catch (e){
      rethrow;
    }
  }

  Future<List<AthleteResponse>> fetchAthleteList() async {
    String path = "/api/Athlete/get-athlete-list";

    final uri = _uriFormatter(path:path);
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      final responseBody = await networkHandler.get(
          uri: uri,
          jwtToken: jwtToken!,
          refreshToken: refreshToken!
      );

      if (responseBody != null) {
       return AthleteResponse.athleteListFromJson(responseBody['athleteList']);
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<AthleteResponse> fetchAthlete(int athleteId) async {
    String path = "/api/Athlete/get-athlete-profile/";
    final queryParameters = {
      'athleteid': athleteId.toString(),
    };
    final uri = _uriFormatter(path:path, queryParameters: queryParameters);
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      final responseBody = await networkHandler.get(
          uri: uri,
          jwtToken: jwtToken!,
          refreshToken: refreshToken!
      );
      return AthleteResponse.fromJsonForProfile(responseBody);

    } catch (e) {
      //the exception could be even athlete not exist
      rethrow;
    }
  }

  Future<bool> uploadAthleteProfileImage(UploadImageRequest imageUploadRequest) async{
    String path = "/api/Athlete/upload-athlete-profile-picture";
    final queryParameters = {
      'athleteid': imageUploadRequest.getEntityId.toString(),
    };
    final uri = _uriFormatter(
        path:path,
        queryParameters: queryParameters
    );
    String? jwtToken;
    String? refreshToken;

    try{
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      var response = await networkHandler.patchImage(
          uri:uri,
          imageUploadRequest: imageUploadRequest,
          jwtToken: jwtToken!,
          refreshToken: refreshToken!
      );

      return true;

    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteAthlete(int athleteId) async {
    String path = "/api/Athlete/delete-athlete";
    final queryParameters = {
      'id': athleteId.toString()
    };
    final uri = _uriFormatter(
        path:path,
        queryParameters: queryParameters
    );
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      var responseBody = await networkHandler.delete(
        uri: uri,
        jwtToken: jwtToken!,
        refreshToken: refreshToken!
      );

      return true;

    } catch (e) {
      rethrow;
    }
  }

  //-----------------------------------Speciality Endpoints--------------------------------------------

  Future<List<SpecialityResponse>> fetchSpecialityList() async {
    String path = "/api/Specialty/get-specialty-list";
    final uri = _uriFormatter(path:path);
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      final responseBody = await networkHandler.get(
        uri: uri,
        jwtToken: jwtToken!,
        refreshToken: refreshToken!
      );

      if (responseBody != null) {
       return SpecialityResponse.specialityListFromJson(responseBody['specialties']);
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  //------------------------------------Insurance  Endpoints--------------------------------------------

  Future<List<InsuranceTypeResonse>> fetchInsuranceTypeList() async {
    String path = "/api/InsuranceType/get-insurance-type-list";
    final uri = _uriFormatter(path:path);
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      final responseBody = await networkHandler.get(
        uri: uri,
        jwtToken: jwtToken!,
        refreshToken: refreshToken!
      );

      if (responseBody != null) {
       return InsuranceTypeResonse.insTypeListFromJson(responseBody['insuranceTypes']);
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  //----------------------------------Health Provider Endpoints--------------------------------------------

  Future<List<HealthProviderResponse>> fetchFilteredHealthProviderList(FindProviderRequest findProviderQuery) async {
    String path = "/api/AthleteHealthCareProvider/search-health-care-providers";
    final uri = _uriFormatter(path:path);
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      final responseBody = await networkHandler.post(
        uri: uri,
        body: findProviderQuery.toJson(),
        jwtToken: jwtToken!,
        refreshToken: refreshToken!
      );

      if (responseBody != null) {
       return HealthProviderResponse.healthProviderListFromJson(responseBody['hcProviderList']);
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> saveEmailFindProviderResult(ProviderListRequest providerListRequest) async {
    String path = "/api/AthleteHealthCareProvider/save-hcp-search-result";
    final uri = _uriFormatter(
        path:path
    );
    String? jwtToken;
    String? refreshToken;

    try{
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      var success = await networkHandler.post(
        uri: uri,
        body: providerListRequest.toJson(),
        jwtToken: jwtToken!,
        refreshToken: refreshToken!
      );

      return true;

    } catch (e) {
      rethrow;
    }
  }

  Future<List<HealthProviderResponse>> fetchSavedHealthProviderList(int resultId) async {
    String path = "/api/Athlete/get-athlete-hcp-list";
    final queryParameters = {
      'resultId': resultId.toString(),
    };
    final uri = _uriFormatter(
      path:path,
      queryParameters: queryParameters,
    );
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      final responseBody = await networkHandler.get(
        uri: uri,
        jwtToken: jwtToken!,
        refreshToken: refreshToken!
      );

      if (responseBody != null) {
        return HealthProviderResponse.healthProviderListFromJsonForSavedResult(responseBody['healthCareProvidersList']);
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  //---------------------------------Locations of Interest Endpoints--------------------------------------------

  Future<bool> createNewLoi(LoiRequest loiRequestModel) async {
    String path = "/api/Loi/add-loi";
    final uri = _uriFormatter(
        path:path
    );
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      var response = await networkHandler.post(
        uri: uri,
        body: loiRequestModel.toJson(),
        jwtToken: jwtToken!,
        refreshToken: refreshToken!
      );

      return true;

    } catch (e){
      rethrow;
    }
  }

  Future<List<LocationOfInterestResponse>> fetchLoiList(int athleteId) async {
    String path = "/api/Loi/get-loi-list";
    final queryParameters = {
      'id': athleteId.toString()
    };
    final uri = _uriFormatter(
        path:path,
        queryParameters: queryParameters
    );
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      final responseBody = await networkHandler.get(
        uri: uri,
        jwtToken: jwtToken!,
        refreshToken: refreshToken!
      );

      if (responseBody != null) {
        return LocationOfInterestResponse.loiListFromJson(responseBody['loiList']);
      }
      return [];

    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteLoi(int loiId) async {
    String path = "/api/Loi/delete-loi";
    final queryParameters = {
      'id': loiId.toString()
    };
    final uri = _uriFormatter(
        path:path,
        queryParameters: queryParameters
    );
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      var responseBody = await networkHandler.delete(
        uri: uri,
        jwtToken: jwtToken!,
        refreshToken: refreshToken!
      );

      return true;

    } catch (e) {
      rethrow;
    }
  }

  //-------------------------------------Social Determinants Endpoints-------------------------------------------------

  Future<bool> downloadSocialDetSurveyTemplate(Directory directory, String fileName) async{

    String path = "/api/Downloads/download-document";
    final queryParameters = {
      'fileName': fileName,
    };
    final url = _urlFormatter(path);
    String? jwtToken;
    String? refreshToken;

    try {
      jwtToken = await authService.getAccessTokenData();
      refreshToken = await authService.getRefreshTokenData();

      var response = await networkHandler.downloadFile(
          url: url,
          directory: directory,
          fileNameToBeSaved: fileName,
          queryParameters: queryParameters,
          jwtToken: jwtToken!,
          refreshToken: refreshToken!
      );

      return true;

    } catch (e) {
      rethrow;
    }

  }
}
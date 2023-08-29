import 'dart:async';
import 'dart:io';
import 'package:low_ses_health_resource_app/request_models/providers_list_request_model.dart';
import 'package:low_ses_health_resource_app/request_models/upload_image_request_model.dart';
import 'package:low_ses_health_resource_app/response_models/location_of_interest_response_model.dart';
import 'package:low_ses_health_resource_app/services/api_provider.dart';
import 'package:low_ses_health_resource_app/response_models/athlete_response_model.dart';
import 'package:low_ses_health_resource_app/response_models/health_provider_response_model.dart';
import 'package:low_ses_health_resource_app/request_models/find_provider_request_model.dart';

import '../request_models/reset_password_request_model.dart';
import '../response_models/insurance_type_response_model.dart';
import '../response_models/speciality_response_model.dart';
import '../response_models/user_response_model.dart';
import '../request_models/athlete_request_model.dart';
import '../request_models/auth_request_model.dart';
import '../request_models/change_password_request_model.dart';
import '../request_models/loi_request_model.dart';
import '../request_models/update_user_request_model.dart';
import '../request_models/user_request_model.dart';

//Repository class is the central point from where the data will flow to the BLOC

class Repository {
  final apiProvider = ApiProvider();

  //Authorization Data flows
  Future<bool> fetchAuthResponse(AuthRequest authRequestModel) async => await apiProvider.authenticate(authRequestModel).catchError((e){throw e;});

  //User Data flows
  Future<UserResponse> fetchUser(String email) async => await apiProvider.fetchUser(email).catchError((e){throw e;});
  Future<bool> signUpUser(SignUpUserRequest userRequestModel) async => await apiProvider.signUpUser(userRequestModel);
  Future<bool> updateUser(UpdateUserRequest updateUserRequest) async => await apiProvider.updateUserBasicData(updateUserRequest);
  Future<bool> uploadUserProfileImage(UploadImageRequest uploadAthleteImageRequest) => apiProvider.uploadUserProfileImage(uploadAthleteImageRequest);
  Future<bool> changeUserPassword(ChangePasswordRequest changePwRequestModel) async => await apiProvider.changeUserPassword(changePwRequestModel).catchError((e){throw e;});
  Future<bool> forgotUserPassword(String userEmail) async => await apiProvider.forgotPassword(userEmail).catchError((e){throw e;});
  Future<bool> resetUserPassword(ResetPasswordRequest resetPwRequestModel) async => await apiProvider.resetUserPassword(resetPwRequestModel).catchError((e){throw e;});
  Future<bool> uploadAthleteProfileImage(UploadImageRequest uploadAthleteImageRequest) => apiProvider.uploadAthleteProfileImage(uploadAthleteImageRequest);
  Future<bool> downloadSocialDetSurveyTemplate(Directory directory, String fileName) => apiProvider.downloadSocialDetSurveyTemplate(directory, fileName).catchError((e){throw e;});

  //Athlete Data flows
  Future<List<AthleteResponse>> fetchAthletes() async => await apiProvider.fetchAthleteList().catchError((e){throw e;});
  Future<bool> newAthlete(AthleteRequest newAthleteRequestModel) async => await apiProvider.createNewAthlete(newAthleteRequestModel);
  Future<bool> updateAthlete(AthleteRequest updateAthleteRequestModel) async => await apiProvider.updateAthlete(updateAthleteRequestModel);
  Future<AthleteResponse> fetchAthlete(int athleteId) async => await apiProvider.fetchAthlete(athleteId).catchError((e){throw e;});
  // Future<bool> uploadSocialDetSurveyAnswer(UploadFileRequest uploadFileRequest) => apiProvider.uploadSocialDetSurveyAnswer(uploadFileRequest);
  Future<bool> deleteAthlete(int athleteId) async => await apiProvider.deleteAthlete(athleteId).catchError((e){throw e;});

  //Location Of Interest flows
  Future<bool> createNewLoi(LoiRequest loiRequestModel) async => await apiProvider.createNewLoi(loiRequestModel);
  Future<List<LocationOfInterestResponse>> fetchLoiList(int athleteId) async => await apiProvider.fetchLoiList(athleteId).catchError((e){throw e;});
  Future<bool> deleteLoi(int loiId) async => await apiProvider.deleteLoi(loiId).catchError((e){throw e;});

  //Speciality Data flows
  Future<List<SpecialityResponse>> fetchSpecialities() async => await apiProvider.fetchSpecialityList().catchError((e){throw e;});

  //Insurance Type Data flows
  Future<List<InsuranceTypeResonse>> fetchInsuranceTypes() async => await apiProvider.fetchInsuranceTypeList().catchError((e){throw e;});

  //Health Provider data flows
  Future<List<HealthProviderResponse>> fetchFilteredHealthProviderList(FindProviderRequest findProviderRequest) async => await apiProvider.fetchFilteredHealthProviderList(findProviderRequest).catchError((e){throw e;});
  Future<bool> saveEmailProviderResult(ProviderListRequest providerListRequest) async => await apiProvider.saveEmailFindProviderResult(providerListRequest).catchError((e){throw e;});
  Future<List<HealthProviderResponse>> fetchSavedHealthProviders(int resultId) async => await apiProvider.fetchSavedHealthProviderList(resultId).catchError((e){throw e;});
}
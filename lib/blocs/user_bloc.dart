import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:low_ses_health_resource_app/request_models/upload_image_request_model.dart';
import 'package:low_ses_health_resource_app/services/repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../request_models/reset_password_request_model.dart';
import '../response_models/user_response_model.dart';
import '../request_models/change_password_request_model.dart';
import '../request_models/update_user_request_model.dart';
import '../request_models/user_request_model.dart';
import '../utility/utility.dart';

class UserBloc {
  final _repository = Repository();

  Future<UserResponse> fetchUser(String email) async {
    UserResponse authUser = await _repository.fetchUser(email);
    return authUser;
  }

  Future<bool> updateUser(UpdateUserRequest userUpdateRequestModel) async {
    bool success = await _repository.updateUser(userUpdateRequestModel);
    return success;
  }

  Future<bool> uploadProfileImage(UploadImageRequest uploadAthleteImageRequest) async {
    bool success = await _repository.uploadUserProfileImage(uploadAthleteImageRequest);
    return success;
  }

  Future<bool> signUpUser(SignUpUserRequest userRequestModel) async {
    bool success = await _repository.signUpUser(userRequestModel);
    return success;
  }

  Future<bool> changeUserPassword(ChangePasswordRequest changePwRequestModel) async {
    bool success = await _repository.changeUserPassword(changePwRequestModel).catchError((e){throw e;});
    return success;
  }

  Future<bool> forgotUserPassword(String userEmail) async {
    bool success = await _repository.forgotUserPassword(userEmail).catchError((e){throw e;});
    return success;
  }

  Future<bool> resetUserPassword(ResetPasswordRequest resetPwRequestModel) async {
    bool success = await _repository.resetUserPassword(resetPwRequestModel).catchError((e){throw e;});
    return success;
  }

  // Future<bool> uploadSocialDetSurveyAnswer(UploadFileRequest uploadFileRequest) async {
  //   bool response = await _repository.uploadSocialDetSurveyAnswer(uploadFileRequest);
  //   return response;
  // }

  Future<bool> downloadSocialDetSurveyTemplate(String fileName) async {
    Directory? directory;
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;

    try{
      if(Platform.isAndroid){
        final isStoragePermissionGranted = android.version.sdkInt < 33
            ? await Utility.requestPermission(Permission.storage)
            : true;
        if(isStoragePermissionGranted) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          List<String> folders = directory!.path.split("/");
          for(int x = 1; x<folders.length; x++){
            String folder = folders[x];
            if(folder != "Android") {
              newPath += "/$folder";
            }
            else{
              break;
            }
          }
          newPath = "$newPath/Download";
          directory = Directory(newPath);
        }
      } else{
        if(await Utility.requestPermission(Permission.photos)) {
          directory = await getApplicationDocumentsDirectory();
        }
      }
    }catch (e, stacktrace) {
      if (kDebugMode) {
        print(e.toString());
        print(stacktrace);
      }
    }

    bool response = await _repository.downloadSocialDetSurveyTemplate(directory!, fileName).catchError((e){throw e;});
    return response;
  }

  dispose() {
  }
}

//giving access to a single instance of the MoviesBloc class to the UI screen
final userBloc = UserBloc();
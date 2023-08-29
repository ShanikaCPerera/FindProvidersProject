import 'package:low_ses_health_resource_app/blocs/auth_bloc.dart';
import 'package:low_ses_health_resource_app/services/auth_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../blocs/user_bloc.dart';

class Utility{

  static void cleanAtLogOut(){

    //disposing instances of BLOC classes - done in widgets
    authBloc.dispose();
    userBloc.dispose();

    //clearing the token
    authService.clearTokenData();
  }

  static Future<bool> requestPermission(Permission permission) async{
    if(await permission.isGranted){
      //print("isgranted");
      return true;
    } else {
      //print(" not granted");
      var result = await permission.request();
      //print(result.toString());
      if(result == PermissionStatus.granted){
        return true;
      } else {
        return false;
      }
    }
  }
}

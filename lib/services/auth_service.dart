import 'package:shared_preferences/shared_preferences.dart';
import '../response_models/user_response_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService{

  final storage = const FlutterSecureStorage();

  Future<void> storeAccessTokenData(String accessTokenStr) async {
    await storage.write(
        key: "accessToken",
        value: accessTokenStr
    );
  }

  Future<void> storeRefreshTokenData(String refreshTokenStr) async {
    await storage.write(
        key: "refreshToken",
        value: refreshTokenStr
    );
  }


  Future<String?> getAccessTokenData() async {
    return await storage.read(key: "accessToken");
  }

  Future<String?> getRefreshTokenData() async {
    return await storage.read(key: "refreshToken");
  }

  void clearTokenData() async {
    await storage.deleteAll();
  }

  Future<void> storeAuthUserData(UserResponse authUser) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('auth_user_id', authUser.getId);
    preferences.setString('auth_user_email', authUser.getEmail);
    preferences.setString('auth_user', UserResponse.toJsonString(authUser));
  }

  Future<UserResponse> getAuthUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return UserResponse.fromJsonString(preferences.getString('auth_user')!);
  }

  Future<int> getAuthUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt('auth_user_id')!;
  }

  Future<String> getAuthUserEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('auth_user_email')!;
  }

}

final authService = AuthService();
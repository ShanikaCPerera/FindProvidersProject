import 'dart:io';
import 'package:flutter/material.dart';
import 'package:low_ses_health_resource_app/forms/change_password.dart';
import 'package:low_ses_health_resource_app/forms/find_providers.dart';
import 'package:low_ses_health_resource_app/forms/signin.dart';
import 'package:low_ses_health_resource_app/pages/home.dart';
import 'package:low_ses_health_resource_app/app_colors.dart';
import 'package:low_ses_health_resource_app/forms/signup.dart';
import 'package:low_ses_health_resource_app/forms/update_user_account.dart';
import 'package:low_ses_health_resource_app/pages/social_determinants.dart';
import 'package:low_ses_health_resource_app/pages/user_settings.dart';
import 'package:low_ses_health_resource_app/pages/athlete_list.dart';

import 'forms/forgot_password.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  // SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());

  HttpOverrides.global = MyHttpOverrides();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Low SES Health Resource App',
    theme: ThemeData(
      scaffoldBackgroundColor: AppColor.primaryBackgroundColor,
      primaryColor: AppColor.primaryThemeColor,
      //textTheme: Theme.of(context).textTheme.apply(bodyColor: primaryTextColor),
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => const SignIn(),
      '/signup': (context) => const SignUp(),
      '/home': (context) => const Home(),
      '/find_providers': (context) => const FindProviders(),
      '/user_settings': (context) => const UserSettings(),
      '/athlete_profiles': (context) => const AthleteList(),
      '/user_account': (context) => const UserAccount(),
      '/change_password': (context) => const ChangePassword(),
      '/social_determinants': (context) => const SocialDeterminants(),
      '/forgot_password': (context) => const ForgotPassword(),
    },
  ));
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:low_ses_health_resource_app/blocs/user_bloc.dart';
import 'package:low_ses_health_resource_app/request_models/auth_request_model.dart';
import '../app_colors.dart';
import '../blocs/auth_bloc.dart';
import '../response_models/user_response_model.dart';
import '../services/auth_service.dart';

class Loading extends StatefulWidget {

  final String email;
  final String password;

  const Loading({super.key, required this.email, required this.password});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  late bool authResponse;

  @override
  void initState() {
    super.initState();
    emailSignIn();
  }

  void emailSignIn() async
  {
    if (!context.mounted) return;
    AuthRequest authRequestModel = AuthRequest(
        email: widget.email,
        password: widget.password);

    try {
      //fetch authentication response
      authResponse = await authBloc.fetchAuthResponse(authRequestModel);

      //fetch user if authentication is successful
      if (authResponse) {
        Future<UserResponse> authUser = userBloc.fetchUser(widget.email);
        //save user data in shared pref
        authService.storeAuthUserData(await authUser);

        if (context.mounted) Navigator.pushReplacementNamed(context, '/home');
      }

    }catch (e, stacktrace){
      if (kDebugMode) {
        print(e.toString());
        print(stacktrace.toString());
      }

      //returning the error back to sign-in page
      Navigator.pop(context, {'error': e});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: const Center(
        child: CupertinoActivityIndicator(
          color: AppColor.primaryThemeColor,
          radius: 20,
          animating: true,
        ),
      ),
    );
  }
}




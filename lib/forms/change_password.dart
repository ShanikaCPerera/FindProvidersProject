import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:low_ses_health_resource_app/app_colors.dart';
import 'package:low_ses_health_resource_app/utility/ui_messages.dart';
import '../blocs/user_bloc.dart';
import '../request_models/change_password_request_model.dart';
import '../services/auth_service.dart';
import '../services/exception_handler.dart';
import '../utility/utility.dart';
import '../utility/utility_widgets.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final _oldPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _confirmNewPwController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePw = true; // Initially password is obscure
  bool _obscureConfPw = true; // Initially confirm password is obscure

  Future<void> changePassword() async {
    bool response;
    int authUserId = await authService.getAuthUserId();

    ChangePasswordRequest changePwRequest = ChangePasswordRequest(
      userId: authUserId,
      oldPassword: _oldPwController.text.trim(),
      newPassword: _newPwController.text.trim());

    try {
      response = await userBloc.changeUserPassword(changePwRequest);
      if (response) {
        if (context.mounted) UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_CHANGE_PASSWORD);
        if (context.mounted) Navigator.pop(context);
      }

    } catch(e, stacktrace){
      if (kDebugMode) {
        print(e.toString());
        print(stacktrace.toString());
      }

      if (e is UnAuthorizedException){
        if (context.mounted) Navigator.popUntil(context, ModalRoute.withName('/'));
        if (context.mounted) UtilityWidgets.showFloatingErrorToast(context, ExceptionHandlers().getExceptionString(e));
        Utility.cleanAtLogOut();
      } else if (e is SessionTimeOutException){
        if (context.mounted) Navigator.popUntil(context, ModalRoute.withName('/'));
        if (context.mounted) UtilityWidgets.showFloatingErrorToast(context, ExceptionHandlers().getExceptionString(e));
        Utility.cleanAtLogOut();
      } else {
        if (context.mounted) UtilityWidgets.showErrorToast(context, ExceptionHandlers().getExceptionString(e));
      }
    }
  }

  void navigateSignIn()
  {
    Navigator.pushReplacementNamed(context, '/');
  }
  bool isValidPassword(String password){
    String password0 = password.trim();
    //final passwordRegExp = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W).{8,}');
    final passwordRegExp = RegExp(r'^(?=.*\d)(?=.*[A-z]).{8,}');
    return passwordRegExp.hasMatch(password0);
  }

  // Toggles the password show status
  void _toggleObscurePw() {
    setState(() {
      _obscurePw = !_obscurePw;
    });
  }

  // Toggles the password show status
  void _toggleObscureConfPw() {
    setState(() {
      _obscureConfPw = !_obscureConfPw;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryBackgroundColor,
        elevation: 0,
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: AppColor.titleTextColor,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon:const Icon(
            Icons.close,
            color: AppColor.darkIconColor,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if(_formKey.currentState!.validate())
              {
                changePassword();
              }
            },

            child: const Text("Done"),
          ),
        ],
      ),
      backgroundColor: AppColor.primaryBackgroundColor,
      body: SingleChildScrollView (
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24.0),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:15.0),
                child: Column(
                  children: [
                    //Old Password field
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Old Password',
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _oldPwController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'\s')),
                        LengthLimitingTextInputFormatter(20),
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if (value == null || value.isEmpty)
                        {
                          return UiMessage.NO_EMPTY_PASSWORD;
                        }
                        else {
                          return null;
                        }
                      },
                      //obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.inputFieldEnabledBorderColor,
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.inputFieldFocusBorderColor,
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Enter old password',
                        hintStyle: const TextStyle(
                            color: AppColor.hintTextColor
                        ),
                        //fillColor: Colors.grey[200],
                        //filled: true,
                        errorMaxLines: 3,
                        suffixIcon: IconButton(
                          onPressed: _oldPwController.clear,
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    //New Password field
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'New Password',
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _newPwController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'\s')),
                        LengthLimitingTextInputFormatter(20),
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if (value == null || value.isEmpty || !(isValidPassword(value)))
                        {
                          return UiMessage.INVALID_PASSWORD;
                        }
                        else if(_oldPwController.text.isNotEmpty && _oldPwController.text != null && value == _oldPwController.text) {
                          return UiMessage.INVALID_NEW_PASSWORD;
                        }
                        else {
                          return null;
                        }
                      },
                      obscureText: _obscurePw,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.inputFieldEnabledBorderColor,
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.inputFieldFocusBorderColor,
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Enter new password',
                        hintStyle: const TextStyle(
                            color: AppColor.hintTextColor
                        ),
                        //fillColor: Colors.grey[200],
                        //filled: true,
                        errorMaxLines: 3,
                        suffixIcon: IconButton(
                          onPressed: _toggleObscurePw,
                          icon: _obscurePw? const Icon(Icons.visibility,
                            color: AppColor.lightIconColor,)
                              :const Icon(Icons.visibility_off,
                            color: AppColor.lightIconColor,),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    //Confirm new password field
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Confirm Password',
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _confirmNewPwController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'\s')),
                        LengthLimitingTextInputFormatter(20),
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if (value == null || value.isEmpty || value != _newPwController.text)
                        {
                          return UiMessage.INVALID_PASSWORD_CONFIRMATION;
                        }
                        else {
                          return null;
                        }
                      },
                      obscureText: _obscureConfPw,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.inputFieldEnabledBorderColor,
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: AppColor.inputFieldFocusBorderColor,
                              width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Confirm new password',
                        hintStyle: const TextStyle(
                            color: AppColor.hintTextColor
                        ),
                        //fillColor: Colors.grey[200],
                        //filled: true,
                        suffixIcon: IconButton(
                          onPressed: _toggleObscureConfPw,
                          icon: _obscureConfPw? const Icon(Icons.visibility,
                            color: AppColor.lightIconColor,)
                              :const Icon(Icons.visibility_off,
                            color: AppColor.lightIconColor,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

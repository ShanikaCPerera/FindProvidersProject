import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:low_ses_health_resource_app/app_colors.dart';
import 'package:low_ses_health_resource_app/utility/ui_messages.dart';
import '../blocs/user_bloc.dart';
import '../request_models/reset_password_request_model.dart';
import '../services/exception_handler.dart';
import '../utility/utility_widgets.dart';

class ResetPassword extends StatefulWidget {
  final String userEmail;

  const ResetPassword({
    super.key,
    required this.userEmail
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final _otpController = TextEditingController();
  final _newPwController = TextEditingController();
  final _confirmNewPwController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isWaitingForApi = false;

  bool _obscurePw = true; // Initially password is obscure
  bool _obscureConfPw = true; // Initially confirm password is obscure

  Future<void> resetPassword() async {
    bool response;
    //int authUserId = await authService.getAuthUserId();

    ResetPasswordRequest resetPwRequest = ResetPasswordRequest(
      email: widget.userEmail,
      otp: _otpController.text.trim(),
      newPassword: _newPwController.text.trim());

    try {
      setState(() {
        _isWaitingForApi=true;
      });

      response = await userBloc.resetUserPassword(resetPwRequest);

      setState(() {
        _isWaitingForApi=false;
      });

      if (response) {
        if (context.mounted) UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_RESET_PASSWORD);
        if (context.mounted) Navigator.popUntil(context, ModalRoute.withName('/'));
      }

    } catch(e, stacktrace){
      setState(() {
        _isWaitingForApi=false;
      });

      if (kDebugMode) {
        print(e.toString());
        print(stacktrace.toString());
      }
      UtilityWidgets.showErrorToast(context, ExceptionHandlers().getExceptionString(e));
    }
  }

  void sendVerificationCode(String userEmail) async {
    bool response;

    try {
      setState(() {
        _isWaitingForApi=true;
      });

      response = await userBloc.forgotUserPassword(userEmail);

      setState(() {
        _isWaitingForApi=false;
      });

      if (response) {
        if (context.mounted) UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_OTP);

        if (context.mounted) {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              ResetPassword(userEmail: userEmail)
          ),
        );
        }
      }

    } catch(e, stacktrace){
      setState(() {
        _isWaitingForApi=false;
      });

      if (kDebugMode) {
        print(e.toString());
        print(stacktrace.toString());
      }
      UtilityWidgets.showErrorToast(context, ExceptionHandlers().getExceptionString(e));
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
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.primaryBackgroundColor,
            elevation: 0,
            title: const Text(
              'Reset Password',
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
                Icons.keyboard_arrow_left,
                color: AppColor.darkIconColor,
              ),
            ),
          ),
          backgroundColor: AppColor.primaryBackgroundColor,
          body: SingleChildScrollView (
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:15.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30,),
                    //OTP field
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Verification Code',
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    //OTP
                    TextFormField(
                      controller: _otpController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'\d')),
                      ],
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return UiMessage.NO_EMPTY_OTP;
                        } else if(value.length < 6) {
                          return UiMessage.INVALID_OTP;
                        }else {
                          return null;
                        }
                      },
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
                        hintText: 'Enter verification code',
                        hintStyle: const TextStyle(
                            color: AppColor.hintTextColor
                        ),
                        suffixIcon: IconButton(
                          onPressed: _otpController.clear,
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
                    //resend OTP text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            "Didn't receive a code?",
                            style: TextStyle(
                              color: AppColor.primaryTextColor,
                              fontSize: 16.0,
                            )
                        ),
                        InkWell(
                          onTap: () {
                            sendVerificationCode(widget.userEmail);
                          },
                          child: const Text(
                            ' Resend',
                            style: TextStyle(
                              color: AppColor.primaryThemeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
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
                        suffixIcon: IconButton(
                          onPressed: _toggleObscureConfPw,
                          icon: _obscureConfPw? const Icon(Icons.visibility,
                            color: AppColor.lightIconColor,)
                              :const Icon(Icons.visibility_off,
                            color: AppColor.lightIconColor,),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                        onPressed: () {
                           if (_formKey.currentState!.validate()) {
                             resetPassword();
                           }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(20),
                          padding: const EdgeInsets.symmetric(vertical: 17),
                          backgroundColor: AppColor.primaryThemeColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(
                            color: AppColor.buttonTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if(_isWaitingForApi)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(
                dismissible: false,
                color: AppColor.processingBackgroundColor
            ),
          ),
        if(_isWaitingForApi)
          const Center(
            // child: CircularProgressIndicator(
            //     color: AppColor.primaryThemeColor
            // ),
              child: CupertinoActivityIndicator(
                color: AppColor.primaryThemeColor,
                radius: 20,
                animating: true,
              )
          ),
      ],
    );
  }
}

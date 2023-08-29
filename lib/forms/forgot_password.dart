import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:low_ses_health_resource_app/forms/reset_password.dart';

import '../app_colors.dart';
import '../blocs/user_bloc.dart';
import '../services/exception_handler.dart';
import '../utility/ui_messages.dart';
import '../utility/utility_widgets.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isWaitingForApi = false;

  void sendVerificationCode(String userEmail) async {
    bool response;

    try {
      setState(() {
        _isWaitingForApi=true;
      });

      response = await userBloc.forgotUserPassword(userEmail);
      if (response) {
        setState(() {
          _isWaitingForApi=false;
        });
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.primaryBackgroundColor,
            elevation: 0,
            title: const Text(
              'Forgot Password?',
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
                    //email filed
                    const Text(
                      textAlign: TextAlign.center,
                      'Enter the email address associated with your account.',
                      style: TextStyle(
                        color: AppColor.primaryTextColor,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: _emailController,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(
                            RegExp(r'\s')),
                        LengthLimitingTextInputFormatter(50),
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return UiMessage.NO_EMPTY_EMAIL;
                        }else if (!(EmailValidator.validate(value!))) {
                          return UiMessage.INVALID_EMAIL;
                        }
                        else
                        {
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
                        hintText: 'Enter your email',
                        hintStyle: const TextStyle(
                            color: AppColor.hintTextColor
                        ),
                        suffixIcon: IconButton(
                          onPressed: _emailController.clear,
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                            sendVerificationCode(_emailController.text.trim());
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
                        'Send Verification Code',
                        style: TextStyle(
                          color: AppColor.buttonTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      textAlign: TextAlign.center,
                      'A verification code will be sent to your email address for verification.',
                      style: TextStyle(
                        color: AppColor.secondaryTextColor,
                        //fontSize: 16.0,
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

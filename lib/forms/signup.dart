import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:low_ses_health_resource_app/app_colors.dart';
import 'package:low_ses_health_resource_app/utility/ui_messages.dart';
import '../blocs/user_bloc.dart';
import '../pages/loading.dart';
import '../request_models/user_request_model.dart';
import '../services/exception_handler.dart';
import '../utility/utility_widgets.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPwController = TextEditingController();
  bool _obscurePw = true; // Initially password is obscure
  bool _obscureConfPw = true; // Initially confirm password is obscure
  bool _isWaitingForApi = false;

  void signUp() async {
    bool response;

    SignUpUserRequest newUserRequest = SignUpUserRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim());

    try {
      setState(() {
        _isWaitingForApi=true;
      });

      response = await userBloc.signUpUser(newUserRequest);

      setState(() {
        _isWaitingForApi=false;
      });

      if (response) {
        if (context.mounted) {
          //send email and password to the loading screen
          //only this way of navigating works for opaque loading screen
          Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) {
              return Loading(email: newUserRequest.getEmail.trim(),
                  password: newUserRequest.getPassword.trim());
            },
          ),
        );
        }
      }
    } catch (e, stacktrace) {
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
          backgroundColor: AppColor.primaryBackgroundColor,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView (
                child: Padding(
                  padding: const EdgeInsets.symmetric( horizontal:25.0,),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Low SES Health Resource App',
                        style: TextStyle(
                          color: AppColor.titleTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //Name field
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Name',
                                style: TextStyle(
                                  color: AppColor.primaryTextColor,
                                ),
                              ),
                            ),
                            const SizedBox(height:8),
                            TextFormField(
                              controller: _nameController,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[A-z ]')),
                                LengthLimitingTextInputFormatter(50),
                              ],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value){
                                if (value == null || value.isEmpty)
                                {
                                  return UiMessage.NO_EMPTY_NAME;
                                }
                                else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColor.inputFieldEnabledBorderColor
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColor.inputFieldFocusBorderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                hintText: 'Enter name',
                                hintStyle: const TextStyle(
                                    color: AppColor.hintTextColor,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: _nameController.clear,
                                  icon: const Icon(Icons.clear),
                                ),
                                //fillColor: Colors.grey[200],
                                //filled: true,
                              ),
                            ),
                            const SizedBox(height:20),
                            //email field
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  color: AppColor.primaryTextColor,
                                ),
                              ),
                            ),
                            const SizedBox(height:8),
                            TextFormField(
                              controller: _emailController,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'\s')),
                                LengthLimitingTextInputFormatter(50),
                              ],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value){
                                if(!(EmailValidator.validate(value!)))
                                {
                                  return UiMessage.INVALID_EMAIL;
                                }
                                else
                                {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColor.inputFieldEnabledBorderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColor.inputFieldFocusBorderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                hintText: 'Enter email',
                                hintStyle: const TextStyle(
                                    color: AppColor.hintTextColor,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: _emailController.clear,
                                  icon: const Icon(Icons.clear),
                                ),
                                //fillColor: AppColor.inputFieldFillColor,
                                //: true,
                              ),
                            ),
                            const SizedBox(height:20),
                            //Password field
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  color: AppColor.primaryTextColor,
                                ),
                              ),
                            ),
                            const SizedBox(height:8),
                            TextFormField(
                              controller: _passwordController,
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
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColor.inputFieldFocusBorderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                hintText: 'Enter password',
                                hintStyle: const TextStyle(
                                    color: AppColor.hintTextColor,
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
                            const SizedBox(height:20),
                            //Confirm password field
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Confirm password',
                                style: TextStyle(
                                  color: AppColor.primaryTextColor,
                                ),
                              ),
                            ),
                            const SizedBox(height:8),
                            TextFormField(
                              controller: _confirmPwController,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'\s')),
                                LengthLimitingTextInputFormatter(50),
                              ],
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value){
                                if (value == null || value.isEmpty || value != _passwordController.text)
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
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColor.inputFieldFocusBorderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                hintText: 'Confirm Password',
                                hintStyle: const TextStyle(
                                    color: AppColor.hintTextColor,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: _toggleObscureConfPw,
                                  icon: _obscureConfPw? const Icon(Icons.visibility,
                                    color: AppColor.lightIconColor,)
                                      :const Icon(Icons.visibility_off,
                                    color: AppColor.lightIconColor,),
                                ),
                                //fillColor: Colors.grey[200],
                                //filled: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      //sign up button
                      GestureDetector(
                        onTap: () {
                          if(_formKey.currentState!.validate()) {
                            signUp();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: AppColor.primaryThemeColor,
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: const Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColor.buttonTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      //not registered option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: AppColor.primaryTextColor,
                              )
                          ),
                          InkWell(
                            onTap: () {
                              navigateSignIn();
                            },
                            child: const Text(
                              ' Sign In',
                              style: TextStyle(
                                color: AppColor.primaryThemeColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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

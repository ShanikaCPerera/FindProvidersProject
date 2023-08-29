import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:low_ses_health_resource_app/pages/loading.dart';
import 'package:low_ses_health_resource_app/app_colors.dart';
import 'package:low_ses_health_resource_app/utility/ui_messages.dart';
import '../services/exception_handler.dart';
import '../utility/utility_widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePw = true; // Initially password is obscure

  void signIn () async
  {

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    //removing all current snack bars
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    //un-focusing the cursor
    FocusScope.of(context).unfocus();

    //send email and password to the loading screen
    //only this way of navigating works for opaque loading screen
    dynamic result = await Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) {
            return Loading(email: email,
                password: password);
          },
        ),
    );

    //in case user is not authenticated or other error occurred Loading page will return here
    if(result != null) {
      setState(() {
        _passwordController.clear();
        _formKey.currentState!.reset();
        //dismiss the keyboard
        FocusManager.instance.primaryFocus?.unfocus();

        UtilityWidgets.showFloatingErrorToast(context, ExceptionHandlers().getExceptionString(result['error']));
      });
    }
  }

  void signUp()
  {
    _emailController.clear();
    _passwordController.clear();
    _formKey.currentState!.reset();
    Navigator.pushReplacementNamed(context, '/signup');
  }

  // Toggles the password show status
  void _toggleObscurePw() {
    setState(() {
      _obscurePw = !_obscurePw;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose()
  {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView (
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
                //email field
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric( horizontal:25.0, vertical: 8.0),
                        child: TextFormField(
                          controller: _emailController,
                          autofocus: false,
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
                              borderRadius: BorderRadius.circular(5)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColor.inputFieldFocusBorderColor,
                                ),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              color: AppColor.hintTextColor
                            ),
                            fillColor: AppColor.inputFieldFillColor,
                            filled: true,
                          ),
                        ),
                      ),
                      //Password field
                      Padding(
                        padding: const EdgeInsets.symmetric( horizontal:25.0, vertical: 8.0),
                        child: TextFormField(
                          controller: _passwordController,
                          autofocus: false,
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
                          obscureText: _obscurePw,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColor.inputFieldEnabledBorderColor,
                                ),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: AppColor.inputFieldFocusBorderColor,)
                                ,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                                color: AppColor.hintTextColor,
                            ),
                            suffixIcon: IconButton(
                              onPressed: _toggleObscurePw,
                              icon: _obscurePw? const Icon(Icons.visibility,
                                                  color: AppColor.lightIconColor,)
                                  :const Icon(Icons.visibility_off,
                                    color: AppColor.lightIconColor,),
                            ),
                            fillColor: AppColor.inputFieldFillColor,
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/forgot_password');
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: AppColor.primaryThemeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                //sign in button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: (){
                      if(_formKey.currentState!.validate())
                      {
                        signIn();
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
                          'Sign In',
                          style: TextStyle(
                            color: AppColor.buttonTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),),
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
                      "Don't have an account?",
                      style: TextStyle(
                        color: AppColor.primaryTextColor,
                      )
                    ),
                    InkWell(
                      onTap: () {
                        signUp();
                      },
                      child: const Text(
                        ' Sign up',
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
    );
  }
}

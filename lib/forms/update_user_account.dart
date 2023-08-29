import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:low_ses_health_resource_app/blocs/user_bloc.dart';
import 'package:low_ses_health_resource_app/response_models/user_response_model.dart';
import 'package:low_ses_health_resource_app/utility/ui_messages.dart';
import '../app_colors.dart';
import 'dart:io';

import '../request_models/update_user_request_model.dart';
import '../request_models/upload_image_request_model.dart';
import '../services/auth_service.dart';
import '../services/exception_handler.dart';
import '../utility/utility.dart';
import '../utility/utility_widgets.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {

  String? _authUserEmail;
  UserResponse? _authUser;

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImageFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();

  bool _isChanged = false;

  String _errorText = '';
  bool _hasError = false;

  bool _isWaitingForApi = false;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async
  {

    try{
      //get auth users email from shared preference
      _authUserEmail = await authService.getAuthUserEmail();

      //get user
      _authUser = await userBloc.fetchUser(_authUserEmail!);

      if(_authUser != null) {
        setState(() {
          _nameController = TextEditingController(text: _authUser!.getName);
          _emailController = TextEditingController(text: _authUser!.getEmail);
        });
      }

    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(e.toString());
        print(stacktrace.toString());
      }

      if (e is UnAuthorizedException){
        Navigator.popUntil(context, ModalRoute.withName('/'));
        UtilityWidgets.showFloatingErrorToast(context, ExceptionHandlers().getExceptionString(e));
        Utility.cleanAtLogOut();
      } else if (e is SessionTimeOutException){
        if (context.mounted) Navigator.popUntil(context, ModalRoute.withName('/'));
        if (context.mounted) UtilityWidgets.showFloatingErrorToast(context, ExceptionHandlers().getExceptionString(e));
        Utility.cleanAtLogOut();
      } else {
        //in case an exception other than UnAuthorizedException is thrown
        setState(() {
          _hasError = true;
          _errorText = ExceptionHandlers().getExceptionString(e);
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return UtilityWidgets.errorScreen(context, _errorText, 'Edit User Account');
    } else {
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.primaryBackgroundColor,
              elevation: 0,
              title: const Text(
                'Edit User Account',
                style: TextStyle(
                  color: AppColor.titleTextColor,
                  fontSize: 20.0,
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColor.darkIconColor,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: _isChanged ? () async{
                    if (_formKey.currentState!.validate()) {
                      await updateUser();
                    }
                  } : null,
                  child: const Text("Done"),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(9.0, 10.0, 9.0, 10.0),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 115.0,
                        height: 115.0,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColor.imageBackgroundColor,
                              backgroundImage:
                              _pickedImageFile != null
                                  ? FileImage(File(_pickedImageFile!.path))
                                  : (_authUser?.getProfilePicture != null
                                  ? NetworkImage(_authUser!.getProfilePicture!)
                                  : const AssetImage(
                                  'assets/images/default_profile_picture.jpg') as ImageProvider),
                            ),
                            Positioned(
                              right: -12,
                              bottom: 0,
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppColor.iconBackgroundColor,
                                    shape: const CircleBorder(side: BorderSide(
                                        color: AppColor.iconBorderColor)),
                                  ),
                                  onPressed: () {
                                    openProfilePicOptionDialog();
                                  },
                                  child: const Icon(
                                    Icons.add_a_photo,
                                    color: AppColor.lightIconColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      //name field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Name',
                          style: TextStyle(
                            color: AppColor.primaryTextColor,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _nameController,
                        onChanged: (text) {
                          setState(() {
                            _isChanged = true;
                          });
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[A-z ]')),
                          LengthLimitingTextInputFormatter(50),
                        ],
                        decoration: InputDecoration(
                          hintText: "Enter first name",
                          suffixIcon: IconButton(
                            onPressed: _nameController.clear,
                            icon: const Icon(Icons.clear),
                          ),
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
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return UiMessage.NO_EMPTY_NAME;
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      //email field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            color: AppColor.primaryTextColor,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: "Enter email",
                          disabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: AppColor.inputFieldDisabledBorderColor,
                                width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
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

  Future openProfilePicOptionDialog() {
    return showDialog(
      context: context,
      builder: (context) =>
          StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  content: SizedBox(
                    height: 120,
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            getNewPicture(ImageSource.camera);
                            //Navigator.pop(context);
                          },
                          leading: const Icon(Icons.camera),
                          title: const Text("Camera"),
                        ),
                        ListTile(
                          onTap: () {
                            getNewPicture(ImageSource.gallery);
                            //Navigator.pop(context);
                          },
                          leading: const Icon(Icons.image),
                          title: const Text("Gallery"),
                        ),
                      ],
                    ),
                  ),
                );
              }
          ),
    );
  }

  void getNewPicture(ImageSource source) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: source,
      imageQuality: 100,
    );

    //closing the dialog
    if (context.mounted) Navigator.pop(context);

    if(pickedFile != null) {
      setState(() {
        _pickedImageFile = pickedFile;
      });

      //Uploading the image
      UploadImageRequest uploadProfileImageRequest = UploadImageRequest(
        entityId: _authUser!.getId,
        image: _pickedImageFile!,
      );

      try {
        setState(() {
          _isWaitingForApi=true;
        });

        if (await userBloc.uploadProfileImage(uploadProfileImageRequest)) {
          setState(() {
            _isWaitingForApi=false;
          });
          if (context.mounted) UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_UPDATE_IMAGE);
        }
      } catch (e, stacktrace){
        setState(() {
          _isWaitingForApi=false;
          _pickedImageFile = null;
        });

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
          if (context.mounted) UtilityWidgets.showErrorToast(context, UiMessage.ERROR_UPDATE_IMAGE);
        }
      }
    }
  }

  Future<void> updateUser() async{
    UpdateUserRequest updateUserRequest = UpdateUserRequest(
      userId: _authUser!.getId,
      name: _nameController.text!,
    );

    try {
      setState(() {
        _isWaitingForApi=true;
      });

      if (await userBloc.updateUser(updateUserRequest)) {
        setState(() {
          _isWaitingForApi=false;
        });

        //un-focusing the cursor
        if (context.mounted) FocusScope.of(context).unfocus();

        if (context.mounted) UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_UPDATE_USER);
        _isChanged = false;
        //if (context.mounted) Navigator.pop(context,);
      }

    } catch (e, stacktrace){
      setState(() {
        _isWaitingForApi=false;
      });

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
        if (context.mounted) UtilityWidgets.showErrorToast(context, UiMessage.ERROR_UPDATE_USER);
      }
    }
  }
}

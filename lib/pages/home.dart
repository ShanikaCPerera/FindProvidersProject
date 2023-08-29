import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:low_ses_health_resource_app/app_colors.dart';
import 'package:low_ses_health_resource_app/services/auth_service.dart';
import 'package:low_ses_health_resource_app/utility/utility.dart';

import '../blocs/user_bloc.dart';
import '../forms/find_providers.dart';
import '../forms/new_update_athlete_profile.dart';
import '../response_models/user_response_model.dart';
import '../services/exception_handler.dart';
import '../utility/utility_widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String? _authUserEmail;
  UserResponse? _authUser;
  List homeTileList = [];

  String _errorText = '';
  bool _hasError = false;

  _initData() async
  {
    try{
      //getting user details for the first time loading of home screen - right after sign-in or sign-up
      //get authorised user from shared preference
      _authUser = await authService.getAuthUserData();

    } catch (e, stacktrace) {
      if (kDebugMode) {
        print(e.toString());
        print(stacktrace.toString());
      }

      setState(() {
        _hasError = true;
        _errorText = ExceptionHandlers().getExceptionString(e);
      });
    }

    final String response = await rootBundle.loadString('json_files/home_tile_list.json');
    final data = await json.decode(response);
    homeTileList = data;

    setState(() {
      homeTileList = data;
    });
  }

  @override
  void initState()
  {
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return UtilityWidgets.errorScreen(context, _errorText, 'Home');
    } else {
      return Scaffold(
        backgroundColor: AppColor.primaryBackgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppColor.primaryThemeColor,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () async {
                  var value = await Navigator.pushNamed(
                      context, '/user_settings');
                  //if popped to home from settings and changes happened to user then load user from API
                  try {
                    //get auth user email
                    _authUserEmail = await authService.getAuthUserEmail();
                    //get user
                    _authUser = await userBloc.fetchUser(_authUserEmail!);
                  } catch (e, stacktrace) {
                    if (kDebugMode) {
                      print(e.toString());
                      print(stacktrace.toString());
                    }

                    if (e is UnAuthorizedException) {
                      if (context.mounted) Navigator.popUntil(context, ModalRoute.withName('/'));
                      if (context.mounted) UtilityWidgets.showFloatingErrorToast(context, ExceptionHandlers().getExceptionString(e));
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

                  setState(() {
                    _authUser = _authUser;
                  });
                }
            ),
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Utility.cleanAtLogOut();
                  Navigator.pushReplacementNamed(context, '/');
                }
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30.0, bottom: 20.0,),
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.12, //covering 12% of total height
              //color: primaryThemeColor,
              decoration: BoxDecoration(
                color: AppColor.primaryThemeColor,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 10),
                    blurRadius: 50,
                    color: AppColor.primaryThemeColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: _authUser?.getProfilePicture != null
                        ? NetworkImage(_authUser!.getProfilePicture!)
                        : const AssetImage(
                        'assets/images/default_profile_picture.jpg') as ImageProvider,
                    backgroundColor: AppColor.imageBackgroundColor,
                    radius: 40.0,
                  ),
                  Text(
                    //'   Hi ${data['username']}',
                    '   Hi ${_authUser?.getName}',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                        color: AppColor.lightTextColor,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: OverflowBox(
                maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: ListView.builder(
                    itemCount: homeTileList.length.toDouble() ~/ 2,
                    // (homeTileList.length.toDouble()/2).toInt()
                    itemBuilder: (_, i) {
                      int a = 2 * i;
                      int b = 2 * i + 1;
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (homeTileList[a]['id'] == 0) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      const FindProviders(selectedAthlete: null,)),
                                );
                              } else if (homeTileList[a]['id'] == 2) {
                                Navigator.pushNamed(context, '/athlete_profiles');
                              }
                            },
                            child: Container(
                              width: (MediaQuery
                                  .of(context)
                                  .size
                                  .width - 90) / 2,
                              height: 170,
                              margin: const EdgeInsets.only(
                                  left: 30.0, bottom: 30.0),
                              padding: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: AppColor.widgetFillColor,
                                borderRadius: BorderRadius.circular(5),
                                // image: DecorationImage(
                                //   image: AssetImage(homeTileList[a]['icon']),
                                // ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: const Offset(5, 5),
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: const Offset(-5, -5),
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: CircleAvatar(
                                      //backgroundImage: AssetImage('assets/images/mary.jpg'),
                                      backgroundColor: AppColor
                                          .imageBackgroundColor,
                                      radius: 30.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 80.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        homeTileList[a]['title'],
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: AppColor.primaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        homeTileList[a]['hint'],
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColor.secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (homeTileList[a]['id'] == 0) {
                                Navigator.pushNamed(
                                    context, '/social_determinants');
                              } else if (homeTileList[a]['id'] == 2) {
                                dynamic result = Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const UpdateAthleteProfile(
                                          selectedAthlete: null,
                                          newAthlete: true,
                                          updateAthlete: false,))
                                );
                              }
                            },
                            child: Container(
                              width: (MediaQuery
                                  .of(context)
                                  .size
                                  .width - 90) / 2,
                              height: 170,
                              margin: const EdgeInsets.only(
                                  left: 30.0, bottom: 30.0),
                              padding: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: AppColor.widgetFillColor,
                                borderRadius: BorderRadius.circular(5),
                                // image: DecorationImage(
                                //   image: AssetImage(homeTileList[b]['icon']),
                                // ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: const Offset(5, 5),
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  BoxShadow(
                                    blurRadius: 3,
                                    offset: const Offset(-5, -5),
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: CircleAvatar(
                                      //backgroundImage: AssetImage('assets/images/mary.jpg'),
                                      backgroundColor: AppColor
                                          .imageBackgroundColor,
                                      radius: 30.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 80.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        homeTileList[b]['title'],
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: AppColor.primaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        homeTileList[b]['hint'],
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColor.secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}


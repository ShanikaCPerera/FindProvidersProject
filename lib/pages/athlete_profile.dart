import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:low_ses_health_resource_app/app_colors.dart';
import 'package:low_ses_health_resource_app/response_models/find_provider_result_response_model.dart';
import 'package:low_ses_health_resource_app/forms/new_update_athlete_profile.dart';
import 'package:low_ses_health_resource_app/request_models/upload_image_request_model.dart';
import 'package:low_ses_health_resource_app/utility/enumerations.dart';
import 'package:low_ses_health_resource_app/utility/ui_messages.dart';
import '../blocs/athlete_bloc.dart';
import 'package:low_ses_health_resource_app/utility/string_extension.dart';
import '../blocs/loi_bloc.dart';
import '../response_models/athlete_response_model.dart';
import '../response_models/location_of_interest_response_model.dart';
import '../services/exception_handler.dart';
import '../utility/utility.dart';
import '../utility/utility_widgets.dart';
import '../forms/new_loi_google.dart';
import 'athlete_saved_result_provider_list.dart';

class AthleteProfile extends StatefulWidget {

  final int athleteId;

  const AthleteProfile({
    super.key,
    required this.athleteId
  });

  @override
  State<AthleteProfile> createState() => _AthleteProfileState();
}

class _AthleteProfileState extends State<AthleteProfile> {
  late int athleteId;
  late AthleteResponse _selectedAthlete;
  List<LocationOfInterestResponse>? _loiList;
  List<FindProviderResultResponse>? _providerResultList;

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImageFile;
  String _errorText = '';
  bool _hasError = false;
  bool _isWaitingForApi = false;

  final AthleteBloc athleteBloc = AthleteBloc();
  final LoiBloc loiBloc = LoiBloc();

  void initData() {
    athleteBloc.fetchAthlete(athleteId).catchError((e, stacktrace){
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
    });
  }

  @override
  void initState() {
    super.initState();
    athleteId = widget.athleteId;
    initData();
  }

  @override
  void dispose() {
    athleteBloc.dispose();
    loiBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return UtilityWidgets.errorScreen(context, _errorText, null);
    } else {
      return Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: AppColor.primaryThemeColor,
              elevation: 0,
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/home'));
                    }),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(9.0, 10.0, 9.0, 10.0),
              child: Center(
                child: StreamBuilder(
                  stream: athleteBloc.athlete,
                  builder: (context, AsyncSnapshot<AthleteResponse> snapshot) {
                    if (snapshot.hasData) {
                      _selectedAthlete = snapshot.data!;
                      _loiList = _selectedAthlete.getLoiList;
                      _providerResultList = _selectedAthlete.getProviderResultList;
                      return Column(
                        children: [
                          //profile picture
                          SizedBox(
                            width: 115.0,
                            height: 115.0,
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColor.imageBackgroundColor,
                                  backgroundImage: _pickedImageFile != null
                                      ? FileImage(File(_pickedImageFile!.path))
                                      : (_selectedAthlete?.getProfilePicture != null
                                      ? NetworkImage(
                                      _selectedAthlete.getProfilePicture!)
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
                                        shape: const CircleBorder(
                                            side: BorderSide(
                                                color: AppColor.iconBorderColor
                                            )
                                        ),
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
                          //Name
                          Text(
                            '${_selectedAthlete.getFname} ${_selectedAthlete
                                .getLname}',
                            style: const TextStyle(
                              color: AppColor.titleTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          //Email
                          Text(
                            _selectedAthlete.getEmail,
                            style: const TextStyle(
                              color: AppColor.secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 15),
                          //update profile button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: AppColor.primaryThemeColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12
                              ),
                            ),
                            onPressed: () async {
                              dynamic result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UpdateAthleteProfile(
                                            selectedAthlete: _selectedAthlete,
                                            newAthlete: false,
                                            updateAthlete: true,))
                              );
                              //updating the page again after updating athlete
                              if (await result['isNewOrUpdateAthlete']) {
                                setState(() {
                                  initData();
                                });
                              }
                            },
                            child: const Text(
                                "Update Profile",
                                style: TextStyle(
                                    color: AppColor.buttonTextColor,
                                ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: ListView(
                              children: [
                                ListTile(
                                  visualDensity: const VisualDensity(vertical: -4),
                                  title: const Text(
                                    'Gender',
                                    style: TextStyle(
                                      color: AppColor.primaryTextColor,
                                    ),
                                  ),
                                  trailing: Text(
                                    GenderEnum.values[_selectedAthlete.getGender]
                                        .name
                                        .capitalize(),
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.withOpacity(0.6),
                                ),
                                ListTile(
                                  visualDensity: const VisualDensity(vertical: -4),
                                  title: const Text(
                                    'Date of Birthday',
                                    style: TextStyle(
                                      color: AppColor.primaryTextColor,
                                    ),
                                  ),
                                  trailing: Text(
                                    DateFormat.yMMMd().format(
                                        _selectedAthlete.getDob),
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.withOpacity(0.6),
                                ),
                                ListTile(
                                  visualDensity: const VisualDensity(vertical: -4),
                                  title: const Text(
                                    'Classification',
                                    style: TextStyle(
                                      color: AppColor.primaryTextColor,
                                    ),
                                  ),
                                  trailing: Text(
                                    '${ClassificationEnum.values[_selectedAthlete
                                        .getClassification].name} th Grade',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                ),
                                // Divider(
                                //   color: Colors.grey.withOpacity(0.6),
                                // ),
                                ExpansionTile(
                                  //leading: const Icon(Icons.location_pin),
                                  title: const Text(
                                    'Locations of Interest',
                                    style: TextStyle(
                                      color: AppColor.primaryTextColor,
                                    ),
                                  ),
                                  //backgroundColor: Colors.grey[100],
                                  children: [
                                    _loiList != null ?
                                    Column(
                                        children: _loiList!.map((e) =>
                                            ListTile(
                                              leading: const Icon(Icons.location_on_outlined),
                                              trailing: TextButton(
                                                //alignment: Alignment.centerRight,
                                                child: const Text(
                                                  'Remove',
                                                  style: TextStyle(
                                                    color: AppColor.errorTextColor
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  bool delete = await showAlertDialog(context, e.getName);
                                                  if(delete){
                                                    try {
                                                      setState(() {
                                                        _isWaitingForApi=true;
                                                      });

                                                      //permanently removing from list
                                                      if(await loiBloc.deleteLoi(e.getId)){
                                                        setState(() {
                                                          _isWaitingForApi=false;
                                                          //updating page with new data
                                                          initData();
                                                        });
                                                        if (context.mounted) UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_DELETE_LOI);
                                                      }
                                                    } catch (e, stacktrace) {
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
                                                        //in case an exception other than UnAuthorizedException is thrown
                                                        if (context.mounted) UtilityWidgets.showErrorToast(context, UiMessage.ERROR_DELETE_LOI);
                                                      }
                                                    }
                                                  }
                                                },
                                              ),
                                              title: Text(e.getName),
                                              onTap: null,
                                            ),
                                        ).toList(),
                                    )
                                    : const SizedBox.shrink(),
                                    ListTile(
                                      //visualDensity: const VisualDensity(vertical: -4),
                                      title: const Text(
                                        'Add new location',
                                        style: TextStyle(
                                          color: AppColor.controlTextColor,
                                        ),
                                      ),
                                      trailing: const Icon(
                                          Icons.keyboard_arrow_right
                                      ),
                                      onTap: () async {
                                        // dynamic result = await Navigator.of(context)
                                        //     .push(
                                        //     MaterialPageRoute(
                                        //         builder: (context) => NewLocation())
                                        // );

                                        dynamic result = await Navigator.of(context)
                                            .push(
                                            MaterialPageRoute(
                                                builder: (context) => NewLoiGoogle(athleteId:athleteId!))
                                        );

                                        //updating the page again after adding a new LOI
                                        if (result['isNewLoi']) {
                                          setState(() {
                                            initData();
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                ExpansionTile(
                                  //leading: const Icon(Icons.person_search),
                                  title: const Text(
                                    'Saved Results of Health Providers',
                                    style: TextStyle(
                                      color: AppColor.primaryTextColor,
                                    ),
                                  ),
                                  //backgroundColor: Colors.grey[100],
                                  children: _providerResultList != null ?
                                  _providerResultList!.map((e) =>
                                      ListTile(
                                        leading: const Icon(Icons.person_search),
                                        title: Text(
                                            '${e.getName} (${e.getProviderResultCount.toString()})'
                                        ),
                                        subtitle: Text(
                                            DateFormat.yMMMd().format(
                                                e.getSavedDateTime)),
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AthleteSavedResultProviderList(
                                                        athleteId: athleteId,
                                                        resultId: e.getId,
                                                        listTopic: '${e.getName} - ${DateFormat.yMMMd().format(e.getSavedDateTime)}'
                                                      )
                                              )
                                          );
                                        },
                                      )
                                  ).toList()
                                  : [],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return const Center(
                        child: CupertinoActivityIndicator(
                          color: AppColor.primaryThemeColor,
                          radius: 20,
                          animating: true,
                        )
                    );
                  },
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

      UploadImageRequest uploadProfileImageRequest = UploadImageRequest(
        entityId: _selectedAthlete!.getId,
        image: pickedFile
      );

      try {
        setState(() {
          _isWaitingForApi=true;
        });

        if(await athleteBloc.uploadProfileImage(uploadProfileImageRequest)){
          setState(() {
            _isWaitingForApi=false;
          });
          if (context.mounted) UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_UPDATE_IMAGE);
        }
      } catch (e, stacktrace) {
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
          //in case an exception other than UnAuthorizedException is thrown
          if (context.mounted) UtilityWidgets.showErrorToast(context, UiMessage.ERROR_UPDATE_IMAGE);
        }
      }
    }
  }

  Future<dynamic> showAlertDialog(BuildContext context, String deleteObjectName) {
    // set up the buttons
    Widget deleteButton = TextButton(
      onPressed:  () {
        Navigator.pop(context, true);
      },
      child: const Text("Yes, Remove!"),
    );
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context, false);
      },
    );

    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove '$deleteObjectName' ?"),
          content: const Text("Once removed, you will not be able to recover this saved location!"),
          actions: [
            deleteButton,
            cancelButton,
          ],
        );
      },
    );
  }

}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:low_ses_health_resource_app/app_colors.dart';
import 'package:low_ses_health_resource_app/forms/find_providers.dart';
import 'package:low_ses_health_resource_app/response_models/athlete_response_model.dart';
import 'package:low_ses_health_resource_app/pages/athlete_profile.dart';
import 'package:low_ses_health_resource_app/blocs/athlete_bloc.dart';

import '../services/exception_handler.dart';
import '../utility/enumerations.dart';
import '../utility/ui_messages.dart';
import '../utility/utility.dart';
import '../utility/utility_widgets.dart';
import '../forms/new_update_athlete_profile.dart';

class AthleteList extends StatefulWidget {
  const AthleteList({super.key});

  @override
  State<AthleteList> createState() => _AthleteListState();
}

class _AthleteListState extends State<AthleteList> {

  List<AthleteResponse>? _resultList = [];
  final _searchController = TextEditingController();
  String _searchText = '';
  String _errorText = '';
  bool _hasError = false;
  bool _isWaitingForApi = false;

  final AthleteBloc athleteBloc = AthleteBloc();

  void initData(){
    athleteBloc.fetchAllAthletes().catchError((e, stacktrace){
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
    initData();
  }

  @override
  void dispose() {
    athleteBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return UtilityWidgets.errorScreen(context, _errorText, 'Athlete Profiles');
    } else {
      return Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.primaryBackgroundColor,
            appBar: AppBar(
              backgroundColor: AppColor.primaryThemeColor,
              title: const Text('Athlete Profiles'),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/home'));
                    }),
              ],
            ),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(6, 6, 6, 10),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      fillColor: AppColor.inputFieldFillColor,
                      filled: true,
                      prefixIcon: const Icon(
                          Icons.search,
                          color: AppColor.lightIconColor),
                      hintText: 'Search',
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColor.inputFieldEnabledBorderColor,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColor.inputFieldFocusBorderColor,
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: athleteBloc.allAthletes,
                    builder: (context, AsyncSnapshot<List<AthleteResponse>> snapshot) {
                      _resultList = snapshot.data;
                      if (_searchText.isNotEmpty) {
                        _resultList = _resultList?.where((element) {
                          return element
                              .getFname
                              .toString()
                              .toLowerCase()
                              .contains(_searchText.toLowerCase());
                        }).toList();
                      }
                      if (snapshot.hasData) {
                        if(_resultList!.isEmpty){
                          //UtilityWidgets.emptyDataWidget(context, "You have no registered Athletes.");
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/empty_data.jpg'),
                                const Padding (
                                  padding: EdgeInsets.only(left:20.0, right:20.0),
                                  child: Text(
                                    "You have no registered Athletes.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15
                                    ),
                                  ),
                                ),
                              ]
                          );
                        } else {
                          return buildList(_resultList);
                        }
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return const Center(
                          child: CupertinoActivityIndicator(
                            color: AppColor.primaryThemeColor,
                            radius: 20,
                            animating: true,
                          )
                        // child: CircularProgressIndicator(
                        //     color: AppColor.primaryThemeColor
                        // ),
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                //create a new Athlete
                dynamic result = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            const UpdateAthleteProfile(
                              selectedAthlete: null,
                              newAthlete: true,
                              updateAthlete: false,))
                );

                //if creating new athlete is successful refresh the list
                if (result['isNewOrUpdateAthlete']) {
                  setState(() {
                    initData();
                  });
                }
              },
              backgroundColor: AppColor.primaryThemeColor,
              child: const Icon(Icons.add),
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

  Widget buildList(List<AthleteResponse>? resultList)
  {
    return ListView.builder(
        itemCount: resultList?.length,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              child: ListTile(
                onTap: () async {
                  //go to Athlete Profile page
                  if(resultList != null) {
                    final value = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AthleteProfile(athleteId: resultList[index].getId)),
                    );
                    //updating the list again when returned to the list
                    setState(() {
                      initData();
                    });
                  }
                },
                title: Text(
                    "${resultList?[index].getFname} ${resultList?[index].getLname}",
                    style: const TextStyle(
                      color: AppColor.primaryTextColor,
                      fontSize: 17.0,
                    )
                ),
                subtitle: Text('${ClassificationEnum.values[resultList![index].getClassification].name} th Grade'),
                leading: CircleAvatar(
                  backgroundColor: AppColor.imageBackgroundColor,
                  backgroundImage: resultList?[index].getProfilePicture == null
                      ? const AssetImage('assets/images/default_profile_picture.jpg') as ImageProvider
                      : NetworkImage(resultList![index].getProfilePicture!),
                ),
                trailing: PopupMenuButton<int>(
                  onSelected: (value) async {
                    if (value == 0){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FindProviders(selectedAthlete: resultList?[index],)),
                      );
                    } else if (value == 1){
                      bool delete = await showAlertDialog(context, '${resultList![index].getFname} ${resultList![index].getLname}');
                      if(delete){
                        try {
                          setState(() {
                            _isWaitingForApi=true;
                          });

                          //permanently removing from list
                          if(await athleteBloc.deleteAthlete(resultList![index].getId)){
                            setState(() {
                              _isWaitingForApi=false;
                              //updating page with new data
                              initData();
                            });
                            if (context.mounted) UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_DELETE_ATHLETE);
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
                            if (context.mounted) UtilityWidgets.showErrorToast(context, UiMessage.ERROR_DELETE_ATHLETE);
                          }

                        }
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<int>>[
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text('Find Providers'),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text('Remove'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
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
          content: const Text("Once removed, you will not be able to recover this athlete profile!"),
          actions: [
            deleteButton,
            cancelButton,
          ],
        );
      },
    );
  }
}

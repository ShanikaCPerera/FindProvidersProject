import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:low_ses_health_resource_app/app_colors.dart';
import 'package:low_ses_health_resource_app/blocs/health_provider_bloc.dart';
import 'package:low_ses_health_resource_app/request_models/find_provider_request_model.dart';
import 'package:low_ses_health_resource_app/response_models/health_provider_response_model.dart';
import 'package:low_ses_health_resource_app/utility/ui_messages.dart';

import '../request_models/providers_list_request_model.dart';
import '../response_models/find_provider_result_health_provider_model.dart';
import '../services/exception_handler.dart';
import '../utility/utility.dart';
import '../utility/utility_widgets.dart';

class ProviderList extends StatefulWidget {
  final FindProviderRequest findProvidersRequest;

  const ProviderList({
    super.key,
    required this.findProvidersRequest
  });

  @override
  State<ProviderList> createState()
  {
    return _ProviderListState();
  }
}

class _ProviderListState extends State<ProviderList> {

  late FindProviderRequest findProvidersRequest;
  List<HealthProviderResponse>? _resultList = [];
  final String _saveText = UiMessage.SUCCESS_SAVE_RESULT;
  final String _emailText = UiMessage.SUCCESS_EMAIL_RESULT;
  final String _saveEmailText = UiMessage.SUCCESS_SAVE_AND_EMAIL_RESULT;
  final String _saveErrorText = UiMessage.ERROR_SAVE_RESULT;
  final String _emailErrorText = UiMessage.ERROR_EMAIL_RESULT;
  final String _saveEmailErrorText = UiMessage.ERROR_SAVE_AND_EMAIL_RESULT;
  late TextEditingController _listNameController;
  String? _listName = "";
  bool _validateListName = true;
  int resultCount = 0;
  String _errorText = '';
  bool _hasError = false;

  bool _isSaveSuccess = false;
  bool _isEmailSuccess = false;
  bool _isWaitingForApi = false;

  final HealthProviderBloc healthProviderBloc = HealthProviderBloc();

  @override
  void initState() {
    super.initState();
    findProvidersRequest = widget.findProvidersRequest;
    healthProviderBloc.fetchFilteredHealthProviders(findProvidersRequest).catchError((e, stacktrace){
      if (kDebugMode) {
        print(e.toString());
        print(stacktrace.toString());
      }

      if (e is UnAuthorizedException) {
        Navigator.popUntil(context, ModalRoute.withName('/'));
        UtilityWidgets.showFloatingErrorToast(context, ExceptionHandlers().getExceptionString(e));
        Utility.cleanAtLogOut();
      } else if (e is SessionTimeOutException){
        if (context.mounted) Navigator.popUntil(context, ModalRoute.withName('/'));
        if (context.mounted) UtilityWidgets.showFloatingErrorToast(context, ExceptionHandlers().getExceptionString(e));
        Utility.cleanAtLogOut();
      } else {
        setState(() {
          _hasError = true;
          _errorText = ExceptionHandlers().getExceptionString(e);
        });
      }
    });
    _listNameController = TextEditingController();
  }

  @override
  void dispose(){
    _listNameController.dispose();
    healthProviderBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (_hasError) {
      return UtilityWidgets.errorScreen(context, _errorText, 'Health Providers');
    } else {
      resultCount = _resultList != null ? _resultList!.length : 0;

      return Stack(
        children: [
          Scaffold(
            backgroundColor: AppColor.primaryBackgroundColor,
            appBar: AppBar(
              backgroundColor: AppColor.primaryThemeColor,
              title: Column(
                children: [
                  const Text(
                    'Health Providers',
                    style: TextStyle(
                      color: AppColor.lightTextColor,
                      fontSize: 19.0,
                    ),
                  ),
                  Text(
                    '${resultCount.toString()} in your area',
                    style: const TextStyle(
                      color: AppColor.lightTextColor,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.home),
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName('/home'));
                    }
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: healthProviderBloc.filteredHealthProviders,
                    builder: (context, AsyncSnapshot<List<HealthProviderResponse>> snapshot) {
                      _resultList = snapshot.data;
                      Future.delayed(Duration.zero,(){
                        setState(() {
                          resultCount = _resultList != null ? _resultList!.length : 0;
                        });
                      });
                      if (snapshot.hasData) {
                        if(_resultList!.isEmpty){
                          //UtilityWidgets.emptyDataWidget(context, "No providers found.");
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/empty_data.jpg'),
                                const Padding (
                                  padding: EdgeInsets.only(left:20.0, right:20.0),
                                  child: Text(
                                    "No providers found.",
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
                        UtilityWidgets.showErrorToast(context, snapshot.error.toString());
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
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showActionSheet(context);
              },
              backgroundColor: AppColor.primaryThemeColor,
              child: const Icon(Icons.download),
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

  Widget buildList(List<HealthProviderResponse>? resultList)
  {
    return ListView.builder(
        itemCount: resultList?.length,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.5),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
              child: ListTile(
                onTap: null,
                title: Text(
                    '${resultList?[index].getName}',
                    style: const TextStyle(
                      color: AppColor.primaryTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                ),
                subtitle: Row(
                  children: [
                    Text('${resultList?[index].getAddress}, ${resultList?[index].getCity}'),
                    Text(' (${resultList?[index].getDistance.toString()} mi away)'),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  void saveEmailResult(List<HealthProviderResponse> resultList, bool email, bool save) async
  {
    Future<bool> response;
    List<FindProviderResultHealthProvider> providerResultList = [];
    String toastContext = "";

    if (save) {
      _listName = (await openDialog());
      _listName = _listName?.trim();
    }

    if ((save && _listName != null && _listName!.isNotEmpty && resultList.isNotEmpty) || (email && resultList.isNotEmpty)) {
      for (int i = 0; i < resultList.length; i++) {
        FindProviderResultHealthProvider result = FindProviderResultHealthProvider(id:resultList[i].getId, distance:resultList[i].getDistance);
        providerResultList.add(result);
      }

      ProviderListRequest providersListRequest = ProviderListRequest(
          athleteId: findProvidersRequest.getAthleteId,
          email: email,
          save: save,
          listName: _listName,
          providerList: providerResultList);

      try {
        setState(() {
          _isWaitingForApi=true;
        });

        response = healthProviderBloc.saveEmailFilteredProviders(providersListRequest);

        if (await response) {
          setState(() {
            _isWaitingForApi=false;
          });

          if (save && !email) {
            setState(() {
              _isSaveSuccess = true;
            });
            toastContext = _saveText;
          } else if (email && !save) {
            setState(() {
              _isEmailSuccess = true;
            });
            toastContext = _emailText;
          } else if (save && email) {
            setState(() {
              _isSaveSuccess = true;
              _isEmailSuccess = true;
            });
            toastContext = _saveEmailText;
          }
          if (context.mounted) UtilityWidgets.showSuccessToast(context, toastContext);
        }
      }catch (e, stacktrace){
        setState(() {
          _isWaitingForApi=false;
          _isSaveSuccess = false;
          _isEmailSuccess = false;
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
          if (save && !email) {
            toastContext = _saveErrorText;
          } else if (email && !save) {
            toastContext = _emailErrorText;
          } else if (save && email) {
            toastContext = _saveEmailErrorText;
          }
          if (context.mounted) UtilityWidgets.showErrorToast(context, toastContext);
        }
      }
    }

  }

  Future<String?> openDialog()
  {
    return showDialog<String>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) { return AlertDialog(
            title: const Text("Provider List Name"),
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(
                  hintText: 'Enter a name',
                  errorText: _validateListName ? null : 'Value cannot be empty',
                  suffixIcon: IconButton(
                    onPressed: _listNameController.clear,
                    icon: const Icon(Icons.clear),
                  ),
              ),
              controller: _listNameController,
              inputFormatters: [
                LengthLimitingTextInputFormatter(30),
              ],
              onTap: () {
                setState(() {
                  _validateListName = true;
                });
              },
            ),
            actions: [
              TextButton(onPressed: dialogCancel, child: const Text("CANCEL")),
              TextButton(onPressed: () {
                setState(() {
                  _listNameController.text.isEmpty
                      ? _validateListName = false
                      : _validateListName = true;
                });
                if (_listNameController.text.isEmpty) {
                }
                if(_validateListName) {
                  Navigator.of(context).pop(_listNameController.text);
                  _listNameController.clear();
                }
                },
                child: const Text("SUBMIT"))
            ],
          );},
        ),
    );
  }

  // void dialogSubmit() {
  //   setState(() {
  //     _listNameController.text.isEmpty
  //         ? _validateListName = false
  //         : _validateListName = true;
  //   });
  //
  //   if (_listNameController.text.isEmpty) {
  //     print("helloooo");
  //   }
  //   if(_validateListName) {
  //     Navigator.of(context).pop(_listNameController.text);
  //     _listNameController.clear();
  //   }
  // }

  void dialogCancel() {
    setState(() {
      _validateListName = true;
    });
    Navigator.of(context).pop();
    _listNameController.clear();
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Actions'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              if(_isSaveSuccess) {
                null;
              } else {
                Navigator.pop(context);
                //Navigator.popUntil(context, ModalRoute.withName('/home'));
                saveEmailResult(_resultList!, false, true);
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: _isSaveSuccess ? Colors.grey : Colors.blue
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              if(_isEmailSuccess) {
                null;
              } else {
                Navigator.pop(context);
                saveEmailResult(_resultList!, true, false);
              }
            },
            child: Text(
              'Email',
              style: TextStyle(
                  color: _isEmailSuccess ? Colors.grey : Colors.blue
              ),),
          ),
          CupertinoActionSheetAction(
            //isDestructiveAction: true,
            onPressed: () {
              if(_isSaveSuccess || _isEmailSuccess) {
                null;
              } else {
                Navigator.pop(context);
                saveEmailResult(_resultList!, true, true);
              }
            },
            child: Text(
              'Save and Email',
              style: TextStyle(
                  color: _isSaveSuccess || _isEmailSuccess  ? Colors.grey : Colors.blue
              ),),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

}

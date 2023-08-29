import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:low_ses_health_resource_app/app_colors.dart';
import 'package:low_ses_health_resource_app/blocs/health_provider_bloc.dart';
import 'package:low_ses_health_resource_app/response_models/health_provider_response_model.dart';
import '../services/exception_handler.dart';
import '../utility/utility.dart';
import '../utility/utility_widgets.dart';

class AthleteSavedResultProviderList extends StatefulWidget {
  final int athleteId;
  final int resultId;
  final String listTopic;

  const AthleteSavedResultProviderList({
    super.key,
    required this.athleteId,
    required this.resultId,
    required this.listTopic,
  });

  @override
  State<AthleteSavedResultProviderList> createState()
  {
    return _AthleteSavedResultProviderListState();
  }
}

class _AthleteSavedResultProviderListState extends State<AthleteSavedResultProviderList> {

  List<HealthProviderResponse>? _resultList = [];
  late TextEditingController _listNameController;
  bool _validateListName = true;
  int resultCount = 0;
  String _errorText = '';
  bool _hasError = false;

  final HealthProviderBloc healthProviderBloc = HealthProviderBloc();

  @override
  void initState() {
    super.initState();
    healthProviderBloc.fetchSavedHealthProviders(widget.resultId).catchError((e, stacktrace){

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
      return UtilityWidgets.errorScreen(context, _errorText, 'Saved Health Providers');
    } else {
      resultCount = _resultList != null ? _resultList!.length : 0;

      return Scaffold(
        backgroundColor: AppColor.primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.primaryThemeColor,
          title: Column(
            children: [
              const Text(
                'Saved Health Providers',
                style: TextStyle(
                  color: AppColor.lightTextColor,
                  fontSize: 19.0,
                ),
              ),
              Text(
                widget.listTopic,
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
                stream: healthProviderBloc.savedHealthProviders,
                builder: (context, AsyncSnapshot<List<HealthProviderResponse>> snapshot) {
                  _resultList = snapshot.data;
                  Future.delayed(Duration.zero,(){
                    setState(() {
                      resultCount = _resultList != null ? _resultList!.length : 0;
                    });
                  });
                  if (snapshot.hasData) {
                    return buildList(_resultList);
                  } else if (snapshot.hasError) {
                    //return Text(snapshot.error.toString());
                    UtilityWidgets.showErrorToast(
                        context, snapshot.error.toString());
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
            ),
            controller: _listNameController,
            onTap: () {
              setState(() {
                _validateListName = true;
              });
            },
          ),
          actions: [
            TextButton(
                onPressed: dialogCancel,
                child: const Text("CANCEL")
            ),
            TextButton(
                onPressed: () {
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
              child: const Text("SUBMIT")
            )
          ],
        );},
      ),
    );
  }

  void dialogCancel() {
    setState(() {
      _validateListName = true;
    });
    Navigator.of(context).pop();
    _listNameController.clear();
  }

}

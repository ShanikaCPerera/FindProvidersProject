import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import '../app_colors.dart';
import 'package:http/http.dart' as http;
import '../blocs/loi_bloc.dart';
import '../request_models/loi_request_model.dart';
import '../utility/ui_messages.dart';
import '../utility/utility_widgets.dart';

class NewLoiGoogle extends StatefulWidget {

  final int athleteId;

  const NewLoiGoogle({
    super.key,
    required this.athleteId
  });

  @override
  State<NewLoiGoogle> createState() => _NewLoiGoogleState();
}

class _NewLoiGoogleState extends State<NewLoiGoogle> {

  late TextEditingController _locationController;
  late TextEditingController _loiNameController;
  dynamic uuid = const Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placesList = [];
  bool _validateLoiName = true;
  String? _loiName = "";
  //based on _isNewLoi the previous page will be refreshed
  bool _isNewLoi = false;
  bool _isWaitingForApi = false;

  final LoiBloc loiBloc = LoiBloc();

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController();
    _locationController.addListener(() {
      onChange();
    });
    _loiNameController = TextEditingController();
  }

  void onChange(){
    if(_sessionToken == null){
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_locationController.text);
  }

  void getSuggestion(String input) async{
    String apiKey = 'AIzaSyBCMfiI3WW5R638cB40RfUy6Ih7jnqxcNY';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?'
        'input=$input&'
        'key=$apiKey&'
        'sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    //print("in get session");
    //print(response.body.toString());

    if(response.statusCode == 200){
      if (mounted) {
        setState(() {
          _placesList = jsonDecode(response.body.toString())['predictions'];
        });
      }
    }else{
      if (context.mounted) UtilityWidgets.showErrorToast(context, "Failed to load data");
    }
  }

  Future<Map<String, dynamic>> getPlaceGeoLocation(String placeId) async {
    String apiKey = 'AIzaSyBCMfiI3WW5R638cB40RfUy6Ih7jnqxcNY';
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?'
        'place_id=$placeId&'
        'key=$apiKey';

    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var results = json['result']['geometry']['location'] as Map<String, dynamic>;
    return results;
  }

  @override
  void dispose() {
    loiBloc.dispose();
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
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context, {'isNewLoi' : _isNewLoi,});
              },
              icon:const Icon(
                Icons.arrow_back_ios,
                color: AppColor.darkIconColor,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: 'Enter an address',
                    hintStyle: TextStyle(
                        color: AppColor.primaryTextColor
                    ),
                    filled: true,
                    fillColor: AppColor.inputFieldFillColor,
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 10,),
                Expanded(
                    child: ListView.builder(
                        itemCount: _placesList.length,
                        itemBuilder: (context, index){
                          return ListTile(
                            leading: const Icon(Icons.location_pin),
                            title: Text(_placesList[index]['description']),
                            onTap: () async{
                              var placeGeopoints = await getPlaceGeoLocation(_placesList[index]['place_id']);
                              saveNewLoi(placeGeopoints);
                            },
                          );
                        }
                    )
                )
              ],
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

  void saveNewLoi(Map<String, dynamic> geoPoint) async{
    Future<bool> response;

    _loiName = (await openDialog());
    _loiName = _loiName?.trim();

    if(_loiName != null && _loiName!.isNotEmpty) {
      LoiRequest newLoiRequest = LoiRequest(
          name: _loiName!,
          longitude: geoPoint['lng'],
          latitude: geoPoint['lat'],
          athleteId: widget.athleteId
      );

      try {
        setState(() {
          _isWaitingForApi=true;
        });

        response = loiBloc.createLoi(newLoiRequest);

        setState(() {
          _isWaitingForApi=false;
        });

        if (await response) {
          _isNewLoi = true;
          if (context.mounted) UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_NEW_LOI);
          //navigate back only if success
          if (context.mounted) Navigator.pop(context, {'isNewLoi' : _isNewLoi,});
        }

      } catch (e, stacktrace) {
        setState(() {
          _isWaitingForApi=false;
        });

        _isNewLoi = false;

        if (kDebugMode) {
          print(e.toString());
          print(stacktrace.toString());
        }
        if (context.mounted) UtilityWidgets.showErrorToast(context, UiMessage.ERROR_NEW_LOI);
      }
    }
  }

  Future<String?> openDialog()
  {
    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) { return AlertDialog(
          title: const Text("LOI Name"),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter a name',
              errorText: _validateLoiName ? null : 'Value cannot be empty',
              suffixIcon: IconButton(
                onPressed: _loiNameController.clear,
                icon: const Icon(Icons.clear),
              ),
            ),
            controller: _loiNameController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(30),
            ],
            onTap: () {
              setState(() {
                _validateLoiName = true;
              });
            },
          ),
          actions: [
            TextButton(onPressed: dialogCancel, child: const Text("CANCEL")),
            TextButton(onPressed: () {
              setState(() {
                _loiNameController.text.isEmpty
                    ? _validateLoiName = false
                    : _validateLoiName = true;
              });
              if (_loiNameController.text.isEmpty) {
              }
              if(_validateLoiName) {
                Navigator.of(context).pop(_loiNameController.text);
                _loiNameController.clear();
              }
            },
                child: const Text("SAVE LOI"))
          ],
        );},
      ),
    );
  }

  void dialogCancel() {
    setState(() {
      _validateLoiName = true;
    });
    Navigator.of(context).pop();
    _loiNameController.clear();
  }
}

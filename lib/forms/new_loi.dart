// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:low_ses_health_resource_app/app_colors.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:low_ses_health_resource_app/utility/ui_messages.dart';
// import '../blocs/loi_bloc.dart';
// import '../request_models/loi_request_model.dart';
// import '../utility/utility_widgets.dart';
//
// class NewLocation extends StatefulWidget {
//   const NewLocation({super.key});
//
//   @override
//   State<NewLocation> createState() => _NewLocationState();
// }
//
// class _NewLocationState extends State<NewLocation> {
//
//   late TextEditingController _locationController = TextEditingController();
//   //dynamic uuid = Uuid();
//   String _sessionToken = '12345';
//   List<SearchInfo> _placesList = [];
//   late TextEditingController _loiNameController;
//   bool _validateLoiName = true;
//   String? _loiName = "";
//   //based on _isNewLoi the previous page will be refreshed
//   bool _isNewLoi = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _locationController.addListener(() {
//       onChange();
//     });
//     _loiNameController = TextEditingController();
//   }
//
//   @override
//   void dispose(){
//     //_loiNameController.removeListener(() { });
//     _loiNameController.dispose();
//     super.dispose();
//   }
//
//   void onChange(){
//     // if(_sessionToken == null){
//     //   setState(() {
//     //     _sessionToken = uuid.v4();
//     //   });
//     // }
//     getSuggestion(_locationController.text);
//   }
//
//   void getSuggestion(String input) async{
//     String api_key = "";
//     String baseURL = "";
//     String request = "baseURL with api key and session";
//     List<SearchInfo> suggestions = [];
//
//     //dynamic response = await http.get(Uri.parse(request));
//     //print(response.body.toString());
//
//     try {
//       suggestions = await addressSuggestion(input);
//       print(suggestions.isNotEmpty? suggestions.first.address:"###no suggestion");
//     } catch (e, s) {
//       print('Failed to load places.Exception details:\n $e');
//       print('Stack trace:\n $s');
//     }
//
//     //List<SearchInfo> suggestions = await addressSuggestion(input);
//     //print(suggestions.isNotEmpty? suggestions.first.address:"###no suggestion");
//
//     if(mounted && suggestions.isNotEmpty) {
//       setState(() {
//         //_placesList = jsonDecode(response.body.toString()) ['predictions'];
//         _placesList = suggestions;
//       });
//     }
//     // }else{
//     //   throw Exception('Failed to load places');
//     // }
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColor.primaryBackgroundColor,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           onPressed: (){
//             Navigator.pop(context, {'isNewLoi' : _isNewLoi,});
//           },
//           icon:const Icon(
//             Icons.arrow_back_ios,
//             color: AppColor.darkIconColor,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _locationController,
//               decoration: const InputDecoration(
//                 hintText: 'Enter an address',
//                 hintStyle: TextStyle(
//                   color: AppColor.primaryTextColor
//                 ),
//                 filled: true,
//                 fillColor: AppColor.inputFieldFillColor,
//                 border: InputBorder.none,
//               ),
//             ),
//             SizedBox(height: 10,),
//             Expanded(
//                 child: ListView.builder(
//                   itemCount: _placesList.length,
//                   itemBuilder: (context, index){
//                     return ListTile(
//                       leading: const Icon(Icons.location_pin),
//                       title: Text(getMainTitleOfPlace(_placesList[index].address)),
//                       subtitle: Text(getSubTitleOfPlace(_placesList[index].address)),
//                       onTap: () {
//                         if(_placesList[index].point != null) {
//                           saveNewLoi((_placesList[index].point)!);
//                         }
//                       },
//                     );
//                   }
//                 )
//             )
//           ],
//         ),
//       ),
//
//     );
//   }
//
//   String getMainTitleOfPlace(Address? address) {
//     String mainTitle = "";
//     if (address?.name != null && (address?.name)!.isNotEmpty) {
//       mainTitle = "$mainTitle${address?.name},";
//     }
//     if (address?.street != null && (address?.street)!.isNotEmpty) {
//       mainTitle = "$mainTitle${address?.street}";
//     }
//
//     return mainTitle;
//   }
//
//   String getSubTitleOfPlace(Address? address) {
//     String subTitle = "";
//     if (address?.city != null && (address?.city)!.isNotEmpty) {
//       subTitle = "$subTitle${address?.city},";
//     }
//     if (address?.state != null && (address?.state)!.isNotEmpty) {
//       subTitle = "$subTitle${address?.state},";
//     }
//     if (address?.postcode != null && (address?.postcode)!.isNotEmpty) {
//       subTitle = "$subTitle${address?.postcode},";
//     }
//     if (address?.country != null && (address?.country)!.isNotEmpty) {
//       subTitle = "$subTitle${address?.country}";
//     }
//
//     return subTitle;
//   }
//
//   void saveNewLoi(GeoPoint point) async{
//     Future<bool> response;
//     List<int> providerIdList = [];
//
//     //get the Loi name from a dialog
//     _loiName = (await openDialog());
//     _loiName = _loiName?.trim();
//
//     if(_loiName != null && _loiName!.isNotEmpty) {
//       LoiRequest newLoiRequest = LoiRequest(
//           name: _loiName!,
//           longitude: point.longitude,
//           latitude: point.latitude),
//           athleteId: ;
//       try {
//         response = loiBloc.createLoi(newLoiRequest);
//
//         if (await response) {
//           _isNewLoi = true;
//           UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_NEW_LOI);
//           Navigator.pop(context, {'isNewLoi' : _isNewLoi,});
//         }
//
//       } catch (e, stacktrace) {
//         _isNewLoi = false;
//         if (kDebugMode) {
//           print(e.toString());
//           print(stacktrace.toString());
//         }
//         UtilityWidgets.showErrorToast(context, UiMessage.ERROR_NEW_LOI);
//       }
//
//       // if (await response) {
//       //   _isNewLoi = true;
//       //   UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_NEW_LOI);
//       //   Navigator.pop(context, {'isNewLoi' : _isNewLoi,});
//       // } else {
//       //   _isNewLoi = false;
//       //   UtilityWidgets.showErrorToast(context, UiMessage.ERROR_NEW_LOI);
//       // }
//     }
//
//   }
//
//   Future<String?> openDialog()
//   {
//     return showDialog<String>(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) { return AlertDialog(
//           title: Text("LOI Name"),
//           content: TextField(
//             autofocus: true,
//             decoration: InputDecoration(
//               hintText: 'Enter a name',
//               errorText: _validateLoiName ? null : 'Value cannot be empty',
//             ),
//             controller: _loiNameController,
//             onTap: () {
//               setState(() {
//                 _validateLoiName = true;
//               });
//             },
//           ),
//           actions: [
//             TextButton(onPressed: dialogCancel, child: Text("CANCEL")),
//             TextButton(onPressed: () {
//               setState(() {
//                 _loiNameController.text.isEmpty
//                     ? _validateLoiName = false
//                     : _validateLoiName = true;
//               });
//               if (_loiNameController.text.isEmpty) {
//               }
//               if(_validateLoiName) {
//                 Navigator.of(context).pop(_loiNameController.text);
//                 _loiNameController.clear();
//               }
//             },
//                 child: Text("SAVE LOI"))
//           ],
//         );},
//       ),
//     );
//   }
//
//   void dialogCancel() {
//     setState(() {
//       _validateLoiName = true;
//     });
//     Navigator.of(context).pop();
//     _loiNameController.clear();
//   }
//
//   // void _showToast(BuildContext context, String content) {
//   //   final scaffold = ScaffoldMessenger.of(context);
//   //   scaffold.showSnackBar(
//   //     SnackBar(
//   //       content: Text(content),
//   //       duration: Duration( seconds: 2),
//   //       backgroundColor: primaryThemeColor,
//   //       action: SnackBarAction(
//   //         label: 'Dismiss',
//   //         onPressed: scaffold.hideCurrentSnackBar,
//   //         disabledTextColor: Colors.white,
//   //         textColor: Colors.yellow,
//   //       ),
//   //     ),
//   //   );
//   // }
//
// }
//

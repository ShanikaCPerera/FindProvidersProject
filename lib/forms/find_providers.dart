import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:low_ses_health_resource_app/app_colors.dart';
import 'package:low_ses_health_resource_app/blocs/loi_bloc.dart';
import 'package:low_ses_health_resource_app/response_models/athlete_response_model.dart';
import 'package:low_ses_health_resource_app/blocs/athlete_bloc.dart';
import 'package:low_ses_health_resource_app/response_models/location_of_interest_response_model.dart';
import 'package:low_ses_health_resource_app/utility/datetime_extension.dart';
import 'package:low_ses_health_resource_app/utility/enumerations.dart';
import 'package:low_ses_health_resource_app/blocs/insurance_type_bloc.dart';
import 'package:low_ses_health_resource_app/response_models/insurance_type_response_model.dart';
import 'package:low_ses_health_resource_app/response_models/speciality_response_model.dart';
import 'package:low_ses_health_resource_app/blocs/speciality_bloc.dart';
import 'package:low_ses_health_resource_app/request_models/find_provider_request_model.dart';
import 'package:low_ses_health_resource_app/pages/providers_list.dart';
import 'package:low_ses_health_resource_app/utility/ui_messages.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../services/exception_handler.dart';
import '../utility/utility.dart';
import '../utility/utility_widgets.dart';
import 'package:time_range_picker/time_range_picker.dart';

class FindProviders extends StatefulWidget {

  final AthleteResponse? selectedAthlete;

  const FindProviders({
    super.key,
    this.selectedAthlete
  });

  @override
  State<FindProviders> createState() => _FindProvidersState();
}

class _FindProvidersState extends State<FindProviders> {

  late AthleteResponse? selectedAthlete;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AthleteResponse? _selectedAthlete;
  late TextEditingController _athleteController;
  late TextEditingController _hoursOfOpController;
  late List<SpecialityResponse> _selectedSpecialityList;
  bool _selectedTelemedicine = false;
  late List<InsuranceTypeResonse> _selectedInsuranceTypeList;
  late List<PaymentTypeEnum> _selectedPaymentTypeList = [];
  TimeOfDay? _selectedHoursOfOpStart;
  TimeOfDay? _selectedHoursOfOpEnd;
  late List<DaysOfOperationEnum> _selectedDaysOfOperationList = [];
  late List<LanguageEnum> _selectedLanguageList = [];
  int? _selectedEthnicity;
  int? _selectedGender;
  LocationOfInterestResponse? _selectedLoi;
  int? _selectedRadius;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;


  String _errorText = '';
  bool _hasError = false;

  final AthleteBloc athleteBloc = AthleteBloc();
  final InsuranceTypeBloc insTypeBloc = InsuranceTypeBloc();
  final SpecialityBloc specialityBloc = SpecialityBloc();
  final LoiBloc loiBloc = LoiBloc();

  @override
  void initState() {
    super.initState();
    selectedAthlete = widget.selectedAthlete;
    if(selectedAthlete != null) {
      _athleteController = TextEditingController(text: "${selectedAthlete!.getFname} ${selectedAthlete!.getLname}");
      loiBloc.fetchLoiList(selectedAthlete!.getId).catchError((e, stacktrace){

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
          setState(() {
            _hasError = true;
            _errorText = ExceptionHandlers().getExceptionString(e);
          });
        }

      });

    } else {
      athleteBloc.fetchAllAthletes().catchError((e, stacktrace){

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
          setState(() {
            _hasError = true;
            _errorText = ExceptionHandlers().getExceptionString(e);
          });
        }

      });
    }

    insTypeBloc.fetchAllInsTypes().catchError((e, stacktrace){

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
        setState(() {
          _hasError = true;
          _errorText = ExceptionHandlers().getExceptionString(e);
        });
      }

    });

    specialityBloc.fetchAllSpecialities().catchError((e, stacktrace){

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
        setState(() {
          _hasError = true;
          _errorText = ExceptionHandlers().getExceptionString(e);
        });
      }

    });
    _hoursOfOpController = TextEditingController();
  }

  @override
  void dispose() {
    athleteBloc.dispose();
    insTypeBloc.dispose();
    specialityBloc.dispose();
    loiBloc.dispose();
    _hoursOfOpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return UtilityWidgets.errorScreen(context, _errorText, 'Find Providers');
    } else {
      return Scaffold(
        backgroundColor: AppColor.primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColor.primaryThemeColor,
          title: const Text('Find Providers'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.home,
                ),
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName('/home'));
                }),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height:20),
                  //Athlete field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                        text: const TextSpan(
                          text: "Athlete",
                          style: TextStyle(
                              color: AppColor.primaryTextColor,
                              ),
                          children: <TextSpan>[
                            TextSpan(
                                text: '*', style:
                                TextStyle(color: AppColor.errorTextColor)
                            ),
                          ],
                        ),
                      ),
                  ),
                  const SizedBox(height:8),
                  buildAthleteDropDown(selectedAthlete),
                  const SizedBox(height: 20,),
                  //speciality
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: const TextSpan(
                        text: "Specialities",
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: '*', style:
                          TextStyle(color: AppColor.errorTextColor)
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height:8),
                  StreamBuilder(
                    stream: specialityBloc.allSpecialities,
                    builder: (context,
                        AsyncSnapshot<List<SpecialityResponse>> snapshot) {
                      if (snapshot.hasData) {
                        return buildSpecialityDropDown(snapshot.data!);
                      } else if (snapshot.hasError) {
                        UtilityWidgets.showErrorToast(context, snapshot.error
                            .toString());
                      }
                      //return buildSpecialityDropDown(snapshot.data);
                      return const Center(
                          child: CupertinoActivityIndicator(
                            color: AppColor.primaryThemeColor,
                            radius: 10,
                            animating: true,
                          )
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  //Insurance Type Field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: const TextSpan(
                        text: "Insurance Types",
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: '*', style:
                          TextStyle(color: AppColor.errorTextColor)
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height:8),
                  StreamBuilder(
                    stream: insTypeBloc.allInsuranceTypes,
                    builder: (context,
                        AsyncSnapshot<List<InsuranceTypeResonse>> snapshot) {
                      if (snapshot.hasData) {
                        return buildInsTypeDropDown(snapshot.data!);
                      } else if (snapshot.hasError) {
                        UtilityWidgets.showErrorToast(context, snapshot.error.toString());
                      }
                      //return buildInsTypeDropDown(snapshot.data);
                      return const Center(
                          child: CupertinoActivityIndicator(
                            color: AppColor.primaryThemeColor,
                            radius: 10,
                            animating: true,
                          )
                      );
                    },
                  ),
                  const SizedBox(height: 20.0),
                  //Telemedicine field
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Need Telemedicine?",
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                        ),
                      ),
                      Switch( //switch at right side of label
                        value: _selectedTelemedicine,
                        onChanged: (bool value) {
                          setState(() {
                            _selectedTelemedicine =
                                value; //update value when switch changed
                          });
                        },
                        activeColor: AppColor.primaryThemeColor,
                      ),
                    ],
                  ),
                  const SizedBox(height:20),
                  //Payment Type field
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Payment Types',
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                        )
                    ),
                  ),
                  const SizedBox(height:8),
                  buildPaymentTypeDropDown(),
                  const SizedBox(height:20),
                  //Hours of Operation field
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Available Time',
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                        )
                    ),
                  ),
                  const SizedBox(height:8),
                  TextFormField(
                      controller: _hoursOfOpController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
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
                        // suffixIcon: const Icon(
                        //   Icons.access_time_filled_outlined,
                        //   color: AppColor.lightIconColor,
                        // ),
                        // suffixIcon: IconButton(
                        //   icon: const Icon(
                        //     Icons.access_time_filled_outlined,
                        //     color: AppColor.primaryThemeColor
                        //   ),
                        //   onPressed: () async {
                        //      _showTimeRangePicker(context);
                        //    },
                        // ),
                        suffixIcon: Container(
                          width: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  _hoursOfOpController.text = "";
                                  _selectedHoursOfOpStart = null;
                                  _selectedHoursOfOpEnd = null;
                                },
                                icon: const Icon(
                                  Icons.close,
                                  //color: background_color,
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.fromLTRB(1, 0, 10, 0),
                                constraints: BoxConstraints(),
                                onPressed: () async {
                                  _showTimeRangePicker(context);
                                },
                                icon: const Icon(
                                  Icons.access_time_filled_outlined,
                                  //color: background_color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // suffix: IconButton(
                        //   icon: const Icon(Icons.close),
                        //   onPressed: _hoursOfOpController.clear,
                        // ),
                        hintText: 'Select time range',
                        hintStyle: const TextStyle(
                          color: AppColor.hintTextColor,
                        ),
                      ),
                      readOnly: true,
                      // onTap: () async {
                      //   _showTimeRangePicker(context);
                      // }
                  ),
                  const SizedBox(height:20),
                  //Days of Operation field
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Available Day',
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                        )
                    ),
                  ),
                  const SizedBox(height:8),
                  buildDaysOfOperationDropDown(),
                  const SizedBox(height:20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Gender of Provider',
                      style: TextStyle(
                        color: AppColor.primaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height:10),
                  DropdownButtonFormField(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                    ),
                    hint: const Text(
                      "Select a Gender",
                      style: TextStyle(
                        color: AppColor.hintTextColor,
                      ),
                    ),
                    //value: _selectedGender,
                    items: ProviderGenderEnum.values.map(
                            (e) => DropdownMenuItem(value: e,child: Text(e.name),)
                    ).toList(),
                    onChanged: (val) {
                      setState(() {
                        if(val?.index == 5){
                          _selectedGender = null;
                        } else {
                          _selectedGender = val!.index;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      //labelText: "payment Type",
                      labelStyle: const TextStyle(
                        fontSize: 23.0,
                        color: AppColor.primaryTextColor,
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
                  const SizedBox(height:20),
                  //Language field
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Language of Provider',
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                        )
                    ),
                  ),
                  const SizedBox(height:8),
                  buildLanguageDropDown(),
                  const SizedBox(height:20),
                  //Ethnicity field
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        'Ethnicity of Provider',
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                        )
                    ),
                  ),
                  const SizedBox(height:8),
                  DropdownButtonFormField(
                    menuMaxHeight: (MediaQuery
                        .of(context)
                        .size
                        .height) / 2,
                    isExpanded: true,
                    isDense: true,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                    ),
                    hint: const Text(
                      "Select an ethnicity",
                      style: TextStyle(
                        color: AppColor.hintTextColor,),
                    ),
                    //value: _selectedEthnicity,
                    items: EthnicityEnum.values.map(
                            (e) =>
                            DropdownMenuItem(value: e, child: Text(e.name),)
                    ).toList(),
                    onChanged: (val) {
                      setState(() {
                        if(val?.index == 8){
                          _selectedEthnicity = null;
                        } else {
                          _selectedEthnicity = val!.index;
                        }
                      });
                    },
                    decoration: InputDecoration(
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
                  const SizedBox(height:20),
                  //LOI field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: const TextSpan(
                        text: "Location of Interest of Athlete",
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: '*',
                              style: TextStyle(color: AppColor.errorTextColor)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height:8),
                  StreamBuilder(
                    stream: loiBloc.athleteLoiList,
                    builder: (context, AsyncSnapshot<List<LocationOfInterestResponse>> snapshot) {
                      if (snapshot.hasData) {
                        return buildLoiDropDown(snapshot.data);
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      return buildLoiDropDown(snapshot.data);
                    },
                  ),
                  const SizedBox(height:20),
                  //Radius field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: const TextSpan(
                        text: "Radius (mi)",
                        style: TextStyle(
                          color: AppColor.primaryTextColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: '*',
                              style: TextStyle(color: AppColor.errorTextColor)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height:8),
                  DropdownButtonFormField(
                    menuMaxHeight: (MediaQuery
                        .of(context)
                        .size
                        .height) / 2,
                    isExpanded: true,
                    isDense: true,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                    ),
                    hint: const Text(
                      "Select radius",
                      style: TextStyle(
                        color: AppColor.hintTextColor,),
                    ),
                    //value: _selectedRadius,
                    items: RadiusEnum.values.map(
                            (e) =>
                            DropdownMenuItem(value: e, child: Text(e.name
                                .toString()),)
                    ).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedRadius = val?.name;
                      });
                    },
                    decoration: InputDecoration(
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
                      if (value == null) {
                        return UiMessage.NO_EMPTY_RADIUS;
                      }
                      else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_formKey.currentState!.validate()) {
                          openProvidersListPage();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                      backgroundColor: AppColor.primaryThemeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Find Providers',
                      style: TextStyle(
                        color: AppColor.buttonTextColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget buildAthleteDropDown(AthleteResponse? selectedAthlete)
  {
    if (selectedAthlete != null) {
      return TextFormField(
        controller: _athleteController,
        enabled: false,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: AppColor.inputFieldEnabledBorderColor,
                width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: AppColor.inputFieldDisabledBorderColor,
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
      );
    }
    else
    {
      return buildAthleteDropDownWithSearch();
    }

  }
  Widget buildAthleteDropDownWithSearch()
  {
    return StreamBuilder(
      stream: athleteBloc.allAthletes,
      builder: (context, AsyncSnapshot<List<AthleteResponse>> snapshot) {
        if (snapshot.hasData) {
          return DropdownSearch<AthleteResponse>(
            //asyncItems: (filter){ return snapshot.data as Future<List<Athlete>>;},
            items: snapshot.data!,
            itemAsString: (AthleteResponse u) => u.AthleteAsName(),
            popupProps: PopupProps.dialog(
              showSelectedItems: true,
              itemBuilder: _customPopupItemBuilderForAthlete,
              showSearchBox: true,
            ),
            compareFn: (item, sItem) => item.AthleteAsName() == sItem.AthleteAsName,
            onChanged: (val) {
              _selectedAthlete = val;
              try {
                loiBloc.fetchLoiList(val!.getId);
              } catch(e, stacktrace) {

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
              }

              // setState((){
              //   _selectedAthlete = val;
              //   //_loiList = _selectedAthlete!.getLoiList;
              // });
            },
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                hintText: "Select an athlete",
                hintStyle: const TextStyle(
                  color: AppColor.hintTextColor,
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
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){
              if (value == null)
              {
                return UiMessage.NO_EMPTY_ATHLETE;
              }
              else {
                return null;
              }
            },
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return const Center(
            child: CupertinoActivityIndicator(
              color: AppColor.primaryThemeColor,
              radius: 10,
              animating: true,
            )
        );
      },
    );
  }

  Widget buildLoiDropDown(List<LocationOfInterestResponse>? loiList){
    return DropdownButtonFormField(
      menuMaxHeight: (MediaQuery
          .of(context)
          .size
          .height) / 2,
      isExpanded: true,
      isDense: true,
      icon: const Icon(
        Icons.arrow_drop_down,
      ),
      hint: const Text(
        "Select a LOI",
        style: TextStyle(
          color: AppColor.hintTextColor,
        ),
      ),
      //value: _selectedLoi,
      items: loiList?.map(
              (e) =>
              DropdownMenuItem(value: e, child: Text(e.getName),)
      ).toList(),
      onChanged: (val) {
        setState(() {
          _selectedLoi = val as LocationOfInterestResponse;
        });
      },
      decoration: InputDecoration(
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
        disabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AppColor.inputFieldDisabledBorderColor,
              width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null) {
          return 'Please select LOI';
        }
        else {
          return null;
        }
      },
    );
  }

  Widget _customPopupItemBuilderForAthlete(BuildContext context, AthleteResponse item, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              //color: Colors.white,
          ),
      child: ListTile(
        selected: isSelected,
        title: Text(item.AthleteAsName()),
        //subtitle: Text(item.createdAt.toString()),
        leading: CircleAvatar(
          backgroundImage: item.getProfilePicture != null ? NetworkImage(item.getProfilePicture!) : const AssetImage('assets/images/default_profile_picture.jpg') as ImageProvider,
          backgroundColor: AppColor.imageBackgroundColor,
        ),
      ),
    );
  }

  Widget buildSpecialityDropDown(List<SpecialityResponse> specialityList)
  {
    return MultiSelectDialogField(
      items: specialityList.map(
              (e) => MultiSelectItem(e,e.getName))
          .toList(),
      listType: MultiSelectListType.LIST,
      onConfirm: (values) {
        _selectedSpecialityList = values;
      },
      // onSelectionChanged: (values){
      //   if(values.contains('S')){
      //     setState(() {
      //
      //     });
      //   }
      // },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (values){
        if (values == null || values.isEmpty)
        {
          return UiMessage.NO_EMPTY_SPECIALITY;
        }
        else {
          return null;
        }
      },
      decoration: BoxDecoration(
        color: AppColor.inputFieldDisabledBorderColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColor.inputFieldDisabledBorderColor,
          width: 2,
        ),
      ),
      cancelText: const Text(
        "Cancel",
        style: TextStyle(
          color: AppColor.controlTextColor,
        ),
      ),
      confirmText: const Text(
        "Ok",
        style: TextStyle(
          color: AppColor.controlTextColor,
        ),
      ),
      buttonIcon: const Icon(
        Icons.playlist_add_outlined,
        color: AppColor.lightIconColor,
      ),
      buttonText: const Text(
        "Select specialities",
        style: TextStyle(
          color: AppColor.hintTextColor,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildInsTypeDropDown(List<InsuranceTypeResonse> insTypeList)
  {
    return MultiSelectDialogField(
      items: insTypeList.map(
              (e) => MultiSelectItem(e,e.getName))
          .toList(),
      listType: MultiSelectListType.LIST,
      onConfirm: (values) {
        _selectedInsuranceTypeList = values;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (values){
        if (values == null || values.isEmpty)
        {
          return UiMessage.NO_EMPTY_INS_TYPE;
        }
        else {
          return null;
        }
      },
      decoration: BoxDecoration(
        color: AppColor.inputFieldDisabledBorderColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColor.inputFieldDisabledBorderColor,
          width: 2,
        ),
      ),
      cancelText: const Text(
        "Cancel",
        style: TextStyle(
          color: AppColor.controlTextColor,
        ),
      ),
      confirmText: const Text(
        "Ok",
        style: TextStyle(
          color: AppColor.controlTextColor,
        ),
      ),
      buttonIcon: const Icon(
        Icons.playlist_add_outlined,
        color: AppColor.lightIconColor,
      ),
      buttonText: const Text(
        "Select insurance types",
        style: TextStyle(
          color: AppColor.hintTextColor,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildPaymentTypeDropDown()
  {
    return MultiSelectDialogField(
      items: PaymentTypeEnum.values.map(
              (e) => MultiSelectItem(e, e.name))
          .toList(),
      listType: MultiSelectListType.LIST,
      onConfirm: (values) {
        _selectedPaymentTypeList = values;
      },
      decoration: BoxDecoration(
        color: AppColor.inputFieldDisabledBorderColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColor.inputFieldDisabledBorderColor,
          width: 2,
        ),
      ),
      cancelText: const Text(
        "Cancel",
        style: TextStyle(
          color: AppColor.controlTextColor,
        ),
      ),
      confirmText: const Text(
        "Ok",
        style: TextStyle(
          color: AppColor.controlTextColor,
        ),
      ),
      buttonIcon: const Icon(
        Icons.playlist_add_outlined,
        color: AppColor.lightIconColor,
      ),
      buttonText: const Text(
        "Select payment types",
        style: TextStyle(
          color: AppColor.hintTextColor,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildDaysOfOperationDropDown()
  {
    return MultiSelectDialogField(
      items: DaysOfOperationEnum.values.map(
              (e) => MultiSelectItem(e, e.name))
          .toList(),
      listType: MultiSelectListType.LIST,
      onConfirm: (values) {
        _selectedDaysOfOperationList = values;
      },
      decoration: BoxDecoration(
        color: AppColor.inputFieldDisabledBorderColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColor.inputFieldDisabledBorderColor,
          width: 2,
        ),
      ),
      cancelText: const Text(
        "Cancel",
        style: TextStyle(
          color: AppColor.controlTextColor,
        ),
      ),
      confirmText: const Text(
        "Ok",
        style: TextStyle(
          color: AppColor.controlTextColor,
        ),
      ),
      buttonIcon: const Icon(
        Icons.playlist_add_outlined,
        color: AppColor.lightIconColor,
      ),
      buttonText: const Text(
        "Select days",
        style: TextStyle(
          color: AppColor.hintTextColor,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildLanguageDropDown()
  {
    return MultiSelectDialogField(
      items: LanguageEnum.values.map(
              (e) => MultiSelectItem(e, e.name))
          .toList(),
      listType: MultiSelectListType.LIST,
      onConfirm: (values) {
        _selectedLanguageList = values;
      },
      decoration: BoxDecoration(
        color: AppColor.inputFieldDisabledBorderColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: AppColor.inputFieldDisabledBorderColor,
          width: 2,
        ),
      ),
      cancelText: const Text(
        "Cancel",
        style: TextStyle(
          color: AppColor.controlTextColor,
        ),
      ),
      confirmText: const Text(
        "Ok",
        style: TextStyle(
          color: AppColor.controlTextColor,
        ),
      ),
      buttonIcon: const Icon(
        Icons.playlist_add_outlined,
        color: AppColor.lightIconColor,
      ),
      buttonText: const Text(
        "Select languages",
        style: TextStyle(
          color: AppColor.hintTextColor,
          fontSize: 16,
        ),
      ),
    );
  }

  void _showTimeRangePicker(BuildContext context) async {
    if (_selectedHoursOfOpStart == null && _selectedHoursOfOpEnd == null) {
      _startTime = TimeOfDay.now();
      _endTime = TimeOfDay.now().addMinutes(120);
    }else {
      _startTime = _selectedHoursOfOpStart;
      _endTime = _selectedHoursOfOpEnd;
    }

    TimeRange? selectedTimeRange = await showTimeRangePicker(
      context: context,
      start: _startTime,
      end: _endTime,
      onStartChange: (start) {
        setState(() {
          _startTime = start;
        });
      },
      onEndChange: (end) {
        setState(() {
          _endTime = end;
        });
      },
      interval: const Duration(minutes: 1),
      minDuration: const Duration(hours: 1),
      use24HourFormat: false,
      padding: 30,
      strokeWidth: 15,
      handlerRadius: 10,
      //strokeColor: Colors.white,
      //handlerColor: Colors.orange[700],
      selectedColor: AppColor.highlightTextColor,
      backgroundColor: Colors.black.withOpacity(0.3),
      ticks: 24,
      ticksColor: AppColor.controlIconColor,
      snap: true,
      labels: [
        "12 am",
        "3 am",
        "6 am",
        "9 am",
        "12 pm",
        "3 pm",
        "6 pm",
        "9 pm"
      ].asMap().entries.map((e) {
        return ClockLabel.fromIndex(
            idx: e.key, length: 8, text: e.value);
      }).toList(),
      labelOffset: -30,
      labelStyle: const TextStyle(
          fontSize: 15,
          color: AppColor.secondaryTextColor,
          fontWeight: FontWeight.bold),
      timeTextStyle: const TextStyle(
          color: AppColor.lightTextColor,
          fontSize: 24,
          //fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
      activeTimeTextStyle: const TextStyle(
          color: AppColor.highlightTextColor,
          fontSize: 26,
          fontWeight: FontWeight.bold),

    );

    if (selectedTimeRange != null) {
      _selectedHoursOfOpStart = selectedTimeRange.startTime;
      _selectedHoursOfOpEnd = selectedTimeRange.endTime;
      _hoursOfOpController.text = '${_selectedHoursOfOpStart!.format(context)} - ${_selectedHoursOfOpEnd!.format(context)}';
    }

  }

  void openProvidersListPage() {
      List<int> selectedSpecialityIdList = [];
      List<int> selectedInsTypeIdList = [];
      List<int> selectedPayTypeIndexList = [];
      List<int> selectedDaysOfOperationIndexList = [];
      List<int> selectedLanguageIndexList = [];

      for (SpecialityResponse spec in _selectedSpecialityList) {
        selectedSpecialityIdList.add(spec.getId);
      }

      for (InsuranceTypeResonse insType in _selectedInsuranceTypeList) {
        selectedInsTypeIdList.add(insType.getId);
      }

      if(_selectedPaymentTypeList != null) {
        for (PaymentTypeEnum payType in _selectedPaymentTypeList) {
          selectedPayTypeIndexList.add(payType.index);
        }
      }
      if(_selectedDaysOfOperationList != null) {
        for (DaysOfOperationEnum dayOfOp in _selectedDaysOfOperationList) {
          selectedDaysOfOperationIndexList.add(dayOfOp.index);
        }
      }

      if(_selectedLanguageList != null) {
        for (LanguageEnum lan in _selectedLanguageList) {
          selectedLanguageIndexList.add(lan.index);
        }
      }

      FindProviderRequest? findProvidersRequest = FindProviderRequest(
        athleteId: selectedAthlete != null ? selectedAthlete!.getId : _selectedAthlete!.getId,
        specialityIdList: selectedSpecialityIdList,
        insTypeIdList: selectedInsTypeIdList,
        telemedicine: _selectedTelemedicine,
        paymentTypeIndexList: selectedPayTypeIndexList,
        hoursOfOperationStart: _selectedHoursOfOpStart,
        hoursOfOperationEnd: _selectedHoursOfOpEnd,
        daysOfOperationIndexList: selectedDaysOfOperationIndexList,
        languageIndexList: selectedLanguageIndexList,
        ethnicityIndex: _selectedEthnicity,
        genderIndex: _selectedGender,
        loiId: _selectedLoi!.getId,
        radius: _selectedRadius!,
      );

      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) {
            return ProviderList(findProvidersRequest:findProvidersRequest!);
          },
        ),
      );
  }

}

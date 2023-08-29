import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:low_ses_health_resource_app/app_colors.dart';
import 'package:low_ses_health_resource_app/request_models/athlete_request_model.dart';
import 'package:low_ses_health_resource_app/utility/ui_messages.dart';
import '../blocs/athlete_bloc.dart';
import 'package:low_ses_health_resource_app/utility/string_extension.dart';
import '../response_models/athlete_response_model.dart';
import '../services/exception_handler.dart';
import '../utility/enumerations.dart';
import 'package:email_validator/email_validator.dart';
import '../utility/utility.dart';
import '../utility/utility_widgets.dart';

class UpdateAthleteProfile extends StatefulWidget {

  final bool newAthlete;
  final bool updateAthlete;
  final AthleteResponse? selectedAthlete;

  const UpdateAthleteProfile({
    super.key,
    required this.newAthlete,
    required this.updateAthlete,
    this.selectedAthlete
  });

  @override
  State<UpdateAthleteProfile> createState() => _UpdateAthleteProfileState();
}

class _UpdateAthleteProfileState extends State<UpdateAthleteProfile> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AthleteResponse? selectedAthlete;
  late bool newAthlete;
  late bool updateAthlete;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late GenderEnum? _selectedGender;
  late DateTime? _selectedDob;
  late TextEditingController _dobController;
  late ClassificationEnum? _selectedClassification;
  bool _isNewOrUpdateAthlete = false;
  bool _isChanged = false;

  final AthleteBloc athleteBloc = AthleteBloc();

  bool _isWaitingForApi = false;

  @override
  void initState() {
    super.initState();

    selectedAthlete = widget.selectedAthlete;
    newAthlete = widget.newAthlete;
    updateAthlete = widget.updateAthlete;

    if(selectedAthlete != null) {
      _firstNameController = TextEditingController(text: selectedAthlete?.getFname);
      _lastNameController = TextEditingController(text: selectedAthlete?.getLname);
      _emailController = TextEditingController(text: selectedAthlete?.getEmail);
      _selectedGender = GenderEnum.values[selectedAthlete!.getGender];
      _selectedDob = selectedAthlete?.getDob;
      _dobController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(selectedAthlete!.getDob));
      _selectedClassification = ClassificationEnum.values[selectedAthlete!.getClassification];
    } else{
      _firstNameController = TextEditingController();
      _lastNameController = TextEditingController();
      _emailController = TextEditingController();
      _selectedGender = null;
      _selectedDob = null;
      _dobController = TextEditingController();
      _selectedClassification = null;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    athleteBloc.dispose();
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
            title: selectedAthlete != null
              ? const Text("Update Athlete Profile",
                    style: TextStyle(
                      color: AppColor.titleTextColor,
                      fontSize: 20.0,
                    ),
                )
              : const Text("New Athlete Profile",
                  style: TextStyle(
                    color: AppColor.titleTextColor,
                    fontSize: 20.0,
                  ),
                ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context, {'isNewOrUpdateAthlete' : _isNewOrUpdateAthlete,});
              },
              icon:const Icon(
                Icons.close,
                color: AppColor.darkIconColor,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: _isChanged? () async{
                  //print(_isNewOrUpdateAthlete.toString());
                  if(_formKey.currentState!.validate())
                  {
                    await saveAthleteProfile(newAthlete, updateAthlete);
                  }
                } : null,
                child: const Text("Done"),
              ),
            ],
          ),
          body:Padding(
            padding: const EdgeInsets.fromLTRB(13.0, 10.0, 9.0, 14.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //First name field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'First name',
                          style: TextStyle(
                            color: AppColor.primaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height:10),
                      TextFormField(
                        controller: _firstNameController,
                        onChanged: (text){
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
                            onPressed: _firstNameController.clear,
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
                        validator: (value){
                          if (value == null || value.isEmpty)
                          {
                            return UiMessage.NO_EMPTY_NAME;
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      //last name field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Last name',
                          style: TextStyle(
                            color: AppColor.primaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height:10),
                      TextFormField(
                        controller: _lastNameController,
                        onChanged: (text){
                          setState(() {
                            _isChanged = true;
                          });
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[A-z ]')),
                          LengthLimitingTextInputFormatter(50),
                        ],
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value){
                          if (value == null || value.isEmpty)
                          {
                            return UiMessage.NO_EMPTY_NAME;
                          }
                          else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter last name",
                          suffixIcon: IconButton(
                            onPressed: _lastNameController.clear,
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
                      ),
                      const SizedBox(height: 24),
                      //email field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            color: AppColor.primaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height:10),
                      TextFormField(
                        controller: _emailController,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(
                              RegExp(r'\s')),
                          LengthLimitingTextInputFormatter(50),
                        ],
                        onChanged: (text){
                          setState(() {
                            _isChanged = true;
                          });
                        },
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
                          hintText: "Enter email",
                          suffixIcon: IconButton(
                            onPressed: _emailController.clear,
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
                      ),
                      const SizedBox(height: 24),
                      //gender field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Gender',
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
                        hint: const Text("Select an item"),
                        value: _selectedGender,
                        items: GenderEnum.values.map(
                                (e) => DropdownMenuItem(value: e,child: Text(e.name),)
                        ).toList(),
                        onChanged: (val) {
                          setState(() {
                            _isChanged = true;
                            _selectedGender = val;
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
                          //filled: true,
                          //fillColor: Colors.grey.shade200,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value){
                          if (value == null)
                          {
                            return UiMessage.NO_EMPTY_GENDER;
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      //dob field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Date of Birth',
                          style: TextStyle(
                            color: AppColor.primaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value){
                          if (value == null || value.isEmpty)
                          {
                            return UiMessage.NO_EMPTY_DOB;
                          }
                          else {
                            return null;
                          }
                        },
                        controller: _dobController,
                        onChanged: (text){
                          setState(() {
                            _isChanged = true;
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
                          suffixIcon: const Icon(
                            Icons.calendar_month_sharp,
                            color: AppColor.lightIconColor,
                          ),
                        ),
                        readOnly: true,
                        onTap: () {
                          showDatePicker(context);
                        }
                      ),
                      const SizedBox(height: 24),
                      //classification field
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Classification',
                          style: TextStyle(
                            color: AppColor.primaryTextColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField(
                        icon: const Icon(
                          Icons.arrow_drop_down,
                        ),
                        hint: const Text("Select an item"),
                        value: _selectedClassification,
                        items: ClassificationEnum.values.map(
                                (e) => DropdownMenuItem(value: e,child: Text('${e.name} th Grade'),)
                        ).toList(),
                        onChanged: (val) {
                          setState(() {
                            _isChanged = true;
                            _selectedClassification = val;
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
                          //filled: true,
                          //fillColor: Colors.grey.shade200,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value){
                          if (value == null)
                          {
                            return UiMessage.NO_EMPTY_CLASSIFICATION;
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
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
                color: AppColor.processingBackgroundColor,
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

  void showDatePicker(BuildContext context){
    DateTime selectedDateTime = DateTime.now();

      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            SizedBox(
            height: 300,
            child: CupertinoDatePicker(
              minimumYear: 1980,
              maximumYear: DateTime.now().year,
              initialDateTime: _selectedDob,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (dateTime) =>
                setState(() {
                  selectedDateTime = dateTime;
                }),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Done'),
            onPressed: () {
              _selectedDob = selectedDateTime;
              _dobController.text = DateFormat('yyyy-MM-dd').format(_selectedDob!);
              setState(() {
                _isChanged = true;
              });
              //closing the date picker
              Navigator.pop(context);
            },
          ),
        ),
      );
  }

  Future<void> saveAthleteProfile(bool newAthlete, bool updateAthlete) async
  {
    bool response = false;

    AthleteRequest saveAthleteRequest = AthleteRequest(
      id: selectedAthlete?.getId,
      fname: _firstNameController.text.capitalize().trim(),
      lname: _lastNameController.text.capitalize().trim(),
      dob: DateTime.parse(_dobController.text),
      gender: _selectedGender!.index,
      classification: _selectedClassification!.index,
      email: _emailController.text.trim(),
      );

    if (newAthlete) {
      try {
        setState(() {
          _isWaitingForApi=true;
        });

        response = await athleteBloc.newAthlete(saveAthleteRequest);

        setState(() {
          _isWaitingForApi=false;
        });

        if (response){
          _isNewOrUpdateAthlete = true;
          if (context.mounted) UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_NEW_ATHLETE);
          //navigating back only if success
          if (context.mounted) Navigator.pop(context, {'isNewOrUpdateAthlete' : _isNewOrUpdateAthlete,});
        }
      } catch (e, stacktrace) {
        setState(() {
          _isWaitingForApi=false;
        });

        _isNewOrUpdateAthlete = false;

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
          UtilityWidgets.showErrorToast(context, UiMessage.ERROR_NEW_ATHLETE);
        }
      }
    }

    else if(saveAthleteRequest.getId != null && updateAthlete){
      try {
        setState(() {
          _isWaitingForApi=true;
        });

        response = await athleteBloc.updateAthlete(saveAthleteRequest);

        setState(() {
          _isWaitingForApi=false;
        });

        if (response) {
          _isNewOrUpdateAthlete = true;
          if (context.mounted) UtilityWidgets.showSuccessToast(context, UiMessage.SUCCESS_UPDATE_ATHLETE);
          //navigating back only if success
          if (context.mounted) Navigator.pop(context, {'isNewOrUpdateAthlete' : _isNewOrUpdateAthlete,});
        }
      } catch (e, stacktrace) {
        setState(() {
          _isWaitingForApi=false;
        });

        _isNewOrUpdateAthlete = false;

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
          UtilityWidgets.showErrorToast(context, UiMessage.ERROR_UPDATE_ATHLETE);
        }
      }
    }

  }

}


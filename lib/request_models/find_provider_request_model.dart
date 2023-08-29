import 'package:flutter/material.dart';
import 'package:low_ses_health_resource_app/utility/datetime_extension.dart';

class FindProviderRequest
{
  final int _athleteId;
  final List<int> _specialityIdList;
  final List<int> _insTypeIdList;
  final bool _telemedicine;
  final List<int>? _paymentTypeIndexList;
  final TimeOfDay? _hoursOfOperationStart;
  final TimeOfDay? _hoursOfOperationEnd;
  final List<int>? _daysOfOperationIndexList;
  final List<int>? _languageIndexList;
  final int? _ethnicityIndex;
  final int? _genderIndex;
  final int _loiId;
  final int _radius;

  FindProviderRequest({
    required int athleteId,
    required List<int> specialityIdList,
    required List<int> insTypeIdList,
    required bool telemedicine,
    List<int>? paymentTypeIndexList,
    TimeOfDay? hoursOfOperationStart,
    TimeOfDay? hoursOfOperationEnd,
    List<int>? daysOfOperationIndexList,
    List<int>? languageIndexList,
    int? ethnicityIndex,
    int? genderIndex,
    required int loiId,
    required int radius,
  }) :  _athleteId = athleteId,
        _specialityIdList = specialityIdList,
        _insTypeIdList = insTypeIdList,
        _telemedicine = telemedicine,
        _paymentTypeIndexList = paymentTypeIndexList ,
        _hoursOfOperationStart = hoursOfOperationStart,
        _hoursOfOperationEnd = hoursOfOperationEnd,
        _daysOfOperationIndexList = daysOfOperationIndexList,
        _languageIndexList = languageIndexList,
        _ethnicityIndex = ethnicityIndex,
        _genderIndex = genderIndex,
        _loiId = loiId,
        _radius = radius;

  int get getAthleteId => _athleteId;

  List<int> get getSpecialityIdList =>  _specialityIdList;

  List<int> get getSInsuranceTypeIdList =>  _insTypeIdList;

  bool get getTelemedicine => _telemedicine;

  List<int>? get getPaymentTypeIndexList => _paymentTypeIndexList;

  TimeOfDay? get getHoursOfOperationStart => _hoursOfOperationStart;

  TimeOfDay? get getHoursOfOperationEnd => _hoursOfOperationEnd;

  List<int>? get getDaysOfOperationIndexList => _daysOfOperationIndexList;

  int? get getGenderIndex => _genderIndex;

  List<int>? get getLanguageIndexList => _languageIndexList;

  int? get getEthnicityIndex => _ethnicityIndex;

  int get getLoiId => _loiId;

  int get getRadius => _radius;

  Map<String, dynamic> toJson() => {
    // "athlete_id": _athleteId,
    "specialities": _specialityIdList,
    "insuranceTypes": _insTypeIdList,
    "telemedicine": _telemedicine,
    "paymentTypes": _paymentTypeIndexList,
    "startTime": _hoursOfOperationStart != null ? _hoursOfOperationStart!.toStringTimeOfDay() : null,
    "endTime": _hoursOfOperationEnd != null ? _hoursOfOperationEnd!.toStringTimeOfDay() : null,
    "daysOfOperation": _daysOfOperationIndexList,
    "gender": _genderIndex,
    "languages": _languageIndexList,
    "ethnicities": _languageIndexList,
    "loiId": _loiId,
    "radius": _radius,
  };
}
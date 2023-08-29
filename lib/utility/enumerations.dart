enum PaymentTypeEnum {
  credit,
  debit,
  hsaCard,
  cash,
  cheque
}

extension PaymentTypeEnumExtension on PaymentTypeEnum {

  static const names = {
    PaymentTypeEnum.credit: 'Credit',
    PaymentTypeEnum.debit: 'Debit',
    PaymentTypeEnum.hsaCard: 'HSA Card',
    PaymentTypeEnum.cash: 'Cash',
    PaymentTypeEnum.cheque: 'Cheque'
  };

  String get name => names[this]!;
}

enum HoursOfOperationEnum
{
  morning,
  afternoon,
  evening
}

extension HoursOfOperationEnumExtention on HoursOfOperationEnum {

  static const names = {
    HoursOfOperationEnum.morning: "Morning: 8 AM- 12 PM",
    HoursOfOperationEnum.afternoon: "Afternoon: 12 PM-5 PM",
    HoursOfOperationEnum.evening: "Evening 5 PM-9 PM",
  };

  String get name => names[this]!;
}

enum DaysOfOperationEnum
{
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension DaysOfOperationEnumExtension on DaysOfOperationEnum {

  static const names = {
    DaysOfOperationEnum.monday: 'Monday',
    DaysOfOperationEnum.tuesday: 'Tuesday',
    DaysOfOperationEnum.wednesday: 'Wednesday',
    DaysOfOperationEnum.thursday: 'Thursday',
    DaysOfOperationEnum.friday: 'Friday',
    DaysOfOperationEnum.saturday: 'Saturday',
    DaysOfOperationEnum.sunday: 'Sunday',
  };

  String get name => names[this]!;
}

enum LanguageEnum
{
  english,
  spanish,
  french
}

extension LanguageEnumExtension on LanguageEnum {

  static const names = {
    LanguageEnum.english: 'English',
    LanguageEnum.spanish: 'Spanish',
    LanguageEnum.french: 'French',
  };

  String get name => names[this]!;
}

enum EthnicityEnum
{
  white,
  hispanic,
  black,
  asian,
  hawaiian,
  native,
  multiracial,
  other,
  none
}

extension EthnicityEnumExtention on EthnicityEnum {

  static const names = {
    EthnicityEnum.white: "White",
    EthnicityEnum.hispanic: "Hispanic, Latin, or Spanish origin",
    EthnicityEnum.black: "Black or African American",
    EthnicityEnum.asian: "Asian",
    EthnicityEnum.hawaiian: "Native Hawaiian or Other Pacific Islander",
    EthnicityEnum.native: "American Indian or Alaska Native",
    EthnicityEnum.multiracial: "Multiracial",
    EthnicityEnum.other: "Other",
    EthnicityEnum.none: "None",
  };

  String get name => names[this]!;
}


enum GenderEnum
{
  male,
  female,
  intersex,
  nonBinary,
  other
}

extension GenderEnumExtention on GenderEnum {

  static const names = {
    GenderEnum.male: "Male",
    GenderEnum.female: "Female",
    GenderEnum.intersex: "Intersex",
    GenderEnum.nonBinary: "Non-binary/third gender",
    GenderEnum.other: "Other"
  };

  String get name => names[this]!;
}

enum ProviderGenderEnum
{
  male,
  female,
  intersex,
  nonBinary,
  other,
  none
}

extension ProviderGenderEnumExtention on ProviderGenderEnum {

  static const names = {
    ProviderGenderEnum.male: "Male",
    ProviderGenderEnum.female: "Female",
    ProviderGenderEnum.intersex: "Intersex",
    ProviderGenderEnum.nonBinary: "Non-binary/third gender",
    ProviderGenderEnum.other: "Other",
    ProviderGenderEnum.none: "None",
  };

  String get name => names[this]!;
}

enum ClassificationEnum
{
  gradeNine,
  gradeTen,
  gradeEleven,
  gradeTwelve
}

extension ClassificationEnumExtension on ClassificationEnum {

  static const names = {
    ClassificationEnum.gradeNine: "9",
    ClassificationEnum.gradeTen: "10",
    ClassificationEnum.gradeEleven: "11",
    ClassificationEnum.gradeTwelve: "12",
  };

  String get name => names[this]!;
}

//TODO consider changing to string
enum RadiusEnum
{
  raduis1,
  radius2
}

extension RadiusEnumExtention on RadiusEnum {

  static const names = {
    RadiusEnum.raduis1: 5,
    RadiusEnum.radius2: 10,
  };

  int get name => names[this]!;
}
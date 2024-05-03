import 'flight_ssr_model.dart';

class PassengerDetailsModel {
  int passengerId = 0;
  String title = '';
  String firstName = '';
  String lastName = '';
  String dateOfBirth = '';
  String gender = '';
  String address = '';
  String zipcode = '';
  String type = ''; // adult, child, infant
  bool isFilled = false;
  String? passportNumber;
  String? passportExpiryDate;
  List<MealData>? mealDataList;
  List<IntMealData>? intMealList;
  List<BaggageData>? baggageDataList;
  SeatData? selectedSeatModel;
  MealData? selectedMealModel;
  IntMealData? selectedIntMealModel;
  BaggageData? selectedBaggageModel;
  List<SeatData>? selectedSeatForPassenger = [];
  List<MealData>? selectedMealForPassenger = [];
  List<IntMealData>? selectedIntMealForPassenger = [];
  List<BaggageData>? selectedBaggageForPassenger = [];

  PassengerDetailsModel({
    required this.passengerId,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.zipcode,
    required this.type,
    required this.isFilled,
    this.passportNumber,
    this.passportExpiryDate,
    this.mealDataList,
    this.intMealList,
    this.baggageDataList,
    this.selectedSeatModel,
    this.selectedMealModel,
    this.selectedIntMealModel,
    this.selectedBaggageModel,
    this.selectedSeatForPassenger,
    this.selectedMealForPassenger,
    this.selectedIntMealForPassenger,
    this.selectedBaggageForPassenger,
  });

  PassengerDetailsModel.fromJson(Map<String, dynamic> json) {
    passengerId = json['passengerId'];
    title = json['title'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    address = json['address'];
    zipcode = json['zipcode'];
    type = json['type'];
    isFilled = json['isFilled'];
    passportNumber = json['passportNumber'];
    passportExpiryDate = json['passportExpiryDate'];
    if (json['mealDataList'] != null) {
      mealDataList = [];
      json['mealDataList'].forEach((v) {
        mealDataList!.add(MealData.fromJson(v));
      });
    }
    if (json['intMealList'] != null) {
      intMealList = [];
      json['intMealList'].forEach((v) {
        intMealList!.add(IntMealData.fromJson(v));
      });
    }
    if (json['baggageDataList'] != null) {
      baggageDataList = [];
      json['baggageDataList'].forEach((v) {
        baggageDataList!.add(BaggageData.fromJson(v));
      });
    }
    selectedSeatModel = json['selectedSeatModel'];
    selectedMealModel = json['selectedMealModel'];
    selectedIntMealModel = json['selectedIntMealModel'];
    selectedBaggageModel = json['selectedBaggageModel'];
    if (json['selectedSeatsForPassenger'] != null) {
      selectedSeatForPassenger = [];
      json['selectedSeatsForPassenger'].forEach((v) {
        selectedSeatForPassenger!.add(SeatData.fromJson(v));
      });
    }
    if (json['selectedMealForPassenger'] != null) {
      selectedMealForPassenger = [];
      json['selectedMealForPassenger'].forEach((v) {
        selectedMealForPassenger!.add(MealData.fromJson(v));
      });
    }
    if (json['selectedIntMealForPassenger'] != null) {
      selectedIntMealForPassenger = [];
      json['selectedIntMealForPassenger'].forEach((v) {
        selectedIntMealForPassenger!.add(IntMealData.fromJson(v));
      });
    }
    if (json['selectedBaggageForPassenger'] != null) {
      selectedBaggageForPassenger = [];
      json['selectedBaggageForPassenger'].forEach((v) {
        selectedBaggageForPassenger!.add(BaggageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['passengerId'] = passengerId;
    data['title'] = title;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['dateOfBirth'] = dateOfBirth;
    data['gender'] = gender;
    data['address'] = address;
    data['zipcode'] = zipcode;
    data['type'] = type;
    data['isFilled'] = isFilled;
    data['passportNumber'] = passportNumber;
    data['passportExpiryDate'] = passportExpiryDate;
    if (mealDataList != null) {
      data['mealDataList'] = mealDataList!.map((v) => v.toJson()).toList();
    }
    if (intMealList != null) {
      data['intMealList'] = intMealList!.map((v) => v.toJson()).toList();
    }
    if (baggageDataList != null) {
      data['baggageDataList'] = baggageDataList!.map((v) => v.toJson()).toList();
    }
    data['selectedSeatModel'] = selectedSeatModel;
    data['selectedMealModel'] = selectedMealModel;
    data['selectedBaggageModel'] = selectedBaggageModel;
    if (selectedSeatForPassenger != null) {
      data['selectedSeatsForPassenger'] = selectedSeatForPassenger!.map((v) => v.toJson()).toList();
    }
    if (selectedMealForPassenger != null) {
      data['selectedMealForPassenger'] = selectedMealForPassenger!.map((v) => v.toJson()).toList();
    }
    if (selectedIntMealForPassenger != null) {
      data['selectedIntMealForPassenger'] = selectedIntMealForPassenger!.map((v) => v.toJson()).toList();
    }
    if (selectedBaggageForPassenger != null) {
      data['selectedBaggageForPassenger'] = selectedBaggageForPassenger!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

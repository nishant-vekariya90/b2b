import 'package:flutter/material.dart';

class PassengerInfoModel {
  PassengerInfoModel({required this.seat});
  String? title, docType, gender;
  final String seat;
  int? maxLengthDoc;
  TextEditingController passengerNameTxtController = TextEditingController();
  TextEditingController passengerAgeTxtController = TextEditingController();
  TextEditingController passengerIdTxtController = TextEditingController();

  toMap() => {
        'name': "${title!} ${passengerNameTxtController.text.trim()}",
        'age': passengerAgeTxtController.text,
        'gender': gender,
      };
}

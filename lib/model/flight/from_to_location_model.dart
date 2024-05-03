import 'package:get/get.dart';

class MultiStopFromToDateModel {
  RxString? fromLocationName = ''.obs;
  RxString? fromLocationCode = ''.obs;
  RxString? toLocationName = ''.obs;
  RxString? toLocationCode = ''.obs;
  RxString? date = ''.obs;

  MultiStopFromToDateModel({
    this.fromLocationName,
    this.fromLocationCode,
    this.toLocationName,
    this.toLocationCode,
    this.date,
  });

  MultiStopFromToDateModel.fromJson(Map<String, dynamic> json) {
    fromLocationName = json['fromLocationName'];
    fromLocationCode = json['fromLocationCode'];
    toLocationName = json['toLocationName'];
    toLocationCode = json['toLocationCode'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fromLocationName'] = fromLocationName;
    data['fromLocationCode'] = fromLocationCode;
    data['toLocationName'] = toLocationName;
    data['toLocationCode'] = toLocationCode;
    data['date'] = date;
    return data;
  }
}

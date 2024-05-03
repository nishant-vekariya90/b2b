import 'package:get/get.dart';

import 'flight_ssr_model.dart';

class SeatLayoutModel {
  RxInt? maxRowCount = 0.obs;
  RxInt? maxColumnCount = 0.obs;
  SeatSegmentData? maxSeatsServiceForColumnHeader = SeatSegmentData();
  RxList<SeatSegmentData>? flightSeatList = <SeatSegmentData>[].obs;

  SeatLayoutModel({
    this.maxRowCount,
    this.maxColumnCount,
    this.maxSeatsServiceForColumnHeader,
    this.flightSeatList,
  });

  SeatLayoutModel.fromJson(Map<String, dynamic> json) {
    maxRowCount = json['maxRowCount'];
    maxColumnCount = json['maxColumnCount'];
    maxSeatsServiceForColumnHeader = json['maxSeatsServiceForColumnHeader'] != null ? SeatSegmentData.fromJson(json['maxSeatsServiceForColumnHeader']) : null;
    if (json['flightSeatList'] != null) {
      flightSeatList!.value = <SeatSegmentData>[];
      json['flightSeatList'].forEach((v) {
        flightSeatList!.add(SeatSegmentData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maxRowCount'] = maxRowCount;
    data['maxColumnCount'] = maxColumnCount;
    if (maxSeatsServiceForColumnHeader != null) {
      data['maxSeatsServiceForColumnHeader'] = maxSeatsServiceForColumnHeader!.toJson();
    }
    if (flightSeatList != null) {
      data['flightSeatList'] = flightSeatList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

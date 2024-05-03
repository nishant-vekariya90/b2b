// Define a tuple to hold minimum and maximum time
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeRange {
  final TimeOfDay minTime;
  final TimeOfDay maxTime;

  TimeRange(this.minTime, this.maxTime);
}

// Define flight filter model
class FlightFilterModel {
  RxString? source;
  RxString? destination;
  RxString? sourceCode;
  RxString? destinationCode;
  RxString? date;
  RxBool? isHideNonRefundable;
  RxMap<String, String>? stopsList;
  RxDouble? minPrice;
  RxDouble? maxPrice;
  RxMap<String, Map<String, String>>? airlinesList;
  RxString? selectedStops;
  Rx<RangeValues>? priceRange;
  RxBool? isSelectedEarlyMorningDeparture;
  RxBool? isSelectedMorningDeparture;
  RxBool? isSelectedAfternoonDeparture;
  RxBool? isSelectedEveningDeparture;
  RxBool? isSelectedEarlyMorningArrival;
  RxBool? isSelectedMorningArrival;
  RxBool? isSelectedAfternoonArrival;
  RxBool? isSelectedEveningArrival;
  RxList<String>? selectedAirlinesList;

  FlightFilterModel({
    this.source,
    this.destination,
    this.sourceCode,
    this.destinationCode,
    this.date,
    this.isHideNonRefundable,
    this.stopsList,
    this.minPrice,
    this.maxPrice,
    this.airlinesList,
    this.selectedStops,
    this.priceRange,
    this.isSelectedEarlyMorningDeparture,
    this.isSelectedMorningDeparture,
    this.isSelectedAfternoonDeparture,
    this.isSelectedEveningDeparture,
    this.isSelectedEarlyMorningArrival,
    this.isSelectedMorningArrival,
    this.isSelectedAfternoonArrival,
    this.isSelectedEveningArrival,
    this.selectedAirlinesList,
  });

  FlightFilterModel.fromJson(Map<String, dynamic> json) {
    source = json['source'] != null ? RxString(json['source']) : RxString('');
    destination = json['destination'] != null ? RxString(json['destination']) : RxString('');
    sourceCode = json['sourceCode'] != null ? RxString(json['sourceCode']) : RxString('');
    destinationCode = json['destinationCode'] != null ? RxString(json['destinationCode']) : RxString('');
    date = json['date'] != null ? RxString(json['date']) : RxString('');
    isHideNonRefundable = json['isHideNonRefundable'] != null ? RxBool(json['isHideNonRefundable']) : false.obs;
    stopsList = json['stopsList'] != null ? RxMap<String, String>(json['stopsList']) : <String, String>{}.obs;
    minPrice = json['minPrice'] != null ? RxDouble(json['minPrice']) : RxDouble(0.0);
    maxPrice = json['maxPrice'] != null ? RxDouble(json['maxPrice']) : RxDouble(0.0);
    airlinesList = json['airlinesList'] != null ? RxMap<String, Map<String, String>>(json['airlinesList']) : <String, Map<String, String>>{}.obs;
    selectedStops = json['selectedStops'] != null ? RxString(json['selectedStops']) : RxString('');
    priceRange = json['priceRange'] != null ? Rx<RangeValues>(json['priceRange']) : const RangeValues(0, 0).obs;
    isSelectedEarlyMorningDeparture = json['isSelectedEarlyMorningDepartureTime'] != null ? RxBool(json['isSelectedEarlyMorningDepartureTime']) : false.obs;
    isSelectedMorningDeparture = json['isSelectedMorningDepartureTime'] != null ? RxBool(json['isSelectedMorningDepartureTime']) : false.obs;
    isSelectedAfternoonDeparture = json['isSelectedAfternoonDepartureTime'] != null ? RxBool(json['isSelectedAfternoonDepartureTime']) : false.obs;
    isSelectedEveningDeparture = json['isSelectedEveningDepartureTime'] != null ? RxBool(json['isSelectedEveningDepartureTime']) : false.obs;
    isSelectedEarlyMorningArrival = json['isSelectedEarlyMorningArrivalTime'] != null ? RxBool(json['isSelectedEarlyMorningArrivalTime']) : false.obs;
    isSelectedMorningArrival = json['isSelectedMorningArrivalTime'] != null ? RxBool(json['isSelectedMorningArrivalTime']) : false.obs;
    isSelectedAfternoonArrival = json['isSelectedAfternoonArrivalTime'] != null ? RxBool(json['isSelectedAfternoonArrivalTime']) : false.obs;
    isSelectedEveningArrival = json['isSelectedEveningArrivalTime'] != null ? RxBool(json['isSelectedEveningArrivalTime']) : false.obs;
    selectedAirlinesList = json['selectedAirlineList'] != null ? RxList<String>(List<String>.from(json['selectedAirlineList'])) : <String>[].obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source'] = source?.value;
    data['destination'] = destination?.value;
    data['sourceCode'] = sourceCode?.value;
    data['destinationCode'] = destinationCode?.value;
    data['date'] = date?.value;
    data['isHideNonRefundable'] = isHideNonRefundable?.value;
    data['stopsList'] = stopsList!;
    data['minPrice'] = minPrice?.value;
    data['maxPrice'] = maxPrice?.value;
    data['airlinesList'] = airlinesList!;
    data['selectedStops'] = selectedStops?.value;
    data['priceRange'] = priceRange?.value;
    data['isSelectedEarlyMorningDepartureTime'] = isSelectedEarlyMorningDeparture?.value;
    data['isSelectedMorningDepartureTime'] = isSelectedMorningDeparture?.value;
    data['isSelectedAfternoonDepartureTime'] = isSelectedAfternoonDeparture?.value;
    data['isSelectedEveningDepartureTime'] = isSelectedEveningDeparture?.value;
    data['isSelectedEarlyMorningArrivalTime'] = isSelectedEarlyMorningArrival?.value;
    data['isSelectedMorningArrivalTime'] = isSelectedMorningArrival?.value;
    data['isSelectedAfternoonArrivalTime'] = isSelectedAfternoonArrival?.value;
    data['isSelectedEveningArrivalTime'] = isSelectedEveningArrival?.value;
    data['selectedAirlineList'] = selectedAirlinesList!;
    return data;
  }
}

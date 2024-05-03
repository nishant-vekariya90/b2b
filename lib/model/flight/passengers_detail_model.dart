import 'package:get/get_rx/src/rx_types/rx_types.dart';

class FlightBookingPassengersDetailModel {
  List<FlightPassengersDetailData>? passengersDataList;
  Pagination? pagination;
  String? message;
  int? statusCode;

  FlightBookingPassengersDetailModel({
    this.passengersDataList,
    this.pagination,
    this.message,
    this.statusCode,
  });

  FlightBookingPassengersDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      passengersDataList = <FlightPassengersDetailData>[];
      json['data'].forEach((v) {
        passengersDataList!.add(FlightPassengersDetailData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> passengersDataList = <String, dynamic>{};
    if (this.passengersDataList != null) {
      passengersDataList['data'] = this.passengersDataList!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      passengersDataList['pagination'] = pagination!.toJson();
    }
    passengersDataList['message'] = message;
    passengersDataList['statusCode'] = statusCode;
    return passengersDataList;
  }
}

class FlightPassengersDetailData {
  int? id;
  int? flightTxnID;
  String? name;
  String? ticketNumber;
  String? seatNumber;
  String? meal;
  String? baggage;
  String? passportNumber;
  String? passportExpiry;
  String? ticketId;
  String? passengerType;
  String? passengerId;
  int? status;
  String? createdOn;
  String? modifiedOn;
  RxBool? isSelectedPassenger = false.obs;

  FlightPassengersDetailData({
    this.id,
    this.flightTxnID,
    this.name,
    this.ticketNumber,
    this.seatNumber,
    this.meal,
    this.baggage,
    this.passportNumber,
    this.passportExpiry,
    this.ticketId,
    this.passengerType,
    this.passengerId,
    this.status,
    this.createdOn,
    this.modifiedOn,
    this.isSelectedPassenger,
  });

  FlightPassengersDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flightTxnID = json['flightTxnID'];
    name = json['name'];
    ticketNumber = json['ticketNumber'];
    seatNumber = json['seatNumber'];
    meal = json['meal'];
    baggage = json['baggage'];
    passportNumber = json['passportNumber'];
    passportExpiry = json['passportExpiry'];
    ticketId = json['ticketId'];
    passengerType = json['passengerType'];
    passengerId = json['passengerId'];
    status = json['status'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['flightTxnID'] = flightTxnID;
    data['name'] = name;
    data['ticketNumber'] = ticketNumber;
    data['seatNumber'] = seatNumber;
    data['meal'] = meal;
    data['baggage'] = baggage;
    data['passportNumber'] = passportNumber;
    data['passportExpiry'] = passportExpiry;
    data['ticketId'] = ticketId;
    data['passengerType'] = passengerType;
    data['passengerId'] = passengerId;
    data['status'] = status;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalCount;
  bool? hasPrevious;
  bool? hasNext;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalCount,
    this.hasPrevious,
    this.hasNext,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['pageSize'] = pageSize;
    data['totalCount'] = totalCount;
    data['hasPrevious'] = hasPrevious;
    data['hasNext'] = hasNext;
    return data;
  }
}

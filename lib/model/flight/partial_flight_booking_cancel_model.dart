class PartialFlightBookingCancelModel {
  List<PartialFlightBookingCancelData>? partialFlightBookingDataList;
  Pagination? pagination;
  String? message;
  int? statusCode;

  PartialFlightBookingCancelModel(
      {this.partialFlightBookingDataList, this.pagination, this.message, this.statusCode});

  PartialFlightBookingCancelModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      partialFlightBookingDataList = <PartialFlightBookingCancelData>[];
      json['data'].forEach((v) {
        partialFlightBookingDataList!.add(PartialFlightBookingCancelData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> partialFlightBookingDataList = <String, dynamic>{};
    if (this.partialFlightBookingDataList != null) {
      partialFlightBookingDataList['data'] = this.partialFlightBookingDataList!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      partialFlightBookingDataList['pagination'] = pagination!.toJson();
    }
    partialFlightBookingDataList['message'] = message;
    partialFlightBookingDataList['statusCode'] = statusCode;
    return partialFlightBookingDataList;
  }
}

class PartialFlightBookingCancelData {
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

  PartialFlightBookingCancelData(
      {this.id,
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
        this.modifiedOn});

  PartialFlightBookingCancelData.fromJson(Map<String, dynamic> json) {
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

  Pagination(
      {this.currentPage,
        this.totalPages,
        this.pageSize,
        this.totalCount,
        this.hasPrevious,
        this.hasNext});

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

class BusBookingReportModel {
  List<BusBookingReportData>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  BusBookingReportModel(
      {this.data, this.pagination, this.message, this.statusCode});

  BusBookingReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BusBookingReportData>[];
      json['data'].forEach((v) {
        data!.add(BusBookingReportData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    data['message'] = message;
    data['statusCode'] = statusCode;
    return data;
  }
}

class BusBookingReportData {
  int? id;
  int? userId;
  String? userDetails;
  String? orderId;
  String? unqID;
  String? name;
  String? mobileNo;
  String? email;
  String? address;
  String? fromCityCode;
  String? fromCityName;
  String? toCityCode;
  String? toCityName;
  String? doj;
  String? seatNos;
  String? fare;
  String? blockKey;
  String? ticketNo;
  int? status;
  bool? partialCancellable;
  String? pnr;
  String? picktupTime;
  String? pickupContactNo;
  String? pickupLocation;
  String? pickupAddress;
  String? boardingPoint;
  String? boardingPointName;
  String? dropingPoint;
  String? dropingPointName;
  String? travels;
  String? busType;
  String? doi;
  dynamic cancellationCharge;
  dynamic refundAmount;
  String? cancellationDate;
  dynamic transportId;
  dynamic apiRef;
  String? transportName;
  String? landMarks;
  String? tripId;
  String? cancellationPolicy;
  int? passengerCount;
  String? reason;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;

  BusBookingReportData(
      {this.id,
        this.userId,
        this.userDetails,
        this.orderId,
        this.unqID,
        this.name,
        this.mobileNo,
        this.email,
        this.address,
        this.fromCityCode,
        this.fromCityName,
        this.toCityCode,
        this.toCityName,
        this.doj,
        this.seatNos,
        this.fare,
        this.blockKey,
        this.ticketNo,
        this.status,
        this.partialCancellable,
        this.pnr,
        this.picktupTime,
        this.pickupContactNo,
        this.pickupLocation,
        this.pickupAddress,
        this.boardingPoint,
        this.boardingPointName,
        this.dropingPoint,
        this.dropingPointName,
        this.travels,
        this.busType,
        this.doi,
        this.cancellationCharge,
        this.refundAmount,
        this.cancellationDate,
        this.transportId,
        this.apiRef,
        this.transportName,
        this.landMarks,
        this.tripId,
        this.cancellationPolicy,
        this.passengerCount,
        this.reason,
        this.createdOn,
        this.createdBy,
        this.modifiedOn,
        this.modifiedBy});

  BusBookingReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userDetails = json['userDetails'];
    orderId = json['orderId'];
    unqID = json['unqID'];
    name = json['name'];
    mobileNo = json['mobileNo'];
    email = json['email'];
    address = json['address'];
    fromCityCode = json['fromCityCode'];
    fromCityName = json['fromCityName'];
    toCityCode = json['toCityCode'];
    toCityName = json['toCityName'];
    doj = json['doj'];
    seatNos = json['seatNos'];
    fare = json['fare'];
    blockKey = json['blockKey'];
    ticketNo = json['ticketNo'];
    status = json['status'];
    partialCancellable = json['partialCancellable'];
    pnr = json['pnr'];
    picktupTime = json['picktupTime'];
    pickupContactNo = json['pickupContactNo'];
    pickupLocation = json['pickupLocation'];
    pickupAddress = json['pickupAddress'];
    boardingPoint = json['boardingPoint'];
    boardingPointName = json['boardingPointName'];
    dropingPoint = json['dropingPoint'];
    dropingPointName = json['dropingPointName'];
    travels = json['travels'];
    busType = json['busType'];
    doi = json['doi'];
    cancellationCharge = json['cancellationCharge'];
    refundAmount = json['refundAmount'];
    cancellationDate = json['cancellationDate'];
    transportId = json['transportId'];
    apiRef = json['apiRef'];
    transportName = json['transportName'];
    landMarks = json['landMarks'];
    tripId = json['tripId'];
    cancellationPolicy = json['cancellationPolicy'];
    passengerCount = json['passengerCount'];
    reason = json['reason'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['userDetails'] = userDetails;
    data['orderId'] = orderId;
    data['unqID'] = unqID;
    data['name'] = name;
    data['mobileNo'] = mobileNo;
    data['email'] = email;
    data['address'] = address;
    data['fromCityCode'] = fromCityCode;
    data['fromCityName'] = fromCityName;
    data['toCityCode'] = toCityCode;
    data['toCityName'] = toCityName;
    data['doj'] = doj;
    data['seatNos'] = seatNos;
    data['fare'] = fare;
    data['blockKey'] = blockKey;
    data['ticketNo'] = ticketNo;
    data['status'] = status;
    data['partialCancellable'] = partialCancellable;
    data['pnr'] = pnr;
    data['picktupTime'] = picktupTime;
    data['pickupContactNo'] = pickupContactNo;
    data['pickupLocation'] = pickupLocation;
    data['pickupAddress'] = pickupAddress;
    data['boardingPoint'] = boardingPoint;
    data['boardingPointName'] = boardingPointName;
    data['dropingPoint'] = dropingPoint;
    data['dropingPointName'] = dropingPointName;
    data['travels'] = travels;
    data['busType'] = busType;
    data['doi'] = doi;
    data['cancellationCharge'] = cancellationCharge;
    data['refundAmount'] = refundAmount;
    data['cancellationDate'] = cancellationDate;
    data['transportId'] = transportId;
    data['apiRef'] = apiRef;
    data['transportName'] = transportName;
    data['landMarks'] = landMarks;
    data['tripId'] = tripId;
    data['cancellationPolicy'] = cancellationPolicy;
    data['passengerCount'] = passengerCount;
    data['reason'] = reason;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
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

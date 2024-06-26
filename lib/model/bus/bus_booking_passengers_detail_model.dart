class BusBookingPassengersDetailModel {
  List<BusBookingPassengersDetailData>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  BusBookingPassengersDetailModel({this.data, this.pagination, this.message, this.statusCode});

  BusBookingPassengersDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BusBookingPassengersDetailData>[];
      json['data'].forEach((v) {
        data!.add(BusBookingPassengersDetailData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
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

class BusBookingPassengersDetailData {
  int? id;
  int? busTxnID;
  String? name;
  String? age;
  String? gender;
  String? title;
  String? fare;
  String? address;
  String? email;
  String? mobile;
  String? ladiesSeat;
  String? isPrimary;
  String? ticketNumber;
  String? seatNumber;
  String? passengerId;
  String? passengerType;
  int? status;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;

  BusBookingPassengersDetailData(
      {this.id,
      this.busTxnID,
      this.name,
      this.age,
      this.gender,
      this.title,
      this.fare,
      this.address,
      this.email,
      this.mobile,
      this.ladiesSeat,
      this.isPrimary,
      this.ticketNumber,
      this.seatNumber,
      this.passengerId,
      this.passengerType,
      this.status,
      this.createdOn,
      this.createdBy,
      this.modifiedOn,
      this.modifiedBy});

  BusBookingPassengersDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    busTxnID = json['busTxnID'];
    name = json['name'];
    age = json['age'];
    gender = json['gender'];
    title = json['title'];
    fare = json['fare'];
    address = json['address'];
    email = json['email'];
    mobile = json['mobile'];
    ladiesSeat = json['ladiesSeat'];
    isPrimary = json['isPrimary'];
    ticketNumber = json['ticketNumber'];
    seatNumber = json['seatNumber'];
    passengerId = json['passengerId'];
    passengerType = json['passengerType'];
    status = json['status'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['busTxnID'] = busTxnID;
    data['name'] = name;
    data['age'] = age;
    data['gender'] = gender;
    data['title'] = title;
    data['fare'] = fare;
    data['address'] = address;
    data['email'] = email;
    data['mobile'] = mobile;
    data['ladiesSeat'] = ladiesSeat;
    data['isPrimary'] = isPrimary;
    data['ticketNumber'] = ticketNumber;
    data['seatNumber'] = seatNumber;
    data['passengerId'] = passengerId;
    data['passengerType'] = passengerType;
    data['status'] = status;
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

  Pagination({this.currentPage, this.totalPages, this.pageSize, this.totalCount, this.hasPrevious, this.hasNext});

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

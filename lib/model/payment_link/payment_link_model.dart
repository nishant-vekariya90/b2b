import 'package:get/get.dart';

class PaymentLinkModel {
  List<PaymentLinkData>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  PaymentLinkModel({
    this.data,
    this.pagination,
    this.message,
    this.statusCode,
  });

  PaymentLinkModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PaymentLinkData>[];
      json['data'].forEach((v) {
        data!.add(PaymentLinkData.fromJson(v));
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

class PaymentLinkData {
  int? id;
  int? customerId;
  String? name;
  String? mobileNo;
  String? emailId;
  double? amount;
  String? remark;
  int? status;
  String? paymentLinks;
  String? createdOn;
  String? createdBy;
  String? modifyOn;
  String? modifyBy;
  String? expiryDate;
  String? uniqueNo;
  bool? alertStatus;
  String? gateway;
  int? channel;
  int? settlementCycle;
  int? settleInHour;
  String? settlementCycleName;
  RxBool? isLinkCopied = false.obs;

  PaymentLinkData({
    this.id,
    this.customerId,
    this.name,
    this.mobileNo,
    this.emailId,
    this.amount,
    this.remark,
    this.status,
    this.paymentLinks,
    this.createdOn,
    this.createdBy,
    this.modifyOn,
    this.modifyBy,
    this.expiryDate,
    this.uniqueNo,
    this.alertStatus,
    this.gateway,
    this.channel,
    this.settlementCycle,
    this.settleInHour,
    this.settlementCycleName,
    this.isLinkCopied,
  });

  PaymentLinkData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customerId'];
    name = json['name'];
    mobileNo = json['mobileNo'];
    emailId = json['emailId'];
    amount = json['amount'];
    remark = json['remark'];
    status = json['status'];
    paymentLinks = json['paymentLinks'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifyOn = json['modifyOn'];
    modifyBy = json['modifyBy'];
    expiryDate = json['expiryDate'];
    uniqueNo = json['uniqueNo'];
    alertStatus = json['alertStatus'];
    gateway = json['gateway'];
    channel = json['channel'];
    settlementCycle = json['settlementCycle'];
    settleInHour = json['settleInHour'];
    settlementCycleName = json['settlementCycleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['customerId'] = customerId;
    data['name'] = name;
    data['mobileNo'] = mobileNo;
    data['emailId'] = emailId;
    data['amount'] = amount;
    data['remark'] = remark;
    data['status'] = status;
    data['paymentLinks'] = paymentLinks;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifyOn'] = modifyOn;
    data['modifyBy'] = modifyBy;
    data['expiryDate'] = expiryDate;
    data['uniqueNo'] = uniqueNo;
    data['alertStatus'] = alertStatus;
    data['gateway'] = gateway;
    data['channel'] = channel;
    data['settlementCycle'] = settlementCycle;
    data['settleInHour'] = settleInHour;
    data['settlementCycleName'] = settlementCycleName;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalCount;
  double? totalVolume;
  int? totalActive;
  int? totalExpired;
  int? totalDeactive;
  int? totalUsed;
  bool? hasPrevious;
  bool? hasNext;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalCount,
    this.totalVolume,
    this.totalActive,
    this.totalExpired,
    this.totalDeactive,
    this.totalUsed,
    this.hasPrevious,
    this.hasNext,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    totalVolume = json['totalVolume'];
    totalActive = json['totalActive'];
    totalExpired = json['totalExpired'];
    totalDeactive = json['totalDeactive'];
    totalUsed = json['totalUsed'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['pageSize'] = pageSize;
    data['totalCount'] = totalCount;
    data['totalVolume'] = totalVolume;
    data['totalActive'] = totalActive;
    data['totalExpired'] = totalExpired;
    data['totalDeactive'] = totalDeactive;
    data['totalUsed'] = totalUsed;
    data['hasPrevious'] = hasPrevious;
    data['hasNext'] = hasNext;
    return data;
  }
}

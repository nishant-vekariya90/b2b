import 'package:get/get.dart';

class StatementReportModel {
  int? statusCode;
  String? message;
  List<StatementReportData>? data;
  Pagination? pagination;

  StatementReportModel({
    this.statusCode,
    this.message,
    this.data,
    this.pagination,
  });

  StatementReportModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StatementReportData>[];
      json['data'].forEach((v) {
        data!.add(StatementReportData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class StatementReportData {
  int? id;
  String? uqID;
  int? userID;
  double? openingBal;
  double? amount;
  double? closingBal;
  String? transactionType;
  String? remarks;
  String? transactionDate;
  String? ipAddress;
  String? crDrType;
  int? payRefID;
  double? commAmt;
  double? chargeAmt;
  double? gst;
  double? tds;
  double? transAmt;
  String? uniquekey;
  String? userName;
  String? serviceName;
  String? orderID;
  RxBool isVisible = false.obs;

  StatementReportData({
    this.id,
    this.uqID,
    this.userID,
    this.openingBal,
    this.amount,
    this.closingBal,
    this.transactionType,
    this.remarks,
    this.transactionDate,
    this.ipAddress,
    this.crDrType,
    this.payRefID,
    this.commAmt,
    this.chargeAmt,
    this.gst,
    this.tds,
    this.transAmt,
    this.uniquekey,
    this.userName,
    this.serviceName,
    this.orderID,
    required this.isVisible,
  });

  StatementReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uqID = json['uqID'];
    userID = json['userID'];
    openingBal = json['openingBal'];
    amount = json['amount'];
    closingBal = json['closingBal'];
    transactionType = json['transactionType'];
    remarks = json['remarks'];
    transactionDate = json['transactionDate'];
    ipAddress = json['ipAddress'];
    crDrType = json['crDrType'];
    payRefID = json['payRefID'];
    commAmt = json['commAmt'];
    chargeAmt = json['chargeAmt'];
    gst = json['gst'];
    tds = json['tds'];
    transAmt = json['transAmt'];
    uniquekey = json['uniquekey'];
    userName = json['userName'];
    serviceName = json['serviceName'];
    orderID = json['orderID'];
    isVisible = false.obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uqID'] = uqID;
    data['userID'] = userID;
    data['openingBal'] = openingBal;
    data['amount'] = amount;
    data['closingBal'] = closingBal;
    data['transactionType'] = transactionType;
    data['remarks'] = remarks;
    data['transactionDate'] = transactionDate;
    data['ipAddress'] = ipAddress;
    data['crDrType'] = crDrType;
    data['payRefID'] = payRefID;
    data['commAmt'] = commAmt;
    data['chargeAmt'] = chargeAmt;
    data['gst'] = gst;
    data['tds'] = tds;
    data['transAmt'] = transAmt;
    data['uniquekey'] = uniquekey;
    data['userName'] = userName;
    data['serviceName'] = serviceName;
    data['orderID'] = orderID;
    isVisible = false.obs;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalCount;
  double? totalCredit;
  double? totalDebit;
  bool? hasPrevious;
  bool? hasNext;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalCount,
    this.totalCredit,
    this.totalDebit,
    this.hasPrevious,
    this.hasNext,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    totalCredit = json['totalCredit'];
    totalDebit = json['totalDebit'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['pageSize'] = pageSize;
    data['totalCount'] = totalCount;
    data['totalCredit'] = totalCredit;
    data['totalDebit'] = totalDebit;
    data['hasPrevious'] = hasPrevious;
    data['hasNext'] = hasNext;
    return data;
  }
}

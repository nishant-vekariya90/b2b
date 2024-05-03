import 'package:get/get_rx/src/rx_types/rx_types.dart';

class TransactionReportModel {
  int? statusCode;
  String? message;
  List<TransactionReportData>? data;
  Pagination? pagination;

  TransactionReportModel({
    this.statusCode,
    this.message,
    this.data,
    this.pagination,
  });

  TransactionReportModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TransactionReportData>[];
      json['data'].forEach((v) {
        data!.add(TransactionReportData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
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

class TransactionReportData {

  int? id;
  String? uniqueId;
  int? userId;
  String? userDetails;
  String? number;
  double? amount;
  int? channel;
  int? serviceId;
  String? serviceName;
  int? operatorId;
  String? operatorName;
  int? status;
  double? commPer;
  double? commVal;
  double? commAmt;
  double? chargeVal;
  double? chargePer;
  double? chargeAmt;
  double? cost;
  String? transactionDate;
  String? updatedDate;
  int? apiId;
  String? apiName;
  String? apiRef;
  String? clientRef;
  String? operatorRef;
  bool? isProcessed;
  String? reason;
  bool? isRevert;
  String? ipAddress;
  double? apiComm;
  double? apiCharge;
  String? orderId;
  String? currency;
  double? gst;
  double? tds;
  String? customerDetails;
  String? paymentType;
  int? walletID;
  String? addedBy;
  bool? isSettled;
  String? settlementDate;
  String? settledBy;
  double? affiliateEarning;
  int? affiliateUserId;
  int? sourceOfFundId;
  RxBool isVisible = false.obs;
  String? customerMobileNo;
  String? customerName;
  String? beneficiaryName;
  String? accountNo;
  String? ifsc;
  String? adharNo;
  String? bankName;
  String? salesAmount;
  int? totalTransactions;
  String? channelName;
  int? categoryId;
  String? categoryName;
  String? splitTransactionId;

  TransactionReportData({
    this.id,
    this.uniqueId,
    this.userId,
    this.userDetails,
    this.number,
    this.amount,
    this.channel,
    this.serviceId,
    this.serviceName,
    this.operatorId,
    this.operatorName,
    this.status,
    this.commPer,
    this.commVal,
    this.commAmt,
    this.chargeVal,
    this.chargePer,
    this.chargeAmt,
    this.cost,
    this.transactionDate,
    this.updatedDate,
    this.apiId,
    this.apiName,
    this.apiRef,
    this.clientRef,
    this.operatorRef,
    this.isProcessed,
    this.reason,
    this.isRevert,
    this.ipAddress,
    this.apiComm,
    this.apiCharge,
    this.orderId,
    this.currency,
    this.gst,
    this.tds,
    this.customerDetails,
    this.paymentType,
    this.walletID,
    this.addedBy,
    this.isSettled,
    this.settlementDate,
    this.settledBy,
    this.affiliateEarning,
    this.affiliateUserId,
    this.sourceOfFundId,
    required this.isVisible,
    this.customerMobileNo,
    this.customerName,
    this.beneficiaryName,
    this.accountNo,
    this.ifsc,
    this.adharNo,
    this.bankName,
    this.salesAmount,
    this.totalTransactions,
    this.channelName,
    this.categoryId,
    this.categoryName,
    this.splitTransactionId
  });

  TransactionReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uniqueId = json['uniqueId'];
    userId = json['userId'];
    userDetails = json['userDetails'];
    number = json['number'];
    amount = json['amount'];
    channel = json['channel'];
    serviceId = json['serviceId'];
    serviceName = json['serviceName'];
    operatorId = json['operatorId'];
    operatorName = json['operatorName'];
    status = json['status'];
    commPer = json['commPer'];
    commVal = json['commVal'];
    commAmt = json['commAmt'];
    chargeVal = json['chargeVal'];
    chargePer = json['chargePer'];
    chargeAmt = json['chargeAmt'];
    cost = json['cost'];
    transactionDate = json['transactionDate'];
    updatedDate = json['updatedDate'];
    apiId = json['apiId'];
    apiName = json['apiName'];
    apiRef = json['apiRef'];
    clientRef = json['clientRef'];
    operatorRef = json['operatorRef'];
    isProcessed = json['isProcessed'];
    reason = json['reason'];
    isRevert = json['isRevert'];
    ipAddress = json['ipAddress'];
    apiComm = json['apiComm'];
    apiCharge = json['apiCharge'];
    orderId = json['orderId'];
    currency = json['currency'];
    gst = json['gst'];
    tds = json['tds'];
    customerDetails = json['customerDetails'];
    paymentType = json['paymentType'];
    walletID = json['walletID'];
    addedBy = json['addedBy'];
    isSettled = json['isSettled'];
    settlementDate = json['settlementDate'];
    settledBy = json['settledBy'];
    affiliateEarning = json['affiliateEarning'];
    affiliateUserId = json['affiliateUserId'];
    sourceOfFundId = json['sourceOfFundId'];
    isVisible = false.obs;
    customerMobileNo = json['customerMobileNo'];
    customerName = json['customerName'];
    beneficiaryName = json['beneficiaryName'];
    accountNo = json['accountNo'];
    ifsc = json['ifsc'];
    adharNo = json['adharNo'];
    bankName = json['bankName'];
    salesAmount = json['salesAmount'];
    totalTransactions = json['totalTransactions'];
    channelName = json['channelName'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    splitTransactionId = json['splitTransactionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uniqueId'] = uniqueId;
    data['userId'] = userId;
    data['userDetails'] = userDetails;
    data['number'] = number;
    data['amount'] = amount;
    data['channel'] = channel;
    data['serviceId'] = serviceId;
    data['serviceName'] = serviceName;
    data['operatorId'] = operatorId;
    data['operatorName'] = operatorName;
    data['status'] = status;
    data['commPer'] = commPer;
    data['commVal'] = commVal;
    data['commAmt'] = commAmt;
    data['chargeVal'] = chargeVal;
    data['chargePer'] = chargePer;
    data['chargeAmt'] = chargeAmt;
    data['cost'] = cost;
    data['transactionDate'] = transactionDate;
    data['updatedDate'] = updatedDate;
    data['apiId'] = apiId;
    data['apiName'] = apiName;
    data['apiRef'] = apiRef;
    data['clientRef'] = clientRef;
    data['operatorRef'] = operatorRef;
    data['isProcessed'] = isProcessed;
    data['reason'] = reason;
    data['isRevert'] = isRevert;
    data['ipAddress'] = ipAddress;
    data['apiComm'] = apiComm;
    data['apiCharge'] = apiCharge;
    data['orderId'] = orderId;
    data['currency'] = currency;
    data['gst'] = gst;
    data['tds'] = tds;
    data['customerDetails'] = customerDetails;
    data['paymentType'] = paymentType;
    data['walletID'] = walletID;
    data['addedBy'] = addedBy;
    data['isSettled'] = isSettled;
    data['settlementDate'] = settlementDate;
    data['settledBy'] = settledBy;
    data['affiliateEarning'] = affiliateEarning;
    data['affiliateUserId'] = affiliateUserId;
    data['sourceOfFundId'] = sourceOfFundId;
    data['customerMobileNo'] = customerMobileNo;
    data['customerName'] = customerName;
    data['beneficiaryName'] = beneficiaryName;
    data['accountNo'] = accountNo;
    data['ifsc'] = ifsc;
    data['adharNo'] = adharNo;
    data['bankName'] = bankName;
    data['salesAmount'] = salesAmount;
    data['totalTransactions'] = totalTransactions;
    data['channelName'] = channelName;
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    data['splitTransactionId'] = splitTransactionId;
    isVisible = false.obs;

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

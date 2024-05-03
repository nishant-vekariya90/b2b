class PaymentLoadReportModel {
  List<PaymentLoadData>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  PaymentLoadReportModel({this.data, this.pagination, this.message, this.statusCode});

  PaymentLoadReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PaymentLoadData>[];
      json['data'].forEach((v) {
        data!.add(PaymentLoadData.fromJson(v));
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

class PaymentLoadData {
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
  String? customerMobileNo;
  String? customerName;
  String? accountNo;
  String? ifsc;
  String? beneficiaryName;
  String? authenticator;
  String? bbpsAccountNo;
  String? dueDate;
  String? adharNo;
  String? bankName;
  int? transactionType;
  int? categoryId;
  String? categoryName;
  String? serviceCode;
  int? tenantId;
  String? tenantName;
  String? channelName;
  String? splitTransactionId;
  int? rank1UserId;
  double? rank1CommAmt;
  double? rank1ChargeAmt;
  double? rank1PriorityTax;
  double? rank1SecondaryTax;
  int? rank2UserId;
  double? rank2CommAmt;
  double? rank2ChargeAmt;
  double? rank2PriorityTax;
  double? rank2SecondaryTax;
  int? rank3UserId;
  double? rank3CommAmt;
  double? rank3ChargeAmt;
  double? rank3PriorityTax;
  double? rank3SecondaryTax;
  int? rank4UserId;
  double? rank4CommAmt;
  double? rank4ChargeAmt;
  double? rank4PriorityTax;
  double? rank4SecondaryTax;
  int? transactionType1;
  bool? isUplineCommDist;
  bool? isLive;
  String? circleID;
  String? circleName;
  bool? isThreeWay;
  String? latitude;
  String? longitude;
  String? deviceId;
  String? txnAction;
  String? txnActionName;
  double? profitLoss;

  PaymentLoadData(
      {this.id,
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
      this.customerMobileNo,
      this.customerName,
      this.accountNo,
      this.ifsc,
      this.beneficiaryName,
      this.authenticator,
      this.bbpsAccountNo,
      this.dueDate,
      this.adharNo,
      this.bankName,
      this.transactionType,
      this.categoryId,
      this.categoryName,
      this.serviceCode,
      this.tenantId,
      this.tenantName,
      this.channelName,
      this.splitTransactionId,
      this.rank1UserId,
      this.rank1CommAmt,
      this.rank1ChargeAmt,
      this.rank1PriorityTax,
      this.rank1SecondaryTax,
      this.rank2UserId,
      this.rank2CommAmt,
      this.rank2ChargeAmt,
      this.rank2PriorityTax,
      this.rank2SecondaryTax,
      this.rank3UserId,
      this.rank3CommAmt,
      this.rank3ChargeAmt,
      this.rank3PriorityTax,
      this.rank3SecondaryTax,
      this.rank4UserId,
      this.rank4CommAmt,
      this.rank4ChargeAmt,
      this.rank4PriorityTax,
      this.rank4SecondaryTax,
      this.transactionType1,
      this.isUplineCommDist,
      this.isLive,
      this.circleID,
      this.circleName,
      this.isThreeWay,
      this.latitude,
      this.longitude,
      this.deviceId,
      this.txnAction,
      this.txnActionName,
      this.profitLoss});

  PaymentLoadData.fromJson(Map<String, dynamic> json) {
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
    customerMobileNo = json['customerMobileNo'];
    customerName = json['customerName'];
    accountNo = json['accountNo'];
    ifsc = json['ifsc'];
    beneficiaryName = json['beneficiaryName'];
    authenticator = json['authenticator'];
    bbpsAccountNo = json['bbpsAccountNo'];
    dueDate = json['dueDate'];
    adharNo = json['adharNo'];
    bankName = json['bankName'];
    transactionType = json['transactionType'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    serviceCode = json['serviceCode'];
    tenantId = json['tenantId'];
    tenantName = json['tenantName'];
    channelName = json['channelName'];
    splitTransactionId = json['splitTransactionId'];
    rank1UserId = json['rank1UserId'];
    rank1CommAmt = json['rank1CommAmt'];
    rank1ChargeAmt = json['rank1ChargeAmt'];
    rank1PriorityTax = json['rank1PriorityTax'];
    rank1SecondaryTax = json['rank1SecondaryTax'];
    rank2UserId = json['rank2UserId'];
    rank2CommAmt = json['rank2CommAmt'];
    rank2ChargeAmt = json['rank2ChargeAmt'];
    rank2PriorityTax = json['rank2PriorityTax'];
    rank2SecondaryTax = json['rank2SecondaryTax'];
    rank3UserId = json['rank3UserId'];
    rank3CommAmt = json['rank3CommAmt'];
    rank3ChargeAmt = json['rank3ChargeAmt'];
    rank3PriorityTax = json['rank3PriorityTax'];
    rank3SecondaryTax = json['rank3SecondaryTax'];
    rank4UserId = json['rank4UserId'];
    rank4CommAmt = json['rank4CommAmt'];
    rank4ChargeAmt = json['rank4ChargeAmt'];
    rank4PriorityTax = json['rank4PriorityTax'];
    rank4SecondaryTax = json['rank4SecondaryTax'];
    transactionType1 = json['transactionType1'];
    isUplineCommDist = json['isUplineCommDist'];
    isLive = json['isLive'];
    circleID = json['circleID'];
    circleName = json['circleName'];
    isThreeWay = json['isThreeWay'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deviceId = json['deviceId'];
    txnAction = json['txnAction'];
    txnActionName = json['txnActionName'];
    profitLoss = json['profitLoss'];
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
    data['accountNo'] = accountNo;
    data['ifsc'] = ifsc;
    data['beneficiaryName'] = beneficiaryName;
    data['authenticator'] = authenticator;
    data['bbpsAccountNo'] = bbpsAccountNo;
    data['dueDate'] = dueDate;
    data['adharNo'] = adharNo;
    data['bankName'] = bankName;
    data['transactionType'] = transactionType;
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    data['serviceCode'] = serviceCode;
    data['tenantId'] = tenantId;
    data['tenantName'] = tenantName;
    data['channelName'] = channelName;
    data['splitTransactionId'] = splitTransactionId;
    data['rank1UserId'] = rank1UserId;
    data['rank1CommAmt'] = rank1CommAmt;
    data['rank1ChargeAmt'] = rank1ChargeAmt;
    data['rank1PriorityTax'] = rank1PriorityTax;
    data['rank1SecondaryTax'] = rank1SecondaryTax;
    data['rank2UserId'] = rank2UserId;
    data['rank2CommAmt'] = rank2CommAmt;
    data['rank2ChargeAmt'] = rank2ChargeAmt;
    data['rank2PriorityTax'] = rank2PriorityTax;
    data['rank2SecondaryTax'] = rank2SecondaryTax;
    data['rank3UserId'] = rank3UserId;
    data['rank3CommAmt'] = rank3CommAmt;
    data['rank3ChargeAmt'] = rank3ChargeAmt;
    data['rank3PriorityTax'] = rank3PriorityTax;
    data['rank3SecondaryTax'] = rank3SecondaryTax;
    data['rank4UserId'] = rank4UserId;
    data['rank4CommAmt'] = rank4CommAmt;
    data['rank4ChargeAmt'] = rank4ChargeAmt;
    data['rank4PriorityTax'] = rank4PriorityTax;
    data['rank4SecondaryTax'] = rank4SecondaryTax;
    data['transactionType1'] = transactionType1;
    data['isUplineCommDist'] = isUplineCommDist;
    data['isLive'] = isLive;
    data['circleID'] = circleID;
    data['circleName'] = circleName;
    data['isThreeWay'] = isThreeWay;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['deviceId'] = deviceId;
    data['txnAction'] = txnAction;
    data['txnActionName'] = txnActionName;
    data['profitLoss'] = profitLoss;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalCount;
  double? totalAmount;
  bool? hasPrevious;
  bool? hasNext;

  Pagination({this.currentPage, this.totalPages, this.pageSize, this.totalCount, this.totalAmount, this.hasPrevious, this.hasNext});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    totalAmount = json['totalAmount'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['pageSize'] = pageSize;
    data['totalCount'] = totalCount;
    data['totalAmount'] = totalAmount;
    data['hasPrevious'] = hasPrevious;
    data['hasNext'] = hasNext;
    return data;
  }
}

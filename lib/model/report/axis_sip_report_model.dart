class AxisSipReportModel {
  List<AxisSipListModel>? axisSipModelList;
  Pagination? pagination;
  String? message;
  int? statusCode;
  int? status;

  AxisSipReportModel(
      {this.axisSipModelList, this.pagination, this.message, this.statusCode, this.status});

  AxisSipReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      axisSipModelList = <AxisSipListModel>[];
      json['data'].forEach((v) {
        axisSipModelList!.add(AxisSipListModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    message = json['message'];
    statusCode = json['statusCode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> axisSipModelList = <String, dynamic>{};
    if (this.axisSipModelList != null) {
      axisSipModelList['data'] = this.axisSipModelList!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      axisSipModelList['pagination'] = pagination!.toJson();
    }
    axisSipModelList['message'] = message;
    axisSipModelList['statusCode'] = statusCode;
    axisSipModelList['status'] = status;
    return axisSipModelList;
  }
}

class AxisSipListModel {
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
  String? transactionDate;
  String? updatedDate;
  int? apiId;
  String? apiName;
  String? apiRef;
  String? clientRef;
  String? operatorRef;
  String? reason;
  String? ipAddress;
  String? orderId;
  String? customerDetails;
  String? paymentType;
  String? customerMobileNo;
  String? customerName;
  int? categoryId;
  String? categoryName;
  String? serviceCode;
  String? channelName;
  String? circleID;
  String? circleName;
  String? latitude;
  String? longitude;
  String? deviceId;
  String? transactionType;
  int? status;
  String? authenticator;
  String? updateRemark;

  AxisSipListModel(
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
        this.transactionDate,
        this.updatedDate,
        this.apiId,
        this.apiName,
        this.apiRef,
        this.clientRef,
        this.operatorRef,
        this.reason,
        this.ipAddress,
        this.orderId,
        this.customerDetails,
        this.paymentType,
        this.customerMobileNo,
        this.customerName,
        this.categoryId,
        this.categoryName,
        this.serviceCode,
        this.channelName,
        this.circleID,
        this.circleName,
        this.latitude,
        this.longitude,
        this.deviceId,
        this.transactionType,
        this.status,
        this.authenticator,
        this.updateRemark});

  AxisSipListModel.fromJson(Map<String, dynamic> json) {
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
    transactionDate = json['transactionDate'];
    updatedDate = json['updatedDate'];
    apiId = json['apiId'];
    apiName = json['apiName'];
    apiRef = json['apiRef'];
    clientRef = json['clientRef'];
    operatorRef = json['operatorRef'];
    reason = json['reason'];
    ipAddress = json['ipAddress'];
    orderId = json['orderId'];
    customerDetails = json['customerDetails'];
    paymentType = json['paymentType'];
    customerMobileNo = json['customerMobileNo'];
    customerName = json['customerName'];
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    serviceCode = json['serviceCode'];
    channelName = json['channelName'];
    circleID = json['circleID'];
    circleName = json['circleName'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deviceId = json['deviceId'];
    transactionType = json['transactionType'];
    status = json['status'];
    authenticator = json['authenticator'];
    updateRemark = json['updateRemark'];
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
    data['transactionDate'] = transactionDate;
    data['updatedDate'] = updatedDate;
    data['apiId'] = apiId;
    data['apiName'] = apiName;
    data['apiRef'] = apiRef;
    data['clientRef'] = clientRef;
    data['operatorRef'] = operatorRef;
    data['reason'] = reason;
    data['ipAddress'] = ipAddress;
    data['orderId'] = orderId;
    data['customerDetails'] = customerDetails;
    data['paymentType'] = paymentType;
    data['customerMobileNo'] = customerMobileNo;
    data['customerName'] = customerName;
    data['categoryId'] = categoryId;
    data['categoryName'] = categoryName;
    data['serviceCode'] = serviceCode;
    data['channelName'] = channelName;
    data['circleID'] = circleID;
    data['circleName'] = circleName;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['deviceId'] = deviceId;
    data['transactionType'] = transactionType;
    data['status'] = status;
    data['authenticator'] = authenticator;
    data['updateRemark'] = updateRemark;
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

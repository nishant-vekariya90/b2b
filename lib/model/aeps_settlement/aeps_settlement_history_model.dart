
class AepsSettlementHistoryModel {
  List<AepsSettlementHistoryData>? data;
  Pagination? pagination;
  String? message;
  int? status;

  AepsSettlementHistoryModel(
      {this.data, this.pagination, this.message, this.status});

  AepsSettlementHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AepsSettlementHistoryData>[];
      json['data'].forEach((v) {
        data!.add(AepsSettlementHistoryData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    message = json['message'];
    status = json['status'];
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
    data['status'] = status;
    return data;
  }
}

class AepsSettlementHistoryData {
  int? id;
  int? tenantID;
  String? tenantName;
  int? userID;
  String? userName;
  double? amount;
  String? paymentType;
  int? settlementBankID;
  String? bankName;
  String? holderName;
  String? accountNo;
  String? ifscCode;
  int? accountType;
  int? method;
  String? upiid;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  String? remarks;
  int? status;
  int? withdrawalMode;
  int? channelID;
  String? channelName;
  String? adminRemark;
  String? refID;
  String? utrNo;
  String? apiReference;

  AepsSettlementHistoryData(
      {this.id,
        this.tenantID,
        this.tenantName,
        this.userID,
        this.userName,
        this.amount,
        this.paymentType,
        this.settlementBankID,
        this.bankName,
        this.holderName,
        this.accountNo,
        this.ifscCode,
        this.accountType,
        this.method,
        this.upiid,
        this.createdOn,
        this.createdBy,
        this.modifiedOn,
        this.modifiedBy,
        this.remarks,
        this.status,
        this.withdrawalMode,
        this.channelID,
        this.channelName,
        this.adminRemark,
        this.refID,
        this.utrNo,
        this.apiReference});

  AepsSettlementHistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenantID = json['tenantID'];
    tenantName = json['tenantName'];
    userID = json['userID'];
    userName = json['userName'];
    amount = json['amount'];
    paymentType = json['paymentType'];
    settlementBankID = json['settlementBankID'];
    bankName = json['bankName'];
    holderName = json['holderName'];
    accountNo = json['accountNo'];
    ifscCode = json['ifscCode'];
    accountType = json['accountType'];
    method = json['method'];
    upiid = json['upiid'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    remarks = json['remarks'];
    status = json['status'];
    withdrawalMode = json['withdrawalMode'];
    channelID = json['channelID'];
    channelName = json['channelName'];
    adminRemark = json['adminRemark'];
    refID = json['refID'];
    utrNo = json['utrNo'];
    apiReference = json['apiReference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tenantID'] = tenantID;
    data['tenantName'] = tenantName;
    data['userID'] = userID;
    data['userName'] = userName;
    data['amount'] = amount;
    data['paymentType'] = paymentType;
    data['settlementBankID'] = settlementBankID;
    data['bankName'] = bankName;
    data['holderName'] = holderName;
    data['accountNo'] = accountNo;
    data['ifscCode'] = ifscCode;
    data['accountType'] = accountType;
    data['method'] = method;
    data['upiid'] = upiid;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    data['remarks'] = remarks;
    data['status'] = status;
    data['withdrawalMode'] = withdrawalMode;
    data['channelID'] = channelID;
    data['channelName'] = channelName;
    data['adminRemark'] = adminRemark;
    data['refID'] = refID;
    data['utrNo'] = utrNo;
    data['apiReference'] = apiReference;
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
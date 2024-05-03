class TopupHistoryModel {
  List<TopupHistoryData>? data;
  Pagination? pagination;
  String? message;
  int? status;

  TopupHistoryModel({this.data, this.pagination, this.message, this.status});

  TopupHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TopupHistoryData>[];
      json['data'].forEach((v) {
        data!.add(TopupHistoryData.fromJson(v));
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

class TopupHistoryData {
  int? id;
  String? userName;
  int? depositBankID;
  double? amount;
  String? paymentDate;
  int? paymentMode;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  String? remarks;
  String? userRemark;
  String? utRNo;
  String? bankDetails;
  int? status;
  String? cashType;
  String? chequeNo;
  int? requestUserID;
  String? requestUserName;
  String? transactionSlip;

  TopupHistoryData(
      {this.id,
        this.userName,
        this.depositBankID,
        this.amount,
        this.paymentDate,
        this.paymentMode,
        this.createdOn,
        this.createdBy,
        this.modifiedOn,
        this.modifiedBy,
        this.remarks,
        this.userRemark,
        this.utRNo,
        this.bankDetails,
        this.status,
        this.cashType,
        this.chequeNo,
        this.requestUserID,
        this.requestUserName,
        this.transactionSlip});

  TopupHistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    depositBankID = json['depositBankID'];
    amount = json['amount'];
    paymentDate = json['paymentDate'];
    paymentMode = json['paymentMode'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    remarks = json['remarks'];
    userRemark = json['userRemark'];
    utRNo = json['utR_No'];
    bankDetails = json['bankDetails'];
    status = json['status'];
    cashType = json['cashType'];
    chequeNo = json['chequeNo'];
    requestUserID = json['requestUserID'];
    requestUserName = json['requestUserName'];
    transactionSlip = json['transactionSlip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userName'] = userName;
    data['depositBankID'] = depositBankID;
    data['amount'] = amount;
    data['paymentDate'] = paymentDate;
    data['paymentMode'] = paymentMode;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    data['remarks'] = remarks;
    data['userRemark'] = userRemark;
    data['utR_No'] = utRNo;
    data['bankDetails'] = bankDetails;
    data['status'] = status;
    data['cashType'] = cashType;
    data['chequeNo'] = chequeNo;
    data['requestUserID'] = requestUserID;
    data['requestUserName'] = requestUserName;
    data['transactionSlip'] = transactionSlip;
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

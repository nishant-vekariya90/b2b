class PaymentModel {
  int? status;
  String? message;
  List<PaymentData>? data;
  Pagination? pagination;

  PaymentModel({
    this.status,
    this.message,
    this.data,
    this.pagination,
  });

  PaymentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PaymentData>[];
      json['data'].forEach((v) {
        data!.add(PaymentData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
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

class PaymentData {
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
  String? utRNo;
  String? bankDetails;
  int? status;
  String? cashType;
  String? chequeNo;
  int? requestUserID;
  String? requestUserName;
  String? transactionSlip;
  String? uniqueId;

  PaymentData({
    this.id,
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
    this.utRNo,
    this.bankDetails,
    this.status,
    this.cashType,
    this.chequeNo,
    this.requestUserID,
    this.requestUserName,
    this.transactionSlip,
    this.uniqueId,
  });

  PaymentData.fromJson(Map<String, dynamic> json) {
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
    utRNo = json['utR_No'];
    bankDetails = json['bankDetails'];
    status = json['status'];
    cashType = json['cashType'];
    chequeNo = json['chequeNo'];
    requestUserID = json['requestUserID'];
    requestUserName = json['requestUserName'];
    transactionSlip = json['transactionSlip'];
    uniqueId = json['uniqueId'];
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
    data['utR_No'] = utRNo;
    data['bankDetails'] = bankDetails;
    data['status'] = status;
    data['cashType'] = cashType;
    data['chequeNo'] = chequeNo;
    data['requestUserID'] = requestUserID;
    data['requestUserName'] = requestUserName;
    data['transactionSlip'] = transactionSlip;
    data['uniqueId'] = uniqueId;
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

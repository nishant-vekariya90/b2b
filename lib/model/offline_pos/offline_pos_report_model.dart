class OfflinePosReportModel {
  List<OfflinePosReportData>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  OfflinePosReportModel({
    this.data,
    this.pagination,
    this.message,
    this.statusCode,
  });

  OfflinePosReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <OfflinePosReportData>[];
      json['data'].forEach((v) {
        data!.add(OfflinePosReportData.fromJson(v));
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

class OfflinePosReportData {
  int? id;
  int? userId;
  String? userName;
  double? amount;
  String? bankRefNo;
  String? paySlip;
  String? cardType;
  int? txnRefNo;
  String? unqID;
  String? transactionDate;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  String? approvedOn;
  String? approvedBy;
  int? status;

  OfflinePosReportData({
    this.id,
    this.userId,
    this.userName,
    this.amount,
    this.bankRefNo,
    this.paySlip,
    this.cardType,
    this.txnRefNo,
    this.unqID,
    this.transactionDate,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
    this.approvedOn,
    this.approvedBy,
    this.status,
  });

  OfflinePosReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userName = json['userName'];
    amount = json['amount'];
    bankRefNo = json['bankRefNo'];
    paySlip = json['paySlip'];
    cardType = json['cardType'];
    txnRefNo = json['txnRefNo'];
    unqID = json['unqID'];
    transactionDate = json['transactionDate'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    approvedOn = json['approvedOn'];
    approvedBy = json['approvedBy'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['userName'] = userName;
    data['amount'] = amount;
    data['bankRefNo'] = bankRefNo;
    data['paySlip'] = paySlip;
    data['cardType'] = cardType;
    data['txnRefNo'] = txnRefNo;
    data['unqID'] = unqID;
    data['transactionDate'] = transactionDate;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    data['approvedOn'] = approvedOn;
    data['approvedBy'] = approvedBy;
    data['status'] = status;
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

class CreditDebitHistoryModel {
  List<CreditDebitData>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  CreditDebitHistoryModel({
    this.data,
    this.pagination,
    this.message,
    this.statusCode,
  });

  CreditDebitHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CreditDebitData>[];
      json['data'].forEach((v) {
        data!.add(CreditDebitData.fromJson(v));
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

class CreditDebitData {
  int? id;
  String? unqID;
  int? debitUserId;
  String? debitUser;
  int? creditUserId;
  String? creditUser;
  double? amount;
  int? wallet;
  String? comment;
  int? channel;
  String? ipAddress;
  int? status;
  String? remarks;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  String? verifiedOn;
  String? verifiedBy;
  int? refId;

  CreditDebitData({
    this.id,
    this.unqID,
    this.debitUserId,
    this.debitUser,
    this.creditUserId,
    this.creditUser,
    this.amount,
    this.wallet,
    this.comment,
    this.channel,
    this.ipAddress,
    this.status,
    this.remarks,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
    this.verifiedOn,
    this.verifiedBy,
    this.refId,
  });

  CreditDebitData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unqID = json['unqID'];
    debitUserId = json['debitUserId'];
    debitUser = json['debitUser'];
    creditUserId = json['creditUserId'];
    creditUser = json['creditUser'];
    amount = json['amount'];
    wallet = json['wallet'];
    comment = json['comment'];
    channel = json['channel'];
    ipAddress = json['ipAddress'];
    status = json['status'];
    remarks = json['remarks'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    verifiedOn = json['verifiedOn'];
    verifiedBy = json['verifiedBy'];
    refId = json['refId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unqID'] = unqID;
    data['debitUserId'] = debitUserId;
    data['debitUser'] = debitUser;
    data['creditUserId'] = creditUserId;
    data['creditUser'] = creditUser;
    data['amount'] = amount;
    data['wallet'] = wallet;
    data['comment'] = comment;
    data['channel'] = channel;
    data['ipAddress'] = ipAddress;
    data['status'] = status;
    data['remarks'] = remarks;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    data['verifiedOn'] = verifiedOn;
    data['verifiedBy'] = verifiedBy;
    data['refId'] = refId;
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

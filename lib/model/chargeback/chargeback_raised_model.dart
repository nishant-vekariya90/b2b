class ChargebackRaisedModel {
  List<ChargebackRaisedData>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  ChargebackRaisedModel(
      {this.data, this.pagination, this.message, this.statusCode});

  ChargebackRaisedModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ChargebackRaisedData>[];
      json['data'].forEach((v) {
        data!.add(ChargebackRaisedData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
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

class ChargebackRaisedData {
  int? id;
  int? userID;
  String? subject;
  int? categoryID;
  String? orderId;
  String? raisedBy;
  String? raisedReason;
  String? assignTo;
  String? assignBy;
  String? raisedReasonDocument;
  int? status;
  String? proofDocument;
  String? proofRemark;
  bool? isHold;
  String? createdOn;
  String? modifiedOn;
  String? param1;
  String? param2;
  String? param3;
  String? param4;
  String? uniqueId;
  int? subjectId;
  String? categoryName;
  String? expiryDate;
  int? assignUserId;
  double? amount;

  ChargebackRaisedData(
      {this.id,
        this.userID,
        this.subject,
        this.categoryID,
        this.orderId,
        this.raisedBy,
        this.raisedReason,
        this.assignTo,
        this.assignBy,
        this.raisedReasonDocument,
        this.status,
        this.proofDocument,
        this.proofRemark,
        this.isHold,
        this.createdOn,
        this.modifiedOn,
        this.param1,
        this.param2,
        this.param3,
        this.param4,
        this.uniqueId,
        this.subjectId,
        this.categoryName,
        this.expiryDate,
        this.assignUserId,
        this.amount});

  ChargebackRaisedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    subject = json['subject'];
    categoryID = json['categoryID'];
    orderId = json['orderId'];
    raisedBy = json['raisedBy'];
    raisedReason = json['raisedReason'];
    assignTo = json['assignTo'];
    assignBy = json['assignBy'];
    raisedReasonDocument = json['raisedReasonDocument'];
    status = json['status'];
    proofDocument = json['proofDocument'];
    proofRemark = json['proofRemark'];
    isHold = json['isHold'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    param1 = json['param1'];
    param2 = json['param2'];
    param3 = json['param3'];
    param4 = json['param4'];
    uniqueId = json['uniqueId'];
    subjectId = json['subjectId'];
    categoryName = json['categoryName'];
    expiryDate = json['expiryDate'];
    assignUserId = json['assignUserId'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userID;
    data['subject'] = subject;
    data['categoryID'] = categoryID;
    data['orderId'] = orderId;
    data['raisedBy'] = raisedBy;
    data['raisedReason'] = raisedReason;
    data['assignTo'] = assignTo;
    data['assignBy'] = assignBy;
    data['raisedReasonDocument'] = raisedReasonDocument;
    data['status'] = status;
    data['proofDocument'] = proofDocument;
    data['proofRemark'] = proofRemark;
    data['isHold'] = isHold;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['param1'] = param1;
    data['param2'] = param2;
    data['param3'] = param3;
    data['param4'] = param4;
    data['uniqueId'] = uniqueId;
    data['subjectId'] = subjectId;
    data['categoryName'] = categoryName;
    data['expiryDate'] = expiryDate;
    data['assignUserId'] = assignUserId;
    data['amount'] = amount;
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

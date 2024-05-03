class SettledCommissionModel {
  List<SettledCommissionModelData>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  SettledCommissionModel(
      {this.data, this.pagination, this.message, this.statusCode});

  SettledCommissionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SettledCommissionModelData>[];
      json['data'].forEach((v) {
        data!.add(SettledCommissionModelData.fromJson(v));
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

class SettledCommissionModelData {
  int? id;
  int? userID;
  String? userName;
  double? amount;
  double? commAmount;
  int? month;
  int? year;
  String? userType;
  int? userTypeID;
  int? status;
  String? mobileNo;
  String? email;
  int? tenantId;
  String? ownerName;
  String? createdOn;

  SettledCommissionModelData(
      {this.id,
        this.userID,
        this.userName,
        this.amount,
        this.commAmount,
        this.month,
        this.year,
        this.userType,
        this.userTypeID,
        this.status,
        this.mobileNo,
        this.email,
        this.tenantId,
        this.ownerName,
        this.createdOn});

  SettledCommissionModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    userName = json['userName'];
    amount = json['amount'];
    commAmount = json['commAmount'];
    month = json['month'];
    year = json['year'];
    userType = json['userType'];
    userTypeID = json['userTypeID'];
    status = json['status'];
    mobileNo = json['mobileNo'];
    email = json['email'];
    tenantId = json['tenantId'];
    ownerName = json['ownerName'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userID;
    data['userName'] = userName;
    data['amount'] = amount;
    data['commAmount'] = commAmount;
    data['month'] = month;
    data['year'] = year;
    data['userType'] = userType;
    data['userTypeID'] = userTypeID;
    data['status'] = status;
    data['mobileNo'] = mobileNo;
    data['email'] = email;
    data['tenantId'] = tenantId;
    data['ownerName'] = ownerName;
    data['createdOn'] = createdOn;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalCount;
  double? totalAmount;
  double? totalMargin;
  bool? hasPrevious;
  bool? hasNext;

  Pagination(
      {this.currentPage,
        this.totalPages,
        this.pageSize,
        this.totalCount,
        this.totalAmount,
        this.totalMargin,
        this.hasPrevious,
        this.hasNext});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    totalAmount = json['totalAmount'];
    totalMargin = json['totalMargin'];
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
    data['totalMargin'] = totalMargin;
    data['hasPrevious'] = hasPrevious;
    data['hasNext'] = hasNext;
    return data;
  }
}

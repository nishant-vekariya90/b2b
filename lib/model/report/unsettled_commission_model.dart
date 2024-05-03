class UnSettledCommissionModel {
  List<UnSettledCommissionModelData>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  UnSettledCommissionModel(
      {this.data, this.pagination, this.message, this.statusCode});

  UnSettledCommissionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <UnSettledCommissionModelData>[];
      json['data'].forEach((v) {
        data!.add(UnSettledCommissionModelData.fromJson(v));
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

class UnSettledCommissionModelData {
  int? userID;
  String? userName;
  double? margin;
  String? userType;
  double? amount;
  int? userTypeId;
  int? month;
  int? year;

  UnSettledCommissionModelData(
      {this.userID,
        this.userName,
        this.margin,
        this.userType,
        this.amount,
        this.userTypeId,
        this.month,
        this.year});

  UnSettledCommissionModelData.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    userName = json['userName'];
    margin = json['margin'];
    userType = json['userType'];
    amount = json['amount'];
    userTypeId = json['userTypeId'];
    month = json['month'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['userName'] = userName;
    data['margin'] = margin;
    data['userType'] = userType;
    data['amount'] = amount;
    data['userTypeId'] = userTypeId;
    data['month'] = month;
    data['year'] = year;
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

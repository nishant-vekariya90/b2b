class CommissionDetailsModal {
  List<CommissionDetailsModalData>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  CommissionDetailsModal(
      {this.data, this.pagination, this.message, this.statusCode});

  CommissionDetailsModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CommissionDetailsModalData>[];
      json['data'].forEach((v) {
        data!.add(CommissionDetailsModalData.fromJson(v));
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

class CommissionDetailsModalData {
  String? userName;
  String? userDetails;
  int? userType;
  String? userTypeName;
  String? profile;
  double? totalTxnAmount;
  double? margin;

  CommissionDetailsModalData(
      {this.userName,
        this.userDetails,
        this.userType,
        this.userTypeName,
        this.profile,
        this.totalTxnAmount,
        this.margin});

  CommissionDetailsModalData.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userDetails = json['userDetails'];
    userType = json['userType'];
    userTypeName = json['userTypeName'];
    profile = json['profile'];
    totalTxnAmount = json['totalTxnAmount'];
    margin = json['margin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['userDetails'] = userDetails;
    data['userType'] = userType;
    data['userTypeName'] = userTypeName;
    data['profile'] = profile;
    data['totalTxnAmount'] = totalTxnAmount;
    data['margin'] = margin;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalCount;
  int? totalAmount;
  int? totalMargin;
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

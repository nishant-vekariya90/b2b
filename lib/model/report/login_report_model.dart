class LoginReportModel {
  List<LoginReportData>? data;
  Pagination? pagination;
  String? message;
  int? status;

  LoginReportModel({this.data, this.pagination, this.message, this.status});

  LoginReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LoginReportData>[];
      json['data'].forEach((v) {
        data!.add(LoginReportData.fromJson(v));
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

class LoginReportData {
  int? id;
  int? userID;
  String? ipimei;
  String? loginTime;
  String? longitude;
  String? latitude;
  String? loginOS;
  String? loginBrowser;
  String? device;
  String? createdBy;
  String? createdOn;
  String? modifiedBy;
  String? modifiedOn;
  String? userName;

  LoginReportData(
      {this.id,
        this.userID,
        this.ipimei,
        this.loginTime,
        this.longitude,
        this.latitude,
        this.loginOS,
        this.loginBrowser,
        this.device,
        this.createdBy,
        this.createdOn,
        this.modifiedBy,
        this.modifiedOn,
        this.userName});

  LoginReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    ipimei = json['ipimei'];
    loginTime = json['loginTime'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    loginOS = json['loginOS'];
    loginBrowser = json['loginBrowser'];
    device = json['device'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedBy = json['modifiedBy'];
    modifiedOn = json['modifiedOn'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userID;
    data['ipimei'] = ipimei;
    data['loginTime'] = loginTime;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['loginOS'] = loginOS;
    data['loginBrowser'] = loginBrowser;
    data['device'] = device;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['modifiedBy'] = modifiedBy;
    data['modifiedOn'] = modifiedOn;
    data['userName'] = userName;
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

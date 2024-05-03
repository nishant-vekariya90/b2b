import 'package:get/get.dart';

class OfflineTokenCredentialsModel {
  List<OfflineTokenCredentialsData>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  OfflineTokenCredentialsModel({
    this.data,
    this.pagination,
    this.message,
    this.statusCode,
  });

  OfflineTokenCredentialsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <OfflineTokenCredentialsData>[];
      json['data'].forEach((v) {
        data!.add(OfflineTokenCredentialsData.fromJson(v));
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

class OfflineTokenCredentialsData {
  int? id;
  int? userID;
  int? serviceID;
  String? userName;
  String? serviceName;
  String? login;
  String? password;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  int? status;
  int? resetPinStatus;
  String? remark;
  String? unqID;
  String? type;
  String? loginUrl;
  RxString? maskedPassword = ''.obs;
  RxBool? isShowPassword = false.obs;
  RxBool? isPasswordCopied = false.obs;

  OfflineTokenCredentialsData({
    this.id,
    this.userID,
    this.serviceID,
    this.userName,
    this.serviceName,
    this.login,
    this.password,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
    this.status,
    this.resetPinStatus,
    this.remark,
    this.unqID,
    this.type,
    this.loginUrl,
    this.maskedPassword,
    this.isShowPassword,
    this.isPasswordCopied,
  });

  OfflineTokenCredentialsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    serviceID = json['serviceID'];
    userName = json['userName'];
    serviceName = json['serviceName'];
    login = json['login'];
    password = json['password'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    status = json['status'];
    resetPinStatus = json['resetPinStatus'];
    remark = json['remark'];
    unqID = json['unqID'];
    type = json['type'];
    loginUrl = json['loginUrl'];
    maskedPassword!.value = json['password'].toString().replaceAll(RegExp(r"."), "*");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userID;
    data['serviceID'] = serviceID;
    data['userName'] = userName;
    data['serviceName'] = serviceName;
    data['login'] = login;
    data['password'] = password;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    data['status'] = status;
    data['resetPinStatus'] = resetPinStatus;
    data['remark'] = remark;
    data['unqID'] = unqID;
    data['type'] = type;
    data['loginUrl'] = loginUrl;
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

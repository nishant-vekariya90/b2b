import 'package:get/get.dart';

class NotificationReportModel {
  List<NotificationReportData>? notificationDataList;
  Pagination? pagination;
  String? message;
  int? statusCode;

  NotificationReportModel(
      {this.notificationDataList, this.pagination, this.message, this.statusCode});

  NotificationReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      notificationDataList = <NotificationReportData>[];
      json['data'].forEach((v) {
        notificationDataList!.add(NotificationReportData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> notificationDataList = <String, dynamic>{};
    if (this.notificationDataList != null) {
      notificationDataList['data'] = this.notificationDataList!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      notificationDataList['pagination'] = pagination!.toJson();
    }
    notificationDataList['message'] = message;
    notificationDataList['statusCode'] = statusCode;
    return notificationDataList;
  }
}

class NotificationReportData {
  int? id;
  int? userTypeID;
  String? userTypeName;
  int? userID;
  String? title;
  String? message;
  String? fileUrl;
  String? link;
  bool? isRead;
  String? uniqueId;
  RxBool isMoreDetails = false.obs;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  String? userName;

  NotificationReportData(
      {this.id,
        this.userTypeID,
        this.userTypeName,
        this.userID,
        this.title,
        this.message,
        this.fileUrl,
        this.link,
        this.isRead,
        this.uniqueId,
        this.createdOn,
        this.createdBy,
        this.modifiedOn,
        this.modifiedBy,
        this.userName});

  NotificationReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userTypeID = json['userTypeID'];
    userTypeName = json['userTypeName'];
    userID = json['userID'];
    title = json['title'];
    message = json['message'];
    fileUrl = json['fileUrl'];
    link = json['link'];
    isRead = json['isRead'];
    uniqueId = json['uniqueId'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userTypeID'] = userTypeID;
    data['userTypeName'] = userTypeName;
    data['userID'] = userID;
    data['title'] = title;
    data['message'] = message;
    data['fileUrl'] = fileUrl;
    data['link'] = link;
    data['isRead'] = isRead;
    data['uniqueId'] = uniqueId;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
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

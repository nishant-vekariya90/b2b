class RaisedComplaintReportModel {
  List<RaisedComplaintReportData>? data;
  Pagination? pagination;
  String? message;
  int? status;

  RaisedComplaintReportModel(
      {this.data, this.pagination, this.message, this.status});

  RaisedComplaintReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <RaisedComplaintReportData>[];
      json['data'].forEach((v) {
        data!.add(RaisedComplaintReportData.fromJson(v));
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

class RaisedComplaintReportData {
  int? id;
  int? userID;
  String? type;
  String? subject;
  int? priority;
  int? status;
  // String? assignedTo;
  String? assignedToName;
  String? assignedBy;
  String? ticketMessage;
  String? documentFile;
  String? remark;
  String? createdOn;
  String? createdBy;
  String? modifedOn;
  String? modifiedBy;
  String? userName;
  String? orderID;
  String? api;
  String? apiStatus;
  String? assignedDate;

  RaisedComplaintReportData(
      {this.id,
        this.userID,
        this.type,
        this.subject,
        this.priority,
        this.status,
        // this.assignedTo,
        this.assignedToName,
        this.assignedBy,
        this.ticketMessage,
        this.documentFile,
        this.remark,
        this.createdOn,
        this.createdBy,
        this.modifedOn,
        this.modifiedBy,
        this.userName,
        this.orderID,
        this.api,
        this.apiStatus,
        this.assignedDate});

  RaisedComplaintReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    type = json['type'];
    subject = json['subject'];
    priority = json['priority'];
    status = json['status'];
    // assignedTo = json['assignedTo'];
    assignedToName = json['assignedToName'];
    assignedBy = json['assignedBy'];
    ticketMessage = json['ticketMessage'];
    documentFile = json['documentFile'];
    remark = json['remark'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifedOn = json['modifedOn'];
    modifiedBy = json['modifiedBy'];
    userName = json['userName'];
    orderID = json['orderID'];
    api = json['api'];
    apiStatus = json['apiStatus'];
    assignedDate = json['assignedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userID;
    data['type'] = type;
    data['subject'] = subject;
    data['priority'] = priority;
    data['status'] = status;
    // data['assignedTo'] = assignedTo;
    data['assignedToName'] = assignedToName;
    data['assignedBy'] = assignedBy;
    data['ticketMessage'] = ticketMessage;
    data['documentFile'] = documentFile;
    data['remark'] = remark;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifedOn'] = modifedOn;
    data['modifiedBy'] = modifiedBy;
    data['userName'] = userName;
    data['orderID'] = orderID;
    data['api'] = api;
    data['apiStatus'] = apiStatus;
    data['assignedDate'] = assignedDate;
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

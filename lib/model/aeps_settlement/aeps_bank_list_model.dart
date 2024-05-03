class AepsBankModel {
  List<AepsBankListModel>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  AepsBankModel({
    this.data,
    this.pagination,
    this.message,
    this.statusCode,
  });

  AepsBankModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AepsBankListModel>[];
      json['data'].forEach((v) {
        data!.add(AepsBankListModel.fromJson(v));
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

class AepsBankListModel {
  int? id;
  String? unqID;
  int? tenantID;
  String? tenantName;
  int? userID;
  String? userName;
  int? method;
  int? accountType;
  String? bankName;
  String? acHolderName;
  String? accountNumber;
  String? ifsCCode;
  String? fileUrl;
  String? upiid;
  String? createdBy;
  String? createdOn;
  String? modifiedOn;
  String? modifiedBy;
  String? createRemark;
  String? approvedBy;
  String? approveRemark;
  String? approveDate;
  int? status;

  AepsBankListModel({
    this.id,
    this.unqID,
    this.tenantID,
    this.tenantName,
    this.userID,
    this.userName,
    this.method,
    this.accountType,
    this.bankName,
    this.acHolderName,
    this.accountNumber,
    this.ifsCCode,
    this.fileUrl,
    this.upiid,
    this.createdBy,
    this.createdOn,
    this.modifiedOn,
    this.modifiedBy,
    this.createRemark,
    this.approvedBy,
    this.approveRemark,
    this.approveDate,
    this.status,
  });

  AepsBankListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unqID = json['unqID'];
    tenantID = json['tenantID'];
    tenantName = json['tenantName'];
    userID = json['userID'];
    userName = json['userName'];
    method = json['method'];
    accountType = json['accountType'];
    bankName = json['bankName'];
    acHolderName = json['acHolderName'];
    accountNumber = json['accountNumber'];
    ifsCCode = json['ifsC_Code'];
    fileUrl = json['fileUrl'];
    upiid = json['upiid'];
    createdBy = json['createdBy'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    createRemark = json['createRemark'];
    approvedBy = json['approvedBy'];
    approveRemark = json['approveRemark'];
    approveDate = json['approveDate'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unqID'] = unqID;
    data['tenantID'] = tenantID;
    data['tenantName'] = tenantName;
    data['userID'] = userID;
    data['userName'] = userName;
    data['method'] = method;
    data['accountType'] = accountType;
    data['bankName'] = bankName;
    data['acHolderName'] = acHolderName;
    data['accountNumber'] = accountNumber;
    data['ifsC_Code'] = ifsCCode;
    data['fileUrl'] = fileUrl;
    data['upiid'] = upiid;
    data['createdBy'] = createdBy;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    data['createRemark'] = createRemark;
    data['approvedBy'] = approvedBy;
    data['approveRemark'] = approveRemark;
    data['approveDate'] = approveDate;
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

  Pagination({this.currentPage, this.totalPages, this.pageSize, this.totalCount, this.hasPrevious, this.hasNext});

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

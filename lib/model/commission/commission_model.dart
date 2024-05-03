class CommissionModel {
  List<CommissionModelList>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  CommissionModel({
    this.data,
    this.pagination,
    this.message,
    this.statusCode,
  });

  CommissionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CommissionModelList>[];
      json['data'].forEach((v) {
        data!.add(CommissionModelList.fromJson(v));
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

class CommissionModelList {
  int? id;
  int? operatorID;
  int? apiid;
  double? chargePer;
  double? chargeVal;
  double? commPer;
  double? commVal;
  String? taxType;
  int? status;
  bool? isSlab;
  String? createdOn;
  String? modifiedOn;
  String? operatorName;
  String? serviceName;
  String? fileUrl;

  CommissionModelList({
    this.id,
    this.operatorID,
    this.apiid,
    this.chargePer,
    this.chargeVal,
    this.commPer,
    this.commVal,
    this.taxType,
    this.status,
    this.isSlab,
    this.createdOn,
    this.modifiedOn,
    this.operatorName,
    this.serviceName,
    this.fileUrl,
  });

  CommissionModelList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    operatorID = json['operatorID'];
    apiid = json['apiid'];
    chargePer = json['chargePer'];
    chargeVal = json['chargeVal'];
    commPer = json['commPer'];
    commVal = json['commVal'];
    taxType = json['taxType'];
    status = json['status'];
    isSlab = json['isSlab'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    operatorName = json['operatorName'];
    serviceName = json['serviceName'];
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['operatorID'] = operatorID;
    data['apiid'] = apiid;
    data['chargePer'] = chargePer;
    data['chargeVal'] = chargeVal;
    data['commPer'] = commPer;
    data['commVal'] = commVal;
    data['taxType'] = taxType;
    data['status'] = status;
    data['isSlab'] = isSlab;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['operatorName'] = operatorName;
    data['serviceName'] = serviceName;
    data['fileUrl'] = fileUrl;
    return data;
  }
}

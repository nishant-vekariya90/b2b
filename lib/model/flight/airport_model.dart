class AirportModel {
  List<AirportData>? data;
  Pagination? pagination;
  String? message;
  int? status;

  AirportModel({this.data, this.pagination, this.message, this.status});

  AirportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AirportData>[];
      json['data'].forEach((v) {
        data!.add(AirportData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
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

class AirportData {
  int? id;
  String? airportName;
  String? airportCode;
  String? cityName;
  String? cityCode;
  String? countryName;
  String? countryCode;
  String? fileURL;
  int? status;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;

  AirportData({
    this.id,
    this.airportName,
    this.airportCode,
    this.cityName,
    this.cityCode,
    this.countryName,
    this.countryCode,
    this.fileURL,
    this.status,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
  });

  AirportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    airportName = json['airportName'];
    airportCode = json['airportCode'];
    cityName = json['cityName'];
    cityCode = json['cityCode'];
    countryName = json['countryName'];
    countryCode = json['countryCode'];
    fileURL = json['fileURL'];
    status = json['status'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['airportName'] = airportName;
    data['airportCode'] = airportCode;
    data['cityName'] = cityName;
    data['cityCode'] = cityCode;
    data['countryName'] = countryName;
    data['countryCode'] = countryCode;
    data['fileURL'] = fileURL;
    data['status'] = status;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
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

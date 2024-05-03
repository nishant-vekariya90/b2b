class CompanyModel {
  int? statusCode;
  String? message;
  List<CompanyListModel>? data;

  CompanyModel({this.statusCode, this.message, this.data});

  CompanyModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CompanyListModel>[];
      json['data'].forEach((v) {
        data!.add(CompanyListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompanyListModel {
  int? id;
  String? companyName;

  CompanyListModel({this.id, this.companyName});

  CompanyListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['companyName'] = companyName;
    return data;
  }
}

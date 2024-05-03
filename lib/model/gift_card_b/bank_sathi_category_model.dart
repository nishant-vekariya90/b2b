class BankSathiCategoryModel {
  int? statusCode;
  String? message;
  List<BKCategoryListModel>? data;

  BankSathiCategoryModel({this.statusCode, this.message, this.data});

  BankSathiCategoryModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BKCategoryListModel>[];
      json['data'].forEach((v) {
        data!.add(BKCategoryListModel.fromJson(v));
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

class BKCategoryListModel {
  int? id;
  String? title;
  String? logo;

  BKCategoryListModel({this.id, this.title, this.logo});

  BKCategoryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

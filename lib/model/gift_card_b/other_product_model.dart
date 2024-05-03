import 'bank_account_product_model.dart';

class OtherProductModel {
  int? statusCode;
  String? message;
  List<EligibleProductList>? data;

  OtherProductModel({this.statusCode, this.message, this.data});

  OtherProductModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EligibleProductList>[];
      json['data'].forEach((v) {
        data!.add( EligibleProductList.fromJson(v));
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


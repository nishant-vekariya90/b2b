class PinCodeModel {
  int? statusCode;
  String? message;
  List<PinCodeListModel>? data;

  PinCodeModel({this.statusCode, this.message, this.data});

  PinCodeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PinCodeListModel>[];
      json['data'].forEach((v) {
        data!.add(PinCodeListModel.fromJson(v));
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

class PinCodeListModel {
  int? id;
  String? pinCode;

  PinCodeListModel({this.id, this.pinCode});

  PinCodeListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pinCode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pincode'] = pinCode;
    return data;
  }
}

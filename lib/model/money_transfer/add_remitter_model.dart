class AddRemitterModel {
  int? statusCode;
  String? message;
  Data? data;
  bool? isVerify;
  String? refNumber;

  AddRemitterModel({
    this.statusCode,
    this.message,
    this.data,
    this.isVerify,
    this.refNumber,
  });

  AddRemitterModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    isVerify = json['isVerify'];
    refNumber = json['refNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['isVerify'] = isVerify;
    data['refNumber'] = refNumber;
    return data;
  }
}

class Data {
  String? remitterCode;

  Data({this.remitterCode});

  Data.fromJson(Map<String, dynamic> json) {
    remitterCode = json['remitterCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['remitterCode'] = remitterCode;
    return data;
  }
}

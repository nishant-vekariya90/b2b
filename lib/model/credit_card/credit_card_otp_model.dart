class CreditCardOtpModel {
  int? statusCode;
  String? message;
  int? tid;
  String? data;

  CreditCardOtpModel({
    this.statusCode,
    this.message,
    this.tid,
    this.data,
  });

  CreditCardOtpModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    tid = json['tid'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['tid'] = tid;
    data['data'] = this.data;
    return data;
  }
}

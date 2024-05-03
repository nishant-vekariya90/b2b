class PaymentStatusUpdateModel {
  int? statusCode;
  String? message;

  PaymentStatusUpdateModel({
    this.statusCode,
    this.message,
  });

  PaymentStatusUpdateModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    return data;
  }
}

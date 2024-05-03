class ReceiptModel {
  int? statusCode;
  String? message;
  String? receipt;

  ReceiptModel({
    this.statusCode,
    this.message,
    this.receipt,
  });

  ReceiptModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    receipt = json['receipt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['receipt'] = receipt;
    return data;
  }
}

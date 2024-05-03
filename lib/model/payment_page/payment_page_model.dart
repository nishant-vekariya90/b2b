class PaymentPageModel {
  int? statusCode;
  String? message;
  List<String>? link;

  PaymentPageModel({
    this.statusCode,
    this.message,
    this.link,
  });

  PaymentPageModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    link = json['link'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['link'] = link;
    return data;
  }
}

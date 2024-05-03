class CmsModel {
  int? statusCode;
  String? redirectUrl;
  String? message;
  String? txnId;

  CmsModel({
    this.statusCode,
    this.redirectUrl,
    this.message,
    this.txnId,
  });

  CmsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    redirectUrl = json['redirectUrl'];
    message = json['message'];
    txnId = json['txnId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['redirectUrl'] = redirectUrl;
    data['message'] = message;
    data['txnId'] = txnId;
    return data;
  }
}

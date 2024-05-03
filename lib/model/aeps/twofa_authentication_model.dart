class TwoFaAuthenticationModel {
  int? statusCode;
  String? message;
  String? merAuthTxnId;

  TwoFaAuthenticationModel({
    this.statusCode,
    this.message,
    this.merAuthTxnId,
  });

  TwoFaAuthenticationModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    merAuthTxnId = json['merAuthTxnId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['merAuthTxnId'] = merAuthTxnId;
    return data;
  }
}

class AccountVerificationModel {
  int? statusCode;
  String? message;
  String? bankTxnId;
  String? name;
  String? orderId;

  AccountVerificationModel(
      {this.statusCode, this.message, this.bankTxnId, this.name, this.orderId});

  AccountVerificationModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    bankTxnId = json['bankTxnId'];
    name = json['name'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['bankTxnId'] = bankTxnId;
    data['name'] = name;
    data['orderId'] = orderId;
    return data;
  }
}

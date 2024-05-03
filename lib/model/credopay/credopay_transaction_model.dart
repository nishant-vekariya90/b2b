class CredoPayTransactionModel {
  int? statusCode;
  String? message;
  String? orderId;
  String? clientTransId;

  CredoPayTransactionModel(
      {this.statusCode, this.message, this.orderId, this.clientTransId});

  CredoPayTransactionModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    orderId = json['orderId'];
    clientTransId = json['clientTransId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['orderId'] = orderId;
    data['clientTransId'] = clientTransId;
    return data;
  }
}

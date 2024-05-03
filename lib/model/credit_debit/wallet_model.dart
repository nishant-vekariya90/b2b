class CreditDebitWalletModel {
  int? statusCode;
  String? message;
  String? clientTransId;
  String? status;
  int? orderId;
  int? amount;

  CreditDebitWalletModel({
    this.statusCode,
    this.message,
    this.clientTransId,
    this.status,
    this.orderId,
    this.amount,
  });

  CreditDebitWalletModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    clientTransId = json['clientTransId'];
    status = json['status'];
    orderId = json['orderId'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['clientTransId'] = clientTransId;
    data['status'] = status;
    data['orderId'] = orderId;
    data['amount'] = amount;
    return data;
  }
}

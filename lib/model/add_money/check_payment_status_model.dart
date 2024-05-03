class CheckPaymentStatusModel {
  int? statusCode;
  String? message;
  String? orderId;
  String? amount;
  String? bankRefId;
  String? paymentType;
  String? date;
  String? txnOrderId;

  CheckPaymentStatusModel({
    this.statusCode,
    this.message,
    this.orderId,
    this.amount,
    this.bankRefId,
    this.paymentType,
    this.date,
    this.txnOrderId,
  });

  CheckPaymentStatusModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    orderId = json['orderId'];
    amount = json['amount'].toString();
    bankRefId = json['bankRefId'];
    paymentType = json['paymentType'];
    date = json['date'];
    txnOrderId = json['txnOrderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['orderId'] = orderId;
    data['amount'] = amount;
    data['bankRefId'] = bankRefId;
    data['paymentType'] = paymentType;
    data['date'] = date;
    data['txnOrderId'] = txnOrderId;
    return data;
  }
}

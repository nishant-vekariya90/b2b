class BillPaymentModel {
  int? statusCode;
  String? message;
  BillPaymentModelData? data;

  BillPaymentModel({
    this.statusCode,
    this.message,
    this.data,
  });

  BillPaymentModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? BillPaymentModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BillPaymentModelData {
  String? number;
  String? amount;
  String? balance;
  int? status;
  String? operatorRef;
  int? txnRef;
  String? txnDate;
  String? orderId;

  BillPaymentModelData({
    this.number,
    this.amount,
    this.balance,
    this.status,
    this.operatorRef,
    this.txnRef,
    this.txnDate,
    this.orderId,
  });

  BillPaymentModelData.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    amount = json['amount'].toString();
    balance = json['balance'].toString();
    status = json['status'];
    operatorRef = json['operatorRef'];
    txnRef = json['txnRef'];
    txnDate = json['txnDate'];
    orderId = json['orderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['amount'] = amount;
    data['balance'] = balance;
    data['status'] = status;
    data['operatorRef'] = operatorRef;
    data['txnRef'] = txnRef;
    data['txnDate'] = txnDate;
    data['orderId'] = orderId;
    return data;
  }
}

class MobileRechargeModel {
  int? statusCode;
  String? message;
  String? clientTransId;
  String? operatorRef;
  String? status;
  int? orderId;
  int? cost;
  int? amount;

  MobileRechargeModel({
    this.statusCode,
    this.message,
    this.clientTransId,
    this.operatorRef,
    this.status,
    this.orderId,
    this.cost,
    this.amount,
  });

  MobileRechargeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    clientTransId = json['clientTransId'];
    operatorRef = json['operatorRef'];
    status = json['status'];
    orderId = json['orderId'];
    cost = json['cost'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['clientTransId'] = clientTransId;
    data['operatorRef'] = operatorRef;
    data['status'] = status;
    data['orderId'] = orderId;
    data['cost'] = cost;
    data['amount'] = amount;
    return data;
  }
}

class RechargeModel {
  int? statusCode;
  String? message;
  String? clientTransId;
  String? operatorRef;
  String? status;
  String? orderId;
  int? tid;
  String? cost;
  int? amount;

  RechargeModel({
    this.statusCode,
    this.message,
    this.clientTransId,
    this.operatorRef,
    this.status,
    this.orderId,
    this.cost,
    this.amount,
  });

  RechargeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    clientTransId = json['clientTransId'];
    operatorRef = json['operatorRef'];
    status = json['status'];
    orderId = json['orderId'];
    tid = json['tid'];
    cost = json['cost'].toString();
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
    data['tid'] = tid;
    data['cost'] = cost;
    data['amount'] = amount;
    return data;
  }
}

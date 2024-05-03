class AccountVerificationModel {
  int? statusCode;
  String? message;
  AccountVerificationData? data;

  AccountVerificationModel({
    this.statusCode,
    this.message,
    this.data,
  });

  AccountVerificationModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? AccountVerificationData.fromJson(json['data']) : null;
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

class AccountVerificationData {
  String? bankTxnId;
  String? bankAccNo;
  String? mobileNo;
  int? status;
  int? amount;
  String? orderId;
  String? recipientName;
  String? txnRefNumber;

  AccountVerificationData({
    this.bankTxnId,
    this.bankAccNo,
    this.mobileNo,
    this.status,
    this.amount,
    this.orderId,
    this.recipientName,
    this.txnRefNumber,
  });

  AccountVerificationData.fromJson(Map<String, dynamic> json) {
    bankTxnId = json['bankTxnId'];
    bankAccNo = json['bankAccNo'];
    mobileNo = json['mobileNo'];
    status = json['status'];
    amount = json['amount'];
    orderId = json['orderId'];
    recipientName = json['recipientName'];
    txnRefNumber = json['txnRefNumber'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bankTxnId'] = bankTxnId;
    data['bankAccNo'] = bankAccNo;
    data['mobileNo'] = mobileNo;
    data['status'] = status;
    data['amount'] = amount;
    data['orderId'] = orderId;
    data['recipientName'] = recipientName;
    data['txnRefNumber'] = txnRefNumber;
    return data;
  }
}

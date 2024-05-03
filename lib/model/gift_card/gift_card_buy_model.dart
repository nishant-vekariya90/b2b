class GiftCardBuyModel {
  int? statusCode;
  String? message;
  int? tid;
  Data? data;

  GiftCardBuyModel({this.statusCode, this.message, this.tid, this.data});

  GiftCardBuyModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    tid = json['tid'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['tid'] = tid;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? bankTxnId;
  String? bankAccNo;
  String? mobileNo;
  int? status;
  int? amount;
  String? orderId;
  String? recipientName;
  String? txnRefNumber;
  String? refId;

  Data(
      {this.bankTxnId,
        this.bankAccNo,
        this.mobileNo,
        this.status,
        this.amount,
        this.orderId,
        this.recipientName,
        this.txnRefNumber,
        this.refId});

  Data.fromJson(Map<String, dynamic> json) {
    bankTxnId = json['bankTxnId'];
    bankAccNo = json['bankAccNo'];
    mobileNo = json['mobileNo'];
    status = json['status'];
    amount = json['amount'];
    orderId = json['orderId'];
    recipientName = json['recipientName'];
    txnRefNumber = json['txnRefNumber'];
    refId = json['refId'];
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
    data['refId'] = refId;
    return data;
  }
}

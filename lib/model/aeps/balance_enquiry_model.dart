class BalanceEnquiryModel {
  int? statusCode;
  String? message;
  String? orderId;
  String? clientTransId;
  BalanceEnquiryData? data;

  BalanceEnquiryModel({
    this.statusCode,
    this.message,
    this.orderId,
    this.clientTransId,
    this.data,
  });

  BalanceEnquiryModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    orderId = json['orderId'].toString();
    clientTransId = json['clientTransId'].toString();
    data = json['data'] != null ? BalanceEnquiryData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['orderId'] = orderId;
    data['clientTransId'] = clientTransId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BalanceEnquiryData {
  String? amount;
  String? adhaarNo;
  String? txnTime;
  String? txnDate;
  String? bankName;
  String? rrn;
  String? status;
  String? customerMobile;
  String? bcName;
  String? availableBalance;
  String? ledgerBalance;

  BalanceEnquiryData({
    this.amount,
    this.adhaarNo,
    this.txnTime,
    this.txnDate,
    this.bankName,
    this.rrn,
    this.status,
    this.customerMobile,
    this.bcName,
    this.availableBalance,
    this.ledgerBalance,
  });

  BalanceEnquiryData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    adhaarNo = json['adhaarNo'];
    txnTime = json['txnTime'];
    txnDate = json['txnDate'];
    bankName = json['bankName'];
    rrn = json['rrn'];
    status = json['status'];
    customerMobile = json['customerMobile'];
    bcName = json['bcName'];
    availableBalance = json['availableBalance'];
    ledgerBalance = json['ledgerBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['adhaarNo'] = adhaarNo;
    data['txnTime'] = txnTime;
    data['txnDate'] = txnDate;
    data['bankName'] = bankName;
    data['rrn'] = rrn;
    data['status'] = status;
    data['customerMobile'] = customerMobile;
    data['bcName'] = bcName;
    data['availableBalance'] = availableBalance;
    data['ledgerBalance'] = ledgerBalance;
    return data;
  }
}

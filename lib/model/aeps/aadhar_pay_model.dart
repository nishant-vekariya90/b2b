class AadharPayModel {
  int? statusCode;
  String? message;
  AadharPayData? data;

  AadharPayModel({
    this.statusCode,
    this.message,
    this.data,
  });

  AadharPayModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? AadharPayData.fromJson(json['data']) : null;
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

class AadharPayData {
  int? amount;
  String? adhaarNo;
  String? txnTime;
  String? txnDate;
  String? bankName;
  String? rrn;
  String? status;
  String? customerMobile;
  String? availableBalance;
  String? ledgerBalance;

  AadharPayData({
    this.amount,
    this.adhaarNo,
    this.txnTime,
    this.txnDate,
    this.bankName,
    this.rrn,
    this.status,
    this.customerMobile,
    this.availableBalance,
    this.ledgerBalance,
  });

  AadharPayData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    adhaarNo = json['adhaarNo'];
    txnTime = json['txnTime'];
    txnDate = json['txnDate'];
    bankName = json['bankName'];
    rrn = json['rrn'];
    status = json['status'];
    customerMobile = json['customerMobile'];
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
    data['availableBalance'] = availableBalance;
    data['ledgerBalance'] = ledgerBalance;
    return data;
  }
}

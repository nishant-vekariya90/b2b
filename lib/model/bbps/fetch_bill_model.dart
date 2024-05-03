class FetchBillModel {
  int? statusCode;
  String? message;
  FetchBillData? data;

  FetchBillModel({
    this.statusCode,
    this.message,
    this.data,
  });

  FetchBillModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? FetchBillData.fromJson(json['data']) : null;
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

class FetchBillData {
  String? billerName;
  String? billDueDate;
  String? billDate;
  String? amount;
  String? billerNumber;
  String? partial;
  String? billRefNumber;
  String? billPeriod;
  String? additionalInfo;

  FetchBillData({
    this.billerName,
    this.billDueDate,
    this.billDate,
    this.amount,
    this.billerNumber,
    this.partial,
    this.billRefNumber,
    this.billPeriod,
    this.additionalInfo,
  });

  FetchBillData.fromJson(Map<String, dynamic> json) {
    billerName = json['billerName'];
    billDueDate = json['billDueDate'];
    billDate = json['billDate'];
    amount = json['amount'];
    billerNumber = json['billerNumber'];
    partial = json['partial'];
    billRefNumber = json['billRefNumber'];
    billPeriod = json['billPeriod'];
    additionalInfo = json['additionalInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billerName'] = billerName;
    data['billDueDate'] = billDueDate;
    data['billDate'] = billDate;
    data['amount'] = amount;
    data['billerNumber'] = billerNumber;
    data['partial'] = partial;
    data['billRefNumber'] = billRefNumber;
    data['billPeriod'] = billPeriod;
    data['additionalInfo'] = additionalInfo;
    return data;
  }
}

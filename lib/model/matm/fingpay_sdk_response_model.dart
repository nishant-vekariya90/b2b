class FingpaySdkResponseModel {
  bool? status;
  String? response;
  String? transAmount;
  String? balAmount;
  String? bankRrn;
  String? transType;
  int? type;
  String? cardNum;
  String? bankName;
  String? cardType;
  String? terminalId;
  String? fpId;
  String? transId;

  FingpaySdkResponseModel({
    this.status,
    this.response,
    this.transAmount,
    this.balAmount,
    this.bankRrn,
    this.transType,
    this.type,
    this.cardNum,
    this.bankName,
    this.cardType,
    this.terminalId,
    this.fpId,
    this.transId,
  });

  FingpaySdkResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    response = json['response'];
    transAmount = json['transAmount'].toString();
    balAmount = json['balAmount'].toString();
    bankRrn = json['bankRrn'];
    transType = json['transType'];
    type = json['type'];
    cardNum = json['cardNum'];
    bankName = json['bankName'];
    cardType = json['cardType'];
    terminalId = json['terminalId'];
    fpId = json['fpId'];
    transId = json['transId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['response'] = response;
    data['transAmount'] = transAmount;
    data['balAmount'] = balAmount;
    data['bankRrn'] = bankRrn;
    data['transType'] = transType;
    data['type'] = type;
    data['cardNum'] = cardNum;
    data['bankName'] = bankName;
    data['cardType'] = cardType;
    data['terminalId'] = terminalId;
    data['fpId'] = fpId;
    data['transId'] = transId;
    return data;
  }
}

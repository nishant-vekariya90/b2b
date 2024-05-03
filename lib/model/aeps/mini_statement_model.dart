class MiniStatementModel {
  int? statusCode;
  String? message;
  String? refNumber;
  String? bankName;
  String? merchant;
  String? merchantName;
  String? mobileNo;
  String? orderId;
  String? clientTransId;
  MiniStatementModelData? data;

  MiniStatementModel({
    this.statusCode,
    this.message,
    this.refNumber,
    this.bankName,
    this.merchant,
    this.merchantName,
    this.mobileNo,
    this.orderId,
    this.clientTransId,
    this.data,
  });

  MiniStatementModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    refNumber = json['refNumber'];
    bankName = json['bankName'];
    merchant = json['merchant'];
    merchantName = json['merchantName'];
    mobileNo = json['mobileNo'];
    orderId = json['orderId'];
    clientTransId = json['clientTransId'];
    data = json['data'] != null ? MiniStatementModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['refNumber'] = refNumber;
    data['bankName'] = bankName;
    data['merchant'] = merchant;
    data['merchantName'] = merchantName;
    data['mobileNo'] = mobileNo;
    data['orderId'] = orderId;
    data['clientTransId'] = clientTransId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MiniStatementModelData {
  String? adhaarNo;
  List<TransactionList>? transactionList;
  String? npciTranData;
  String? isFormated;
  String? systemTraceAudit;
  String? localTime;
  String? localDate;
  String? rrn;
  String? authIndentyResp;
  String? txnCurCode;
  String? uidAuthCode;
  String? terminalIdenty;
  String? cardAccceptorCode;
  String? nameLocation;
  String? balance;

  MiniStatementModelData({
    this.adhaarNo,
    this.transactionList,
    this.npciTranData,
    this.isFormated,
    this.systemTraceAudit,
    this.localTime,
    this.localDate,
    this.rrn,
    this.authIndentyResp,
    this.txnCurCode,
    this.uidAuthCode,
    this.terminalIdenty,
    this.cardAccceptorCode,
    this.nameLocation,
    this.balance,
  });

  MiniStatementModelData.fromJson(Map<String, dynamic> json) {
    adhaarNo = json['adhaarNo'];
    if (json['transactionList'] != null) {
      transactionList = <TransactionList>[];
      json['transactionList'].forEach((v) {
        transactionList!.add(TransactionList.fromJson(v));
      });
    }
    npciTranData = json['npciTranData'];
    isFormated = json['isFormated'];
    systemTraceAudit = json['systemTraceAudit'];
    localTime = json['localTime'];
    localDate = json['localDate'];
    rrn = json['rrn'];
    authIndentyResp = json['authIndentyResp'];
    txnCurCode = json['txnCurCode'];
    uidAuthCode = json['uidAuthCode'];
    terminalIdenty = json['terminalIdenty'];
    cardAccceptorCode = json['cardAccceptorCode'];
    nameLocation = json['nameLocation'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adhaarNo'] = adhaarNo;
    if (transactionList != null) {
      data['transactionList'] = transactionList!.map((v) => v.toJson()).toList();
    }
    data['npciTranData'] = npciTranData;
    data['isFormated'] = isFormated;
    data['systemTraceAudit'] = systemTraceAudit;
    data['localTime'] = localTime;
    data['localDate'] = localDate;
    data['rrn'] = rrn;
    data['authIndentyResp'] = authIndentyResp;
    data['txnCurCode'] = txnCurCode;
    data['uidAuthCode'] = uidAuthCode;
    data['terminalIdenty'] = terminalIdenty;
    data['cardAccceptorCode'] = cardAccceptorCode;
    data['nameLocation'] = nameLocation;
    data['balance'] = balance;
    return data;
  }
}

class TransactionList {
  String? date;
  String? modeOfTxn;
  String? type;
  String? refNo;
  String? debitCredit;
  String? amount;

  TransactionList({
    this.date,
    this.modeOfTxn,
    this.type,
    this.refNo,
    this.debitCredit,
    this.amount,
  });

  TransactionList.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    modeOfTxn = json['modeOfTxn'];
    type = json['type'];
    refNo = json['refNo'];
    debitCredit = json['debitCredit'];
    amount = json['amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['modeOfTxn'] = modeOfTxn;
    data['type'] = type;
    data['refNo'] = refNo;
    data['debitCredit'] = debitCredit;
    data['amount'] = amount;
    return data;
  }
}

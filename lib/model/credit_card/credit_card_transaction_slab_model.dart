class CreditCardTransactionSlabModel {
  int? statusCode;
  String? message;
  List<CreditCardSlab>? slab;
  dynamic totalAmount;
  dynamic customerPayAmount;
  dynamic totalCharge;
  dynamic totalMargin;
  String? txnRefNumber;

  CreditCardTransactionSlabModel({
    this.statusCode,
    this.message,
    this.slab,
    this.totalAmount,
    this.customerPayAmount,
    this.totalCharge,
    this.totalMargin,
    this.txnRefNumber,
  });

  CreditCardTransactionSlabModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['slab'] != null) {
      slab = <CreditCardSlab>[];
      json['slab'].forEach((v) {
        slab!.add(CreditCardSlab.fromJson(v));
      });
    }
    totalAmount = json['totalAmount'];
    customerPayAmount = json['customerPayAmount'];
    totalCharge = json['totalCharge'];
    totalMargin = json['totalMargin'];
    txnRefNumber = json['txnRefNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (slab != null) {
      data['slab'] = slab!.map((v) => v.toJson()).toList();
    }
    data['totalAmount'] = totalAmount;
    data['customerPayAmount'] = customerPayAmount;
    data['totalCharge'] = totalCharge;
    data['totalMargin'] = totalMargin;
    data['txnRefNumber'] = txnRefNumber;
    return data;
  }
}

class CreditCardSlab {
  int? slno;
  String? amount;
  String? serviceCharge;
  String? marginAmount;
  String? total;
  String? status = 'Failed';
  String? orderId;
  String? bankTxnId;
  String? txnRefNumber;

  CreditCardSlab({
    this.slno,
    this.amount,
    this.serviceCharge,
    this.marginAmount,
    this.total,
    this.status,
    this.orderId,
    this.bankTxnId,
    this.txnRefNumber,
  });

  CreditCardSlab.fromJson(Map<String, dynamic> json) {
    slno = json['slno'];
    amount = json['amount'].toString();
    serviceCharge = json['serviceCharge'].toString();
    marginAmount = json['marginAmount'].toString();
    total = json['total'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slno'] = slno;
    data['amount'] = amount;
    data['serviceCharge'] = serviceCharge;
    data['marginAmount'] = marginAmount;
    data['total'] = total;
    return data;
  }
}

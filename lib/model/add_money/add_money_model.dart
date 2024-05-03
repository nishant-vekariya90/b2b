class AddMoney {
  int? statusCode;
  String? message;
  String? orderId;
  String? ourOrderId;
  String? mobileNo;
  String? email;
  String? name;
  String? amount;
  String? amountINR;
  String? returnUrl;
  String? callbackUrl;
  String? paymentId;
  String? acParam1;
  String? acParam2;
  String? gateway;
  String? paymentUrl;
  Data? data;

  AddMoney({
    this.statusCode,
    this.message,
    this.orderId,
    this.ourOrderId,
    this.mobileNo,
    this.email,
    this.name,
    this.amount,
    this.amountINR,
    this.returnUrl,
    this.callbackUrl,
    this.paymentId,
    this.acParam1,
    this.acParam2,
    this.gateway,
    this.paymentUrl,
    this.data,
  });

  AddMoney.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    orderId = json['orderId'];
    ourOrderId = json['ourOrderId'];
    mobileNo = json['mobileNo'];
    email = json['email'];
    name = json['name'];
    amount = json['amount'];
    amountINR = json['amountINR'];
    returnUrl = json['returnUrl'];
    callbackUrl = json['callbackUrl'];
    paymentId = json['paymentId'];
    acParam1 = json['acParam1'];
    acParam2 = json['acParam2'];
    gateway = json['gateway'];
    paymentUrl = json['paymentUrl'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['orderId'] = orderId;
    data['ourOrderId'] = ourOrderId;
    data['mobileNo'] = mobileNo;
    data['email'] = email;
    data['name'] = name;
    data['amount'] = amount;
    data['amountINR'] = amountINR;
    data['returnUrl'] = returnUrl;
    data['callbackUrl'] = callbackUrl;
    data['paymentId'] = paymentId;
    data['acParam1'] = acParam1;
    data['acParam2'] = acParam2;
    data['gateway'] = gateway;
    data['paymentUrl'] = paymentUrl;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? firstname;
  String? udf1;
  String? email;
  String? surl;
  String? productinfo;
  int? amount;
  String? udf2;
  String? udf4;
  String? txnid;
  String? furl;
  String? phone;
  String? udf3;
  String? hash;
  String? udf5;
  String? key;
  String? paymode;

  Data({
    this.firstname,
    this.udf1,
    this.email,
    this.surl,
    this.productinfo,
    this.amount,
    this.udf2,
    this.udf4,
    this.txnid,
    this.furl,
    this.phone,
    this.udf3,
    this.hash,
    this.udf5,
    this.key,
    this.paymode,
  });

  Data.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    udf1 = json['udf1'];
    email = json['email'];
    surl = json['surl'];
    productinfo = json['productinfo'];
    amount = json['amount'];
    udf2 = json['udf2'];
    udf4 = json['udf4'];
    txnid = json['txnid'];
    furl = json['furl'];
    phone = json['phone'];
    udf3 = json['udf3'];
    hash = json['hash'];
    udf5 = json['udf5'];
    key = json['key'];
    paymode = json['paymode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = firstname;
    data['udf1'] = udf1;
    data['email'] = email;
    data['surl'] = surl;
    data['productinfo'] = productinfo;
    data['amount'] = amount;
    data['udf2'] = udf2;
    data['udf4'] = udf4;
    data['txnid'] = txnid;
    data['furl'] = furl;
    data['phone'] = phone;
    data['udf3'] = udf3;
    data['hash'] = hash;
    data['udf5'] = udf5;
    data['key'] = key;
    data['paymode'] = paymode;
    return data;
  }
}

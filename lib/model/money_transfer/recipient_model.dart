class RecipientModel {
  int? statusCode;
  String? message;
  List<RecipientListModel>? data;

  RecipientModel({
    this.statusCode,
    this.message,
    this.data,
  });

  RecipientModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RecipientListModel>[];
      json['data'].forEach((v) {
        data!.add(RecipientListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecipientListModel {
  String? name;
  String? mobileNo;
  String? recipientId;
  String? accountNo;
  String? ifsc;
  String? bankName;
  String? address;
  String? pincode;
  String? dob;
  String? status;
  bool? verified;
  String? bankId;
  String? accountType;
  String? vpa;

  RecipientListModel({
    this.name,
    this.mobileNo,
    this.recipientId,
    this.accountNo,
    this.ifsc,
    this.bankName,
    this.address,
    this.pincode,
    this.dob,
    this.status,
    this.verified,
    this.bankId,
    this.accountType,
    this.vpa,
  });

  RecipientListModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobileNo = json['mobileNo'];
    recipientId = json['recipientId'];
    accountNo = json['accountNo'];
    ifsc = json['ifsc'];
    bankName = json['bankName'];
    address = json['address'];
    pincode = json['pincode'];
    dob = json['dob'];
    status = json['status'];
    verified = json['verified'];
    bankId = json['bankId'];
    accountType = json['accountType'];
    vpa = json['vpa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mobileNo'] = mobileNo;
    data['recipientId'] = recipientId;
    data['accountNo'] = accountNo;
    data['ifsc'] = ifsc;
    data['bankName'] = bankName;
    data['address'] = address;
    data['pincode'] = pincode;
    data['dob'] = dob;
    data['status'] = status;
    data['verified'] = verified;
    data['bankId'] = bankId;
    data['accountType'] = accountType;
    data['vpa'] = vpa;
    return data;
  }
}

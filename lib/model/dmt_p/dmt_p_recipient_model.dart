class DmtPRecipientModel {
  int? statusCode;
  String? message;
  List<DmtPRecipientListModel>? data;

  DmtPRecipientModel({this.statusCode, this.message, this.data});

  DmtPRecipientModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DmtPRecipientListModel>[];
      json['data'].forEach((v) {
        data!.add(DmtPRecipientListModel.fromJson(v));
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

class DmtPRecipientListModel {
  String? name;
  String? mobileNo;
  String? recipientId;
  String? accountNo;
  String? ifsc;
  String? bankName;
  String? status;
  bool? verified;
  String? bankId;
  String? accountType;
  String? vpa;

  DmtPRecipientListModel({this.name, this.mobileNo, this.recipientId, this.accountNo, this.ifsc, this.bankName, this.status, this.verified, this.bankId, this.accountType, this.vpa});

  DmtPRecipientListModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobileNo = json['mobileNo'];
    recipientId = json['recipientId'];
    accountNo = json['accountNo'];
    ifsc = json['ifsc'];
    bankName = json['bankName'];
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
    data['status'] = status;
    data['verified'] = verified;
    data['bankId'] = bankId;
    data['accountType'] = accountType;
    data['vpa'] = vpa;
    return data;
  }
}

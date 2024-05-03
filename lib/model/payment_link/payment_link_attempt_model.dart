class PaymentLinkAttemptModel {
  List<PaymentLinkAttemptData>? data;
  String? message;
  int? statusCode;

  PaymentLinkAttemptModel({
    this.data,
    this.message,
    this.statusCode,
  });

  PaymentLinkAttemptModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PaymentLinkAttemptData>[];
      json['data'].forEach((v) {
        data!.add(PaymentLinkAttemptData.fromJson(v));
      });
    }
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['statusCode'] = statusCode;
    return data;
  }
}

class PaymentLinkAttemptData {
  int? id;
  int? userID;
  int? linkID;
  String? mobileNo;
  String? emailId;
  String? mode;
  String? name;
  String? accountNo;
  String? ifscCode;
  String? vpa;
  String? ipAddress;
  String? logitude;
  String? latitude;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  String? orderId;
  String? transId;
  String? remarks;
  int? status;

  PaymentLinkAttemptData({
    this.id,
    this.userID,
    this.linkID,
    this.mobileNo,
    this.emailId,
    this.mode,
    this.name,
    this.accountNo,
    this.ifscCode,
    this.vpa,
    this.ipAddress,
    this.logitude,
    this.latitude,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
    this.orderId,
    this.transId,
    this.remarks,
    this.status,
  });

  PaymentLinkAttemptData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    linkID = json['linkID'];
    mobileNo = json['mobileNo'];
    emailId = json['emailId'];
    mode = json['mode'];
    name = json['name'];
    accountNo = json['accountNo'];
    ifscCode = json['ifscCode'];
    vpa = json['vpa'];
    ipAddress = json['ipAddress'];
    logitude = json['logitude'];
    latitude = json['latitude'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    orderId = json['orderId'];
    transId = json['transId'];
    remarks = json['remarks'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userID;
    data['linkID'] = linkID;
    data['mobileNo'] = mobileNo;
    data['emailId'] = emailId;
    data['mode'] = mode;
    data['name'] = name;
    data['accountNo'] = accountNo;
    data['ifscCode'] = ifscCode;
    data['vpa'] = vpa;
    data['ipAddress'] = ipAddress;
    data['logitude'] = logitude;
    data['latitude'] = latitude;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    data['orderId'] = orderId;
    data['transId'] = transId;
    data['remarks'] = remarks;
    data['status'] = status;
    return data;
  }
}

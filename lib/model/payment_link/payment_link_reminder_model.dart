class PaymentLinkReminderModel {
  PaymentLinkReminderData? data;
  String? message;
  int? statusCode;

  PaymentLinkReminderModel({
    this.data,
    this.message,
    this.statusCode,
  });

  PaymentLinkReminderModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? PaymentLinkReminderData.fromJson(json['data']) : null;
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['statusCode'] = statusCode;
    return data;
  }
}

class PaymentLinkReminderData {
  int? id;
  bool? sms;
  bool? email;
  int? status;
  int? expiryDay;
  String? createdOn;
  String? createdBy;
  String? modifyOn;
  String? modifyBy;
  int? userID;

  PaymentLinkReminderData({
    this.id,
    this.sms,
    this.email,
    this.status,
    this.expiryDay,
    this.createdOn,
    this.createdBy,
    this.modifyOn,
    this.modifyBy,
    this.userID,
  });

  PaymentLinkReminderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sms = json['sms'];
    email = json['email'];
    status = json['status'];
    expiryDay = json['expiryDay'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifyOn = json['modifyOn'];
    modifyBy = json['modifyBy'];
    userID = json['userID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sms'] = sms;
    data['email'] = email;
    data['status'] = status;
    data['expiryDay'] = expiryDay;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifyOn'] = modifyOn;
    data['modifyBy'] = modifyBy;
    data['userID'] = userID;
    return data;
  }
}

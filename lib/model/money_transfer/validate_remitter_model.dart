class ValidateRemitterModel {
  int? statusCode;
  String? message;
  RemitterData? data;
  String? refNumber;
  bool? isVerify;

  ValidateRemitterModel({
    this.statusCode,
    this.message,
    this.data,
    this.refNumber,
    this.isVerify,
  });

  ValidateRemitterModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? RemitterData.fromJson(json['data']) : null;
    refNumber = json['refNumber'];
    isVerify = json['isVerify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['refNumber'] = refNumber;
    data['isVerify'] = isVerify;
    return data;
  }
}

class RemitterData {
  String? mobileNo;
  String? name;
  String? remitterId;
  String? monthlyLimit;
  String? bank1Limit;
  String? bank2Limit;
  String? bank3Limit;

  RemitterData({
    this.mobileNo,
    this.name,
    this.remitterId,
    this.monthlyLimit,
    this.bank1Limit,
    this.bank2Limit,
    this.bank3Limit,
  });

  RemitterData.fromJson(Map<String, dynamic> json) {
    mobileNo = json['mobileNo'];
    name = json['name'];
    remitterId = json['remitterId'];
    monthlyLimit = json['monthlyLimit'].toString();
    bank1Limit = json['bank1_Limit'].toString();
    bank2Limit = json['bank2_Limit'].toString();
    bank3Limit = json['bank3_Limit'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNo'] = mobileNo;
    data['name'] = name;
    data['remitterId'] = remitterId;
    data['monthlyLimit'] = monthlyLimit;
    data['bank1_Limit'] = bank1Limit;
    data['bank2_Limit'] = bank2Limit;
    data['bank3_Limit'] = bank3Limit;
    return data;
  }
}

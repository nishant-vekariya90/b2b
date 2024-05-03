class TwoFaRegistrationModel {
  int? statusCode;
  String? message;
  String? aadharNo;
  String? mobileNo;
  String? panCard;
  String? name;

  TwoFaRegistrationModel({
    this.statusCode,
    this.message,
    this.aadharNo,
    this.mobileNo,
    this.panCard,
    this.name,
  });

  TwoFaRegistrationModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    aadharNo = json['aadharNo'];
    mobileNo = json['mobileNo'];
    panCard = json['panCard'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['aadharNo'] = aadharNo;
    data['mobileNo'] = mobileNo;
    data['panCard'] = panCard;
    data['name'] = name;
    return data;
  }
}

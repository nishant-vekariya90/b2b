class VerifyBankSathiModel {
  int? statusCode;
  String? message;
  BkVerifiedUserData? data;

  VerifyBankSathiModel({this.statusCode, this.message, this.data});

  VerifyBankSathiModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? BkVerifiedUserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BkVerifiedUserData {
  String? firstName;
  String? lastName;
  String? mobileNo;
  String? firmName;
  String? email;
  String? gender;
  String? state;

  BkVerifiedUserData(
      {this.firstName,
        this.lastName,
        this.mobileNo,
        this.firmName,
        this.email,
        this.gender,
        this.state});

  BkVerifiedUserData.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNo = json['mobileNo'];
    firmName = json['firmName'];
    email = json['email'];
    gender = json['gender'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobileNo'] = mobileNo;
    data['firmName'] = firmName;
    data['email'] = email;
    data['gender'] = gender;
    data['state'] = state;
    return data;
  }
}

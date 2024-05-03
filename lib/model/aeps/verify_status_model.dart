class VerifyGatewayStatusModel {
  int? statusCode;
  String? message;
  bool? isAuth;
  String? status;
  UserData? data;
  bool? isRedirect;
  String? redirectUrl;

  VerifyGatewayStatusModel({
    this.statusCode,
    this.message,
    this.isAuth,
    this.status,
    this.data,
    this.isRedirect,
    this.redirectUrl,
  });

  VerifyGatewayStatusModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    isAuth = json['isAuth'];
    status = json['status'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
    isRedirect = json['isRedirect'];
    redirectUrl = json['redirectUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['isAuth'] = isAuth;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['isRedirect'] = isRedirect;
    data['redirectUrl'] = redirectUrl;
    return data;
  }
}

class UserData {
  String? aadharNo;
  String? mobileNo;
  String? panCard;
  String? name;
  String? email;
  String? accountNo;
  String? ifscCode;
  String? stateName;
  String? district;
  String? cityName;
  String? pinCode;
  String? address;
  String? latitude;
  String? longitude;

  UserData({
    this.aadharNo,
    this.mobileNo,
    this.panCard,
    this.name,
    this.email,
    this.accountNo,
    this.ifscCode,
    this.stateName,
    this.district,
    this.cityName,
    this.pinCode,
    this.address,
    this.latitude,
    this.longitude,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    aadharNo = json['aadharNo'];
    mobileNo = json['mobileNo'];
    panCard = json['panCard'];
    name = json['name'];
    email = json['email'];
    accountNo = json['accountNo'];
    ifscCode = json['ifscCode'];
    stateName = json['stateName'];
    district = json['district'];
    cityName = json['cityName'];
    pinCode = json['pinCode'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['aadharNo'] = aadharNo;
    data['mobileNo'] = mobileNo;
    data['panCard'] = panCard;
    data['name'] = name;
    data['email'] = email;
    data['accountNo'] = accountNo;
    data['ifscCode'] = ifscCode;
    data['stateName'] = stateName;
    data['district'] = district;
    data['cityName'] = cityName;
    data['pinCode'] = pinCode;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

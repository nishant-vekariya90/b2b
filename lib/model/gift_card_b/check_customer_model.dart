class CheckCustomerModel {
  int? statusCode;
  String? message;
  String? customerId;
  bool? creditScore;
  String? categoryId;
  String? mobileNo;
  String? panNo;

  CheckCustomerModel({this.statusCode, this.message, this.customerId, this.creditScore, this.categoryId, this.mobileNo, this.panNo});

  CheckCustomerModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    customerId = json['customerId'];
    creditScore = json['creditScore'];
    categoryId = json['categoryId'];
    mobileNo = json['mobileNo'];
    panNo = json['panNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['customerId'] = customerId;
    data['creditScore'] = creditScore;
    data['categoryId'] = categoryId;
    data['mobileNo'] = mobileNo;
    data['panNo'] = panNo;
    return data;
  }
}

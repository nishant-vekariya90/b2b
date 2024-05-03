class ValidateShowPasswordOtpModel {
  int? statusCode;
  String? message;
  String? password;

  ValidateShowPasswordOtpModel({
    this.statusCode,
    this.message,
    this.password,
  });

  ValidateShowPasswordOtpModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['password'] = password;
    return data;
  }
}

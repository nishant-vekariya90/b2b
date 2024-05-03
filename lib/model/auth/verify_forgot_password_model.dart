class VerifyForgotPasswordModel {
  int? statusCode;
  String? message;
  String? uuid;

  VerifyForgotPasswordModel({
    this.statusCode,
    this.message,
    this.uuid,
  });

  VerifyForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    uuid = json['uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['uuid'] = uuid;
    return data;
  }
}

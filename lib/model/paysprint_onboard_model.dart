class PaysprintOnboardModel {
  int? statusCode;
  String? message;
  bool? otpVerification;

  PaysprintOnboardModel({
    this.statusCode,
    this.message,
    this.otpVerification,
  });

  PaysprintOnboardModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    otpVerification = json['otpVerification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['otpVerification'] = otpVerification;
    return data;
  }
}

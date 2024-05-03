class InstantpayOnboardModel {
  int? statusCode;
  String? message;
  bool? otpVerification;

  InstantpayOnboardModel({
    this.statusCode,
    this.message,
    this.otpVerification,
  });

  InstantpayOnboardModel.fromJson(Map<String, dynamic> json) {
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

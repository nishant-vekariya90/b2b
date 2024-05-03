class WithdrwalLimitModel {
  String? message;
  int? statusCode;
  String? currentWithdrawalLimit;

  WithdrwalLimitModel({
    this.message,
    this.statusCode,
    this.currentWithdrawalLimit,
  });

  WithdrwalLimitModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    currentWithdrawalLimit = json['currentWithdrawalLimit'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['statusCode'] = statusCode;
    data['currentWithdrawalLimit'] = currentWithdrawalLimit;
    return data;
  }
}

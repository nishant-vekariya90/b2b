class AxisSipModel {
  int? statusCode;
  String? message;
  String? redirectUrl;

  AxisSipModel({this.statusCode, this.message, this.redirectUrl});

  AxisSipModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    redirectUrl = json['redirectUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['redirectUrl'] = redirectUrl;
    return data;
  }
}

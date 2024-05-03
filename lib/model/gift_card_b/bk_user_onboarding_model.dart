class BkOnboardUserModel {
  int? statusCode;
  String? message;

  BkOnboardUserModel({this.statusCode, this.message});

  BkOnboardUserModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    return data;
  }
}

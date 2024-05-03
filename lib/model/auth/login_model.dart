class LoginModel {
  String? accessToken;
  String? authMode;
  String? refNumber;
  String? message;

  LoginModel({
    this.accessToken,
    this.authMode,
    this.refNumber,
    this.message,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    authMode = json['authMode'];
    refNumber = json['refNumber'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['authMode'] = authMode;
    data['refNumber'] = refNumber;
    data['message'] = message;
    return data;
  }
}

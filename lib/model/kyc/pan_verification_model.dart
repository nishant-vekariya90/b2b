class PanVerificationModel {
  int? statusCode;
  String? message;
  String? requestId;
  PanVerificationData? data;

  PanVerificationModel(
      {this.statusCode, this.message, this.requestId, this.data});

  PanVerificationModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    requestId = json['requestId'];
    data = json['data'] != null ? PanVerificationData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['requestId'] = requestId;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PanVerificationData {
  String? clientId;
  String? panNumber;
  String? fullName;
  String? category;

  PanVerificationData({this.clientId, this.panNumber, this.fullName, this.category});

  PanVerificationData.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    panNumber = json['panNumber'];
    fullName = json['fullName'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['panNumber'] = panNumber;
    data['fullName'] = fullName;
    data['category'] = category;
    return data;
  }
}

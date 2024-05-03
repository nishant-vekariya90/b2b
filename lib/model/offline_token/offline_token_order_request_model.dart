class OfflineTokenOrderRequestModel {
  int? statusCode;
  String? message;
  int? tid;

  OfflineTokenOrderRequestModel({
    this.statusCode,
    this.message,
    this.tid,
  });

  OfflineTokenOrderRequestModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    tid = json['tid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['tid'] = tid;
    return data;
  }
}

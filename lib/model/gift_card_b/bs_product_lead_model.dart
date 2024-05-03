class BSProductLeadModel {
  int? statusCode;
  String? message;
  int? orderId;
  String? clientTransId;
  String? leadCode;
  String? campaignUrl;

  BSProductLeadModel(
      {this.statusCode,
        this.message,
        this.orderId,
        this.clientTransId,
        this.leadCode,
        this.campaignUrl});

  BSProductLeadModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    orderId = json['orderId'];
    clientTransId = json['clientTransId'];
    leadCode = json['leadCode'];
    campaignUrl = json['campaignUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['orderId'] = orderId;
    data['clientTransId'] = clientTransId;
    data['leadCode'] = leadCode;
    data['campaignUrl'] = campaignUrl;
    return data;
  }
}

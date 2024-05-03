class ConfirmRemoveRecipientModel {
  int? statusCode;
  String? message;
  String? recipientId;

  ConfirmRemoveRecipientModel({
    this.statusCode,
    this.message,
    this.recipientId,
  });

  ConfirmRemoveRecipientModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    recipientId = json['recipientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['recipientId'] = recipientId;
    return data;
  }
}

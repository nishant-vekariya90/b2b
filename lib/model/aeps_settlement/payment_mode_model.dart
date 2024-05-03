class PaymentModeModel {
  int? id;
  int? paymentModeID;
  String? name;
  String? fileUrl;
  int? status;
  String? createdOn;
  String? modifiedOn;
  String? paymentModeName;

  PaymentModeModel(
      {this.id,
        this.paymentModeID,
        this.name,
        this.fileUrl,
        this.status,
        this.createdOn,
        this.modifiedOn,
        this.paymentModeName});

  PaymentModeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentModeID = json['paymentModeID'];
    name = json['name'];
    fileUrl = json['fileUrl'];
    status = json['status'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    paymentModeName = json['paymentModeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['paymentModeID'] = paymentModeID;
    data['name'] = name;
    data['fileUrl'] = fileUrl;
    data['status'] = status;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['paymentModeName'] = paymentModeName;
    return data;
  }
}

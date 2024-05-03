class PaymentModeModel {
  int? id;
  String? name;
  String? fileUrl;
  int? status;
  String? createdOn;
  String? modifiedOn;

  PaymentModeModel({
    this.id,
    this.name,
    this.fileUrl,
    this.status,
    this.createdOn,
    this.modifiedOn,
  });

  PaymentModeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fileUrl = json['fileUrl'];
    status = json['status'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['fileUrl'] = fileUrl;
    data['status'] = status;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    return data;
  }
}

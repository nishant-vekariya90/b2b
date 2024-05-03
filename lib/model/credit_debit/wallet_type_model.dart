class WalletTypeModel {
  int? id;
  String? name;
  int? status;
  String? code;
  String? description;

  WalletTypeModel({
    this.id,
    this.name,
    this.status,
    this.code,
    this.description,
  });

  WalletTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    code = json['code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['code'] = code;
    data['description'] = description;
    return data;
  }
}

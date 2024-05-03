class PaymentGatewayModel {
  int? id;
  String? name;
  int? status;
  int? rank;
  bool? isDeleted;
  String? code;
  String? description;
  int? categoryID;
  String? categoryName;

  PaymentGatewayModel({
    this.id,
    this.name,
    this.status,
    this.rank,
    this.isDeleted,
    this.code,
    this.description,
  });

  PaymentGatewayModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    rank = json['rank'];
    isDeleted = json['isDeleted'];
    code = json['code'];
    description = json['description'];
    categoryID = json['categoryID'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['rank'] = rank;
    data['isDeleted'] = isDeleted;
    data['code'] = code;
    data['description'] = description;
    data['categoryID'] = categoryID;
    data['categoryName'] = categoryName;
    return data;
  }
}

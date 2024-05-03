class UserTypeModel {
  int? id;
  String? name;
  String? code;
  String? description;
  int? rank;
  int? status;
  bool? isUser;
  bool? isAllow;
  bool? isCommission;
  String? createdOn;
  String? modifiedOn;

  UserTypeModel({
    this.id,
    this.name,
    this.code,
    this.description,
    this.rank,
    this.status,
    this.isUser,
    this.isAllow,
    this.isCommission,
    this.createdOn,
    this.modifiedOn,
  });

  UserTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
    rank = json['rank'];
    status = json['status'];
    isUser = json['isUser'];
    isAllow = json['isAllow'];
    isCommission = json['isCommission'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['description'] = description;
    data['rank'] = rank;
    data['status'] = status;
    data['isUser'] = isUser;
    data['isAllow'] = isAllow;
    data['isCommission'] = isCommission;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    return data;
  }
}

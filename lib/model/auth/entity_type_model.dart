class EntityTypeModel {
  int? id;
  String? name;
  String? code;
  bool? isKYC;
  String? createdOn;
  String? modifiedOn;
  int? status;

  EntityTypeModel(
      {this.id,
        this.name,
        this.code,
        this.isKYC,
        this.createdOn,
        this.modifiedOn,
        this.status});

  EntityTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    isKYC = json['isKYC'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['isKYC'] = isKYC;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['status'] = status;
    return data;
  }
}

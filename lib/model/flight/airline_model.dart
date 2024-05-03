class AirlineModel {
  int? id;
  String? name;
  String? code;
  String? country;
  bool? isPreferred;
  String? gdsCode;
  int? status;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  String? fileURL;
  bool? isLCC;

  AirlineModel({
    this.id,
    this.name,
    this.code,
    this.country,
    this.isPreferred,
    this.gdsCode,
    this.status,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
    this.fileURL,
    this.isLCC,
  });

  AirlineModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    country = json['country'];
    isPreferred = json['isPreferred'];
    gdsCode = json['gdsCode'];
    status = json['status'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    fileURL = json['fileURL'];
    isLCC = json['isLCC'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['country'] = country;
    data['isPreferred'] = isPreferred;
    data['gdsCode'] = gdsCode;
    data['status'] = status;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    data['fileURL'] = fileURL;
    data['isLCC'] = isLCC;
    return data;
  }
}

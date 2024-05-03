class GetLatestVersionModel {
  int? id;
  int? tenantID;
  String? version;
  String? message;
  int? type;
  int? status;
  String? createdOn;
  String? modifiedOn;
  String? createdBy;
  String? modifiedBy;
  int? versionCode;

  GetLatestVersionModel(
      {this.id,
        this.tenantID,
        this.version,
        this.message,
        this.type,
        this.status,
        this.createdOn,
        this.modifiedOn,
        this.createdBy,
        this.modifiedBy,
        this.versionCode});

  GetLatestVersionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenantID = json['tenantID'];
    version = json['version'];
    message = json['message'];
    type = json['type'];
    status = json['status'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    versionCode = json['versionCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tenantID'] = tenantID;
    data['version'] = version;
    data['message'] = message;
    data['type'] = type;
    data['status'] = status;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['createdBy'] = createdBy;
    data['modifiedBy'] = modifiedBy;
    data['versionCode'] = versionCode;
    return data;
  }
}

class AgreementModel {
  int? id;
  int? tenantID;
  String? type;
  String? name;
  String? value;
  String? contentType;
  String? fileURL;
  String? extra1;
  String? extra2;
  String? extra3;
  String? tenantName;
  bool? isShowWebsite;

  AgreementModel(
      {this.id,
        this.tenantID,
        this.type,
        this.name,
        this.value,
        this.contentType,
        this.fileURL,
        this.extra1,
        this.extra2,
        this.extra3,
        this.tenantName,
        this.isShowWebsite});

  AgreementModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenantID = json['tenantID'];
    type = json['type'];
    name = json['name'];
    value = json['value'];
    contentType = json['contentType'];
    fileURL = json['fileURL'];
    extra1 = json['extra1'];
    extra2 = json['extra2'];
    extra3 = json['extra3'];
    tenantName = json['tenantName'];
    isShowWebsite = json['isShowWebsite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tenantID'] = tenantID;
    data['type'] = type;
    data['name'] = name;
    data['value'] = value;
    data['contentType'] = contentType;
    data['fileURL'] = fileURL;
    data['extra1'] = extra1;
    data['extra2'] = extra2;
    data['extra3'] = extra3;
    data['tenantName'] = tenantName;
    data['isShowWebsite'] = isShowWebsite;
    return data;
  }
}

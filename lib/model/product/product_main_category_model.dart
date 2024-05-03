class ProductMainCategoryModel {
  int? id;
  String? code;
  String? name;
  String? iconUrl;
  String? bannerUrl;
  String? seoTitle;
  String? seoDescription;
  int? status;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  bool? isVisible;

  ProductMainCategoryModel({
    this.id,
    this.code,
    this.name,
    this.iconUrl,
    this.bannerUrl,
    this.seoTitle,
    this.seoDescription,
    this.status,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
    this.isVisible,
  });

  ProductMainCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    iconUrl = json['iconUrl'];
    bannerUrl = json['bannerUrl'];
    seoTitle = json['seoTitle'];
    seoDescription = json['seoDescription'];
    status = json['status'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    isVisible = json['isVisible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['iconUrl'] = iconUrl;
    data['bannerUrl'] = bannerUrl;
    data['seoTitle'] = seoTitle;
    data['seoDescription'] = seoDescription;
    data['status'] = status;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    data['isVisible'] = isVisible;
    return data;
  }
}

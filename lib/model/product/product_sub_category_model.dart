class ProductSubCategoryModel {
  int? id;
  String? code;
  String? name;
  int? categoryID;
  String? categoryName;
  String? iconUrl;
  String? bannerUrl;
  String? seoTitle;
  String? seoDescription;
  int? status;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;

  ProductSubCategoryModel({
    this.id,
    this.code,
    this.name,
    this.categoryID,
    this.categoryName,
    this.iconUrl,
    this.bannerUrl,
    this.seoTitle,
    this.seoDescription,
    this.status,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
  });

  ProductSubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    categoryID = json['categoryID'];
    categoryName = json['categoryName'];
    iconUrl = json['iconUrl'];
    bannerUrl = json['bannerUrl'];
    seoTitle = json['seoTitle'];
    seoDescription = json['seoDescription'];
    status = json['status'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['categoryID'] = categoryID;
    data['categoryName'] = categoryName;
    data['iconUrl'] = iconUrl;
    data['bannerUrl'] = bannerUrl;
    data['seoTitle'] = seoTitle;
    data['seoDescription'] = seoDescription;
    data['status'] = status;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    return data;
  }
}

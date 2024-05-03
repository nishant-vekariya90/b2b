class DisputeSubCategoryModel {
  int? id;
  String? name;
  int? disputeCategoryId;
  String? disputeCategoryName;
  String? icon;
  int? priority;
  int? status;

  DisputeSubCategoryModel(
      {this.id,
        this.name,
        this.disputeCategoryId,
        this.disputeCategoryName,
        this.icon,
        this.priority,
        this.status});

  DisputeSubCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    disputeCategoryId = json['disputeCategoryId'];
    disputeCategoryName = json['disputeCategoryName'];
    icon = json['icon'];
    priority = json['priority'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['disputeCategoryId'] = disputeCategoryId;
    data['disputeCategoryName'] = disputeCategoryName;
    data['icon'] = icon;
    data['priority'] = priority;
    data['status'] = status;
    return data;
  }
}

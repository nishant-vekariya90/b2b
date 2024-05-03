class DisputeChildCategoryModel {
  int? id;
  String? name;
  int? disputeSubcategoryId;
  String? disputeSubcategoryName;
  String? icon;
  int? priority;

  DisputeChildCategoryModel(
      {this.id,
        this.name,
        this.disputeSubcategoryId,
        this.disputeSubcategoryName,
        this.icon,
        this.priority});

  DisputeChildCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    disputeSubcategoryId = json['disputeSubcategoryId'];
    disputeSubcategoryName = json['disputeSubcategoryName'];
    icon = json['icon'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['disputeSubcategoryId'] = disputeSubcategoryId;
    data['disputeSubcategoryName'] = disputeSubcategoryName;
    data['icon'] = icon;
    data['priority'] = priority;
    return data;
  }
}

class CategoryModel {
  int? id;
  String? name;
  String? fileUrl;
  int? status;

  CategoryModel({this.id, this.name, this.fileUrl, this.status});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fileUrl = json['fileUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['fileUrl'] = fileUrl;
    data['status'] = status;
    return data;
  }
}

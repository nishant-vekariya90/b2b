class AxisSipExportModel {
  bool? item1;
  String? item2;

  AxisSipExportModel({this.item1, this.item2});

  AxisSipExportModel.fromJson(Map<String, dynamic> json) {
    item1 = json['item1'];
    item2 = json['item2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item1'] = item1;
    data['item2'] = item2;
    return data;
  }
}

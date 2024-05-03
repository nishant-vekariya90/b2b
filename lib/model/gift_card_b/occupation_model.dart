class OccupationModel {
  int? statusCode;
  String? message;
  List<OccupationListModel>? data;

  OccupationModel({this.statusCode, this.message, this.data});

  OccupationModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OccupationListModel>[];
      json['data'].forEach((v) {
        data!.add(OccupationListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OccupationListModel {
  int? id;
  String? occuTitle;

  OccupationListModel({this.id, this.occuTitle});

  OccupationListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    occuTitle = json['occuTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['occuTitle'] = occuTitle;
    return data;
  }
}

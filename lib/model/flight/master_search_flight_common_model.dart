import 'package:get/get_rx/src/rx_types/rx_types.dart';

class MasterSearchFlightCommonModel {
  int? id;
  String? name;
  String? code;
  int? rank;
  bool? isFlight;
  String? fileURL;
  int? status;
  String? createdOn;
  String? modifiedOn;
  String? createdBy;
  String? modifiedBy;
  RxBool? flightStopCheckBox = false.obs;

  MasterSearchFlightCommonModel({
    this.id,
    this.name,
    this.code,
    this.rank,
    this.isFlight,
    this.fileURL,
    this.status,
    this.createdOn,
    this.modifiedOn,
    this.createdBy,
    this.modifiedBy,
    this.flightStopCheckBox,
  });

  MasterSearchFlightCommonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    rank = json['rank'];
    isFlight = json['isFlight'];
    fileURL = json['fileURL'];
    status = json['status'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['rank'] = rank;
    data['isFlight'] = isFlight;
    data['fileURL'] = fileURL;
    data['status'] = status;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['createdBy'] = createdBy;
    data['modifiedBy'] = modifiedBy;
    return data;
  }
}

class SettlementCyclesModel {
  int? id;
  String? settlementType;
  int? status;
  int? settleInHour;
  String? createdOn;
  String? modifiedOn;

  SettlementCyclesModel({
    this.id,
    this.settlementType,
    this.status,
    this.settleInHour,
    this.createdOn,
    this.modifiedOn,
  });

  SettlementCyclesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    settlementType = json['settlementType'];
    status = json['status'];
    settleInHour = json['settleInHour'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['settlementType'] = settlementType;
    data['status'] = status;
    data['settleInHour'] = settleInHour;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    return data;
  }
}

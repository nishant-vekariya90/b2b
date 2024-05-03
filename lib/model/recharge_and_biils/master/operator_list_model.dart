class MasterOperatorListModel {
  int? id;
  String? name;
  int? serviceID;
  int? status;
  String? apiCode;
  int? taxTypeID;
  String? fileUrl;
  bool? isBBPS;
  bool? isValidate;
  bool? isPartial;
  double? minAmount;
  double? maxAmount;
  int? mainMinLength;
  int? mainMaxLength;
  String? amountPlans;
  String? allowType;
  bool? isRandom;
  String? rejectedAmount;
  int? stateID;
  String? serviceName;
  String? stateName;
  String? taxTypeName;
  String? code;

  MasterOperatorListModel({
    this.id,
    this.name,
    this.serviceID,
    this.status,
    this.apiCode,
    this.taxTypeID,
    this.fileUrl,
    this.isBBPS,
    this.isValidate,
    this.isPartial,
    this.minAmount,
    this.maxAmount,
    this.mainMinLength,
    this.mainMaxLength,
    this.amountPlans,
    this.allowType,
    this.isRandom,
    this.rejectedAmount,
    this.stateID,
    this.serviceName,
    this.stateName,
    this.taxTypeName,
    this.code,
  });

  MasterOperatorListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    serviceID = json['serviceID'];
    status = json['status'];
    apiCode = json['apiCode'];
    taxTypeID = json['taxTypeID'];
    fileUrl = json['fileUrl'];
    isBBPS = json['isBBPS'];
    isValidate = json['isValidate'];
    isPartial = json['isPartial'];
    minAmount = json['minAmount'];
    maxAmount = json['maxAmount'];
    mainMinLength = json['mainMinLength'];
    mainMaxLength = json['mainMaxLength'];
    amountPlans = json['amountPlans'];
    allowType = json['allowType'];
    isRandom = json['isRandom'];
    rejectedAmount = json['rejectedAmount'];
    stateID = json['stateID'];
    serviceName = json['serviceName'];
    stateName = json['stateName'];
    taxTypeName = json['taxTypeName'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['serviceID'] = serviceID;
    data['status'] = status;
    data['apiCode'] = apiCode;
    data['taxTypeID'] = taxTypeID;
    data['fileUrl'] = fileUrl;
    data['isBBPS'] = isBBPS;
    data['isValidate'] = isValidate;
    data['isPartial'] = isPartial;
    data['minAmount'] = minAmount;
    data['maxAmount'] = maxAmount;
    data['mainMinLength'] = mainMinLength;
    data['mainMaxLength'] = mainMaxLength;
    data['amountPlans'] = amountPlans;
    data['allowType'] = allowType;
    data['isRandom'] = isRandom;
    data['rejectedAmount'] = rejectedAmount;
    data['stateID'] = stateID;
    data['serviceName'] = serviceName;
    data['stateName'] = stateName;
    data['taxTypeName'] = taxTypeName;
    data['code'] = code;
    return data;
  }
}

class OperationModel {
  String? operationType;
  int? totalCount;
  int? activeCount;
  List<Operations>? operations;

  OperationModel(
      {this.operationType, this.totalCount, this.activeCount, this.operations});

  OperationModel.fromJson(Map<String, dynamic> json) {
    operationType = json['operationType'];
    totalCount = json['totalCount'];
    activeCount = json['activeCount'];
    if (json['operations'] != null) {
      operations = <Operations>[];
      json['operations'].forEach((v) {
        operations!.add(Operations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['operationType'] = operationType;
    data['totalCount'] = totalCount;
    data['activeCount'] = activeCount;
    if (operations != null) {
      data['operations'] = operations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Operations {
  String? operationName;
  bool? isUI;
  int? status;
  String? code;
  bool? isMakerChecker;
  dynamic makerChecker;
  bool? isUIOperationWise;

  Operations(
      {this.operationName,
        this.isUI,
        this.status,
        this.code,
        this.isMakerChecker,
        this.makerChecker,
        this.isUIOperationWise});

  Operations.fromJson(Map<String, dynamic> json) {
    operationName = json['operationName'];
    isUI = json['isUI'];
    status = json['status'];
    code = json['code'];
    isMakerChecker = json['isMakerChecker'];
    makerChecker = json['makerChecker'];
    isUIOperationWise = json['isUIOperationWise'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['operationName'] = operationName;
    data['isUI'] = isUI;
    data['status'] = status;
    data['code'] = code;
    data['isMakerChecker'] = isMakerChecker;
    data['makerChecker'] = makerChecker;
    data['isUIOperationWise'] = isUIOperationWise;
    return data;
  }
}

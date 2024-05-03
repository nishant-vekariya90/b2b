class KYCStepsModel {
  List<KYCSteps>? steps;
  List<CompletedStepId>? completedStepId;

  KYCStepsModel({this.steps, this.completedStepId});

  KYCStepsModel.fromJson(Map<String, dynamic> json) {
    if (json['steps'] != null) {
      steps = <KYCSteps>[];
      json['steps'].forEach((v) {
        steps!.add(KYCSteps.fromJson(v));
      });
    }
    if (json['completedStepId'] != null) {
      completedStepId = <CompletedStepId>[];
      json['completedStepId'].forEach((v) {
        completedStepId!.add(CompletedStepId.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (steps != null) {
      data['steps'] = steps!.map((v) => v.toJson()).toList();
    }
    if (completedStepId != null) {
      data['completedStepId'] =
          completedStepId!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KYCSteps {
  int? id;
  String? stepName;
  String? label;
  int? rank;
  int? userType;
  String? userTypeName;
  int? entityType;
  String? entityTypeName;
  bool? isMandatory;
  bool? isSignup;

  KYCSteps(
      {this.id,
        this.stepName,
        this.label,
        this.rank,
        this.userType,
        this.userTypeName,
        this.entityType,
        this.entityTypeName,
        this.isMandatory,
        this.isSignup});

  KYCSteps.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stepName = json['stepName'];
    label = json['label'];
    rank = json['rank'];
    userType = json['userType'];
    userTypeName = json['userTypeName'];
    entityType = json['entityType'];
    entityTypeName = json['entityTypeName'];
    isMandatory = json['isMandatory'];
    isSignup = json['isSignup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stepName'] = stepName;
    data['label'] = label;
    data['rank'] = rank;
    data['userType'] = userType;
    data['userTypeName'] = userTypeName;
    data['entityType'] = entityType;
    data['entityTypeName'] = entityTypeName;
    data['isMandatory'] = isMandatory;
    data['isSignup'] = isSignup;
    return data;
  }
}

class CompletedStepId {
  int? step;

  CompletedStepId({this.step});

  CompletedStepId.fromJson(Map<String, dynamic> json) {
    step = json['step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['step'] = step;
    return data;
  }
}

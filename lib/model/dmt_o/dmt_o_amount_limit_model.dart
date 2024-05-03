class DmtOAmountLimitModel {
  int? id;
  String? name;
  int? userID;
  String? userName;
  bool? isUserWise;
  String? code;
  int? singleTransactionLowerLimit;
  int? singleTransactionUpperLimit;
  int? dailyTransactionLimit;
  int? monthlyTransactionLimit;
  int? dailyTxnsCount;
  int? monthlyTxnsCount;
  int? minimumAccountBalance;
  String? createdOn;
  String? modifiedOn;
  int? status;

  DmtOAmountLimitModel(
      {this.id,
        this.name,
        this.userID,
        this.userName,
        this.isUserWise,
        this.code,
        this.singleTransactionLowerLimit,
        this.singleTransactionUpperLimit,
        this.dailyTransactionLimit,
        this.monthlyTransactionLimit,
        this.dailyTxnsCount,
        this.monthlyTxnsCount,
        this.minimumAccountBalance,
        this.createdOn,
        this.modifiedOn,
        this.status});

  DmtOAmountLimitModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userID = json['userID'];
    userName = json['userName'];
    isUserWise = json['isUserWise'];
    code = json['code'];
    singleTransactionLowerLimit = json['singleTransactionLowerLimit'];
    singleTransactionUpperLimit = json['singleTransactionUpperLimit'];
    dailyTransactionLimit = json['dailyTransactionLimit'];
    monthlyTransactionLimit = json['monthlyTransactionLimit'];
    dailyTxnsCount = json['dailyTxnsCount'];
    monthlyTxnsCount = json['monthlyTxnsCount'];
    minimumAccountBalance = json['minimumAccountBalance'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['userID'] = userID;
    data['userName'] = userName;
    data['isUserWise'] = isUserWise;
    data['code'] = code;
    data['singleTransactionLowerLimit'] = singleTransactionLowerLimit;
    data['singleTransactionUpperLimit'] = singleTransactionUpperLimit;
    data['dailyTransactionLimit'] = dailyTransactionLimit;
    data['monthlyTransactionLimit'] = monthlyTransactionLimit;
    data['dailyTxnsCount'] = dailyTxnsCount;
    data['monthlyTxnsCount'] = monthlyTxnsCount;
    data['minimumAccountBalance'] = minimumAccountBalance;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['status'] = status;
    return data;
  }
}

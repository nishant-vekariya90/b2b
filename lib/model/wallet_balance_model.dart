class WalletBalanceModel {
  String? wallet1Balance;
  String? wallet1Name;
  String? wallet2Balance;
  String? wallet2Name;
  String? outstandingBalance;
  String? outstandingName;
  String? holdBalance;

  WalletBalanceModel({
    this.wallet1Balance,
    this.wallet1Name,
    this.wallet2Balance,
    this.wallet2Name,
    this.outstandingBalance,
    this.outstandingName,
    this.holdBalance,
  });

  WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    wallet1Balance = json['wallet1Balance'].toString();
    wallet1Name = json['wallet1Name'];
    wallet2Balance = json['wallet2Balance'].toString();
    wallet2Name = json['wallet2Name'];
    outstandingBalance = json['outstandingBalance'].toString();
    outstandingName = json['outstandingName'].toString();
    holdBalance = json['holdBalance'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wallet1Balance'] = wallet1Balance.toString();
    data['wallet1Name'] = wallet1Name.toString();
    data['wallet2Balance'] = wallet2Balance.toString();
    data['wallet2Name'] = wallet2Name.toString();
    data['outstandingBalance'] = outstandingBalance.toString();
    data['outstandingName'] = outstandingName.toString();
    data['holdBalance'] = holdBalance.toString();
    return data;
  }
}

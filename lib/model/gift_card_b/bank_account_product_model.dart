class BankAccountProductModel {
  int? statusCode;
  List<EligibleProductList>? eligibleProductList;
  String? message;

  BankAccountProductModel(
      {this.statusCode, this.eligibleProductList, this.message});

  BankAccountProductModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['eligibleProductList'] != null) {
      eligibleProductList = <EligibleProductList>[];
      json['eligibleProductList'].forEach((v) {
        eligibleProductList!.add(EligibleProductList.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    if (eligibleProductList != null) {
      data['eligibleProductList'] =
          eligibleProductList!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class EligibleProductList {
  int? productId;
  int? cardId;
  String? title;
  String? subTitle;
  String? logo;

  EligibleProductList({this.productId,this.cardId, this.title, this.subTitle, this.logo});

  EligibleProductList.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    cardId = json['cardId'];
    title = json['title'];
    subTitle = json['subTitle'];
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['title'] = title;
    data['subTitle'] = subTitle;
    data['logo'] = logo;
    return data;
  }
}

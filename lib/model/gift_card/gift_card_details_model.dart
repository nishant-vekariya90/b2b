class GiftCardDetailModel {
  int? statusCode;
  String? message;
  GiftCardDetailData? data;

  GiftCardDetailModel({this.statusCode, this.message, this.data});

  GiftCardDetailModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    data = json['data'] != null ? GiftCardDetailData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class GiftCardDetailData {
  String? brandName;
  String? code;
  String? image;
  Price? price;
  String? howToRedeem;
  String? txnType;
  String? redemptionMode;
  int? discount;
  String? thingsToRemember;
  int? id;
  String? tnc;

  GiftCardDetailData(
      {this.brandName,
        this.code,
        this.image,
        this.price,
        this.howToRedeem,
        this.txnType,
        this.redemptionMode,
        this.discount,
        this.thingsToRemember,
        this.id,
        this.tnc});

  GiftCardDetailData.fromJson(Map<String, dynamic> json) {
    brandName = json['brandName'];
    code = json['code'];
    image = json['image'];
    price = json['price'] != null ? Price.fromJson(json['price']) : null;
    howToRedeem = json['howToRedeem'];
    txnType = json['txnType'];
    redemptionMode = json['redemptionMode'];
    discount = json['discount'];
    thingsToRemember = json['thingsToRemember'];
    id = json['id'];
    tnc = json['tnc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brandName'] = brandName;
    data['code'] = code;
    data['image'] = image;
    if (price != null) {
      data['price'] = price!.toJson();
    }
    data['howToRedeem'] = howToRedeem;
    data['txnType'] = txnType;
    data['redemptionMode'] = redemptionMode;
    data['discount'] = discount;
    data['thingsToRemember'] = thingsToRemember;
    data['id'] = id;
    data['tnc'] = tnc;
    return data;
  }
}

class Price {
  int? max;
  int? min;

  Price({this.max, this.min});

  Price.fromJson(Map<String, dynamic> json) {
    max = json['max'];
    min = json['min'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['max'] = max;
    data['min'] = min;
    return data;
  }
}

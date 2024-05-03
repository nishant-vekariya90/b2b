class GiftCardModel {
  int? statusCode;
  String? message;
  int? totalRecords;
  String? pageSize;
  String? pageNumber;
  List<GiftCardsListModel>? data;

  GiftCardModel({
    this.statusCode,
    this.message,
    this.totalRecords,
    this.pageSize,
    this.pageNumber,
    this.data,
  });

  GiftCardModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    totalRecords = json['totalRecords'];
    pageSize = json['pageSize'];
    pageNumber = json['pageNumber'];
    if (json['data'] != null) {
      data = <GiftCardsListModel>[];
      json['data'].forEach((v) {
        data!.add(GiftCardsListModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['totalRecords'] = totalRecords;
    data['pageSize'] = pageSize;
    data['pageNumber'] = pageNumber;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GiftCardsListModel {
  int? id;
  String? brand;
  String? image;

  GiftCardsListModel({
    this.id,
    this.brand,
    this.image,
  });

  GiftCardsListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brand = json['brand'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brand'] = brand;
    data['image'] = image;
    return data;
  }
}

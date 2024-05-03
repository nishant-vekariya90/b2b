class MerchantCategoryModel {
  List<CategoryListModel>? merchantCategoryList;
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  String? prevPage;
  String? nextPage;

  MerchantCategoryModel({
    this.merchantCategoryList,
    this.totalDocs,
    this.limit,
    this.totalPages,
    this.page,
    this.pagingCounter,
    this.hasPrevPage,
    this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  MerchantCategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['docs'] != null) {
      merchantCategoryList = <CategoryListModel>[];
      json['docs'].forEach((v) {
        merchantCategoryList!.add(CategoryListModel.fromJson(v));
      });
    }
    totalDocs = json['totalDocs'];
    limit = json['limit'];
    totalPages = json['totalPages'];
    page = json['page'];
    pagingCounter = json['pagingCounter'];
    hasPrevPage = json['hasPrevPage'];
    hasNextPage = json['hasNextPage'];
    prevPage = json['prevPage'];
    nextPage = json['nextPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (merchantCategoryList != null) {
      data['docs'] = merchantCategoryList!.map((v) => v.toJson()).toList();
    }
    data['totalDocs'] = totalDocs;
    data['limit'] = limit;
    data['totalPages'] = totalPages;
    data['page'] = page;
    data['pagingCounter'] = pagingCounter;
    data['hasPrevPage'] = hasPrevPage;
    data['hasNextPage'] = hasNextPage;
    data['prevPage'] = prevPage;
    data['nextPage'] = nextPage;
    return data;
  }
}

class CategoryListModel {
  String? sId;
  String? code;
  String? description;
  String? id;

  CategoryListModel({this.sId, this.code, this.description, this.id});

  CategoryListModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    code = json['code'];
    description = json['description'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['code'] = code;
    data['description'] = description;
    data['id'] = id;
    return data;
  }
}

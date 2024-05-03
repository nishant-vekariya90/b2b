class AllProductModel {
  List<AllProductListModel>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  AllProductModel({
    this.data,
    this.pagination,
    this.message,
    this.statusCode,
  });

  AllProductModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AllProductListModel>[];
      json['data'].forEach((v) {
        data!.add(AllProductListModel.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    data['message'] = message;
    data['statusCode'] = statusCode;
    return data;
  }
}

class AllProductListModel {
  int? id;
  String? productId;
  String? unqId;
  String? name;
  String? shortDescription;
  String? tags;
  double? tax;
  String? originCountry;
  int? minQnty;
  int? maxQnty;
  int? deliverableType;
  String? deliverableZipCode;
  bool? isTaxIncluded;
  bool? isCOD;
  bool? isReturnable;
  bool? isCancellable;
  String? mainImage;
  String? subImage1;
  String? subImage2;
  String? subImage3;
  String? subImage4;
  String? subImage5;
  int? videoType;
  String? videoLink;
  String? description;
  int? availableUnits;
  String? brandName;
  int? brandID;
  String? thumbnailImage;
  double? price;
  double? salePrice;
  bool? isInStock;
  String? productSKU;
  bool? isDiscount;
  int? status;
  String? createdOn;
  String? modifiedOn;
  String? createdBy;
  String? modifiedBy;
  int? categoryID;
  String? categoryName;
  int? subCategoryID;
  String? subCategoryName;
  int? childCategoryID;
  String? childCategoryName;
  int? sellerID;
  String? sellerName;
  bool? isBestSeller;
  double? discount;

  AllProductListModel({
    this.id,
    this.productId,
    this.unqId,
    this.name,
    this.shortDescription,
    this.tags,
    this.tax,
    this.originCountry,
    this.minQnty,
    this.maxQnty,
    this.deliverableType,
    this.deliverableZipCode,
    this.isTaxIncluded,
    this.isCOD,
    this.isReturnable,
    this.isCancellable,
    this.mainImage,
    this.subImage1,
    this.subImage2,
    this.subImage3,
    this.subImage4,
    this.subImage5,
    this.videoType,
    this.videoLink,
    this.description,
    this.availableUnits,
    this.brandName,
    this.brandID,
    this.thumbnailImage,
    this.price,
    this.salePrice,
    this.isInStock,
    this.productSKU,
    this.isDiscount,
    this.status,
    this.createdOn,
    this.modifiedOn,
    this.createdBy,
    this.modifiedBy,
    this.categoryID,
    this.categoryName,
    this.subCategoryID,
    this.subCategoryName,
    this.childCategoryID,
    this.childCategoryName,
    this.sellerID,
    this.sellerName,
    this.isBestSeller,
    this.discount,
  });

  AllProductListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    unqId = json['unqId'];
    name = json['name'];
    shortDescription = json['shortDescription'];
    tags = json['tags'];
    tax = json['tax'];
    originCountry = json['originCountry'];
    minQnty = json['minQnty'];
    maxQnty = json['maxQnty'];
    deliverableType = json['deliverableType'];
    deliverableZipCode = json['deliverableZipCode'];
    isTaxIncluded = json['isTaxIncluded'];
    isCOD = json['isCOD'];
    isReturnable = json['isReturnable'];
    isCancellable = json['isCancellable'];
    mainImage = json['mainImage'];
    subImage1 = json['subImage1'];
    subImage2 = json['subImage2'];
    subImage3 = json['subImage3'];
    subImage4 = json['subImage4'];
    subImage5 = json['subImage5'];
    videoType = json['videoType'];
    videoLink = json['videoLink'];
    description = json['description'];
    availableUnits = json['availableUnits'];
    brandName = json['brandName'];
    brandID = json['brandID'];
    thumbnailImage = json['thumbnailImage'];
    price = json['price'];
    salePrice = json['salePrice'];
    isInStock = json['isInStock'];
    productSKU = json['productSKU'];
    isDiscount = json['isDiscount'];
    status = json['status'];
    createdOn = json['createdOn'];
    modifiedOn = json['modifiedOn'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    categoryID = json['categoryID'];
    categoryName = json['categoryName'];
    subCategoryID = json['subCategoryID'];
    subCategoryName = json['subCategoryName'];
    childCategoryID = json['childCategoryID'];
    childCategoryName = json['childCategoryName'];
    sellerID = json['sellerID'];
    sellerName = json['sellerName'];
    isBestSeller = json['isBestSeller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productId'] = productId;
    data['unqId'] = unqId;
    data['name'] = name;
    data['shortDescription'] = shortDescription;
    data['tags'] = tags;
    data['tax'] = tax;
    data['originCountry'] = originCountry;
    data['minQnty'] = minQnty;
    data['maxQnty'] = maxQnty;
    data['deliverableType'] = deliverableType;
    data['deliverableZipCode'] = deliverableZipCode;
    data['isTaxIncluded'] = isTaxIncluded;
    data['isCOD'] = isCOD;
    data['isReturnable'] = isReturnable;
    data['isCancellable'] = isCancellable;
    data['mainImage'] = mainImage;
    data['subImage1'] = subImage1;
    data['subImage2'] = subImage2;
    data['subImage3'] = subImage3;
    data['subImage4'] = subImage4;
    data['subImage5'] = subImage5;
    data['videoType'] = videoType;
    data['videoLink'] = videoLink;
    data['description'] = description;
    data['availableUnits'] = availableUnits;
    data['brandName'] = brandName;
    data['brandID'] = brandID;
    data['thumbnailImage'] = thumbnailImage;
    data['price'] = price;
    data['salePrice'] = salePrice;
    data['isInStock'] = isInStock;
    data['productSKU'] = productSKU;
    data['isDiscount'] = isDiscount;
    data['status'] = status;
    data['createdOn'] = createdOn;
    data['modifiedOn'] = modifiedOn;
    data['createdBy'] = createdBy;
    data['modifiedBy'] = modifiedBy;
    data['categoryID'] = categoryID;
    data['categoryName'] = categoryName;
    data['subCategoryID'] = subCategoryID;
    data['subCategoryName'] = subCategoryName;
    data['childCategoryID'] = childCategoryID;
    data['childCategoryName'] = childCategoryName;
    data['sellerID'] = sellerID;
    data['sellerName'] = sellerName;
    data['isBestSeller'] = isBestSeller;
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? pageSize;
  int? totalCount;
  bool? hasPrevious;
  bool? hasNext;

  Pagination({
    this.currentPage,
    this.totalPages,
    this.pageSize,
    this.totalCount,
    this.hasPrevious,
    this.hasNext,
  });

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    pageSize = json['pageSize'];
    totalCount = json['totalCount'];
    hasPrevious = json['hasPrevious'];
    hasNext = json['hasNext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['pageSize'] = pageSize;
    data['totalCount'] = totalCount;
    data['hasPrevious'] = hasPrevious;
    data['hasNext'] = hasNext;
    return data;
  }
}

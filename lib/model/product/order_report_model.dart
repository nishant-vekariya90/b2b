import 'package:get/get_rx/src/rx_types/rx_types.dart';

class OrderReportModel {
  List<OrderListData>? data;
  Pagination? pagination;
  String? message;
  int? statusCode;

  OrderReportModel({this.data, this.pagination, this.message, this.statusCode});

  OrderReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <OrderListData>[];
      json['data'].forEach((v) {
        data!.add(OrderListData.fromJson(v));
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

class OrderListData {
  int? id;
  String? orderID;
  String? unqId;
  int? userId;
  String? userName;
  int? seller;
  String? sellerName;
  int? productId;
  String? productName;
  int? quantity;
  double? total;
  String? date;
  String? paymentMethod;
  String? deliveryDate;
  int? status;
  String? itemDesc;
  String? name;
  String? email;
  String? contact;
  String? address;
  String? address2;
  String? houseNo;
  String? city;
  String? pincode;
  String? district;
  String? state;
  String? altContact;
  String? deliveryBy;
  double? tax;
  String? createdOn;
  String? createdBy;
  String? modifiedOn;
  String? modifiedBy;
  String? approvedOn;
  String? approvedBy;
  String? remark;
  int? categoryID;
  int? subCategoryID;
  int? childCategoryID;
  bool? isVisible;
  RxBool isShowMoreDetails = false.obs;

  OrderListData({
    this.id,
    this.orderID,
    this.unqId,
    this.userId,
    this.userName,
    this.seller,
    this.sellerName,
    this.productId,
    this.productName,
    this.quantity,
    this.total,
    this.date,
    this.paymentMethod,
    this.deliveryDate,
    this.status,
    this.itemDesc,
    this.name,
    this.email,
    this.contact,
    this.address,
    this.address2,
    this.houseNo,
    this.city,
    this.pincode,
    this.district,
    this.state,
    this.altContact,
    this.deliveryBy,
    this.tax,
    this.createdOn,
    this.createdBy,
    this.modifiedOn,
    this.modifiedBy,
    this.approvedOn,
    this.approvedBy,
    this.remark,
    this.categoryID,
    this.subCategoryID,
    this.childCategoryID,
    this.isVisible,
    required this.isShowMoreDetails,
  });

  OrderListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderID = json['orderID'];
    unqId = json['unqId'];
    userId = json['userId'];
    userName = json['userName'];
    seller = json['seller'];
    sellerName = json['sellerName'];
    productId = json['productId'];
    productName = json['productName'];
    quantity = json['quantity'];
    total = json['total'];
    date = json['date'];
    paymentMethod = json['paymentMethod'];
    deliveryDate = json['deliveryDate'];
    status = json['status'];
    itemDesc = json['itemDesc'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    address = json['address'];
    address2 = json['address2'];
    houseNo = json['houseNo'];
    city = json['city'];
    pincode = json['pincode'];
    district = json['district'];
    state = json['state'];
    altContact = json['altContact'];
    deliveryBy = json['deliveryBy'];
    tax = json['tax'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    modifiedOn = json['modifiedOn'];
    modifiedBy = json['modifiedBy'];
    approvedOn = json['approvedOn'];
    approvedBy = json['approvedBy'];
    remark = json['remark'];
    categoryID = json['categoryID'];
    subCategoryID = json['subCategoryID'];
    childCategoryID = json['childCategoryID'];
    isVisible = json['isVisible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['orderID'] = orderID;
    data['unqId'] = unqId;
    data['userId'] = userId;
    data['userName'] = userName;
    data['seller'] = seller;
    data['sellerName'] = sellerName;
    data['productId'] = productId;
    data['productName'] = productName;
    data['quantity'] = quantity;
    data['total'] = total;
    data['date'] = date;
    data['paymentMethod'] = paymentMethod;
    data['deliveryDate'] = deliveryDate;
    data['status'] = status;
    data['itemDesc'] = itemDesc;
    data['name'] = name;
    data['email'] = email;
    data['contact'] = contact;
    data['address'] = address;
    data['address2'] = address2;
    data['houseNo'] = houseNo;
    data['city'] = city;
    data['pincode'] = pincode;
    data['district'] = district;
    data['state'] = state;
    data['altContact'] = altContact;
    data['deliveryBy'] = deliveryBy;
    data['tax'] = tax;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['modifiedOn'] = modifiedOn;
    data['modifiedBy'] = modifiedBy;
    data['approvedOn'] = approvedOn;
    data['approvedBy'] = approvedBy;
    data['remark'] = remark;
    data['categoryID'] = categoryID;
    data['subCategoryID'] = subCategoryID;
    data['childCategoryID'] = childCategoryID;
    data['isVisible'] = isVisible;
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

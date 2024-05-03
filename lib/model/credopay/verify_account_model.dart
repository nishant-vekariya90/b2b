class VerifyAccountModel {
  List<AccountDetailsListModel>? accountDetailsList;
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  String? prevPage;
  String? nextPage;

  VerifyAccountModel(
      {this.accountDetailsList,
        this.totalDocs,
        this.limit,
        this.totalPages,
        this.page,
        this.pagingCounter,
        this.hasPrevPage,
        this.hasNextPage,
        this.prevPage,
        this.nextPage});

  VerifyAccountModel.fromJson(Map<String, dynamic> json) {
    if (json['docs'] != null) {
      accountDetailsList = <AccountDetailsListModel>[];
      json['docs'].forEach((v) {
        accountDetailsList!.add(AccountDetailsListModel.fromJson(v));
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
    if (accountDetailsList != null) {
      data['docs'] = accountDetailsList!.map((v) => v.toJson()).toList();
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

class AccountDetailsListModel {
  String? sId;
  String? ifsc;
  String? bank;
  String? branch;
  String? id;

  AccountDetailsListModel({this.sId, this.ifsc, this.bank, this.branch, this.id});

  AccountDetailsListModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    ifsc = json['ifsc'];
    bank = json['bank'];
    branch = json['branch'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['ifsc'] = ifsc;
    data['bank'] = bank;
    data['branch'] = branch;
    data['id'] = id;
    return data;
  }
}

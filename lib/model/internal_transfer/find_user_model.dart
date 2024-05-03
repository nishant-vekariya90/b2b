class FindUserNameModel {
  int? statusCode;
  String? message;
  int? userId;
  String? userName;
  String? name;
  int? userType;
  String? companyName;

  FindUserNameModel(
      {this.statusCode,
        this.message,
        this.userId,
        this.userName,
        this.name,
        this.userType,
        this.companyName});

  FindUserNameModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    userId = json['userId'];
    userName = json['userName'];
    name = json['name'];
    userType = json['userType'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['userId'] = userId;
    data['userName'] = userName;
    data['name'] = name;
    data['userType'] = userType;
    data['companyName'] = companyName;
    return data;
  }
}

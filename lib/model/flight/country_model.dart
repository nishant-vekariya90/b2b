class CountryModel {
  int? id;
  String? name;
  int? regionID;
  String? flag;
  String? phoneCode;
  String? regex;
  int? status;
  String? regionName;
  String? code;
  String? nationality;

  CountryModel({
    this.id,
    this.name,
    this.regionID,
    this.flag,
    this.phoneCode,
    this.regex,
    this.status,
    this.regionName,
    this.code,
    this.nationality,
  });

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    regionID = json['regionID'];
    flag = json['flag'];
    phoneCode = json['phoneCode'];
    regex = json['regex'];
    status = json['status'];
    regionName = json['regionName'];
    code = json['code'];
    nationality = json['nationality'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['regionID'] = regionID;
    data['flag'] = flag;
    data['phoneCode'] = phoneCode;
    data['regex'] = regex;
    data['status'] = status;
    data['regionName'] = regionName;
    data['code'] = code;
    data['nationality'] = nationality;
    return data;
  }
}

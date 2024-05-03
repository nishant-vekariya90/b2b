class BusInventoryItems {
  String? seatName;
  String? fare;
  String? ladiesSeat;
  String? address;
  String? age;
  String? email;
  String? gender;
  String? idNumber;
  String? idType;
  String? mobile;
  String? name;
  String? primary;
  String? title;

  BusInventoryItems(
      {this.seatName,
        this.fare,
        this.ladiesSeat,
        this.address,
        this.age,
        this.email,
        this.gender,
        this.idNumber,
        this.idType,
        this.mobile,
        this.name,
        this.primary,
        this.title});

  BusInventoryItems.fromJson(Map<String, dynamic> json) {
    seatName = json['seatName'];
    fare = json['fare'];
    ladiesSeat = json['ladiesSeat'];
    address = json['address'];
    age = json['age'];
    email = json['email'];
    gender = json['gender'];
    idNumber = json['idNumber'];
    idType = json['idType'];
    mobile = json['mobile'];
    name = json['name'];
    primary = json['primary'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seatName'] = seatName;
    data['fare'] = fare;
    data['ladiesSeat'] = ladiesSeat;
    data['address'] = address;
    data['age'] = age;
    data['email'] = email;
    data['gender'] = gender;
    data['idNumber'] = idNumber;
    data['idType'] = idType;
    data['mobile'] = mobile;
    data['name'] = name;
    data['primary'] = primary;
    data['title'] = title;
    return data;
  }
}

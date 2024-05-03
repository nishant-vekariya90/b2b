class BusBpDpDetailsModel {
  int? statusCode;
  String? message;
  List<BoardingPoints>? boardingPoints;
  List<BoardingPoints>? droppingPoints;

  BusBpDpDetailsModel(
      {this.statusCode,
        this.message,
        this.boardingPoints,
        this.droppingPoints});

  BusBpDpDetailsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['boardingPoints'] != null) {
      boardingPoints = <BoardingPoints>[];
      json['boardingPoints'].forEach((v) {
        boardingPoints!.add(BoardingPoints.fromJson(v));
      });
    }
    if (json['droppingPoints'] != null) {
      droppingPoints = <BoardingPoints>[];
      json['droppingPoints'].forEach((v) {
        droppingPoints!.add(BoardingPoints.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (boardingPoints != null) {
      data['boardingPoints'] =
          boardingPoints!.map((v) => v.toJson()).toList();
    }
    if (droppingPoints != null) {
      data['droppingPoints'] =
          droppingPoints!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BoardingPoints {
  int? id;
  String? name;
  String? address;
  String? landmark;
  String? contactNumber;
  String? locationName;
  int? rbMasterId;

  BoardingPoints(
      {this.id,
        this.name,
        this.address,
        this.landmark,
        this.contactNumber,
        this.locationName,
        this.rbMasterId});

  BoardingPoints.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    landmark = json['landmark'];
    contactNumber = json['contactNumber'];
    locationName = json['locationName'];
    rbMasterId = json['rbMasterId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['landmark'] = landmark;
    data['contactNumber'] = contactNumber;
    data['locationName'] = locationName;
    data['rbMasterId'] = rbMasterId;
    return data;
  }
}

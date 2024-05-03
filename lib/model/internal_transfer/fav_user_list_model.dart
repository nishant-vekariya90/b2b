class FavouriteUserListModel {
  int? id;
  int? userID;
  String? userName;
  String? createdOn;
  String? createdBy;
  int? favUserID;
  String? favUserName;
  bool? isFav;
  String? favUser;

  FavouriteUserListModel(
      {this.id,
        this.userID,
        this.userName,
        this.createdOn,
        this.createdBy,
        this.favUserID,
        this.favUserName,
        this.isFav,
        this.favUser});

  FavouriteUserListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userID = json['userID'];
    userName = json['userName'];
    createdOn = json['createdOn'];
    createdBy = json['createdBy'];
    favUserID = json['favUserID'];
    favUserName = json['favUserName'];
    isFav = json['isFav'];
    favUser = json['favUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userID'] = userID;
    data['userName'] = userName;
    data['createdOn'] = createdOn;
    data['createdBy'] = createdBy;
    data['favUserID'] = favUserID;
    data['favUserName'] = favUserName;
    data['isFav'] = isFav;
    data['favUser'] = favUser;
    return data;
  }
}

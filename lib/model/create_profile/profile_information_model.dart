class ProfileInformationModel {
  List<Profile>? profile;
  String? message;
  int? status;

  ProfileInformationModel({this.profile, this.message, this.status});

  ProfileInformationModel.fromJson(Map<String, dynamic> json) {
    if (json['profile'] != null) {
      profile = <Profile>[];
      json['profile'].forEach((v) {
        profile!.add(Profile.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (profile != null) {
      data['profile'] = profile!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

class Profile {
  int? id;
  String? name;
  int? userTypeID;
  String? userType;
  String? code;
  int? status;
  bool? isSignupProfile;
  int? userId;

  Profile(
      {this.id,
        this.name,
        this.userTypeID,
        this.userType,
        this.code,
        this.status,
        this.isSignupProfile,
        this.userId});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    userTypeID = json['userTypeID'];
    userType = json['userType'];
    code = json['code'];
    status = json['status'];
    isSignupProfile = json['isSignupProfile'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['userTypeID'] = userTypeID;
    data['userType'] = userType;
    data['code'] = code;
    data['status'] = status;
    data['isSignupProfile'] = isSignupProfile;
    data['userId'] = userId;
    return data;
  }
}

class OtherProductDetails {
  int? statusCode;
  String? title;
  String? subTitle;
  List<Attribute>? attribute;
  String? message;
  String? logo;

  OtherProductDetails({
    this.statusCode,
    this.title,
    this.subTitle,
    this.attribute,
    this.message,
    this.logo,
  });

  OtherProductDetails.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    title = json['title'];
    subTitle = json['subTitle'];
    if (json['attribute'] != null) {
      attribute = <Attribute>[];
      json['attribute'].forEach((v) {
        attribute!.add(Attribute.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['title'] = title;
    data['subTitle'] = subTitle;
    if (attribute != null) {
      data['attribute'] = attribute!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Attribute {
  String? tabName;
  List<Content>? content;

  Attribute({this.tabName, this.content});

  Attribute.fromJson(Map<String, dynamic> json) {
    tabName = json['tabName'];
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content!.add(Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tabName'] = tabName;
    if (content != null) {
      data['content'] = content!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Content {
  String? title;
  String? content;
  String? video;

  Content({this.title, this.content, this.video});

  Content.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
    video = json['video'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['content'] = content;
    data['video'] = video;
    return data;
  }
}

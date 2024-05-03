class CreditCardProductDetails {
  int? statusCode;
  String? cardName;
  String? bankLogo;
  String? annualCharges;
  String? joiningFees;
  List<Tabs>? tabs;
  String? mobileNo;
  String? message;

  CreditCardProductDetails(
      {this.statusCode,
        this.cardName,
        this.bankLogo,
        this.annualCharges,
        this.joiningFees,
        this.tabs,
        this.mobileNo,
        this.message});

  CreditCardProductDetails.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    cardName = json['cardName'];
    bankLogo = json['bankLogo'];
    annualCharges = json['annualCharges'];
    joiningFees = json['joiningFees'];
    if (json['tabs'] != null) {
      tabs = <Tabs>[];
      json['tabs'].forEach((v) {
        tabs!.add(Tabs.fromJson(v));
      });
    }
    mobileNo = json['mobileNo'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['cardName'] = cardName;
    data['bankLogo'] = bankLogo;
    data['annualCharges'] = annualCharges;
    data['joiningFees'] = joiningFees;
    if (tabs != null) {
      data['tabs'] = tabs!.map((v) => v.toJson()).toList();
    }
    data['mobileNo'] = mobileNo;
    data['message'] = message;
    return data;
  }
}

class Tabs {
  String? tabName;
  List<Content>? content;

  Tabs({this.tabName, this.content});

  Tabs.fromJson(Map<String, dynamic> json) {
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
  List<String>? content;
  String? video;

  Content({this.title, this.content, this.video});

  Content.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'].cast<String>();
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

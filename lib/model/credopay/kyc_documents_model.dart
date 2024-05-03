import 'dart:io';

import 'package:get/get.dart';

class KycDocumentsModel {
  List<IndividualData>? individual;
  List<ProprietorshipData>? proprietorship;
  List<PartnershipData>? partnership;
  List<PrivateData>? private;
  List<PublicData>? public;
  List<TrustData>? trust;
  List<PgData>? pg;

  KycDocumentsModel(
      {this.individual,
        this.proprietorship,
        this.partnership,
        this.private,
        this.public,
        this.trust,
        this.pg,
      });

  KycDocumentsModel.fromJson(Map<String, dynamic> json) {
    if (json['individual'] != null) {
      individual = <IndividualData>[];
      json['individual'].forEach((v) {
        individual!.add(IndividualData.fromJson(v));
      });
    }
    if (json['proprietorship'] != null) {
      proprietorship = <ProprietorshipData>[];
      json['proprietorship'].forEach((v) {
        proprietorship!.add(ProprietorshipData.fromJson(v));
      });
    }
    if (json['partnership'] != null) {
      partnership = <PartnershipData>[];
      json['partnership'].forEach((v) {
        partnership!.add(PartnershipData.fromJson(v));
      });
    }
    if (json['private'] != null) {
      private = <PrivateData>[];
      json['private'].forEach((v) {
        private!.add(PrivateData.fromJson(v));
      });
    }
    if (json['public'] != null) {
      public = <PublicData>[];
      json['public'].forEach((v) {
        public!.add(PublicData.fromJson(v));
      });
    }
    if (json['trust'] != null) {
      trust = <TrustData>[];
      json['trust'].forEach((v) {
        trust!.add(TrustData.fromJson(v));
      });
    }
    if (json['pg'] != null) {
      pg = <PgData>[];
      json['pg'].forEach((v) {
        pg!.add(PgData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (individual != null) {
      data['individual'] = individual!.map((v) => v.toJson()).toList();
    }
    if (proprietorship != null) {
      data['proprietorship'] =
          proprietorship!.map((v) => v.toJson()).toList();
    }
    if (partnership != null) {
      data['partnership'] = partnership!.map((v) => v.toJson()).toList();
    }
    if (private != null) {
      data['private'] = private!.map((v) => v.toJson()).toList();
    }
    if (public != null) {
      data['public'] = public!.map((v) => v.toJson()).toList();
    }
    if (trust != null) {
      data['trust'] = trust!.map((v) => v.toJson()).toList();
    }
    if (pg != null) {
      data['pg'] = pg!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class IndividualData {
  int? type;
  String? name;
  bool? required;
  Rx<File> file = File('').obs;

  IndividualData({this.type, this.name, this.required,required this.file});

  IndividualData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    required = json['required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['required'] = required;
    return data;
  }
}
class ProprietorshipData {
  int? type;
  String? name;
  bool? required;
  Rx<File> file = File('').obs;

  ProprietorshipData({this.type, this.name, this.required});

  ProprietorshipData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    required = json['required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['required'] = required;
    return data;
  }
}
class PartnershipData {
  int? type;
  String? name;
  bool? required;
  Rx<File> file = File('').obs;


  PartnershipData({this.type, this.name, this.required});

  PartnershipData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    required = json['required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['required'] = required;
    return data;
  }
}
class PrivateData {
  int? type;
  String? name;
  bool? required;
  Rx<File> file = File('').obs;

  PrivateData({this.type, this.name, this.required});

  PrivateData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    required = json['required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['required'] = required;
    return data;
  }
}
class PublicData {
  int? type;
  String? name;
  bool? required;
  Rx<File> file = File('').obs;


  PublicData({this.type, this.name, this.required});

  PublicData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    required = json['required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['required'] = required;
    return data;
  }
}
class TrustData {
  int? type;
  String? name;
  bool? required;
  Rx<File> file = File('').obs;


  TrustData({this.type, this.name, this.required});

  TrustData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    required = json['required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['required'] = required;
    return data;
  }
}
class PgData {
  int? type;
  String? name;
  bool? required;
  Rx<File> file = File('').obs;


  PgData({this.type, this.name, this.required});

  PgData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    required = json['required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['required'] = required;
    return data;
  }
}

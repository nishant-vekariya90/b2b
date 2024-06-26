class AgentPerformanceModel {
  List<AgentPerformanceData>? data;
  String? message;
  int? statusCode;

  AgentPerformanceModel({this.data, this.message, this.statusCode});

  AgentPerformanceModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AgentPerformanceData>[];
      json['data'].forEach((v) {
        data!.add(AgentPerformanceData.fromJson(v));
      });
    }
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    data['statusCode'] = statusCode;
    return data;
  }
}

class AgentPerformanceData {
  String? serviceType;
  double? totalVolume;
  int? totalTransactionCount;
  double? totalSuccessVolume;
  int? totalSuccessTransactionCount;
  double? totalFailedVolume;
  int? totalFailedTransactionCount;
  double? totalPendingVolume;
  int? totalPendingTransactionCount;

  AgentPerformanceData(
      {this.serviceType,
        this.totalVolume,
        this.totalTransactionCount,
        this.totalSuccessVolume,
        this.totalSuccessTransactionCount,
        this.totalFailedVolume,
        this.totalFailedTransactionCount,
        this.totalPendingVolume,
        this.totalPendingTransactionCount});

  AgentPerformanceData.fromJson(Map<String, dynamic> json) {
    serviceType = json['serviceType'];
    totalVolume = json['totalVolume'];
    totalTransactionCount = json['totalTransactionCount'];
    totalSuccessVolume = json['totalSuccessVolume'];
    totalSuccessTransactionCount = json['totalSuccessTransactionCount'];
    totalFailedVolume = json['totalFailedVolume'];
    totalFailedTransactionCount = json['totalFailedTransactionCount'];
    totalPendingVolume = json['totalPendingVolume'];
    totalPendingTransactionCount = json['totalPendingTransactionCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceType'] = serviceType;
    data['totalVolume'] = totalVolume;
    data['totalTransactionCount'] = totalTransactionCount;
    data['totalSuccessVolume'] = totalSuccessVolume;
    data['totalSuccessTransactionCount'] = totalSuccessTransactionCount;
    data['totalFailedVolume'] = totalFailedVolume;
    data['totalFailedTransactionCount'] = totalFailedTransactionCount;
    data['totalPendingVolume'] = totalPendingVolume;
    data['totalPendingTransactionCount'] = totalPendingTransactionCount;
    return data;
  }
}

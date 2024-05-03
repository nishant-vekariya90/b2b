import '../api/api_manager.dart';
import '../model/receipt_model.dart';
import '../utils/string_constants.dart';

class ReceiptRepository {
  final APIManager apiManager;
  ReceiptRepository(this.apiManager);

  // Get receipt api call
  Future<ReceiptModel> getReceiptApiCall({required String transactionId, required int type, required String design, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/receipt/generate-receipt?Tid=$transactionId&Type=$type&Design=$design',
      isLoaderShow: isLoaderShow,
    );
    var response = ReceiptModel.fromJson(jsonData);
    return response;
  }

  // Get receipt for balance enquiry api call
  Future<ReceiptModel> getReceiptForBalanceEnquiryApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/receipt/generate-balinquiry-receipt',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ReceiptModel.fromJson(jsonData);
    return response;
  }

  // Get receipt api call
  Future<ReceiptModel> getReceiptForMiniStatementApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/receipt/generate-aepsmini-receipt',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ReceiptModel.fromJson(jsonData);
    return response;
  }

  // Get receipt api call
  Future<ReceiptModel> getFlightReceiptApiCall({required String orderId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/receipt/generate-onewayflight-receipt?OrderId=$orderId',
      params: {},
      isLoaderShow: isLoaderShow,
    );
    var response = ReceiptModel.fromJson(jsonData);
    return response;
  }

  // Get receipt api call
  Future<ReceiptModel> getBusReceiptApiCall({required String orderId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/receipt/generate-bus-receipt?OrderId=$orderId',
      params: {},
      isLoaderShow: isLoaderShow,
    );
    var response = ReceiptModel.fromJson(jsonData);
    return response;
  }
}

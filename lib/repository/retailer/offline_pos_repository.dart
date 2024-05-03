import 'dart:io';
import '../../api/api_manager.dart';
import '../../model/offline_pos/offline_pos_order_create_model.dart';
import '../../model/offline_pos/offline_pos_report_model.dart';
import '../../utils/string_constants.dart';

class OfflinePosRepository {
  final APIManager apiManager;
  OfflinePosRepository(this.apiManager);

  // Offline pos order create api call
  Future<OfflinePosOrderCreateModel> offlinePosOrderCreateApiCall({required var params, required String fileKey, required File file, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.multipartAPICall(
      url: '${baseUrl}transaction/api/transaction-module/matm/POS-Orders-Create',
      params: params,
      fileKey: fileKey,
      file: file,
      isLoaderShow: isLoaderShow,
    );
    var response = OfflinePosOrderCreateModel.fromJson(jsonData);
    return response;
  }

  // Get offline pos report
  Future<OfflinePosReportModel> getOfflinePosReportApiCall({required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/transactionpaymentstatus/list-user-wise?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = OfflinePosReportModel.fromJson(jsonData);
    return response;
  }
}

import '../../api/api_manager.dart';
import '../../model/scan_and_pay/scan_and_pay_model.dart';
import '../../utils/string_constants.dart';

class ScanAndPayRepository {
  final APIManager apiManager;
  ScanAndPayRepository(this.apiManager);

  // Scan and pay api call
  Future<ScanAndPayModel> scanAndPayApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/scanpay/scanpay-request',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ScanAndPayModel.fromJson(jsonData);
    return response;
  }
}

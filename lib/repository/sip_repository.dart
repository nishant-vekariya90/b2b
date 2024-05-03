import '../api/api_manager.dart';
import '../model/sip/axis_sip_model.dart';
import '../utils/string_constants.dart';

class SipRepository{
  final APIManager apiManager;
  SipRepository(this.apiManager);


  // Axis SIP api call
  Future<AxisSipModel> axisSipApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/sip/sip-axis',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AxisSipModel.fromJson(jsonData);
    return response;
  }
}
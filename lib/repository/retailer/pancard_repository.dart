import '../../api/api_manager.dart';
import '../../model/pancard/pancard_model.dart';
import '../../utils/string_constants.dart';

class PancardRepository {
  final APIManager apiManager;
  PancardRepository(this.apiManager);

  // Pancard api
  Future<PancardModel> pancardApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/pancard',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = PancardModel.fromJson(jsonData);
    return response;
  }
}

import '../../api/api_manager.dart';
import '../../model/cms/cms_model.dart';
import '../../utils/string_constants.dart';

class CmsRepository {
  final APIManager apiManager;
  CmsRepository(this.apiManager);

  // Cms api
  Future<CmsModel> cmsApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/cms/generate-url',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = CmsModel.fromJson(jsonData);
    return response;
  }
}

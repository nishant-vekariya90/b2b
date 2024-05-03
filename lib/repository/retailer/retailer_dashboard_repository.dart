import '../../api/api_manager.dart';
import '../../model/auth/latest_version_model.dart';
import '../../model/auth/user_basic_details_model.dart';
import '../../model/category_for_tpin_model.dart';
import '../../model/news_model.dart';
import '../../model/operation_model.dart';
import '../../model/success_model.dart';
import '../../model/wallet_balance_model.dart';
import '../../model/website_content_model.dart';
import '../../utils/string_constants.dart';

class RetailerDashboardRepository {
  final APIManager apiManager;
  RetailerDashboardRepository(this.apiManager);

  // Get latest version
  Future<GetLatestVersionModel> getLatestVersionApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/appupdate',
      isLoaderShow: isLoaderShow,
    );
    var response = GetLatestVersionModel.fromJson(jsonData);
    return response;
  }

  // Get wallet balance api call
  Future<WalletBalanceModel> getWalletBalanceApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/wallet-balance',
      isLoaderShow: isLoaderShow,
    );
    var response = WalletBalanceModel.fromJson(jsonData);
    return response;
  }

  // Change profile picture
  Future<SuccessModel> changeProfilePictureApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/upload-profile',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = SuccessModel.fromJson(jsonData);
    return response;
  }

  // Get basic details  api
  Future<UserBasicDetailsModel> userBasicDetailsApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/user-basic-details',
      isLoaderShow: isLoaderShow,
    );
    var response = UserBasicDetailsModel.fromJson(jsonData);
    return response;
  }

  // Get website content api call
  Future<List<WebsiteContentModel>> getWebsiteContentApiCall({required int contentType, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/websitecontent/Websitecontent-name?TenantId=$tenantId&Type=$contentType',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<WebsiteContentModel> objects = response.map((e) => WebsiteContentModel.fromJson(e)).toList();
    return objects;
  }

  // Get category for tpin api call
  Future<List<CategoryForTpinModel>> getCategoryForTpinApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/service-configurations/category',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<CategoryForTpinModel> objects = response.map((e) => CategoryForTpinModel.fromJson(e)).toList();
    return objects;
  }

  // Get operation  api call
  Future<List<OperationModel>> getOperationApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/Operations/user-operation-auth?Channel=$channelID',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<OperationModel> objects = response.map((e) => OperationModel.fromJson(e)).toList();
    return objects;
  }

  // Get news api call
  Future<List<NewsModel>> getNewsApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/new-Api/settingsnews/user-type-list-news',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<NewsModel> objects = response.map((e) => NewsModel.fromJson(e)).toList();
    return objects;
  }
}

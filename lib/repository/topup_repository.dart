import '../api/api_manager.dart';
import '../model/master/bank_list_model.dart';
import '../model/topup/topup_history_model.dart';
import '../model/topup/topup_request_model.dart';
import '../utils/string_constants.dart';

class TopupRepository {
  final APIManager apiManager;
  TopupRepository(this.apiManager);

  // Check parent api call
  Future<List<String>> checkParentApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/check-parent',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<String> objects = response.map((e) => e.toString()).toList();
    return objects;
  }

  // Get bank list by user api call
  Future<List<MasterBankListModel>> getBankListByUserApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/banks/Bankdata-By-User',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<MasterBankListModel> objects = response.map((e) => MasterBankListModel.fromJson(e)).toList();
    return objects;
  }

  // Get bank list by admin api call
  Future<List<MasterBankListModel>> getBankListByAdminApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/banks/Bankdata-By-Admin',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<MasterBankListModel> objects = response.map((e) => MasterBankListModel.fromJson(e)).toList();
    return objects;
  }

  // Topup request api call
  Future<TopupRequestModel> topupRequestApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/reportPayment',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = TopupRequestModel.fromJson(jsonData);
    return response;
  }

  // Get topup history api call
  Future<TopupHistoryModel> getTopupHistoryApiCall({required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/reportPayment/userwise?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = TopupHistoryModel.fromJson(jsonData);
    return response;
  }
}

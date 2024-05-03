import '../../api/api_manager.dart';
import '../../model/master/circle_list_model.dart';
import '../../model/master/operator_list_model.dart';
import '../../model/recharge_and_biils/recharge_model.dart';
import '../../model/recharge_and_biils/operator_fetch_model.dart';
import '../../model/recharge_and_biils/m_plans_model.dart';
import '../../model/recharge_and_biils/r_plans_model.dart';
import '../../utils/string_constants.dart';

class RechargeRepository {
  final APIManager apiManager;
  RechargeRepository(this.apiManager);

  ///////////////////////
  /// Mobile Recharge ///
  ///////////////////////

  // Get master operator list api call
  Future<List<MasterOperatorListModel>> getMasterOperatorListApiCall({required String operator, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/service-configurations/operator/operators-servicecode/$operator',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<MasterOperatorListModel> objects = response.map((e) => MasterOperatorListModel.fromJson(e)).toList();
    return objects;
  }

  // Get master circle list api call
  Future<List<MasterCircleListModel>> getMasterCircleListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/new-Api/circle',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<MasterCircleListModel> objects = response.map((e) => MasterCircleListModel.fromJson(e)).toList();
    return objects;
  }

  // Get operator fetch api call
  Future<OperatorFetchModel> getOperatorFetchApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/RechargePlan/operator-fetch',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = OperatorFetchModel.fromJson(jsonData);
    return response;
  }

  // Get m plans api call
  Future<MPlansModel> getMPlansApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/RechargePlan/operator-plans',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = MPlansModel.fromJson(jsonData);
    return response;
  }

  // Get r plans api call
  Future<RPlansModel> getRPlansApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/RechargePlan/operator-roffers',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = RPlansModel.fromJson(jsonData);
    return response;
  }

  // Recharge api call
  Future<RechargeModel> rechargeApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/Recharge',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = RechargeModel.fromJson(jsonData);
    return response;
  }
}

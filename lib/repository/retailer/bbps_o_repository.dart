import '../../model/bbps/bbps_category_list_model.dart';
import '../../model/bbps/bbps_operator_grouping_list_model.dart';
import '../../model/bbps/bbps_parameters_list_model.dart';
import '../../model/bbps/bbps_sub_category_list_model.dart';
import '../../model/bbps/bill_payment_model.dart';
import '../../../api/api_manager.dart';
import '../../../utils/string_constants.dart';
import '../../model/bbps/fetch_bill_model.dart';

class BbpsORepository {
  final APIManager apiManager;
  BbpsORepository(this.apiManager);

  // Get bbps category list api call
  Future<List<BbpsCategoryListModel>> getBbpsCategory({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/service-configurations/service/bbps-off',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<BbpsCategoryListModel> objects = response.map((e) => BbpsCategoryListModel.fromJson(e)).toList();
    return objects;
  }

  // Get bbps sub category list api call
  Future<List<BbpsSubCategoryListModel>> getBbpsSubCategory({required int id, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/service-configurations/operator/bbps-service/$id',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<BbpsSubCategoryListModel> objects = response.map((e) => BbpsSubCategoryListModel.fromJson(e)).toList();
    return objects;
  }

  // Get bbps parameters list api call
  Future<List<BbpsParametersListModel>> getBbpsFieldList({required int id, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/service-configurations/operatorParameters/bbps-operator/$id',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<BbpsParametersListModel> objects = response.map((e) => BbpsParametersListModel.fromJson(e)).toList();
    return objects;
  }

  // Get master bbps sub service list api call
  Future<List<BbpsOperatorGroupingListModel>> getMasterBbpsOperatorGrouping({required int operatorId, required int operatorParamId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/service-configurations/operatorGrouping?OperatorId=$operatorId&OperatorParameterId=$operatorParamId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<BbpsOperatorGroupingListModel> objects = response.map((e) => BbpsOperatorGroupingListModel.fromJson(e)).toList();
    return objects;
  }

  // Fetch bill details api call
  Future<FetchBillModel> fetchBillDetails({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/BBPS/bill-fetch',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FetchBillModel.fromJson(jsonData);
    return response;
  }

  // Fetch bill details api call
  Future<BillPaymentModel> getPayBbpsBill({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/BBPS/bill-payment',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = BillPaymentModel.fromJson(jsonData);
    return response;
  }
}

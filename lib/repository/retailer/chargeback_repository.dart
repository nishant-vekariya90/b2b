import '../../api/api_manager.dart';
import '../../model/chargeback/chargeback_doc_model.dart';
import '../../model/chargeback/chargeback_raised_model.dart';
import '../../model/success_model.dart';
import '../../utils/string_constants.dart';

class ChargebackRepository {
  final APIManager apiManager;
  ChargebackRepository(this.apiManager);

  //Get Chargeback Raised Model
  Future<ChargebackRaisedModel> getChargebackRaisedApiCall({required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url:'${baseUrl}masterdata/api/master-module/chargeback/raised-list?PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = ChargebackRaisedModel.fromJson(jsonData);
    return response;
  }

  // Get login report
  Future<ChargebackRaisedModel> getChargebackHistoryApiCall({required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/chargeback/user-wise-list?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = ChargebackRaisedModel.fromJson(jsonData);
    return response;
  }

 //Get Chargeback Docs Model
  Future<List<ChargebackDocModel>> getChargebackDocApiCall({required String uniqueId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url:'${baseUrl}masterdata/api/master-module/chargebackdocuments/raised-revision-list?UniqueId=$uniqueId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<ChargebackDocModel> object = response.map((e) => ChargebackDocModel.fromJson(e)).toList();
    return object;
  }


  // Upload / Update Documents
  Future<SuccessModel> uploadDocsApiCall({required List<dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.putAPICall(
      url: '${baseUrl}masterdata/api/master-module/chargebackdocuments',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = SuccessModel.fromJson(jsonData);
    return response;
  }
}
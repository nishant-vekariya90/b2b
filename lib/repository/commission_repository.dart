import '../api/api_manager.dart';
import '../model/commission/commission_model.dart';
import '../utils/string_constants.dart';

class CommissionRepository {
  final APIManager apiManager;
  CommissionRepository(this.apiManager);

  // Get user type api call
  Future<CommissionModel> getCommissionApiCall({String? searchOperatorName, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: searchOperatorName == null
          ? '${baseUrl}masterdata/api/master-module/profilefees/profile-fee-details?PageNumber=$pageNumber&PageSize=10'
          : '${baseUrl}masterdata/api/master-module/profilefees/profile-fee-details?OperatorName=$searchOperatorName&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = CommissionModel.fromJson(jsonData);
    return response;
  }
}

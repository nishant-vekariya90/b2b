import '../../api/api_manager.dart';
import '../../model/auth/user_type_model.dart';
import '../../model/credit_debit/debit_history_model.dart';
import '../../model/credit_debit/user_list_model.dart';
import '../../model/credit_debit/wallet_model.dart';
import '../../model/credit_debit/wallet_type_model.dart';
import '../../utils/string_constants.dart';

class CreditDebitRepository {
  final APIManager apiManager;
  CreditDebitRepository(this.apiManager);

  // Get user type api call
  Future<List<UserTypeModel>> getUserTypeApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/user-module/usertypes/${getStoredUserBasicDetails().userTypeID}',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<UserTypeModel> objects = response.map((e) => UserTypeModel.fromJson(e)).toList();
    return objects;
  }

  // Get user list via user type api call
  Future<UserListModel> getUserListVaiUserTypeApiCall({String? userTypeId, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/dis-users?UserTypeId=$userTypeId&PageNumber=$pageNumber&PageSize=20',
      isLoaderShow: isLoaderShow,
    );
    var response = UserListModel.fromJson(jsonData);
    return response;
  }

  // Search user list via user type api call
  Future<UserListModel> searchUserListVaiUserTypeApiCall({required String text, required String userTypeId, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/dis-users?SearchUserName=$text&UserTypeId=$userTypeId&PageNumber=$pageNumber&PageSize=20',
      isLoaderShow: isLoaderShow,
    );
    var response = UserListModel.fromJson(jsonData);
    return response;
  }

  // Get wallet type api call
  Future<List<WalletTypeModel>> getWalletTypeApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/new-Api/walletData',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<WalletTypeModel> objects = response.map((e) => WalletTypeModel.fromJson(e)).toList();
    return objects;
  }

  // Credit debit wallet api call
  Future<CreditDebitWalletModel> creditDebitWalletApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/Wallet',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = CreditDebitWalletModel.fromJson(jsonData);
    return response;
  }

  // Credit debit history
  Future<CreditDebitHistoryModel> getCreditDebitHistoryApiCall({required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '$baseUrl/masterdata/api/master-module/transactiondebitrequest/debit-transaction?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=20',
      isLoaderShow: isLoaderShow,
    );
    var response = CreditDebitHistoryModel.fromJson(jsonData);
    return response;
  }

  // Outstanding collection api
  Future<CreditDebitWalletModel> outstandingApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/Wallet/outStanding-collection',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = CreditDebitWalletModel.fromJson(jsonData);
    return response;
  }
}

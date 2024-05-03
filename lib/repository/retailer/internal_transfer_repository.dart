import '../../api/api_manager.dart';
import '../../model/internal_transfer/add_fav_model.dart';
import '../../model/internal_transfer/fav_user_list_model.dart';
import '../../model/internal_transfer/find_user_model.dart';
import '../../model/internal_transfer/remove_fav_user_model.dart';
import '../../utils/string_constants.dart';
import '../../model/internal_transfer/internal_transfer_model.dart';
import '../../model/internal_transfer/validate_username.dart';

class InternalTransferRepository {
  final APIManager apiManager;
  InternalTransferRepository(this.apiManager);

  // Validate username api
  Future<ValidateUsernameModel> validateUsernameApiCall({bool isLoaderShow = true, required var username}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/find-via-username?UserName=$username',
      isLoaderShow: isLoaderShow,
    );
    var response = ValidateUsernameModel.fromJson(jsonData);
    return response;
  }

  // Internal-transfer api
  Future<InternalTransferModel> internalTransferApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/Wallet/internal-transfer',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = InternalTransferModel.fromJson(jsonData);
    return response;
  }

  // Confirm-internal-transfer api
  Future<InternalTransferModel> confirmInternalTransferApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/Wallet/confirm-internal-transfer',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = InternalTransferModel.fromJson(jsonData);
    return response;
  }

  // Add-Favourite api
  Future<AddFavouriteModel> addFavouriteApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/walletfavwallets',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = AddFavouriteModel.fromJson(jsonData);
    return response;
  }

  // Get FavUser List api
  Future<List<FavouriteUserListModel>> favUserListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/walletfavwallets',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<FavouriteUserListModel> objects = response.map((e) => FavouriteUserListModel.fromJson(e)).toList();
    return objects;
  }

  // Update profile api
  Future<RemoveFavouriteModel> removeFavUserApiCall({bool isLoaderShow = true, required int id}) async {
    var jsonData = await apiManager.putAPICall(
      url: '${baseUrl}masterdata/api/master-module/walletfavwallets/remove-favourite/$id',
      isLoaderShow: isLoaderShow,
      params: {},
    );
    var response = RemoveFavouriteModel.fromJson(jsonData);
    return response;
  }

  // Fing username api
  Future<FindUserNameModel> findUsernameApiCall({bool isLoaderShow = true, required var username}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/find-via-username?UserName=$username',
      isLoaderShow: isLoaderShow,
    );
    var response = FindUserNameModel.fromJson(jsonData);
    return response;
  }
}

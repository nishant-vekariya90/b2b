import '../../api/api_manager.dart';
import '../../model/auth/user_type_model.dart';
import '../../model/view_user_model.dart';
import '../../utils/string_constants.dart';

class ViewUserRepository {
  final APIManager apiManager;
  ViewUserRepository(this.apiManager);

  // Get user type list
  Future<List<UserTypeModel>> userTypeApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/user-module/usertypes/${getStoredUserBasicDetails().userTypeID}',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<UserTypeModel> objects = response.map((jsonMap) => UserTypeModel.fromJson(jsonMap)).toList();
    return objects;
  }

  // Get view user
  Future<ViewUserModel> viewUserApiCall({String? username, String? userTypeId, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url:
          "${baseUrl}authentication/api/authentication-module/Account/dis-users?${username != null && username.isNotEmpty ? 'SearchUserName=$username&' : ''}${userTypeId != null && userTypeId.isNotEmpty ? 'UserTypeId=$userTypeId&' : ''}PageNumber=$pageNumber&PageSize=20",
      isLoaderShow: isLoaderShow,
    );
    var response = ViewUserModel.fromJson(jsonData);
    return response;
  }

  // Get view child user
  Future<ViewUserModel> viewChildUserApiCall({required String uniqueId, String? username, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url:
          "${baseUrl}authentication/api/authentication-module/Account/child-user-of-parent-from-userid?Referenceid=$uniqueId&${username != null && username.isNotEmpty ? 'SearchUserName=$username&' : ''}PageNumber=$pageNumber&PageSize=20",
      isLoaderShow: isLoaderShow,
    );
    var response = ViewUserModel.fromJson(jsonData);
    return response;
  }
}

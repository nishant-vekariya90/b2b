import '../../model/success_model.dart';
import '../../api/api_manager.dart';
import '../../model/create_profile/create_profile_model.dart';
import '../../model/create_profile/profile_information_model.dart';
import '../../model/create_profile/update_profile_model.dart';
import '../../utils/string_constants.dart';

class ProfileRepository {
  final APIManager apiManager;
  ProfileRepository(this.apiManager);

  // Create profile
  Future<CreateProfileModel> createProfileApiCall({bool isLoaderShow = true, required var params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/profiles/Profile_Creation',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = CreateProfileModel.fromJson(jsonData);
    return response;
  }

  // Update profile
  Future<UpdateProfileModel> updateProfileApiCall({bool isLoaderShow = true, required var params, required int id}) async {
    var jsonData = await apiManager.putAPICall(
      url: '${baseUrl}masterdata/api/master-module/profiles/user-wise/$id',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = UpdateProfileModel.fromJson(jsonData);
    return response;
  }

  // Status update
  Future<SuccessModel> updateStatusApiCall({bool isLoaderShow = true, required var params, required int id}) async {
    var jsonData = await apiManager.putAPICall(
      url: '${baseUrl}masterdata/api/master-module/profiles/status-update/$id',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = SuccessModel.fromJson(jsonData);
    return response;
  }

  // Profile information
  Future<ProfileInformationModel> profileInformationApiCall({bool isLoaderShow = true, required String selectedUserTypeId}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/profiles/user-wise-profile?UserTypeId=$selectedUserTypeId&channels=$channelID',
      isLoaderShow: isLoaderShow,
    );
    var response = ProfileInformationModel.fromJson(jsonData);
    return response;
  }
}

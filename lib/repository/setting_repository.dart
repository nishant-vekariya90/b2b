import '../api/api_manager.dart';
import '../model/dispute_category_model.dart';
import '../model/dispute_child_category_model.dart';
import '../model/dispute_sub_category_model.dart';
import '../model/id_card_model.dart';
import '../model/setting/change_password_tpin_model.dart';
import '../model/report/login_report_model.dart';
import '../model/report/raised_ticket_model.dart';
import '../model/website_content_model.dart';
import '../utils/string_constants.dart';

class SettingRepository {
  final APIManager apiManager;
  SettingRepository(this.apiManager);

  // Change password api
  Future<ChangePasswordTPINModel> changePasswordApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/change-password',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ChangePasswordTPINModel.fromJson(jsonData);
    return response;
  }

  // Confirm change password
  Future<ChangePasswordTPINModel> changePasswordConfirmApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/change-password-confirm',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ChangePasswordTPINModel.fromJson(jsonData);
    return response;
  }

  // Change TPIN api
  Future<ChangePasswordTPINModel> changeTPINApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/change-tpin',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ChangePasswordTPINModel.fromJson(jsonData);
    return response;
  }

  // Forgot TPIN api
  Future<ChangePasswordTPINModel> forgotTPINApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/forget-tpin',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ChangePasswordTPINModel.fromJson(jsonData);
    return response;
  }

  // Confirm TPIN password
  Future<ChangePasswordTPINModel> changeTPINConfirmApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/change-tpin-confirm',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ChangePasswordTPINModel.fromJson(jsonData);
    return response;
  }

  // Confirm forgot TPIN
  Future<ChangePasswordTPINModel> forgotTPINConfirmApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/forget-tpin-confirm',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ChangePasswordTPINModel.fromJson(jsonData);
    return response;
  }

  // Get login report
  Future<LoginReportModel> loginReportApiCall({required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/loginhistorylogs/userwise?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = LoginReportModel.fromJson(jsonData);
    return response;
  }

  // Raised complaint
  Future<RaisedTicketModel> raisedComplaintApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/tableticket',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = RaisedTicketModel.fromJson(jsonData);
    return response;
  }

  // Get category list api call
  Future<List<DisputeCategoryModel>> getDisputeCategoryApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/disputecategory/user-type-wise',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<DisputeCategoryModel> objects = response.map((e) => DisputeCategoryModel.fromJson(e)).toList();
    return objects;
  }

  // Get category list api call
  Future<List<DisputeChildCategoryModel>> getDisputeChildCategoryApiCall({required int disputeSubCategoryId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/disputechildcategory?DisputeSubcategoryId=$disputeSubCategoryId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<DisputeChildCategoryModel> objects = response.map((e) => DisputeChildCategoryModel.fromJson(e)).toList();
    return objects;
  }

  // Get sub category api call
  Future<List<DisputeSubCategoryModel>> getDisputeSubCategoryApiCall({required int disputeCategoryId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/disputesubcategory?DisputeCategoryId=$disputeCategoryId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<DisputeSubCategoryModel> objects = response.map((e) => DisputeSubCategoryModel.fromJson(e)).toList();
    return objects;
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

  // Get Id Card api call
  Future<List<IdCardModel>> getIdCardApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/certificate',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<IdCardModel> objects = response.map((e) => IdCardModel.fromJson(e)).toList();
    return objects;
  }
}

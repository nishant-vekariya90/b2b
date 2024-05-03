import '../../api/api_manager.dart';
import '../../model/offline_token/show_password_otp_model.dart';
import '../../model/offline_token/offline_token_credentials_model.dart';
import '../../model/offline_token/offline_token_order_request_model.dart';
import '../../model/offline_token/validate_show_password_otp_model.dart';
import '../../model/product/all_product_model.dart';
import '../../model/product/order_report_model.dart';
import '../../model/product/product_child_category_model.dart';
import '../../model/product/product_main_category_model.dart';
import '../../model/product/product_sub_category_model.dart';
import '../../model/success_model.dart';
import '../../utils/string_constants.dart';

class OfflineTokenRepository {
  final APIManager apiManager;
  OfflineTokenRepository(this.apiManager);

  // Get main category list api call
  Future<List<ProductMainCategoryModel>> getMainCategoryListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/productmaincategory',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<ProductMainCategoryModel> object = response.map((e) => ProductMainCategoryModel.fromJson(e)).toList();
    return object;
  }

  // Get sub category list api call
  Future<List<ProductSubCategoryModel>> getSubCategoryListApiCall({required int categoryId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/productsubcategory?CategoryID=$categoryId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<ProductSubCategoryModel> object = response.map((e) => ProductSubCategoryModel.fromJson(e)).toList();
    return object;
  }

  // Get child category list api call
  Future<List<ProductChildCategoryModel>> getChildCategoryListApiCall({required int subCategoryId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/productchildcategory?SubCategoryID=$subCategoryId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<ProductChildCategoryModel> object = response.map((e) => ProductChildCategoryModel.fromJson(e)).toList();
    return object;
  }

  // Get product details api call
  Future<AllProductModel> getProductDetailsApiCall({required int childCategoryId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/productdata?ChildCategoryID=$childCategoryId',
      isLoaderShow: isLoaderShow,
    );
    var response = AllProductModel.fromJson(jsonData);
    return response;
  }

  // Offline token order request api call
  Future<OfflineTokenOrderRequestModel> offlineTokenOrderRequestApiCall({required var params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/Product/place-order',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = OfflineTokenOrderRequestModel.fromJson(jsonData);
    return response;
  }

  // Get offline token credentials api call
  Future<OfflineTokenCredentialsModel> getOfflineTokenCredentialsApiCall({required String type, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/productUserCredentials/list-by-user?Type=$type&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = OfflineTokenCredentialsModel.fromJson(jsonData);
    return response;
  }

  // Generate show password otp api call
  Future<ShowPasswordOtpModel> generateShowPasswordOtpApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/productUserCredentials/generate-otp',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ShowPasswordOtpModel.fromJson(jsonData);
    return response;
  }

  // Resend show password otp api call
  Future<ShowPasswordOtpModel> resendShowPasswordOtpApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/productUserCredentials/resend-otp',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ShowPasswordOtpModel.fromJson(jsonData);
    return response;
  }

  // Validate show password otp api call
  Future<ValidateShowPasswordOtpModel> validateShowPasswordOtpApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}masterdata/api/master-module/productUserCredentials/validate-otp',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ValidateShowPasswordOtpModel.fromJson(jsonData);
    return response;
  }

  // Generate reset password request api call
  Future<SuccessModel> generateResetPasswordRequestApiCall({required String uniqueId, required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.putAPICall(
      url: '${baseUrl}masterdata/api/master-module/productUserCredentials/reset-pin-request/$uniqueId',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = SuccessModel.fromJson(jsonData);
    return response;
  }

  // Get purchase token order report api call
  Future<OrderReportModel> getPurchaseTokenReportApiCall({required int subCategoryID, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/productordetitems/user-wise?IsVisible=false&SubCategoryID=$subCategoryID&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = OrderReportModel.fromJson(jsonData);
    return response;
  }
}

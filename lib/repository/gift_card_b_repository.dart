import '../api/api_manager.dart';
import '../model/gift_card_b/bank_account_product_model.dart';
import '../model/gift_card_b/bank_sathi_category_model.dart';
import '../model/gift_card_b/bk_user_onboarding_model.dart';
import '../model/gift_card_b/bs_product_lead_model.dart';
import '../model/gift_card_b/check_customer_model.dart';
import '../model/gift_card_b/company_model.dart';
import '../model/gift_card_b/occupation_model.dart';
import '../model/gift_card_b/other_product_details_model.dart';
import '../model/gift_card_b/other_product_model.dart';
import '../model/gift_card_b/pincode_model.dart';
import '../model/gift_card_b/verify_bank_sathi_model.dart';
import '../utils/string_constants.dart';

class GiftCardBankSathiRepository {
  final APIManager apiManager;
  GiftCardBankSathiRepository(this.apiManager);

  // Get bk category list api call
  Future<BankSathiCategoryModel> getCategoryApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/bk-category',
      isLoaderShow: isLoaderShow,
    );
    var response = BankSathiCategoryModel.fromJson(jsonData);
    return response;
  }

  // Verify bank sathi user
  Future<VerifyBankSathiModel> verifyUserGiftCardApiCall({bool isLoaderShow = true, required String categoryId}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/Verify-bk-onboarding?Channels=$channelID&CategoryId=$categoryId',
      isLoaderShow: isLoaderShow,
    );
    var response = VerifyBankSathiModel.fromJson(jsonData);
    return response;
  }

  // Get bk company list api call
  Future<CompanyModel> getCompanyApiCall({bool isLoaderShow = true, required String searchKey}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/bk-companies?UserId=1&UserName=1&IPAddress=1&SearchKey=$searchKey',
      isLoaderShow: isLoaderShow,
    );
    var response = CompanyModel.fromJson(jsonData);
    return response;
  }

  // Get bk pinCode list api call
  Future<PinCodeModel> getPinCodeApiCall({bool isLoaderShow = true, required String searchKey}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/bk-pincode?SearchKey=$searchKey',
      isLoaderShow: isLoaderShow,
    );
    var response = PinCodeModel.fromJson(jsonData);
    return response;
  }

  // Get bk pinCode list api call
  Future<OccupationModel> getOccupationApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/bk-occupation',
      isLoaderShow: isLoaderShow,
    );
    var response = OccupationModel.fromJson(jsonData);
    return response;
  }

  // gift card Onboard  api call
  Future<BkOnboardUserModel> bkOnboardApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/create-bk-profile',
      isLoaderShow: isLoaderShow,
      params: params,
    );
    var response = BkOnboardUserModel.fromJson(jsonData);
    return response;
  }

  // Get personal loan products list api call
  Future<dynamic> getPersonalLoanProductsApiCall({bool isLoaderShow = true, required Map<String, dynamic> params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/bk-personal-loan-products',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    // var response = BankAccountProductModel.fromJson(jsonData);
    return jsonData;
  }

  // Get bank account products list api call
  Future<BankAccountProductModel> getBankAccountProductsApiCall({bool isLoaderShow = true, required Map<String, dynamic> params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/bk-bank-account-products',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = BankAccountProductModel.fromJson(jsonData);
    return response;
  }

  // Get credit card products list api call
  Future<dynamic> getCreditCardProductsApiCall({bool isLoaderShow = true, required Map<String, dynamic> params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/bk-credit-card-products',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    // var response = BankAccountProductModel.fromJson(jsonData);
    return jsonData;
  }

  // Get other products list api call
  Future<OtherProductModel> getOtherProductsApiCall({bool isLoaderShow = true, required String categoryId}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/bk-product-category?CategoryId=$categoryId',
      isLoaderShow: isLoaderShow,
    );
    var response = OtherProductModel.fromJson(jsonData);
    return response;
  }

  // Get credit card product details api call
  Future<dynamic> getCreditCardDetailsApiCall({bool isLoaderShow = true, required Map<String, dynamic> params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/bk-product-details',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    // var response = c;
    return jsonData;
  }

  // Get other product details api call
  Future<OtherProductDetails> getOtherProductDetailsApiCall({bool isLoaderShow = true, required Map<String, dynamic> params}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/bk-product-details-direct',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = OtherProductDetails.fromJson(jsonData);
    return response;
  }

  // Check customer exit or not
  Future<CheckCustomerModel> checkCustomerExitApiCall({required String mobileNo, required String panNo, required String categoryId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/check-cutomer-exists?MobileNo=$mobileNo&Pan=$panNo&CategoryId=$categoryId',
      isLoaderShow: isLoaderShow,
    );
    var response = CheckCustomerModel.fromJson(jsonData);
    return response;
  }

  // Generate product lead api call
  Future<BSProductLeadModel> generateProductLeadApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/bk-lead',
      isLoaderShow: isLoaderShow,
      params: params,
    );
    var response = BSProductLeadModel.fromJson(jsonData);
    return response;
  }
}

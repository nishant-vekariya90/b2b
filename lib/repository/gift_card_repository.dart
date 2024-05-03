import '../api/api_manager.dart';
import '../model/auth/states_model.dart';
import '../model/gift_card/gift_card_buy_model.dart';
import '../model/gift_card/gift_card_details_model.dart';
import '../model/gift_card/gift_cards_list_model.dart';
import '../model/gift_card/verify_sayf_user_model.dart';
import '../utils/string_constants.dart';

class GiftCardRepository {
  final APIManager apiManager;
  GiftCardRepository(this.apiManager);

  // Verify sayF giftCard user
  Future<VerifySayfUserModel> verifyUserGiftCardApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/Verify-sayf-onboarding?Channels=$channelID',
      isLoaderShow: isLoaderShow,
    );
    var response = VerifySayfUserModel.fromJson(jsonData);
    return response;
  }

  // Get states list
  Future<List<StatesModel>> statesApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/states',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<StatesModel> objects = response.map((jsonMap) => StatesModel.fromJson(jsonMap)).toList();
    return objects;
  }

  // gift card Onboard  api call
  Future<VerifySayfUserModel> onboardGiftCardApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/sayf-onboarding',
      isLoaderShow: isLoaderShow,
      params: params,
    );
    var response = VerifySayfUserModel.fromJson(jsonData);
    return response;
  }

  // Get gift cards  list api call
  Future<GiftCardModel> getGiftCardsApiCall({required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/sayf-gift-cards?Page=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = GiftCardModel.fromJson(jsonData);
    return response;
  }

  // Get gift cards details api call
  Future<GiftCardDetailModel> getGiftCardDetailsApiCall({required String productId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/sayf-cards-details?PId=$productId',
      isLoaderShow: isLoaderShow,
    );
    var response = GiftCardDetailModel.fromJson(jsonData);
    return response;
  }

  // Buy gift cards api call
  Future<GiftCardBuyModel> buyGiftCardApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/giftcard/sayf-buy-gift-cards',
      isLoaderShow: isLoaderShow,
      params: params,
    );
    var response = GiftCardBuyModel.fromJson(jsonData);
    return response;
  }
}

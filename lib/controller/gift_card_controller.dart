import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../api/api_manager.dart';
import '../model/auth/states_model.dart';
import '../model/gift_card/gift_card_buy_model.dart';
import '../model/gift_card/gift_card_details_model.dart';
import '../model/gift_card/gift_cards_list_model.dart';
import '../model/gift_card/verify_sayf_user_model.dart';
import '../repository/gift_card_repository.dart';
import '../utils/string_constants.dart';
import '../widgets/constant_widgets.dart';

class GiftCardController extends GetxController {
  GiftCardRepository giftCardRepository = GiftCardRepository(APIManager());

  // Verify sayF giftCard api call
  Rx<SayFVerifiedUserData> verifiedUserDataModel = SayFVerifiedUserData().obs;
  Future<int> verifyUserGiftCardApi({bool isLoaderShow = true}) async {
    try {
      VerifySayfUserModel verifySayUserModel = await giftCardRepository.verifyUserGiftCardApiCall(isLoaderShow: isLoaderShow);
      if (verifySayUserModel.statusCode == 1) {
        return 1;
      } else if (verifySayUserModel.statusCode == 2) {
        if(verifySayUserModel.data!=null){
          verifiedUserDataModel.value=verifySayUserModel.data!;
        }
        return 2;
      } else {
        errorSnackBar(message: verifySayUserModel.message);
        return 0;
      }
    } catch (e) {
      dismissProgressIndicator();
      return 0;
    }
  }

  setVerifiedDataIntoVariables(SayFVerifiedUserData verifyUserModel ){
    if(verifyUserModel.firstName!=null && verifyUserModel.firstName!.isNotEmpty){
      firstNameTxtController.text=verifyUserModel.firstName!;
    } if(verifyUserModel.lastName!=null && verifyUserModel.lastName!.isNotEmpty){
      lastnameTxtController.text=verifyUserModel.lastName!;
    } if(verifyUserModel.mobileNo!=null && verifyUserModel.mobileNo!.isNotEmpty){
      mobileTxtController.text=verifyUserModel.mobileNo!;
    } if(verifyUserModel.firmName!=null && verifyUserModel.firmName!.isNotEmpty){
      firmNameTxtController.text=verifyUserModel.firmName!;
    } if(verifyUserModel.email!=null && verifyUserModel.email!.isNotEmpty){
      emailTxtController.text=verifyUserModel.email!;
    }
  }

  // GiftCard Onboarding variables
  TextEditingController firstNameTxtController = TextEditingController();
  TextEditingController lastnameTxtController = TextEditingController();
  TextEditingController mobileTxtController = TextEditingController();
  TextEditingController firmNameTxtController = TextEditingController();
  TextEditingController emailTxtController = TextEditingController();
  TextEditingController stateTxtController = TextEditingController();
  TextEditingController remarkTxtController = TextEditingController();
  RxInt selectedStateId = 0.obs;


  RxString selectedGenderMethodRadio = 'MALE'.obs;

  // get states api call
  RxList<StatesModel> statesList = <StatesModel>[].obs;
  Future<bool> getStatesAPI({bool isLoaderShow = true}) async {
    try {
      List<StatesModel> response = await giftCardRepository.statesApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (response.isNotEmpty) {
        statesList.clear();
        for (StatesModel element in response) {
          if (element.status == 1) {
            statesList.add(element);
          }
        }
        statesList.sort((a, b) => a.countryName!.toLowerCase().compareTo(b.countryName!.toLowerCase()));
        return true;
      } else {
        statesList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // onboard api call
  Future<bool> giftCardOnboardApi({bool isLoaderShow = true}) async {
    try {
      VerifySayfUserModel verifySayUserModel = await giftCardRepository.onboardGiftCardApiCall(
        params: {
          "firstName": firstNameTxtController.text.trim(),
          "lastName": lastnameTxtController.text.trim(),
          "mobileNo": mobileTxtController.text.trim(),
          "firmName": firmNameTxtController.text.trim(),
          "email": emailTxtController.text.trim(),
          "gender": selectedGenderMethodRadio.value,
          "state": selectedStateId.value,
          "remarks": remarkTxtController.text.trim()
        },
        isLoaderShow: isLoaderShow,
      );
      if (verifySayUserModel.statusCode == 1) {
        return true;
      } else {
        errorSnackBar(message: verifySayUserModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Gift cards
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;
  RxString selectedGiftCardId = ''.obs;
  RxList<GiftCardsListModel> filteredGiftCardsList = <GiftCardsListModel>[].obs;
  RxList<GiftCardsListModel> allGiftCardsList = <GiftCardsListModel>[].obs;
  Future<bool> getGiftCardsListApi({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      GiftCardModel giftCardModel = await giftCardRepository.getGiftCardsApiCall(
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
     // filteredGiftCardsList.clear();
     // allGiftCardsList.clear();
      if (giftCardModel.statusCode == 1) {
        if (currentPage.value == 1) {
          allGiftCardsList.clear();
          filteredGiftCardsList.clear();
        }
        for (GiftCardsListModel element in giftCardModel.data!) {
          allGiftCardsList.add(element);
          filteredGiftCardsList.add(element);
        }
        currentPage.value = int.parse(giftCardModel.pageNumber.toString());
        totalPages.value = int.parse(giftCardModel.pageSize.toString());
        // hasNext.value = giftCardModel.pagination!.hasNext!;
        return true;
      } else if (giftCardModel.statusCode == 0) {
        allGiftCardsList.clear();
        filteredGiftCardsList.clear();
        return true;
      } else {
        allGiftCardsList.clear();
        filteredGiftCardsList.clear();
        errorSnackBar(message: giftCardModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // search filter in gift cards list
  searchInGiftCardList(String searchQuery) {
    if (searchQuery.isNotEmpty) {
      filteredGiftCardsList.value = allGiftCardsList.where((item) {
        final query = searchQuery.toLowerCase();
        return item.brand!.toLowerCase().contains(query);
      }).toList();
    } else {
      filteredGiftCardsList.value = allGiftCardsList;
    }
  }

  resetAllGiftCardVariables(){
    currentPage.value=1;
    totalPages.value=1;
    filteredGiftCardsList.clear();
    allGiftCardsList.clear();
  }

  // Gift Card details api
  TextEditingController amountController = TextEditingController();
  RxString amountIntoWords = ''.obs;
  Rx<GiftCardDetailModel> giftCardDetailsModel = GiftCardDetailModel().obs;
  Future<bool> giftCardDetailsApi({bool isLoaderShow = true}) async {
    try {
      giftCardDetailsModel.value = await giftCardRepository.getGiftCardDetailsApiCall(
        productId: selectedGiftCardId.value,
        isLoaderShow: isLoaderShow,
      );
      if (giftCardDetailsModel.value.statusCode == 1) {
        return true;
      } else {
        errorSnackBar(message: giftCardDetailsModel.value.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Buy gift card api call
  RxBool isShowTpinField = false.obs;
  RxBool isShowTpin = true.obs;
  RxInt orderStatus = (-1).obs;
  TextEditingController tPinTxtController = TextEditingController();
  Rx<GiftCardBuyModel> giftCardBuyModel = GiftCardBuyModel().obs;
  Future<int> buyGiftCardApi({bool isLoaderShow = true}) async {
    try {
      giftCardBuyModel.value = await giftCardRepository.buyGiftCardApiCall(
        params: {
          "mobileNo": "${getStoredUserBasicDetails().mobile}",
          "code": giftCardDetailsModel.value.data!.code,
          "amount": int.parse(amountController.text.trim()),
          "brandName": giftCardDetailsModel.value.data!.brandName,
          "orderId": "App${DateTime.now().millisecondsSinceEpoch.toString()}",
          "remarks": remarkTxtController.text.trim(),
          "tpin": tPinTxtController.text.isNotEmpty ? tPinTxtController.text.trim() : null,
          "channel": channelID,
          "ipAddress": ipAddress,
          "latitude": latitude,
          "longitude": longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (giftCardBuyModel.value.statusCode == 1) {
        return giftCardBuyModel.value.statusCode!;
      } else {
        errorSnackBar(message: giftCardBuyModel.value.message);
        return 0;
      }
    } catch (e) {
      dismissProgressIndicator();
      return -1;
    }
  }

  resetGiftCardVariables() {
    isShowTpinField.value = false;
    isShowTpin.value = true;
    firstNameTxtController.clear();
    lastnameTxtController.clear();
    mobileTxtController.clear();
    emailTxtController.clear();
    firmNameTxtController.clear();
    selectedGenderMethodRadio.value = 'MALE';
    amountController.clear();
    stateTxtController.clear();
    tPinTxtController.clear();
    remarkTxtController.clear();
    orderStatus.value = -1;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_manager.dart';
import '../../generated/assets.dart';
import '../../model/gift_card_b/bank_account_product_model.dart';
import '../../model/gift_card_b/bank_sathi_category_model.dart';
import '../../model/gift_card_b/bk_user_onboarding_model.dart';
import '../../model/gift_card_b/bs_product_lead_model.dart';
import '../../model/gift_card_b/check_customer_model.dart';
import '../../model/gift_card_b/company_model.dart';
import '../../model/gift_card_b/occupation_model.dart';
import '../../model/gift_card_b/other_product_details_model.dart';
import '../../model/gift_card_b/other_product_model.dart';
import '../../model/gift_card_b/pincode_model.dart';
import '../../model/gift_card_b/verify_bank_sathi_model.dart';
import '../../repository/gift_card_b_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class GiftCardBController extends GetxController {
  GiftCardBankSathiRepository giftCardBRepository = GiftCardBankSathiRepository(APIManager());

  RxList<BKCategoryListModel> categoryList = <BKCategoryListModel>[].obs;
  TextEditingController categoryTxtController = TextEditingController();
  RxInt selectedCategoryId = 0.obs;
  Future<bool> getCategoryListApi({bool isLoaderShow = true}) async {
    try {
      BankSathiCategoryModel giftCardModel = await giftCardBRepository.getCategoryApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (giftCardModel.statusCode == 1) {
        for (BKCategoryListModel element in giftCardModel.data!) {
          //bank account
          if (element.id == 13) {
            BKCategoryListModel bkCategoryModel = BKCategoryListModel(id: element.id, title: element.title, logo: Assets.iconsBankAccounts);
            categoryList.add(bkCategoryModel);
          }
          //credit card
          else if (element.id == 3) {
            BKCategoryListModel bkCategoryModel = BKCategoryListModel(id: element.id, title: element.title, logo: Assets.iconsDebitCard);
            categoryList.add(bkCategoryModel);
          } //credit line
          else if (element.id == 30) {
            BKCategoryListModel bkCategoryModel = BKCategoryListModel(id: element.id, title: element.title, logo: Assets.iconsCreditCard);
            categoryList.add(bkCategoryModel);
          } //Demat Accounts
          else if (element.id == 17) {
            BKCategoryListModel bkCategoryModel = BKCategoryListModel(id: element.id, title: element.title, logo: Assets.iconsDematAccount);
            categoryList.add(bkCategoryModel);
          } //Mutual Funds
          else if (element.id == 261) {
            BKCategoryListModel bkCategoryModel = BKCategoryListModel(id: element.id, title: element.title, logo: Assets.iconsMutualFund);
            categoryList.add(bkCategoryModel);
          }
          //Personal Loan
          else if (element.id == 4) {
            BKCategoryListModel bkCategoryModel = BKCategoryListModel(id: element.id, title: element.title, logo: Assets.iconsPersonalLoan);
            categoryList.add(bkCategoryModel);
          }
        }
        return true;
      } else if (giftCardModel.statusCode == 0) {
        categoryList.clear();
        return true;
      } else {
        categoryList.clear();
        errorSnackBar(message: giftCardModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Verify bank sathi giftCard api call
  Rx<BkVerifiedUserData> verifiedUserDataModel = BkVerifiedUserData().obs;
  Future<int> verifyGiftCardBUserApi({bool isLoaderShow = true}) async {
    try {
      VerifyBankSathiModel verifyUserModel = await giftCardBRepository.verifyUserGiftCardApiCall(isLoaderShow: isLoaderShow, categoryId: selectedCategoryId.value.toString());
      if (verifyUserModel.statusCode == 1) {
        return 1;
      } else if (verifyUserModel.statusCode == 5) {
        if (verifyUserModel.data != null) {
          verifiedUserDataModel.value = verifyUserModel.data!;
        }
        return 5;
      } else {
        errorSnackBar(message: verifyUserModel.message);
        return 0;
      }
    } catch (e) {
      dismissProgressIndicator();
      return 0;
    }
  }

  setVerifiedDataIntoVariables(BkVerifiedUserData verifyUserModel) {
    if (verifyUserModel.firstName != null && verifyUserModel.firstName!.isNotEmpty) {
      firstNameTxtController.text = verifyUserModel.firstName!;
    }
    if (verifyUserModel.lastName != null && verifyUserModel.lastName!.isNotEmpty) {
      lastnameTxtController.text = verifyUserModel.lastName!;
    }
    if (verifyUserModel.mobileNo != null && verifyUserModel.mobileNo!.isNotEmpty) {
      mobileTxtController.text = verifyUserModel.mobileNo!;
    }
    if (verifyUserModel.firmName != null && verifyUserModel.firmName!.isNotEmpty) {
      firmNameTxtController.text = verifyUserModel.firmName!;
    }
    if (verifyUserModel.email != null && verifyUserModel.email!.isNotEmpty) {
      emailTxtController.text = verifyUserModel.email!;
    }
  }

  // GiftCard Onboarding variables
  TextEditingController firstNameTxtController = TextEditingController();
  TextEditingController lastnameTxtController = TextEditingController();
  TextEditingController mobileTxtController = TextEditingController();
  TextEditingController customerNameTxtController = TextEditingController();
  TextEditingController firmNameTxtController = TextEditingController();
  TextEditingController emailTxtController = TextEditingController();
  TextEditingController addressTxtController = TextEditingController();
  TextEditingController dobTxtController = TextEditingController();
  TextEditingController pinCodeTxtController = TextEditingController();
  TextEditingController occupationTxtController = TextEditingController();
  TextEditingController remarkTxtController = TextEditingController();
  TextEditingController monthlySalaryTxtController = TextEditingController();
  TextEditingController itrTxtController = TextEditingController();
  RxInt selectedCompanyId = 0.obs;
  RxInt selectedOccupationId = 0.obs;
  RxInt selectedPinCodeId = 0.obs;
  RxString selectedGenderMethodRadio = 'Male'.obs;
  RxString selectedCategoryMethodRadio = 'Individual'.obs;
  RxString amountIntoWords = ''.obs;

  // Get company list api call
  RxList<CompanyListModel> companyList = <CompanyListModel>[].obs;
  Future<bool> getCompanyListApi({bool isLoaderShow = true, required String searchKey}) async {
    try {
      CompanyModel companyModel = await giftCardBRepository.getCompanyApiCall(
        searchKey: searchKey,
        isLoaderShow: isLoaderShow,
      );
      companyList.clear();
      if (companyModel.statusCode == 1) {
        for (CompanyListModel element in companyModel.data!) {
          companyList.add(element);
        }
        return true;
      } else if (companyModel.statusCode == 0) {
        companyList.clear();
        return true;
      } else {
        companyList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get occupation list api call
  RxList<OccupationListModel> occupationList = <OccupationListModel>[].obs;
  Future<bool> getOccupationListApi({bool isLoaderShow = true}) async {
    try {
      OccupationModel occupationModel = await giftCardBRepository.getOccupationApiCall(
        isLoaderShow: isLoaderShow,
      );
      occupationList.clear();
      if (occupationModel.statusCode == 1) {
        for (OccupationListModel element in occupationModel.data!) {
          occupationList.add(element);
        }
        return true;
      } else if (occupationModel.statusCode == 0) {
        occupationList.clear();
        return true;
      } else {
        occupationList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get pinCode list api call
  RxList<PinCodeListModel> pinCodeList = <PinCodeListModel>[].obs;
  Future<bool> getPinCodeListApi({bool isLoaderShow = true, required String searchKey}) async {
    try {
      PinCodeModel pinCodeModel = await giftCardBRepository.getPinCodeApiCall(isLoaderShow: isLoaderShow, searchKey: searchKey);
      pinCodeList.clear();
      if (pinCodeModel.statusCode == 1) {
        for (PinCodeListModel element in pinCodeModel.data!) {
          pinCodeList.add(element);
        }
        return true;
      } else if (pinCodeModel.statusCode == 0) {
        pinCodeList.clear();
        return true;
      } else {
        pinCodeList.clear();
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
      BkOnboardUserModel onboardModel = await giftCardBRepository.bkOnboardApiCall(
        params: {
          "firstName": firstNameTxtController.text.trim(),
          "lastName": lastnameTxtController.text.trim(),
          "mobileNo": mobileTxtController.text.trim(),
          "firmName": selectedCompanyId.value,
          "email": emailTxtController.text.trim(),
          "address": addressTxtController.text.trim(),
          "gender": selectedGenderMethodRadio.value,
          "dob": dobTxtController.text.trim(),
          "occupation": selectedOccupationId.value,
          "monthlySalary": selectedOccupationId.value == 1 || selectedOccupationId.value == 3 ? int.parse(monthlySalaryTxtController.text.trim()) : '0',
          "itrAmount": selectedOccupationId.value == 2 ? int.parse(itrTxtController.text.trim()) : 0,
          "pincode": selectedPinCodeId.value,
          "category": selectedCategoryMethodRadio.value,
          "categoryId": selectedCategoryId.value,
        },
        isLoaderShow: isLoaderShow,
      );
      if (onboardModel.statusCode == 1) {
        successSnackBar(message: onboardModel.message);
        return true;
      } else {
        errorSnackBar(message: onboardModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  resetOnboardingVariables() {
    firstNameTxtController.clear();
    lastnameTxtController.clear();
    mobileTxtController.clear();
    emailTxtController.clear();
    firmNameTxtController.clear();
    occupationTxtController.clear();
    pinCodeTxtController.clear();
    monthlySalaryTxtController.clear();
    dobTxtController.clear();
    itrTxtController.clear();
    occupationTxtController.clear();
    addressTxtController.clear();
    selectedCompanyId.value = 0;
    selectedOccupationId.value = 0;
    selectedPinCodeId.value = 0;
    selectedGenderMethodRadio.value = 'Male';
    selectedCategoryMethodRadio.value = 'Individual';
  }

  RxList<EligibleProductList> filteredEligibleProductList = <EligibleProductList>[].obs;
  RxList<EligibleProductList> allEligibleProductList = <EligibleProductList>[].obs;
  TextEditingController panNumberTxtController = TextEditingController();

  // fetch personal loan products
  Future<bool> getPersonalLoanProductListApi({bool isLoaderShow = true}) async {
    try {
      var productModel =
          await giftCardBRepository.getPersonalLoanProductsApiCall(isLoaderShow: isLoaderShow, params: {"categroyId": selectedCategoryId.value, "requiredAmount": "10", "ipAddress": ipAddress});
      if (productModel['statusCode'] == 1) {
        if (productModel['eligibleProductList'].isNotEmpty) {
          for (var element in productModel['eligibleProductList']) {
            EligibleProductList eligibleProductList = EligibleProductList(
              productId: element['id'],
              title: element['title'],
              subTitle: element['subTitle'],
              logo: element['bankLogo'],
            );
            allEligibleProductList.add(eligibleProductList);
            filteredEligibleProductList.add(eligibleProductList);
          }
          return true;
        } else {
          allEligibleProductList.clear();
          filteredEligibleProductList.clear();
          return true;
        }
      } else if (productModel.statusCode == 0) {
        allEligibleProductList.clear();
        filteredEligibleProductList.clear();
        return true;
      } else {
        allEligibleProductList.clear();
        filteredEligibleProductList.clear();
        errorSnackBar(message: productModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // fetch credit card products
  Future<bool> getCreditCardProductListApi({bool isLoaderShow = true}) async {
    try {
      var productModel =
          await giftCardBRepository.getCreditCardProductsApiCall(isLoaderShow: isLoaderShow, params: {"categroyId": selectedCategoryId.value, "requiredAmount": "10", "ipAddress": ipAddress});

      if (productModel['statusCode'] == 1) {
        if (productModel['eligibleProductList'].isNotEmpty) {
          for (var element in productModel['eligibleProductList']) {
            EligibleProductList eligibleProductList = EligibleProductList(
              productId: element['productId'],
              cardId: element['cardId'],
              title: element['cardName'],
              logo: element['bankLogo'],
            );
            allEligibleProductList.add(eligibleProductList);
            filteredEligibleProductList.add(eligibleProductList);
          }
          return true;
        } else {
          allEligibleProductList.clear();
          filteredEligibleProductList.clear();
          return true;
        }
      } else if (productModel.statusCode == 0) {
        allEligibleProductList.clear();
        filteredEligibleProductList.clear();
        return true;
      } else {
        allEligibleProductList.clear();
        filteredEligibleProductList.clear();
        errorSnackBar(message: productModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // fetch bank accounts products
  Future<bool> getBankAccountProductListApi({bool isLoaderShow = true}) async {
    try {
      BankAccountProductModel productModel =
          await giftCardBRepository.getBankAccountProductsApiCall(isLoaderShow: isLoaderShow, params: {"categroyId": selectedCategoryId.value, "requiredAmount": "10", "ipAddress": ipAddress});

      if (productModel.statusCode == 1) {
        if (productModel.eligibleProductList != null && productModel.eligibleProductList!.isNotEmpty) {
          for (EligibleProductList element in productModel.eligibleProductList!) {
            allEligibleProductList.add(element);
            filteredEligibleProductList.add(element);
          }
          return true;
        } else {
          allEligibleProductList.clear();
          filteredEligibleProductList.clear();
          return true;
        }
      } else if (productModel.statusCode == 0) {
        allEligibleProductList.clear();
        filteredEligibleProductList.clear();
        return true;
      } else {
        allEligibleProductList.clear();
        filteredEligibleProductList.clear();
        errorSnackBar(message: productModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // fetch other products
  Future<bool> getOtherProductListApi({bool isLoaderShow = true}) async {
    try {
      OtherProductModel productModel = await giftCardBRepository.getOtherProductsApiCall(isLoaderShow: isLoaderShow, categoryId: selectedCategoryId.value.toString());
      allEligibleProductList.clear();
      filteredEligibleProductList.clear();
      if (productModel.statusCode == 1) {
        for (EligibleProductList element in productModel.data!) {
          allEligibleProductList.add(element);
          filteredEligibleProductList.add(element);
        }
        return true;
      } else if (productModel.statusCode == 0) {
        allEligibleProductList.clear();
        filteredEligibleProductList.clear();
        return true;
      } else {
        allEligibleProductList.clear();
        filteredEligibleProductList.clear();
        errorSnackBar(message: productModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // search filter in product list
  searchInProductList(String searchQuery) {
    if (searchQuery.isNotEmpty) {
      filteredEligibleProductList.value = allEligibleProductList.where((item) {
        final query = searchQuery.toLowerCase();
        return item.title!.toLowerCase().contains(query);
      }).toList();
    } else {
      filteredEligibleProductList.value = allEligibleProductList;
    }
  }

  resetAllEligibleProductPageVariable() {
    selectedCategoryId.value = 0;
    allEligibleProductList.clear();
    filteredEligibleProductList.clear();
  }

  // Credit card product details api
  RxBool isShowTpinField = false.obs;
  RxBool isShowTpin = true.obs;
  TextEditingController tPinTxtController = TextEditingController();
  Rx<OtherProductDetails> bkProductDetailsModel = OtherProductDetails().obs;
  RxInt selectedProductId = 0.obs;
  RxString selectedProductName = "".obs;
  RxInt selectedCardId = 0.obs;

  Future<bool> getCreditCardDetailsApi({
    bool isLoaderShow = true,
  }) async {
    try {
      var productDetails =
          await giftCardBRepository.getCreditCardDetailsApiCall(isLoaderShow: isLoaderShow, params: {"productId": selectedProductId.value, "cardId": selectedCardId.value, "ipAddress": ipAddress});
      if (productDetails['statusCode'] == 1) {
        List<Attribute> attributes = (productDetails['tabs'] as List<dynamic>).map((e) => Attribute.fromJson(e)).toList();

        bkProductDetailsModel.value = OtherProductDetails(title: productDetails['cardName'], subTitle: null, logo: productDetails['bankLogo'], attribute: attributes);

        return true;
      } else {
        errorSnackBar(message: productDetails['message']);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> getOtherProductDetailsApi({
    bool isLoaderShow = true,
  }) async {
    try {
      bkProductDetailsModel.value = await giftCardBRepository.getOtherProductDetailsApiCall(isLoaderShow: isLoaderShow, params: {
        "productId": selectedProductId.value,
      });
      if (bkProductDetailsModel.value.statusCode == 1) {
        return true;
      } else {
        errorSnackBar(message: bkProductDetailsModel.value.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Check customer exit or not
  RxString customerId = ''.obs;
  Future<bool> checkCustomerExitApi({bool isLoaderShow = true}) async {
    try {
      CheckCustomerModel checkCustomerModel = await giftCardBRepository.checkCustomerExitApiCall(
        mobileNo: mobileTxtController.text.trim(),
        panNo: panNumberTxtController.text.trim(),
        categoryId: selectedCategoryId.value.toString(),
        isLoaderShow: isLoaderShow,
      );
      if (checkCustomerModel.statusCode == 1) {
        if (checkCustomerModel.customerId != null && checkCustomerModel.customerId!.isNotEmpty) {
          customerId.value = checkCustomerModel.customerId.toString();
          return true;
        } else {
          errorSnackBar(message: "Customer id not found please try after some time");
          return false;
        }
      } else {
        errorSnackBar(message: giftCardBuyModel.value.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  resetProductDetailsVaribales() {
    mobileTxtController.clear();
    panNumberTxtController.clear();
    tPinTxtController.clear();
  }

  // Generate product lead api call
  RxInt orderStatus = (-1).obs;
  Rx<BSProductLeadModel> giftCardBuyModel = BSProductLeadModel().obs;
  Future<int> generateProductLeadApi({bool isLoaderShow = true}) async {
    try {
      giftCardBuyModel.value = await giftCardBRepository.generateProductLeadApiCall(
        params: {
          "productId": selectedProductId.value,
          "productName": selectedProductName.value,
          "categroyId": selectedCategoryId.value,
          "categroyName": categoryTxtController.text,
          "CustomerId": customerId.value,
          "pancardNo": panNumberTxtController.text.trim(),
          "customerName":customerNameTxtController.text.trim(),
          "requiredAmount": "1",
          "channels": channelID,
          "orderId": "App${DateTime.now().millisecondsSinceEpoch.toString()}",
          "tpin": tPinTxtController.text.isNotEmpty ? tPinTxtController.text.trim() : null,
          "ipAddress": ipAddress
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
    tPinTxtController.clear();
    orderStatus.value = -1;
  }
}

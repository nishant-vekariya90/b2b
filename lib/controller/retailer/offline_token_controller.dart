import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../api/api_manager.dart';
import '../../model/offline_token/offline_token_credentials_model.dart';
import '../../model/offline_token/offline_token_order_request_model.dart';
import '../../model/offline_token/show_password_otp_model.dart';
import '../../model/offline_token/validate_show_password_otp_model.dart';
import '../../model/product/all_product_model.dart';
import '../../model/product/order_report_model.dart';
import '../../model/product/product_child_category_model.dart';
import '../../model/product/product_main_category_model.dart';
import '../../model/product/product_sub_category_model.dart';
import '../../model/success_model.dart';
import '../../repository/retailer/offline_token_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class OfflineTokenController extends GetxController {
  OfflineTokenRepository offlineTokenRepository = OfflineTokenRepository(APIManager());

  // Get main category list
  RxList<ProductMainCategoryModel> mainCategoryList = <ProductMainCategoryModel>[].obs;
  RxInt mainCategoryId = 0.obs;
  Future<bool> getMainCategoryList({required String code, bool isLoaderShow = true}) async {
    RxBool result = false.obs;
    try {
      List<ProductMainCategoryModel> productMainCategoryModel = await offlineTokenRepository.getMainCategoryListApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (productMainCategoryModel.isNotEmpty) {
        mainCategoryList.clear();
        for (ProductMainCategoryModel element in productMainCategoryModel) {
          if (element.status == 1) {
            mainCategoryList.add(element);
          }
        }
        mainCategoryId.value = mainCategoryList.firstWhere((element) => element.code != null && element.code == 'OFXL').id ?? 0;
        // Get sub category list according to category
        if (mainCategoryId.value > 0) {
          result.value = await getSubCategoryList(
            code: code,
            categoryId: mainCategoryId.value,
            isLoaderShow: false,
          );
        }
        return result.value;
      } else {
        mainCategoryList.clear();
        return result.value;
      }
    } catch (e) {
      dismissProgressIndicator();
      return result.value;
    }
  }

  // Get sub category list
  RxList<ProductSubCategoryModel> subCategoryList = <ProductSubCategoryModel>[].obs;
  RxInt subCategoryId = 0.obs;
  Future<bool> getSubCategoryList({required String code, required int categoryId, bool isLoaderShow = true}) async {
    RxBool result = false.obs;
    try {
      List<ProductSubCategoryModel> productSubCategoryModel = await offlineTokenRepository.getSubCategoryListApiCall(
        categoryId: categoryId,
        isLoaderShow: isLoaderShow,
      );
      if (productSubCategoryModel.isNotEmpty) {
        subCategoryList.clear();
        for (ProductSubCategoryModel element in productSubCategoryModel) {
          if (element.status == 1) {
            subCategoryList.add(element);
          }
        }
        subCategoryId.value = subCategoryList.firstWhere((element) => element.code != null && element.code == code).id ?? 0;
        // Get child category list according to sub category
        if (subCategoryId.value > 0) {
          result.value = await getChildCategoryList(
            subCategoryId: subCategoryId.value,
            isLoaderShow: false,
          );
        }
        return result.value;
      } else {
        subCategoryList.clear();
        return result.value;
      }
    } catch (e) {
      dismissProgressIndicator();
      return result.value;
    }
  }

  // Get child category list
  RxList<ProductChildCategoryModel> childCategoryList = <ProductChildCategoryModel>[].obs;
  Future<bool> getChildCategoryList({required int subCategoryId, bool isLoaderShow = true}) async {
    try {
      List<ProductChildCategoryModel> productChildCategoryModel = await offlineTokenRepository.getChildCategoryListApiCall(
        subCategoryId: subCategoryId,
        isLoaderShow: isLoaderShow,
      );
      if (productChildCategoryModel.isNotEmpty) {
        childCategoryList.clear();
        for (ProductChildCategoryModel element in productChildCategoryModel) {
          if (element.status == 1) {
            childCategoryList.add(element);
          }
        }
        return true;
      } else {
        childCategoryList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get product details
  RxList<AllProductListModel> productDetailsList = <AllProductListModel>[].obs;
  Future<bool> getProductDetails({required int childCategoryId, bool isLoaderShow = true}) async {
    try {
      AllProductModel productDetailsModel = await offlineTokenRepository.getProductDetailsApiCall(
        childCategoryId: childCategoryId,
        isLoaderShow: isLoaderShow,
      );
      if (productDetailsModel.statusCode == 1 && productDetailsModel.data != null && productDetailsModel.data!.isNotEmpty) {
        productDetailsList.clear();
        for (AllProductListModel element in productDetailsModel.data!) {
          if (element.status == 1) {
            productDetailsList.add(element);
          }
        }
        return true;
      } else {
        productDetailsList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Converting integer status into string
  String tokenCredentialsResetPinStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Not Reset';
    } else if (intStatus == 1) {
      status = 'Success';
    } else if (intStatus == 2) {
      status = 'Pending';
    }
    return status;
  }

  // Offline token order request variables
  RxInt selectedTabIndex = 0.obs;
  RxString selectedProductUniqueId = ''.obs;
  TextEditingController numberOfTokenController = TextEditingController();
  TextEditingController tokenValueController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  RxString amountIntoWords = ''.obs;
  TextEditingController tPinController = TextEditingController();
  RxBool isHideTpin = true.obs;
  RxInt minQuantity = 1.obs;
  RxInt maxQuantity = 1000.obs;
  // Offline token order request
  Rx<OfflineTokenOrderRequestModel> offlineTokenOrderRequestModel = OfflineTokenOrderRequestModel().obs;
  Future<bool> offlineTokenOrderRequest({bool isLoaderShow = true}) async {
    try {
      offlineTokenOrderRequestModel.value = await offlineTokenRepository.offlineTokenOrderRequestApiCall(
        params: {
          'productUnqId': selectedProductUniqueId.value,
          'quantity': int.parse(numberOfTokenController.text.trim()),
          'amount': double.parse(totalAmountController.text.trim()).toInt(),
          'name': getStoredUserBasicDetails().ownerName,
          'contact': getStoredUserBasicDetails().mobile,
          'email': getStoredUserBasicDetails().email,
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'tpin': tPinController.text.isNotEmpty ? tPinController.text.trim() : null,
          'channel': channelID,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (offlineTokenOrderRequestModel.value.statusCode == 1) {
        successSnackBar(message: offlineTokenOrderRequestModel.value.message!);
        return true;
      } else {
        errorSnackBar(message: offlineTokenOrderRequestModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Offline token credentials variables
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;
  RxBool isOfflineTokenCredentialsListLoading = false.obs;
  // Get offline token credentials
  RxList<OfflineTokenCredentialsData> offlineTokenCredentialsList = <OfflineTokenCredentialsData>[].obs;
  Future<void> getOfflineTokenCredentialsList({required String type, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      OfflineTokenCredentialsModel offlineTokenCredentialsModel = await offlineTokenRepository.getOfflineTokenCredentialsApiCall(
        type: type,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (offlineTokenCredentialsModel.statusCode == 1) {
        if (offlineTokenCredentialsModel.pagination!.currentPage == 1) {
          offlineTokenCredentialsList.clear();
        }
        if (offlineTokenCredentialsModel.data != null && offlineTokenCredentialsModel.data!.isNotEmpty) {
          for (OfflineTokenCredentialsData element in offlineTokenCredentialsModel.data!) {
            offlineTokenCredentialsList.add(element);
          }
        }
        if (offlineTokenCredentialsModel.pagination != null) {
          currentPage.value = offlineTokenCredentialsModel.pagination!.currentPage!;
          totalPages.value = offlineTokenCredentialsModel.pagination!.totalPages!;
          hasNext.value = offlineTokenCredentialsModel.pagination!.hasNext!;
        }
      } else if (offlineTokenCredentialsModel.statusCode == 0) {
        offlineTokenCredentialsList.clear();
        Future.delayed(const Duration(milliseconds: 500), () {
          currentPage.value = 1;
          totalPages.value = 1;
          hasNext.value = false;
        });
      } else {
        offlineTokenCredentialsList.clear();
        currentPage.value = 1;
        totalPages.value = 1;
        hasNext.value = false;
        errorSnackBar(message: offlineTokenCredentialsModel.message);
      }
    } catch (e) {
      dismissProgressIndicator();
    } finally {
      dismissProgressIndicator();
      Future.delayed(const Duration(milliseconds: 500), () {
        isOfflineTokenCredentialsListLoading.value = false;
      });
    }
  }

  // Reset offline token variables
  resetOfflineTokenVariables() {
    selectedTabIndex.value = 0;
    selectedProductUniqueId.value = '';
    numberOfTokenController.clear();
    tokenValueController.clear();
    totalAmountController.clear();
    amountIntoWords.value = '';
    tPinController.clear();
    isHideTpin.value = true;
    currentPage.value = 1;
    totalPages.value = 1;
    hasNext.value = false;
    selectedTokenTypeController.clear();
    selectedTokenDescription.value = '';
    selectedCompanyNameController.clear();
    selectedProductNameController.clear();
    selectedProductDescription.value = '';
    minQuantity.value = 1;
    maxQuantity.value = 1000;
  }

  /////////////////////
  /// Show Password ///
  /////////////////////

  // Show password otp variables
  RxString showPasswordOtpRefNumber = ''.obs;
  RxString showPasswordOtp = ''.obs;
  RxString showPasswordAutoReadOtp = ''.obs;
  Timer? showPasswordResendTimer;
  RxInt showPasswordTotalSecond = 120.obs;
  RxBool clearShowPasswordOtp = false.obs;
  RxBool isShowPasswordResendButtonShow = false.obs;

  // Verify/Resend show password otp timer
  startShowPasswordTimer() {
    showPasswordResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      showPasswordTotalSecond.value--;
      if (showPasswordTotalSecond.value == 0) {
        showPasswordResendTimer!.cancel();
        isShowPasswordResendButtonShow.value = true;
      }
    });
  }

  // Reset show password timer
  resetShowPasswordTimer() {
    showPasswordOtp.value = '';
    showPasswordAutoReadOtp.value = '';
    showPasswordResendTimer!.cancel();
    showPasswordTotalSecond.value = 120;
    clearShowPasswordOtp.value = true;
    isShowPasswordResendButtonShow.value = false;
  }

  // Generate show password otp
  Rx<ShowPasswordOtpModel> generateShowPasswordOtpModel = ShowPasswordOtpModel().obs;
  Future<bool> generateShowPasswordOtp({required String uniqueId, bool isLoaderShow = true}) async {
    try {
      generateShowPasswordOtpModel.value = await offlineTokenRepository.generateShowPasswordOtpApiCall(
        params: {
          'unqId': uniqueId,
          'channels': channelID,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (generateShowPasswordOtpModel.value.statusCode == 1) {
        showPasswordOtpRefNumber.value =
            generateShowPasswordOtpModel.value.refNumber != null && generateShowPasswordOtpModel.value.refNumber!.isNotEmpty ? generateShowPasswordOtpModel.value.refNumber!.toString() : '';
        successSnackBar(message: generateShowPasswordOtpModel.value.message!);
        return true;
      } else {
        errorSnackBar(message: generateShowPasswordOtpModel.value.message!);
        showPasswordOtpRefNumber.value = '';
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      showPasswordOtpRefNumber.value = '';
      return false;
    }
  }

  // Resend show password otp
  Rx<ShowPasswordOtpModel> resendShowPasswordOtpModel = ShowPasswordOtpModel().obs;
  Future<bool> resendShowPasswordOtp({bool isLoaderShow = true}) async {
    try {
      resendShowPasswordOtpModel.value = await offlineTokenRepository.resendShowPasswordOtpApiCall(
        params: {
          'otpRefNumber': generateShowPasswordOtpModel.value.otpRefNumber,
          'channels': channelID,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (resendShowPasswordOtpModel.value.statusCode == 1) {
        showPasswordOtpRefNumber.value =
            resendShowPasswordOtpModel.value.refNumber != null && resendShowPasswordOtpModel.value.refNumber!.isNotEmpty ? resendShowPasswordOtpModel.value.refNumber!.toString() : '';
        return true;
      } else {
        errorSnackBar(message: resendShowPasswordOtpModel.value.message!);
        showPasswordOtpRefNumber.value = '';
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      showPasswordOtpRefNumber.value = '';
      return false;
    }
  }

  // Validate show password otp
  Rx<ValidateShowPasswordOtpModel> validateShowPasswordOtpModel = ValidateShowPasswordOtpModel().obs;
  Future<bool> validateShowPasswordOtp({required String uniqueId, bool isLoaderShow = true}) async {
    try {
      validateShowPasswordOtpModel.value = await offlineTokenRepository.validateShowPasswordOtpApiCall(
        params: {
          'unqId': uniqueId,
          'otp': showPasswordOtp.value,
          'refNum': showPasswordOtpRefNumber.value,
          'channels': channelID,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (validateShowPasswordOtpModel.value.statusCode == 1) {
        return true;
      } else {
        errorSnackBar(message: validateShowPasswordOtpModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //////////////////////
  /// Reset Password ///
  //////////////////////
  // Generate reset password request
  Rx<SuccessModel> generateResetPasswordRequestModel = SuccessModel().obs;
  Future<bool> generateResetPasswordRequest({required String uniqueId, bool isLoaderShow = true}) async {
    try {
      generateResetPasswordRequestModel.value = await offlineTokenRepository.generateResetPasswordRequestApiCall(
        uniqueId: uniqueId,
        params: {
          'channel': channelID,
        },
        isLoaderShow: isLoaderShow,
      );
      if (generateResetPasswordRequestModel.value.statusCode == 1) {
        return true;
      } else {
        errorSnackBar(message: generateResetPasswordRequestModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  /////////////////////
  /// Pancard Token ///
  /////////////////////

  TextEditingController selectedTokenTypeController = TextEditingController();
  RxString selectedTokenDescription = ''.obs;

  ///////////////////////////////
  /// Digital Signature Token ///
  ///////////////////////////////

  TextEditingController selectedCompanyNameController = TextEditingController();
  TextEditingController selectedProductNameController = TextEditingController();
  RxString selectedProductDescription = ''.obs;

  ////////////////////
  /// Order Report ///
  ///////////////////

  String formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('dd MMM, yyyy hh:mm a');
    return formatter.format(dateTime);
  }

  // Converting integer status into string
  String orderReportStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Rejected';
    } else if (intStatus == 1) {
      status = 'Pending';
    } else if (intStatus == 3) {
      status = 'Success';
    }
    return status;
  }

  // Get report of purchase token
  RxList<OrderListData> purchaseOrderReportList = <OrderListData>[].obs;
  RxInt tokenReportCurrentPage = 1.obs;
  RxInt tokenReportTotalPages = 1.obs;
  RxBool tokenReportHasNext = false.obs;
  RxBool isOfflineTokenPurchaseReportListLoading = false.obs;
  Future<void> getPurchaseTokenReport({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      OrderReportModel orderReportModel = await offlineTokenRepository.getPurchaseTokenReportApiCall(
        subCategoryID: subCategoryId.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (orderReportModel.statusCode == 1) {
        if (orderReportModel.pagination!.currentPage == 1) {
          purchaseOrderReportList.clear();
        }
        if (orderReportModel.data != null && orderReportModel.data!.isNotEmpty) {
          for (OrderListData element in orderReportModel.data!) {
            purchaseOrderReportList.add(element);
          }
        }
        if (orderReportModel.pagination != null) {
          tokenReportCurrentPage.value = orderReportModel.pagination!.currentPage!;
          tokenReportTotalPages.value = orderReportModel.pagination!.totalPages!;
          tokenReportHasNext.value = orderReportModel.pagination!.hasNext!;
        }
      } else if (orderReportModel.statusCode == 0) {
        purchaseOrderReportList.clear();
        Future.delayed(const Duration(milliseconds: 500), () {
          tokenReportCurrentPage.value = 1;
          tokenReportTotalPages.value = 1;
          tokenReportHasNext.value = false;
        });
      } else {
        purchaseOrderReportList.clear();
        tokenReportCurrentPage.value = 1;
        tokenReportTotalPages.value = 1;
        tokenReportHasNext.value = false;
        errorSnackBar(message: orderReportModel.message);
      }
    } catch (e) {
      dismissProgressIndicator();
    } finally {
      dismissProgressIndicator();
      Future.delayed(const Duration(milliseconds: 500), () {
        isOfflineTokenPurchaseReportListLoading.value = false;
      });
    }
  }
}

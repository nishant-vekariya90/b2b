import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../api/api_manager.dart';
import '../model/dispute_category_model.dart';
import '../model/dispute_child_category_model.dart';
import '../model/dispute_sub_category_model.dart';
import '../model/id_card_model.dart';
import '../model/report/login_report_model.dart';
import '../model/report/raised_ticket_model.dart';
import '../model/setting/change_password_tpin_model.dart';
import '../model/website_content_model.dart';
import '../repository/setting_repository.dart';
import '../utils/string_constants.dart';
import '../widgets/constant_widgets.dart';

class SettingController extends GetxController {
  SettingRepository settingRepository = SettingRepository(APIManager());
  RxList<LoginReportData> loginReportList = <LoginReportData>[].obs;

  ///////////////////////
  /// Change password ///
  ///////////////////////
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RxBool isHideOldPassword = true.obs;
  RxBool isHideNewPassword = true.obs;
  RxBool isHideConfirmPassword = true.obs;
  RxString refNumber = ''.obs;
  Rx<File> transactionSlipFile = File('').obs;
  Rx<File> raisedDocumentFile = File('').obs;

  // For change password otp verification
  RxString changePasswordOtp = ''.obs;
  RxString changePasswordAutoOtp = ''.obs;
  Timer? changePasswordOtpResendTimer;
  RxInt changePasswordOtpTotalSecond = 120.obs;
  RxBool clearChangePasswordOtp = false.obs;
  RxBool isChangePasswordResendButtonShow = false.obs;

  // Verify/Resend change password otp timer
  startChangePasswordOtpTimer() {
    changePasswordOtpResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      changePasswordOtpTotalSecond.value--;
      if (changePasswordOtpTotalSecond.value == 0) {
        changePasswordOtpResendTimer!.cancel();
        isChangePasswordResendButtonShow.value = true;
      }
    });
  }

  // Reset change password otp timer
  resetChangePasswordOtpTimer() {
    changePasswordOtp.value = '';
    changePasswordAutoOtp.value = '';
    changePasswordOtpResendTimer!.cancel();
    changePasswordOtpTotalSecond.value = 120;
    clearChangePasswordOtp.value = true;
    isChangePasswordResendButtonShow.value = false;
  }

  // Send otp for change password
  Future<bool> sendOtpForChangePassword({bool isLoaderShow = true}) async {
    try {
      ChangePasswordTPINModel changePasswordModel = await settingRepository.changePasswordApiCall(
        params: {
          'currentPassword': oldPasswordController.text,
          'newPassword': newPasswordController.text,
          'confirmPassword': confirmPasswordController.text,
        },
        isLoaderShow: isLoaderShow,
      );
      if (changePasswordModel.statusCode == 1) {
        refNumber.value = changePasswordModel.refNumber!;
        successSnackBar(message: changePasswordModel.message);
        return true;
      } else {
        errorSnackBar(message: changePasswordModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Resend otp for change password
  Future<bool> resendOtpForChangePassword({bool isLoaderShow = true}) async {
    try {
      ChangePasswordTPINModel changePasswordModel = await settingRepository.changePasswordApiCall(
        params: {
          'currentPassword': oldPasswordController.text,
          'newPassword': newPasswordController.text,
          'confirmPassword': confirmPasswordController.text,
        },
        isLoaderShow: isLoaderShow,
      );
      if (changePasswordModel.statusCode == 1) {
        refNumber.value = changePasswordModel.refNumber!;
        clearChangePasswordOtp.value = true;
        successSnackBar(message: changePasswordModel.message);
        return true;
      } else {
        errorSnackBar(message: changePasswordModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Confirm otp for password
  Future<bool> confirmOtpForChangePassword({bool isLoaderShow = true}) async {
    try {
      ChangePasswordTPINModel changePasswordModel = await settingRepository.changePasswordConfirmApiCall(
        params: {
          'currentPassword': oldPasswordController.text,
          'newPassword': newPasswordController.text,
          'confirmPassword': confirmPasswordController.text,
          'refNumber': refNumber.value,
          'otp': changePasswordOtp.value,
        },
        isLoaderShow: isLoaderShow,
      );
      if (changePasswordModel.statusCode == 1) {
        Get.back();
        successSnackBar(message: changePasswordModel.message);
        return true;
      } else {
        errorSnackBar(message: changePasswordModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  ///////////////////
  /// Change tpin ///
  ///////////////////
  TextEditingController oldTPinController = TextEditingController();
  TextEditingController newTPinController = TextEditingController();
  TextEditingController confirmTPinController = TextEditingController();
  RxBool isHideOldTPin = true.obs;
  RxBool isHideNewTPin = true.obs;
  RxBool isHideConfirmTPin = true.obs;

  // For change tpin otp verification
  RxString changeTpinOtp = ''.obs;
  RxString changeTpinAutoOtp = ''.obs;
  Timer? changeTpinOtpResendTimer;
  RxInt changeTpinOtpTotalSecond = 120.obs;
  RxBool clearChangeTpinOtp = false.obs;
  RxBool isChangeTpinResendButtonShow = false.obs;

  // Verify/Resend change tpin otp timer
  startChangeTpinOtpTimer() {
    changeTpinOtpResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      changeTpinOtpTotalSecond.value--;
      if (changeTpinOtpTotalSecond.value == 0) {
        changeTpinOtpResendTimer!.cancel();
        isChangeTpinResendButtonShow.value = true;
      }
    });
  }

  // Reset change tpin otp timer
  resetChangeTpinOtpTimer() {
    changeTpinOtp.value = '';
    changeTpinAutoOtp.value = '';
    changeTpinOtpResendTimer!.cancel();
    changeTpinOtpTotalSecond.value = 120;
    clearChangeTpinOtp.value = true;
    isChangeTpinResendButtonShow.value = false;
  }

  // Send otp for change tpin
  Future<bool> sendOtpForChangeTpin({bool isLoaderShow = true}) async {
    try {
      ChangePasswordTPINModel changePasswordModel = await settingRepository.changeTPINApiCall(
        params: {
          'currentTPIN': oldTPinController.text,
          'newTPIN': newTPinController.text,
          'confirmTPIN': confirmTPinController.text,
        },
        isLoaderShow: isLoaderShow,
      );
      if (changePasswordModel.statusCode == 1) {
        refNumber.value = changePasswordModel.refNumber!;
        successSnackBar(message: changePasswordModel.message);
        return true;
      } else {
        errorSnackBar(message: changePasswordModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Resend otp for change tpin
  Future<bool> resendOtpForChangeTpin({bool isLoaderShow = true}) async {
    try {
      ChangePasswordTPINModel changePasswordModel = await settingRepository.changeTPINApiCall(
        params: {
          'currentTPIN': oldTPinController.text,
          'newTPIN': newTPinController.text,
          'confirmTPIN': confirmTPinController.text,
        },
        isLoaderShow: isLoaderShow,
      );
      if (changePasswordModel.statusCode == 1) {
        refNumber.value = changePasswordModel.refNumber!;
        clearChangeTpinOtp.value = true;
        successSnackBar(message: changePasswordModel.message);
        return true;
      } else {
        errorSnackBar(message: changePasswordModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Confirm otp for tpin
  Future<bool> confirmOtpForChangeTpin({bool isLoaderShow = true}) async {
    try {
      ChangePasswordTPINModel changeTpinModel = await settingRepository.changeTPINConfirmApiCall(
        params: {
          'currentTPIN': oldTPinController.text,
          'newTPIN': newTPinController.text,
          'confirmTPIN': confirmTPinController.text,
          'refNumber': refNumber.value,
          'otp': changeTpinOtp.value,
        },
        isLoaderShow: isLoaderShow,
      );
      if (changeTpinModel.statusCode == 1) {
        Get.back();
        successSnackBar(message: changeTpinModel.message);
        return true;
      } else {
        errorSnackBar(message: changeTpinModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Clear change password variables
  clearChangeTpinVariables() {
    oldTPinController.clear();
    newTPinController.clear();
    confirmTPinController.clear();
    isHideOldTPin.value = true;
    isHideNewTPin.value = true;
    isHideConfirmTPin.value = true;
  }

  ///////////////////
  /// Forgot tpin ///
  ///////////////////
  TextEditingController newForgotTpinController = TextEditingController();
  TextEditingController confirmForgotTpinController = TextEditingController();
  TextEditingController forgotOTPController = TextEditingController();
  RxString otpRefNumber = ''.obs;

  // Send otp for forgot tpin
  Future<bool> sendOtpForForgotTpin({bool isLoaderShow = true}) async {
    try {
      ChangePasswordTPINModel changePasswordModel = await settingRepository.forgotTPINApiCall(
        params: {'channel': channelID},
        isLoaderShow: isLoaderShow,
      );
      if (changePasswordModel.statusCode == 1) {
        otpRefNumber.value = changePasswordModel.refNumber!;
        successSnackBar(message: changePasswordModel.message);
        return true;
      } else {
        errorSnackBar(message: changePasswordModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Confirm forgot otp for tpin
  Future<bool> confirmOtpForForgotTpin({bool isLoaderShow = true}) async {
    try {
      ChangePasswordTPINModel forgotTpinModel = await settingRepository.forgotTPINConfirmApiCall(
        params: {
          'newTPIN': newForgotTpinController.text,
          'confirmTPIN': confirmForgotTpinController.text,
          'refNumber': otpRefNumber.value,
          'otp': forgotOTPController.text,
        },
        isLoaderShow: isLoaderShow,
      );
      if (forgotTpinModel.statusCode == 1) {
        Get.back();
        successSnackBar(message: forgotTpinModel.message);
        return true;
      } else {
        errorSnackBar(message: forgotTpinModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Clear change password variables
  clearForgotTpinVariables() {
    newForgotTpinController.clear();
    confirmForgotTpinController.clear();
    forgotOTPController.clear();
    isHideOldTPin.value = true;
    isHideNewTPin.value = true;
    isHideConfirmTPin.value = true;
  }

  //for Raised complaints
  RxList<DisputeCategoryModel> disputeCategoryList = <DisputeCategoryModel>[].obs;
  RxList<DisputeSubCategoryModel> disputeSubCategoryList = <DisputeSubCategoryModel>[].obs;
  RxList<DisputeChildCategoryModel> disputeChildCategoryList = <DisputeChildCategoryModel>[].obs;
  TextEditingController messageTxtController = TextEditingController();
  TextEditingController transactionIdTxtController = TextEditingController();
  TextEditingController disputeCategoryController = TextEditingController();
  TextEditingController disputeSubCategoryController = TextEditingController();
  TextEditingController disputeChildCategoryController = TextEditingController();

  RxInt selectedCategory = 0.obs;
  RxInt selectedSubCategory = 0.obs;
  RxInt selectedChildCategory = 0.obs;

  RxList priorityList = ["Low", "Medium", "High", "Server"].obs;
  RxString selectedPriority = 'Select priority'.obs;

  int ticketPriority(String priority) {
    int status = 0;
    if (priority == "Low") {
      status = 0;
    } else if (priority == "Medium") {
      status = 1;
    } else if (priority == "High") {
      status = 2;
    } else if (priority == "Server") {
      status = 3;
    }
    return status;
  }

  clearRaiseComplaintVariables() {
    disputeCategoryController.clear();
    selectedCategory.value = 0;
    disputeSubCategoryController.clear();
    selectedSubCategory.value = 0;
    disputeChildCategoryController.clear();
    selectedChildCategory.value = 0;
    selectedPriority.value = 'Select priority';
    raisedDocumentFile.value = File('');
    transactionIdTxtController.clear();
    messageTxtController.clear();
  }

  // Get Dispute category list
  Future<bool> getDisputeCategoryApi({bool isLoaderShow = true}) async {
    try {
      List<DisputeCategoryModel> categoryListModel = await settingRepository.getDisputeCategoryApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (categoryListModel.isNotEmpty) {
        disputeCategoryList.clear();
        for (DisputeCategoryModel element in categoryListModel) {
          if (element.name != null && element.name!.isNotEmpty) {
            disputeCategoryList.add(element);
          }
        }
        disputeCategoryList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        return true;
      } else {
        disputeCategoryList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get Dispute category list
  Future<bool> getDisputeChildCategoryApi({bool isLoaderShow = true}) async {
    try {
      List<DisputeChildCategoryModel> categoryListModel = await settingRepository.getDisputeChildCategoryApiCall(isLoaderShow: isLoaderShow, disputeSubCategoryId: selectedSubCategory.value);
      if (categoryListModel.isNotEmpty) {
        disputeChildCategoryList.clear();
        for (DisputeChildCategoryModel element in categoryListModel) {
          if (element.name != null && element.name!.isNotEmpty) {
            disputeChildCategoryList.add(element);
          }
        }
        disputeCategoryList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        return true;
      } else {
        disputeCategoryList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get Dispute sub category list
  Future<bool> getDisputeSubCategoryApi({bool isLoaderShow = true}) async {
    try {
      List<DisputeSubCategoryModel> subCategoryListModel = await settingRepository.getDisputeSubCategoryApiCall(isLoaderShow: isLoaderShow, disputeCategoryId: selectedCategory.value);
      if (subCategoryListModel.isNotEmpty) {
        disputeSubCategoryList.clear();
        for (DisputeSubCategoryModel element in subCategoryListModel) {
          if (element.name != null && element.name!.isNotEmpty) {
            disputeSubCategoryList.add(element);
          }
        }
        disputeSubCategoryList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        return true;
      } else {
        disputeSubCategoryList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> raiseComplaintAPI({bool isLoaderShow = true}) async {
    try {
      RaisedTicketModel raisedTicketModel = await settingRepository.raisedComplaintApiCall(isLoaderShow: isLoaderShow, params: {
        "type": disputeSubCategoryController.text,
        "subject": disputeChildCategoryController.text,
        "priority": ticketPriority(selectedPriority.value),
        "ticketMessage": messageTxtController.text,
        "orderID": transactionIdTxtController.text.isNotEmpty ? transactionIdTxtController.text : null,
        "fileBytes": raisedDocumentFile.value.path.isNotEmpty ? await convertFileToBase64(raisedDocumentFile.value) : null,
        "fileBytesFormat": raisedDocumentFile.value.path.isNotEmpty ? extension(raisedDocumentFile.value.path) : null,
      });
      if (raisedTicketModel.statusCode == 1) {
        successSnackBar(message: raisedTicketModel.message);
        return true;
      } else {
        errorSnackBar(message: raisedTicketModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  String formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('dd MMM, hh:mm a');
    return formatter.format(dateTime);
  }

  //for login report

  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;

  TextEditingController searchReportTxtController = TextEditingController();

  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;

  Future<bool> getLoginReportApi({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      LoginReportModel loginReportModel = await settingRepository.loginReportApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (loginReportModel.status == 1) {
        if (loginReportModel.pagination!.currentPage == 1) {
          loginReportList.clear();
        }
        for (LoginReportData element in loginReportModel.data!) {
          loginReportList.add(element);
        }
        currentPage.value = loginReportModel.pagination!.currentPage!;
        totalPages.value = loginReportModel.pagination!.totalPages!;
        hasNext.value = loginReportModel.pagination!.hasNext!;
        return true;
      } else if (loginReportModel.status == 0) {
        loginReportList.clear();
        return true;
      } else {
        loginReportList.clear();
        errorSnackBar(message: loginReportModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  clearChangeTpinController() {
    oldTPinController.clear();
    newTPinController.clear();
    confirmTPinController.clear();
    isHideOldTPin.value = true;
    isHideNewTPin.value = true;
    isHideConfirmTPin.value = true;
    changePasswordOtp.value = '';
  }

  Rx<WebsiteContentModel> websiteContentModel = WebsiteContentModel().obs;
  RxString address = ''.obs;
  RxString supportNo = ''.obs;
  RxString supportEmail = ''.obs;

  // Get website content
  Future<bool> getWebsiteContent({required int contentType, bool isLoaderShow = true}) async {
    try {
      List<WebsiteContentModel> websiteContentModel = await settingRepository.getWebsiteContentApiCall(
        contentType: contentType,
        isLoaderShow: isLoaderShow,
      );
      if (websiteContentModel.isNotEmpty) {
        this.websiteContentModel.value = websiteContentModel.first;
        //For contact us
        if (contentType == 0) {
          for (var element in websiteContentModel) {
            if (element.name!.toLowerCase() == 'address') {
              address.value = element.value!;
            } else if (element.name!.toLowerCase() == 'support no') {
              supportNo.value = element.value!;
            } else if (element.name!.toLowerCase() == 'support email') {
              supportEmail.value = element.value!;
            }
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get website content
  Rx<IdCardModel> idCardModel = IdCardModel().obs;
  RxString idCard = ''.obs;
  RxBool isIdCardLoad = false.obs;
  Future<bool> getIdCard({bool isLoaderShow = true}) async {
    try {
      List<IdCardModel> idCardModelRes = await settingRepository.getIdCardApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (idCardModelRes.isNotEmpty) {
        for (IdCardModel element in idCardModelRes) {
          if (element.id! == 2) {
            idCardModel.value = element;
            idCard.value = element.htmlBody!;
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}

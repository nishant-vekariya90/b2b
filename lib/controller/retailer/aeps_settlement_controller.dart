import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../../api/api_manager.dart';
import '../../model/aeps_settlement/add_aeps_bank_model.dart';
import '../../model/aeps_settlement/aeps_bank_list_model.dart';
import '../../model/aeps_settlement/aeps_settlement_history_model.dart';
import '../../model/aeps_settlement/aeps_settlement_request_model.dart';
import '../../model/aeps_settlement/payment_mode_model.dart';
import '../../model/aeps_settlement/settlement_account_verification_model.dart';
import '../../model/aeps_settlement/withdrwal_limit_model.dart';
import '../../model/kyc/kyc_bank_list_model.dart';
import '../../repository/retailer/aeps_settlement_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class AepsSettlementController extends GetxController {
  AepsSettlementRepository aepsSettlementRepository = AepsSettlementRepository(APIManager());

  String formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('dd MMM, hh:mm a');
    return formatter.format(dateTime);
  }

  String formatDateTimeNormal(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(dateTime);
  }

  RxString selectedBankPaymentMethodRadio = 'Bank'.obs;
  TextEditingController accountHolderNameBankController = TextEditingController();
  TextEditingController accountHolderNameUpiController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  RxString selectedAccountTypeRadio = 'Current'.obs;
  TextEditingController bankNameController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();
  TextEditingController bankRemarksController = TextEditingController();
  TextEditingController tpinController = TextEditingController();
  RxBool isShowTpin = true.obs;
  Rx<File> bankChequeFile = File('').obs;
  RxString bankChequeRejectedFile = ''.obs;
  RxBool isAccountVerify = false.obs;
  String? mobileNum = GetStorage().read(mobileNumber);

  // Reset aeps settlement bank variables
  resetAepsSettlementBankVariables() {
    selectedBankPaymentMethodRadio.value = 'Bank';
    accountHolderNameBankController.clear();
    accountHolderNameUpiController.clear();
    accountNumberController.clear();
    selectedAccountTypeRadio.value = 'Current';
    bankNameController.clear();
    ifscCodeController.clear();
    upiIdController.clear();
    bankRemarksController.clear();
    remarksController.clear();
    bankChequeFile.value = File('');
    isAccountVerify.value = false;
    settlementAccountVerificationModel.value.name = "";
    bankChequeRejectedFile.value = "";
  }



  // Verify account number api
  Rx<SettlementAccountVerificationModel> settlementAccountVerificationModel = SettlementAccountVerificationModel().obs;
  Future<bool> verifyAccount({bool isLoaderShow = true}) async {
    try {
      settlementAccountVerificationModel.value = await aepsSettlementRepository.accountVerificationApiCall(
        params: {
          'mobileNo': mobileNum,
          'accountNo': accountNumberController.text.trim(),
          'bankName': bankNameController.text.trim(),
          'ifscCode': ifscCodeController.text.trim(),
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'channel':2
        },
        isLoaderShow: isLoaderShow,
      );
      if (settlementAccountVerificationModel.value.statusCode == 1) {
        isAccountVerify.value = true;
        return true;
      } else {
        isAccountVerify.value = false;
        errorSnackBar(message: settlementAccountVerificationModel.value.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  RxList<KYCBankListModel> bankList = <KYCBankListModel>[].obs;

  Future<bool> getBankListApi({bool isLoaderShow = true}) async {
    try {
      List<KYCBankListModel> response = await aepsSettlementRepository.bankListApiCall(isLoaderShow: isLoaderShow);
      if (response.isNotEmpty) {
        bankList.clear();
        for (var element in response) {
          bankList.add(element);
        }
        return true;
      } else {
        bankList.clear();
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get withdrwal limit
  RxDouble withdrwalLimit = 0.00.obs;

  Future<void> getWithdrwalLimit({bool isLoaderShow = true}) async {
    try {
      WithdrwalLimitModel withdrwalLimitModel = await aepsSettlementRepository.getWithdrwalLimitApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (withdrwalLimitModel.statusCode == 1) {
        if (withdrwalLimitModel.currentWithdrawalLimit != null && withdrwalLimitModel.currentWithdrawalLimit!.isNotEmpty) {
          withdrwalLimit.value = double.parse(withdrwalLimitModel.currentWithdrawalLimit!);
        }
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Get payment mode list
  Future<bool> getPaymentModeList({bool isLoaderShow = true}) async {
    try {
      List<PaymentModeModel> masterBankListModel = await aepsSettlementRepository.paymentModeApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (masterBankListModel.isNotEmpty) {
        masterPaymentModeList.clear();
        for (PaymentModeModel element in masterBankListModel) {
          if (element.status == 1) {
            masterPaymentModeList.add(element.name!);
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

  // Add aeps settlement bank
  Future<bool> addAepsSettlementBank({bool isLoaderShow = true}) async {
    try {
      AddAepsBankModel addAepsBankModel = await aepsSettlementRepository.addAepsBankApiCall(
        params: {
          'method': selectedBankPaymentMethodRadio.value == 'Bank' ? 0 : 1,
          'acHolderName': selectedBankPaymentMethodRadio.value == 'Bank' ? accountHolderNameBankController.text.trim() : accountHolderNameUpiController.text.trim(),
          'accountType': selectedBankPaymentMethodRadio.value == 'Bank'
              ? selectedAccountTypeRadio.value == 'Current'
                  ? 0
                  : 1
              : null,
          'accountNumber': selectedBankPaymentMethodRadio.value == 'Bank' ? accountNumberController.text.trim() : null,
          'bankName': selectedBankPaymentMethodRadio.value == 'Bank' ? bankNameController.text.trim() : null,
          'ifsC_Code': selectedBankPaymentMethodRadio.value == 'Bank' ? ifscCodeController.text.trim() : null,
          'fileBytes': bankChequeFile.value.path.isNotEmpty ? await convertFileToBase64(bankChequeFile.value) : null,
          'fileBytesFormat': bankChequeFile.value.path.isNotEmpty ? extension(bankChequeFile.value.path) : null,
          'upiid': selectedBankPaymentMethodRadio.value == 'UPI' ? upiIdController.text.trim() : null,
          'createRemark': selectedBankPaymentMethodRadio.value == 'Bank' ? bankRemarksController.text : remarksController.text.trim(),
          'isVerified': selectedBankPaymentMethodRadio.value == 'Bank' ? isAccountVerify.value : false,
          'verifiedValue': selectedBankPaymentMethodRadio.value == 'Bank' ? settlementAccountVerificationModel.value.name : null
        },
        isLoaderShow: isLoaderShow,
      );
      if (addAepsBankModel.statusCode == 1) {
        await getAepsBankList(pageNumber: 1, isLoaderShow: false);
        Get.back();
        successSnackBar(message: addAepsBankModel.message!);
        return true;
      } else {
        errorSnackBar(message: addAepsBankModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  RxInt selectedTabIndex = 0.obs;
  RxList<AepsBankListModel> allAepsBankList = <AepsBankListModel>[].obs;
  RxList<AepsBankListModel> allAepsUpiList = <AepsBankListModel>[].obs;
  RxList<AepsBankListModel> successAepsBankList = <AepsBankListModel>[].obs;
  RxList<AepsBankListModel> successAepsUpiList = <AepsBankListModel>[].obs;

  String appType = GetStorage().read(loginTypeKey);

  // Get aeps bank/upi list
  Future<void> getAepsBankList({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      AepsBankModel aepsBankListModel = await aepsSettlementRepository.getAepsBankListApiCall(
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (aepsBankListModel.statusCode == 1) {
        if (aepsBankListModel.pagination!.currentPage == 1) {
          allAepsBankList.clear();
          successAepsBankList.clear();
          allAepsUpiList.clear();
          successAepsUpiList.clear();
        }
        if (aepsBankListModel.data != null && aepsBankListModel.data!.isNotEmpty) {
          for (AepsBankListModel element in aepsBankListModel.data!) {
            if (appType == 'Retailer') {
              if (element.method == 0) {
                allAepsBankList.add(element);
                if (element.status == 1) {
                  successAepsBankList.add(element);
                }
              } else if (element.method == 1) {
                allAepsUpiList.add(element);
                if (element.status == 1) {
                  successAepsUpiList.add(element);
                }
              }
            } else {
              if (element.method == 0) {
                allAepsBankList.add(element);
                if (element.status == 2) {
                  successAepsBankList.add(element);
                }
              } else if (element.method == 1) {
                allAepsUpiList.add(element);
                if (element.status == 2) {
                  successAepsUpiList.add(element);
                }
              }
            }
          }
        }
        if (aepsBankListModel.pagination != null) {
          currentPage.value = aepsBankListModel.pagination!.currentPage!;
          totalPages.value = aepsBankListModel.pagination!.totalPages!;
          hasNext.value = aepsBankListModel.pagination!.hasNext!;
        }
        allAepsBankList.sort((a, b) => a.bankName!.toLowerCase().compareTo(b.bankName!.toLowerCase()));
        allAepsUpiList.sort((a, b) => a.upiid!.toLowerCase().compareTo(b.upiid!.toLowerCase()));
        successAepsBankList.sort((a, b) => a.bankName!.toLowerCase().compareTo(b.bankName!.toLowerCase()));
        successAepsUpiList.sort((a, b) => a.upiid!.toLowerCase().compareTo(b.upiid!.toLowerCase()));
      } else if (aepsBankListModel.statusCode == 0) {
        allAepsBankList.clear();
        allAepsUpiList.clear();
        successAepsBankList.clear();
        successAepsUpiList.clear();
        currentPage.value = 1;
        totalPages.value = 1;
        hasNext.value = false;
      } else {
        allAepsBankList.clear();
        allAepsUpiList.clear();
        successAepsBankList.clear();
        successAepsUpiList.clear();
        currentPage.value = 1;
        totalPages.value = 1;
        hasNext.value = false;
        errorSnackBar(message: aepsBankListModel.message);
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  ////////////////////
  /// Aeps Request ///
  ////////////////////

  Rx<AepsSettlementRequestModel> aepsSettlementRequestModel = AepsSettlementRequestModel().obs;
  RxString selectedPaymentMethodRadio = 'Bank'.obs;
  List<String> masterPaymentModeList = [];
  TextEditingController selectedBankNameController = TextEditingController();
  TextEditingController bankIdController = TextEditingController();
  TextEditingController paymentModeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  RxString amountIntoWords = ''.obs;

  // Reset aeps settlement bank variables
  resetAepsSettlementRequestVariables() {
    selectedPaymentMethodRadio.value = 'Bank';
    selectedBankNameController.clear();
    bankIdController.clear();
    upiIdController.clear();
    paymentModeController.clear();
    amountController.clear();
    amountIntoWords.value = '';
    remarksController.clear();
    tpinController.clear();
  }

  // converting integer status into string
  String ticketStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Rejected';
    } else if (intStatus == 1) {
      status = 'Approved';
    } else if (intStatus == 2) {
      status = 'Pending';
    }
    return status;
  }

  // Aeps settlement request
  // for to bank withdrawalMode=0
  // for to direct bank withdrawalMode=1
  // for to wallet withdrawalMode=2
  Future<bool> aepsSettlementRequest({required int withdrawalMode, bool isLoaderShow = true}) async {
    try {
      aepsSettlementRequestModel.value = await aepsSettlementRepository.aepsSettlementRequestApiCall(
        params: {
          'amount': amountController.text.trim(),
          'paymentType': paymentModeController.text.trim(),
          'withdrawalMode': withdrawalMode,
          'settlementBankID': withdrawalMode == 0 || withdrawalMode == 1
              ? selectedPaymentMethodRadio.value == 'Bank'
                  ? bankIdController.text.trim()
                  : upiIdController.text.trim()
              : null,
          'remarks': remarksController.text.trim(),
          'channel': channelID,
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'tpin': tpinController.text.isNotEmpty ? tpinController.text.trim() : null,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (aepsSettlementRequestModel.value.statusCode == 1) {
        successSnackBar(message: aepsSettlementRequestModel.value.message!);
        return true;
      } else if (aepsSettlementRequestModel.value.statusCode == 2) {
        successSnackBar(message: aepsSettlementRequestModel.value.message!);
        return true;
      } else {
        errorSnackBar(message: aepsSettlementRequestModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  ////////////////////
  /// Aeps History ///
  ////////////////////
  RxList<AepsSettlementHistoryData> aepsSettlementHistoryList = <AepsSettlementHistoryData>[].obs;

  // Get aeps settlement history list
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;

  Future<bool> getAepsSettlementHistory({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      AepsSettlementHistoryModel aepsSettlementHistoryModel = await aepsSettlementRepository.getAepsSettlementHistoryListApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (aepsSettlementHistoryModel.status == 1) {
        if (aepsSettlementHistoryModel.pagination!.currentPage == 1) {
          aepsSettlementHistoryList.clear();
        }
        for (AepsSettlementHistoryData element in aepsSettlementHistoryModel.data!) {
          aepsSettlementHistoryList.add(element);
        }
        currentPage.value = aepsSettlementHistoryModel.pagination!.currentPage!;
        totalPages.value = aepsSettlementHistoryModel.pagination!.totalPages!;
        hasNext.value = aepsSettlementHistoryModel.pagination!.hasNext!;
        return true;
      } else if (aepsSettlementHistoryModel.status == 0) {
        aepsSettlementHistoryList.clear();
        return false;
      } else {
        aepsSettlementHistoryList.clear();
        errorSnackBar(message: aepsSettlementHistoryModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}

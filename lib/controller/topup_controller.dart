import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import '../api/api_manager.dart';
import '../model/master/bank_list_model.dart';
import '../model/topup/topup_history_model.dart';
import '../model/topup/topup_request_model.dart';
import '../repository/topup_repository.dart';
import '../widgets/constant_widgets.dart';

class TopupController extends GetxController {
  TopupRepository topupRepository = TopupRepository(APIManager());

  // Topup Request Section
  RxList<String> toRequestList = <String>[].obs;
  RxList<MasterBankListModel> masterBankListByUser = <MasterBankListModel>[].obs;
  RxList<MasterBankListModel> masterBankListByAdmin = <MasterBankListModel>[].obs;
  List<String> masterPaymentModeList = ['Cash', 'Cheque', 'RTGS', 'NEFT', 'Fund Transfer', 'IMPS'];

  // Observables for form fields and validation
  RxString selectedUserTypeRadio = 'Parent'.obs;
  TextEditingController depositBankController = TextEditingController();
  RxInt selectedBankId = 0.obs;
  TextEditingController amountController = TextEditingController();
  TextEditingController userRemarkController = TextEditingController();
  TextEditingController paymentModeController = TextEditingController();
  RxString selectedPaymentMode = ''.obs;
  RxString selectedCashTypeRadio = 'CDM Machine'.obs;
  TextEditingController chequeNumberController = TextEditingController();
  TextEditingController utrController = TextEditingController();
  TextEditingController paymentDateController = TextEditingController();
  Rx<File> transactionSlipFile = File('').obs;
  Rx<TopupRequestModel> topupRequestModel = TopupRequestModel().obs;
  RxString amountIntoWords = ''.obs;
  RxInt topupRequestStatus = (-1).obs;

  // Get master bank list by user
  Future<bool> getRequestParentList({bool isLoaderShow = true}) async {
    try {
      List<String> checkParentList = await topupRepository.checkParentApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (checkParentList.isNotEmpty) {
        toRequestList.clear();
        for (String element in checkParentList) {
          if (element == 'parent') {
            toRequestList.add('Parent');
          }
          if (element == 'administrator') {
            toRequestList.add('Administrator');
          }
        }
        selectedUserTypeRadio.value = toRequestList.first;
        return true;
      } else {
        toRequestList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get master bank list by user
  Future<bool> getMasterBankListByUser({bool isLoaderShow = true}) async {
    try {
      List<MasterBankListModel> masterBankListModel = await topupRepository.getBankListByUserApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (masterBankListModel.isNotEmpty) {
        masterBankListByUser.clear();
        masterBankListByUser.addAll(masterBankListModel.where((element) => element.isActive == true));
        masterBankListByUser.sort((a, b) => a.priority!.compareTo(b.priority!));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get master bank list by admin
  Future<bool> getMasterBankListByAdmin({bool isLoaderShow = true}) async {
    try {
      List<MasterBankListModel> masterBankListModel = await topupRepository.getBankListByAdminApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (masterBankListModel.isNotEmpty) {
        masterBankListByAdmin.clear();
        masterBankListByAdmin.addAll(masterBankListModel.where((element) => element.isActive == true));
        masterBankListByAdmin.sort((a, b) => a.priority!.compareTo(b.priority!));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Topup request
  Future<bool> topupRequest({bool isLoaderShow = true}) async {
    try {
      topupRequestModel.value = await topupRepository.topupRequestApiCall(
        params: {
          'requestUserType': selectedUserTypeRadio.value,
          'depositBankID': selectedBankId.value,
          'amount': amountController.text.trim(),
          'paymentMode': masterPaymentModeList.indexOf(selectedPaymentMode.value),
          'cashType': selectedPaymentMode.value == 'Cash' ? selectedCashTypeRadio.value : null,
          'chequeNo': selectedPaymentMode.value == 'Cheque' ? chequeNumberController.text.trim() : null,
          'userRemark': userRemarkController.text,
          'utR_No': selectedPaymentMode.value != 'Cash' && selectedPaymentMode.value != 'Cheque' ? utrController.text.trim() : null,
          'paymentDate': paymentDateController.text.trim(),
          'fileBytes': transactionSlipFile.value.path.isNotEmpty ? await convertFileToBase64(transactionSlipFile.value) : null,
          'fileBytesFormat': transactionSlipFile.value.path.isNotEmpty ? extension(transactionSlipFile.value.path) : null,
        },
        isLoaderShow: isLoaderShow,
      );
      if (topupRequestModel.value.statusCode == 1) {
        Get.back();
        successSnackBar(message: topupRequestModel.value.message!);
        return true;
      } else {
        errorSnackBar(message: topupRequestModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Reset topup request variables
  resetTopupRequestVariables() {
    selectedUserTypeRadio.value = toRequestList.first;
    depositBankController.clear();
    selectedBankId.value = 0;
    amountController.clear();
    amountIntoWords.value = '';
    paymentModeController.clear();
    selectedPaymentMode.value = '';
    selectedCashTypeRadio.value = 'CDM Machine';
    chequeNumberController.clear();
    utrController.clear();
    paymentDateController.clear();
    userRemarkController.clear();
    transactionSlipFile.value = File('');
  }

  /////////////////////
  /// Topup History ///
  /////////////////////

  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;
  RxList<TopupHistoryData> topupHistoryList = <TopupHistoryData>[].obs;

  String formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('dd MMM, yyyy');
    return formatter.format(dateTime);
  }

  String formatDateTimeNormal(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(dateTime);
  }

  String ticketStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Rejected';
    } else if (intStatus == 1) {
      status = 'Approved';
    } else if (intStatus == 2) {
      status = 'Pending';
    } else if (intStatus == 3) {
      status = 'Pending';
    }
    return status;
  }

  // Get topup history
  Future<bool> getTopupHistory({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      TopupHistoryModel topupHistoryModel = await topupRepository.getTopupHistoryApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (topupHistoryModel.status == 1) {
        if (topupHistoryModel.pagination!.currentPage == 1) {
          topupHistoryList.clear();
        }
        for (TopupHistoryData element in topupHistoryModel.data!) {
          topupHistoryList.add(element);
        }
        currentPage.value = topupHistoryModel.pagination!.currentPage!;
        totalPages.value = topupHistoryModel.pagination!.totalPages!;
        hasNext.value = topupHistoryModel.pagination!.hasNext!;
        return true;
      } else if (topupHistoryModel.status == 0) {
        topupHistoryList.clear();
        return true;
      } else {
        topupHistoryList.clear();
        errorSnackBar(message: topupHistoryModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}

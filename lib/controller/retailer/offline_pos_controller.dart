import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../api/api_manager.dart';
import '../../model/offline_pos/offline_pos_order_create_model.dart';
import '../../model/offline_pos/offline_pos_report_model.dart';
import '../../repository/retailer/offline_pos_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class OfflinePosController extends GetxController {
  OfflinePosRepository offlinePosRepository = OfflinePosRepository(APIManager());

  List<String> cardTypeList = ['CreditCard', 'DebitCard', 'AmexCard', 'DinnerCard', 'Other'];
  TextEditingController transactionRefNumberController = TextEditingController();
  TextEditingController cardTypeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  RxString amountIntoWords = ''.obs;
  TextEditingController transactionDateController = TextEditingController();
  Rx<File> transactionSlipFile = File('').obs;

  // Offline pos order create
  Rx<OfflinePosOrderCreateModel> offlinePosOrderCreateModel = OfflinePosOrderCreateModel().obs;
  Future<bool> offlinePosOrderCreate({bool isLoaderShow = true}) async {
    try {
      offlinePosOrderCreateModel.value = await offlinePosRepository.offlinePosOrderCreateApiCall(
        params: {
          'TxnRefNo': transactionRefNumberController.text.trim(),
          'CardType': cardTypeController.text.trim(),
          'Amount': amountController.text.trim(),
          'Date': transactionDateController.text.trim(),
          'IpAddress': ipAddress,
          'Channel': channelID,
        },
        fileKey: 'FileName',
        file: transactionSlipFile.value,
        isLoaderShow: isLoaderShow,
      );
      if (offlinePosOrderCreateModel.value.statusCode == 1) {
        successSnackBar(message: offlinePosOrderCreateModel.value.message!);
        return true;
      } else {
        errorSnackBar(message: offlinePosOrderCreateModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Reset offline pos variables
  resetOfflinePosVariables() {
    transactionRefNumberController.clear();
    cardTypeController.clear();
    amountController.clear();
    amountIntoWords.value = '';
    transactionDateController.clear();
    transactionSlipFile.value = File('');
  }

  // converting integer status into string
  String offlinePosReportStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Failed';
    } else if (intStatus == 1) {
      status = 'Success';
    } else if (intStatus == 2) {
      status = 'Pending';
    }
    return status;
  }

  // Format dateTime
  String formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(dateTime);
  }

  // Get offline pos report
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  RxList<OfflinePosReportData> offlinePosReportList = <OfflinePosReportData>[].obs;
  RxBool isOfflinePosReportLoading = false.obs;
  Future<void> getOfflinePosReport({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      OfflinePosReportModel offlinePosReportModel = await offlinePosRepository.getOfflinePosReportApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (offlinePosReportModel.statusCode == 1) {
        if (offlinePosReportModel.pagination!.currentPage == 1) {
          offlinePosReportList.clear();
        }
        if (offlinePosReportModel.data != null && offlinePosReportModel.data!.isNotEmpty) {
          for (OfflinePosReportData element in offlinePosReportModel.data!) {
            offlinePosReportList.add(element);
          }
        }
        if (offlinePosReportModel.pagination != null) {
          currentPage.value = offlinePosReportModel.pagination!.currentPage!;
          totalPages.value = offlinePosReportModel.pagination!.totalPages!;
          hasNext.value = offlinePosReportModel.pagination!.hasNext!;
        }
      } else if (offlinePosReportModel.statusCode == 0) {
        offlinePosReportList.clear();
        Future.delayed(const Duration(milliseconds: 500), () {
          resetOffliePosReportVariables();
        });
      } else {
        offlinePosReportList.clear();
        resetOffliePosReportVariables();
        errorSnackBar(message: offlinePosReportModel.message);
      }
    } catch (e) {
      dismissProgressIndicator();
    } finally {
      dismissProgressIndicator();
      Future.delayed(const Duration(milliseconds: 500), () {
        isOfflinePosReportLoading.value = false;
      });
    }
  }

  // Reset offline pos report variables
  resetOffliePosReportVariables() {
    currentPage.value = 1;
    totalPages.value = 1;
    hasNext.value = false;
  }
}

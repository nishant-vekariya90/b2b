import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../api/api_manager.dart';
import '../../model/payment/payment_model.dart';
import '../../model/payment/payment_status_update_model.dart';
import '../../repository/distributor/payment_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class PaymentController extends GetxController {
  PaymentRepository paymentRepository = PaymentRepository(APIManager());

  List<String> masterPaymentModeList = ['Cash', 'Cheque', 'RTGS', 'NEFT', 'Fund Transfer', 'IMPS'];
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;
  RxList<PaymentData> paymentRequestList = <PaymentData>[].obs;
  RxList<PaymentData> paymentHistoryList = <PaymentData>[].obs;
  RxBool isShowTpin = true.obs;
  TextEditingController tpinController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  String formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('dd MMM, yyyy, hh:mm a');
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
    }
    return status;
  }

  // Get payment request
  Future<bool> getPaymentRequest({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      PaymentModel paymentModel = await paymentRepository.getPaymentRequestApiCall(
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (paymentModel.status == 1) {
        if (paymentModel.pagination!.currentPage == 1) {
          paymentRequestList.clear();
        }
        for (PaymentData element in paymentModel.data!) {
          paymentRequestList.add(element);
        }
        currentPage.value = paymentModel.pagination!.currentPage!;
        totalPages.value = paymentModel.pagination!.totalPages!;
        hasNext.value = paymentModel.pagination!.hasNext!;
        return true;
      } else if (paymentModel.status == 0) {
        paymentRequestList.clear();
        return true;
      } else {
        paymentRequestList.clear();
        errorSnackBar(message: paymentModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Change payment status
  Future<bool> changePaymentStatus({required PaymentData paymentData, required int status, bool isLoaderShow = true}) async {
    try {
      PaymentStatusUpdateModel paymentStatusUpdateModel = await paymentRepository.changePaymentStatusApiCall(
        params: {
          'uniqueId': paymentData.uniqueId,
          'status': status,
          'utr': paymentData.utRNo,
          'comment': remarksController.text.trim(),
          'channel': channelID,
          'tpin': tpinController.text.isNotEmpty ? tpinController.text.trim() : null,
          'orderId': paymentData.id.toString(),
          'userID': null,
          'userName': paymentData.userName,
          'name': paymentData.createdBy,
          'ipAddress': ipAddress,
        },
        isLoaderShow: isLoaderShow,
      );
      if (paymentStatusUpdateModel.statusCode == 1) {
        await getPaymentRequest(pageNumber: 1, isLoaderShow: false);
        Get.back();
        successSnackBar(message: paymentStatusUpdateModel.message);
        return true;
      } else {
        errorSnackBar(message: paymentStatusUpdateModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get payment history
  Future<bool> getPaymentHistory({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      PaymentModel paymentModel = await paymentRepository.getPaymentHistoryApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (paymentModel.status == 1) {
        if (paymentModel.pagination!.currentPage == 1) {
          paymentHistoryList.clear();
        }
        for (PaymentData element in paymentModel.data!) {
          paymentHistoryList.add(element);
        }
        currentPage.value = paymentModel.pagination!.currentPage!;
        totalPages.value = paymentModel.pagination!.totalPages!;
        hasNext.value = paymentModel.pagination!.hasNext!;
        return true;
      } else if (paymentModel.status == 0) {
        paymentHistoryList.clear();
        return true;
      } else {
        paymentHistoryList.clear();
        errorSnackBar(message: paymentModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}

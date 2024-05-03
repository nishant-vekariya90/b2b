import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../api/api_manager.dart';
import '../../model/add_money/amount_limit_model.dart';
import '../../model/add_money/payment_gateway_model.dart';
import '../../model/add_money/settlement_cycles_model.dart';
import '../../model/payment_link/payment_link_attempt_model.dart';
import '../../model/payment_link/payment_link_model.dart';
import '../../model/payment_link/payment_link_reminder_model.dart';
import '../../model/success_model.dart';
import '../../repository/retailer/payment_link_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class PaymentLinkController extends GetxController {
  PaymentLinkRepository paymentLinkRepository = PaymentLinkRepository(APIManager());

  // converting integer status into string
  String ticketStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Deactive';
    } else if (intStatus == 1) {
      status = 'Active';
    } else if (intStatus == 2) {
      status = 'Pending';
    } else if (intStatus == 3) {
      status = 'Used';
    } else if (intStatus == 4) {
      status = 'Expired';
    }
    return status;
  }

  // Format dateTime
  String formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('MM/dd/yyyy hh:mm:ss a');
    return formatter.format(dateTime);
  }

  // Get payment link
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  RxInt totalPaymentLinkCount = 0.obs;
  RxDouble totalRevenueCount = 0.0.obs;
  RxInt activeLinkCount = 0.obs;
  RxInt deactiveLinkCount = 0.obs;
  RxInt expiredLinkCount = 0.obs;
  RxInt usedLinkCount = 0.obs;
  RxList<PaymentLinkData> paymentLinkList = <PaymentLinkData>[].obs;
  RxBool isPaymentLinksLoading = false.obs;
  RxInt selectedStatusForFilter = (-1).obs;

  // Get payment link
  Future<void> getPaymentLink({int? status, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      PaymentLinkModel paymentLinkModel = await paymentLinkRepository.getPaymentLinkApiCall(
        status: status,
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (paymentLinkModel.statusCode == 1) {
        if (paymentLinkModel.pagination!.currentPage == 1) {
          paymentLinkList.clear();
        }
        if (paymentLinkModel.data != null && paymentLinkModel.data!.isNotEmpty) {
          for (PaymentLinkData element in paymentLinkModel.data!) {
            paymentLinkList.add(element);
          }
        }
        if (paymentLinkModel.pagination != null) {
          Future.delayed(const Duration(milliseconds: 500), () {
            totalPaymentLinkCount.value = paymentLinkModel.pagination!.totalCount!;
            totalRevenueCount.value = paymentLinkModel.pagination!.totalVolume!;
            activeLinkCount.value = paymentLinkModel.pagination!.totalActive!;
            deactiveLinkCount.value = paymentLinkModel.pagination!.totalDeactive!;
            expiredLinkCount.value = paymentLinkModel.pagination!.totalExpired!;
            usedLinkCount.value = paymentLinkModel.pagination!.totalUsed!;
            currentPage.value = paymentLinkModel.pagination!.currentPage!;
            totalPages.value = paymentLinkModel.pagination!.totalPages!;
            hasNext.value = paymentLinkModel.pagination!.hasNext!;
          });
        }
      } else if (paymentLinkModel.statusCode == 0) {
        paymentLinkList.clear();
        Future.delayed(const Duration(milliseconds: 500), () {
          resetGetPaymentLinkVariables();
        });
      } else {
        paymentLinkList.clear();
        resetGetPaymentLinkVariables();
        selectedStatusForFilter.value = (-1);
        errorSnackBar(message: paymentLinkModel.message!);
      }
    } catch (e) {
      dismissProgressIndicator();
    } finally {
      dismissProgressIndicator();
      Future.delayed(const Duration(milliseconds: 500), () {
        isPaymentLinksLoading.value = false;
      });
    }
  }

  // Reset get payment link variables
  resetGetPaymentLinkVariables() {
    totalPaymentLinkCount.value = 0;
    totalRevenueCount.value = 0.0;
    activeLinkCount.value = 0;
    deactiveLinkCount.value = 0;
    expiredLinkCount.value = 0;
    usedLinkCount.value = 0;
    currentPage.value = 1;
    totalPages.value = 1;
    hasNext.value = false;
  }

  // Get payment gateway list
  RxList<PaymentGatewayModel> paymentGatewayList = <PaymentGatewayModel>[].obs;
  Future<void> getPaymentGatewayList({bool isLoaderShow = true}) async {
    try {
      List<PaymentGatewayModel> paymentGatewayListModel = await paymentLinkRepository.getPaymentGatewayListApiCall(isLoaderShow: isLoaderShow);
      if (paymentGatewayListModel.isNotEmpty) {
        paymentGatewayList.clear();
        for (PaymentGatewayModel element in paymentGatewayListModel) {
          if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryID == 10) {
            paymentGatewayList.add(element);
          }
        }
        paymentGatewayList.sort((a, b) => a.rank!.compareTo(b.rank!));
      } else {
        paymentGatewayList.clear();
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Get settlement cycle list
  RxList<SettlementCyclesModel> settlementCycleList = <SettlementCyclesModel>[].obs;
  Future<void> getSettlemetCyclesList({bool isLoaderShow = true}) async {
    try {
      List<SettlementCyclesModel> settlementCycleListModel = await paymentLinkRepository.getSettlementCyclesListApiCall(isLoaderShow: isLoaderShow);
      if (settlementCycleListModel.isNotEmpty) {
        settlementCycleList.clear();
        for (SettlementCyclesModel element in settlementCycleListModel) {
          if (element.status == 1 && element.settlementType != null && element.settlementType!.isNotEmpty) {
            settlementCycleList.add(element);
          }
        }
        settlementCycleList.sort((a, b) => a.settlementType!.toLowerCase().compareTo(b.settlementType!.toLowerCase()));
      } else {
        settlementCycleList.clear();
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Create payment link
  RxString selectedPaymentGateway = ''.obs;
  TextEditingController settlementCycleController = TextEditingController();
  RxInt selectedSettlementCycleId = 0.obs;
  List amountList = ['500', '1000', '2000', '3000', '4000', '5000', '10000'];
  TextEditingController amountController = TextEditingController();
  RxString selectedAmountFromList = ''.obs;
  RxString selectedAmountInText = ''.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController linkExpireDateController = TextEditingController();
  TextEditingController purposeOfPaymentController = TextEditingController();
  RxBool isLinkStatusActive = true.obs;

  // Create payment link
  Future<bool> createPaymentLink({bool isLoaderShow = true}) async {
    try {
      SuccessModel createPaymentLinkModel = await paymentLinkRepository.createPaymentLinkApiCall(
        params: {
          'gateway': selectedPaymentGateway.value,
          'settlementCycle': selectedSettlementCycleId.value,
          'payAmount': amountController.text.trim(),
          'emailId': emailController.text.trim(),
          'mobileNo': mobileNumberController.text.trim(),
          'expiryDate': linkExpireDateController.text.trim(),
          'remarks': purposeOfPaymentController.text.trim(),
          'status': isLinkStatusActive.value ? 1 : 0,
          'channel': channelID,
          'ipAddress': ipAddress,
        },
        isLoaderShow: isLoaderShow,
      );
      if (createPaymentLinkModel.statusCode == 1) {
        await getPaymentLink(pageNumber: 1, isLoaderShow: false);
        selectedStatusForFilter.value = (-1);
        Get.back();
        successSnackBar(message: createPaymentLinkModel.message!);
        return true;
      } else {
        errorSnackBar(message: createPaymentLinkModel.message!);
        dismissProgressIndicator();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Reset create payment link variables
  resetCreatePaymentLinkVariables() {
    selectedPaymentGateway.value = '';
    settlementCycleController.clear();
    selectedSettlementCycleId.value = 0;
    amountController.clear();
    selectedAmountFromList.value = '';
    selectedAmountInText.value = '';
    emailController.clear();
    mobileNumberController.clear();
    linkExpireDateController.clear();
    purposeOfPaymentController.clear();
    isLinkStatusActive.value = true;
  }

  // Update payment link status
  TextEditingController updateStatusRemarksController = TextEditingController();
  Future<bool> updatePaymentLinkStatus({required int paymentLinkId, required int paymentLinkStatus, bool isLoaderShow = true}) async {
    try {
      SuccessModel updatePaymentLinkStatusModel = await paymentLinkRepository.updatePaymentLinkStatusApiCall(
        params: {
          'id': paymentLinkId,
          'status': paymentLinkStatus,
          'remarks': updateStatusRemarksController.text.trim(),
          'ipAddress': ipAddress,
        },
        isLoaderShow: isLoaderShow,
      );
      if (updatePaymentLinkStatusModel.statusCode == 1) {
        await getPaymentLink(pageNumber: 1, isLoaderShow: false);
        selectedStatusForFilter.value = (-1);
        Get.back();
        updateStatusRemarksController.clear();
        successSnackBar(message: updatePaymentLinkStatusModel.message!);
        return true;
      } else {
        errorSnackBar(message: updatePaymentLinkStatusModel.message!);
        dismissProgressIndicator();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get payment link attempts
  RxList<PaymentLinkAttemptData> paymentLinkAttemptList = <PaymentLinkAttemptData>[].obs;
  Future<bool> getPaymentLinkAttempts({required int paymentLinkId, bool isLoaderShow = true}) async {
    try {
      PaymentLinkAttemptModel paymentLinkAttemptModel = await paymentLinkRepository.getPaymentLinkAttemptsApiCall(
        paymentLinkId: paymentLinkId,
        isLoaderShow: isLoaderShow,
      );
      if (paymentLinkAttemptModel.statusCode == 1) {
        paymentLinkAttemptList.clear();
        if (paymentLinkAttemptModel.data != null && paymentLinkAttemptModel.data!.isNotEmpty) {
          for (PaymentLinkAttemptData element in paymentLinkAttemptModel.data!) {
            paymentLinkAttemptList.add(element);
          }
        }
        return true;
      } else {
        paymentLinkAttemptList.clear();
        errorSnackBar(message: paymentLinkAttemptModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get payment link reminder setting
  RxBool isReminderEnable = false.obs;
  RxBool isSmsReminderEnable = false.obs;
  RxBool isEmailReminderEnable = false.obs;
  List<String> daysBeforeLinkExpiredList = [
    '1 day before link expired',
    '2 days before link expired',
    '3 days before link expired',
    '4 days before link expired',
    '5 days before link expired',
    '6 days before link expired',
    '7 days before link expired',
    '8 days before link expired',
    '9 days before link expired',
    '10 days before link expired',
  ];
  RxInt daysBeforeLinkExpired = 0.obs;
  TextEditingController daysBeforeLinkExpiredController = TextEditingController();
  Rx<PaymentLinkReminderModel> paymentLinkReminderModel = PaymentLinkReminderModel().obs;
  // Get payment link reminder setting
  Future<void> getPaymentLinkReminderSetting({bool isLoaderShow = true}) async {
    try {
      paymentLinkReminderModel.value = await paymentLinkRepository.getPaymentLinkReminderApiCall(isLoaderShow: isLoaderShow);
      if (paymentLinkReminderModel.value.statusCode == 1) {
        isReminderEnable.value = paymentLinkReminderModel.value.data!.status != null && paymentLinkReminderModel.value.data!.status! == 1 ? true : false;
        isSmsReminderEnable.value = paymentLinkReminderModel.value.data!.sms != null ? paymentLinkReminderModel.value.data!.sms! : false;
        isEmailReminderEnable.value = paymentLinkReminderModel.value.data!.email != null ? paymentLinkReminderModel.value.data!.email! : false;
        daysBeforeLinkExpired.value = paymentLinkReminderModel.value.data!.expiryDay != null ? paymentLinkReminderModel.value.data!.expiryDay! : 0;
        daysBeforeLinkExpiredController.text = daysBeforeLinkExpiredList[daysBeforeLinkExpired.value - 1];
      } else {
        errorSnackBar(message: paymentLinkReminderModel.value.message!);
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Update payment link reminder setting
  Future<void> updatePaymentLinkReminderSetting({bool isLoaderShow = true}) async {
    try {
      SuccessModel updatePaymentLinkReminderSettingModel = await paymentLinkRepository.updatePaymentLinkReminderApiCall(
        params: {
          'sms': isSmsReminderEnable.value,
          'email': isEmailReminderEnable.value,
          'status': isReminderEnable.value ? 1 : 0,
          'linksExpiry': daysBeforeLinkExpired.value,
          'ipAddress': ipAddress,
        },
        isLoaderShow: isLoaderShow,
      );
      if (updatePaymentLinkReminderSettingModel.statusCode == 1) {
        Get.back();
        successSnackBar(message: updatePaymentLinkReminderSettingModel.message!);
      } else {
        errorSnackBar(message: updatePaymentLinkReminderSettingModel.message!);
        dismissProgressIndicator();
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Reset payment link reminder setting variables
  resetPaymentLinkReminderSettingVariables() {
    isReminderEnable.value = false;
    isSmsReminderEnable.value = false;
    isEmailReminderEnable.value = false;
    daysBeforeLinkExpired.value = 0;
    daysBeforeLinkExpiredController.clear();
  }

  // Get amount limit
  RxList<AmountLimitModel> amountLimitList = <AmountLimitModel>[].obs;
  RxInt lowerLimit = 0.obs;
  RxInt upperLimit = 0.obs;
  Future<bool> getAmountLimit({bool isLoaderShow = true}) async {
    try {
      List<AmountLimitModel> amountLimitModel = await paymentLinkRepository.getAmountLimitApiCall(isLoaderShow: isLoaderShow);
      if (amountLimitModel.isNotEmpty) {
        amountLimitList.clear();
        for (AmountLimitModel element in amountLimitModel) {
          amountLimitList.add(element);
        }
        if (amountLimitList.isNotEmpty) {
          lowerLimit.value = amountLimitList.first.singleTransactionLowerLimit ?? 0;
          upperLimit.value = amountLimitList.first.singleTransactionUpperLimit ?? 0;
        }
        return true;
      } else {
        amountLimitList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}

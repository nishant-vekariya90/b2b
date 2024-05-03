import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../api/api_manager.dart';
import '../../model/add_money/payment_gateway_model.dart';
import '../../model/aeps/aadhar_pay_model.dart';
import '../../model/aeps/balance_enquiry_model.dart';
import '../../model/aeps/cash_withdraw_limit_model.dart';
import '../../model/aeps/cash_withdraw_model.dart';
import '../../model/aeps/master/bank_list_model.dart';
import '../../model/aeps/mini_statement_model.dart';
import '../../model/aeps/twofa_authentication_model.dart';
import '../../model/aeps/twofa_registration_model.dart';
import '../../model/aeps/verify_status_model.dart';
import '../../repository/retailer/aeps_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class AepsController extends GetxController {
  AepsRepository aepsRepository = AepsRepository(APIManager());
  RxInt selectedAepsType = 0.obs;
  List<String> aepsTypeList = [
    'Cash Withdraw',
    'Balance Enquiry',
    'Mini Statements',
    'Aadhar Pay',
  ];
  RxString capturedFingerData = ''.obs;
  RxBool isAmountVisible = true.obs;
  TextEditingController bankController = TextEditingController();
  RxInt selectedBankId = 0.obs;
  TextEditingController authAadharNumberController = TextEditingController();
  TextEditingController authMobileNumberController = TextEditingController();
  TextEditingController aadharNumberController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  RxString amountIntoWords = ''.obs;
  RxString selectedBiometricDevice = 'Select biometric device'.obs;
  TextEditingController tPinController = TextEditingController();
  RxBool isShowTpin = true.obs;
  RxBool isAuthBeforeTransaction = false.obs;
  Rx<CashWithdrawModel> cashWithdrawModel = CashWithdrawModel().obs;
  Rx<BalanceEnquiryModel> balanceEnquiryModel = BalanceEnquiryModel().obs;
  Rx<MiniStatementModel> miniStatementModel = MiniStatementModel().obs;
  RxList<TransactionList> transactionList = <TransactionList>[].obs;
  Rx<AadharPayModel> aadharPayModel = AadharPayModel().obs;
  Rx<TwoFaRegistrationModel> twoFaRegistrationModel = TwoFaRegistrationModel().obs;
  Rx<TwoFaAuthenticationModel> twoFaAuthenticationModel = TwoFaAuthenticationModel().obs;
  RxList<MasterBankListModel> masterBankList = <MasterBankListModel>[].obs;

  // Reset aeps variables
  resetAepsVariables() {
    selectedAepsType.value = 0;
    isAmountVisible.value = true;
    capturedFingerData.value = '';
    bankController.clear();
    selectedBankId.value = 0;
    aadharNumberController.clear();
    mobileNumberController.clear();
    amountController.clear();
    amountIntoWords.value = '';
    tPinController.clear();
    isShowTpin.value = true;
    isAuthBeforeTransaction.value = false;
    selectedBiometricDevice.value = 'Select biometric device';
  }

  // Get payment gateway list
  RxList<PaymentGatewayModel> paymentGatewayList = <PaymentGatewayModel>[].obs;
  RxString selectedPaymentGateway = ''.obs;
  Future<bool> getPaymentGatewayList({bool isLoaderShow = true}) async {
    try {
      List<PaymentGatewayModel> paymentGatewayListModel = await aepsRepository.getPaymentGatewayListApiCall(isLoaderShow: isLoaderShow);
      if (paymentGatewayListModel.isNotEmpty) {
        paymentGatewayList.clear();
        for (PaymentGatewayModel element in paymentGatewayListModel) {
          if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryName == "AEPS") {
            paymentGatewayList.add(element);
          }
        }
        paymentGatewayList.sort((a, b) => a.rank!.compareTo(b.rank!));
        return true;
      } else {
        paymentGatewayList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Verify payment gateway status
  Rx<VerifyGatewayStatusModel> verifyGatewayStatusModel = VerifyGatewayStatusModel().obs;
  Future<String> getVerifyGatewayStatus({bool isLoaderShow = true}) async {
    try {
      verifyGatewayStatusModel.value = await aepsRepository.getVerifyGatewayStatusApiCall(
        gatewayName: selectedPaymentGateway.value,
        isLoaderShow: isLoaderShow,
      );
      if (verifyGatewayStatusModel.value.statusCode == 1 || verifyGatewayStatusModel.value.statusCode == 2) {
        if (verifyGatewayStatusModel.value.data != null) {
          authAadharNumberController.text =
              verifyGatewayStatusModel.value.data!.aadharNo != null && verifyGatewayStatusModel.value.data!.aadharNo!.isNotEmpty ? verifyGatewayStatusModel.value.data!.aadharNo! : '';
          authMobileNumberController.text =
              verifyGatewayStatusModel.value.data!.mobileNo != null && verifyGatewayStatusModel.value.data!.mobileNo!.isNotEmpty ? verifyGatewayStatusModel.value.data!.mobileNo! : '';
        }
        return verifyGatewayStatusModel.value.status!;
      } else {
        errorSnackBar(message: verifyGatewayStatusModel.value.message!);
        return '';
      }
    } catch (e) {
      errorSnackBar(message: 'Something went wrong!');
      dismissProgressIndicator();
      return '';
    }
  }

  // 2FA Registration
  Future<bool> twoFaRegistration({bool isLoaderShow = true}) async {
    try {
      twoFaRegistrationModel.value = await aepsRepository.twoFaRegistrationApiCall(
        params: {
          'deviceType': selectedBiometricDevice.value,
          'gateway': selectedPaymentGateway.value,
          'imeI_MAC': deviceId,
          'latitude': latitude,
          'longitude': longitude,
          'pidData': capturedFingerData.value,
        },
        isLoaderShow: isLoaderShow,
      );
      if (twoFaRegistrationModel.value.statusCode == 1) {
        Get.back();
        successSnackBar(message: twoFaRegistrationModel.value.message!);
        return true;
      } else {
        Get.back();
        errorSnackBar(message: twoFaRegistrationModel.value.message!);
        return false;
      }
    } catch (e) {
      errorSnackBar(message: 'Something went wrong!');
      dismissProgressIndicator();
      return false;
    }
  }

  // 2FA Authentication
  Future<bool> twoFaAuthentication({bool isLoaderShow = true}) async {
    try {
      twoFaAuthenticationModel.value = await aepsRepository.twoFaAuthenticationApiCall(
        params: {
          'gateway': selectedPaymentGateway.value,
          'deviceType': selectedBiometricDevice.value,
          'imeI_MAC': deviceId,
          'latitude': latitude,
          'longitude': longitude,
          'pidData': capturedFingerData.value,
        },
        isLoaderShow: isLoaderShow,
      );
      if (twoFaAuthenticationModel.value.statusCode == 1) {
        Get.back();
        successSnackBar(message: twoFaAuthenticationModel.value.message!);
        return true;
      } else {
        Get.back();
        errorSnackBar(message: twoFaAuthenticationModel.value.message!);
        return false;
      }
    } catch (e) {
      errorSnackBar(message: 'Something went wrong!');
      dismissProgressIndicator();
      return false;
    }
  }

  // 2FA Authentication for fingpay transaction
  Future<bool> twoFaAuthenticationForTransaction({bool isLoaderShow = true}) async {
    try {
      twoFaAuthenticationModel.value = await aepsRepository.twoFaAuthenticationForTransactionApiCall(
        params: {
          'gateway': selectedPaymentGateway.value,
          'deviceType': selectedBiometricDevice.value,
          'imeI_MAC': deviceId,
          'bankId': selectedBankId.value.toString(),
          'latitude': latitude,
          'longitude': longitude,
          'pidData': capturedFingerData.value,
        },
        isLoaderShow: isLoaderShow,
      );
      if (twoFaAuthenticationModel.value.statusCode == 1) {
        Get.back();
        isAuthBeforeTransaction.value = true;
        merAuthTxnId.value = twoFaAuthenticationModel.value.merAuthTxnId != null && twoFaAuthenticationModel.value.merAuthTxnId!.isNotEmpty ? twoFaAuthenticationModel.value.merAuthTxnId! : '';
        successSnackBar(message: twoFaAuthenticationModel.value.message!);
        return true;
      } else {
        Get.back();
        isAuthBeforeTransaction.value = false;
        errorSnackBar(message: twoFaAuthenticationModel.value.message!);
        return false;
      }
    } catch (e) {
      errorSnackBar(message: 'Something went wrong!');
      dismissProgressIndicator();
      return false;
    }
  }

  // Get master bank list
  Future<bool> getMasterBankList({bool isLoaderShow = true}) async {
    try {
      List<MasterBankListModel> masterBankListModel = await aepsRepository.getMasterBankListApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (masterBankListModel.isNotEmpty) {
        masterBankList.clear();
        masterBankList.addAll(masterBankListModel.where((element) => element.bankName != null && element.bankName!.isNotEmpty));
        masterBankList.sort((a, b) => a.bankName!.toLowerCase().compareTo(b.bankName!.toLowerCase()));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Cash Withdraw
  RxString merAuthTxnId = ''.obs;
  Future<bool> cashWithdraw({bool isLoaderShow = true}) async {
    try {
      cashWithdrawModel.value = await aepsRepository.cashWithdrawApiCall(
        params: {
          'gateway': selectedPaymentGateway.value,
          'deviceName': selectedBiometricDevice.value,
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'bankId': selectedBankId.value.toString(),
          'aadharNo': aadharNumberController.text.trim(),
          'mobileNo': mobileNumberController.text.trim(),
          'amount': amountController.text.trim(),
          'tpin': tPinController.text.isNotEmpty ? tPinController.text.trim() : null,
          'merAuthTxnId': merAuthTxnId.value,
          'channel': 2,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
          'imeI_MAC': deviceId,
          'pidData': capturedFingerData.value,
        },
        isLoaderShow: isLoaderShow,
      );
      // For fail response
      if (cashWithdrawModel.value.statusCode == 0) {
        merAuthTxnId.value = '';
        isAuthBeforeTransaction.value = false;
        errorSnackBar(message: cashWithdrawModel.value.message!);
        return false;
      }
      // For success response
      else if (cashWithdrawModel.value.statusCode == 1) {
        merAuthTxnId.value = '';
        isAuthBeforeTransaction.value = false;
        return true;
      }
      // For pending response
      else if (cashWithdrawModel.value.statusCode == 2) {
        merAuthTxnId.value = '';
        isAuthBeforeTransaction.value = false;
        pendingSnackBar(message: cashWithdrawModel.value.message!);
        return false;
      }
      // For other response
      else {
        merAuthTxnId.value = '';
        isAuthBeforeTransaction.value = false;
        errorSnackBar(message: cashWithdrawModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Balance Enquiry
  Future<bool> balanceEnquiry({bool isLoaderShow = true}) async {
    try {
      balanceEnquiryModel.value = await aepsRepository.balanceEnquiryApiCall(
        params: {
          'gateway': selectedPaymentGateway.value,
          'deviceName': selectedBiometricDevice.value,
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'bankId': selectedBankId.value.toString(),
          'mobileNo': mobileNumberController.text.trim(),
          'aadharNo': aadharNumberController.text.trim(),
          'tpin': tPinController.text.isNotEmpty ? tPinController.text.trim() : null,
          'channel': 2,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
          'imeI_MAC': deviceId,
          'pidData': capturedFingerData.value,
        },
        isLoaderShow: isLoaderShow,
      );
      // For fail response
      if (balanceEnquiryModel.value.statusCode == 0) {
        errorSnackBar(message: balanceEnquiryModel.value.message!);
        return false;
      }
      // For success response
      else if (balanceEnquiryModel.value.statusCode == 1) {
        return true;
      }
      // For pending response
      else if (balanceEnquiryModel.value.statusCode == 2) {
        pendingSnackBar(message: balanceEnquiryModel.value.message!);
        return false;
      }
      // For other response
      else {
        errorSnackBar(message: balanceEnquiryModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Mini Statement
  Future<bool> miniStatement({bool isLoaderShow = true}) async {
    try {
      miniStatementModel.value = await aepsRepository.miniStatementApiCall(
        params: {
          'gateway': selectedPaymentGateway.value,
          'deviceName': selectedBiometricDevice.value,
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'bankId': selectedBankId.value.toString(),
          'aadharNo': aadharNumberController.text.trim(),
          'mobileNo': mobileNumberController.text.trim(),
          'tpin': tPinController.text.isNotEmpty ? tPinController.text.trim() : null,
          'channel': 2,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
          'imeI_MAC': deviceId,
          'pidData': capturedFingerData.value,
        },
        isLoaderShow: isLoaderShow,
      );
      // For fail response
      if (miniStatementModel.value.statusCode == 0) {
        transactionList.clear();
        errorSnackBar(message: miniStatementModel.value.message!);
        return false;
      }
      // For success response
      else if (miniStatementModel.value.statusCode == 1) {
        transactionList.clear();
        if (miniStatementModel.value.data != null) {
          if (miniStatementModel.value.data!.transactionList != null && miniStatementModel.value.data!.transactionList!.isNotEmpty) {
            for (TransactionList element in miniStatementModel.value.data!.transactionList!) {
              transactionList.add(element);
            }
          }
        }
        return true;
      }
      // For pending response
      else if (miniStatementModel.value.statusCode == 2) {
        transactionList.clear();
        pendingSnackBar(message: miniStatementModel.value.message!);
        return false;
      }
      // For other response
      else {
        transactionList.clear();
        errorSnackBar(message: miniStatementModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Aadhar Pay
  Future<bool> aadharPay({bool isLoaderShow = true}) async {
    try {
      aadharPayModel.value = await aepsRepository.aadharPayApiCall(
        params: {
          'gateway': selectedPaymentGateway.value,
          'deviceName': selectedBiometricDevice.value,
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'bankId': selectedBankId.value.toString(),
          'aadharNo': aadharNumberController.text.trim(),
          'mobileNo': mobileNumberController.text.trim(),
          'amount': amountController.text.trim(),
          'tpin': tPinController.text.isNotEmpty ? tPinController.text.trim() : null,
          'merAuthTxnId': merAuthTxnId.value,
          'channel': 2,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
          'imeI_MAC': deviceId,
          'pidData': capturedFingerData.value,
        },
        isLoaderShow: isLoaderShow,
      );
      // For fail response
      if (aadharPayModel.value.statusCode == 0) {
        merAuthTxnId.value = '';
        isAuthBeforeTransaction.value = false;
        errorSnackBar(message: aadharPayModel.value.message!);
        return false;
      }
      // For success response
      else if (aadharPayModel.value.statusCode == 1) {
        merAuthTxnId.value = '';
        isAuthBeforeTransaction.value = false;
        return true;
      }
      // For pending response
      else if (aadharPayModel.value.statusCode == 2) {
        merAuthTxnId.value = '';
        isAuthBeforeTransaction.value = false;
        pendingSnackBar(message: aadharPayModel.value.message!);
        return false;
      }
      // For other response
      else {
        merAuthTxnId.value = '';
        isAuthBeforeTransaction.value = false;
        errorSnackBar(message: aadharPayModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get cash withdraw limit
  RxList<CashWithdrawLimitModel> cashWithDrawLimitList = <CashWithdrawLimitModel>[].obs;
  Future<bool> getCashWithdrawLimit({bool isLoaderShow = true}) async {
    try {
      List<CashWithdrawLimitModel> cashWithDrawModel = await aepsRepository.getCashWithdrawLimitApiCall(isLoaderShow: isLoaderShow);
      if (cashWithDrawModel.isNotEmpty) {
        cashWithDrawLimitList.clear();
        for (CashWithdrawLimitModel element in cashWithDrawModel) {
          cashWithDrawLimitList.add(element);
        }
        return true;
      } else {
        cashWithDrawLimitList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}

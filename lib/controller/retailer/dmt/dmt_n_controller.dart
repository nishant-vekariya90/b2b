import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../api/api_manager.dart';
import '../../../model/money_transfer/account_verification_model.dart';
import '../../../model/money_transfer/add_recipient_model.dart';
import '../../../model/money_transfer/add_remitter_model.dart';
import '../../../model/money_transfer/recipient_model.dart';
import '../../../model/money_transfer/recipient_deposit_bank_model.dart';
import '../../../model/money_transfer/remove_recipient_model.dart';
import '../../../model/money_transfer/transaction_model.dart';
import '../../../model/money_transfer/transaction_slab_model.dart';
import '../../../model/money_transfer/validate_remitter_model.dart';
import '../../../repository/retailer/dmt/dmt_n_repository.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/constant_widgets.dart';

class DmtNController extends GetxController {
  DmtNRepository dmtNRepository = DmtNRepository(APIManager());

  ////////////////
  /// Remitter ///
  ////////////////
  TextEditingController validateRemitterMobileNumberController = TextEditingController();
  // Validate remitter
  Rx<ValidateRemitterModel> validateRemitterModel = ValidateRemitterModel().obs;
    RxInt monthlyLimit = 0.obs;
  Future<int> validateRemitter({bool isLoaderShow = true}) async {
    try {
      validateRemitterModel.value = await dmtNRepository.validateRemitterApiCall(
        mobileNumber: validateRemitterMobileNumberController.text,
        isLoaderShow: isLoaderShow,
      );
      if (validateRemitterModel.value.statusCode == 0) {
        errorSnackBar(message: validateRemitterModel.value.message);
        return 0;
      } else if (validateRemitterModel.value.statusCode == 1) {
        if (validateRemitterModel.value.data != null && validateRemitterModel.value.data!.monthlyLimit != null && validateRemitterModel.value.data!.monthlyLimit!.isNotEmpty) {
          monthlyLimit.value = double.parse(validateRemitterModel.value.data!.monthlyLimit!.toString()).toInt();
        }
        return 1;
      } else if (validateRemitterModel.value.statusCode == 2) {
        remitterRegistrationMobileNumberController.text = validateRemitterMobileNumberController.text.trim();
        return 2;
      } else {
        errorSnackBar(message: validateRemitterModel.value.message);
        return 0;
      }
    } catch (e) {
      dismissProgressIndicator();
      return 0;
    }
  }

  // Remitter registration variables
  TextEditingController remitterRegistrationFirstNameController = TextEditingController();
  TextEditingController remitterRegistrationLastNameController = TextEditingController();
  TextEditingController remitterRegistrationMobileNumberController = TextEditingController();
  TextEditingController remitterRegistrationPinCodeController = TextEditingController();

  // Remitter registration
  Rx<AddRemitterModel> addRemitterModel = AddRemitterModel().obs;
  Future<bool> remitterRegistration({bool isLoaderShow = true}) async {
    try {
      addRemitterModel.value = await dmtNRepository.addRemitterApiCall(
        params: {
          'firstName': remitterRegistrationFirstNameController.text.trim(),
          'lastName': remitterRegistrationLastNameController.text.trim(),
          'mobileNo': remitterRegistrationMobileNumberController.text.trim(),
          'pinCode': remitterRegistrationPinCodeController.text.trim(),
          'address': '',
          'ipAddress': ipAddress,
        },
        isLoaderShow: isLoaderShow,
      );
      if (addRemitterModel.value.statusCode == 1) {
        return true;
      } else {
        errorSnackBar(message: addRemitterModel.value.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Clear remitter registration variables
  clearRemitterRegistrationVariables() {
    remitterRegistrationFirstNameController.clear();
    remitterRegistrationLastNameController.clear();
    remitterRegistrationMobileNumberController.clear();
    remitterRegistrationPinCodeController.clear();
  }

  /////////////////
  /// Recipient ///
  /////////////////

  // Get recipient list
  RxList<RecipientListModel> recipientList = <RecipientListModel>[].obs;
  Future<bool> getRecipientList({bool isLoaderShow = true}) async {
    try {
      RecipientModel recipientModel = await dmtNRepository.fetchRecipientsApiCall(
        mobileNumber: validateRemitterMobileNumberController.text,
        isLoaderShow: isLoaderShow,
      );
      if (recipientModel.statusCode == 0) {
        recipientList.clear();
        return false;
      } else if (recipientModel.statusCode == 1) {
        recipientList.clear();
        if (recipientModel.data!.isNotEmpty) {
          for (RecipientListModel element in recipientModel.data!) {
            recipientList.add(element);
          }
        }
        return true;
      } else {
        recipientList.clear();
        errorSnackBar(message: recipientModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Add recipient variables
  GlobalKey<FormState> addRecipientForm = GlobalKey<FormState>();
  RxString selectedRecipientId = ''.obs;
  TextEditingController addRecipientFullNameController = TextEditingController();
  TextEditingController addRecipientDepositBankController = TextEditingController();
  RxString addRecipientDepositBankId = ''.obs;
  TextEditingController addRecipientIfscCodeController = TextEditingController();
  TextEditingController addRecipientAccountNumberController = TextEditingController();
  TextEditingController addRecipientMobileNumberController = TextEditingController();
  RxBool isAccountVerify = false.obs;

  // Deposit bank list
  RxList<RecipientDepositBankModel> depositBankList = <RecipientDepositBankModel>[].obs;
  Future<bool> getDepositBankList({bool isLoaderShow = true}) async {
    try {
      List<RecipientDepositBankModel> bankModel = await dmtNRepository.getDepositBankApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (bankModel.isNotEmpty) {
        depositBankList.clear();
        for (RecipientDepositBankModel element in bankModel) {
          depositBankList.add(element);
        }
        depositBankList.sort((a, b) => a.bankName!.toLowerCase().compareTo(b.bankName!.toLowerCase()));
        return true;
      } else {
        depositBankList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Verify account number api
  Rx<AccountVerificationModel> accountVerificationModel = AccountVerificationModel().obs;
  Future<bool> verifyAccount({required String recipientName, required String accountNo, required String ifscCode, required String bankName, bool isLoaderShow = true}) async {
    try {
      accountVerificationModel.value = await dmtNRepository.accountVerificationApiCall(
        params: {
          'mobileNo': validateRemitterModel.value.data!.mobileNo!,
          'remitterId': validateRemitterModel.value.data!.remitterId!,
          'recipientName': recipientName,
          'accountNo': accountNo,
          'ifscCode': ifscCode,
          'bankName': bankName,
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'channel': channelID,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (accountVerificationModel.value.statusCode == 1) {
        isAccountVerify.value = true;
        addRecipientFullNameController.text = accountVerificationModel.value.data!.recipientName.toString();
        return true;
      } else {
        isAccountVerify.value = false;
        errorSnackBar(message: accountVerificationModel.value.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Add recipient
  Rx<AddRecipientModel> addRecipientModel = AddRecipientModel().obs;
  Future<bool> addRecipient({bool isLoaderShow = true}) async {
    try {
      addRecipientModel.value = await dmtNRepository.addRecipientApiCall(
        params: {
          'mobileNo': validateRemitterModel.value.data!.mobileNo.toString(),
          'remitterId': validateRemitterModel.value.data!.remitterId.toString(),
          'name': addRecipientFullNameController.text,
          'accountNo': addRecipientAccountNumberController.text,
          'ifscCode': addRecipientIfscCodeController.text,
          'bankId': addRecipientDepositBankId.value,
          'isVerified': isAccountVerify.value,
          'ipAddress': ipAddress,
        },
        isLoaderShow: isLoaderShow,
      );
      if (addRecipientModel.value.statusCode == 1) {
        return true;
      } else {
        errorSnackBar(message: addRecipientModel.value.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Clear add recipient variables
  clearAddRecipientVariables() {
    addRecipientFullNameController.clear();
    addRecipientDepositBankController.clear();
    addRecipientDepositBankId.value = '';
    addRecipientIfscCodeController.clear();
    addRecipientAccountNumberController.clear();
    addRecipientMobileNumberController.clear();
    isAccountVerify.value = false;
  }

  // Remove recipient
  Rx<RemoveRecipientModel> removeRecipientModel = RemoveRecipientModel().obs;
  Future<bool> removeRecipient({required String mobileNo, bool isLoaderShow = true}) async {
    try {
      removeRecipientModel.value = await dmtNRepository.removeRecipientApiCall(
        params: {
          'mobileNo': mobileNo,
          'remitterId': validateRemitterModel.value.data!.remitterId.toString(),
          'recipientId': selectedRecipientId.value,
          'ipAddress': ipAddress,
        },
        isLoaderShow: isLoaderShow,
      );
      if (removeRecipientModel.value.statusCode == 1) {
        successSnackBar(message: removeRecipientModel.value.message);
        return true;
      } else {
        errorSnackBar(message: removeRecipientModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  ///////////////////
  /// Transaction ///
  ///////////////////
  RxString selectedPaymentType = 'IMPS'.obs;
  TextEditingController rNameController = TextEditingController();
  TextEditingController rMobileNumberController = TextEditingController();
  TextEditingController rBankNameController = TextEditingController();
  TextEditingController rAccountNumberController = TextEditingController();
  TextEditingController rIfscCodeController = TextEditingController();
  TextEditingController rAmountController = TextEditingController();
  RxString rAmountIntoWords = ''.obs;
  TextEditingController rTpinController = TextEditingController();
  RxBool rIsShowTpin = false.obs;
  TextEditingController pendingSlabAmountController = TextEditingController();
  TextEditingController successSlabAmountController = TextEditingController();
  TextEditingController failedSlabAmountController = TextEditingController();
  RxList pendingSlabList = [].obs;
  RxList successSlabList = [].obs;
  RxList failedSlabList = [].obs;
  RxInt moneyTransferResponse = 0.obs;
  RxString statusName = ''.obs;
  RxString statusAccountNumber = ''.obs;
  RxString statusMobileNumber = ''.obs;

  // Set values for money transfer
  setTransactionVariables(RecipientListModel recipientListModel) {
    rNameController.text = recipientListModel.name!;
    rMobileNumberController.text = recipientListModel.mobileNo!;
    rBankNameController.text = recipientListModel.bankName!;
    rAccountNumberController.text = recipientListModel.accountNo!;
    rIfscCodeController.text = recipientListModel.ifsc!;
  }

  // Transaction slab api
  Rx<TransactionSlabModel> transactionSlabModel = TransactionSlabModel().obs;
  Future<bool> transactionSlab({bool isLoaderShow = true}) async {
    try {
      transactionSlabModel.value = await dmtNRepository.transactionSlabApiCall(
        params: {
          'mobileNo': rMobileNumberController.text.trim(),
          'accountNo': rAccountNumberController.text.trim(),
          'amount': rAmountController.text.trim(),
          'tpin': rTpinController.text.isNotEmpty ? rTpinController.text.trim() : null,
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'channel': channelID,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (transactionSlabModel.value.statusCode == 1) {
        return true;
      } else {
        errorSnackBar(message: transactionSlabModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Transaction api
  Rx<TransactionModel> transactionModel = TransactionModel().obs;
  Future<int> transaction({required String amount, required int slabNo, bool isLoaderShow = true}) async {
    try {
      transactionModel.value = await dmtNRepository.transactionApiCall(
        params: {
          'slno': slabNo,
          'mobileNo': rMobileNumberController.text.trim(),
          'remitterId': validateRemitterModel.value.data!.remitterId ?? '',
          'remitterName': validateRemitterModel.value.data!.name ?? '',
          'recipientId': selectedRecipientId.value,
          'recipientName': rNameController.text,
          'bankName': rBankNameController.text,
          'accountNo': rAccountNumberController.text,
          'ifscCode': rIfscCodeController.text,
          'amount': amount,
          'paymentType': selectedPaymentType.value,
          'orderId': transactionSlabModel.value.txnRefNumber ?? '',
          'tpin': rTpinController.text.isNotEmpty ? rTpinController.text.trim() : null,
          'channel': channelID,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (transactionModel.value.statusCode != null && transactionModel.value.statusCode! >= 0) {
        return transactionModel.value.statusCode!;
      } else {
        errorSnackBar(message: transactionModel.value.message!);
        return -1;
      }
    } catch (e) {
      dismissProgressIndicator();
      return -1;
    }
  }

  // Clear transaction variable
  clearTransactionVariables() {
    selectedPaymentType.value = 'IMPS';
    rNameController.clear();
    rMobileNumberController.clear();
    rBankNameController.clear();
    rAccountNumberController.clear();
    rIfscCodeController.clear();
    rAmountController.clear();
    rAmountIntoWords.value = '';
    rTpinController.clear();
    rIsShowTpin = false.obs;
    pendingSlabAmountController.clear();
    successSlabAmountController.clear();
    failedSlabAmountController.clear();
    pendingSlabList.clear();
    successSlabList.clear();
    failedSlabList.clear();
  }
}

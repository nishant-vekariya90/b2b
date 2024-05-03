import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/api_manager.dart';
import '../../../model/credit_card/credit_card_transaction_slab_model.dart';
import '../../../model/money_transfer/recipient_deposit_bank_model.dart';
import '../../../model/money_transfer/transaction_model.dart';
import '../../../repository/retailer/credit_card/credit_card_i_repository.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/constant_widgets.dart';

class CreditCardIController extends GetxController {
  CreditCardIRepository creditCardIRepository = CreditCardIRepository(APIManager());

  // For credit card payment
  TextEditingController bankNameController = TextEditingController();
  RxString selectedBankId = ''.obs;
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  RxString amountIntoWords = ''.obs;
  TextEditingController tpinController = TextEditingController();
  RxBool isHideTpin = true.obs;
  TextEditingController pendingSlabAmountController = TextEditingController();
  TextEditingController successSlabAmountController = TextEditingController();
  TextEditingController failedSlabAmountController = TextEditingController();
  RxList pendingSlabList = [].obs;
  RxList successSlabList = [].obs;
  RxList failedSlabList = [].obs;
  RxInt transactionResponse = 0.obs;
  RxString statusName = ''.obs;
  RxString statusCardNumber = ''.obs;
  RxString statusMobileNumber = ''.obs;

  // Deposit bank list
  RxList<RecipientDepositBankModel> depositBankList = <RecipientDepositBankModel>[].obs;
  Future<bool> getBankListAPI({bool isLoaderShow = true}) async {
    try {
      List<RecipientDepositBankModel> bankModel = await creditCardIRepository.getBankApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (bankModel.isNotEmpty) {
        depositBankList.clear();
        for (RecipientDepositBankModel element in bankModel) {
          depositBankList.add(element);
        }
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

  // Transaction slab
  Rx<CreditCardTransactionSlabModel> transactionSlabModel = CreditCardTransactionSlabModel().obs;
  Future<bool> transactionSlab({bool isLoaderShow = true}) async {
    try {
      transactionSlabModel.value = await creditCardIRepository.transactionSlabApiCall(
        params: {
          'gatewayName': 'INSTANTPAY',
          'name': nameController.text.trim(),
          'mobileNo': mobileNumberController.text.trim(),
          'cardNumber': cardNumberController.text.trim(),
          'bankId': selectedBankId.value,
          'amount': int.parse(amountController.text.trim()),
          'tpin': tpinController.text.isNotEmpty ? tpinController.text.trim() : null,
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

  // Transaction
  Rx<TransactionModel> transactionModel = TransactionModel().obs;
  Future<int> transaction({required String amount, required int slabNo, bool isLoaderShow = true}) async {
    try {
      transactionModel.value = await creditCardIRepository.transactionApiCall(
        params: {
          'gatewayName': 'INSTANTPAY',
          'slno': slabNo,
          'mobileNo': mobileNumberController.text.trim(),
          'name': nameController.text.trim(),
          'bankId': selectedBankId.value,
          'cardNumber': cardNumberController.text.trim(),
          'amount': amount,
          'tpin': tpinController.text.isNotEmpty ? tpinController.text.trim() : null,
          'orderId': transactionSlabModel.value.txnRefNumber!.toString(),
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
        return 0;
      }
    } catch (e) {
      dismissProgressIndicator();
      return 0;
    }
  }

  // Clear all variables
  resetCreditCardMVariables() {
    bankNameController.clear();
    selectedBankId.value = '';
    cardNumberController.clear();
    nameController.clear();
    mobileNumberController.clear();
    amountController.clear();
    amountIntoWords.value = '';
    tpinController.clear();
    isHideTpin = true.obs;
    pendingSlabAmountController.clear();
    successSlabAmountController.clear();
    failedSlabAmountController.clear();
    pendingSlabList.clear();
    successSlabList.clear();
    failedSlabList.clear();
  }
}

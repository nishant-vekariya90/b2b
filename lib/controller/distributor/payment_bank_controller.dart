import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import '../../api/api_manager.dart';
import '../../model/payment_bank/add_payment_bank_model.dart';
import '../../model/payment_bank/payment_bank_list_model.dart';
import '../../repository/distributor/payment_bank_repository.dart';
import '../../widgets/constant_widgets.dart';

class PaymentBankController extends GetxController {
  PaymentBankRepository paymentBankRepository = PaymentBankRepository(APIManager());

// Add payment request bank

  RxInt selectedTabIndex = 0.obs;
  RxList<PaymentBankListModel> allPaymentBankList = <PaymentBankListModel>[].obs;
  RxList<PaymentBankListModel> allPaymentUpiList = <PaymentBankListModel>[].obs;

  RxString selectedBankPaymentMethodRadio = 'Bank'.obs;
  TextEditingController accountHolderNameBankController = TextEditingController();
  TextEditingController accountHolderNameUpiController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  RxString selectedAccountTypeRadio = 'Current'.obs;
  TextEditingController bankNameController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController upiIdController = TextEditingController();
  TextEditingController bankBranchCodeController = TextEditingController();
  TextEditingController bankBranchNameController = TextEditingController();
  Rx<File> bankChequeFile = File('').obs;
  int priority = 1;

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
    bankBranchCodeController.clear();
    bankBranchNameController.clear();
    bankChequeFile.value = File('');
  }

  // Add payment bank
  Future<bool> addPaymentBank({bool isLoaderShow = true}) async {
    try {
      AddPaymentBankModel addPaymentBankModel = await paymentBankRepository.addPaymentBankApiCall(
        params: {
          'name': selectedBankPaymentMethodRadio.value == 'Bank' ? bankNameController.text.trim() : null,
          'bankCode': selectedBankPaymentMethodRadio.value == 'Bank' ? bankBranchCodeController.text.trim() : null,
          'type': selectedBankPaymentMethodRadio.value,
          'accountName': selectedBankPaymentMethodRadio.value == 'Bank' ? accountHolderNameBankController.text.trim() : accountHolderNameUpiController.text.trim(),
          'accountType': selectedBankPaymentMethodRadio.value == 'Bank' ? selectedAccountTypeRadio.value : null,
          'accountNumber': selectedBankPaymentMethodRadio.value == 'Bank' ? accountNumberController.text : null,
          'ifsc': selectedBankPaymentMethodRadio.value == 'Bank' ? ifscCodeController.text : null,
          'fileBytes': bankChequeFile.value.path.isNotEmpty ? await convertFileToBase64(bankChequeFile.value) : null,
          'branch': selectedBankPaymentMethodRadio.value == 'Bank' ? bankBranchNameController.text : null,
          'priority': priority.toString(),
          'fileBytesFormat': bankChequeFile.value.path.isNotEmpty ? extension(bankChequeFile.value.path) : null,
          'upiid': selectedBankPaymentMethodRadio.value == 'UPI' ? upiIdController.text.trim() : null,
          'qrData': null,
        },
        isLoaderShow: isLoaderShow,
      );
      if (addPaymentBankModel.statusCode == 1) {
        await getPaymentBankList(isLoaderShow: false);
        Get.back();
        successSnackBar(message: addPaymentBankModel.message!);
        priority++;
        return true;
      } else {
        errorSnackBar(message: addPaymentBankModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get Payment bank/upi list
  Future<bool> getPaymentBankList({bool isLoaderShow = true}) async {
    try {
      List<PaymentBankListModel> paymentBankListModel = await paymentBankRepository.getPaymentBankListApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (paymentBankListModel.isNotEmpty) {
        allPaymentBankList.clear();
        allPaymentUpiList.clear();
        for (PaymentBankListModel element in paymentBankListModel) {
          if (element.type == "Bank") {
            allPaymentBankList.add(element);
          } else {
            allPaymentUpiList.add(element);
          }
        }
        return true;
      } else {
        allPaymentBankList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}

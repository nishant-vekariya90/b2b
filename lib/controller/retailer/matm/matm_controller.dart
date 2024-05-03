import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../api/api_manager.dart';
import '../../../model/add_money/payment_gateway_model.dart';
import '../../../model/matm/fingpay_sdk_response_model.dart';
import '../../../model/matm/matm_auth_detail_model.dart';
import '../../../repository/retailer/matm/matm_repository.dart';
import '../../../widgets/constant_widgets.dart';

class MAtmController extends GetxController {
  MatmRepository mAtmRepository = MatmRepository(APIManager());
  String respData = '';
  String username = '';
  String authKey = '';
  String merchantId = '';
  String mobileNo = '';
  String agentId = '';
  RxBool isAmountVisible = true.obs;
  // Get payment gateway list
  RxList<PaymentGatewayModel> paymentGatewayList = <PaymentGatewayModel>[].obs;
  RxString selectedPaymentGateway = ''.obs;
  Future<bool> getPaymentGatewayList({bool isLoaderShow = true}) async {
    try {
      List<PaymentGatewayModel> paymentGatewayListModel = await mAtmRepository.getPaymentGatewayListApiCall(isLoaderShow: isLoaderShow);
      if (paymentGatewayListModel.isNotEmpty) {
        paymentGatewayList.clear();
        for (PaymentGatewayModel element in paymentGatewayListModel) {
          if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryName == 'MATM') {
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

  // Get Matm authentication details
  Rx<MatmAuthDetailsModel> matmAuthDetailsModel = MatmAuthDetailsModel().obs;
  TextEditingController authAadharNumberController = TextEditingController();
  TextEditingController authMobileNumberController = TextEditingController();
  Future<String> getMatmAuthDetails({bool isLoaderShow = true}) async {
    try {
      matmAuthDetailsModel.value = await mAtmRepository.getMATMAuthDetailsApiCall(
        orderId: 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
        gateway: selectedPaymentGateway.value,
        isLoaderShow: isLoaderShow,
      );
      if (matmAuthDetailsModel.value.statusCode == 1 || matmAuthDetailsModel.value.statusCode == 2) {
        if (matmAuthDetailsModel.value.data != null) {
          authAadharNumberController.text =
              matmAuthDetailsModel.value.data!.aadharNo != null && matmAuthDetailsModel.value.data!.aadharNo!.isNotEmpty ? matmAuthDetailsModel.value.data!.aadharNo! : '';
          authMobileNumberController.text =
              matmAuthDetailsModel.value.data!.mobileNo != null && matmAuthDetailsModel.value.data!.mobileNo!.isNotEmpty ? matmAuthDetailsModel.value.data!.mobileNo! : '';
        }
        if(selectedPaymentGateway.value == "MONEYART" || selectedPaymentGateway.value == "EZYPAY") {
          if (matmAuthDetailsModel.value.statusCode == 1) {
            return "Approved";
          } else {
            return "NotRegistered";
          }
        }else if(selectedPaymentGateway.value == "CREDOPAYMATM") {
          if (matmAuthDetailsModel.value.statusCode == 1) {
            return "true";
          } else  if (matmAuthDetailsModel.value.statusCode == 2) {
            return "true";
          } else {
            errorSnackBar(message: matmAuthDetailsModel.value.message!);
            return '';
          }
        }
        else {
          return matmAuthDetailsModel.value.status!;
        }
      } else {
        errorSnackBar(message: matmAuthDetailsModel.value.message!);
        return '';
      }
    } catch (e) {
      errorSnackBar(message: e.toString());
      dismissProgressIndicator();
      return '';
    }
  }

  // Reset aeps variables
  resetAepsVariables() {
    selectedPaymentGateway.value = '';
  }

  // Fingpay Matm
  RxList<String> fingpayServiceTypeList = <String>['Cash Withdrawal', 'Balance Enquiry'].obs;
  RxString selectedFingpayServiceType = 'Cash Withdrawal'.obs;
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  RxString amountIntoWords = ''.obs;
  TextEditingController remarksController = TextEditingController();
  Rx<FingpaySdkResponseModel> fingpaySdkResponseModel = FingpaySdkResponseModel().obs;

  // Reset fingpay variables
  resetFingpayVariables() {
    selectedFingpayServiceType.value = 'Cash Withdrawal';
    mobileNumberController.clear();
    amountController.clear();
    amountIntoWords.value = '';
    remarksController.clear();
    fingpaySdkResponseModel.value = FingpaySdkResponseModel();
  }
}

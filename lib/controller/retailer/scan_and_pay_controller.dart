import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_manager.dart';
import '../../model/scan_and_pay/scan_and_pay_model.dart';
import '../../repository/retailer/scan_and_pay_repository.dart';
import '../../widgets/constant_widgets.dart';
import '../../utils/string_constants.dart';

class ScanAndPayController extends GetxController {
  ScanAndPayRepository scanAndPayRepository = ScanAndPayRepository(APIManager());

  RxBool isFlashOn = false.obs;
  RxString mcCode = ''.obs;
  TextEditingController upiController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  RxString amountInText = ''.obs;
  TextEditingController remarksController = TextEditingController();
  TextEditingController tPinController = TextEditingController();
  RxBool isShowTpinField = false.obs;
  RxBool isShowTpin = true.obs;
  RxInt payStatus = (-1).obs;

  bool parseScanedData(String data) {
    String mainUPI = "";
    String mainUPIName = "";
    String mc1 = "";

    List<String> upiIDArray = data.split("pa=");
    String upiID2 = upiIDArray[1];

    if (upiID2.contains("@apl")) {
      if (upiID2.contains("&tn=")) {
        List<String> upiID = upiID2.split("&tn=");
        String upi1 = upiID[0];
        String upi2 = upiID[1];

        List<String> mainUpiID = upi2.split("&pn=");
        mainUPI = upi1;
        mainUPIName = mainUpiID[1];
      }
    } else {
      if (upiID2.contains("&pn=")) {
        List<String> mainUpiID1 = upiID2.split("&pn=");
        mainUPI = mainUpiID1[0];
        mainUPIName = mainUpiID1[1];

        if (mainUPIName.contains("&cu=")) {
          List<String> name = mainUPIName.split("&cu=");
          mainUPIName = name[0];
        }

        if (mainUPIName.contains("&tn=")) {
          List<String> upiID = mainUPIName.split("&tn=");
          mainUPIName = upiID[0];
        }
      }
    }

    if (mainUPIName.contains("&aid=")) {
      List<String> mainUpiIDName = mainUPIName.split("&aid=");
      mainUPIName = mainUpiIDName[0];
    } else if (mainUPIName.contains("&mc=")) {
      List<String> mainUpiIDName = mainUPIName.split("&mc=");
      mainUPIName = mainUpiIDName[0];
      String mainUPIName1 = mainUpiIDName[1];

      List<String> mc = mainUPIName1.split("&mode=");
      mc1 = mc[0];
    }

    if (mainUPIName.contains("%20")) {
      List<String> fullName = mainUPIName.split("%20");
      String firstName = fullName[0];
      String lastName = fullName[1];
      upiController.text = mainUPI;
      nameController.text = '$firstName $lastName';
      mcCode.value = mc1;
    } else {
      upiController.text = mainUPI;
      nameController.text = mainUPIName;
      mcCode.value = mc1;
    }

    if (upiController.text.isNotEmpty && nameController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Reset scan pay variables
  resetScanPayVariables() {
    isFlashOn.value = false;
    mcCode.value = '';
    upiController.clear();
    nameController.clear();
    amountController.clear();
    amountInText.value = '';
    remarksController.clear();
    tPinController.clear();
    isShowTpinField.value = false;
    isShowTpin.value = true;
    payStatus.value = (-1);
  }

  // Scanpay request
  Rx<ScanAndPayModel> scanAndPayModel = ScanAndPayModel().obs;
  Future<int> scanPayRequest({bool isLoaderShow = true}) async {
    try {
      scanAndPayModel.value = await scanAndPayRepository.scanAndPayApiCall(
        params: {
          'vpa': upiController.text.trim(),
          'name': nameController.text.trim(),
          'amount': amountController.text.trim(),
          'remarks': remarksController.text.trim(),
          'mc': mcCode.value != '' && mcCode.value.isNotEmpty ? mcCode.value : null,
          'tpin': tPinController.text.isNotEmpty ? tPinController.text.trim() : null,
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'channel': channelID,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (scanAndPayModel.value.statusCode != null) {
        return scanAndPayModel.value.statusCode!;
      } else {
        return -1;
      }
    } catch (e) {
      dismissProgressIndicator();
      return -1;
    }
  }
}

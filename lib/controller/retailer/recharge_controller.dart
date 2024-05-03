import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_manager.dart';
import '../../model/master/circle_list_model.dart';
import '../../model/master/operator_list_model.dart';
import '../../model/recharge_and_biils/m_plans_model.dart';
import '../../model/recharge_and_biils/recharge_model.dart';
import '../../model/recharge_and_biils/operator_fetch_model.dart';
import '../../model/recharge_and_biils/r_plans_model.dart';
import '../../repository/retailer/recharge_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class RechargeController extends GetxController {
  RechargeRepository rechargeRepository = RechargeRepository(APIManager());
  RxBool isShowTpinField = false.obs;

  ///////////////////////
  /// Mobile recharge ///
  ///////////////////////
  RxList<Contact> contactList = <Contact>[].obs;
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController operatorController = TextEditingController();
  TextEditingController circleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController tPinController = TextEditingController();
  RxBool isShowTpin = true.obs;
  RxBool isShowPlanButton = false.obs;

  RxList<MasterOperatorListModel> masterOperatorList = <MasterOperatorListModel>[].obs;
  RxList<MasterCircleListModel> masterCircleList = <MasterCircleListModel>[].obs;
  Rx<OperatorFetchData> operatorFetchData = OperatorFetchData().obs;
  RxString selectedOperatorCode = ''.obs;
  RxString selectedCircleCode = ''.obs;
  RxInt selectedIndex = 0.obs;
  RxMap<String, List<MPlanDetails>> mPlansList = <String, List<MPlanDetails>>{}.obs;
  RxString selectedMPlansKey = ''.obs;
  RxList<MPlanDetails> selectedMPlansList = <MPlanDetails>[].obs;
  RxList<RPlanDetails> rPlansList = <RPlanDetails>[].obs;
  Rx<RechargeModel> rechargeModel = RechargeModel().obs;
  RxString selectedPlanDescription = ''.obs;
  RxString amountIntoWords = ''.obs;
  RxInt rechargeStatus = (-1).obs;

  // reset recharge variables
  resetRechargeVariables() {
    mobileNumberController.clear();
    operatorController.clear();
    circleController.clear();
    amountController.clear();
    tPinController.clear();
    selectedOperatorCode.value = '';
    selectedCircleCode.value = '';
    selectedIndex.value = 0;
    selectedMPlansKey.value = '';
    selectedPlanDescription.value = '';
    amountIntoWords.value = '';
    isShowTpin.value = true;
    isShowPlanButton.value = false;
  }

  // Get master operator list
  Future<bool> getMasterOperatorList({required String operator, bool isLoaderShow = true}) async {
    try {
      List<MasterOperatorListModel> masterOperatorListModel = await rechargeRepository.getMasterOperatorListApiCall(
        operator: operator,
        isLoaderShow: isLoaderShow,
      );
      if (masterOperatorListModel.isNotEmpty) {
        masterOperatorList.clear();
        for (MasterOperatorListModel element in masterOperatorListModel) {
          if (element.status == 1 && element.name != null && element.name!.isNotEmpty) {
            masterOperatorList.add(element);
          }
        }
        masterOperatorList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        return true;
      } else {
        masterOperatorList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get master circle list
  Future<bool> getMasterCircleList({bool isLoaderShow = true}) async {
    try {
      List<MasterCircleListModel> masterCircleListModel = await rechargeRepository.getMasterCircleListApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (masterCircleListModel.isNotEmpty) {
        masterCircleList.clear();
        for (MasterCircleListModel element in masterCircleListModel) {
          if (element.status == 1) {
            masterCircleList.add(element);
          }
        }
        masterCircleList.sort((a, b) => a.name!.trim().toLowerCase().compareTo(b.name!.trim().toLowerCase()));
        return true;
      } else {
        masterCircleList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get operator fetch details
  Future<bool> getOperatorFetchDetails({bool isLoaderShow = true}) async {
    try {
      OperatorFetchModel operatorFetchModel = await rechargeRepository.getOperatorFetchApiCall(
        params: {
          'mobileNo': mobileNumberController.text.trim(),
        },
        isLoaderShow: isLoaderShow,
      );
      if (operatorFetchModel.statusCode == 1) {
        if (operatorFetchModel.data != null) {
          operatorController.clear();
          circleController.clear();
          operatorFetchData.value = operatorFetchModel.data!;
          if (operatorFetchData.value.operatorCode != null && operatorFetchData.value.operatorCode!.isNotEmpty) {
            operatorController.text = operatorFetchData.value.operator != null && operatorFetchData.value.operator!.isNotEmpty ? operatorFetchData.value.operator! : '';
            selectedOperatorCode.value = operatorFetchData.value.operatorCode != null && operatorFetchData.value.operatorCode!.isNotEmpty ? operatorFetchData.value.operatorCode! : '';
          }
          if (operatorFetchData.value.circleCode != null && operatorFetchData.value.circleCode!.isNotEmpty) {
            circleController.text = operatorFetchData.value.circle != null && operatorFetchData.value.circle!.isNotEmpty ? operatorFetchData.value.circle! : '';
            selectedCircleCode.value = operatorFetchData.value.circleCode != null && operatorFetchData.value.circleCode!.isNotEmpty ? operatorFetchData.value.circleCode! : '';
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get m plans details
  Future<bool> getMPlansList({bool isLoaderShow = true}) async {
    try {
      MPlansModel mPlansModel = await rechargeRepository.getMPlansApiCall(
        params: {
          'mobileNo': mobileNumberController.text.trim(),
          'operatorCode': selectedOperatorCode.value,
          'circleCode': selectedCircleCode.value,
        },
        isLoaderShow: isLoaderShow,
      );
      if (mPlansModel.statusCode == 1) {
        mPlansList.clear();
        if (mPlansModel.data != null) {
          mPlansModel.data!.forEach((key, value) {
            mPlansList[key] = List.from(value);
          });
          selectedMPlansList.value = mPlansList.entries.first.value;
        }
        return true;
      } else {
        mPlansList.clear();
        errorSnackBar(message: mPlansModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get r plans details
  Future<bool> getRPlansList({bool isLoaderShow = true}) async {
    try {
      RPlansModel rPlansModel = await rechargeRepository.getRPlansApiCall(
        params: {
          'mobileNo': mobileNumberController.text.trim(),
          'operatorCode': selectedOperatorCode.value,
        },
        isLoaderShow: isLoaderShow,
      );
      if (rPlansModel.statusCode == 1) {
        rPlansList.clear();
        if (rPlansModel.data != null) {
          rPlansList.value = rPlansModel.data!;
        }
        return true;
      } else {
        errorSnackBar(message: rPlansModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Mobile recharge
  Future<int> mobileRecharge({bool isLoaderShow = true}) async {
    try {
      rechargeModel.value = await rechargeRepository.rechargeApiCall(
        params: {
          'number': mobileNumberController.text.trim(),
          'operatorCode': selectedOperatorCode.value,
          'circleId': selectedCircleCode.value,
          'amount': amountController.text.trim(),
          'tpin': tPinController.text.isNotEmpty ? tPinController.text.trim() : null,
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'channel': channelID,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (rechargeModel.value.statusCode != null) {
        return rechargeModel.value.statusCode!;
      } else {
        return -1;
      }
    } catch (e) {
      dismissProgressIndicator();
      return -1;
    }
  }

  // Dth recharge
  Future<int> dthRecharge({bool isLoaderShow = true}) async {
    try {
      rechargeModel.value = await rechargeRepository.rechargeApiCall(
        params: {
          'number': mobileNumberController.text.trim(),
          'operatorCode': selectedOperatorCode.value,
          'amount': amountController.text.trim(),
          'tpin': tPinController.text.isNotEmpty ? tPinController.text.trim() : null,
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'channel': channelID,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (rechargeModel.value.statusCode != null) {
        return rechargeModel.value.statusCode!;
      } else {
        return -1;
      }
    } catch (e) {
      dismissProgressIndicator();
      return -1;
    }
  }

  // Postpaid recharge
  Future<int> postpaidRecharge({bool isLoaderShow = true}) async {
    try {
      rechargeModel.value = await rechargeRepository.rechargeApiCall(
        params: {
          'number': mobileNumberController.text.trim(),
          'operatorCode': selectedOperatorCode.value,
          'amount': amountController.text.trim(),
          'tpin': tPinController.text.isNotEmpty ? tPinController.text.trim() : null,
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'channel': channelID,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (rechargeModel.value.statusCode != null) {
        return rechargeModel.value.statusCode!;
      } else {
        return -1;
      }
    } catch (e) {
      dismissProgressIndicator();
      return -1;
    }
  }
}

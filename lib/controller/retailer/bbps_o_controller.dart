import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_manager.dart';
import '../../model/bbps/bbps_category_list_model.dart';
import '../../model/bbps/bbps_operator_grouping_list_model.dart';
import '../../model/bbps/bbps_parameters_list_model.dart';
import '../../model/bbps/bbps_sub_category_list_model.dart';
import '../../model/bbps/bill_payment_model.dart';
import '../../model/bbps/fetch_bill_model.dart';
import '../../repository/retailer/bbps_o_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class BbpsOController extends GetxController {
  BbpsORepository bbpsORepository = BbpsORepository(APIManager());

  TextEditingController searchBillerTxtController = TextEditingController();
  TextEditingController searchSubBillerTxtController = TextEditingController();
  RxBool isHideTPIN = true.obs;

  TextEditingController agentMobileNumberController = TextEditingController();
  TextEditingController tPinController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  // Category
  RxList<BbpsCategoryListModel> bbpsCategoryList = <BbpsCategoryListModel>[].obs;
  TextEditingController bbpsSearchCategoryController = TextEditingController();
  // Sub Category
  RxList<BbpsSubCategoryListModel> bbpsSubCategoryList = <BbpsSubCategoryListModel>[].obs;
  TextEditingController bbpsSearchSubCategoryController = TextEditingController();
  // Fetch Bill
  RxList<BbpsParametersListModel> bbpsParametersFieldList = <BbpsParametersListModel>[].obs;
  RxList<BbpsOperatorGroupingListModel> bbpsGroupingList = <BbpsOperatorGroupingListModel>[].obs;
  RxList<TextEditingController> valueControllers = <TextEditingController>[].obs;
  RxList<TextEditingController> selectedGroupingValueControllers = <TextEditingController>[].obs;

  Rx<FetchBillModel> fetchBillModel = FetchBillModel().obs;
  Rx<BillPaymentModel> billPaymentModel = BillPaymentModel().obs;

  RxInt serviceId = 0.obs;
  RxInt operatorId = 0.obs;
  RxInt filterVisibility = 0.obs;
  RxInt operatorParameterId = 0.obs;
  RxString selectedGroupingId = "".obs;
  RxInt bbpsStatus = (-1).obs;

  // reset recharge variables
  resetBBPSVariables() {
    agentMobileNumberController.clear();
    amountController.clear();
    tPinController.clear();
    serviceId.value = 0;
    operatorId.value = 0;
    operatorParameterId.value = 0;
    selectedGroupingId.value = '';
    isHideTPIN.value = true;
    for (TextEditingController element in valueControllers) {
      element.clear();
    }
  }

  // Get bbps category list
  Future<bool> getBbpsCategoryList({bool isLoaderShow = true}) async {
    try {
      List<BbpsCategoryListModel> bbpsCategoryListModel = await bbpsORepository.getBbpsCategory(
        isLoaderShow: isLoaderShow,
      );
      if (bbpsCategoryListModel.isNotEmpty) {
        bbpsCategoryList.clear();
        for (BbpsCategoryListModel element in bbpsCategoryListModel) {
          if (element.isoffbbps == true) {
            bbpsCategoryList.add(element);
          }
        }
        bbpsCategoryList.sort((a, b) => a.name!.toLowerCase().toString().compareTo(b.name!.toLowerCase().toString()));
        return true;
      } else {
        bbpsCategoryList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get bbps sub category list
  Future<bool> getBbpsSubCategoryList({required int serviceId, bool isLoaderShow = true}) async {
    try {
      List<BbpsSubCategoryListModel> bbpsSubCategoryListModel = await bbpsORepository.getBbpsSubCategory(
        id: serviceId,
        isLoaderShow: isLoaderShow,
      );
      if (bbpsSubCategoryListModel.isNotEmpty) {
        bbpsSubCategoryList.clear();
        for (BbpsSubCategoryListModel element in bbpsSubCategoryListModel) {
          bbpsSubCategoryList.add(element);
        }
        bbpsSubCategoryList.sort((a, b) => a.name!.toLowerCase().toString().compareTo(b.name!.toLowerCase().toString()));
        return true;
      } else {
        bbpsSubCategoryList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get bbps parameters list
  Future<bool> getBbpsParametersFieldList({required int operatorId, bool isLoaderShow = true}) async {
    try {
      List<BbpsParametersListModel> bbpsParametersListModel = await bbpsORepository.getBbpsFieldList(
        id: operatorId,
        isLoaderShow: isLoaderShow,
      );
      if (bbpsParametersListModel.isNotEmpty) {
        bbpsParametersFieldList.clear();
        for (BbpsParametersListModel element in bbpsParametersListModel) {
          if (element.isActive == true) {
            bbpsParametersFieldList.add(element);
            if (element.hasGrouping == true) {
              await getBbpsOperatorGroupingList(
                operatorId: operatorId,
                operatorParamId: element.id!,
              );
            }
            selectedGroupingValueControllers.add(TextEditingController());
            valueControllers.add(TextEditingController());
          }
        }
        bbpsParametersFieldList.sort((a, b) => a.sort!.compareTo(b.sort!));
        return true;
      } else {
        bbpsParametersFieldList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get bbps operator grouping
  Future<bool> getBbpsOperatorGroupingList({required int operatorId, required int operatorParamId, bool isLoaderShow = true}) async {
    try {
      List<BbpsOperatorGroupingListModel> bbpsOperatorGroupingListModel = await bbpsORepository.getMasterBbpsOperatorGrouping(
        operatorId: operatorId,
        operatorParamId: operatorParamId,
        isLoaderShow: isLoaderShow,
      );
      if (bbpsOperatorGroupingListModel.isNotEmpty) {
        bbpsGroupingList.clear();
        for (BbpsOperatorGroupingListModel element in bbpsOperatorGroupingListModel) {
          if (element.status == 1) {
            bbpsGroupingList.add(element);
          }
        }
        bbpsGroupingList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()),
        );
        return true;
      } else {
        bbpsGroupingList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Fetch bill details
  Future<bool> fetchBbpsBill({required String operatorCode, bool isLoaderShow = true}) async {
    try {
      fetchBillModel.value = await bbpsORepository.fetchBillDetails(
        params: {
          'mobileNo': agentMobileNumberController.text.trim(),
          'operatorCode': operatorCode,
          'consumerNumber': valueControllers[0].text.toString(),
          'accountNumber': valueControllers.length >= 2 ? valueControllers[1].text.toString() : '',
          'authenticator': valueControllers.length >= 3 ? valueControllers[2].text.toString() : '',
          'TPIN': tPinController.text.isNotEmpty ? tPinController.text : '',
          'channel': channelID,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (fetchBillModel.value.statusCode == 1) {
        amountController.text = fetchBillModel.value.data!.amount!;
        return true;
      } else if (fetchBillModel.value.statusCode == 0) {
        errorSnackBar(message: fetchBillModel.value.message!);
        return false;
      } else {
        errorSnackBar(message: fetchBillModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Pay bill
  Future<int> payBbpsBill({required String operatorCode, bool isLoaderShow = true}) async {
    try {
      billPaymentModel.value = await bbpsORepository.getPayBbpsBill(
        params: {
          'operatorCode': operatorCode,
          'amount': amountController.text.toString(),
          'number': valueControllers[0].text.toString(),
          'accountNumber': valueControllers.length >= 2 ? valueControllers[1].text.toString() : '',
          'authenticator': valueControllers.length >= 3 ? valueControllers[2].text.toString() : '',
          'mobileNo': agentMobileNumberController.text.trim(),
          'dueDate': fetchBillModel.value.data!.billDueDate!.toString(),
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'billRefNo': fetchBillModel.value.data!.billRefNumber!.toString(),
          'tpin': tPinController.text.isNotEmpty ? tPinController.text : '',
          'channel': channelID,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (billPaymentModel.value.statusCode != null) {
        return billPaymentModel.value.statusCode!;
      } else {
        return -1;
      }
    } catch (e) {
      dismissProgressIndicator();
      return -1;
    }
  }
}

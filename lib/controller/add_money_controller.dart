import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:get/get.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:weipl_checkout_flutter/weipl_checkout_flutter.dart';
import '../api/api_manager.dart';
import '../generated/assets.dart';
import '../model/add_money/add_money_model.dart';
import '../model/add_money/amount_limit_model.dart';
import '../model/add_money/check_payment_status_model.dart';
import '../model/add_money/payment_gateway_model.dart';
import '../model/add_money/settlement_cycles_model.dart';
import '../model/auth/system_wise_operation_model.dart';
import '../model/operation_model.dart';
import '../model/operation_wise_model.dart';
import '../repository/add_money_repository.dart';
import '../utils/string_constants.dart';
import '../widgets/constant_widgets.dart';

class AddMoneyController extends GetxController {
  AddMoneyRepository addMoneyRepository = AddMoneyRepository(APIManager());

  RxList<PaymentGatewayModel> paymentGatewayList = <PaymentGatewayModel>[].obs;
  RxList<SettlementCyclesModel> settlementCycleList = <SettlementCyclesModel>[].obs;
  RxList<OperationWiseModel> operationWisePaymentGatewayList = <OperationWiseModel>[].obs;

  TextEditingController amountController = TextEditingController();
  List amountList = ['500', '1000', '2000', '3000', '4000', '5000', '10000'];
  RxString selectedAmountFromList = ''.obs;
  RxString selectedAmountInText = ''.obs;
  RxString selectedPaymentGateway = ''.obs;
  TextEditingController settlementPayController = TextEditingController();
  RxInt selectedSettlementPayId = 0.obs;
  TextEditingController tPinController = TextEditingController();
  RxBool isShowTpin = true.obs;
  RxBool isAcceptAgreement = false.obs;
  Rx<AddMoney> addMoneyModel = AddMoney().obs;
  Razorpay razorpay = Razorpay();
  CFPaymentGatewayService cfPaymentGatewayService = CFPaymentGatewayService();
  CFEnvironment environment = CFEnvironment.PRODUCTION;
  late PayUCheckoutProFlutter payUCheckoutProFlutter;
  WeiplCheckoutFlutter wlCheckoutFlutter = WeiplCheckoutFlutter();
  RxInt paymentStatus = (-1).obs;

  // Reset add money variables
  resetAddMoneyVariables() {
    amountController.clear();
    selectedAmountFromList.value = '';
    selectedAmountInText.value = '';
    selectedPaymentGateway.value = '';
    settlementPayController.clear();
    selectedSettlementPayId.value = 0;
    tPinController.clear();
    isShowTpin.value = true;
    isAcceptAgreement.value = false;
    tPinController.clear();
  }

  //Get system wise operations
  RxBool isShowMobileEmailInput = false.obs;
  TextEditingController mobileTxtController = TextEditingController();
  TextEditingController emailTxtController = TextEditingController();
  Future<bool> systemWiseOperationApi({bool isLoaderShow = true}) async {
    try {
      List<SystemWiseOperationModel> operationResponse = await addMoneyRepository.getSystemWiseOperationApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (operationResponse.isNotEmpty) {
        for (SystemWiseOperationModel operation in operationResponse) {
          if (operation.code == 'PAYIN_MOBILEEMAILINPUT') {
            if (operation.status == 1) {
              isShowMobileEmailInput.value = true;
            }
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


  Future<void> getOperation({bool isLoaderShow = true}) async {
    try {
      List<OperationModel> operationListModel = await addMoneyRepository.getOperationApiCall(isLoaderShow: isLoaderShow);

      operationWisePaymentGatewayList.clear();
      if (operationListModel.isNotEmpty) {
        for (OperationModel element in operationListModel) {
          if (element.activeCount! > 0) {
            for (Operations operation in element.operations!) {
              // Add payment gateways
              if (operation.code == 'RAZORPAYPG' && operation.status == 1) {
                for (PaymentGatewayModel element in paymentGatewayListModel) {
                  if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryID == 10
                      && operation.code==element.code) {
                    operationWisePaymentGatewayList.add(OperationWiseModel(
                      icon: Assets.iconsProductIcon,
                      title: element.name!,
                      code: operation.code,
                      rank: 1,
                      isAccess: operation.isUIOperationWise != null &&
                          operation.isUIOperationWise == true
                          ? false
                          : true,
                    ));
                  }
                }
                /*operationWisePaymentGatewayList.add(OperationWiseModel(
                  icon: Assets.iconsProductIcon,
                  title: 'RAZORPAYPG',
                  code: operation.code,
                  rank: 1,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));*/
              }
              if (operation.code == 'CASHFREEPG' && operation.status == 1) {
                for (PaymentGatewayModel element in paymentGatewayListModel) {
                  if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryID == 10
                      && operation.code==element.code) {
                    operationWisePaymentGatewayList.add(OperationWiseModel(
                      icon: Assets.iconsProductIcon,
                      title: element.name!,
                      code: operation.code,
                      rank: 1,
                      isAccess: operation.isUIOperationWise != null &&
                          operation.isUIOperationWise == true
                          ? false
                          : true,
                    ));
                  }
                }
              }
              if (operation.code == 'EASEBUZZPG' && operation.status == 1) {
                for (PaymentGatewayModel element in paymentGatewayListModel) {
                  if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryID == 10
                      && operation.code==element.code) {
                    operationWisePaymentGatewayList.add(OperationWiseModel(
                      icon: Assets.iconsProductIcon,
                      title: element.name!,
                      code: operation.code,
                      rank: 1,
                      isAccess: operation.isUIOperationWise != null &&
                          operation.isUIOperationWise == true
                          ? false
                          : true,
                    ));
                  }
                }
              }
              if (operation.code == 'IMONEYPG' && operation.status == 1) {
                for (PaymentGatewayModel element in paymentGatewayListModel) {
                  if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryID == 10
                      && operation.code==element.code) {
                    operationWisePaymentGatewayList.add(OperationWiseModel(
                      icon: Assets.iconsProductIcon,
                      title: element.name!,
                      code: operation.code,
                      rank: 1,
                      isAccess: operation.isUIOperationWise != null &&
                          operation.isUIOperationWise == true
                          ? false
                          : true,
                    ));
                  }
                }
              }
              if (operation.code == 'PAYTMPG' && operation.status == 1) {
                for (PaymentGatewayModel element in paymentGatewayListModel) {
                  if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryID == 10
                      && operation.code==element.code) {
                    operationWisePaymentGatewayList.add(OperationWiseModel(
                      icon: Assets.iconsProductIcon,
                      title: element.name!,
                      code: operation.code,
                      rank: 1,
                      isAccess: operation.isUIOperationWise != null &&
                          operation.isUIOperationWise == true
                          ? false
                          : true,
                    ));
                  }
                }
              }
              if (operation.code == 'PAYUPG' && operation.status == 1) {
                for (PaymentGatewayModel element in paymentGatewayListModel) {
                  if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryID == 10
                      && operation.code==element.code) {
                    operationWisePaymentGatewayList.add(OperationWiseModel(
                      icon: Assets.iconsProductIcon,
                      title: element.name!,
                      code: operation.code,
                      rank: 1,
                      isAccess: operation.isUIOperationWise != null &&
                          operation.isUIOperationWise == true
                          ? false
                          : true,
                    ));
                  }
                }
              }
              if (operation.code == 'PAYGPG' && operation.status == 1) {
                for (PaymentGatewayModel element in paymentGatewayListModel) {
                  if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryID == 10
                      && operation.code==element.code) {
                    operationWisePaymentGatewayList.add(OperationWiseModel(
                      icon: Assets.iconsProductIcon,
                      title: element.name!,
                      code: operation.code,
                      rank: 1,
                      isAccess: operation.isUIOperationWise != null &&
                          operation.isUIOperationWise == true
                          ? false
                          : true,
                    ));
                  }
                }
              }
              if (operation.code == 'PHONEPEPG' && operation.status == 1) {
                for (PaymentGatewayModel element in paymentGatewayListModel) {
                  if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryID == 10
                      && operation.code==element.code) {
                    operationWisePaymentGatewayList.add(OperationWiseModel(
                      icon: Assets.iconsProductIcon,
                      title: element.name!,
                      code: operation.code,
                      rank: 1,
                      isAccess: operation.isUIOperationWise != null &&
                          operation.isUIOperationWise == true
                          ? false
                          : true,
                    ));
                  }
                }
              }
              if (operation.code == 'RUNPAISAPG' && operation.status == 1) {
                for (PaymentGatewayModel element in paymentGatewayListModel) {
                  if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryID == 10
                      && operation.code==element.code) {
                    operationWisePaymentGatewayList.add(OperationWiseModel(
                      icon: Assets.iconsProductIcon,
                      title: element.name!,
                      code: operation.code,
                      rank: 1,
                      isAccess: operation.isUIOperationWise != null &&
                          operation.isUIOperationWise == true
                          ? false
                          : true,
                    ));
                  }
                }
              }
              if (operation.code == 'WORLDLINEPG' && operation.status == 1) {
                for (PaymentGatewayModel element in paymentGatewayListModel) {
                  if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryID == 10
                      && operation.code==element.code) {
                    operationWisePaymentGatewayList.add(OperationWiseModel(
                      icon: Assets.iconsProductIcon,
                      title: element.name!,
                      code: operation.code,
                      rank: 1,
                      isAccess: operation.isUIOperationWise != null &&
                          operation.isUIOperationWise == true
                          ? false
                          : true,
                    ));
                  }
                }
              }


            }
          }
        }

        if (settlementServiceList.isNotEmpty) {
          settlementServiceList.sort((a, b) => a.rank!.compareTo(b.rank!));
        }
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  List<PaymentGatewayModel> paymentGatewayListModel=[];
  // Get payment gateway list
  Future<bool> getPaymentGatewayList({bool isLoaderShow = true}) async {
    try {
      paymentGatewayListModel.clear();
      paymentGatewayListModel = await addMoneyRepository.getPaymentGatewayListApiCall(isLoaderShow: isLoaderShow);
      if (paymentGatewayListModel.isNotEmpty) {
        paymentGatewayList.clear();
        for (PaymentGatewayModel element in paymentGatewayListModel) {
          if (element.status == 1 && element.code != null && element.code!.isNotEmpty && element.categoryID == 10) {
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



  // Get settlement cycle list
  Future<bool> getSettlemetCyclesList({bool isLoaderShow = true}) async {
    try {
      List<SettlementCyclesModel> settlementCycleListModel = await addMoneyRepository.getSettlementCyclesListApiCall(isLoaderShow: isLoaderShow);
      if (settlementCycleListModel.isNotEmpty) {
        settlementCycleList.clear();
        for (SettlementCyclesModel element in settlementCycleListModel) {
          if (element.status == 1 && element.settlementType != null && element.settlementType!.isNotEmpty) {
            settlementCycleList.add(element);
          }
        }
        settlementCycleList.sort((a, b) => a.settlementType!.toLowerCase().compareTo(b.settlementType!.toLowerCase()));
        return true;
      } else {
        settlementCycleList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Add money
  Future<int> addMoney({bool isLoaderShow = true}) async {
    try {
      addMoneyModel.value = await addMoneyRepository.addMoneyApiCall(
        params: {
          'amount': int.parse(amountController.text),
          'gateway': selectedPaymentGateway.value,
          'channel': channelID,
          'returnUrl': '',
          'email': isShowMobileEmailInput.value == true ? emailTxtController.text.trim() : getStoredUserBasicDetails().email,
          'mobile': isShowMobileEmailInput.value == true ? mobileTxtController.text.trim() : getStoredUserBasicDetails().mobile,
          'tpin': tPinController.text.isNotEmpty ? tPinController.text.trim() : null,
          'settlementCycle': selectedSettlementPayId.value,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (addMoneyModel.value.statusCode != null && addMoneyModel.value.statusCode == 1) {
        return addMoneyModel.value.statusCode!;
      } else {
        errorSnackBar(message: addMoneyModel.value.message);
        dismissProgressIndicator();
        return -1;
      }
    } catch (e) {
      dismissProgressIndicator();
      return -1;
    }
  }

  // Check order status
  Rx<CheckPaymentStatusModel> checkPaymentStatusModel = CheckPaymentStatusModel().obs;
  Future<int> checkOrderStatus({required String orderId, bool isLoaderShow = true}) async {
    try {
      checkPaymentStatusModel.value = await addMoneyRepository.checkOrderStatusApiCall(
        orderId: orderId,
        isLoaderShow: isLoaderShow,
      );
      if (checkPaymentStatusModel.value.statusCode != null && checkPaymentStatusModel.value.statusCode! >= 0) {
        paymentStatus.value = checkPaymentStatusModel.value.statusCode!;
        return checkPaymentStatusModel.value.statusCode!;
      } else {
        paymentStatus.value = checkPaymentStatusModel.value.statusCode!;
        errorSnackBar(message: checkPaymentStatusModel.value.message);
        return -1;
      }
    } catch (e) {
      dismissProgressIndicator();
      return -1;
    }
  }

  // Get amount limit
  RxList<AmountLimitModel> amountLimitList = <AmountLimitModel>[].obs;
  RxInt lowerLimit = 0.obs;
  RxInt upperLimit = 0.obs;
  Future<bool> getAmountLimit({bool isLoaderShow = true}) async {
    try {
      List<AmountLimitModel> amountLimitModel = await addMoneyRepository.getAmountLimitApiCall(isLoaderShow: isLoaderShow);
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

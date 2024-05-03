import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weipl_checkout_flutter/weipl_checkout_flutter.dart';
import '../../controller/add_money_controller.dart';
import '../../model/add_money/settlement_cycles_model.dart';
import '../../model/operation_wise_model.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/text_field.dart';
import '../../widgets/text_field_with_title.dart';
import 'package:crypto/crypto.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> implements PayUCheckoutProProtocol {
  final AddMoneyController addMoneyController = Get.find();
  final Rx<GlobalKey<FormState>> addMoneyFormKey = GlobalKey<FormState>().obs;
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      await addMoneyController.getPaymentGatewayList(isLoaderShow: false);
      await addMoneyController.systemWiseOperationApi(isLoaderShow: false);
      await addMoneyController.getOperation(isLoaderShow: false);
      await addMoneyController.getSettlemetCyclesList(isLoaderShow: false);
      await addMoneyController.getAmountLimit(isLoaderShow: false);

      // Razor Pay
      addMoneyController.razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
        handlePaymentSuccessResponse(orderId: addMoneyController.addMoneyModel.value.orderId!);
      });
      addMoneyController.razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
        handlePaymentFailureResponse(message: response.message!);
      });
      // Cashfree
      addMoneyController.cfPaymentGatewayService.setCallback(verifyPayment, onErrorCashFree);
      // PayU
      addMoneyController.payUCheckoutProFlutter = PayUCheckoutProFlutter(this);
      isShowTpinField.value = checkTpinRequired(categoryCode: 'Payin');
      dismissProgressIndicator();
    } catch (e) {
      isShowTpinField.value = false;
      dismissProgressIndicator();
    }
  }

  // PayU
  @override
  generateHash(Map response) {
    HashService(addMoneyController.addMoneyModel.value.acParam1!, addMoneyController.addMoneyModel.value.acParam2!);
    Map hashResponse = HashService.generateHash(response);
    addMoneyController.payUCheckoutProFlutter.hashGenerated(hash: hashResponse);
  }

  @override
  onPaymentSuccess(dynamic response) async {
    debugPrint('[PayU] => ${response.toString()}');
    handlePaymentSuccessResponse(orderId: addMoneyController.addMoneyModel.value.orderId!);
  }

  @override
  onPaymentFailure(dynamic response) {
    errorSnackBar(title: 'Payment Failed', message: response!['errorMsg'].toString());
    debugPrint('[Payment Failed] => ${response.toString()}');
    addMoneyController.resetAddMoneyVariables();
    addMoneyFormKey.value = GlobalKey<FormState>();
  }

  @override
  onPaymentCancel(Map? response) {
    errorSnackBar(title: 'Payment Cancelled', message: 'Payment cancelled by user');
    debugPrint('[PayU] => ${response.toString()}');
    addMoneyController.resetAddMoneyVariables();
    addMoneyFormKey.value = GlobalKey<FormState>();
  }

  @override
  onError(Map? response) {
    errorSnackBar(title: 'Payment Error', message: response!['errorMsg'].toString());
    debugPrint('[PayU] => ${response.toString()}');
    addMoneyController.resetAddMoneyVariables();
    addMoneyFormKey.value = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    addMoneyController.razorpay.clear();
    addMoneyController.wlCheckoutFlutter.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Add Money',
      isShowLeadingIcon: true,
      mainBody: Column(
        children: [
          height(1.h),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Obx(
                () => Form(
                  key: addMoneyFormKey.value,
                  child: Column(
                    children: [
                      height(1.h),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Amount
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Amount',
                                  style: TextHelper.size14,
                                  children: [
                                    TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                        color: ColorsForApp.errorColor,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              height(0.8.h),
                              CustomTextField(
                                controller: addMoneyController.amountController,
                                hintText: 'Enter amount',
                                suffixIcon: Icon(
                                  Icons.currency_rupee_rounded,
                                  size: 18,
                                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                                ),
                                maxLength: addMoneyController.upperLimit.value.toString().length,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                textInputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                obscureText: false,
                                onChange: (value) {
                                  addMoneyController.selectedAmountFromList.value = '';
                                  if (addMoneyController.amountController.text.isNotEmpty &&
                                      int.parse(addMoneyController.amountController.text.trim()) >= addMoneyController.lowerLimit.value &&
                                      int.parse(addMoneyController.amountController.text.trim()) <= addMoneyController.upperLimit.value) {
                                    addMoneyController.selectedAmountInText.value = getAmountIntoWords(int.parse(
                                      addMoneyController.amountController.text.trim(),
                                    ));
                                  } else {
                                    addMoneyController.selectedAmountInText.value = '';
                                  }
                                },
                                validator: (value) {
                                  String amountText = addMoneyController.amountController.text.trim();
                                  if (amountText.isEmpty) {
                                    return 'Please enter amount';
                                  } else if (int.parse(amountText) < addMoneyController.lowerLimit.value) {
                                    return 'Amount should be greater than or equal to ${addMoneyController.lowerLimit.value}';
                                  } else if (int.parse(amountText) > addMoneyController.upperLimit.value) {
                                    return 'Amount should be less than or equal to ${addMoneyController.upperLimit.value}';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          // Amount in text
                          Obx(
                            () => Visibility(
                              visible: addMoneyController.selectedAmountInText.value.isNotEmpty ? true : false,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  height(0.6.h),
                                  Text(
                                    addMoneyController.selectedAmountInText.value,
                                    style: TextHelper.size13.copyWith(
                                      fontFamily: mediumGoogleSansFont,
                                      color: ColorsForApp.successColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          height(0.8.h),
                          // Amount list
                          Wrap(
                            spacing: 10,
                            children: addMoneyController.amountList.map(
                              (e) {
                                return GestureDetector(
                                  onTap: () {
                                    addMoneyController.selectedAmountFromList.value = e;
                                    addMoneyController.amountController.text = e;
                                    FocusScope.of(context).unfocus();
                                    if (addMoneyController.amountController.text.isNotEmpty) {
                                      addMoneyController.selectedAmountInText.value = getAmountIntoWords(
                                        int.parse(addMoneyController.amountController.text.trim()),
                                      );
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: addMoneyController.selectedAmountFromList.value == e ? ColorsForApp.primaryColor : ColorsForApp.primaryColor.withOpacity(0.05),
                                    ),
                                    child: Text(
                                      e,
                                      style: TextHelper.size14.copyWith(
                                        fontFamily: addMoneyController.selectedAmountFromList.value == e ? mediumGoogleSansFont : regularGoogleSansFont,
                                        color: addMoneyController.selectedAmountFromList.value == e ? ColorsForApp.whiteColor : ColorsForApp.lightBlackColor,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                          height(1.h),
                          // Payment gateway
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Payment Gateway',
                              style: TextHelper.size14,
                              children: [
                                TextSpan(
                                  text: ' *',
                                  style: TextStyle(
                                    color: ColorsForApp.errorColor,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          height(1.h),
                          // operation wise payment gateway list
                          Obx(
                            () => addMoneyController.operationWisePaymentGatewayList.isNotEmpty
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 3, crossAxisSpacing: 1),
                                    itemCount: addMoneyController.operationWisePaymentGatewayList.length,
                                    itemBuilder: (context, index) {
                                      OperationWiseModel operationWiseService = addMoneyController.operationWisePaymentGatewayList[index];
                                      return InkWell(
                                        onTap: () async {
                                          if (isInternetAvailable.value) {
                                            if (operationWiseService.isAccess == false) {
                                              showCommonMessageDialog(context, 'Access', 'You don\'t have access please contact to administrator');
                                            } else {
                                              switch (operationWiseService.code) {
                                                case 'RAZORPAYPG':
                                                  addMoneyController.selectedPaymentGateway.value = operationWiseService.code!;
                                                  break;
                                                case 'CASHFREEPG':
                                                  addMoneyController.selectedPaymentGateway.value = operationWiseService.code!;
                                                  break;
                                                case 'EASEBUZZPG':
                                                  addMoneyController.selectedPaymentGateway.value = operationWiseService.code!;
                                                  break;
                                                case 'IMONEYPG':
                                                  addMoneyController.selectedPaymentGateway.value = operationWiseService.code!;
                                                  break;
                                                case 'PAYTMPG':
                                                  addMoneyController.selectedPaymentGateway.value = operationWiseService.code!;
                                                  break;
                                                case 'PAYUPG':
                                                  addMoneyController.selectedPaymentGateway.value = operationWiseService.code!;
                                                  break;
                                                case 'PAYGPG':
                                                  addMoneyController.selectedPaymentGateway.value = operationWiseService.code!;
                                                  break;
                                                case 'PHONEPEPG':
                                                  addMoneyController.selectedPaymentGateway.value = operationWiseService.code!;
                                                  break;
                                                case 'RUNPAISAPG':
                                                  addMoneyController.selectedPaymentGateway.value = operationWiseService.code!;
                                                  break;
                                                case 'WORLDLINEPG':
                                                  addMoneyController.selectedPaymentGateway.value = operationWiseService.code!;
                                                  break;
                                              }
                                            }
                                          } else {
                                            errorSnackBar(message: noInternetMsg);
                                          }
                                        },
                                        child: Obx(
                                          () => Container(
                                            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(7),
                                              color: addMoneyController.selectedPaymentGateway.value == operationWiseService.code ? ColorsForApp.primaryColor : ColorsForApp.greyColor.withOpacity(0.05),
                                            ),
                                            child: Text(
                                              operationWiseService.title,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              style: TextHelper.size13.copyWith(
                                                color: addMoneyController.operationWisePaymentGatewayList[index].code == addMoneyController.selectedPaymentGateway.value ? ColorsForApp.whiteColor : ColorsForApp.lightBlackColor,
                                                fontFamily: addMoneyController.selectedPaymentGateway.value == operationWiseService.code ? mediumGoogleSansFont : regularGoogleSansFont,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Container(),
                          ),
                          height(1.h),
                          // Settlement pay
                          CustomTextFieldWithTitle(
                            controller: addMoneyController.settlementPayController,
                            title: 'Settlement Pay',
                            hintText: 'Select settlement pay',
                            readOnly: true,
                            isCompulsory: true,
                            onTap: () async {
                              SettlementCyclesModel selectedSettlementPay = await Get.toNamed(
                                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                                arguments: [
                                  addMoneyController.settlementCycleList, // modelList
                                  'settlementCycle', // modelName
                                ],
                              );
                              if (selectedSettlementPay.settlementType != null && selectedSettlementPay.settlementType!.isNotEmpty && selectedSettlementPay.id != null) {
                                addMoneyController.settlementPayController.text = selectedSettlementPay.settlementType!;
                                addMoneyController.selectedSettlementPayId.value = selectedSettlementPay.id!;
                              }
                            },
                            validator: (value) {
                              if (addMoneyController.settlementPayController.text.trim().isEmpty) {
                                return 'Please select settlement pay';
                              }
                              return null;
                            },
                            suffixIcon: GestureDetector(
                              onTap: () async {
                                SettlementCyclesModel selectedSettlementPay = await Get.toNamed(
                                  Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                                  arguments: [
                                    addMoneyController.settlementCycleList, // modelList
                                    'settlementCycle', // modelName
                                  ],
                                );
                                if (selectedSettlementPay.settlementType != null && selectedSettlementPay.settlementType!.isNotEmpty && selectedSettlementPay.id != null) {
                                  addMoneyController.settlementPayController.text = selectedSettlementPay.settlementType!;
                                  addMoneyController.selectedSettlementPayId.value = selectedSettlementPay.id!;
                                }
                              },
                              child: Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: ColorsForApp.greyColor,
                              ),
                            ),
                          ),
                          // Email
                          Visibility(
                            visible: addMoneyController.isShowMobileEmailInput.value,
                            child: CustomTextFieldWithTitle(
                              controller: addMoneyController.emailTxtController,
                              title: 'Email',
                              hintText: 'Enter email',
                              isCompulsory: true,
//readOnly: userData.email!=null?true:false,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (addMoneyController.emailTxtController.text.trim().isEmpty) {
                                  return 'Please enter email';
                                } else if (!GetUtils.isEmail(addMoneyController.emailTxtController.text.trim())) {
                                  return 'Please enter a valid email';
                                }

                                return null;
                              },

                              suffixIcon: Icon(
                                Icons.email,
                                size: 18,
                                color: ColorsForApp.secondaryColor,
                              ),
                            ),
                          ),
// Mobile
                          Visibility(
                            visible: addMoneyController.isShowMobileEmailInput.value,
                            child: CustomTextFieldWithTitle(
                              controller: addMoneyController.mobileTxtController,
                              title: 'Mobile',
                              hintText: 'Enter mobile',
                              isCompulsory: true,
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              textInputFormatter: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],
                              validator: (value) {
                                if (addMoneyController.mobileTxtController.text.trim().isEmpty) {
                                  return 'Please enter mobile number';
                                } else if (addMoneyController.mobileTxtController.text.length < 10) {
                                  return 'Please enter valid mobile number';
                                }

                                return null;
                              },
                              suffixIcon: Icon(
                                Icons.call,
                                size: 18,
                                color: ColorsForApp.secondaryColor,
                              ),
                            ),
                          ),
                          // TPIN
                          Visibility(
                            visible: isShowTpinField.value,
                            child: Obx(
                              () => CustomTextFieldWithTitle(
                                controller: addMoneyController.tPinController,
                                title: 'TPIN',
                                hintText: 'Enter TPIN',
                                maxLength: 4,
                                isCompulsory: true,
                                obscureText: addMoneyController.isShowTpin.value,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    addMoneyController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                                    size: 18,
                                    color: ColorsForApp.secondaryColor,
                                  ),
                                  onPressed: () {
                                    addMoneyController.isShowTpin.value = !addMoneyController.isShowTpin.value;
                                  },
                                ),
                                textInputFormatter: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                                validator: (value) {
                                  if (addMoneyController.tPinController.text.trim().isEmpty) {
                                    return 'Please enter TPIN';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          height(1.h),
                          // Agreement
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(
                                () => Checkbox(
                                  activeColor: ColorsForApp.primaryColor,
                                  value: addMoneyController.isAcceptAgreement.value,
                                  onChanged: (bool? value) {
                                    addMoneyController.isAcceptAgreement.value = value!;
                                  },
                                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                              width(4),
                              Expanded(
                                child: Text(
                                  'You certify that the Credit Card/Debit Card/Net Banking Account being used for this transaction belongs to your company or an authorized employee of your company i.e. it does not belong to a customer or a passenger.',
                                  style: TextHelper.size13,
                                ),
                              ),
                            ],
                          ),
                          height(2.h),
                          // Proceed button
                          CommonButton(
                            bgColor: ColorsForApp.primaryColor,
                            labelColor: ColorsForApp.whiteColor,
                            label: 'Proceed',
                            onPressed: () async {
                              if (addMoneyFormKey.value.currentState!.validate()) {
                                if (addMoneyController.selectedPaymentGateway.value.isEmpty) {
                                  errorSnackBar(message: 'Please select payment gateway');
                                } else if (addMoneyController.settlementPayController.text == '' || addMoneyController.settlementPayController.text.isEmpty) {
                                  errorSnackBar(message: 'Please select settlement pay');
                                } else if (addMoneyController.isAcceptAgreement.value == false) {
                                  errorSnackBar(message: 'Please select agreement');
                                } else {
                                  int result = await addMoneyController.addMoney();
                                  if (result == 1) {
                                    if (addMoneyController.selectedPaymentGateway.value == 'RAZORPAYPG') {
                                      razorPayInit();
                                    } else if (addMoneyController.selectedPaymentGateway.value == 'CASHFREEPG') {
                                      cashFreeInit();
                                    } else if (addMoneyController.selectedPaymentGateway.value == 'PAYGPG') {
                                      if (context.mounted) {
                                        payGInit(context, addMoneyController.addMoneyModel.value.paymentUrl!);
                                      }
                                    } else if (addMoneyController.selectedPaymentGateway.value == 'PAYUPG') {
                                      payUInit();
                                    } else if (addMoneyController.selectedPaymentGateway.value == 'PHONEPEPG') {
                                      phonePeInit();
                                    } else if (addMoneyController.selectedPaymentGateway.value == 'WORLDLINEPG') {
                                      worldlineInit();
                                    } else if (addMoneyController.selectedPaymentGateway.value == 'RUNPAISAPG') {
                                      if (context.mounted) {
                                        runPaisaInit(context, addMoneyController.addMoneyModel.value.paymentUrl!);
                                      }
                                    } else if (addMoneyController.selectedPaymentGateway.value == 'PAYTMPG') {
                                      paytmInit();
                                    } else if (addMoneyController.selectedPaymentGateway.value == 'EASEBUZZPG') {
                                      redirectToEasebuzz();
                                    }
                                  } else {
                                    dismissProgressIndicator();
                                  }
                                }
                              }
                            },
                          ),
                          height(2.h),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Payment success response handle
  Future<void> handlePaymentSuccessResponse({required String orderId}) async {
    int result = -1;
    result = await addMoneyController.checkOrderStatus(orderId: orderId);
    if (result > 0) {
      await Get.toNamed(Routes.ADD_MONEY_STATUS_SCREEN);
      addMoneyFormKey.value = GlobalKey<FormState>();
    }
  }

  // Payment failure response handle
  Future<void> handlePaymentFailureResponse({required String message}) async {
    errorSnackBar(title: 'Payment Failed', message: message);
    debugPrint('[Payment Failed] => $message');
    addMoneyController.resetAddMoneyVariables();
    addMoneyFormKey.value = GlobalKey<FormState>();
  }

  /////////////////
  /// Razor Pay ///
  /////////////////

  razorPayInit() {
    try {
      Map<String, dynamic> options = {
        'key': addMoneyController.addMoneyModel.value.acParam1,
        'order_id': addMoneyController.addMoneyModel.value.orderId,
        'currency': 'INR',
        'timeout': 600,
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'prefill': {
          'contact': addMoneyController.addMoneyModel.value.mobileNo,
          'email': addMoneyController.addMoneyModel.value.email,
        },
      };
      addMoneyController.razorpay.open(options);
    } catch (e) {
      debugPrint('[Razorpay] => $e');
    }
  }

  /////////////////
  /// Cash Free ///
  /////////////////

  Future<void> verifyPayment(String orderId) async {
    int result = -1;
    result = await addMoneyController.checkOrderStatus(orderId: addMoneyController.addMoneyModel.value.orderId!);
    if (result > 0) {
      await Get.toNamed(Routes.ADD_MONEY_STATUS_SCREEN);
      addMoneyFormKey.value = GlobalKey<FormState>();
    }
  }

  void onErrorCashFree(CFErrorResponse errorResponse, String orderId) {
    errorSnackBar(title: 'Payment Failed', message: errorResponse.getMessage());
    debugPrint('[Cashfree] => $errorResponse.getMessage()');
    addMoneyController.resetAddMoneyVariables();
    addMoneyFormKey.value = GlobalKey<FormState>();
  }

  CFSession? createSession() {
    try {
      CFSession session = CFSessionBuilder().setEnvironment(addMoneyController.environment).setOrderId(addMoneyController.addMoneyModel.value.orderId!).setPaymentSessionId(addMoneyController.addMoneyModel.value.paymentId!).build();
      return session;
    } on CFException catch (e) {
      debugPrint(e.message);
    }
    return null;
  }

  cashFreeInit() {
    try {
      CFSession? session = createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      components.add(CFPaymentModes.CARD);
      components.add(CFPaymentModes.UPI);
      components.add(CFPaymentModes.NETBANKING);
      components.add(CFPaymentModes.WALLET);
      components.add(CFPaymentModes.PAYLATER);
      components.add(CFPaymentModes.EMI);
      CFPaymentComponent paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();
      CFTheme theme = CFThemeBuilder().setNavigationBarBackgroundColorColor('#0A1852').build();
      CFDropCheckoutPayment cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(session!).setPaymentComponent(paymentComponent).setTheme(theme).build();
      addMoneyController.cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
    } catch (e) {
      debugPrint('[Cashfree] => $e');
    }
  }

  /////////////
  /// Pay G ///
  /////////////

  payGInit(BuildContext context, String url) async {
    bool result = await Get.toNamed(
      Routes.WEB_VIEW_SCREEN,
      arguments: [url, 'PayG'],
    );
    if (result == true) {
      int result = -1;
      result = await addMoneyController.checkOrderStatus(orderId: addMoneyController.addMoneyModel.value.orderId!);
      if (result > 0) {
        await Get.toNamed(Routes.ADD_MONEY_STATUS_SCREEN);
        addMoneyFormKey.value = GlobalKey<FormState>();
      }
    }
  }

  /////////////
  /// Pay U ///
  /////////////

  payUInit() {
    addMoneyController.payUCheckoutProFlutter.openCheckoutScreen(
      payUPaymentParams: {
        PayUPaymentParamKey.key: addMoneyController.addMoneyModel.value.acParam1,
        PayUPaymentParamKey.userCredential: '${addMoneyController.addMoneyModel.value.acParam1}:${addMoneyController.addMoneyModel.value.email}',
        PayUPaymentParamKey.amount: addMoneyController.addMoneyModel.value.amount,
        PayUPaymentParamKey.firstName: addMoneyController.addMoneyModel.value.name,
        PayUPaymentParamKey.email: addMoneyController.addMoneyModel.value.email,
        PayUPaymentParamKey.phone: addMoneyController.addMoneyModel.value.mobileNo,
        PayUPaymentParamKey.ios_surl: addMoneyController.addMoneyModel.value.callbackUrl,
        PayUPaymentParamKey.ios_furl: addMoneyController.addMoneyModel.value.callbackUrl,
        PayUPaymentParamKey.android_surl: addMoneyController.addMoneyModel.value.callbackUrl,
        PayUPaymentParamKey.android_furl: addMoneyController.addMoneyModel.value.callbackUrl,
        PayUPaymentParamKey.environment: '0', // 0 => Production 1 => Test
        PayUPaymentParamKey.transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
        PayUPaymentParamKey.enableNativeOTP: true,
      },
      payUCheckoutProConfig: {
        PayUCheckoutProConfigKeys.merchantName: appName,
        PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
        PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
        PayUCheckoutProConfigKeys.autoSelectOtp: true,
        PayUCheckoutProConfigKeys.autoApprove: true,
        PayUCheckoutProConfigKeys.merchantSMSPermission: true,
        PayUCheckoutProConfigKeys.showCbToolbar: true,
      },
    );
  }

  ////////////////
  /// Phone Pe ///
  ////////////////

  phonePeInit() async {
    try {
      bool isInitialized = await PhonePePaymentSdk.init('PRODUCTION', 'UoXasKkW9qz8NDAspKUMNzgUdBk=', addMoneyController.addMoneyModel.value.acParam1!, true);
      if (isInitialized == true) {
        debugPrint('[Phone Pe SDK Initialized] => $isInitialized');
        String body = addMoneyController.addMoneyModel.value.acParam2!;
        String callbackUrl = addMoneyController.addMoneyModel.value.callbackUrl!;
        String checksum = addMoneyController.addMoneyModel.value.paymentId!;
        await PhonePePaymentSdk.startTransaction(body, callbackUrl, checksum, 'com.phonepe.app').then((response) async {
          if (response != null) {
            log('[Phone Pe] => $response');
            String status = response['status'].toString();
            String error = response['error'].toString();
            if (status == 'SUCCESS') {
              await handlePaymentSuccessResponse(orderId: addMoneyController.addMoneyModel.value.orderId!);
            } else {
              await handlePaymentFailureResponse(message: error);
            }
          } else {
            await handlePaymentFailureResponse(message: 'Payment Incomplate');
          }
        }).catchError((e) async {
          await handlePaymentFailureResponse(message: e);
        });
      } else {
        errorSnackBar(message: 'PhonePe not initialize');
      }
    } catch (e) {
      await handlePaymentFailureResponse(message: e.toString());
    }
  }

  /////////////////
  /// Run Paisa ///
  /////////////////

  runPaisaInit(BuildContext context, String url) async {
    bool result = await Get.toNamed(
      Routes.WEB_VIEW_SCREEN,
      arguments: [url, 'Run Paisa'],
    );
    if (result == true) {
      int result = -1;
      result = await addMoneyController.checkOrderStatus(orderId: addMoneyController.addMoneyModel.value.orderId!);
      if (result > 0) {
        await Get.toNamed(Routes.ADD_MONEY_STATUS_SCREEN);
        addMoneyFormKey.value = GlobalKey<FormState>();
      }
    }
  }

  /////////////////
  /// Worldline ///
  /////////////////

  worldlineInit() async {
    String deviceID = Platform.isAndroid ? 'AndroidSH2' : 'iOSSH2';

    var reqJson = {
      'features': {
        'enableAbortResponse': true,
        'enableExpressPay': true,
        'enableInstrumentDeRegistration': true,
        'enableMerTxnDetails': true,
      },
      'consumerData': {
        'deviceId': deviceID,
        'token': addMoneyController.addMoneyModel.value.paymentUrl!,
        'paymentMode': 'all',
        'merchantLogoUrl': appIcon.value,
        'merchantId': addMoneyController.addMoneyModel.value.acParam1,
        'currency': 'INR',
        'consumerId': addMoneyController.addMoneyModel.value.paymentId,
        'consumerMobileNo': addMoneyController.addMoneyModel.value.mobileNo,
        'consumerEmailId': addMoneyController.addMoneyModel.value.email,
        'txnId': addMoneyController.addMoneyModel.value.orderId,
        'items': [
          {
            'itemId': 'first',
            'amount': addMoneyController.addMoneyModel.value.amount.toString(),
            'comAmt': '0',
          }
        ],
        'customStyle': {
          'PRIMARY_COLOR_CODE': '#0A1852', //merchant primary color code
          'SECONDARY_COLOR_CODE': '#6C82BA', //provide merchant's suitable color code
          'BUTTON_COLOR_CODE_1': '#0A1852', //merchant's button background color code
          'BUTTON_COLOR_CODE_2': '#FFFFFF' //provide merchant's suitable color code for button text
        }
      }
    };
    debugPrint('[Worldline PG] => ${reqJson.toString()}');

    addMoneyController.wlCheckoutFlutter.on(
      WeiplCheckoutFlutter.wlResponse,
      (Map<dynamic, dynamic> response) {
        debugPrint(response.toString());
        String res = response['msg'];
        List<String> tempResList = res.split('|');
        if (tempResList.isNotEmpty) {
          String statusCode = tempResList[0];
          // 0300->Success | 0398->Initiated | 0399->Failed | 0396->Awaited | 0392->Aborted
          if (statusCode == '0300' || statusCode == '0396') {
            handlePaymentSuccessResponse(orderId: tempResList[3]);
          } else if (statusCode == '0392' || statusCode == '0398' || statusCode == '0399') {
            handlePaymentFailureResponse(message: tempResList[2]);
          }
        }
      },
    );
    addMoneyController.wlCheckoutFlutter.open(reqJson);
  }

  /////////////
  /// Paytm ///
  /////////////

  paytmInit() async {
    await AllInOneSdk.startTransaction(
      addMoneyController.addMoneyModel.value.acParam1!,
      addMoneyController.addMoneyModel.value.ourOrderId!,
      addMoneyController.addMoneyModel.value.amount.toString(),
      addMoneyController.addMoneyModel.value.orderId!,
      addMoneyController.addMoneyModel.value.callbackUrl!,
      true,
      false,
    ).then((response) {
      if (response!['STATUS'] == 'TXN_SUCCESS') {
        handlePaymentSuccessResponse(orderId: addMoneyController.addMoneyModel.value.orderId!);
      }
      debugPrint(response.toString());
    }).catchError((error) {
      if (error is PlatformException) {
        handlePaymentFailureResponse(message: error.message.toString());
      } else {
        handlePaymentFailureResponse(message: error.toString());
      }
    });
  }

  redirectToEasebuzz() async {
    String accessKey = addMoneyController.addMoneyModel.value.data!.hash!.toString();
    String payMode = addMoneyController.addMoneyModel.value.data!.paymode!.toString();
    debugPrint("Easebuzz accessKey ==> $accessKey");
    debugPrint("Easebuzz payMode ==> $payMode");

    Object parameters = {
      "access_key": accessKey,
      "pay_mode": payMode,
    };

    debugPrint('Easebuzz parameters ==> $parameters');

    Map paymentResponse = await platformMethodChannel.invokeMethod("payWithEasebuzz", parameters);
    debugPrint("Easebuzz response ==> $paymentResponse");

    showEasebuzzResponseDialog(paymentResponse);
  }

  void showEasebuzzResponseDialog(Map paymentResponse) {
    String title = "";
    String strMessage = "";
    addMoneyController.resetAddMoneyVariables();
    addMoneyFormKey.value = GlobalKey<FormState>();

    if (paymentResponse['result'] == "payment_successfull") {
      title = "Success";
      strMessage = "Your payment is successful";
    } else {
      title = "Failed";
      strMessage = "Your payment is failed/ Cancelled by user";
    }
    //{result: payment_successfull,
    // payment_response: {
    // firstname: harsh,
    // merchant_logo: NA,
    // cardCategory: NA, udf10: ,
    // error: APPROVED OR COMPLETED SUCCESSFULLY,
    // addedon: 2024-02-08 05:51:40,
    // mode: UPI, udf9: , udf7: ,
    // issuing_bank: NA, udf8: ,
    // cash_back_percentage: 50.0,
    // bank_name: NA,
    // deduction_percentage: 0.0,
    // error_Message: APPROVED OR COMPLETED SUCCESSFULLY,
    // payment_source: Easebuzz,
    // bank_ref_num: 403962971091,
    // key: DYHIMA9X2Q,
    // upi_va: nikchawda091@ybl,
    // bankcode: NA,
    // email: rishisharma255@gmail.com,
    // txnid: 1390,
    // amount: 1.0,
    // unmappedstatus: NA,
    // easepayid: E240208E47DYFX, udf5: , udf6: , udf3: ,
    // surl: https://api1.pay99.co.in/gateway,
    // net_amount_debit: 1.0, udf4: , card_type: UPI, udf1: , udf2: ,
    // cardnum: NA, phone: 8956488401,
    // furl: https://api1.pay99.co.in/gateway,
    // productinfo: AddMoney,
    // hash: 9a17f9a160ae6c3a86e4aba3810bf661269150f6febbb8d91336b65e2659d2fc01a4111e803cdd040e87c050f183adcec1edbf3a36fe96c74ab96ab615f48c66,
    // PG_TYPE: NA,
    // name_on_card: NA,
    // status: success}}

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              style: TextHelper.size16.copyWith(fontFamily: mediumGoogleSansFont, color: title == "Success" ? Colors.green : Colors.red),
            ),
            content: Text(strMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Perform the positive action
                  // For example, you can navigate to another screen or close the dialog
                  Navigator.of(context).pop(); // Close the dialog
                  // Add your desired action here
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  void redirectionToPG(String hash, String payMode) async {
    String accessKey = hash;
    String paymode = payMode;
    double amount = addMoneyController.addMoneyModel.value.amount as double;
    Object parameters = {'access_key': accessKey, 'pay_mode': paymode, 'amount': amount};
    final paymentResponse = await platformMethodChannel.invokeMethod('payWithEasebuzz', parameters);
    /* payment_response is the HashMap containing the response of the payment.
You can parse it accordingly to handle response */

    String result = paymentResponse['result'];
    debugPrint('Easebuzz Pg$result');

    // String detailedResponse = paymentResponse['payment_response'];
  }
}

// Webview for pay-g/run paisa
class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  final AddMoneyController addMoneyController = Get.find();
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  String url = Get.arguments[0];
  String returnUrl = '';
  String title = Get.arguments[1];

  @override
  void initState() {
    super.initState();
    if (title.toLowerCase() == 'payg') {
      returnUrl = 'https://payg.in/payment/paymentresponse?orderid=${addMoneyController.addMoneyModel.value.orderId}';
    } else if (title.toLowerCase() == 'run paisa') {
      // https://api.pg.runpaisa.com/transaction
      // https://api.pg.runpaisa.com/cashfreeadpgnotify?order_id=901
      returnUrl = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: title,
      isShowLeadingIcon: true,
      onBackIconTap: () {
        if (url == returnUrl) {
          Get.back(result: true);
        } else {
          Get.back(result: false);
        }
      },
      mainBody: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: WebUri(url)),
          initialSettings: InAppWebViewSettings(
            isInspectable: kDebugMode,
            supportZoom: false,
            underPageBackgroundColor: Colors.white,
          ),
          onWebViewCreated: (controller) async {
            webViewController = controller;
          },
          onLoadStart: (controller, url) async {
            setState(() {
              this.url = url.toString();
            });
          },
          onLoadStop: (controller, url) async {
            setState(() {
              this.url = url.toString();
            });
          },
          onUpdateVisitedHistory: (controller, url, isReload) {
            setState(() {
              this.url = url.toString();
            });
          },
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(resources: request.resources, action: PermissionResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;
            if (!['http', 'https', 'file', 'chrome', 'data', 'javascript', 'about'].contains(uri.scheme)) {
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
                return NavigationActionPolicy.CANCEL;
              }
            }
            return NavigationActionPolicy.ALLOW;
          },
        ),
      ),
    );
  }
}

// Generate hash for pay-u payment gateway
class HashService {
  final AddMoneyController addMoneyController = Get.find();
  static String merchantSecretKey = '';
  static String merchantSalt = '';
  HashService(String key, String salt) {
    merchantSecretKey = key;
    merchantSalt = salt;
  }

  static Map generateHash(Map response) {
    var hashName = response[PayUHashConstantsKeys.hashName];
    var hashStringWithoutSalt = response[PayUHashConstantsKeys.hashString];
    var hashType = response[PayUHashConstantsKeys.hashType];
    var postSalt = response[PayUHashConstantsKeys.postSalt];
    var hash = '';

    if (hashType == PayUHashConstantsKeys.hashVersionV2) {
      hash = getHmacSHA256Hash(hashStringWithoutSalt, merchantSalt);
    } else if (hashName == PayUHashConstantsKeys.mcpLookup) {
      hash = getHmacSHA1Hash(hashStringWithoutSalt, merchantSecretKey);
    } else {
      var hashDataWithSalt = hashStringWithoutSalt + merchantSalt;
      if (postSalt != null) {
        hashDataWithSalt = hashDataWithSalt + postSalt;
      }
      hash = getSHA512Hash(hashDataWithSalt);
    }
    var finalHash = {hashName: hash};
    return finalHash;
  }

  static String getSHA512Hash(String hashData) {
    var bytes = utf8.encode(hashData);
    var hash = sha512.convert(bytes);
    return hash.toString();
  }

  static String getHmacSHA256Hash(String hashData, String salt) {
    var key = utf8.encode(salt);
    var bytes = utf8.encode(hashData);
    final hmacSha256 = Hmac(sha256, key).convert(bytes).bytes;
    final hmacBase64 = base64Encode(hmacSha256);
    return hmacBase64;
  }

  static String getHmacSHA1Hash(String hashData, String salt) {
    var key = utf8.encode(salt);
    var bytes = utf8.encode(hashData);
    var hmacSha1 = Hmac(sha1, key);
    var hash = hmacSha1.convert(bytes);
    return hash.toString();
  }
}

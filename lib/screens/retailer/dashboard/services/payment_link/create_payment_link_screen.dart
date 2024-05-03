import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/payment_link_controller.dart';
import '../../../../../model/add_money/settlement_cycles_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field.dart';
import '../../../../../widgets/text_field_with_title.dart';

class CreatePaymentLinkScreen extends StatefulWidget {
  const CreatePaymentLinkScreen({Key? key}) : super(key: key);

  @override
  State<CreatePaymentLinkScreen> createState() => _CreatePaymentLinkScreenState();
}

class _CreatePaymentLinkScreenState extends State<CreatePaymentLinkScreen> {
  final PaymentLinkController paymentLinkController = Get.find();
  final GlobalKey<FormState> createPaymentLinkFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      if (paymentLinkController.paymentGatewayList.isEmpty) {
        await paymentLinkController.getPaymentGatewayList(isLoaderShow: false);
      }
      if (paymentLinkController.settlementCycleList.isEmpty) {
        await paymentLinkController.getSettlemetCyclesList(isLoaderShow: false);
      }
      await paymentLinkController.getAmountLimit(isLoaderShow: false);
      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    paymentLinkController.resetCreatePaymentLinkVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Create Payment Link',
      isShowLeadingIcon: true,
      mainBody: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Form(
          key: createPaymentLinkFormKey,
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(2.h),
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
                height(0.5.h),
                // Payment gateway list
                Wrap(
                  spacing: 10,
                  children: paymentLinkController.paymentGatewayList.map(
                    (e) {
                      return GestureDetector(
                        onTap: () {
                          paymentLinkController.selectedPaymentGateway.value = e.code!;
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: paymentLinkController.selectedPaymentGateway.value == e.code ? ColorsForApp.primaryColor : ColorsForApp.primaryColor.withOpacity(0.05),
                          ),
                          child: Text(
                            e.name != null && e.name!.isNotEmpty ? e.name! : '-',
                            style: TextHelper.size14.copyWith(
                              fontFamily: paymentLinkController.selectedPaymentGateway.value == e.code ? mediumGoogleSansFont : regularGoogleSansFont,
                              color: paymentLinkController.selectedPaymentGateway.value == e.code ? ColorsForApp.whiteColor : ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
                height(1.h),
                // Settlement cycle
                CustomTextFieldWithTitle(
                  controller: paymentLinkController.settlementCycleController,
                  title: 'Settlement Cycle',
                  hintText: 'Select settlement cycle',
                  readOnly: true,
                  isCompulsory: true,
                  onTap: () async {
                    SettlementCyclesModel selectedSettlementPay = await Get.toNamed(
                      Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                      arguments: [
                        paymentLinkController.settlementCycleList, // modelList
                        'settlementCycle', // modelName
                      ],
                    );
                    if (selectedSettlementPay.settlementType != null && selectedSettlementPay.settlementType!.isNotEmpty && selectedSettlementPay.id != null) {
                      paymentLinkController.settlementCycleController.text = selectedSettlementPay.settlementType!;
                      paymentLinkController.selectedSettlementCycleId.value = selectedSettlementPay.id!;
                    }
                  },
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (paymentLinkController.settlementCycleController.text.trim().isEmpty) {
                      return 'Please select settlement cycle';
                    }
                    return null;
                  },
                ),
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
                      controller: paymentLinkController.amountController,
                      hintText: 'Enter amount',
                      maxLength: paymentLinkController.upperLimit.value.toString().length,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      suffixIcon: Icon(
                        Icons.currency_rupee_rounded,
                        size: 18,
                        color: ColorsForApp.secondaryColor.withOpacity(0.5),
                      ),
                      onChange: (value) {
                        paymentLinkController.selectedAmountFromList.value = '';
                        if (paymentLinkController.selectedPaymentGateway.value == 'RUNPAISAPG') {
                          if (paymentLinkController.amountController.text.isNotEmpty &&
                              int.parse(paymentLinkController.amountController.text) >= 10 &&
                              int.parse(paymentLinkController.amountController.text.trim()) < paymentLinkController.upperLimit.value) {
                            paymentLinkController.selectedAmountInText.value = getAmountIntoWords(int.parse(
                              paymentLinkController.amountController.text.trim(),
                            ));
                          } else {
                            paymentLinkController.selectedAmountInText.value = '';
                          }
                        } else {
                          if (paymentLinkController.amountController.text.isNotEmpty &&
                              int.parse(paymentLinkController.amountController.text.trim()) >= paymentLinkController.lowerLimit.value &&
                              int.parse(paymentLinkController.amountController.text.trim()) <= paymentLinkController.upperLimit.value) {
                            paymentLinkController.selectedAmountInText.value = getAmountIntoWords(int.parse(
                              paymentLinkController.amountController.text.trim(),
                            ));
                          } else {
                            paymentLinkController.selectedAmountInText.value = '';
                          }
                        }
                      },
                      validator: (value) {
                        String amountText = paymentLinkController.amountController.text.trim();
                        if (amountText.isEmpty) {
                          return 'Please enter amount';
                        } else if (int.parse(amountText) < paymentLinkController.lowerLimit.value) {
                          return 'Amount should be greater than or equal to ${paymentLinkController.lowerLimit.value}';
                        } else if (int.parse(amountText) > paymentLinkController.upperLimit.value) {
                          return 'Amount should be less than or equal to ${paymentLinkController.upperLimit.value}';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                // Amount in text
                Obx(
                  () => Visibility(
                    visible: paymentLinkController.selectedAmountInText.value.isNotEmpty ? true : false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(0.6.h),
                        Text(
                          paymentLinkController.selectedAmountInText.value,
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
                  children: paymentLinkController.amountList.map(
                    (e) {
                      return GestureDetector(
                        onTap: () {
                          paymentLinkController.selectedAmountFromList.value = e;
                          paymentLinkController.amountController.text = e;
                          FocusScope.of(context).unfocus();
                          if (paymentLinkController.amountController.text.isNotEmpty) {
                            paymentLinkController.selectedAmountInText.value = getAmountIntoWords(
                              int.parse(paymentLinkController.amountController.text.trim()),
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: paymentLinkController.selectedAmountFromList.value == e ? ColorsForApp.primaryColor : ColorsForApp.primaryColor.withOpacity(0.05),
                          ),
                          child: Text(
                            e,
                            style: TextHelper.size14.copyWith(
                              fontFamily: paymentLinkController.selectedAmountFromList.value == e ? mediumGoogleSansFont : regularGoogleSansFont,
                              color: paymentLinkController.selectedAmountFromList.value == e ? ColorsForApp.whiteColor : ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
                height(1.h),
                // Email
                CustomTextFieldWithTitle(
                  controller: paymentLinkController.emailController,
                  title: 'Email',
                  hintText: 'Enter email',
                  isCompulsory: true,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  suffixIcon: Icon(
                    Icons.email,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (paymentLinkController.emailController.text.trim().isEmpty) {
                      return 'Please enter email';
                    } else if (!GetUtils.isEmail(paymentLinkController.emailController.text.trim())) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                // Mobile number
                CustomTextFieldWithTitle(
                  controller: paymentLinkController.mobileNumberController,
                  title: 'Mobile Number',
                  hintText: 'Enter mobile number',
                  maxLength: 10,
                  isCompulsory: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixIcon: Icon(
                    Icons.call,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (paymentLinkController.mobileNumberController.text.trim().isEmpty) {
                      return 'Please enter mobile number';
                    } else if (paymentLinkController.mobileNumberController.text.length < 10) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                ),
                // Link expiry date
                CustomTextFieldWithTitle(
                  controller: paymentLinkController.linkExpireDateController,
                  title: 'Link Expiry Date',
                  hintText: 'Select link expiry date',
                  readOnly: true,
                  isCompulsory: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  suffixIcon: Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  onTap: () async {
                    await customDatePicker(
                      context: context,
                      firstDate: DateTime.now().add(const Duration(days: 1)),
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      controller: paymentLinkController.linkExpireDateController,
                      dateFormat: 'MM/dd/yyyy',
                    );
                  },
                  validator: (value) {
                    if (paymentLinkController.linkExpireDateController.text.trim().isEmpty) {
                      return 'Please select link expiry date';
                    }
                    return null;
                  },
                ),
                // Purpose of payment
                CustomTextFieldWithTitle(
                  controller: paymentLinkController.purposeOfPaymentController,
                  title: 'Purpose Of Payment',
                  hintText: 'Enter purspose of payment',
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                ),
                // Link status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Link Status',
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
                    Obx(
                      () => FlutterSwitch(
                        height: 3.h,
                        width: 12.w,
                        padding: 3,
                        value: paymentLinkController.isLinkStatusActive.value,
                        onToggle: (bool value) {
                          paymentLinkController.isLinkStatusActive.value = value;
                        },
                        activeColor: ColorsForApp.successColor,
                        activeToggleColor: ColorsForApp.whiteColor,
                      ),
                    ),
                  ],
                ),
                height(2.h),
                // Proceed button
                CommonButton(
                  label: 'Proceed',
                  onPressed: () async {
                    if (paymentLinkController.selectedPaymentGateway.value.isEmpty) {
                      errorSnackBar(message: 'Please select payment gateway');
                    } else {
                      if (createPaymentLinkFormKey.currentState!.validate()) {
                        showProgressIndicator();
                        await paymentLinkController.createPaymentLink(isLoaderShow: false);
                        dismissProgressIndicator();
                      }
                    }
                  },
                ),
                height(2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

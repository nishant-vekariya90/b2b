import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/upi_payment_controller.dart';
import '../../../../../model/money_transfer/recipient_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field.dart';
import '../../../../../widgets/text_field_with_title.dart';

class UpiPaymentTransactionScreen extends StatefulWidget {
  const UpiPaymentTransactionScreen({Key? key}) : super(key: key);

  @override
  State<UpiPaymentTransactionScreen> createState() => _UpiPaymentTransactionScreenState();
}

class _UpiPaymentTransactionScreenState extends State<UpiPaymentTransactionScreen> {
  UpiPaymentController upiPaymentController = Get.find();
  final Rx<GlobalKey<FormState>> transactionFormKey = GlobalKey<FormState>().obs;
  RecipientListModel recipientData = Get.arguments;
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    upiPaymentController.setMoneyTransferVariables(recipientData);
    try {
      isShowTpinField.value = checkTpinRequired(categoryCode: 'DMT');
    } catch (e) {
      isShowTpinField.value = false;
    }
  }

  @override
  void dispose() {
    upiPaymentController.clearTransactionVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Money Transfer',
      isShowLeadingIcon: true,
      mainBody: Obx(
        () => Form(
          key: transactionFormKey.value,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(2.h),
                // Recipient name
                CustomTextFieldWithTitle(
                  controller: upiPaymentController.rNameController,
                  title: 'Recipient Name',
                  hintText: '',
                  readOnly: true,
                ),
                // Upi id
                CustomTextFieldWithTitle(
                  controller: upiPaymentController.rUpiIdController,
                  title: 'Upi Id',
                  readOnly: true,
                  hintText: '',
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
                      controller: upiPaymentController.rAmountController,
                      hintText: 'Enter amount',
                      maxLength: 7,
                      keyboardType: TextInputType.number,
                      textInputAction: isShowTpinField.value ? TextInputAction.next : TextInputAction.done,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      obscureText: false,
                      onChange: (value) {
                        if (upiPaymentController.rAmountController.text.isNotEmpty &&
                            int.parse(upiPaymentController.rAmountController.text.trim()) >= 1 &&
                            int.parse(upiPaymentController.rAmountController.text.trim()) <= upiPaymentController.monthlyLimit.value) {
                          upiPaymentController.rAmountIntoWords.value = getAmountIntoWords(int.parse(upiPaymentController.rAmountController.text.trim()));
                        } else {
                          upiPaymentController.rAmountIntoWords.value = '';
                        }
                      },
                      validator: (value) {
                        String amountText = upiPaymentController.rAmountController.text.trim();
                        if (amountText.isEmpty) {
                          return 'Please enter amount';
                        } else if (int.parse(amountText) < 1) {
                          return 'Amount should be greater than or equal to 1';
                        } else if (int.parse(amountText) > upiPaymentController.monthlyLimit.value) {
                          return 'Amount should be less than or equal to ${upiPaymentController.monthlyLimit.value}';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                // Amount in text
                Obx(
                  () => Visibility(
                    visible: upiPaymentController.rAmountIntoWords.value.isNotEmpty ? true : false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(0.6.h),
                        Text(
                          upiPaymentController.rAmountIntoWords.value,
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.successColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                height(1.5.h),
                Visibility(
                  visible: isShowTpinField.value,
                  child: Obx(
                    () => CustomTextFieldWithTitle(
                      controller: upiPaymentController.rTpinController,
                      title: 'Tpin',
                      hintText: 'Enter Tpin',
                      maxLength: 4,
                      isCompulsory: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      obscureText: !upiPaymentController.rIsShowTpin.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          !upiPaymentController.rIsShowTpin.value ? Icons.visibility : Icons.visibility_off,
                          size: 18,
                          color: ColorsForApp.secondaryColor.withOpacity(0.5),
                        ),
                        onPressed: () {
                          upiPaymentController.rIsShowTpin.value = !upiPaymentController.rIsShowTpin.value;
                        },
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter tpin';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                height(1.h),
                // Cancel | Transfer button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CommonButton(
                        onPressed: () {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          Get.back();
                        },
                        label: 'Cancel',
                        labelColor: ColorsForApp.primaryColor,
                        bgColor: ColorsForApp.whiteColor,
                        border: Border.all(
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
                    ),
                    width(4.w),
                    Expanded(
                      child: CommonButton(
                        onPressed: () async {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          if (transactionFormKey.value.currentState!.validate()) {
                            bool result = await upiPaymentController.transactionSlab();
                            if (result == true) {
                              await Get.toNamed(Routes.UPI_PAYMENT_TRANSACTION_SLAB_SCREEN);
                              transactionFormKey.value = GlobalKey<FormState>();
                            }
                          }
                        },
                        label: 'Transfer',
                      ),
                    ),
                  ],
                ),
                height(3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

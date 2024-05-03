import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/dmt/dmt_controller.dart';
import '../../../../../../model/money_transfer/recipient_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class DmtTransactionScreen extends StatefulWidget {
  const DmtTransactionScreen({Key? key}) : super(key: key);

  @override
  State<DmtTransactionScreen> createState() => _DmtTransactionScreenState();
}

class _DmtTransactionScreenState extends State<DmtTransactionScreen> {
  final DmtController dmtController = Get.find();
  final Rx<GlobalKey<FormState>> transactionFormKey = GlobalKey<FormState>().obs;
  RecipientListModel recipientData = Get.arguments;
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    dmtController.setTransactionVariables(recipientData);
    try {
      isShowTpinField.value = checkTpinRequired(categoryCode: 'DMT');
    } catch (e) {
      isShowTpinField.value = false;
    }
  }

  @override
  void dispose() {
    dmtController.clearTransactionVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Money Transfer',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        height: 7.h,
        width: 100.w,
        padding: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: ColorsForApp.stepBgColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // IMPS
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (dmtController.selectedPaymentType.value != 'IMPS') {
                      dmtController.selectedPaymentType.value = 'IMPS';
                    }
                  },
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: dmtController.selectedPaymentType.value == 'IMPS' ? ColorsForApp.whiteColor : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'IMPS',
                      style: TextHelper.size15.copyWith(
                        fontFamily: dmtController.selectedPaymentType.value == 'IMPS' ? mediumGoogleSansFont : regularGoogleSansFont,
                        color: dmtController.selectedPaymentType.value == 'IMPS' ? ColorsForApp.primaryColor : ColorsForApp.lightBlackColor,
                      ),
                    ),
                  ),
                ),
              ),
              // NEFT
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (dmtController.selectedPaymentType.value != 'NEFT') {
                      dmtController.selectedPaymentType.value = 'NEFT';
                    }
                  },
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: dmtController.selectedPaymentType.value == 'NEFT' ? ColorsForApp.whiteColor : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'NEFT',
                      style: TextHelper.size15.copyWith(
                        fontFamily: dmtController.selectedPaymentType.value == 'NEFT' ? mediumGoogleSansFont : regularGoogleSansFont,
                        color: dmtController.selectedPaymentType.value == 'NEFT' ? ColorsForApp.primaryColor : ColorsForApp.lightBlackColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
                  controller: dmtController.rNameController,
                  title: 'Recipient Name',
                  hintText: '',
                  readOnly: true,
                ),
                // Recipient mobile number
                CustomTextFieldWithTitle(
                  controller: dmtController.rMobileNumberController,
                  title: 'Recipient Mobile Number',
                  hintText: '',
                  readOnly: true,
                ),
                // Bank name
                CustomTextFieldWithTitle(
                  controller: dmtController.rBankNameController,
                  title: 'Bank Name',
                  hintText: '',
                  readOnly: true,
                ),
                // Account number
                CustomTextFieldWithTitle(
                  controller: dmtController.rAccountNumberController,
                  title: 'Account Number',
                  hintText: '',
                  readOnly: true,
                ),
                // IFSC code
                CustomTextFieldWithTitle(
                  controller: dmtController.rIfscCodeController,
                  title: 'IFSC Code',
                  hintText: '',
                  readOnly: true,
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
                      controller: dmtController.rAmountController,
                      hintText: 'Enter amount',
                      maxLength: 7,
                      keyboardType: TextInputType.number,
                      textInputAction: isShowTpinField.value ? TextInputAction.next : TextInputAction.done,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      obscureText: false,
                      onChange: (value) {
                        if (dmtController.rAmountController.text.isNotEmpty && int.parse(dmtController.rAmountController.text.trim()) >= 1 && int.parse(dmtController.rAmountController.text.trim()) <= dmtController.monthlyLimit.value) {
                          dmtController.rAmountIntoWords.value = getAmountIntoWords(int.parse(dmtController.rAmountController.text.trim()));
                        } else {
                          dmtController.rAmountIntoWords.value = '';
                        }
                      },
                      validator: (value) {
                        String amountText = dmtController.rAmountController.text.trim();
                        if (amountText.isEmpty) {
                          return 'Please enter amount';
                        } else if (int.parse(amountText) < 1) {
                          return 'Amount should be greater than or equal to 1';
                        } else if (int.parse(amountText) > dmtController.monthlyLimit.value) {
                          return 'Amount should be less than or equal to ${dmtController.monthlyLimit.value}';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                // Amount in text
                Obx(
                  () => Visibility(
                    visible: dmtController.rAmountIntoWords.value.isNotEmpty ? true : false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(0.6.h),
                        Text(
                          dmtController.rAmountIntoWords.value,
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
                // Tpin
                Visibility(
                  visible: isShowTpinField.value,
                  child: Obx(
                    () => CustomTextFieldWithTitle(
                      controller: dmtController.rTpinController,
                      title: 'Tpin',
                      hintText: 'Enter Tpin',
                      maxLength: 4,
                      isCompulsory: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      obscureText: !dmtController.rIsShowTpin.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          !dmtController.rIsShowTpin.value ? Icons.visibility : Icons.visibility_off,
                          size: 18,
                          color: ColorsForApp.secondaryColor.withOpacity(0.5),
                        ),
                        onPressed: () {
                          dmtController.rIsShowTpin.value = !dmtController.rIsShowTpin.value;
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
                            bool result = await dmtController.transactionSlab();
                            if (result == true) {
                              await Get.toNamed(Routes.DMT_TRANSACTION_SLAB_SCREEN);
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

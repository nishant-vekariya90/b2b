import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/dmt/dmt_o_controller.dart';
import '../../../../../../model/money_transfer/recipient_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class DmtOTransactionScreen extends StatefulWidget {
  const DmtOTransactionScreen({Key? key}) : super(key: key);

  @override
  State<DmtOTransactionScreen> createState() => _DmtOTransactionScreenState();
}

class _DmtOTransactionScreenState extends State<DmtOTransactionScreen> {
  DmtOController dmtOController = Get.find();
  final Rx<GlobalKey<FormState>> transactionFormKey = GlobalKey<FormState>().obs;
  RecipientListModel recipientData = Get.arguments;
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    dmtOController.setTransactionVariables(recipientData);
    callAsyncApi();
    try {
      isShowTpinField.value = checkTpinRequired(categoryCode: 'DMT');
    } catch (e) {
      isShowTpinField.value = false;
    }
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      await dmtOController.getAmountLimit(isLoaderShow: false);
      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    dmtOController.clearTransactionVariables();
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
                    if (dmtOController.selectedPaymentType.value != 'IMPS') {
                      dmtOController.selectedPaymentType.value = 'IMPS';
                    }
                  },
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: dmtOController.selectedPaymentType.value == 'IMPS' ? ColorsForApp.whiteColor : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'IMPS',
                      style: TextHelper.size15.copyWith(
                        fontFamily: dmtOController.selectedPaymentType.value == 'IMPS' ? mediumGoogleSansFont : regularGoogleSansFont,
                        color: dmtOController.selectedPaymentType.value == 'IMPS' ? ColorsForApp.primaryColor : ColorsForApp.lightBlackColor,
                      ),
                    ),
                  ),
                ),
              ),
              // NEFT
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (dmtOController.selectedPaymentType.value != 'NEFT') {
                      dmtOController.selectedPaymentType.value = 'NEFT';
                    }
                  },
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: dmtOController.selectedPaymentType.value == 'NEFT' ? ColorsForApp.whiteColor : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'NEFT',
                      style: TextHelper.size15.copyWith(
                        fontFamily: dmtOController.selectedPaymentType.value == 'NEFT' ? mediumGoogleSansFont : regularGoogleSansFont,
                        color: dmtOController.selectedPaymentType.value == 'NEFT' ? ColorsForApp.primaryColor : ColorsForApp.lightBlackColor,
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
                  controller: dmtOController.rNameController,
                  title: 'Recipient Name',
                  hintText: '',
                  readOnly: true,
                ),
                // Recipient mobile number
                CustomTextFieldWithTitle(
                  controller: dmtOController.rMobileNumberController,
                  title: 'Recipient Mobile Number',
                  hintText: '',
                  readOnly: true,
                ),
                // Bank name
                CustomTextFieldWithTitle(
                  controller: dmtOController.rBankNameController,
                  title: 'Bank Name',
                  hintText: '',
                  readOnly: true,
                ),
                // Account number
                CustomTextFieldWithTitle(
                  controller: dmtOController.rAccountNumberController,
                  title: 'Account Number',
                  hintText: '',
                  readOnly: true,
                ),
                // IFSC code
                CustomTextFieldWithTitle(
                  controller: dmtOController.rIfscCodeController,
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
                      controller: dmtOController.rAmountController,
                      hintText: 'Enter amount',
                      maxLength: 7,
                      keyboardType: TextInputType.number,
                      textInputAction: isShowTpinField.value ? TextInputAction.next : TextInputAction.done,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      obscureText: false,
                      onChange: (value) {
                        if (dmtOController.rAmountController.text.isNotEmpty &&
                            int.parse(dmtOController.rAmountController.text.trim()) >= dmtOController.lowerLimit.value &&
                            int.parse(dmtOController.rAmountController.text.trim()) <= dmtOController.upperLimit.value) {
                          dmtOController.rAmountIntoWords.value = getAmountIntoWords(int.parse(dmtOController.rAmountController.text.trim()));
                        } else {
                          dmtOController.rAmountIntoWords.value = '';
                        }
                      },
                      validator: (value) {
                        String amountText = dmtOController.rAmountController.text.trim();
                        if (amountText.isEmpty) {
                          return 'Please enter amount';
                        } else if (int.parse(amountText) < dmtOController.lowerLimit.value) {
                          return 'Amount should be greater than or equal to ${dmtOController.lowerLimit.value}';
                        } else if (int.parse(amountText) > dmtOController.upperLimit.value) {
                          return 'Amount should be less than or equal to ${dmtOController.upperLimit.value}';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                // Amount in text
                Obx(
                  () => Visibility(
                    visible: dmtOController.rAmountIntoWords.value.isNotEmpty ? true : false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(0.6.h),
                        Text(
                          dmtOController.rAmountIntoWords.value,
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
                      controller: dmtOController.rTpinController,
                      title: 'Tpin',
                      hintText: 'Enter Tpin',
                      maxLength: 4,
                      isCompulsory: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      obscureText: !dmtOController.rIsShowTpin.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          !dmtOController.rIsShowTpin.value ? Icons.visibility : Icons.visibility_off,
                          size: 18,
                          color: ColorsForApp.secondaryColor.withOpacity(0.5),
                        ),
                        onPressed: () {
                          dmtOController.rIsShowTpin.value = !dmtOController.rIsShowTpin.value;
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
                            bool result = await dmtOController.transactionSlab();
                            if (result == true) {
                              await Get.toNamed(Routes.DMT_O_TRANSACTION_SLAB_SCREEN);
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

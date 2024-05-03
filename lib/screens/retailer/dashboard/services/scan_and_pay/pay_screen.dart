import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/scan_and_pay_controller.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field.dart';
import '../../../../../widgets/text_field_with_title.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final ScanAndPayController scanAndPayController = Get.find();
  final GlobalKey<FormState> payFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    vibrateDevice();
    scanAndPayController.isShowTpinField.value = checkTpinRequired(categoryCode: 'Payout');
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Pay',
      isShowLeadingIcon: true,
      mainBody: Form(
        key: payFormKey,
        child: Obx(
          () => ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            children: [
              // UPI
              CustomTextFieldWithTitle(
                controller: scanAndPayController.upiController,
                title: 'UPI',
                hintText: 'Enter UPI',
                readOnly: scanAndPayController.upiController.text != '' && scanAndPayController.upiController.text.isNotEmpty ? true : false,
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (scanAndPayController.upiController.text.trim().isEmpty) {
                    return 'Please enter UPI';
                  }
                  return null;
                },
              ),
              // Name
              CustomTextFieldWithTitle(
                controller: scanAndPayController.nameController,
                title: 'Name',
                hintText: 'Enter name',
                readOnly: scanAndPayController.nameController.text != '' && scanAndPayController.nameController.text.isNotEmpty ? true : false,
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                ],
                validator: (value) {
                  if (scanAndPayController.nameController.text.trim().isEmpty) {
                    return 'Please enter name';
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
                    controller: scanAndPayController.amountController,
                    hintText: 'Enter amount',
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    textInputAction: scanAndPayController.isShowTpinField.value == true ? TextInputAction.next : TextInputAction.done,
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffixIcon: Icon(
                      Icons.currency_rupee_rounded,
                      size: 18,
                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                    ),
                    onChange: (value) {
                      if (scanAndPayController.amountController.text.isNotEmpty && int.parse(scanAndPayController.amountController.text) > 0) {
                        scanAndPayController.amountInText.value = getAmountIntoWords(int.parse(scanAndPayController.amountController.text.trim()));
                      } else {
                        scanAndPayController.amountInText.value = '';
                      }
                    },
                    validator: (value) {
                      if (scanAndPayController.amountController.text.trim().isEmpty) {
                        return 'Please enter amount';
                      } else if (int.parse(scanAndPayController.amountController.text) < 1 || int.parse(scanAndPayController.amountController.text) > 100000) {
                        return 'Please enter amount between 1 to 99,999';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              // Amount in text
              Obx(
                () => Visibility(
                  visible: scanAndPayController.amountInText.value.isNotEmpty ? true : false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(0.6.h),
                      Text(
                        scanAndPayController.amountInText.value,
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
              // TPIN
              Visibility(
                visible: scanAndPayController.isShowTpinField.value,
                child: Obx(
                  () => CustomTextFieldWithTitle(
                    controller: scanAndPayController.tPinController,
                    title: 'TPIN',
                    hintText: 'Enter TPIN',
                    maxLength: 4,
                    isCompulsory: true,
                    obscureText: scanAndPayController.isShowTpin.value,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    suffixIcon: IconButton(
                      icon: Icon(
                        scanAndPayController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                        size: 18,
                        color: ColorsForApp.secondaryColor.withOpacity(0.5),
                      ),
                      onPressed: () {
                        scanAndPayController.isShowTpin.value = !scanAndPayController.isShowTpin.value;
                      },
                    ),
                    validator: (value) {
                      if (scanAndPayController.tPinController.text.trim().isEmpty) {
                        return 'Please enter TPIN';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // Remarks
              CustomTextFieldWithTitle(
                controller: scanAndPayController.remarksController,
                title: 'Remarks',
                hintText: 'Enter remarks',
                maxLines: 4,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
              height(1.h),
              // Pay button
              CommonButton(
                label: 'Pay',
                onPressed: () async {
                  if (payFormKey.currentState!.validate()) {
                    scanAndPayController.payStatus.value = -1;
                    Get.toNamed(Routes.PAY_STATUS_SCREEN);
                  }
                },
              ),
              height(2.h),
            ],
          ),
        ),
      ),
    );
  }
}

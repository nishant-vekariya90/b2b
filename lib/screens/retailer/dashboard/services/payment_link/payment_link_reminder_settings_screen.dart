import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/payment_link_controller.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field_with_title.dart';

class PaymentLinkReminderSettingsScreen extends StatefulWidget {
  const PaymentLinkReminderSettingsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentLinkReminderSettingsScreen> createState() => _PaymentLinkReminderSettingsScreenState();
}

class _PaymentLinkReminderSettingsScreenState extends State<PaymentLinkReminderSettingsScreen> {
  final PaymentLinkController paymentLinkController = Get.find();
  final GlobalKey<FormState> reminderSettingsLinkFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await paymentLinkController.getPaymentLinkReminderSetting();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    paymentLinkController.resetPaymentLinkReminderSettingVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Reminder Settings',
      isShowLeadingIcon: true,
      mainBody: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Form(
          key: reminderSettingsLinkFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height(2.h),
              // Enable reminder | switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Enable Reminder',
                    style: TextHelper.size14,
                  ),
                  Obx(
                    () => FlutterSwitch(
                      height: 3.h,
                      width: 12.w,
                      padding: 3,
                      value: paymentLinkController.isReminderEnable.value,
                      onToggle: (bool value) {
                        paymentLinkController.isReminderEnable.value = value;
                      },
                      activeColor: ColorsForApp.successColor,
                      activeToggleColor: ColorsForApp.whiteColor,
                    ),
                  ),
                ],
              ),
              height(2.h),
              // Description
              Text(
                'Reminders will be sent to customers between 10AM - 12PM and 3PM - 5PM. You can turn ON/OFF reminders for any individual customer.',
                style: TextHelper.size13.copyWith(
                  color: ColorsForApp.grayScale500,
                ),
              ),
              height(2.h),
              Divider(
                height: 0,
                thickness: 0.2,
                color: ColorsForApp.greyColor,
              ),
              height(2.h),
              // Send Reminder Using text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Send Reminder Using',
                  style: TextHelper.size14,
                  children: [
                    TextSpan(
                      text: ' *',
                      style: TextHelper.size14.copyWith(
                        color: ColorsForApp.errorColor,
                      ),
                    ),
                  ],
                ),
              ),
              height(1.h),
              // Checkbox of SMS | Email
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SMS
                  Obx(
                    () => Checkbox(
                      activeColor: ColorsForApp.primaryColor,
                      value: paymentLinkController.isSmsReminderEnable.value,
                      onChanged: (bool? value) {
                        paymentLinkController.isSmsReminderEnable.value = value!;
                      },
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  width(2.w),
                  Text(
                    'SMS',
                    style: TextHelper.size13,
                  ),
                  width(4.w),
                  // Email
                  Obx(
                    () => Checkbox(
                      activeColor: ColorsForApp.primaryColor,
                      value: paymentLinkController.isEmailReminderEnable.value,
                      onChanged: (bool? value) {
                        paymentLinkController.isEmailReminderEnable.value = value!;
                      },
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  width(2.w),
                  Expanded(
                    child: Text(
                      'Email',
                      style: TextHelper.size13,
                    ),
                  ),
                ],
              ),
              height(2.h),
              Divider(
                height: 0,
                thickness: 0.2,
                color: ColorsForApp.greyColor,
              ),
              height(2.h),
              // Days Before Link Expired
              CustomTextFieldWithTitle(
                controller: paymentLinkController.daysBeforeLinkExpiredController,
                title: 'Days Before Link Expired',
                hintText: 'Select days before link expired',
                readOnly: true,
                isCompulsory: true,
                onTap: () async {
                  String selectedDay = await Get.toNamed(
                    Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                    arguments: [
                      paymentLinkController.daysBeforeLinkExpiredList, // modelList
                      'string', // modelName
                    ],
                  );
                  if (selectedDay != '' && selectedDay.isNotEmpty) {
                    paymentLinkController.daysBeforeLinkExpiredController.text = selectedDay;
                    paymentLinkController.daysBeforeLinkExpired.value = paymentLinkController.daysBeforeLinkExpiredList.indexOf(selectedDay) + 1;
                  }
                },
                validator: (value) {
                  if (paymentLinkController.daysBeforeLinkExpiredController.text.trim().isEmpty) {
                    return 'Please select day before link expired';
                  }
                  return null;
                },
                suffixIcon: GestureDetector(
                  onTap: () async {
                    String selectedDay = await Get.toNamed(
                      Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                      arguments: [
                        paymentLinkController.daysBeforeLinkExpiredList, // modelList
                        'string', // modelName
                      ],
                    );
                    if (selectedDay != '' && selectedDay.isNotEmpty) {
                      paymentLinkController.daysBeforeLinkExpiredController.text = selectedDay;
                      paymentLinkController.daysBeforeLinkExpired.value = paymentLinkController.daysBeforeLinkExpiredList.indexOf(selectedDay) + 1;
                    }
                  },
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: ColorsForApp.greyColor,
                  ),
                ),
              ),
              height(1.h),
              // Save changes button
              CommonButton(
                label: 'Save Changes',
                onPressed: () async {
                  if (Get.isSnackbarOpen) {
                    Get.back();
                  }
                  if (reminderSettingsLinkFormKey.currentState!.validate()) {
                    if (paymentLinkController.isReminderEnable.value == true &&
                        paymentLinkController.isSmsReminderEnable.value == false &&
                        paymentLinkController.isEmailReminderEnable.value == false) {
                      errorSnackBar(message: 'Please select atleast SMS or Email for send reminder notification');
                    } else {
                      await paymentLinkController.updatePaymentLinkReminderSetting();
                    }
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

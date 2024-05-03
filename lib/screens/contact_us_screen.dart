import '../utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../generated/assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../controller/setting_controller.dart';
import '../widgets/constant_widgets.dart';
import '../widgets/custom_scaffold.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final SettingController settingController = SettingController();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await settingController.getWebsiteContent(contentType: 0);
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 18.h,
      title: 'Contact Us',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        height: 18.h,
        width: 100.w,
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Lottie.asset(
          Assets.animationsContactUsAnimation,
          fit: BoxFit.contain,
        ),
      ),
      mainBody: Obx(
        () => Container(
          margin: EdgeInsets.all(5.w),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              height(2.h),
              Text(
                'Is you have any questions, concerns, or inquiries regarding $appName, you can reach us using following contact information.',
                textAlign: TextAlign.center,
                style: TextHelper.size13.copyWith(
                  color: ColorsForApp.grayScale500,
                ),
              ),
              height(2.h),
              // Email
              InkWell(
                onTap: () {
                  if (settingController.supportEmail.value.isNotEmpty) {
                    openUrl(url: 'mailto:${settingController.supportEmail.value}');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mail_outline,
                      color: ColorsForApp.primaryColor,
                      size: 20,
                    ),
                    width(4),
                    Flexible(
                      child: Text(
                        settingController.supportEmail.value.isNotEmpty ? settingController.supportEmail.value : '-',
                        textAlign: TextAlign.center,
                        style: TextHelper.size14,
                      ),
                    ),
                  ],
                ),
              ),
              height(1.h),
              // Mobile number
              InkWell(
                onTap: () {
                  if (settingController.supportNo.value.isNotEmpty) {
                    openUrl(url: 'tel://${settingController.supportNo.value}');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.call,
                      color: ColorsForApp.primaryColor,
                      size: 20,
                    ),
                    width(4),
                    Flexible(
                      child: Text(
                        settingController.supportNo.value.isNotEmpty ? settingController.supportNo.value : '-',
                        textAlign: TextAlign.center,
                        style: TextHelper.size14,
                      ),
                    ),
                  ],
                ),
              ),
              height(1.h),
              // Address
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: ColorsForApp.primaryColor,
                    size: 20,
                  ),
                  width(4),
                  Flexible(
                    child: Text(
                      settingController.address.value.isNotEmpty ? settingController.address.value : '-',
                      textAlign: TextAlign.center,
                      style: TextHelper.size14,
                    ),
                  ),
                ],
              ),
              height(2.h),
              Text(
                'We strive to respond to all inquiries promptly and provide assistance as needed. Please ensure that your contact information is accurate to facilitate our response.',
                textAlign: TextAlign.center,
                style: TextHelper.size13.copyWith(
                  color: ColorsForApp.grayScale500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

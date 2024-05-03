import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/payment_page_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';

class PaymentPageScreen extends StatelessWidget {
  final PaymentPageController paymentPageController = Get.find();
  PaymentPageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Payment Page',
      isShowLeadingIcon: true,
      mainBody: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Obx(
          () => paymentPageController.paymentPageLink.value.isNotEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    height(2.h),
                    // Copy below link for payment
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorsForApp.successColor.withOpacity(0.7),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorsForApp.successColor.withOpacity(0.7),
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_circle_rounded,
                              size: 17,
                              color: ColorsForApp.successColor.withOpacity(0.7),
                            ),
                          ),
                          width(2.w),
                          Text(
                            'Copy below link for payment',
                            style: TextHelper.size15.copyWith(
                              fontFamily: mediumGoogleSansFont,
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    height(2.h),
                    // Payment link
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Payment Link',
                            style: TextHelper.size14,
                            children: [
                              TextSpan(
                                text: ' *',
                                style: TextHelper.size13.copyWith(
                                  color: ColorsForApp.errorColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        height(0.8.h),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ColorsForApp.grayScale200.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: ColorsForApp.grayScale500.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            paymentPageController.paymentPageLink.value,
                            textAlign: TextAlign.center,
                            style: TextHelper.size15.copyWith(
                              color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    height(2.h),
                    // Copy link button
                    CommonButton(
                      onPressed: () {
                        if (paymentPageController.isLinkCopied.value == false) {
                          vibrateDevice();
                          Clipboard.setData(
                            ClipboardData(text: paymentPageController.paymentPageLink.value),
                          );
                          paymentPageController.isLinkCopied.value = true;
                          Future.delayed(const Duration(seconds: 1), () {
                            paymentPageController.isLinkCopied.value = false;
                          });
                        }
                      },
                      label: paymentPageController.isLinkCopied.value == true ? 'Link Copied' : 'Copy Link',
                      border: Border.all(
                        color: paymentPageController.isLinkCopied.value == true ? ColorsForApp.successColor : ColorsForApp.primaryColor,
                      ),
                      bgColor: paymentPageController.isLinkCopied.value == true ? ColorsForApp.whiteColor : ColorsForApp.primaryColor,
                      labelColor: paymentPageController.isLinkCopied.value == true ? ColorsForApp.successColor : ColorsForApp.whiteColor,
                    ),
                  ],
                )
              : notFoundText(text: 'Sorry, the payment page is currently unavailable. Please try again later.'),
        ),
      ),
    );
  }
}

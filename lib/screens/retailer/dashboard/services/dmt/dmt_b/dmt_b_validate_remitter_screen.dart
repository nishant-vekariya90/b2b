import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/dmt/dmt_b_controller.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class DmtBValidateRemitterScreen extends StatefulWidget {
  const DmtBValidateRemitterScreen({super.key});

  @override
  State<DmtBValidateRemitterScreen> createState() => _DmtBValidateRemitterScreenState();
}

class _DmtBValidateRemitterScreenState extends State<DmtBValidateRemitterScreen> {
  final DmtBController dmtBController = Get.find();
  final GlobalKey<FormState> validateFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    dmtBController.validateRemitterMobileNumberController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CustomScaffold(
        appBarHeight: 18.h,
        title: 'Money Transfer',
        isShowLeadingIcon: true,
        topCenterWidget: Container(
          height: 18.h,
          width: 100.w,
          decoration: BoxDecoration(
            color: ColorsForApp.whiteColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Lottie.asset(
            Assets.animationsMoneyTransfer,
            fit: BoxFit.contain,
          ),
        ),
        mainBody: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Form(
            key: validateFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                height(3.h),
                // Mobile Number
                CustomTextFieldWithTitle(
                  controller: dmtBController.validateRemitterMobileNumberController,
                  title: 'Mobile Number',
                  hintText: 'Enter mobile number',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  maxLength: 10,
                  isCompulsory: true,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter mobile number';
                    } else if (value.length < 10) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                ),
                height(2.h),
                // Proceed button
                CommonButton(
                  onPressed: () async {
                    if (validateFormKey.currentState!.validate()) {
                      int result = await dmtBController.validateRemitter();
                      if (result == 1) {
                        Get.toNamed(Routes.DMT_B_BENEFICIARY_LIST_SCREEN);
                      } else if (result == 2) {
                        Get.toNamed(Routes.DMT_B_REMITTER_REGISTRATION_SCREEN);
                      }
                    }
                  },
                  label: 'Proceed',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

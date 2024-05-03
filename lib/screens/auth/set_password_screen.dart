import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/custom_scaffold.dart';
import '../../../../widgets/text_field_with_title.dart';
import '../../controller/auth_controller.dart';
import '../../generated/assets.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final AuthController authController = Get.find();
  final GlobalKey<FormState> setPasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 12.h,
      title: 'Set Password',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        height: 12.h,
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage(Assets.imagesSetPasswordTopImg),
            fit: BoxFit.contain,
          ),
        ),
      ),
      mainBody: Form(
        key: setPasswordFormKey,
        child: Obx(
          () => ListView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            children: [
              height(2.h),
              CustomTextFieldWithTitle(
                controller: authController.oldPasswordController,
                title: 'Old Password',
                hintText: 'Enter old password',
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                obscureText: authController.isHideOldPassword.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    authController.isHideOldPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 18,
                    color: ColorsForApp.grayScale500,
                  ),
                  onPressed: () {
                    authController.isHideOldPassword.value = !authController.isHideOldPassword.value;
                  },
                ),
                validator: (value) {
                  if (authController.oldPasswordController.text.trim().isEmpty) {
                    return 'Please enter old password';
                  }
                  return null;
                },
              ),
              CustomTextFieldWithTitle(
                controller: authController.newPasswordController,
                title: 'New Password',
                hintText: 'Enter new password',
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                obscureText: authController.isHideNewPassword.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    authController.isHideNewPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 18,
                    color: ColorsForApp.grayScale500,
                  ),
                  onPressed: () {
                    authController.isHideNewPassword.value = !authController.isHideNewPassword.value;
                  },
                ),
                validator: (value) {
                  final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\-]).{8,16}$');
                  List<String> conditions = [];
                  if (!passwordRegex.hasMatch(authController.newPasswordController.text.trim())) {
                    conditions.add('Password must meet the following criteria:');
                  }
                  if (authController.newPasswordController.text.trim().length < 8 || authController.newPasswordController.text.trim().length > 16) {
                    conditions.add('• Must be 8-16 characters');
                  }
                  if (!RegExp(r'[A-Z]').hasMatch(authController.newPasswordController.text.trim())) {
                    conditions.add('• At least one upper case letter');
                  }
                  if (!RegExp(r'[a-z]').hasMatch(authController.newPasswordController.text.trim())) {
                    conditions.add('• At least one lower case letter');
                  }
                  if (!RegExp(r'[0-9]').hasMatch(authController.newPasswordController.text.trim())) {
                    conditions.add('• At least one number');
                  }
                  if (!RegExp(r'[!@#$%^&*()_+={}|:;<>,.?/\[\]-]').hasMatch(authController.newPasswordController.text.trim())) {
                    conditions.add('• At least one special character');
                  }
                  if (authController.newPasswordController.text.trim().isEmpty) {
                    return 'Please enter new password';
                  } else if (conditions.isNotEmpty) {
                    return conditions.join('\n');
                  }
                  return null;
                },
              ),
              CustomTextFieldWithTitle(
                controller: authController.confirmPasswordController,
                title: 'Confirm Password',
                hintText: 'Enter confirm password',
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                obscureText: authController.isHideConfirmPassword.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    authController.isHideConfirmPassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 18,
                    color: ColorsForApp.grayScale500,
                  ),
                  onPressed: () {
                    authController.isHideConfirmPassword.value = !authController.isHideConfirmPassword.value;
                  },
                ),
                validator: (value) {
                  if (authController.confirmPasswordController.text.trim().isEmpty) {
                    return 'Please enter confirm password';
                  } else if (authController.newPasswordController.text != value) {
                    return 'New password & confirm password must be same';
                  }
                  return null;
                },
              ),
              height(1.h),
              CommonButton(
                onPressed: () async {
                  if (setPasswordFormKey.currentState!.validate()) {
                    bool result = await authController.setPasswordAPI();
                    if (result == true) {
                      Get.offAllNamed(Routes.AUTH_SCREEN);
                    }
                  }
                },
                label: 'Submit',
              ),
              height(1.h),
            ],
          ),
        ),
      ),
    );
  }
}

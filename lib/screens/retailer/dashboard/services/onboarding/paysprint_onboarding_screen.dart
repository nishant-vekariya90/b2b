import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../model/aeps/verify_status_model.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field_with_title.dart';
import '../../../../../controller/retailer/onboarding/paysprint_controller.dart';

class PaysprintOnboardingScreen extends StatefulWidget {
  const PaysprintOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<PaysprintOnboardingScreen> createState() => _PaysprintOnboardingScreenState();
}

class _PaysprintOnboardingScreenState extends State<PaysprintOnboardingScreen> {
  final PaysprintController paysprintController = Get.find();
  UserData userData = Get.arguments;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    paysprintController.setOnboardingData(userData);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: false);
        paysprintController.clearOnboardingVariables();
        return true;
      },
      child: CustomScaffold(
        appBarHeight: 10.h,
        title: 'Onboarding',
        isShowLeadingIcon: true,
        topCenterWidget: Container(
          height: 10.h,
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            color: ColorsForApp.whiteColor,
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage(Assets.imagesTopCardBgStart),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(2.w),
                child: Lottie.asset(
                  Assets.animationsPaymentGateway,
                ),
              ),
              width(2.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paysprint Onboarding',
                      style: TextHelper.size14.copyWith(
                        fontFamily: boldGoogleSansFont,
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                    height(0.5.h),
                    Text(
                      'Register/Onboard your self to access services.',
                      maxLines: 2,
                      style: TextHelper.size13.copyWith(
                        color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        mainBody: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              children: [
                // Name
                CustomTextFieldWithTitle(
                  controller: paysprintController.nameController,
                  title: 'Name',
                  hintText: 'Enter name',
                  maxLength: 200,
                  isCompulsory: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                  ],
                  suffixIcon: Icon(
                    Icons.person,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (paysprintController.nameController.text.trim().isEmpty) {
                      return 'Please enter name';
                    } else if (paysprintController.nameController.text.length < 3) {
                      return 'Please enter valid name';
                    }
                    return null;
                  },
                ),
                // Mobile number
                CustomTextFieldWithTitle(
                  controller: paysprintController.mobileNumberController,
                  title: 'Mobile Number',
                  hintText: 'Enter mobile number',
                  maxLength: 10,
                  isCompulsory: true,
                  readOnly: userData.mobileNo != null && userData.mobileNo!.isNotEmpty ? true : false,
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
                    if (paysprintController.mobileNumberController.text.trim().isEmpty) {
                      return 'Please enter mobile number';
                    } else if (paysprintController.mobileNumberController.text.length < 10) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                ),
                // Email
                CustomTextFieldWithTitle(
                  controller: paysprintController.emailController,
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
                    if (paysprintController.emailController.text.trim().isEmpty) {
                      return 'Please enter email';
                    } else if (!GetUtils.isEmail(paysprintController.emailController.text.trim())) {
                      return 'Please enter valid email';
                    }
                    return null;
                  },
                ),
                // Aadhar number
                CustomTextFieldWithTitle(
                  controller: paysprintController.aadharNumberController,
                  title: 'Aadhaar Number',
                  hintText: 'Enter aadhaar number',
                  maxLength: 12,
                  isCompulsory: true,
                  readOnly: userData.aadharNo != null && userData.aadharNo!.isNotEmpty ? true : false,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixIcon: Icon(
                    Icons.pin_rounded,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    RegExp aadharRegex = RegExp(r'^[2-9]\d{11}$');
                    if (paysprintController.aadharNumberController.text.trim().isEmpty) {
                      return 'Please enter aadhaar number';
                    } else if (!aadharRegex.hasMatch(paysprintController.aadharNumberController.text.trim())) {
                      return 'Please enter valid aadhaar number';
                    }
                    return null;
                  },
                ),
                // Pan number
                CustomTextFieldWithTitle(
                  controller: paysprintController.panNumberController,
                  title: 'Pan Number',
                  hintText: 'Enter pan number',
                  maxLength: 10,
                  isCompulsory: true,
                  readOnly: userData.panCard != null && userData.panCard!.isNotEmpty ? true : false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.characters,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                  ],
                  suffixIcon: Icon(
                    Icons.pin_rounded,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    RegExp panRegex = RegExp(r'^[A-Z]{5}\d{4}[A-Z]$');
                    if (paysprintController.panNumberController.text.trim().isEmpty) {
                      return 'Please enter pan number';
                    } else if (!panRegex.hasMatch(paysprintController.panNumberController.text.trim())) {
                      return 'Please enter valid pan number';
                    }
                    return null;
                  },
                ),
                // Consent
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Checkbox(
                        value: paysprintController.isConsent.value,
                        activeColor: ColorsForApp.primaryColor,
                        onChanged: (value) {
                          paysprintController.isConsent.value = value!;
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'I hereby give my consent and submit voluntarily at my own discretion, my Aadhaar Number or VID for the purpose of establishing my identity on the portal. The Aadhaar submitted herewith shall not be used for any purpose other than mentioned, or as per the requirements of the law.',
                        style: TextHelper.size14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
          child: CommonButton(
            bgColor: ColorsForApp.primaryColor,
            labelColor: ColorsForApp.whiteColor,
            label: 'Proceed',
            onPressed: () async {
              // Unfocus text-field
              FocusScope.of(context).unfocus();
              if (Get.isSnackbarOpen) {
                Get.back();
              }
              if (formKey.currentState!.validate()) {
                if (paysprintController.isConsent.value != true) {
                  errorSnackBar(message: 'Please accept consent');
                } else {
                  await paysprintController.paysprintOnboardingApi();
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

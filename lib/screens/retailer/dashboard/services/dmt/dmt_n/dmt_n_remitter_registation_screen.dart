import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/dmt/dmt_n_controller.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class DmtNRemitterRegistrationScreen extends StatefulWidget {
  const DmtNRemitterRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<DmtNRemitterRegistrationScreen> createState() => _DmtNRemitterRegistrationScreenState();
}

class _DmtNRemitterRegistrationScreenState extends State<DmtNRemitterRegistrationScreen> {
  final DmtNController dmtNController = Get.find();
  final GlobalKey<FormState> remitterRegistrationForm = GlobalKey<FormState>();

  @override
  void dispose() {
    dmtNController.clearRemitterRegistrationVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CustomScaffold(
        title: 'Remitter Registration',
        isShowLeadingIcon: true,
        mainBody: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Form(
            key: remitterRegistrationForm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(2.h),
                // First name
                CustomTextFieldWithTitle(
                  controller: dmtNController.remitterRegistrationFirstNameController,
                  title: 'First Name',
                  hintText: 'Enter first name',
                  maxLength: 50,
                  isCompulsory: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  ],
                  suffixIcon: Icon(
                    Icons.account_circle_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter first name';
                    } else if (!GetUtils.isAlphabetOnly(value)) {
                      return 'Please enter valid first name';
                    }
                    return null;
                  },
                ),
                // Last name
                CustomTextFieldWithTitle(
                  controller: dmtNController.remitterRegistrationLastNameController,
                  title: 'Last Name',
                  hintText: 'Enter last name',
                  maxLength: 50,
                  isCompulsory: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  ],
                  suffixIcon: Icon(
                    Icons.account_circle_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter last name';
                    } else if (!GetUtils.isAlphabetOnly(value)) {
                      return 'Please enter valid last name';
                    }
                    return null;
                  },
                ),
                // Mobile number
                CustomTextFieldWithTitle(
                  controller: dmtNController.remitterRegistrationMobileNumberController,
                  title: 'Mobile Number',
                  hintText: 'Enter mobile number',
                  maxLength: 10,
                  readOnly: true,
                  isCompulsory: true,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixIcon: Icon(
                    Icons.call,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                ),
                // Pincode
                CustomTextFieldWithTitle(
                  controller: dmtNController.remitterRegistrationPinCodeController,
                  title: 'Pin code',
                  hintText: 'Enter pin code',
                  maxLength: 6,
                  isCompulsory: true,
                  keyboardType: TextInputType.number,
                  textInputAction: dmtNController.validateRemitterModel.value.isVerify == true ? TextInputAction.next : TextInputAction.done,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  suffixIcon: Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter pin code';
                    } else if (value.length < 6) {
                      return 'Please enter valid pin code';
                    }
                    return null;
                  },
                ),
                height(3.h),
                // Cancel | Submit button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CommonButton(
                        onPressed: () {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          Get.back();
                          dmtNController.clearRemitterRegistrationVariables();
                        },
                        label: 'Cancel',
                        labelColor: ColorsForApp.primaryColor,
                        bgColor: ColorsForApp.whiteColor,
                        border: Border.all(
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
                    ),
                    width(5.w),
                    Expanded(
                      child: CommonButton(
                        onPressed: () async {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          if (remitterRegistrationForm.currentState!.validate()) {
                            showProgressIndicator();
                            bool response = await dmtNController.remitterRegistration(isLoaderShow: false);
                            if (response == true) {
                              int result = await dmtNController.validateRemitter(isLoaderShow: false);
                              if (result == 1) {
                                Get.back();
                                successSnackBar(message: dmtNController.addRemitterModel.value.message);
                                Get.toNamed(Routes.DMT_N_BENEFICIARY_LIST_SCREEN);
                              }
                              dismissProgressIndicator();
                            }
                            dismissProgressIndicator();
                          }
                        },
                        label: 'Submit',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

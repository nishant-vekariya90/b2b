import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/gift_card_controller.dart';
import '../../../../../../model/auth/states_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class GiftCardOnboardingScreen extends StatefulWidget {
  const GiftCardOnboardingScreen({super.key});

  @override
  State<GiftCardOnboardingScreen> createState() => _GiftCardOnboardingScreenState();
}

class _GiftCardOnboardingScreenState extends State<GiftCardOnboardingScreen> {
  final GiftCardController giftCardController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    giftCardController.setVerifiedDataIntoVariables(giftCardController.verifiedUserDataModel.value);
    await giftCardController.getStatesAPI();
  }

  @override
  void dispose() {
    giftCardController.resetGiftCardVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 3.h,
      title: 'Onboarding',
      isShowLeadingIcon: true,
      onBackIconTap: () {
        Get.back();
      },
      mainBody: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height(2.h),
              // First Name
              CustomTextFieldWithTitle(
                controller: giftCardController.firstNameTxtController,
                title: 'First Name',
                hintText: 'Enter first name',
                maxLength: 200,
                isCompulsory: true,
                // readOnly: userData.name!=null?true:false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textInputFormatter: [
                  FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (giftCardController.firstNameTxtController.text.trim().isEmpty) {
                    return 'Please enter first name';
                  } else if (giftCardController.firstNameTxtController.text.length < 3) {
                    return 'Please enter valid first name';
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.person,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              // Last Name
              CustomTextFieldWithTitle(
                controller: giftCardController.lastnameTxtController,
                title: 'Last Name',
                hintText: 'Enter last name',
                maxLength: 200,
                isCompulsory: true,
                // readOnly: userData.name!=null?true:false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textInputFormatter: [
                  FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (giftCardController.lastnameTxtController.text.trim().isEmpty) {
                    return 'Please enter last name';
                  } else if (giftCardController.lastnameTxtController.text.length < 3) {
                    return 'Please enter last name';
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.person,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              // Mobile number
              CustomTextFieldWithTitle(
                controller: giftCardController.mobileTxtController,
                title: 'Mobile Number',
                hintText: 'Enter mobile number',
                maxLength: 10,
                isCompulsory: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (giftCardController.mobileTxtController.text.trim().isEmpty) {
                    return 'Please enter mobile number';
                  } else if (giftCardController.mobileTxtController.text.length < 10) {
                    return 'Please enter valid mobile number';
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.call,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              // Email
              CustomTextFieldWithTitle(
                controller: giftCardController.emailTxtController,
                title: 'Email',
                hintText: 'Enter email',
                isCompulsory: true,
                //readOnly: userData.email!=null?true:false,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (giftCardController.emailTxtController.text.trim().isEmpty) {
                    return 'Please enter email';
                  } else if (!GetUtils.isEmail(giftCardController.emailTxtController.text.trim())) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.mail,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              const Text("Gender"),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio(
                        value: 'MALE',
                        groupValue: giftCardController.selectedGenderMethodRadio.value,
                        onChanged: (value) {
                          giftCardController.selectedGenderMethodRadio.value = value!;
                        },
                        activeColor: ColorsForApp.primaryColor,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      ),
                      width(5),
                      Text(
                        'Male',
                        style: TextHelper.size14.copyWith(
                          color: giftCardController.selectedGenderMethodRadio.value == 'MALE' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                          fontWeight: giftCardController.selectedGenderMethodRadio.value == 'MALE' ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                      width(15),
                      Radio(
                        value: 'FEMALE',
                        groupValue: giftCardController.selectedGenderMethodRadio.value,
                        onChanged: (value) {
                          giftCardController.selectedGenderMethodRadio.value = value!;
                        },
                        activeColor: ColorsForApp.primaryColor,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      ),
                      width(5),
                      Text(
                        'Female',
                        style: TextHelper.size14.copyWith(
                          color: giftCardController.selectedGenderMethodRadio.value == 'FEMALE' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                          fontWeight: giftCardController.selectedGenderMethodRadio.value == 'FEMALE' ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                      width(5),
                      Radio(
                        value: 'OTHER',
                        groupValue: giftCardController.selectedGenderMethodRadio.value,
                        onChanged: (value) {
                          giftCardController.selectedGenderMethodRadio.value = value!;
                        },
                        activeColor: ColorsForApp.primaryColor,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      ),
                      width(5),
                      Text(
                        'Other',
                        style: TextHelper.size14.copyWith(
                          color: giftCardController.selectedGenderMethodRadio.value == 'OTHER' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                          fontWeight: giftCardController.selectedGenderMethodRadio.value == 'OTHER' ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ],
                  )),
              // Firm
              CustomTextFieldWithTitle(
                controller: giftCardController.firmNameTxtController,
                title: 'Firm',
                hintText: 'Enter firm',
                isCompulsory: true,
                //readOnly: userData.email!=null?true:false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (giftCardController.firmNameTxtController.text.trim().isEmpty) {
                    return 'Please enter firm';
                  } else if (giftCardController.firmNameTxtController.text.length < 3) {
                    return 'Please enter valid firm';
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.home_work_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              CustomTextFieldWithTitle(
                controller: giftCardController.stateTxtController,
                title: 'State',
                hintText: 'Select state',
                isCompulsory: true,
                readOnly: true,
                validator: (value) {
                  if (giftCardController.stateTxtController.text.trim().isEmpty) {
                    return 'Please select state';
                  }
                  return null;
                },
                onTap: () async {
                  //Check If we got state ,city,block from pinCode then dropdown should be disable
                  StatesModel selectedState = await Get.toNamed(
                    Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                    arguments: [
                      giftCardController.statesList, // modelList
                      'statesList', // modelName
                    ],
                  );
                  if (selectedState.name != null && selectedState.name!.isNotEmpty) {
                    giftCardController.stateTxtController.text = selectedState.name!;
                    giftCardController.selectedStateId.value = selectedState.id!;
                  }
                },
                suffixIcon: GestureDetector(
                  onTap: () async {
                    //Check If we got state ,city,block from pinCode then dropdown should be disable
                    StatesModel selectedState = await Get.toNamed(
                      Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                      arguments: [
                        giftCardController.statesList, // modelList
                        'statesList', // modelName
                      ],
                    );
                    if (selectedState.name != null && selectedState.name!.isNotEmpty) {
                      giftCardController.stateTxtController.text = selectedState.name!;
                      giftCardController.selectedStateId.value = selectedState.id!;
                    }
                  },
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    size: 18,
                    color: ColorsForApp.secondaryColor,
                  ),
                ),
              ),
              // Firm
              CustomTextFieldWithTitle(
                controller: giftCardController.remarkTxtController,
                title: 'Remark',
                hintText: 'Enter remark',
                isCompulsory: false,
                maxLines: 4,
                //readOnly: userData.email!=null?true:false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (giftCardController.remarkTxtController.text.isNotEmpty) {
                    if (giftCardController.remarkTxtController.text.length < 3) {
                      return 'Please enter valid remark';
                    }
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.comment_bank,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              height(2.h),
              CommonButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // onboard user
                    bool result = await giftCardController.giftCardOnboardApi();
                    // if user onboard successfully then again verify user
                    if (result == true) {
                      int verifyResult = await giftCardController.verifyUserGiftCardApi();
                      if (verifyResult == 1) {
                        // if user verify successfully show all gifts cards
                        Get.toNamed(Routes.GIFTCARD_SCREEN);
                      }
                    }
                  }
                },
                label: 'Proceed',
              ),
              height(1.h),
            ],
          ),
        ),
      ),
    );
  }
}

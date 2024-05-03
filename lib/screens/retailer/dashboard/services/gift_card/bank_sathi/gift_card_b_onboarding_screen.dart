import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/gift_card_b_controller.dart';
import '../../../../../../model/gift_card_b/company_model.dart';
import '../../../../../../model/gift_card_b/occupation_model.dart';
import '../../../../../../model/gift_card_b/pincode_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class GiftCardBOnboardingScreen extends StatefulWidget {
  const GiftCardBOnboardingScreen({super.key});

  @override
  State<GiftCardBOnboardingScreen> createState() => _GiftCardBOnboardingScreenState();
}

class _GiftCardBOnboardingScreenState extends State<GiftCardBOnboardingScreen> {
  final GiftCardBController giftCardBController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      giftCardBController.setVerifiedDataIntoVariables(giftCardBController.verifiedUserDataModel.value);
      await giftCardBController.getOccupationListApi(isLoaderShow: false);
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    giftCardBController.resetOnboardingVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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
                controller: giftCardBController.firstNameTxtController,
                title: 'First Name',
                hintText: 'Enter first name',
                maxLength: 200,
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textInputFormatter: [
                  FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (giftCardBController.firstNameTxtController.text.trim().isEmpty) {
                    return 'Please enter first name';
                  } else if (giftCardBController.firstNameTxtController.text.length < 3) {
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
                controller: giftCardBController.lastnameTxtController,
                title: 'Last Name',
                hintText: 'Enter last name',
                maxLength: 200,
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textInputFormatter: [
                  FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (giftCardBController.lastnameTxtController.text.trim().isEmpty) {
                    return 'Please enter last name';
                  } else if (giftCardBController.lastnameTxtController.text.length < 3) {
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
                controller: giftCardBController.mobileTxtController,
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
                  if (giftCardBController.mobileTxtController.text.trim().isEmpty) {
                    return 'Please enter mobile number';
                  } else if (giftCardBController.mobileTxtController.text.length < 10) {
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
                controller: giftCardBController.emailTxtController,
                title: 'Email',
                hintText: 'Enter email',
                isCompulsory: true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (giftCardBController.emailTxtController.text.trim().isEmpty) {
                    return 'Please enter email';
                  } else if (!GetUtils.isEmail(giftCardBController.emailTxtController.text.trim())) {
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
              // dob date
              CustomTextFieldWithTitle(
                controller: giftCardBController.dobTxtController,
                title: 'Date of Birth',
                hintText: 'Select birth date',
                readOnly: true,
                isCompulsory: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                suffixIcon: Icon(
                  Icons.calendar_month,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
                onTap: () async {
                  await customDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now(),
                    controller: giftCardBController.dobTxtController,
                    dateFormat: 'yyyy-MM-dd',
                  );
                },
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please select dob date';
                  } else {
                    DateTime pickedDate = DateTime.parse(giftCardBController.dobTxtController.text);
                    final age = DateTime.now().year - pickedDate.year - ((DateTime.now().month > pickedDate.month || (DateTime.now().month == pickedDate.month && DateTime.now().day >= pickedDate.day)) ? 0 : 1);
                    if (age < 18) {
                      return 'You must be 18 years or older to proceed';
                    }
                  }
                  return null;
                },
              ),
              const Text("Gender"),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio(
                        value: 'Male',
                        groupValue: giftCardBController.selectedGenderMethodRadio.value,
                        onChanged: (value) {
                          giftCardBController.selectedGenderMethodRadio.value = value!;
                        },
                        activeColor: ColorsForApp.primaryColor,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      ),
                      width(5),
                      Text(
                        'Male',
                        style: TextHelper.size14.copyWith(
                          color: giftCardBController.selectedGenderMethodRadio.value == 'Male' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                          fontWeight: giftCardBController.selectedGenderMethodRadio.value == 'Male' ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                      width(15),
                      Radio(
                        value: 'Female',
                        groupValue: giftCardBController.selectedGenderMethodRadio.value,
                        onChanged: (value) {
                          giftCardBController.selectedGenderMethodRadio.value = value!;
                        },
                        activeColor: ColorsForApp.primaryColor,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      ),
                      width(5),
                      Text(
                        'Female',
                        style: TextHelper.size14.copyWith(
                          color: giftCardBController.selectedGenderMethodRadio.value == 'Female' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                          fontWeight: giftCardBController.selectedGenderMethodRadio.value == 'Female' ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                      width(5),
                      Radio(
                        value: 'Other',
                        groupValue: giftCardBController.selectedGenderMethodRadio.value,
                        onChanged: (value) {
                          giftCardBController.selectedGenderMethodRadio.value = value!;
                        },
                        activeColor: ColorsForApp.primaryColor,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      ),
                      width(5),
                      Text(
                        'Other',
                        style: TextHelper.size14.copyWith(
                          color: giftCardBController.selectedGenderMethodRadio.value == 'Other' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                          fontWeight: giftCardBController.selectedGenderMethodRadio.value == 'Other' ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ],
                  )),
              height(1.h),
              const Text("Choose category"),
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Radio(
                        value: 'Individual',
                        groupValue: giftCardBController.selectedCategoryMethodRadio.value,
                        onChanged: (value) {
                          giftCardBController.selectedCategoryMethodRadio.value = value!;
                        },
                        activeColor: ColorsForApp.primaryColor,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      ),
                      width(5),
                      Text(
                        'Individual',
                        style: TextHelper.size14.copyWith(
                          color: giftCardBController.selectedCategoryMethodRadio.value == 'Individual' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                          fontWeight: giftCardBController.selectedCategoryMethodRadio.value == 'Individual' ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                      width(15),
                      Radio(
                        value: 'Non-Individual',
                        groupValue: giftCardBController.selectedCategoryMethodRadio.value,
                        onChanged: (value) {
                          giftCardBController.selectedCategoryMethodRadio.value = value!;
                        },
                        activeColor: ColorsForApp.primaryColor,
                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                      ),
                      width(5),
                      Text(
                        'Non-Individual',
                        style: TextHelper.size14.copyWith(
                          color: giftCardBController.selectedCategoryMethodRadio.value == 'Non-Individual' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                          fontWeight: giftCardBController.selectedCategoryMethodRadio.value == 'Non-Individual' ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ],
                  )),
              height(1.h),
              // Firm
              CustomTextFieldWithTitle(
                controller: giftCardBController.firmNameTxtController,
                title: 'Firm',
                hintText: 'Select firm',
                isCompulsory: true,
                readOnly: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                suffixIcon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
                onTap: () async {
                  CompanyListModel selectedCompany = await Get.toNamed(Routes.SEARCHABLE_LIST_VIEW_SCREEN, arguments: [[], 'firmList']);
                  if (selectedCompany.companyName != null) {
                    giftCardBController.firmNameTxtController.text = selectedCompany.companyName!;
                    giftCardBController.selectedCompanyId.value = selectedCompany.id!;
                  }
                },
                validator: (value) {
                  if (giftCardBController.firmNameTxtController.text.trim().isEmpty) {
                    return 'Please select firm';
                  }
                  return null;
                },
              ),
              // Occupation
              CustomTextFieldWithTitle(
                controller: giftCardBController.occupationTxtController,
                title: 'Occupation',
                hintText: 'Select occupation',
                isCompulsory: true,
                readOnly: true,
                validator: (value) {
                  if (giftCardBController.occupationTxtController.text.trim().isEmpty) {
                    return 'Please select occupation';
                  }
                  return null;
                },
                onTap: () async {
                  giftCardBController.monthlySalaryTxtController.clear();
                  giftCardBController.itrTxtController.clear();
                  giftCardBController.amountIntoWords.value = '';
                  OccupationListModel selectedOccupation = await Get.toNamed(Routes.SEARCHABLE_LIST_VIEW_SCREEN, arguments: [giftCardBController.occupationList, 'occupationList']);
                  if (selectedOccupation.occuTitle != null) {
                    giftCardBController.occupationTxtController.text = selectedOccupation.occuTitle!;
                    giftCardBController.selectedOccupationId.value = selectedOccupation.id!;
                  }
                },
                suffixIcon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              Obx(() => Visibility(
                  visible: giftCardBController.selectedOccupationId.value == 1 || giftCardBController.selectedOccupationId.value == 3 ? true : false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFieldWithTitle(
                        title: 'Monthly Salary',
                        controller: giftCardBController.monthlySalaryTxtController,
                        hintText: 'Enter salary',
                        maxLength: 7,
                        isCompulsory: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        obscureText: false,
                        onChange: (value) {
                          if (giftCardBController.monthlySalaryTxtController.text.isNotEmpty && int.parse(giftCardBController.monthlySalaryTxtController.text.trim()) > 0) {
                            giftCardBController.amountIntoWords.value = getAmountIntoWords(int.parse(giftCardBController.monthlySalaryTxtController.text.trim()));
                          } else {
                            giftCardBController.amountIntoWords.value = '';
                          }
                        },
                        validator: (value) {
                          String amountText = giftCardBController.monthlySalaryTxtController.text.trim();
                          if (amountText.isEmpty) {
                            return 'Please enter salary';
                          }
                          if (int.parse(amountText) <= 0) {
                            return 'Salary should be greater than 0';
                          }
                          return null;
                        },
                      ),
                      // Amount in text
                      Visibility(
                        visible: giftCardBController.amountIntoWords.value.isNotEmpty ? true : false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              giftCardBController.amountIntoWords.value,
                              style: TextHelper.size13.copyWith(
                                fontFamily: mediumGoogleSansFont,
                                color: ColorsForApp.successColor,
                              ),
                            ),
                            height(0.5.h),
                          ],
                        ),
                      ),
                    ],
                  ))),
              Obx(() => Visibility(
                  visible: giftCardBController.selectedOccupationId.value == 2 ? true : false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextFieldWithTitle(
                        title: 'ITR Amount',
                        controller: giftCardBController.itrTxtController,
                        hintText: 'Enter itr amount',
                        maxLength: 7,
                        isCompulsory: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        obscureText: false,
                        onChange: (value) {
                          if (giftCardBController.itrTxtController.text.isNotEmpty && int.parse(giftCardBController.itrTxtController.text.trim()) > 0) {
                            giftCardBController.amountIntoWords.value = getAmountIntoWords(int.parse(giftCardBController.itrTxtController.text.trim()));
                          } else {
                            giftCardBController.amountIntoWords.value = '';
                          }
                        },
                        validator: (value) {
                          String amountText = giftCardBController.itrTxtController.text.trim();
                          if (amountText.isEmpty) {
                            return 'Please enter itr amount';
                          }
                          if (int.parse(amountText) <= 0) {
                            return 'ITR amount should be greater than 0';
                          }
                          return null;
                        },
                      ),
                      // Amount in text
                      Visibility(
                        visible: giftCardBController.amountIntoWords.value.isNotEmpty ? true : false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            height(0.6.h),
                            Text(
                              giftCardBController.amountIntoWords.value,
                              style: TextHelper.size13.copyWith(
                                fontFamily: mediumGoogleSansFont,
                                color: ColorsForApp.successColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),

              // pinCode
              CustomTextFieldWithTitle(
                controller: giftCardBController.pinCodeTxtController,
                title: 'Pincode',
                hintText: 'Select pincode',
                isCompulsory: true,
                readOnly: true,
                validator: (value) {
                  if (giftCardBController.pinCodeTxtController.text.trim().isEmpty) {
                    return 'Please select pincode';
                  }
                  return null;
                },
                onTap: () async {
                  PinCodeListModel selectedPinCode = await Get.toNamed(Routes.SEARCHABLE_LIST_VIEW_SCREEN, arguments: [[], 'pinCodeList']);
                  if (selectedPinCode.pinCode != null) {
                    giftCardBController.pinCodeTxtController.text = selectedPinCode.pinCode!;
                    giftCardBController.selectedPinCodeId.value = selectedPinCode.id!;
                  }
                },
                suffixIcon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              // address
              CustomTextFieldWithTitle(
                controller: giftCardBController.addressTxtController,
                title: 'Address',
                hintText: 'Enter address',
                isCompulsory: false,
                maxLines: 4,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (giftCardBController.addressTxtController.text.trim().isEmpty) {
                    return 'Please enter address';
                  } else if (giftCardBController.addressTxtController.text.trim().length < 5) {
                    return 'Please enter valid address';
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.home_work_outlined,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              height(2.h),
              CommonButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // onboard user
                      bool result = await giftCardBController.giftCardOnboardApi(isLoaderShow: true);
                      // if user onboard successfully then navigate to all product list page.
                      if (result == true) {
                        Get.toNamed(Routes.ELIGIBLE_PRODUCT_lIST_SCREEN);
                      }
                    }
                  },
                  label: 'Proceed'),
              height(1.h),
            ],
          ),
        ),
      ),
      title: 'Onboarding',
      isShowLeadingIcon: true,
    );
  }
}

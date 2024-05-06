import 'dart:io';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../controller/retailer/matm/credo_pay_controller.dart';
import '../../../../../../controller/retailer/matm/matm_controller.dart';
import '../../../../../../model/credopay/device_model.dart';
import '../../../../../../model/credopay/merchant_category_model.dart';
import '../../../../../../model/credopay/merchant_type_model.dart';
import '../../../../../../model/credopay/terminal_type_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/permission_handler.dart';
import '../../../../../../utils/string_constants.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/base_dropdown.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field_with_title.dart';

enum StepEnabling { sequential, individual }

class CredoPayOnboardingScreen extends StatefulWidget {
  const CredoPayOnboardingScreen({super.key});

  @override
  State<CredoPayOnboardingScreen> createState() => _MAtmOnboardingScreenState();
}

class _MAtmOnboardingScreenState extends State<CredoPayOnboardingScreen> {
  CredoPayController credoPayController = Get.find();
  MAtmController mAtmController = Get.find();

  final GlobalKey<FormState> companyFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> terminalFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> documentFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> personalDetailsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (credoPayController.activeStep.value == 2) {
      credoPayController.getKycDocuments(isLoaderShow: true, businessType: mAtmController.matmAuthDetailsModel.value.credo!.businessType!);
    } else if (credoPayController.activeStep.value == 3) {
      credoPayController.referenceNumber.value = mAtmController.matmAuthDetailsModel.value.credo!.refNumber!;
      callTerminalAPI();
    } else if (credoPayController.activeStep.value == 0) {
      callAPI();
    }
  }

  Future<void> callAPI() async {
    showProgressIndicator();
    await credoPayController.getMerchantCategories(
      isLoaderShow: false,
    );
    await credoPayController.getMerchantType(
      isLoaderShow: false,
    );

    dismissProgressIndicator();
  }

  Future<void> callTerminalAPI() async {
    showProgressIndicator();
    await credoPayController.getTerminalType(
      isLoaderShow: false,
    );
    await credoPayController.getDeviceModelApi(
      isLoaderShow: false,
    );

    dismissProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 16.h,
      title: 'MATM Onboarding',
      isShowLeadingIcon: true,
      mainBody: Padding(
        padding: EdgeInsets.only(left: 3.w, top: 2.h, right: 3.w),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Sign up your merchant Onboarding",
                    style: TextHelper.size14.copyWith(color: Colors.black, fontFamily: mediumGoogleSansFont),
                  ),
                  height(3.h),
                  EasyStepper(
                    padding: EdgeInsets.symmetric(horizontal: 2.h),
                    activeStep: credoPayController.activeStep.value,
                    lineStyle: LineStyle(
                      lineLength: 5.h,
                      lineType: LineType.normal,
                      activeLineColor: Colors.indigo,
                      lineThickness: 0.8,
                      finishedLineColor: ColorsForApp.primaryColor,
                      defaultLineColor: Colors.grey,
                    ),
                    alignment: Alignment.topCenter,
                    activeStepBorderColor: Colors.indigo,
                    finishedStepIconColor: ColorsForApp.primaryColor,
                    activeStepBorderType: BorderType.normal,
                    defaultStepBorderType: BorderType.normal,
                    finishedStepBorderColor: ColorsForApp.stepBorderColor,
                    direction: Axis.horizontal,
                    unreachedStepTextColor: Colors.black,
                    fitWidth: true,
                    stepShape: StepShape.circle,
                    stepBorderRadius: 18,
                    borderThickness: 8,
                    activeStepTextColor: ColorsForApp.primaryColor,
                    finishedStepTextColor: ColorsForApp.primaryColor,
                    finishedStepBackgroundColor: ColorsForApp.stepBgColor,
                    internalPadding: 12,
                    unreachedStepBackgroundColor: ColorsForApp.stepBgColor,
                    unreachedStepBorderColor: ColorsForApp.stepBorderColor,
                    activeStepIconColor: ColorsForApp.primaryColor,
                    activeStepBackgroundColor: ColorsForApp.stepBgColor,
                    showLoadingAnimation: true,
                    stepRadius: 18,
                    textDirection: TextDirection.ltr,
                    showStepBorder: true,
                    steppingEnabled: false,
                    enableStepTapping: false,
                    onStepReached: (index) {
                      credoPayController.activeStep.value = index;
                    },
                    steps: const [
                      EasyStep(
                        icon: Icon(Icons.house_siding),
                        title: 'Company',
                      ),
                      EasyStep(
                        icon: Icon(CupertinoIcons.person_alt_circle),
                        title: 'Personal',
                      ),
                      EasyStep(
                        icon: Icon(CupertinoIcons.doc),
                        title: 'Document',
                      ),
                      EasyStep(
                        icon: Icon(CupertinoIcons.text_aligncenter),
                        title: 'Terminal',
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Visibility(visible: credoPayController.activeStep.value == 0, child: companyDetails()),
                      Visibility(visible: credoPayController.activeStep.value == 1, child: personalDetails()),
                      Visibility(visible: credoPayController.activeStep.value == 2, child: documentDetails()),
                      Visibility(visible: credoPayController.activeStep.value == 3, child: terminalDetails()),
                    ],
                  ),
                ),
              ),
              height(1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(visible: credoPayController.activeStep.value == 1 ? true : false, child: cancelStep(StepEnabling.sequential)),
                  nextStep(StepEnabling.sequential, context)
                  /* if (kycController.activeStep.value < kycController.kycStepList.length - 1)
                                nextStep(StepEnabling.sequential,context)
                              else if (kycController.activeStep.value == kycController.kycStepList.length - 1)
                                submitStep(context)*/
                ],
              ),
              height(2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget terminalDetails() {
    return Form(
      key: terminalFormKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Column(
          children: [
            height(1.h),
            // Terminal type
            CustomTextFieldWithTitle(
              controller: credoPayController.terminalTypeController,
              title: 'Terminal Type',
              hintText: 'Select terminal type',
              readOnly: true,
              isCompulsory: true,
              onTap: () async {
                TerminalTypeListModel selectedTerminalType = await Get.toNamed(
                  Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                  arguments: [
                    credoPayController.terminalTypeList, // modelList
                    'terminalTypeList', // modelName
                  ],
                );
                if (selectedTerminalType.name != null && selectedTerminalType.id!.toString().isNotEmpty) {
                  credoPayController.selectedTerminalTypeId.value = selectedTerminalType.id!.toString();
                  credoPayController.terminalTypeController.text = selectedTerminalType.name.toString();
                }
              },
              validator: (value) {
                if (credoPayController.terminalTypeController.text.trim().isEmpty) {
                  return 'Please select terminal type';
                }
                return null;
              },
              suffixIcon: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: ColorsForApp.greyColor,
              ),
            ),
            height(1.h),
            // select device
            CustomTextFieldWithTitle(
              controller: credoPayController.deviceModelController,
              title: 'Device Model',
              hintText: 'Select device model',
              readOnly: true,
              isCompulsory: true,
              onTap: () async {
                DeviceListModel selectedDeviceModel = await Get.toNamed(
                  Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                  arguments: [
                    credoPayController.deviceModelList, // modelList
                    'deviceModelList', // modelName
                  ],
                );
                if (selectedDeviceModel.name != null && selectedDeviceModel.id!.toString().isNotEmpty) {
                  credoPayController.selectedDeviceModelId.value = selectedDeviceModel.id!.toString();
                  credoPayController.deviceModelController.text = selectedDeviceModel.name.toString();
                }
              },
              validator: (value) {
                if (credoPayController.terminalTypeController.text.trim().isEmpty) {
                  return 'Please select device model';
                }
                return null;
              },
              suffixIcon: Icon(
                Icons.keyboard_arrow_right_rounded,
                color: ColorsForApp.greyColor,
              ),
            ),
            height(1.h),
            //Device Serial Number
            CustomTextFieldWithTitle(
              controller: credoPayController.deviceSerialNumberController,
              title: 'Device Serial Number',
              hintText: 'Enter device serial number',
              isCompulsory: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (credoPayController.deviceSerialNumberController.text.trim().isEmpty) {
                  return 'Please enter serial number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget companyDetails() {
    return Form(
      key: companyFormKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            CustomTextFieldWithTitle(
              controller: credoPayController.firmNameTxtController,
              title: 'Firm Name',
              hintText: 'Enter firm name',
              maxLength: 50,
              isCompulsory: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (credoPayController.firmNameTxtController.text.trim().isEmpty) {
                  return 'Please enter firm name';
                } else if (credoPayController.firmNameTxtController.text.trim().length < 3) {
                  return 'Please enter valid name';
                }
                return null;
              },
            ),
            // Mobile number
            CustomTextFieldWithTitle(
              controller: credoPayController.firmMobileNoTxtController,
              title: 'Firm Mobile Number',
              hintText: 'Enter firm mobile number',
              maxLength: 10,
              readOnly: true,
              isCompulsory: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              textInputFormatter: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validator: (value) {
                if (credoPayController.firmMobileNoTxtController.text.trim().isEmpty) {
                  return 'Please enter firm mobile number';
                } else if (credoPayController.firmMobileNoTxtController.text.trim().length < 10) {
                  return 'Please enter valid firm mobile number';
                }
                return null;
              },
            ),
            // Email
            CustomTextFieldWithTitle(
              controller: credoPayController.firmEmailTxtController,
              title: 'Firm Email',
              hintText: 'Enter firm email',
              isCompulsory: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final emailRegex = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
                if (value!.isEmpty) {
                  return 'Please enter email';
                } else if (!emailRegex.hasMatch(value)) {
                  return 'Please enter valid email';
                }
                return null;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Pincode
                Expanded(
                  child: CustomTextFieldWithTitle(
                      controller: credoPayController.firmAreaPinCodeTxtController,
                      title: 'PinCode',
                      hintText: 'Enter pincode',
                      maxLength: 6,
                      isCompulsory: true,
                      keyboardType: TextInputType.text,
                      onChange: (value) {
                        if (credoPayController.firmAreaPinCodeTxtController.text.trim().length < 6) {
                          credoPayController.isPinCodeVerified.value = false;
                        }
                      },
                      textInputAction: TextInputAction.next,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      validator: (value) {
                        if (credoPayController.firmAreaPinCodeTxtController.text.trim().isEmpty) {
                          return 'Please enter pincode';
                        } else if (credoPayController.firmAreaPinCodeTxtController.text.trim().length < 6) {
                          return 'Please enter valid pincode';
                        }
                        return null;
                      }),
                ),
                //Button Pincode Details
                width(3.w),
                CommonButton(
                    width: 30.w,
                    bgColor: credoPayController.isPinCodeVerified.value == true ? Colors.green : ColorsForApp.primaryColor,
                    onPressed: () async {
                      if (credoPayController.firmAreaPinCodeTxtController.text.isEmpty) {
                        errorSnackBar(message: "please enter pincode first");
                      } else {
                        bool result = await credoPayController.getPinCodeDetails();
                        if (result == true) {
                          if (credoPayController.pinCodeID.value.isEmpty) {
                            errorSnackBar(message: 'Details not found please try again');
                          } else {
                            credoPayController.isPinCodeVerified.value = true;
                          }
                        }
                      }
                    },
                    style: credoPayController.isPinCodeVerified.value == false ? TextHelper.size12.copyWith(fontFamily: regularGoogleSansFont, color: Colors.white) : TextHelper.size12.copyWith(fontFamily: mediumGoogleSansFont, color: Colors.white),
                    label: credoPayController.isPinCodeVerified.value == false ? "Verify" : "Verified"),
              ],
            ),
            Visibility(
              visible: credoPayController.isPinCodeVerified.value,
              child: Row(
                children: [
                  //State
                  Expanded(
                    child: CustomTextFieldWithTitle(
                      controller: credoPayController.firmStateTxtController,
                      title: 'State',
                      hintText: 'Enter state',
                      isCompulsory: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (credoPayController.firmStateTxtController.text.trim().isEmpty) {
                          return 'Please enter state';
                        }
                        return null;
                      },
                    ),
                  ),
                  width(1.w),
                  // City
                  Expanded(
                    child: CustomTextFieldWithTitle(
                        controller: credoPayController.firmCityTxtController,
                        title: 'City',
                        hintText: 'Enter city',
                        isCompulsory: true,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (credoPayController.firmCityTxtController.text.trim().isEmpty) {
                            return 'Please enter city';
                          }
                          return null;
                        }),
                  ),
                ],
              ),
            ),
            // Address
            CustomTextFieldWithTitle(
              controller: credoPayController.firmAddressTxtController,
              title: 'Address',
              hintText: 'Enter address',
              maxLength: 120,
              isCompulsory: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (credoPayController.firmAddressTxtController.text.trim().isEmpty) {
                  return 'Please enter address';
                }
                return null;
              },
            ),

            // Business type

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Business Type",
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
            Obx(
              () => BaseDropDown(
                value: credoPayController.selectedBusinessType.value.isEmpty ? null : credoPayController.selectedBusinessType.value,
                options: credoPayController.businessTypeList.map(
                  (element) {
                    return element;
                  },
                ).toList(),
                onChanged: (value) async {
                  credoPayController.selectedBusinessType.value = value!;
                  mAtmController.matmAuthDetailsModel.value.credo!.businessType = value;
                  GetStorage().write(businessTypeKey, credoPayController.selectedBusinessType.value);
                },
                hintText: 'Select Business Type',
              ),
            ),
            height(1.5.h),
            // Pan number
            CustomTextFieldWithTitle(
              controller: credoPayController.firmPanNumberTxtController,
              title: 'Firm Pan Number',
              hintText: 'Enter firm pan number',
              maxLength: 10,
              isCompulsory: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (value) {
                final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
                if (value!.isEmpty) {
                  return 'Please enter pan card number';
                } else if (!panRegex.hasMatch(value)) {
                  return 'Please enter valid pan number';
                }
                return null;
              },
            ),

            // Firm GST IN
            Visibility(
              visible: credoPayController.selectedBusinessType.value == 'individual' ? false : true,
              child: CustomTextFieldWithTitle(
                controller: credoPayController.firmGSTINTxtController,
                title: 'Firm GSTIN',
                hintText: 'Ex - 22MJHGT7652P',
                maxLength: 16,
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  final gstINRegex = RegExp(r'(^([0]{1}[1-9]{1}|[1-2]{1}[0-9]{1}|[3]{1}[0-7]{1})([a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9a-zA-Z]{1}[zZ]{1}[0-9a-zA-Z]{1})+$)');
                  if (value!.isEmpty) {
                    return 'Please enter GSTIN';
                  } else if (!gstINRegex.hasMatch(value)) {
                    return 'Please enter valid GSTIN';
                  }
                  return null;
                },
              ),
            ),

            // Firm Established year
            CustomTextFieldWithTitle(
              controller: credoPayController.firmEstablishedYearTxtController,
              title: 'Firm Established Year ',
              hintText: 'Ex - 2020',
              maxLength: 15,
              isCompulsory: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              textInputFormatter: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validator: (value) {
                if (credoPayController.firmEstablishedYearTxtController.text.trim().isEmpty) {
                  return 'Please enter year';
                } else if (credoPayController.firmEstablishedYearTxtController.text.trim().length < 4) {
                  return 'Please enter valid year';
                }
                return null;
              },
            ),

            // Business Nature
            CustomTextFieldWithTitle(
              controller: credoPayController.firmBusinessNatureTxtController,
              title: 'Business Nature',
              hintText: 'Enter Business Nature',
              maxLength: 20,
              isCompulsory: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (credoPayController.firmBusinessNatureTxtController.text.trim().isEmpty) {
                  return 'Please enter business nature';
                } else if (credoPayController.firmBusinessNatureTxtController.text.trim().length < 4) {
                  return 'Please enter valid business nature';
                }
                return null;
              },
            ),
            // Merchant Category
            CustomTextFieldWithTitle(
              controller: credoPayController.merchantCategoryTxtController,
              title: 'Merchant Category ',
              hintText: 'Select Merchant Category',
              maxLength: 10,
              readOnly: true,
              isCompulsory: true,
              textInputAction: TextInputAction.next,
              onTap: () async {
                CategoryListModel selectedCategory = await Get.toNamed(
                  Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                  arguments: [
                    credoPayController.merchantCategoryList, // modelList
                    'merchantCategoryList', // modelName
                  ],
                );
                if (selectedCategory.description != null && selectedCategory.id!.toString().isNotEmpty) {
                  credoPayController.selectedMerchantCategoryId.value = selectedCategory.id!.toString();
                  credoPayController.merchantCategoryTxtController.text = selectedCategory.description.toString();
                }
              },
              validator: (value) {
                if (credoPayController.merchantCategoryTxtController.text.trim().isEmpty) {
                  return 'Please select merchant category';
                }
                return null;
              },
            ),
            // Merchant Type
            CustomTextFieldWithTitle(
              controller: credoPayController.merchantTypeTxtController,
              title: 'Merchant Type',
              hintText: 'Select Merchant Type',
              maxLength: 10,
              readOnly: true,
              isCompulsory: true,
              textInputAction: TextInputAction.next,
              onTap: () async {
                MerchantTypeData selectedMerchantType = await Get.toNamed(
                  Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                  arguments: [
                    credoPayController.merchantTypeList, // modelList
                    'merchantTypeList', // modelName
                  ],
                );
                if (selectedMerchantType.name != null && selectedMerchantType.id!.toString().isNotEmpty) {
                  credoPayController.selectedMerchantTypeId.value = selectedMerchantType.id!.toString();
                  credoPayController.merchantTypeTxtController.text = selectedMerchantType.name.toString();
                }
              },
              validator: (value) {
                if (credoPayController.merchantTypeTxtController.text.trim().isEmpty) {
                  return 'Please select merchant type';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget personalDetails() {
    return Form(
      key: personalDetailsFormKey,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Title
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Title',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorsForApp.blackColor,
                  ),
                  children: [
                    TextSpan(
                      text: '',
                      style: TextStyle(
                        color: ColorsForApp.errorColor,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              height(0.8.h),
              BaseDropDown(
                value: credoPayController.selectedTitle.value.isEmpty ? null : credoPayController.selectedTitle.value,
                options: credoPayController.titleList.map(
                  (element) {
                    return element;
                  },
                ).toList(),
                hintText: 'Select title',
                onChanged: (value) async {
                  credoPayController.selectedTitle.value = value!;
                },
              ),
              height(1.5.h),
              // Name
              Row(
                children: [
                  Expanded(
                    child: CustomTextFieldWithTitle(
                      controller: credoPayController.firstNameTxtController,
                      title: 'First Name',
                      hintText: 'Enter first name',
                      maxLength: 50,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s'-]")),
                      ],
                      validator: (value) {
                        RegExp nameRegex = RegExp(r"^[a-zA-Z\s'-]{3,50}$");
                        if (credoPayController.firstNameTxtController.text.trim().isEmpty) {
                          return 'Please enter first name';
                        } else if (!nameRegex.hasMatch(credoPayController.firstNameTxtController.text.trim())) {
                          return 'Please enter valid first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  width(2.w),
                  Expanded(
                    child: CustomTextFieldWithTitle(
                      controller: credoPayController.lastNameTxtController,
                      title: 'Last Name',
                      hintText: 'Enter last name',
                      maxLength: 50,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s'-]")),
                      ],
                      validator: (value) {
                        RegExp nameRegex = RegExp(r"^[a-zA-Z\s'-]{3,50}$");
                        if (credoPayController.lastNameTxtController.text.trim().isEmpty) {
                          return 'Please enter last name';
                        } else if (!nameRegex.hasMatch(credoPayController.lastNameTxtController.text.trim())) {
                          return 'Please enter valid last name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  //NATIONALITY
                  Expanded(
                    child: CustomTextFieldWithTitle(
                      controller: credoPayController.nationalityTxtController,
                      title: 'Nationality',
                      hintText: 'Enter nationality',
                      maxLength: 50,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s'-]")),
                      ],
                      validator: (value) {
                        RegExp nameRegex = RegExp(r"^[a-zA-Z\s'-]{3,50}$");
                        if (credoPayController.firstNameTxtController.text.trim().isEmpty) {
                          return 'Please enter nationality';
                        } else if (!nameRegex.hasMatch(credoPayController.firstNameTxtController.text.trim())) {
                          return 'Please enter valid nationality';
                        }
                        return null;
                      },
                    ),
                  ),
                  width(2.w),
                  //DOB
                  Expanded(
                    child: CustomTextFieldWithTitle(
                      controller: credoPayController.dobTxtController,
                      title: 'DOB',
                      hintText: 'Enter DOB(as per document)',
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      suffixIcon: const Icon(Icons.calendar_month_outlined),
                      onTap: () async {
                        await customDatePicker(
                          context: Get.context!,
                          firstDate: DateTime(DateTime.now().year - 50),
                          initialDate: DateTime.now(),
                          lastDate: DateTime.now(),
                          controller: credoPayController.dobTxtController,
                          dateFormat: 'yyyy-MM-dd',
                        );
                      },
                      validator: (value) {
                        if (credoPayController.dobTxtController.text.trim().isEmpty) {
                          return 'Please select dob';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              // Address
              CustomTextFieldWithTitle(
                controller: credoPayController.addressDetailsTxtController,
                title: 'Address Details',
                hintText: 'Enter full address',
                maxLines: 3,
                maxLength: 120,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (credoPayController.addressDetailsTxtController.text.trim().isEmpty) {
                    return 'Please enter full address';
                  }
                  return null;
                },
              ),
              // Select account type
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Is Own House',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorsForApp.blackColor,
                  ),
                  children: [
                    TextSpan(
                      text: ' ',
                      style: TextStyle(
                        color: ColorsForApp.errorColor,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              height(0.8.h),
              // Payment method radio
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Radio(
                    value: 'Yes',
                    groupValue: credoPayController.selectedAccountTypeRadio.value,
                    onChanged: (value) {
                      credoPayController.selectedAccountTypeRadio.value = value!;
                    },
                    activeColor: ColorsForApp.primaryColor,
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  ),
                  width(5),
                  GestureDetector(
                    onTap: () {
                      credoPayController.selectedAccountTypeRadio.value = 'Yes';
                    },
                    child: Text(
                      'Yes',
                      style: TextHelper.size14.copyWith(
                        color: credoPayController.selectedAccountTypeRadio.value == 'Yes' ? ColorsForApp.blackColor : ColorsForApp.blackColor.withOpacity(0.5),
                        fontWeight: credoPayController.selectedAccountTypeRadio.value == 'Yes' ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ),
                  width(15),
                  Radio(
                    value: 'No',
                    groupValue: credoPayController.selectedAccountTypeRadio.value,
                    onChanged: (value) {
                      credoPayController.selectedAccountTypeRadio.value = value!;
                    },
                    activeColor: ColorsForApp.primaryColor,
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                  ),
                  width(5),
                  GestureDetector(
                    onTap: () {
                      credoPayController.selectedAccountTypeRadio.value = 'No';
                    },
                    child: Text(
                      'No',
                      style: TextHelper.size14.copyWith(
                        color: credoPayController.selectedAccountTypeRadio.value == 'No' ? ColorsForApp.blackColor : ColorsForApp.blackColor.withOpacity(0.5),
                        fontWeight: credoPayController.selectedAccountTypeRadio.value == 'No' ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              height(0.8.h),
              // Account number
              CustomTextFieldWithTitle(
                controller: credoPayController.accountNoTxtController,
                title: 'Account Number',
                hintText: 'Account number',
                minLength: 11,
                maxLength: 16,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (credoPayController.accountNoTxtController.text.trim().isEmpty) {
                    return 'Please enter account number';
                  } else if (credoPayController.accountNoTxtController.text.length < 11) {
                    return 'Please enter valid account number';
                  }
                  return null;
                },
              ),
              height(0.8.h),
              Row(
                children: [
                  Expanded(
                    child: // IFSC code
                        CustomTextFieldWithTitle(
                      controller: credoPayController.ifscCodeTxtController,
                      title: 'IFSC  Code',
                      hintText: 'IFSC code',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onChange: (value) {
                        credoPayController.isAccountVerified.value = false;
                        credoPayController.bankNameTxtController.clear();
                        credoPayController.branchNameTxtController.clear();
                      },
                      validator: (value) {
                        if (credoPayController.ifscCodeTxtController.text.trim().isEmpty) {
                          return 'Please enter ifsc code';
                        }
                        return null;
                      },
                    ),
                  ),
                  width(2.w),
                  Expanded(
                    child: CustomTextFieldWithTitle(
                      controller: credoPayController.bankNameTxtController,
                      title: 'Bank Name',
                      hintText: 'Bank name',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onChange: (value) {
                        credoPayController.isAccountVerified.value = false;
                      },
                      validator: (value) {
                        if (credoPayController.bankNameTxtController.text.trim().isEmpty) {
                          return 'Please enter bank name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              CustomTextFieldWithTitle(
                controller: credoPayController.branchNameTxtController,
                title: 'Branch Name',
                hintText: 'Branch name',
                keyboardType: TextInputType.text,
                onChange: (value) {
                  credoPayController.isAccountVerified.value = false;
                },
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (credoPayController.branchNameTxtController.text.trim().isEmpty) {
                    return 'Please enter Branch name';
                  }
                  return null;
                },
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Bank Type',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: ColorsForApp.blackColor,
                  ),
                  children: [
                    TextSpan(
                      text: ' ',
                      style: TextStyle(
                        color: ColorsForApp.errorColor,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
              height(0.8.h),
              BaseDropDown(
                value: credoPayController.selectedBankType.value.isEmpty ? null : credoPayController.selectedBankType.value,
                options: credoPayController.bankTypeList.map(
                  (element) {
                    return element;
                  },
                ).toList(),
                hintText: 'Select bank type',
                onChanged: (value) async {
                  credoPayController.selectedBankType.value = value!;
                },
              ),
              height(1.h),
              CommonButton(
                  width: 30.w,
                  bgColor: credoPayController.isAccountVerified.value == true ? Colors.green : ColorsForApp.primaryColor,
                  onPressed: () async {
                    if (credoPayController.ifscCodeTxtController.text.isEmpty && credoPayController.accountNoTxtController.text.length < 11) {
                      errorSnackBar(message: "please enter account details");
                    } else {
                      bool result = await credoPayController.verifyAccountDetailsApi();
                      if (result == true) {
                        if (credoPayController.ifscId.value.isEmpty) {
                          errorSnackBar(message: 'Details not found please try again');
                        } else {
                          credoPayController.isAccountVerified.value = true;
                        }
                      }
                    }
                  },
                  style: credoPayController.isAccountVerified.value == false ? TextHelper.size12.copyWith(fontFamily: regularGoogleSansFont, color: Colors.white) : TextHelper.size12.copyWith(fontFamily: mediumGoogleSansFont, color: Colors.white),
                  label: credoPayController.isAccountVerified.value == false ? "Verify Account" : "Verified"),
            ],
          ),
        ),
      ),
    );
  }

  Widget documentDetails() {
    return Form(
        key: documentFormKey,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: credoPayController.kycDocumentsList.length,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(2.w),
          itemBuilder: (context, index) {
            return Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    credoPayController.kycDocumentsList[index].name,
                    style: TextHelper.size15,
                  ),
                  height(2.h),
                  // Document slip
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Upload document',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorsForApp.blackColor,
                      ),
                      children: [
                        TextSpan(
                          text: ' *',
                          style: TextStyle(
                            color: credoPayController.kycDocumentsList[index].required ? ColorsForApp.errorColor : Colors.transparent,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  height(5),
                  Text(
                    'Document slip in jpg, png, jpeg format with maximum 6MB can be uploaded.',
                    style: TextHelper.size12.copyWith(
                      color: ColorsForApp.errorColor,
                    ),
                  ),
                  height(10),
                  credoPayController.kycDocumentsList[index].file.value.path.isNotEmpty
                      ? SizedBox(
                          height: 21.5.w,
                          width: 21.5.w,
                          child: Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              InkWell(
                                onTap: () async {
                                  OpenResult openResult = await OpenFile.open(credoPayController.kycDocumentsList[index].file.path);
                                  if (openResult.type != ResultType.done) {
                                    errorSnackBar(message: openResult.message);
                                  }
                                },
                                child: Container(
                                  height: 20.w,
                                  width: 20.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: ColorsForApp.greyColor.withOpacity(0.7),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(9),
                                    child: Obx(
                                      () => Image.file(
                                        File(credoPayController.kycDocumentsList[index].file.value.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    credoPayController.kycDocumentsList[index].file.value = File('');
                                  },
                                  child: Container(
                                    height: 6.w,
                                    width: 6.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: ColorsForApp.grayScale200,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.delete_rounded,
                                      color: ColorsForApp.errorColor,
                                      size: 4.5.w,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            await imageSourceDialog(context, credoPayController.kycDocumentsList[index].name, credoPayController.kycDocumentsList[index].type.toString(), index);
                          },
                          child: Container(
                            width: 100,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: ColorsForApp.primaryColor,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: ColorsForApp.primaryColor,
                                  size: 20,
                                ),
                                width(5),
                                Text(
                                  'Upload',
                                  style: TextHelper.size14.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: ColorsForApp.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Divider(color: Colors.grey.withOpacity(0.5)),
                height(1.h),
              ],
            );
          },
        ));
  }

// Image source dialog
  Future<dynamic> imageSourceDialog(BuildContext context, String name, String type, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Text(
            'Select image source',
            style: TextHelper.size20.copyWith(
              fontFamily: mediumGoogleSansFont,
            ),
          ),
          content: Text(
            'Capture a photo or choose from your phone for quick processing.',
            style: TextHelper.size14.copyWith(
              color: ColorsForApp.blackColor.withOpacity(0.7),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    try {
                      File capturedFile = File(await captureImage());
                      if (capturedFile.path.isNotEmpty) {
                        int fileSize = capturedFile.lengthSync();
                        int maxAllowedSize = 6 * 1024 * 1024;
                        if (fileSize > maxAllowedSize) {
                          errorSnackBar(message: 'File size should be less than 6 MB');
                        } else {
                          credoPayController.kycDocumentsList[index].file.value = capturedFile;
                          Map object = {
                            "name": name,
                            "typeId": type,
                            "docNumber": type,
                            "fileUrl": "",
                            "fileName": basename(capturedFile.path),
                            "fileBytesFormat": extension(capturedFile.path),
                            "fileBytes": await convertFileToBase64(capturedFile),
                            //"fileBytes": "await convertFileToBase64(capturedFile)",
                          };
                          //before add check if already exit or not if exit then update that map otherwise add.
                          int finalObjIndex = credoPayController.finalDocsStepObjList.indexWhere((element) => element['param'] == name);
                          if (finalObjIndex != -1) {
                            credoPayController.finalDocsStepObjList[finalObjIndex] = {
                              "name": name,
                              "typeId": type,
                              "docNumber": type,
                              "fileUrl": "",
                              "fileName": basename(capturedFile.path),
                              "fileBytesFormat": extension(capturedFile.path),
                              "fileBytes": await convertFileToBase64(capturedFile),
                              //"fileBytes": "await convertFileToBase64(capturedFile)",
                            };
                          } else {
                            credoPayController.finalDocsStepObjList.add(object);
                          }
                        }
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  },
                  splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                  highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                  child: Text(
                    'Take photo',
                    style: TextHelper.size14.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.primaryColorBlue,
                    ),
                  ),
                ),
                width(4.w),
                InkWell(
                  onTap: () async {
                    await PermissionHandlerPermissionService.handlePhotosPermission(context).then(
                      (photoPermission) async {
                        if (photoPermission == true) {
                          Get.back();
                          try {
                            await openFilePicker(fileType: FileType.custom).then(
                              (pickedFile) async {
                                if (pickedFile != null && pickedFile.path != '' && pickedFile.path.isNotEmpty) {
                                  await convertFileToBase64(pickedFile).then(
                                    (base64Img) async {
                                      int fileSize = pickedFile.lengthSync();
                                      int maxAllowedSize = 6 * 1024 * 1024;
                                      if (fileSize > maxAllowedSize) {
                                        errorSnackBar(message: 'File size should be less than 6 MB');
                                      } else {
                                        credoPayController.kycDocumentsList[index].file.value = pickedFile;
                                        Map object = {
                                          "name": name,
                                          "typeId": type,
                                          "docNumber": type,
                                          "fileUrl": "",
                                          "fileName": basename(pickedFile.path),
                                          "fileBytesFormat": extension(pickedFile.path),
                                          "fileBytes": await convertFileToBase64(pickedFile),
                                          //"fileBytes": "await convertFileToBase64(capturedFile)",
                                        };
                                        //before add check if already exit or not if exit then update that map otherwise add.
                                        int finalObjIndex = credoPayController.finalDocsStepObjList.indexWhere((element) => element['param'] == name);
                                        if (finalObjIndex != -1) {
                                          credoPayController.finalDocsStepObjList[finalObjIndex] = {
                                            "name": name,
                                            "typeId": type,
                                            "docNumber": type,
                                            "fileUrl": "",
                                            "fileName": basename(pickedFile.path),
                                            "fileBytesFormat": extension(pickedFile.path),
                                            "fileBytes": await convertFileToBase64(pickedFile),
                                            //"fileBytes": "await convertFileToBase64(capturedFile)",
                                          };
                                        } else {
                                          credoPayController.finalDocsStepObjList.add(object);
                                        }
                                      }
                                      setState(() {});
                                    },
                                  );
                                }
                              },
                            );
                          } catch (e) {
                            if (kDebugMode) {
                              print("cc : $e");
                            }
                          }
                        }
                      },
                    );
                  },
                  splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                  highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                  child: Text(
                    'Choose from phone',
                    style: TextHelper.size14.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.primaryColorBlue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<String?> checkImageFormat(File file) async {
    try {
      // Read the first few bytes of the file
      List<int> bytes = await file.readAsBytes();

      // Check the magic bytes to determine the format
      if (isJPEG(bytes)) {
        return 'JPEG';
      } else if (isPNG(bytes)) {
        return 'PNG';
      } else {
        // Handle other formats if needed

        return 'Unsupported Format';
      }
    } catch (e) {
      // Handle exceptions, e.g., if the file is not accessible or not an image
      errorSnackBar(message: "$e");
      return 'Error: $e';
    }
  }

  bool isJPEG(List<int> bytes) {
    return bytes.length > 2 && bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF;
  }

  bool isPNG(List<int> bytes) {
    return bytes.length > 7 && bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47 && bytes[4] == 0x0D && bytes[5] == 0x0A && bytes[6] == 0x1A && bytes[7] == 0x0A;
  }

  Widget nextStep(StepEnabling enabling, context) {
    return CommonButton(
      shadowColor: ColorsForApp.whiteColor,
      bgColor: ColorsForApp.primaryColor,
      label: credoPayController.activeStep.value == 3 ? 'Submit' : 'Proceed',
      onPressed: () async {
        //if user on company details
        if (credoPayController.activeStep.value == 0 && companyFormKey.currentState!.validate()) {
          if (credoPayController.selectedBusinessType.value == "Select Business Type") {
            errorSnackBar(message: "please select Business type");
          } else if (!credoPayController.isPinCodeVerified.value) {
            errorSnackBar(message: 'please verify pincode');
          } else {
            credoPayController.activeStep.value = 1;
          }
        }

        // if user is on personal details
        else if (credoPayController.activeStep.value == 1 && personalDetailsFormKey.currentState!.validate()) {
          if (credoPayController.selectedTitle.value == "Select title") {
            errorSnackBar(message: 'please select title');
          } else if (credoPayController.selectedBankType.value == "Select bank type") {
            errorSnackBar(message: 'please select bank type');
          } else if (!credoPayController.isAccountVerified.value) {
            errorSnackBar(message: 'please verify account');
          } else {
            bool result = await credoPayController.merchantOnboardingAPI();
            if (result == true) {
              credoPayController.activeStep.value = 2;
              credoPayController.getKycDocuments(isLoaderShow: true, businessType: mAtmController.matmAuthDetailsModel.value.credo!.businessType!);
            }
          }
        } else if (credoPayController.activeStep.value == 2 && documentFormKey.currentState!.validate()) {
          if (validateDocuments()) {
            bool result = await credoPayController.uploadDocumentsApi(isLoaderShow: true, refNumber: mAtmController.matmAuthDetailsModel.value.credo!.refNumber!);
            if (result == true) {
              if (mAtmController.matmAuthDetailsModel.value.credo != null && (credoPayController.merchantStatus(mAtmController.matmAuthDetailsModel.value.credo!.merchantStatus!) == "Revision") ||
                  credoPayController.merchantStatus(mAtmController.matmAuthDetailsModel.value.credo!.merchantStatus!) == "ReferBack") {
                //calling submit api
                bool submitResult = await credoPayController.submitAPI();
                if (submitResult == true) {
                  Get.offAllNamed(Routes.RETAILER_DASHBOARD_SCREEN);
                }
              } else {
                callTerminalAPI();
                credoPayController.activeStep.value = 3;
              }
            }
          } else {
            errorSnackBar(message: 'Please upload All the required documents');
          }
        } else if (credoPayController.activeStep.value == 3 && terminalFormKey.currentState!.validate()) {
          showProgressIndicator();
          // calling terminal api
          bool result = await credoPayController.terminalOnboardingAPI();
          if (result == true) {
            //calling submit api
            bool submitResult = await credoPayController.submitAPI();
            if (submitResult == true) {
              Get.offAllNamed(Routes.RETAILER_DASHBOARD_SCREEN);
            }
          }
          dismissProgressIndicator();
        }
      },
      labelColor: ColorsForApp.whiteColor,
      width: 30.w,
    );
  }

  Widget cancelStep(StepEnabling enabling) {
    return CommonButton(
      shadowColor: ColorsForApp.whiteColor,
      bgColor: ColorsForApp.whiteColor,
      label: 'Cancel',
      border: Border.all(color: ColorsForApp.secondaryColor),
      onPressed: () async {
        if (credoPayController.activeStep > 0) {
          credoPayController.activeStep--;
        }
      },
      labelColor: ColorsForApp.secondaryColor,
      width: 30.w,
    );
  }

  bool validateDocuments() {
    // Implement your validation logic here
    for (var document in credoPayController.kycDocumentsList) {
      if (document.required && document.file.value.path.isEmpty) {
        // A required document is missing
        return false;
      }
    }
    // All required documents are uploaded
    return true;
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/onboarding/fingpay_controller.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/aeps/verify_status_model.dart';
import '../../../../../model/auth/cities_model.dart';
import '../../../../../model/auth/states_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field_with_title.dart';

class FingpayOnboardingScreen extends StatefulWidget {
  const FingpayOnboardingScreen({Key? key}) : super(key: key);

  @override
  State<FingpayOnboardingScreen> createState() => _FingpayOnboardingScreenState();
}

class _FingpayOnboardingScreenState extends State<FingpayOnboardingScreen> {
  final FingpayController fingpayController = Get.find();
  OTPInteractor otpInTractor = OTPInteractor();
  UserData userData = Get.arguments;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fingpayController.setOnboardingData(userData);
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await fingpayController.getStatesAPI();
      initController();
      //  await fingpayController.getCitiesAPI(isLoaderShow: false);
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  Future<void> initController() async {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          fingpayController.autoReadOtp.value = code;
          fingpayController.enteredOTP.value = code;
          Get.log('\x1B[97m[OTP] => ${fingpayController.enteredOTP.value}\x1B[0m');
        },
        otpInteractor: otpInTractor,
      ).startListenUserConsent((code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: false);
        fingpayController.clearOnboardingVariables();
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
                      'Fingpay Onboarding',
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
        mainBody: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   height: 4.5.h,
            //   width: 100.w,
            //   child: ListView.separated(
            //     scrollDirection: Axis.horizontal,
            //     physics: const BouncingScrollPhysics(),
            //     padding: EdgeInsets.symmetric(horizontal: 0.w),
            //     itemCount: fingpayController.onboardSteps.length,
            //     itemBuilder: (context, index) {
            //       return Obx(
            //         () => Padding(
            //           padding: index == 0
            //               ? EdgeInsets.only(left: 2.w)
            //               : index == fingpayController.onboardSteps.length - 1
            //                   ? EdgeInsets.only(right: 2.w)
            //                   : EdgeInsets.zero,
            //           child: GestureDetector(
            //             onTap: () async {
            //               fingpayController.selectedIndex.value = index;
            //             },
            //             child: ClipRRect(
            //               borderRadius: BorderRadius.circular(10),
            //               child: Container(
            //                 constraints: BoxConstraints(minWidth: 30.w),
            //                 padding: const EdgeInsets.symmetric(horizontal: 15),
            //                 decoration: BoxDecoration(
            //                   gradient: LinearGradient(
            //                     begin: const Alignment(-0.0, -0.7),
            //                     end: const Alignment(0, 1),
            //                     colors: fingpayController.selectedIndex.value == index
            //                         ? [
            //                             ColorsForApp.whiteColor,
            //                             ColorsForApp.selectedTabBackgroundColor,
            //                           ]
            //                         : [
            //                             ColorsForApp.whiteColor,
            //                             ColorsForApp.whiteColor,
            //                           ],
            //                   ),
            //                   color: fingpayController.selectedIndex.value == index ? ColorsForApp.selectedTabBgColor : ColorsForApp.whiteColor,
            //                   border: Border(
            //                     bottom: BorderSide(
            //                       color: fingpayController.selectedIndex.value == index ? ColorsForApp.primaryColor : ColorsForApp.accentColor,
            //                       width: 2,
            //                     ),
            //                   ),
            //                 ),
            //                 alignment: Alignment.center,
            //                 child: Text(
            //                   fingpayController.onboardSteps[index].toString(),
            //                   style: TextHelper.size15.copyWith(
            //                     color: ColorsForApp.primaryColor,
            //                     fontWeight: fingpayController.selectedIndex.value == index ? FontWeight.w500 : FontWeight.w400,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //     separatorBuilder: (BuildContext context, int index) {
            //       return width(2.w);
            //     },
            //   ),
            // ),
            Obx(
              () => Visibility(
                visible: fingpayController.selectedIndex.value == 0 ? true : false,
                child: personalDetails(),
              ),
            ),
            Visibility(
              visible: fingpayController.selectedIndex.value == 1 ? true : false,
              child: Container(),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
          child: CommonButton(
            label: 'Proceed',
            onPressed: () async {
              // Unfocus text-field
              FocusScope.of(context).unfocus();
              if (Get.isSnackbarOpen) {
                Get.back();
              }
              if (formKey.currentState!.validate()) {
                await fingpayController.fingpayOnboardingApi();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget personalDetails() {
    return Expanded(
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              // Name
              CustomTextFieldWithTitle(
                controller: fingpayController.nameController,
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
                  if (fingpayController.nameController.text.trim().isEmpty) {
                    return 'Please enter name';
                  } else if (fingpayController.nameController.text.length < 3) {
                    return 'Please enter valid name';
                  }
                  return null;
                },
              ),
              // Mobile number
              CustomTextFieldWithTitle(
                controller: fingpayController.mobileNumberController,
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
                  if (fingpayController.mobileNumberController.text.trim().isEmpty) {
                    return 'Please enter mobile number';
                  } else if (fingpayController.mobileNumberController.text.length < 10) {
                    return 'Please enter valid mobile number';
                  }
                  return null;
                },
              ),
              // Email
              CustomTextFieldWithTitle(
                controller: fingpayController.emailController,
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
                  if (fingpayController.emailController.text.trim().isEmpty) {
                    return 'Please enter email';
                  } else if (!GetUtils.isEmail(fingpayController.emailController.text.trim())) {
                    return 'Please enter valid email';
                  }
                  return null;
                },
              ),
              // Aadhar number
              CustomTextFieldWithTitle(
                controller: fingpayController.aadharNumberController,
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
                  if (fingpayController.aadharNumberController.text.trim().isEmpty) {
                    return 'Please enter aadhaar number';
                  } else if (!aadharRegex.hasMatch(fingpayController.aadharNumberController.text.trim())) {
                    return 'Please enter valid aadhaar number';
                  }
                  return null;
                },
              ),
              // Pan number
              CustomTextFieldWithTitle(
                controller: fingpayController.panNumberController,
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
                  if (fingpayController.panNumberController.text.trim().isEmpty) {
                    return 'Please enter pan number';
                  } else if (!panRegex.hasMatch(fingpayController.panNumberController.text.trim())) {
                    return 'Please enter valid pan number';
                  }
                  return null;
                },
              ),
              // Pin code
              CustomTextFieldWithTitle(
                controller: fingpayController.pinCodeController,
                title: 'Pincode',
                hintText: 'Enter pincode',
                maxLength: 6,
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                suffixIcon: Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                ),
                onChange: (value) async {
                  if (value!.isNotEmpty && value.length >= 6) {
                    bool result = await fingpayController.getStateCityBlockAPI(pinCode: fingpayController.pinCodeController.text);
                    if (result == true) {
                      fingpayController.stateNameController.text = fingpayController.getCityStateBlockData.value.data!.stateName!.toString();
                      fingpayController.selectedStateId.value = fingpayController.getCityStateBlockData.value.data!.stateID!.toString();
                      fingpayController.cityNameController.text = fingpayController.getCityStateBlockData.value.data!.cityName!.toString();
                    }
                  }
                },
                validator: (value) {
                  if (fingpayController.pinCodeController.text.trim().isEmpty) {
                    return 'Please enter pincode';
                  }
                  return null;
                },
              ),
              // State
              CustomTextFieldWithTitle(
                controller: fingpayController.stateNameController,
                title: 'State',
                hintText: 'Select state',
                readOnly: true,
                isCompulsory: true,
                textInputAction: TextInputAction.next,
                suffixIcon: Icon(
                  Icons.chevron_right_rounded,
                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                ),
                onTap: () async {
                  StatesModel selectedState = await Get.toNamed(
                    Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                    arguments: [
                      fingpayController.statesList, // modelList
                      'statesList', // modelName
                    ],
                  );
                  if (selectedState.name != null && selectedState.name!.isNotEmpty && selectedState.id != null) {
                    fingpayController.stateNameController.text = selectedState.name!.toString();
                    fingpayController.selectedStateId.value = selectedState.id!.toString();
                  }
                },
                validator: (value) {
                  if (fingpayController.stateNameController.text.trim().isEmpty) {
                    return 'Please select state';
                  }
                  return null;
                },
              ),
              // District
              CustomTextFieldWithTitle(
                controller: fingpayController.districtController,
                title: 'District',
                hintText: 'Enter district',
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                ],
                suffixIcon: Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                ),
                validator: (value) {
                  if (fingpayController.districtController.text.trim().isEmpty) {
                    return 'Please enter district';
                  }
                  return null;
                },
              ),
              // City
              CustomTextFieldWithTitle(
                controller: fingpayController.cityNameController,
                title: 'City',
                hintText: 'Enter city',
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                ],
                suffixIcon: Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                ),
                validator: (value) {
                  if (fingpayController.cityNameController.text.trim().isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
              // Address
              CustomTextFieldWithTitle(
                controller: fingpayController.addressController,
                title: 'Address',
                hintText: 'Enter address',
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.words,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                ],
                suffixIcon: Icon(
                  Icons.home_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                ),
                validator: (value) {
                  if (fingpayController.addressController.text.trim().isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget otherDetails() {
    return Expanded(
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: Column(
            children: [
              // Name
              CustomTextFieldWithTitle(
                controller: fingpayController.nameController,
                title: 'Name',
                hintText: 'Enter name',
                maxLength: 200,
                isCompulsory: true,
                readOnly: userData.name != null ? true : false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                textInputFormatter: [
                  FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (userData.name == null) {
                    if (fingpayController.nameController.text.trim().isEmpty) {
                      return 'Please enter name number';
                    } else if (fingpayController.nameController.text.length < 3) {
                      return 'Please enter valid name';
                    }
                    return null;
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
                controller: fingpayController.mobileNumberController,
                title: 'Mobile Number',
                hintText: 'Enter mobile number',
                maxLength: 10,
                isCompulsory: true,
                readOnly: userData.mobileNo != null ? true : false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (userData.mobileNo == null) {
                    if (fingpayController.mobileNumberController.text.trim().isEmpty) {
                      return 'Please enter mobile number';
                    } else if (fingpayController.mobileNumberController.text.length < 10) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
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
                controller: fingpayController.emailController,
                title: 'Email',
                hintText: 'Enter email',
                isCompulsory: true,
                readOnly: userData.email != null ? true : false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (userData.email == null) {
                    if (fingpayController.emailController.text.trim().isEmpty) {
                      return 'Please enter email';
                    } else if (!GetUtils.isEmail(fingpayController.emailController.text.trim())) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.email,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              // Aadhar number
              CustomTextFieldWithTitle(
                controller: fingpayController.aadharNumberController,
                title: 'Aadhar Number',
                hintText: 'Enter aadhar number',
                isCompulsory: true,
                readOnly: userData.mobileNo != null ? true : false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (userData.email == null) {
                    RegExp aadharRegex = RegExp(r'^[2-9]\d{11}$');
                    if (fingpayController.aadharNumberController.text.trim().isEmpty) {
                      return 'Please enter aadhar number';
                    } else if (!aadharRegex.hasMatch(fingpayController.aadharNumberController.text.trim())) {
                      return 'Please enter valid aadhar number';
                    }
                    return null;
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.person,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              // Pan number
              CustomTextFieldWithTitle(
                controller: fingpayController.panNumberController,
                title: 'Pan Number',
                hintText: 'Enter pan number',
                isCompulsory: true,
                readOnly: userData.panCard != null ? true : false,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (userData.email == null) {
                    RegExp panRegex = RegExp(r'^[A-Z]{5}\d{4}[A-Z]$');
                    if (fingpayController.panNumberController.text.trim().isEmpty) {
                      return 'Please enter pan number';
                    } else if (!panRegex.hasMatch(fingpayController.panNumberController.text.trim())) {
                      return 'Please enter valid pan number';
                    }
                    return null;
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.person,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              // State
              CustomTextFieldWithTitle(
                controller: fingpayController.stateNameController,
                title: 'State',
                hintText: 'Enter state',
                isCompulsory: true,
                readOnly: userData.stateName != null ? true : false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (userData.stateName == null) {
                    if (fingpayController.stateNameController.text.trim().isEmpty) {
                      return 'Please enter state';
                    }
                    return null;
                  }
                  return null;
                },
                onTap: () async {
                  StatesModel selectedState = await Get.toNamed(
                    Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                    arguments: [
                      fingpayController.statesList, // modelList
                      'statesList', // modelName
                    ],
                  );
                  if (selectedState.name != null && selectedState.name!.isNotEmpty) {
                    fingpayController.stateNameController.text = selectedState.name!;
                    fingpayController.selectedStateId.value = selectedState.id!.toString();
                  }
                },
                suffixIcon: Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              // District
              CustomTextFieldWithTitle(
                controller: fingpayController.districtController,
                title: 'District',
                hintText: 'Enter district',
                isCompulsory: true,
                readOnly: userData.district != null ? true : false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (userData.district == null) {
                    if (fingpayController.districtController.text.trim().isEmpty) {
                      return 'Please enter district';
                    }
                    return null;
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              // City
              CustomTextFieldWithTitle(
                controller: fingpayController.cityNameController,
                title: 'City',
                hintText: 'Enter city',
                isCompulsory: true,
                readOnly: userData.cityName != null ? true : false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (userData.cityName == null) {
                    if (fingpayController.cityNameController.text.trim().isEmpty) {
                      return 'Please enter city';
                    }
                    return null;
                  }
                  return null;
                },
                onChange: (value) async {
                  if (fingpayController.getCityStateBlockData.value.data!.cityName!.isNotEmpty && fingpayController.getCityStateBlockData.value.data!.cityName != null) {
                    CitiesModel selectedCity = await Get.toNamed(
                      Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                      arguments: [
                        fingpayController.citiesList, // modelList
                        'citiesList', // modelName
                      ],
                    );
                    if (selectedCity.name != null && selectedCity.name!.isNotEmpty) {
                      fingpayController.stateNameController.text = selectedCity.name!;
                      fingpayController.selectedStateId.value = selectedCity.id!.toString();
                    }
                  }
                },
                suffixIcon: Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              // Pin code
              CustomTextFieldWithTitle(
                controller: fingpayController.pinCodeController,
                title: 'Pincode',
                hintText: 'Enter pincode',
                maxLength: 6,
                isCompulsory: true,
                readOnly: userData.pinCode != null ? true : false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                onChange: (value) async {
                  if (value!.isNotEmpty && value.length >= 6) {
                    bool result = await fingpayController.getStateCityBlockAPI(isLoaderShow: true, pinCode: fingpayController.pinCodeController.text);
                    if (result == true) {
                      fingpayController.stateNameController.text = fingpayController.getCityStateBlockData.value.data!.stateName!;
                      fingpayController.cityNameController.text = fingpayController.getCityStateBlockData.value.data!.cityName!;
                    }
                  }
                },
                validator: (value) {
                  if (userData.pinCode == null) {
                    if (fingpayController.pinCodeController.text.trim().isEmpty) {
                      return 'Please enter pincode';
                    }
                    return null;
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
              // Address
              CustomTextFieldWithTitle(
                controller: fingpayController.addressController,
                title: 'Address',
                hintText: 'Enter address',
                isCompulsory: true,
                readOnly: userData.address != null ? true : false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (userData.address == null) {
                    if (fingpayController.addressController.text.trim().isEmpty) {
                      return 'Please enter address';
                    }
                    return null;
                  }
                  return null;
                },
                suffixIcon: Icon(
                  Icons.house,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

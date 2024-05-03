import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../controller/auth_controller.dart';
import '../../generated/assets.dart';
import '../../model/auth/adress_by_pincode_model.dart';
import '../../model/auth/block_model.dart';
import '../../model/auth/states_model.dart';
import '../../model/auth/cities_model.dart';
import '../../model/auth/signup_steps_model.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';
import '../../widgets/base_dropdown.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/otp_text_field.dart';
import '../../widgets/text_field_with_title.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthController authController = Get.find();
  OTPInteractor otpInTractor = OTPInteractor();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
    initController();
  }

  Future<void> callAsyncApi() async {
    showProgressIndicator();
    await authController.getEntityType(isLoaderShow: false);
    await authController.getUserType(isLoaderShow: false);
    await authController.getCitiesAPI(isLoaderShow: false);
    await authController.getStatesAPI(isLoaderShow: false);
    dismissProgressIndicator();
  }

  Future<void> initController() async {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          authController.mobileOtp.value = code;
          authController.autoReadOtp.value = code;
        },
        otpInteractor: otpInTractor,
      ).startListenUserConsent((code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      });
    }
  }

  @override
  void dispose() {
    authController.clearSignUpVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 10.h,
      title: 'Personal Details',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        height: 10.h,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage(Assets.imagesLaptopIcon),
            fit: BoxFit.contain,
            alignment: Alignment.centerRight,
          ),
        ),
        child: Obx(
          () => authController.widgetId.value == 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    width(4.w),
                    Lottie.asset(
                      Assets.animationsAddUserAnimation,
                      fit: BoxFit.contain,
                    )
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Type: ',
                          style: TextHelper.size13.copyWith(
                            fontFamily: boldGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                        width(5),
                        Expanded(
                          child: Text(
                            authController.selectedUserType.value,
                            style: TextHelper.size13.copyWith(
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    height(1.h),
                    // Entity type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Entity Type: ',
                          style: TextHelper.size13.copyWith(
                            fontFamily: boldGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                        width(5),
                        Expanded(
                          child: Text(
                            authController.selectedEntityType.value,
                            style: TextHelper.size13.copyWith(
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
      mainBody: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          // reverseDuration: const Duration(seconds: 1),
          switchInCurve: Curves.fastOutSlowIn,
          switchOutCurve: Curves.fastOutSlowIn,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
            return currentChild ?? Container();
          },
          child: authController.widgetId.value == 1 ? signUpView() : personalDetailsView(),
        ),
      ),
    );
  }

  Widget signUpView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          height(2.h),
          Obx(
            () => BaseDropDown(
              value: authController.selectedUserType.value.isEmpty ? null : authController.selectedUserType.value,
              options: authController.userTypeList.map(
                (element) {
                  return element.name;
                },
              ).toList(),
              hintText: 'Select user type',
              onChanged: (value) async {
                authController.selectedUserType.value = value!;
                if (authController.selectedUserType.value != 'Select user type') {
                  authController.selectedUserTypeId.value = authController.userTypeList.firstWhere((element) => element.name == authController.selectedUserType.value).id.toString();
                }
                debugPrint(authController.selectedUserTypeId.toString());
              },
            ),
          ),
          height(2.h),
          Obx(
            () => BaseDropDown(
              value: authController.selectedEntityType.value.isEmpty ? null : authController.selectedEntityType.value,
              options: authController.entityTypeList.map(
                (element) {
                  return element.name;
                },
              ).toList(),
              hintText: 'Select entity type',
              onChanged: (value) async {
                authController.selectedEntityType.value = value!;
                if (authController.selectedEntityType.value != 'Select entity type') {
                  authController.selectedEntityTypeId.value = authController.entityTypeList.firstWhere((element) => element.name == authController.selectedEntityType.value).id.toString();
                }
                debugPrint(authController.selectedEntityTypeId.toString());
              },
            ),
          ),
          height(3.h),
          CommonButton(
            bgColor: ColorsForApp.primaryColor,
            label: 'Continue',
            onPressed: () async {
              if (authController.selectedEntityType.value == 'Select entity type') {
                errorSnackBar(message: 'Please select entity type');
              } else if (authController.selectedUserType.value == 'Select user type') {
                errorSnackBar(message: 'Please select user type');
              } else {
                bool result = await authController.getSignUpSteps();
                if (result == true) {
                  authController.updateRender();
                }
              }
            },
            labelColor: ColorsForApp.whiteColor,
            width: 100.w,
          ),
        ],
      ),
    );
  }

  Widget personalDetailsView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          height(2.h),
          Expanded(
            child: Form(
              key: authController.signUpFormKey,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: authController.signUpStepList.length,
                itemBuilder: (context, index) {
                  if (authController.signUpStepList[index].fieldName != 'usertype' &&
                      authController.signUpStepList[index].fieldName != 'entityType' &&
                      authController.signUpStepList[index].fieldName != 'Parent' &&
                      authController.signUpStepList[index].fieldName != 'profileid' &&
                      authController.signUpStepList[index].fieldName != 'Country') {
                    if (authController.signUpStepList[index].fieldType == 'text') {
                      return Obx(
                        () => CustomTextFieldWithTitle(
                          title: authController.signUpStepList[index].label,
                          isCompulsory: authController.signUpStepList[index].isMandatory,
                          controller: authController.signUpStepList[index].textEditingController,
                          hintText: authController.signUpStepList[index].label!,
                          maxLength: authController.signUpStepList[index].maxLength,
                          readOnly: authController.signUpStepList[index].fieldName == 'mobileNo' && authController.mobileVerified.value == true
                              ? true
                              : authController.signUpStepList[index].fieldName == 'email' && authController.emailVerified.value == true
                                  ? true
                                  : false,
                          suffixIcon: authController.signUpStepList[index].isVerified == true
                              ? GestureDetector(
                                  onTap: () async {
                                    if (authController.signUpStepList[index].fieldName == 'mobileNo' && authController.signUpStepList[index].isValidField == true && authController.signUpStepList[index].textEditingController!.text.isNotEmpty) {
                                      if (authController.signUpStepList[index].fieldName == 'mobileNo' && authController.mobileVerified.value == false) {
                                        bool result = await authController.generateMobileOtp(mobileNumber: authController.signUpStepList[index].textEditingController!.text);
                                        if (result == true) {
                                          if (context.mounted) {
                                            otpVerifyMobileDialog(context);
                                          }
                                        }
                                      }
                                    }
                                    if (authController.signUpStepList[index].fieldName == 'email' && authController.signUpStepList[index].isValidField == true && authController.signUpStepList[index].textEditingController!.text.isNotEmpty) {
                                      if (authController.signUpStepList[index].fieldName == 'email' && authController.emailVerified.value == false) {
                                        bool result = await authController.generateEmailOtp(emailId: authController.signUpStepList[index].textEditingController!.text);
                                        if (result == true) {
                                          if (context.mounted) {
                                            otpVerifyEmailDialog(context);
                                          }
                                        }
                                      }
                                    }
                                  },
                                  child: Obx(
                                    () => Container(
                                      width: 8.h,
                                      decoration: BoxDecoration(
                                        color: authController.emailVerified.value == true && authController.signUpStepList[index].fieldName == 'email' ||
                                                authController.mobileVerified.value == true && authController.signUpStepList[index].fieldName == 'mobileNo'
                                            ? ColorsForApp.successColor.withOpacity(0.1)
                                            : ColorsForApp.blueShade22,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(5),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(5),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: authController.emailVerified.value == true && authController.signUpStepList[index].fieldName == 'email'
                                          ? Text(
                                              'Verified',
                                              style: TextHelper.size13.copyWith(
                                                color: ColorsForApp.successColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : authController.mobileVerified.value == true && authController.signUpStepList[index].fieldName == 'mobileNo'
                                              ? Text(
                                                  'Verified',
                                                  style: TextHelper.size13.copyWith(
                                                    color: ColorsForApp.successColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  'Verify',
                                                  style: TextHelper.size13.copyWith(
                                                    color: ColorsForApp.primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          keyboardType: TextInputType.text,
                          onChange: (value) async {
                            if (authController.signUpStepList[index].fieldName == 'Pincode') {
                              if (value!.length >= 6) {
                                bool result = await authController.getStateCityBlockAPI(isLoaderShow: true, pinCode: authController.signUpStepList[index].textEditingController!.text);
                                if (result == true) {
                                  for (SignUpFields element in authController.signUpStepList) {
                                    if (element.fieldName == 'Pincode') {
                                      element.textEditingController!.text = value;
                                      Map object = {
                                        'stepID': element.stepID.toString(),
                                        'rank': element.rank.toString(),
                                        'param': element.fieldName.toString(),
                                        'value': value,
                                        'fileBytes': '',
                                        'fileBytesFormat': '',
                                        'channel': channelID,
                                      };
                                      //before add check if already exit or not if exit then update that map otherwise add.
                                      int finalObjIndex = authController.finalSingStepList.indexWhere((foundElement) => foundElement['param'] == element.fieldName.toString());
                                      if (finalObjIndex != -1) {
                                        authController.finalSingStepList[finalObjIndex] = {
                                          'stepID': element.stepID.toString(),
                                          'rank': element.rank.toString(),
                                          'param': element.fieldName.toString(),
                                          'value': element.textEditingController!.text,
                                          'fileBytes': '',
                                          'fileBytesFormat': '',
                                          'channel': channelID,
                                        };
                                      } else {
                                        authController.finalSingStepList.add(object);
                                      }
                                    } else if (element.groupType == 'state') {
                                      element.textEditingController!.text = authController.getCityStateBlockData.value.data!.stateName!;
                                      Map object = {
                                        'stepID': element.stepID.toString(),
                                        'rank': element.rank.toString(),
                                        'param': element.fieldName.toString(),
                                        'text': element.textEditingController!.text,
                                        'value': authController.getCityStateBlockData.value.data!.stateID!.toString(),
                                        'fileBytes': '',
                                        'fileBytesFormat': '',
                                        'channel': channelID,
                                      };
                                      //before add check if already exit or not if exit then update that map otherwise add.
                                      int finalObjIndex = authController.finalSingStepList.indexWhere((foundElement) => foundElement['param'] == element.fieldName.toString());
                                      if (finalObjIndex != -1) {
                                        authController.finalSingStepList[finalObjIndex] = {
                                          'stepID': element.stepID.toString(),
                                          'rank': element.rank.toString(),
                                          'param': element.fieldName.toString(),
                                          'text': element.textEditingController!.text,
                                          'value': authController.getCityStateBlockData.value.data!.stateID!.toString(),
                                          'fileBytes': '',
                                          'fileBytesFormat': '',
                                          'channel': channelID,
                                        };
                                      } else {
                                        authController.finalSingStepList.add(object);
                                      }
                                    }
                                    if (element.groupType == 'city') {
                                      element.textEditingController!.text = authController.getCityStateBlockData.value.data!.cityName!;
                                      Map object = {
                                        'stepID': element.stepID.toString(),
                                        'rank': element.rank.toString(),
                                        'param': element.fieldName.toString(),
                                        'text': element.textEditingController!.text,
                                        'value': authController.getCityStateBlockData.value.data!.cityID!.toString(),
                                        'fileBytes': '',
                                        'fileBytesFormat': '',
                                        'channel': channelID,
                                      };
                                      //before add check if already exit or not if exit then update that map otherwise add.
                                      int finalObjIndex = authController.finalSingStepList.indexWhere((foundElement) => foundElement['param'] == element.fieldName.toString());
                                      if (finalObjIndex != -1) {
                                        authController.finalSingStepList[finalObjIndex] = {
                                          'stepID': element.stepID.toString(),
                                          'rank': element.rank.toString(),
                                          'param': element.fieldName.toString(),
                                          'text': element.textEditingController!.text,
                                          'value': authController.getCityStateBlockData.value.data!.cityID!.toString(),
                                          'fileBytes': '',
                                          'fileBytesFormat': '',
                                          'channel': channelID,
                                        };
                                      } else {
                                        authController.finalSingStepList.add(object);
                                      }
                                    }
                                    if (element.groupType == 'block') {
                                      element.textEditingController!.text = authController.getCityStateBlockData.value.data!.blockName!;
                                      Map object = {
                                        'stepID': element.stepID.toString(),
                                        'rank': element.rank.toString(),
                                        'param': element.fieldName.toString(),
                                        'text': element.textEditingController!.text,
                                        'value': authController.getCityStateBlockData.value.data!.blockID!.toString(),
                                        'fileBytes': '',
                                        'fileBytesFormat': '',
                                        'channel': channelID,
                                      };
                                      //before add check if already exit or not if exit then update that map otherwise add.
                                      int finalObjIndex = authController.finalSingStepList.indexWhere((foundElement) => foundElement['param'] == element.fieldName.toString());
                                      if (finalObjIndex != -1) {
                                        authController.finalSingStepList[finalObjIndex] = {
                                          'stepID': element.stepID.toString(),
                                          'rank': element.rank.toString(),
                                          'param': element.fieldName.toString(),
                                          'text': element.textEditingController!.text,
                                          'value': authController.getCityStateBlockData.value.data!.blockID!.toString(),
                                          'fileBytes': '',
                                          'fileBytesFormat': '',
                                          'channel': channelID,
                                        };
                                      } else {
                                        authController.finalSingStepList.add(object);
                                      }
                                    }
                                  }
                                } else {
                                  //If data not found rest state,city,block
                                  authController.getCityStateBlockData.value.data = StateCityBlockDataModel();
                                  for (SignUpFields element in authController.signUpStepList) {
                                    if (element.groupType == 'state') {
                                      authController.getCityStateBlockData.value.data!.stateName = null;
                                      authController.getCityStateBlockData.value.data!.stateID = null;
                                      element.textEditingController!.clear();
                                    }
                                    if (element.groupType == 'city') {
                                      authController.getCityStateBlockData.value.data!.cityName = null;
                                      authController.getCityStateBlockData.value.data!.cityID = null;
                                      element.textEditingController!.clear();
                                    }
                                    if (element.groupType == 'block') {
                                      authController.getCityStateBlockData.value.data!.blockName = null;
                                      authController.getCityStateBlockData.value.data!.blockID = null;
                                      element.textEditingController!.clear();
                                    }
                                  }
                                }
                              }
                            } else {
                              Map object = {
                                'stepID': authController.signUpStepList[index].stepID.toString(),
                                'rank': authController.signUpStepList[index].rank.toString(),
                                'param': authController.signUpStepList[index].fieldName.toString(),
                                'value': authController.signUpStepList[index].textEditingController!.text,
                                'fileBytes': '',
                                'fileBytesFormat': '',
                                'channel': channelID,
                              };
                              //before add check if already exit or not if exit then update that map otherwise add.
                              int finalObjIndex = authController.finalSingStepList.indexWhere((element) => element['param'] == authController.signUpStepList[index].fieldName.toString());
                              if (finalObjIndex != -1) {
                                authController.finalSingStepList[finalObjIndex] = {
                                  'stepID': authController.signUpStepList[index].stepID.toString(),
                                  'rank': authController.signUpStepList[index].rank.toString(),
                                  'param': authController.signUpStepList[index].fieldName.toString(),
                                  'value': authController.signUpStepList[index].textEditingController!.text,
                                  'fileBytes': '',
                                  'fileBytesFormat': '',
                                  'channel': channelID,
                                };
                              } else {
                                authController.finalSingStepList.add(object);
                              }
                            }
                          },
                          validator: (value) {
                            if (authController.signUpStepList[index].isMandatory == true) {
                              if (authController.signUpStepList[index].textEditingController!.text.trim().isEmpty) {
                                return 'Please enter ${authController.signUpStepList[index].label}';
                              } else if (authController.signUpStepList[index].regex != null && authController.signUpStepList[index].regex!.isNotEmpty) {
                                RegExp nameRegex = RegExp(authController.signUpStepList[index].regex!);
                                bool isRegexMatch = nameRegex.hasMatch(authController.signUpStepList[index].textEditingController!.text.trim());
                                if (isRegexMatch == true) {
                                  authController.signUpStepList[index].isValidField = true;
                                  return null;
                                } else {
                                  authController.signUpStepList[index].isValidField = false;
                                  return 'Please enter valid ${authController.signUpStepList[index].label}';
                                }
                              }
                              return null;
                            }
                            return null;
                          },
                        ),
                      );
                    } else if (authController.signUpStepList[index].fieldType == 'dropdown') {
                      return CustomTextFieldWithTitle(
                        controller: authController.signUpStepList[index].textEditingController,
                        title: authController.signUpStepList[index].label,
                        hintText: authController.signUpStepList[index].label,
                        isCompulsory: authController.signUpStepList[index].isMandatory,
                        readOnly: true,
                        onTap: () async {
                          //Check If we got state ,city,block from pinCode then dropdown should be disable

                          if (authController.signUpStepList[index].groupType == 'state' &&
                              authController.getCityStateBlockData.value.data != null &&
                              authController.getCityStateBlockData.value.data!.stateName != null &&
                              authController.getCityStateBlockData.value.data!.stateName!.isNotEmpty) {
                          } else if (authController.signUpStepList[index].groupType == 'city' &&
                              authController.getCityStateBlockData.value.data != null &&
                              authController.getCityStateBlockData.value.data!.cityName != null &&
                              authController.getCityStateBlockData.value.data!.cityName!.isNotEmpty) {
                          } else if (authController.signUpStepList[index].groupType == 'block' &&
                              authController.getCityStateBlockData.value.data != null &&
                              authController.getCityStateBlockData.value.data!.blockName != null &&
                              authController.getCityStateBlockData.value.data!.blockName!.isNotEmpty) {
                          } else {
                            if (authController.signUpStepList[index].groupType == 'state') {
                              StatesModel selectedState = await Get.toNamed(
                                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                                arguments: [
                                  authController.statesList, // modelList
                                  'statesList', // modelName
                                ],
                              );
                              if (selectedState.name != null && selectedState.name!.isNotEmpty) {
                                authController.signUpStepList[index].textEditingController!.text = selectedState.name!;
                                authController.selectedStateId.value = selectedState.id!.toString();
                                Map object = {
                                  'stepID': authController.signUpStepList[index].stepID.toString(),
                                  'rank': authController.signUpStepList[index].rank.toString(),
                                  'param': authController.signUpStepList[index].fieldName.toString(),
                                  'text': authController.signUpStepList[index].textEditingController!.text,
                                  'value': authController.selectedStateId.value,
                                  'fileBytes': '',
                                  'fileBytesFormat': '',
                                  'channel': channelID,
                                };
                                //before add check if already exit or not if exit then update that map otherwise add.
                                int finalObjIndex = authController.finalSingStepList.indexWhere((element) => element['param'] == authController.signUpStepList[index].fieldName.toString());
                                if (finalObjIndex != -1) {
                                  authController.finalSingStepList[finalObjIndex] = {
                                    'stepID': authController.signUpStepList[index].stepID.toString(),
                                    'rank': authController.signUpStepList[index].rank.toString(),
                                    'param': authController.signUpStepList[index].fieldName.toString(),
                                    'text': authController.signUpStepList[index].textEditingController!.text,
                                    'value': authController.selectedStateId.value,
                                    'fileBytes': '',
                                    'fileBytesFormat': '',
                                    'channel': channelID,
                                  };
                                } else {
                                  authController.finalSingStepList.add(object);
                                }
                                for (var element in authController.signUpStepList) {
                                  if (element.groupType == 'city' && element.textEditingController!.text.isNotEmpty) {
                                    element.textEditingController!.clear();
                                  }
                                  if (element.groupType == 'block' && element.textEditingController!.text.isNotEmpty) {
                                    element.textEditingController!.clear();
                                  }
                                }
                                await authController.getCitiesAPI(isLoaderShow: true);
                              }
                            } else if (authController.signUpStepList[index].groupType == 'city') {
                              authController.signUpStepList[index].textEditingController!.clear();
                              CitiesModel selectedCity = await Get.toNamed(
                                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                                arguments: [
                                  authController.citiesList, // modelList
                                  'citiesList', // modelName
                                ],
                              );
                              if (selectedCity.name != null && selectedCity.name!.isNotEmpty) {
                                authController.signUpStepList[index].textEditingController!.text = selectedCity.name!;
                                authController.selectedCityId.value = selectedCity.id!.toString();
                                Map object = {
                                  'stepID': authController.signUpStepList[index].stepID.toString(),
                                  'rank': authController.signUpStepList[index].rank.toString(),
                                  'param': authController.signUpStepList[index].fieldName.toString(),
                                  'text': authController.signUpStepList[index].textEditingController!.text,
                                  'value': authController.selectedCityId.value,
                                  'fileBytes': '',
                                  'fileBytesFormat': '',
                                  'channel': channelID,
                                };
                                //before add check if already exit or not if exit then update that map otherwise add.
                                int finalObjIndex = authController.finalSingStepList.indexWhere((element) => element['param'] == authController.signUpStepList[index].fieldName.toString());
                                if (finalObjIndex != -1) {
                                  authController.finalSingStepList[finalObjIndex] = {
                                    'stepID': authController.signUpStepList[index].stepID.toString(),
                                    'rank': authController.signUpStepList[index].rank.toString(),
                                    'param': authController.signUpStepList[index].fieldName.toString(),
                                    'text': authController.signUpStepList[index].textEditingController!.text,
                                    'value': authController.selectedCityId.value,
                                    'fileBytes': '',
                                    'fileBytesFormat': '',
                                    'channel': channelID,
                                  };
                                } else {
                                  authController.finalSingStepList.add(object);
                                }
                                for (var element in authController.signUpStepList) {
                                  if (element.groupType == 'block' && element.textEditingController!.text.isNotEmpty) {
                                    element.textEditingController!.clear();
                                  }
                                }
                                await authController.getBlockAPI(isLoaderShow: true);
                              }
                            } else if (authController.signUpStepList[index].groupType == 'block') {
                              authController.signUpStepList[index].textEditingController!.clear();
                              BlockModel selectedBlock = await Get.toNamed(
                                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                                arguments: [
                                  authController.blockList, // modelList
                                  'blockList', // modelName
                                ],
                              );
                              if (selectedBlock.name != null && selectedBlock.name!.isNotEmpty) {
                                authController.signUpStepList[index].textEditingController!.text = selectedBlock.name!;
                                authController.selectedBlockId.value = selectedBlock.id!.toString();
                                Map object = {
                                  'stepID': authController.signUpStepList[index].stepID.toString(),
                                  'rank': authController.signUpStepList[index].rank.toString(),
                                  'param': authController.signUpStepList[index].fieldName.toString(),
                                  'text': authController.signUpStepList[index].textEditingController!.text,
                                  'value': authController.selectedBlockId.value,
                                  'fileBytes': '',
                                  'fileBytesFormat': '',
                                  'channel': channelID,
                                };
                                //before add check if already exit or not if exit then update that map otherwise add.
                                int finalObjIndex = authController.finalSingStepList.indexWhere((element) => element['param'] == authController.signUpStepList[index].fieldName.toString());
                                if (finalObjIndex != -1) {
                                  authController.finalSingStepList[finalObjIndex] = {
                                    'stepID': authController.signUpStepList[index].stepID.toString(),
                                    'rank': authController.signUpStepList[index].rank.toString(),
                                    'param': authController.signUpStepList[index].fieldName.toString(),
                                    'text': authController.signUpStepList[index].textEditingController!.text,
                                    'value': authController.selectedBlockId.value,
                                    'fileBytes': '',
                                    'fileBytesFormat': '',
                                    'channel': channelID,
                                  };
                                } else {
                                  authController.finalSingStepList.add(object);
                                }
                              }
                            }
                          }
                        },
                        validator: (value) {
                          if (authController.signUpStepList[index].isMandatory == true) {
                            if (authController.signUpStepList[index].textEditingController!.text.trim().isEmpty) {
                              return 'Please select ${authController.signUpStepList[index].label}';
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
                      );
                    } else if (authController.signUpStepList[index].fieldType == 'textarea') {
                      return CustomTextFieldWithTitle(
                        title: authController.signUpStepList[index].fieldName,
                        isCompulsory: authController.signUpStepList[index].isMandatory,
                        controller: authController.signUpStepList[index].textEditingController,
                        hintText: authController.signUpStepList[index].label!,
                        maxLength: 200,
                        maxLines: 4,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (authController.signUpStepList[index].isMandatory == true) {
                            if (authController.signUpStepList[index].textEditingController!.text.trim().isEmpty) {
                              return 'Please enter ${authController.signUpStepList[index].label}';
                            } else if (authController.signUpStepList[index].regex != null && authController.signUpStepList[index].regex!.isNotEmpty) {
                              RegExp nameRegex = RegExp(authController.signUpStepList[index].regex!);
                              if (!nameRegex.hasMatch(authController.signUpStepList[index].textEditingController!.text.trim())) {
                                return 'Please enter valid ${authController.signUpStepList[index].label}';
                              }
                            }
                            return null;
                          }
                          return null;
                        },
                        onChange: (value) {
                          Map object = {
                            'stepID': authController.signUpStepList[index].stepID.toString(),
                            'rank': authController.signUpStepList[index].rank.toString(),
                            'param': authController.signUpStepList[index].fieldName.toString(),
                            'value': authController.signUpStepList[index].textEditingController!.text,
                            'fileBytes': '',
                            'fileBytesFormat': '',
                            'channel': channelID,
                          };
                          //before add check if already exit or not if exit then update that map otherwise add.
                          int finalObjIndex = authController.finalSingStepList.indexWhere((element) => element['param'] == authController.signUpStepList[index].fieldName.toString());
                          if (finalObjIndex != -1) {
                            authController.finalSingStepList[finalObjIndex] = {
                              'stepID': authController.signUpStepList[index].stepID.toString(),
                              'rank': authController.signUpStepList[index].rank.toString(),
                              'param': authController.signUpStepList[index].fieldName.toString(),
                              'value': authController.signUpStepList[index].textEditingController!.text,
                              'fileBytes': '',
                              'fileBytesFormat': '',
                              'channel': channelID,
                            };
                          } else {
                            authController.finalSingStepList.add(object);
                          }
                        },
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: CommonButton(
              label: 'Submit',
              onPressed: () async {
                if (authController.signUpFormKey.currentState!.validate()) {
                  if (authController.isMobileVerify == true && authController.isEmailVerify == true) {
                    if (authController.emailVerified.value == true && authController.mobileVerified.value == true) {
                      showProgressIndicator();
                      bool result = await authController.signUPAPI(isLoaderShow: false);
                      if (result == true) {
                        Get.offAllNamed(Routes.AUTH_SCREEN);
                      }
                      dismissProgressIndicator();
                    } else if (authController.mobileVerified.value == false) {
                      errorSnackBar(message: 'Please verify mobile');
                    } else if (authController.emailVerified.value == false) {
                      errorSnackBar(message: 'Please verify email');
                    } else {
                      errorSnackBar(message: 'Please verify mobile & email');
                    }
                  } else if (authController.isMobileVerify == true && authController.isEmailVerify == false) {
                    if (authController.mobileVerified.value == true) {
                      showProgressIndicator();
                      bool result = await authController.signUPAPI(isLoaderShow: false);
                      if (result == true) {
                        Get.offAllNamed(Routes.AUTH_SCREEN);
                      }
                      dismissProgressIndicator();
                    } else {
                      errorSnackBar(message: 'Please verify mobile');
                    }
                  } else if (authController.isMobileVerify == false && authController.isEmailVerify == true) {
                    if (authController.emailVerified.value == true) {
                      showProgressIndicator();
                      bool result = await authController.signUPAPI(isLoaderShow: false);
                      if (result == true) {
                        Get.offAllNamed(Routes.AUTH_SCREEN);
                      }
                      dismissProgressIndicator();
                    } else {
                      errorSnackBar(message: 'Please verify email');
                    }
                  } else if (authController.isMobileVerify == false || authController.isEmailVerify == false) {
                    showProgressIndicator();
                    bool result = await authController.signUPAPI(isLoaderShow: false);
                    if (result == true) {
                      Get.offAllNamed(Routes.AUTH_SCREEN);
                    }
                    dismissProgressIndicator();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Email verify Dialog
  Future<dynamic> otpVerifyEmailDialog(BuildContext context) {
    authController.startEmailTimer();
    return customSimpleDialog(
      context: context,
      title: Text(
        'Verify Your Email',
        style: TextHelper.size20.copyWith(
          color: ColorsForApp.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      description: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          height(10),
          Text(
            'We have sent a 6-digit OTP to your entered email address',
            textAlign: TextAlign.center,
            style: TextHelper.size14.copyWith(
              color: ColorsForApp.lightBlackColor,
            ),
          ),
          height(8),
          Text(
            'OTP will expire in 10 minutes',
            textAlign: TextAlign.center,
            style: TextHelper.size12.copyWith(
              color: ColorsForApp.greyColor,
            ),
          ),
          height(20),
          Obx(
            () => CustomOtpTextField(
              otpList: authController.autoReadOtp.isNotEmpty && authController.autoReadOtp.value != '' ? authController.autoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(5),
              clearText: true,
              onChanged: (value) {
                authController.emailOtp.value = value;
              },
            ),
          ),
          height(20),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  authController.isEmailResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                  style: TextHelper.size14,
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  child: authController.isEmailResendButtonShow.value == true
                      ? GestureDetector(
                          onTap: () async {
                            // Unfocus the CustomOtpTextField
                            FocusScope.of(Get.context!).unfocus();
                            if (authController.isEmailResendButtonShow.value == true) {
                              authController.emailOtp.value = '';
                              initController();
                              bool result = await authController.generateEmailOtp(emailId: authController.sEmailTxtController.text);
                              if (result == true) {
                                authController.resetEmailTimer();
                                authController.startEmailTimer();
                              }
                            }
                          },
                          child: Text(
                            'Resend',
                            style: TextHelper.size14.copyWith(
                              color: ColorsForApp.primaryColor,
                            ),
                          ),
                        )
                      : Text(
                          '${(authController.emailTotalSecond ~/ 60).toString().padLeft(2, '0')}:${(authController.emailTotalSecond % 60).toString().padLeft(2, '0')}',
                          style: TextHelper.size14.copyWith(
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      noText: 'Cancel',
      onNo: () {
        Get.back();
        authController.resetEmailTimer();
        authController.emailOtp.value = '';
        initController();
      },
      yesText: 'Verify',
      onYes: () async {
        if (authController.emailOtp.value.isEmpty || authController.emailOtp.value.contains('null') || authController.emailOtp.value.length < 6) {
          errorSnackBar(message: 'Please enter OTP');
        } else {
          bool result = await authController.verifyEmailOtp();
          if (result == true) {
            authController.resetEmailTimer();
          }
        }
      },
    );
  }

  // Mobile verify Dialog
  Future<dynamic> otpVerifyMobileDialog(BuildContext context) {
    authController.startMobileTimer();
    return customSimpleDialog(
      context: context,
      title: Text(
        'Verify Your Mobile',
        style: TextHelper.size20.copyWith(
          color: ColorsForApp.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      description: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          height(10),
          Text(
            'We have sent a 6-digit OTP to your entered mobile number',
            textAlign: TextAlign.center,
            style: TextHelper.size14.copyWith(
              color: ColorsForApp.lightBlackColor,
            ),
          ),
          height(8),
          Text(
            'OTP will expire in 10 minutes',
            textAlign: TextAlign.center,
            style: TextHelper.size12.copyWith(
              color: ColorsForApp.greyColor,
            ),
          ),
          height(20),
          Obx(
            () => CustomOtpTextField(
              otpList: authController.autoReadOtp.isNotEmpty && authController.autoReadOtp.value != '' ? authController.autoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(5),
              clearText: true,
              onChanged: (value) {
                authController.mobileOtp.value = value;
              },
            ),
          ),
          height(20),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  authController.isMobileResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                  style: TextHelper.size14,
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  child: authController.isMobileResendButtonShow.value == true
                      ? GestureDetector(
                          onTap: () async {
                            // Unfocus the CustomOtpTextField
                            FocusScope.of(Get.context!).unfocus();
                            if (authController.isMobileResendButtonShow.value == true) {
                              authController.mobileOtp.value = '';
                              initController();
                              bool result = await authController.generateMobileOtp(mobileNumber: authController.mobileTxtController.text);
                              if (result == true) {
                                authController.resetMobileTimer();
                                authController.startMobileTimer();
                              }
                            }
                          },
                          child: Text(
                            'Resend',
                            style: TextHelper.size14.copyWith(
                              color: ColorsForApp.primaryColor,
                            ),
                          ),
                        )
                      : Text(
                          '${(authController.mobileTotalSecond ~/ 60).toString().padLeft(2, '0')}:${(authController.mobileTotalSecond % 60).toString().padLeft(2, '0')}',
                          style: TextHelper.size14.copyWith(
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      noText: 'Cancel',
      onNo: () {
        Get.back();
        authController.resetMobileTimer();
        authController.mobileOtp.value = '';
        initController();
      },
      yesText: 'Verify',
      onYes: () async {
        if (authController.mobileOtp.value.isEmpty || authController.mobileOtp.value.contains('null') || authController.mobileOtp.value.length < 6) {
          errorSnackBar(message: 'Please enter OTP');
        } else {
          bool result = await authController.verifyMobileOtp();
          if (result == true) {
            authController.resetMobileTimer();
          }
        }
      },
    );
  }
}

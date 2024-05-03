import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/distributor/add_user_controller.dart';
import '../../../controller/distributor/profile_controller.dart';
import '../../../generated/assets.dart';
import '../../../model/auth/adress_by_pincode_model.dart';
import '../../../model/auth/block_model.dart';
import '../../../model/auth/cities_model.dart';
import '../../../model/auth/entity_type_model.dart';
import '../../../model/auth/signup_steps_model.dart';
import '../../../model/auth/states_model.dart';
import '../../../model/auth/user_type_model.dart';
import '../../../model/create_profile/profile_information_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/string_constants.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_dialog.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/otp_text_field.dart';
import '../../../widgets/text_field_with_title.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final AddUserController addUserController = Get.find();
  final ProfileController profileController = Get.find();
  final GlobalKey<FormState> addUserFormKey = GlobalKey<FormState>();
  OTPInteractor otpInTractor = OTPInteractor();
  final ownerName = Get.arguments;

  @override
  void initState() {
    super.initState();
    initController();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    showProgressIndicator();
    await addUserController.getEntityType(isLoaderShow: false);
    await addUserController.getUserType(isLoaderShow: false);
    await addUserController.getStatesAPI(isLoaderShow: false);
    dismissProgressIndicator();
  }

  void initController() {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          addUserController.mobileOtp.value = code;
          addUserController.autoReadOtp.value = code;
          Get.log('\x1B[97m[OTP] => ${addUserController.mobileOtp.value}\x1B[0m');
        },
        otpInteractor: otpInTractor,
      ).startListenUserConsent((code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      });
    }
  }

  callPersonalDetailsApi() async {
    await addUserController.getAddUserFields();
    addUserController.updateRender();
  }

  @override
  void dispose() {
    addUserController.clearAddUserVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 10.h,
      title: 'Add User',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        height: 10.h,
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          image: const DecorationImage(
            image: AssetImage(Assets.imagesTopCardBgStart),
            fit: BoxFit.fitWidth,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(2.w),
              child: Image.asset(
                Assets.imagesAddUserTopBg,
              ),
            ),
            width(2.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add User',
                    style: TextHelper.size14.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    'Create a new user account with the following details.',
                    maxLines: 3,
                    style: TextHelper.size12.copyWith(
                      color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      mainBody: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          switchInCurve: Curves.fastOutSlowIn,
          switchOutCurve: Curves.fastOutSlowIn,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
            return currentChild ?? Container();
          },
          child: addUserController.widgetId.value == 1 ? renderUserTypeUI() : renderPersonalDetails(),
        ),
      ),
    );
  }

  Widget renderUserTypeUI() {
    return Container(
      height: 100.h,
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        image: DecorationImage(
          image: AssetImage(
            Assets.imagesProfileScreenTopBg,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Form(
          key: addUserController.addUserFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              height(2.h),
              // Select usertype
              CustomTextFieldWithTitle(
                controller: addUserController.userTypeTxtController,
                title: 'User Type',
                hintText: 'Select user type',
                isCompulsory: true,
                readOnly: true,
                suffixIcon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                ),
                onTap: () async {
                  UserTypeModel selectedUserType = await Get.toNamed(
                    Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                    arguments: [
                      addUserController.userTypeList, // modelList
                      'userTypeList', // modelName
                    ],
                  );
                  if (selectedUserType.name != null && selectedUserType.name!.isNotEmpty) {
                    addUserController.userTypeTxtController.text = selectedUserType.name!;
                    addUserController.selectedUserTypeId.value = selectedUserType.id!.toString();
                    profileController.selectedUserTypeId.value = selectedUserType.id!.toString();
                  }
                },
                validator: (value) {
                  if (addUserController.userTypeTxtController.text.trim().isEmpty) {
                    return 'Please select user type';
                  }
                  return null;
                },
              ),
              // Select entity type
              CustomTextFieldWithTitle(
                controller: addUserController.entityTypeTxtController,
                title: 'Entity Type',
                hintText: 'Select entity type',
                isCompulsory: true,
                readOnly: true,
                suffixIcon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                ),
                onTap: () async {
                  EntityTypeModel selectedEntityType = await Get.toNamed(
                    Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                    arguments: [
                      addUserController.entityTypeList, // modelList
                      'entityTypeList', // modelName
                    ],
                  );
                  if (selectedEntityType.name != null && selectedEntityType.name!.isNotEmpty) {
                    addUserController.entityTypeTxtController.text = selectedEntityType.name!;
                    addUserController.selectedEntityTypeId.value = selectedEntityType.id!.toString();
                  }
                },
                validator: (value) {
                  if (addUserController.entityTypeTxtController.text.trim().isEmpty) {
                    return 'Please select entity type';
                  }
                  return null;
                },
              ),
              height(2.h),
              CommonButton(
                bgColor: ColorsForApp.primaryColor,
                label: 'Continue',
                onPressed: () async {
                  if (addUserController.userTypeTxtController.text.isEmpty) {
                    errorSnackBar(message: 'Please select user type');
                  } else if (addUserController.entityTypeTxtController.text.isEmpty) {
                    errorSnackBar(message: 'Please select entity type');
                  } else {
                    await profileController.profileInformation(isLoaderShow: false);
                    callPersonalDetailsApi();
                  }
                },
                labelColor: ColorsForApp.whiteColor,
                width: 100.w,
              ),
              height(2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderPersonalDetails() {
    return Form(
      key: addUserFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            height(2.h),
            Text(
              'Personal Details',
              style: TextHelper.size15.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            height(15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customKeyValueText(key: 'User Type: ', value: addUserController.userTypeTxtController.text),
                height(5),
                customKeyValueText(key: 'Entity Type: ', value: addUserController.entityTypeTxtController.text),
              ],
            ),
            height(15),
            ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: addUserController.addUserFieldList.length,
              itemBuilder: (context, index) {
                if (addUserController.addUserFieldList[index].fieldName != 'usertype' &&
                    addUserController.addUserFieldList[index].fieldName != 'entityType' &&
                    addUserController.addUserFieldList[index].fieldName != 'Parent' &&
                    addUserController.addUserFieldList[index].fieldName != 'Country') {
                  if (addUserController.addUserFieldList[index].fieldType == 'text') {
                    return Obx(
                      () => CustomTextFieldWithTitle(
                        title: addUserController.addUserFieldList[index].label,
                        isCompulsory: addUserController.addUserFieldList[index].isMandatory,
                        controller: addUserController.addUserFieldList[index].textEditingController,
                        hintText: addUserController.addUserFieldList[index].label!,
                        maxLength: addUserController.addUserFieldList[index].maxLength,
                        readOnly: addUserController.addUserFieldList[index].fieldName == 'mobileNo' && addUserController.mobileVerified.value == true
                            ? true
                            : addUserController.addUserFieldList[index].fieldName == 'email' && addUserController.emailVerified.value == true
                                ? true
                                : false,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (addUserController.addUserFieldList[index].isMandatory == true) {
                            if (addUserController.addUserFieldList[index].textEditingController!.text.trim().isEmpty) {
                              return 'Please enter ${addUserController.addUserFieldList[index].label!.toLowerCase()}';
                            } else if (addUserController.addUserFieldList[index].regex != null && addUserController.addUserFieldList[index].regex!.isNotEmpty) {
                              RegExp nameRegex = RegExp(addUserController.addUserFieldList[index].regex!);
                              if (!nameRegex.hasMatch(addUserController.addUserFieldList[index].textEditingController!.text.trim())) {
                                return 'Please enter valid ${addUserController.addUserFieldList[index].label!.toLowerCase()}';
                              }
                            }
                            return null;
                          }
                          return null;
                        },
                        onChange: (value) async {
                          if (addUserController.addUserFieldList[index].fieldName == 'Pincode') {
                            if (value!.length >= 6) {
                              //object for pin code
                              Map object = {
                                'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                                'rank': addUserController.addUserFieldList[index].rank.toString(),
                                'param': addUserController.addUserFieldList[index].fieldName.toString(),
                                'value': value,
                                'fileBytes': null,
                                'fileBytesFormat': null,
                                'channel': channelID,
                              };
                              //before add check if already exit or not if exit then update that map otherwise add.
                              int finalObjIndex = addUserController.finalSingStepList.indexWhere((element) => element['param'] == addUserController.addUserFieldList[index].fieldName.toString());
                              if (finalObjIndex != -1) {
                                addUserController.finalSingStepList[finalObjIndex] = {
                                  'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                                  'rank': addUserController.addUserFieldList[index].rank.toString(),
                                  'param': addUserController.addUserFieldList[index].fieldName.toString(),
                                  'value': value,
                                  'fileBytes': null,
                                  'fileBytesFormat': null,
                                  'channel': channelID,
                                };
                              } else {
                                addUserController.finalSingStepList.add(object);
                              }
                              bool result = await addUserController.getStateCityBlockAPI(isLoaderShow: true, pinCode: addUserController.addUserFieldList[index].textEditingController!.text);
                              if (result == true) {
                                for (SignUpFields element in addUserController.addUserFieldList) {
                                  if (element.groupType == 'state') {
                                    element.textEditingController!.text = addUserController.getCityStateBlockData.value.data!.stateName!;
                                    Map object = {
                                      'stepID': element.stepID.toString(),
                                      'rank': element.rank.toString(),
                                      'param': element.fieldName.toString(),
                                      'text': element.textEditingController!.text.toString(),
                                      'value': addUserController.getCityStateBlockData.value.data!.stateID.toString(),
                                      'fileBytes': null,
                                      'fileBytesFormat': null,
                                      'channel': channelID,
                                    };
                                    //before add check if already exit or not if exit then update that map otherwise add.
                                    int finalObjIndex = addUserController.finalSingStepList.indexWhere((foundElement) => foundElement['param'] == element.fieldName.toString());
                                    if (finalObjIndex != -1) {
                                      addUserController.finalSingStepList[finalObjIndex] = {
                                        'stepID': element.stepID.toString(),
                                        'rank': element.rank.toString(),
                                        'param': element.fieldName.toString(),
                                        'text': element.textEditingController!.text.toString(),
                                        'value': addUserController.getCityStateBlockData.value.data!.stateID.toString(),
                                        'fileBytes': null,
                                        'fileBytesFormat': null,
                                        'channel': channelID,
                                      };
                                    } else {
                                      addUserController.finalSingStepList.add(object);
                                    }
                                  }
                                  if (element.groupType == 'city') {
                                    element.textEditingController!.text = addUserController.getCityStateBlockData.value.data!.cityName!;
                                    Map object = {
                                      'stepID': element.stepID.toString(),
                                      'rank': element.rank.toString(),
                                      'param': element.fieldName.toString(),
                                      'text': element.textEditingController!.text.toString(),
                                      'value': addUserController.getCityStateBlockData.value.data!.cityID.toString(),
                                      'fileBytes': null,
                                      'fileBytesFormat': null,
                                      'channel': channelID,
                                    };
                                    //before add check if already exit or not if exit then update that map otherwise add.
                                    int finalObjIndex = addUserController.finalSingStepList.indexWhere((foundElement) => foundElement['param'] == element.fieldName.toString());
                                    if (finalObjIndex != -1) {
                                      addUserController.finalSingStepList[finalObjIndex] = {
                                        'stepID': element.stepID.toString(),
                                        'rank': element.rank.toString(),
                                        'param': element.fieldName.toString(),
                                        'text': element.textEditingController!.text.toString(),
                                        'value': addUserController.getCityStateBlockData.value.data!.cityID.toString(),
                                        'fileBytes': null,
                                        'fileBytesFormat': null,
                                        'channel': channelID,
                                      };
                                    } else {
                                      addUserController.finalSingStepList.add(object);
                                    }
                                  }
                                  if (element.groupType == 'block') {
                                    element.textEditingController!.text = addUserController.getCityStateBlockData.value.data!.blockName!;
                                    Map object = {
                                      'stepID': element.stepID.toString(),
                                      'rank': element.rank.toString(),
                                      'param': element.fieldName.toString(),
                                      'text': element.textEditingController!.text,
                                      'value': addUserController.getCityStateBlockData.value.data!.blockID.toString(),
                                      'fileBytes': null,
                                      'fileBytesFormat': null,
                                      'channel': channelID,
                                    };
                                    //before add check if already exit or not if exit then update that map otherwise add.
                                    int finalObjIndex = addUserController.finalSingStepList.indexWhere((foundElement) => foundElement['param'] == element.fieldName.toString());
                                    if (finalObjIndex != -1) {
                                      addUserController.finalSingStepList[finalObjIndex] = {
                                        'stepID': element.stepID.toString(),
                                        'rank': element.rank.toString(),
                                        'param': element.fieldName.toString(),
                                        'text': element.textEditingController!.text,
                                        'value': addUserController.getCityStateBlockData.value.data!.blockID.toString(),
                                        'fileBytes': null,
                                        'fileBytesFormat': null,
                                        'channel': channelID,
                                      };
                                    } else {
                                      addUserController.finalSingStepList.add(object);
                                    }
                                  }
                                }
                              } else {
                                //If data not found rest state,city,block
                                addUserController.getCityStateBlockData.value.data = StateCityBlockDataModel();
                                for (SignUpFields element in addUserController.addUserFieldList) {
                                  if (element.groupType == 'state') {
                                    addUserController.getCityStateBlockData.value.data!.stateName = null;
                                    addUserController.getCityStateBlockData.value.data!.stateID = null;
                                    element.textEditingController!.clear();
                                  }
                                  if (element.groupType == 'city') {
                                    addUserController.getCityStateBlockData.value.data!.cityName = null;
                                    addUserController.getCityStateBlockData.value.data!.cityID = null;
                                    element.textEditingController!.clear();
                                  }
                                  if (element.groupType == 'block') {
                                    addUserController.getCityStateBlockData.value.data!.blockName = null;
                                    addUserController.getCityStateBlockData.value.data!.blockID = null;
                                    element.textEditingController!.clear();
                                  }
                                }
                              }
                            }
                          } else {
                            if (addUserController.addUserFieldList[index].fieldName == 'fullName') {
                              addUserController.ownerName.value = addUserController.addUserFieldList[index].textEditingController!.text;
                            }
                            Map object = {
                              'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                              'rank': addUserController.addUserFieldList[index].rank.toString(),
                              'param': addUserController.addUserFieldList[index].fieldName.toString(),
                              'value': addUserController.addUserFieldList[index].textEditingController!.text,
                              'fileBytes': null,
                              'fileBytesFormat': null,
                              'channel': channelID,
                            };
                            //before add check if already exit or not if exit then update that map otherwise add.
                            int finalObjIndex = addUserController.finalSingStepList.indexWhere((element) => element['param'] == addUserController.addUserFieldList[index].fieldName.toString());
                            if (finalObjIndex != -1) {
                              addUserController.finalSingStepList[finalObjIndex] = {
                                'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                                'rank': addUserController.addUserFieldList[index].rank.toString(),
                                'param': addUserController.addUserFieldList[index].fieldName.toString(),
                                'value': addUserController.addUserFieldList[index].textEditingController!.text,
                                'fileBytes': null,
                                'fileBytesFormat': null,
                                'channel': channelID,
                              };
                            } else {
                              addUserController.finalSingStepList.add(object);
                            }
                          }
                        },
                      ),
                    );
                  } else if (addUserController.addUserFieldList[index].fieldType == 'textarea') {
                    return Obx(
                      () => CustomTextFieldWithTitle(
                        title: addUserController.addUserFieldList[index].label,
                        isCompulsory: addUserController.addUserFieldList[index].isMandatory,
                        controller: addUserController.addUserFieldList[index].textEditingController,
                        hintText: addUserController.addUserFieldList[index].label!,
                        maxLength: addUserController.addUserFieldList[index].maxLength,
                        maxLines: 4,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (addUserController.addUserFieldList[index].isMandatory == true) {
                            if (addUserController.addUserFieldList[index].textEditingController!.text.trim().isEmpty) {
                              return 'Please enter ${addUserController.addUserFieldList[index].fieldName!.toLowerCase()}';
                            } else if (addUserController.addUserFieldList[index].mobileRegex != null && addUserController.addUserFieldList[index].mobileRegex!.isNotEmpty) {
                              RegExp nameRegex = RegExp(addUserController.addUserFieldList[index].mobileRegex!);
                              if (!nameRegex.hasMatch(addUserController.addUserFieldList[index].textEditingController!.text.trim())) {
                                return 'Please enter valid ${addUserController.addUserFieldList[index].fieldName!.toLowerCase()}';
                              }
                            }
                            return null;
                          }
                          return null;
                        },
                        onChange: (value) {
                          Map object = {
                            'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                            'rank': addUserController.addUserFieldList[index].rank.toString(),
                            'param': addUserController.addUserFieldList[index].fieldName.toString(),
                            'value': addUserController.addUserFieldList[index].textEditingController!.text,
                            'fileBytes': null,
                            'fileBytesFormat': null,
                            'channel': channelID,
                          };
                          //before add check if already exit or not if exit then update that map otherwise add.
                          int finalObjIndex = addUserController.finalSingStepList.indexWhere((element) => element['param'] == addUserController.addUserFieldList[index].fieldName.toString());
                          if (finalObjIndex != -1) {
                            addUserController.finalSingStepList[finalObjIndex] = {
                              'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                              'rank': addUserController.addUserFieldList[index].rank.toString(),
                              'param': addUserController.addUserFieldList[index].fieldName.toString(),
                              'value': addUserController.addUserFieldList[index].textEditingController!.text,
                              'fileBytes': null,
                              'fileBytesFormat': null,
                              'channel': channelID,
                            };
                          } else {
                            addUserController.finalSingStepList.add(object);
                          }
                        },
                      ),
                    );
                  } else if (addUserController.addUserFieldList[index].fieldType == 'dropdown') {
                    return CustomTextFieldWithTitle(
                      controller: addUserController.addUserFieldList[index].textEditingController,
                      title: addUserController.addUserFieldList[index].label,
                      hintText: addUserController.addUserFieldList[index].label,
                      isCompulsory: addUserController.addUserFieldList[index].isMandatory,
                      readOnly: true,
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: ColorsForApp.secondaryColor.withOpacity(0.5),
                      ),
                      onTap: () async {
                        //Check If we got state ,city,block from pinCode then dropdown should be disable
                        if (addUserController.addUserFieldList[index].groupType == 'state' &&
                            addUserController.getCityStateBlockData.value.data != null &&
                            addUserController.getCityStateBlockData.value.data!.stateName != null &&
                            addUserController.getCityStateBlockData.value.data!.stateName!.isNotEmpty) {
                        } else if (addUserController.addUserFieldList[index].groupType == 'city' &&
                            addUserController.getCityStateBlockData.value.data != null &&
                            addUserController.getCityStateBlockData.value.data!.cityName != null &&
                            addUserController.getCityStateBlockData.value.data!.cityName!.isNotEmpty) {
                        } else if (addUserController.addUserFieldList[index].groupType == 'block' &&
                            addUserController.getCityStateBlockData.value.data != null &&
                            addUserController.getCityStateBlockData.value.data!.blockName != null &&
                            addUserController.getCityStateBlockData.value.data!.blockName!.isNotEmpty) {
                        } else {
                          if (addUserController.addUserFieldList[index].groupType == 'state') {
                            StatesModel selectedState = await Get.toNamed(
                              Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                              arguments: [
                                addUserController.statesList, // modelList
                                'statesList', // modelName
                              ],
                            );
                            if (selectedState.name != null && selectedState.name!.isNotEmpty) {
                              addUserController.addUserFieldList[index].textEditingController!.text = selectedState.name!;
                              addUserController.selectedStateId.value = selectedState.id!.toString();
                              Map object = {
                                'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                                'rank': addUserController.addUserFieldList[index].rank.toString(),
                                'param': addUserController.addUserFieldList[index].fieldName.toString(),
                                'text': addUserController.addUserFieldList[index].textEditingController!.text,
                                'value': addUserController.selectedStateId.value,
                                'fileBytes': null,
                                'fileBytesFormat': null,
                                'channel': channelID,
                              };
                              //before add check if already exit or not if exit then update that map otherwise add.
                              int finalObjIndex = addUserController.finalSingStepList.indexWhere((element) => element['param'] == addUserController.addUserFieldList[index].fieldName.toString());
                              if (finalObjIndex != -1) {
                                addUserController.finalSingStepList[finalObjIndex] = {
                                  'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                                  'rank': addUserController.addUserFieldList[index].rank.toString(),
                                  'param': addUserController.addUserFieldList[index].fieldName.toString(),
                                  'text': addUserController.addUserFieldList[index].textEditingController!.text,
                                  'value': addUserController.selectedStateId.value.toString(),
                                  'fileBytes': null,
                                  'fileBytesFormat': null,
                                  'channel': channelID,
                                };
                              } else {
                                addUserController.finalSingStepList.add(object);
                              }
                              for (var element in addUserController.addUserFieldList) {
                                if (element.groupType == 'city' && element.textEditingController!.text.isNotEmpty) {
                                  element.textEditingController!.clear();
                                }
                                if (element.groupType == 'block' && element.textEditingController!.text.isNotEmpty) {
                                  element.textEditingController!.clear();
                                }
                              }
                              await addUserController.getCitiesAPI(isLoaderShow: true);
                            }
                          } else if (addUserController.addUserFieldList[index].groupType == 'city') {
                            addUserController.addUserFieldList[index].textEditingController!.clear();
                            CitiesModel selectedCity = await Get.toNamed(
                              Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                              arguments: [
                                addUserController.citiesList, // modelList
                                'citiesList', // modelName
                              ],
                            );
                            if (selectedCity.name != null && selectedCity.name!.isNotEmpty) {
                              addUserController.addUserFieldList[index].textEditingController!.text = selectedCity.name!;
                              addUserController.selectedCityId.value = selectedCity.id!.toString();
                              Map object = {
                                'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                                'rank': addUserController.addUserFieldList[index].rank.toString(),
                                'param': addUserController.addUserFieldList[index].fieldName.toString(),
                                'text': addUserController.addUserFieldList[index].textEditingController!.text,
                                'value': addUserController.selectedCityId.value.toString(),
                                'fileBytes': null,
                                'fileBytesFormat': null,
                                'channel': channelID,
                              };
                              //before add check if already exit or not if exit then update that map otherwise add.
                              int finalObjIndex = addUserController.finalSingStepList.indexWhere((element) => element['param'] == addUserController.addUserFieldList[index].fieldName.toString());
                              if (finalObjIndex != -1) {
                                addUserController.finalSingStepList[finalObjIndex] = {
                                  'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                                  'rank': addUserController.addUserFieldList[index].rank.toString(),
                                  'param': addUserController.addUserFieldList[index].fieldName.toString(),
                                  'text': addUserController.addUserFieldList[index].textEditingController!.text,
                                  'value': addUserController.selectedCityId.value,
                                  'fileBytes': null,
                                  'fileBytesFormat': null,
                                  'channel': channelID,
                                };
                              } else {
                                addUserController.finalSingStepList.add(object);
                              }
                              for (var element in addUserController.addUserFieldList) {
                                if (element.groupType == 'block' && element.textEditingController!.text.isNotEmpty) {
                                  element.textEditingController!.clear();
                                }
                              }
                              await addUserController.getBlockAPI(isLoaderShow: true);
                            }
                          } else if (addUserController.addUserFieldList[index].groupType == 'block') {
                            addUserController.addUserFieldList[index].textEditingController!.clear();
                            BlockModel selectedBlock = await Get.toNamed(
                              Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                              arguments: [
                                addUserController.blockList, // modelList
                                'blockList', // modelName
                              ],
                            );
                            if (selectedBlock.name != null && selectedBlock.name!.isNotEmpty) {
                              addUserController.addUserFieldList[index].textEditingController!.text = selectedBlock.name!;
                              addUserController.selectedBlockId.value = selectedBlock.id!.toString();
                              Map object = {
                                'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                                'rank': addUserController.addUserFieldList[index].rank.toString(),
                                'param': addUserController.addUserFieldList[index].fieldName.toString(),
                                'text': addUserController.addUserFieldList[index].textEditingController!.text,
                                'value': addUserController.selectedBlockId.value,
                                'fileBytes': null,
                                'fileBytesFormat': null,
                                'channel': channelID,
                              };
                              //before add check if already exit or not if exit then update that map otherwise add.
                              int finalObjIndex = addUserController.finalSingStepList.indexWhere((element) => element['param'] == addUserController.addUserFieldList[index].fieldName.toString());
                              if (finalObjIndex != -1) {
                                addUserController.finalSingStepList[finalObjIndex] = {
                                  'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                                  'rank': addUserController.addUserFieldList[index].rank.toString(),
                                  'param': addUserController.addUserFieldList[index].fieldName.toString(),
                                  'text': addUserController.addUserFieldList[index].textEditingController!.text,
                                  'value': addUserController.selectedBlockId.value,
                                  'fileBytes': null,
                                  'fileBytesFormat': null,
                                  'channel': channelID,
                                };
                              } else {
                                addUserController.finalSingStepList.add(object);
                              }
                            }
                          } else if (addUserController.addUserFieldList[index].groupType == 'profile') {
                            addUserController.addUserFieldList[index].textEditingController!.clear();
                            Profile profile = await Get.toNamed(
                              Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                              arguments: [
                                profileController.activeProfilesList, // modelList
                                'profileList', // modelName
                              ],
                            );
                            if (profile.name != null && profile.name!.isNotEmpty) {
                              addUserController.addUserFieldList[index].textEditingController!.text = profile.name!;
                              addUserController.selectedProfileId.value = profile.id!.toString();
                              Map object = {
                                'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                                'rank': addUserController.addUserFieldList[index].rank.toString(),
                                'param': addUserController.addUserFieldList[index].fieldName.toString(),
                                'text': addUserController.addUserFieldList[index].textEditingController!.text,
                                'value': addUserController.selectedProfileId.value.toString(),
                                'fileBytes': null,
                                'fileBytesFormat': null,
                                'channel': channelID,
                              };
                              //before add check if already exit or not if exit then update that map otherwise add.
                              int finalObjIndex = addUserController.finalSingStepList.indexWhere((element) => element['param'] == addUserController.addUserFieldList[index].fieldName.toString());
                              if (finalObjIndex != -1) {
                                addUserController.finalSingStepList[finalObjIndex] = {
                                  'stepID': addUserController.addUserFieldList[index].stepID.toString(),
                                  'rank': addUserController.addUserFieldList[index].rank.toString(),
                                  'param': addUserController.addUserFieldList[index].fieldName.toString(),
                                  'text': addUserController.addUserFieldList[index].textEditingController!.text,
                                  'value': addUserController.selectedProfileId.value.toString(),
                                  'fileBytes': null,
                                  'fileBytesFormat': null,
                                  'channel': channelID,
                                };
                              } else {
                                addUserController.finalSingStepList.add(object);
                              }
                            }
                          }
                        }
                      },
                      validator: (value) {
                        if (addUserController.addUserFieldList[index].isMandatory == true) {
                          if (addUserController.addUserFieldList[index].textEditingController!.text.trim().isEmpty) {
                            return 'Please select ${addUserController.addUserFieldList[index].label!.toLowerCase()}';
                          }
                          return null;
                        }
                        return null;
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
            height(20),
            CommonButton(
              bgColor: ColorsForApp.primaryColor,
              label: 'Add User',
              onPressed: () async {
                if (addUserFormKey.currentState!.validate()) {
                  try {
                    showProgressIndicator();
                    bool result = await addUserController.addUserAPI(params: addUserController.finalSingStepList);
                    if (result == true) {
                      if (context.mounted) {
                        successDialog(context);
                      }
                    }
                    dismissProgressIndicator();
                  } catch (e) {
                    dismissProgressIndicator();
                  }
                }
              },
              labelColor: ColorsForApp.whiteColor,
              width: 100.w,
            ),
            height(10),
          ],
        ),
      ),
    );
  }

  // Email verify Dialog
  Future<dynamic> otpVerifyEmailDialog(BuildContext context) {
    addUserController.startEmailTimer();
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
              otpList: addUserController.autoReadOtp.isNotEmpty && addUserController.autoReadOtp.value != '' ? addUserController.autoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(5),
              clearText: true,
              onChanged: (value) {
                addUserController.emailOtp.value = value;
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
                  addUserController.isEmailResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                  style: TextHelper.size14,
                ),
                Container(
                  width: 70,
                  alignment: Alignment.center,
                  child: addUserController.isEmailResendButtonShow.value == true
                      ? GestureDetector(
                          onTap: () async {
                            // Unfocus the CustomOtpTextField
                            FocusScope.of(Get.context!).unfocus();
                            if (addUserController.isEmailResendButtonShow.value == true) {
                              addUserController.emailOtp.value = '';
                              initController();
                              bool result = await addUserController.generateEmailOtp(emailId: addUserController.sEmailTxtController.text);
                              if (result == true) {
                                addUserController.resetEmailTimer();
                                addUserController.startEmailTimer();
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
                          '${(addUserController.emailTotalSecond ~/ 60).toString().padLeft(2, '0')}:${(addUserController.emailTotalSecond % 60).toString().padLeft(2, '0')}',
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
        addUserController.resetEmailTimer();
        addUserController.emailOtp.value = '';
        initController();
      },
      yesText: 'Verify',
      onYes: () async {
        if (addUserController.emailOtp.value.isEmpty || addUserController.emailOtp.value.contains('null') || addUserController.emailOtp.value.length < 6) {
          errorSnackBar(message: 'Please enter OTP');
        } else {
          showProgressIndicator();
          bool result = await addUserController.verifyEmailOtp(isLoaderShow: false);
          if (result == true) {
            addUserController.resetEmailTimer();
          }
          dismissProgressIndicator();
        }
      },
    );
  }

  // Mobile verify Dialog
  Future<dynamic> otpVerifyMobileDialog(BuildContext context) {
    addUserController.startMobileTimer();
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
              otpList: addUserController.autoReadOtp.isNotEmpty && addUserController.autoReadOtp.value != '' ? addUserController.autoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(5),
              clearText: true,
              onChanged: (value) {
                addUserController.mobileOtp.value = value;
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
                  addUserController.isMobileResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                  style: TextHelper.size14,
                ),
                Container(
                  width: 50,
                  alignment: Alignment.centerLeft,
                  child: addUserController.isMobileResendButtonShow.value == true
                      ? GestureDetector(
                          onTap: () async {
                            // Unfocus the CustomOtpTextField
                            FocusScope.of(Get.context!).unfocus();
                            if (addUserController.isMobileResendButtonShow.value == true) {
                              addUserController.mobileOtp.value = '';
                              initController();
                              bool result = await addUserController.generateMobileOtp(mobileNumber: addUserController.mobileTxtController.text);
                              if (result == true) {
                                addUserController.resetMobileTimer();
                                addUserController.startMobileTimer();
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
                          '${(addUserController.mobileTotalSecond ~/ 60).toString().padLeft(2, '0')}:${(addUserController.mobileTotalSecond % 60).toString().padLeft(2, '0')}',
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
        addUserController.resetMobileTimer();
        addUserController.mobileOtp.value = '';
        initController();
        Get.back();
      },
      yesText: 'Verify',
      onYes: () async {
        if (addUserController.mobileOtp.value.isEmpty || addUserController.mobileOtp.value.contains('null') || addUserController.mobileOtp.value.length < 6) {
          errorSnackBar(message: 'Please enter OTP');
        } else {
          showProgressIndicator();
          bool result = await addUserController.verifyMobileOtp(
            isLoaderShow: false,
          );
          if (result == true) {
            addUserController.resetMobileTimer();
          }
          dismissProgressIndicator();
        }
      },
    );
  }

  Future<dynamic> successDialog(BuildContext context) {
    return customDialog(
      context: context,
      barrierDismissible: false,
      preventToClose: false,
      title: Text(
        'User Created Successfully!',
        style: TextHelper.size20.copyWith(
          color: ColorsForApp.primaryColor,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      description: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'What would you like to do next?\nYou can perform KYC or you can Skip for now',
            textAlign: TextAlign.center,
            style: TextHelper.size15.copyWith(
              fontWeight: FontWeight.w500,
              color: ColorsForApp.lightBlackColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
      noText: 'Update KYC',
      onNo: () {
        Get.back();
        Get.toNamed(
          Routes.KYC_SCREEN,
          arguments: [
            true, //Navigate to do user kyc screen
            addUserController.ownerName.value, //pass full name
            addUserController.addUserResponse.value.refNumber //pass unique id
          ],
        );
      },
      yesText: 'Yes,Skip',
      onYes: () async {
        Get.offAllNamed(Routes.DISTRIBUTOR_DASHBOARD_SCREEN);
      },
      topImage: Assets.imagesSucessImg,
    );
  }

  Widget customKeyValueText({required String key, required String value, TextStyle? keyTextStyle, TextStyle? valueTextStyle}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key,
              style: keyTextStyle ?? TextHelper.size13.copyWith(fontFamily: mediumGoogleSansFont, color: ColorsForApp.lightBlackColor, fontWeight: FontWeight.bold),
            ),
            width(5),
            Expanded(
              child: Text(
                value.isNotEmpty ? value : '',
                textAlign: TextAlign.start,
                style: valueTextStyle ??
                    TextHelper.size13.copyWith(
                      fontFamily: regularGoogleSansFont,
                      color: ColorsForApp.lightBlackColor,
                    ),
              ),
            ),
          ],
        ),
        height(8),
      ],
    );
  }
}

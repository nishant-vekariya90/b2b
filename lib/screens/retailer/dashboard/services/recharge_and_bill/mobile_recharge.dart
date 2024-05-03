import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/recharge_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/master/circle_list_model.dart';
import '../../../../../model/master/operator_list_model.dart';
import '../../../../../model/recharge_and_biils/m_plans_model.dart';
import '../../../../../model/recharge_and_biils/r_plans_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/permission_handler.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field.dart';
import '../../../../../widgets/text_field_with_title.dart';

class MobileRechargePage extends StatefulWidget {
  const MobileRechargePage({Key? key}) : super(key: key);

  @override
  State<MobileRechargePage> createState() => _MobileRechargePageState();
}

class _MobileRechargePageState extends State<MobileRechargePage> {
  final RechargeController rechargeController = Get.find();
  final Rx<GlobalKey<FormState>> mobileRechargeFormKey = GlobalKey<FormState>().obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      await rechargeController.getMasterOperatorList(operator: 'mobile', isLoaderShow: false);
      if (rechargeController.masterCircleList.isEmpty) {
        await rechargeController.getMasterCircleList(isLoaderShow: false);
      }
      rechargeController.isShowTpinField.value = checkTpinRequired(categoryCode: 'Telecom');
      dismissProgressIndicator();
    } catch (e) {
      rechargeController.isShowTpinField.value = false;
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    rechargeController.resetRechargeVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 10.h,
      title: 'Mobile Recharge',
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
              child: Image.asset(
                Assets.imagesMobileRechargeTopBg,
              ),
            ),
            width(2.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mobile Recharge',
                    style: TextHelper.size14.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    'Recharge your mobile instantly from the leading service providers, anywhere and anytime.',
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
      mainBody: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Obx(
          () => Form(
            key: mobileRechargeFormKey.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(2.h),
                // Mobile number
                CustomTextFieldWithTitle(
                  controller: rechargeController.mobileNumberController,
                  title: 'Mobile Number',
                  hintText: 'Enter mobile number',
                  maxLength: 10,
                  isCompulsory: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChange: (value) async {
                    if (value!.isNotEmpty && value.length >= 10) {
                      await rechargeController.getOperatorFetchDetails();
                      if (context.mounted) {
                        FocusScope.of(context).unfocus();
                      }
                      rechargeController.isShowPlanButton.value = true;
                    } else {
                      rechargeController.operatorController.clear();
                      rechargeController.circleController.clear();
                      rechargeController.isShowPlanButton.value = false;
                    }
                  },
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      await PermissionHandlerPermissionService.handleContactPermission(context).then((bool contactPermission) async {
                        if (contactPermission == true) {
                          try {
                            Contact selectedContact = Contact();
                            if (rechargeController.contactList.isEmpty) {
                              showProgressIndicator();
                              rechargeController.contactList.value = await ContactsService.getContacts();
                              rechargeController.contactList.removeWhere((element) => element.phones == null || element.phones!.isEmpty);
                              dismissProgressIndicator();
                              if (rechargeController.contactList.isNotEmpty) {
                                rechargeController.contactList.sort((a, b) => a.displayName!.toLowerCase().compareTo(b.displayName!.toLowerCase()));
                                selectedContact = await Get.toNamed(
                                  Routes.SEARCHABLE_LIST_VIEW_WITH_IMAGE_SCREEN,
                                  arguments: [
                                    rechargeController.contactList, // modelList
                                    'contactList', // modelName
                                  ],
                                );
                                if (selectedContact.phones!.isNotEmpty) {
                                  String tempNumber = selectedContact.phones!.first.value!.replaceAll(RegExp(r'[^0-9]'), '');
                                  if (tempNumber.length >= 10) {
                                    tempNumber = tempNumber.substring(tempNumber.length - 10);
                                  }
                                  rechargeController.mobileNumberController.text = tempNumber;
                                  await rechargeController.getOperatorFetchDetails();
                                  if (context.mounted) {
                                    FocusScope.of(context).unfocus();
                                  }
                                  rechargeController.isShowPlanButton.value = true;
                                }
                              } else {
                                errorSnackBar(message: 'No contact found!');
                              }
                            } else {
                              selectedContact = await Get.toNamed(
                                Routes.SEARCHABLE_LIST_VIEW_WITH_IMAGE_SCREEN,
                                arguments: [
                                  rechargeController.contactList, // modelList
                                  'contactList', // modelName
                                ],
                              );
                              if (selectedContact.phones!.isNotEmpty) {
                                String tempNumber = selectedContact.phones!.first.value!.replaceAll(RegExp(r'[^0-9]'), '');
                                if (tempNumber.length >= 10) {
                                  tempNumber = tempNumber.substring(tempNumber.length - 10);
                                }
                                rechargeController.mobileNumberController.text = tempNumber;
                                await rechargeController.getOperatorFetchDetails();
                                if (context.mounted) {
                                  FocusScope.of(context).unfocus();
                                }
                                rechargeController.isShowPlanButton.value = true;
                              }
                            }
                          } catch (e) {
                            dismissProgressIndicator();
                          }
                        }
                      });
                    },
                    child: Icon(
                      Icons.contacts_rounded,
                      size: 18,
                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                    ),
                  ),
                  validator: (value) {
                    if (rechargeController.mobileNumberController.text.trim().isEmpty) {
                      return 'Please enter mobile number';
                    } else if (rechargeController.mobileNumberController.text.length < 10) {
                      return 'Please enter valid mobile number';
                    }
                    return null;
                  },
                ),
                // Operator
                CustomTextFieldWithTitle(
                  controller: rechargeController.operatorController,
                  title: 'Operator',
                  hintText: 'Select operator',
                  readOnly: true,
                  isCompulsory: true,
                  onTap: () async {
                    MasterOperatorListModel selectedOperator = await Get.toNamed(
                      Routes.SEARCHABLE_LIST_VIEW_WITH_IMAGE_SCREEN,
                      arguments: [
                        rechargeController.masterOperatorList, // modelList
                        'operatorList', // modelName
                      ],
                    );
                    if (selectedOperator.name != null && selectedOperator.name!.isNotEmpty) {
                      rechargeController.operatorController.text = selectedOperator.name!;
                      rechargeController.selectedOperatorCode.value = selectedOperator.apiCode!;
                    }
                  },
                  suffixIcon: Icon(
                    Icons.chevron_right_rounded,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (rechargeController.operatorController.text.trim().isEmpty) {
                      return 'Please select operator';
                    }
                    return null;
                  },
                ),
                // Circle
                CustomTextFieldWithTitle(
                  controller: rechargeController.circleController,
                  title: 'Circle',
                  hintText: 'Select circle',
                  readOnly: true,
                  isCompulsory: true,
                  onTap: () async {
                    MasterCircleListModel selectedCircle = await Get.toNamed(
                      Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                      arguments: [
                        rechargeController.masterCircleList, // modelList
                        'circleList', // listType
                      ],
                    );
                    if (selectedCircle.name != null && selectedCircle.name!.isNotEmpty) {
                      rechargeController.circleController.text = selectedCircle.name!;
                      rechargeController.selectedCircleCode.value = selectedCircle.code!;
                    }
                  },
                  suffixIcon: Icon(
                    Icons.chevron_right_rounded,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (rechargeController.circleController.text.trim().isEmpty) {
                      return 'Please select circle';
                    }
                    return null;
                  },
                ),
                // M-plans | R-plans
                Obx(
                  () => Visibility(
                    visible: rechargeController.isShowPlanButton.value == true ? true : false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (rechargeController.mobileNumberController.text.isEmpty) {
                              errorSnackBar(message: 'Please enter mobile number');
                            } else if (rechargeController.mobileNumberController.text.length < 10) {
                              errorSnackBar(message: 'Please enter valid  mobile number');
                            } else if (rechargeController.operatorController.text.isEmpty) {
                              errorSnackBar(message: 'Please select operator');
                            } else {
                              RPlanDetails selectedRPlan = await Get.toNamed(Routes.R_PLAN_SCREEN);
                              if (selectedRPlan.rs != null && selectedRPlan.rs!.isNotEmpty) {
                                rechargeController.amountController.text = selectedRPlan.rs!;
                                rechargeController.selectedPlanDescription.value = selectedRPlan.desc!;
                                if (rechargeController.amountController.text.isNotEmpty) {
                                  rechargeController.amountIntoWords.value = getAmountIntoWords(int.parse(rechargeController.amountController.text.trim()));
                                } else {
                                  rechargeController.amountIntoWords.value = '';
                                }
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: ColorsForApp.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'R-Plans',
                              style: TextHelper.size14.copyWith(
                                fontFamily: mediumGoogleSansFont,
                              ),
                            ),
                          ),
                        ),
                        width(3.w),
                        GestureDetector(
                          onTap: () async {
                            if (rechargeController.mobileNumberController.text.isEmpty) {
                              errorSnackBar(message: 'Please enter mobile number');
                            } else if (rechargeController.mobileNumberController.text.length < 10) {
                              errorSnackBar(message: 'Please enter valid  mobile number');
                            } else if (rechargeController.operatorController.text.isEmpty) {
                              errorSnackBar(message: 'Please select operator');
                            } else if (rechargeController.circleController.text.isEmpty) {
                              errorSnackBar(message: 'Please select circle');
                            } else {
                              MPlanDetails selectedMPlan = await Get.toNamed(Routes.M_PLAN_SCREEN);
                              if (selectedMPlan.rs != null && selectedMPlan.rs!.isNotEmpty) {
                                rechargeController.amountController.text = selectedMPlan.rs!;
                                rechargeController.selectedPlanDescription.value = selectedMPlan.desc!;
                                if (rechargeController.amountController.text.isNotEmpty) {
                                  rechargeController.amountIntoWords.value = getAmountIntoWords(int.parse(rechargeController.amountController.text.trim()));
                                } else {
                                  rechargeController.amountIntoWords.value = '';
                                }
                              }
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: ColorsForApp.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'M-Plans',
                              style: TextHelper.size14.copyWith(
                                fontFamily: mediumGoogleSansFont,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Amount
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Amount',
                        style: TextHelper.size14,
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: ColorsForApp.errorColor,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    height(0.8.h),
                    CustomTextField(
                      controller: rechargeController.amountController,
                      hintText: 'Enter amount',
                      maxLength: 7,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      suffixIcon: Icon(
                        Icons.currency_rupee_rounded,
                        size: 18,
                        color: ColorsForApp.secondaryColor.withOpacity(0.5),
                      ),
                      onChange: (value) {
                        if (rechargeController.amountController.text.isNotEmpty && int.parse(rechargeController.amountController.text.trim()) > 0) {
                          rechargeController.amountIntoWords.value = getAmountIntoWords(int.parse(rechargeController.amountController.text.trim()));
                        } else {
                          rechargeController.amountIntoWords.value = '';
                        }
                        rechargeController.selectedPlanDescription.value = '';
                      },
                      validator: (value) {
                        String amountText = rechargeController.amountController.text.trim();
                        if (amountText.isEmpty) {
                          return 'Please enter amount';
                        } else if (int.parse(amountText) <= 0) {
                          return 'Amount should be greater than 0';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                // Amount in text
                Obx(
                  () => Visibility(
                    visible: rechargeController.amountIntoWords.value.isNotEmpty ? true : false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(0.6.h),
                        Text(
                          rechargeController.amountIntoWords.value,
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.successColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                height(1.5.h),
                // TPIN
                Visibility(
                  visible: rechargeController.isShowTpinField.value,
                  child: Obx(
                    () => CustomTextFieldWithTitle(
                      controller: rechargeController.tPinController,
                      title: 'TPIN',
                      hintText: 'Enter TPIN',
                      maxLength: 4,
                      isCompulsory: true,
                      obscureText: rechargeController.isShowTpin.value,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      suffixIcon: IconButton(
                        onPressed: () {
                          rechargeController.isShowTpin.value = !rechargeController.isShowTpin.value;
                        },
                        icon: Icon(
                          rechargeController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                          size: 18,
                          color: ColorsForApp.secondaryColor.withOpacity(0.5),
                        ),
                      ),
                      validator: (value) {
                        if (rechargeController.tPinController.text.trim().isEmpty) {
                          return 'Please enter TPIN';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                height(1.h),
                // Proceed button
                CommonButton(
                  label: 'Proceed',
                  onPressed: () async {
                    if (mobileRechargeFormKey.value.currentState!.validate()) {
                      confirmationBottomSheet();
                    }
                  },
                ),
                height(2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Confirm recharge dialog
  Future<dynamic> confirmationBottomSheet() {
    return customBottomSheet(
      isScrollControlled: true,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Recharge Confirmation',
          textAlign: TextAlign.center,
          style: TextHelper.size20.copyWith(
            fontFamily: boldGoogleSansFont,
          ),
        ),
        height(2.h),
        Center(
          child: Text(
            '₹ ${rechargeController.amountController.text.trim()}.00',
            style: TextHelper.h1.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.primaryColor,
            ),
          ),
        ),
        height(1.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: ColorsForApp.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Recharge for ${rechargeController.operatorController.text.trim()} - ${rechargeController.circleController.text.trim()}',
                style: TextHelper.size14,
              ),
              height(5),
              Text(
                '(+91 ${rechargeController.mobileNumberController.text.trim()})',
                style: TextHelper.size14,
              ),
            ],
          ),
        ),
        height(1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: ColorsForApp.lightBlackColor,
              ),
              width(5),
              Flexible(
                child: Text(
                  rechargeController.selectedPlanDescription.value.isNotEmpty ? rechargeController.selectedPlanDescription.value : 'No plan selected',
                  style: TextHelper.size13,
                ),
              ),
            ],
          ),
        ),
      ],
      isShowButton: true,
      buttonText: 'Recharge',
      onTap: () async {
        if (Get.isSnackbarOpen) {
          Get.back();
        }
        Get.back();
        rechargeController.rechargeStatus.value = -1;
        await Get.toNamed(
          Routes.RECHARGE_STATUS_SCREEN,
          arguments: 'mobile',
        );
        mobileRechargeFormKey.value = GlobalKey<FormState>();
      },
    );
  }
}

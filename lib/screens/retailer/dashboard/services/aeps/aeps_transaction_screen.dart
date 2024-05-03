import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/aeps_controller.dart';
import '../../../../../controller/retailer/retailer_dashboard_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/aeps/master/bank_list_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/dropdown_text_field_with_title.dart';
import '../../../../../widgets/network_image.dart';
import '../../../../../widgets/text_field.dart';
import '../../../../../widgets/text_field_with_title.dart';

class AepsTransactionScreen extends StatefulWidget {
  const AepsTransactionScreen({Key? key}) : super(key: key);
  @override
  State<AepsTransactionScreen> createState() => _AepsTransactionScreenState();
}

class _AepsTransactionScreenState extends State<AepsTransactionScreen> {
  final AepsController aepsController = Get.find();
  RetailerDashboardController retailerDashboardController = Get.find();

  final Rx<GlobalKey<FormState>> aepsPaymentFormKey = GlobalKey<FormState>().obs;
  RxBool isShowTpinField = false.obs;
  final String modelType = Get.arguments;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      await aepsController.getMasterBankList(isLoaderShow: false);
      await aepsController.getCashWithdrawLimit(isLoaderShow: false);
      isShowTpinField.value = checkTpinRequired(categoryCode: 'AEPS');
      dismissProgressIndicator();
    } catch (e) {
      isShowTpinField.value = false;
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    aepsController.resetAepsVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 11.h + 103,
      title: 'AEPS',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        height: 11.h + 103,
        width: 100.w,
        decoration: BoxDecoration(
          color: ColorsForApp.lightBlueColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // AEPS top widget
            Container(
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
                    child: const ShowNetworkImage(
                      networkUrl: Assets.imagesAepsTopBg,
                      isAssetImage: true,
                    ),
                  ),
                  width(2.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AEPS',
                          style: TextHelper.size14.copyWith(
                            fontFamily: boldGoogleSansFont,
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                        height(0.5.h),
                        Text(
                          'AEPS offers a reliable and user-friendly method for secure digital payments, reinforcing trust in financial transactions.',
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
            height(1.h),
            // Balance-Enquiry | Cash-Withdraw | Mini-Statement | Aadhar-Pay
            Obx(
              () => Container(
                width: 92.w,
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        title: 'Cash Withdraw',
                        image: Assets.iconsCashWithdraw,
                        isSelected: aepsController.selectedAepsType.value == 0 ? true : false,
                        onTap: () {
                          aepsController.selectedAepsType.value = 0;
                          aepsController.isAmountVisible.value = true;
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: CustomButton(
                        title: 'Balance Enquiry',
                        image: Assets.iconsBalanceEnquiry,
                        isSelected: aepsController.selectedAepsType.value == 1 ? true : false,
                        onTap: () {
                          aepsController.selectedAepsType.value = 1;
                          aepsController.isAmountVisible.value = false;
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: CustomButton(
                        title: 'Mini Statements',
                        image: Assets.iconsMiniStatement,
                        isSelected: aepsController.selectedAepsType.value == 2 ? true : false,
                        onTap: () {
                          aepsController.selectedAepsType.value = 2;
                          aepsController.isAmountVisible.value = false;
                        },
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: CustomButton(
                        title: 'Aadhar Pay',
                        image: Assets.iconsAadharPay,
                        isSelected: aepsController.selectedAepsType.value == 3 || modelType == 'Aadhar Pay' ? true : false,
                        onTap: () {
                          aepsController.selectedAepsType.value = 3;
                          aepsController.isAmountVisible.value = true;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      mainBody: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height(2.h),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Obx(
                () => Form(
                  key: aepsPaymentFormKey.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bank
                      CustomTextFieldWithTitle(
                        controller: aepsController.bankController,
                        title: 'Bank',
                        hintText: 'Select bank',
                        readOnly: true,
                        isCompulsory: true,
                        onTap: () async {
                          MasterBankListModel selectedBank = await Get.toNamed(
                            Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                            arguments: [
                              aepsController.masterBankList, // modelList
                              'bankList', // modelName
                            ],
                          );
                          if (selectedBank.bankName != null && selectedBank.bankName!.isNotEmpty) {
                            aepsController.bankController.text = selectedBank.bankName!;
                            aepsController.selectedBankId.value = selectedBank.id!;
                          }
                        },
                        validator: (value) {
                          if (aepsController.bankController.text.trim().isEmpty) {
                            return 'Please select bank';
                          }
                          return null;
                        },
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            MasterBankListModel selectedBank = await Get.toNamed(
                              Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                              arguments: [
                                aepsController.masterBankList, // modelList
                                'bankList', // modelName
                              ],
                            );
                            if (selectedBank.bankName != null && selectedBank.bankName!.isNotEmpty) {
                              aepsController.bankController.text = selectedBank.bankName!;
                              aepsController.selectedBankId.value = selectedBank.id!;
                            }
                          },
                          child: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: ColorsForApp.greyColor,
                          ),
                        ),
                      ),
                      // Aadhar number
                      CustomTextFieldWithTitle(
                        controller: aepsController.aadharNumberController,
                        title: 'Aadhaar number',
                        hintText: "Enter aadhaar number",
                        maxLength: 12,
                        isCompulsory: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (aepsController.aadharNumberController.text.trim().isEmpty) {
                            return 'Please enter aadhar number';
                          } else if (aepsController.aadharNumberController.text.length < 12) {
                            return 'Please enter valid aadhar number';
                          }
                          return null;
                        },
                      ),
                      // Mobile number
                      CustomTextFieldWithTitle(
                        controller: aepsController.mobileNumberController,
                        title: 'Mobile number',
                        hintText: "Enter mobile number",
                        maxLength: 10,
                        isCompulsory: true,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                        validator: (value) {
                          if (aepsController.mobileNumberController.text.trim().isEmpty) {
                            return 'Please enter mobile number';
                          } else if (aepsController.mobileNumberController.text.length < 10) {
                            return 'Please enter valid mobile number';
                          }
                          return null;
                        },
                      ),
                      // Amount for aadhar pay
                      Obx(
                        () => Visibility(
                          visible: aepsController.isAmountVisible.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    controller: aepsController.amountController,
                                    hintText: 'Enter the amount',
                                    maxLength: 7,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    textInputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    obscureText: false,
                                    onChange: (value) {
                                      if (aepsController.amountController.text.isNotEmpty && int.parse(aepsController.amountController.text.trim()) >= 50) {
                                        aepsController.amountIntoWords.value = getAmountIntoWords(int.parse(aepsController.amountController.text.trim()));
                                      } else {
                                        aepsController.amountIntoWords.value = '';
                                      }
                                    },
                                    validator: (value) {
                                      // For cash withdraw
                                      if (aepsController.selectedAepsType.value == 0) {
                                        if (aepsController.amountController.text.trim().isEmpty) {
                                          return 'Please enter amount';
                                        } else if (int.parse(aepsController.amountController.text.trim()) <= 0) {
                                          return 'Amount should be greater than 0 ';
                                        } else {
                                          // Check cashWithdraw limit is not empty
                                          if (aepsController.cashWithDrawLimitList.isNotEmpty) {
                                            if (int.parse(aepsController.amountController.text.trim()) < int.parse(aepsController.cashWithDrawLimitList[0].singleTransactionLowerLimit.toString())) {
                                              return 'Amount should be greater than ${int.parse(aepsController.cashWithDrawLimitList[0].singleTransactionLowerLimit.toString()) - 1} ';
                                            } else if (int.parse(aepsController.amountController.text.trim()) > int.parse(aepsController.cashWithDrawLimitList[0].singleTransactionUpperLimit.toString())) {
                                              return 'Amount should be less than ${int.parse(aepsController.cashWithDrawLimitList[0].singleTransactionUpperLimit.toString()) + 1} ';
                                            } else if (aepsController.cashWithDrawLimitList[0].dailyTransactionLimit != null && aepsController.cashWithDrawLimitList[0].dailyTransactionLimit != 0) {
                                              if (int.parse(aepsController.amountController.text.trim()) % int.parse(aepsController.cashWithDrawLimitList[0].dailyTransactionLimit.toString()) != 0) {
                                                return 'Amount must be in multiple of ${aepsController.cashWithDrawLimitList[0].dailyTransactionLimit.toString()}';
                                              }
                                            }
                                            return null;
                                          } else {
                                            if (int.parse(aepsController.amountController.text.trim()) % 50 != 0) {
                                              return 'Amount must be in multiple of 50';
                                            }
                                            return null;
                                          }
                                        }
                                      }
                                      // For aadhar pay
                                      else if (aepsController.selectedAepsType.value == 3) {
                                        if (aepsController.amountController.text.trim().isEmpty) {
                                          return 'Please enter amount';
                                        } else if (int.parse(aepsController.amountController.text.trim()) <= 0) {
                                          return 'Amount should be greater than 0';
                                        } else if (int.parse(aepsController.amountController.text.trim()) % 50 != 0) {
                                          return 'Amount must be in multiple of 50';
                                        }
                                        return null;
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              // Amount in text
                              Obx(
                                () => Visibility(
                                  visible: aepsController.amountIntoWords.value.isNotEmpty ? true : false,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      height(0.6.h),
                                      Text(
                                        aepsController.amountIntoWords.value,
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
                            ],
                          ),
                        ),
                      ),
                      // Select biometric device
                      Obx(
                        () => CustomDropDownTextFieldWithTitle(
                          title: 'Biometric device',
                          hintText: 'Select biometric device',
                          isCompulsory: true,
                          value: aepsController.selectedBiometricDevice.value,
                          options: biomatricDeviceList.map(
                            (element) {
                              return element;
                            },
                          ).toList(),
                          onChanged: (value) async {
                            aepsController.selectedBiometricDevice.value = value!;
                          },
                          validator: (value) {
                            if (aepsController.selectedBiometricDevice.value.isEmpty || aepsController.selectedBiometricDevice.value == 'Select biometric device') {
                              return 'Please select biometric device';
                            }
                            return null;
                          },
                        ),
                      ),
                      // Tpin
                      Visibility(
                        visible: isShowTpinField.value,
                        child: Obx(
                          () => CustomTextFieldWithTitle(
                            controller: aepsController.tPinController,
                            title: 'TPIN',
                            hintText: 'Enter TPIN',
                            maxLength: 4,
                            isCompulsory: true,
                            obscureText: aepsController.isShowTpin.value,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            suffixIcon: IconButton(
                              icon: Icon(
                                aepsController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                                size: 18,
                                color: ColorsForApp.secondaryColor,
                              ),
                              onPressed: () {
                                aepsController.isShowTpin.value = !aepsController.isShowTpin.value;
                              },
                            ),
                            textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                            validator: (value) {
                              if (aepsController.tPinController.text.trim().isEmpty) {
                                return 'Please enter TPIN';
                              } else if (aepsController.tPinController.text.length < 4) {
                                return 'Please enter valid TPIN';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      // Authentication before transaction
                      Visibility(
                        visible: aepsController.selectedAepsType.value == 0 || aepsController.selectedAepsType.value == 3 ? true : false,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(
                              () => Checkbox(
                                activeColor: ColorsForApp.primaryColor,
                                value: aepsController.isAuthBeforeTransaction.value,
                                onChanged: (bool? value) {
                                  if (aepsController.isAuthBeforeTransaction.value == false) {
                                    authenticationForTransactionDialog(context);
                                  }
                                },
                                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                            width(4),
                            Expanded(
                              child: Text(
                                'Complete 2FA authentication before transaction',
                                style: TextHelper.size13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      height(3.h),
                      // Proceed button
                      CommonButton(
                        bgColor: ColorsForApp.primaryColor,
                        labelColor: ColorsForApp.whiteColor,
                        label: 'Proceed',
                        onPressed: () async {
                          if (aepsPaymentFormKey.value.currentState!.validate()) {
                            if (aepsController.selectedAepsType.value == 0 || aepsController.selectedAepsType.value == 3) {
                              if (aepsController.isAuthBeforeTransaction.value == true) {
                                await captureAndDisplayFingerprint(context);
                              } else {
                                errorSnackBar(message: 'Please complete 2FA authentication before doing transaction');
                              }
                            } else {
                              await captureAndDisplayFingerprint(context);
                            }
                          }
                        },
                      ),
                      height(20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Capture and display fingerprint
  Future<void> captureAndDisplayFingerprint(BuildContext context) async {
    String capturedData = await captureFingerprint(
      device: aepsController.selectedBiometricDevice.value,
      paymentGateway: aepsController.selectedPaymentGateway.value,
      isRegistration: false,
    );

    if (capturedData.isNotEmpty) {
      aepsController.capturedFingerData.value = capturedData;
      if (context.mounted) {
        displayFingerprintSuccessDailog(context);
      }
    }
  }

  // Display authentication dialog for 2FA
  Future<dynamic> authenticationForTransactionDialog(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
            insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
            contentPadding: const EdgeInsets.all(20),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Retailer authentication for ${aepsController.selectedAepsType.value == 0 ? 'Cash Withdraw' : aepsController.selectedAepsType.value == 3 ? 'Aadhar Pay' : ''}',
                            style: TextHelper.size16.copyWith(
                              fontFamily: boldGoogleSansFont,
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                        width(5),
                        GestureDetector(
                          child: Image.asset(
                            Assets.iconsClose,
                            height: 25,
                            width: 25,
                          ),
                          onTap: () {
                            Get.back();
                            aepsController.selectedBiometricDevice.value = 'Select biometric device';
                          },
                        ),
                      ],
                    ),
                    height(2.h),
                    Text(
                      'Proceed with your aadhar and mobile for transaction',
                      style: TextHelper.size14.copyWith(
                        fontFamily: mediumGoogleSansFont,
                      ),
                    ),
                    height(1.h),
                    // Aadhar number
                    CustomTextFieldWithTitle(
                      controller: aepsController.authAadharNumberController,
                      title: 'Aadhaar number',
                      hintText: '',
                      readOnly: true,
                      isCompulsory: true,
                    ),
                    // Mobile number
                    CustomTextFieldWithTitle(
                      controller: aepsController.authMobileNumberController,
                      title: 'Mobile number',
                      hintText: '',
                      readOnly: true,
                      isCompulsory: true,
                    ),
                    // Select biometric device
                    Obx(
                      () => CustomDropDownTextFieldWithTitle(
                        title: 'Biometric device',
                        hintText: 'Select biometric device',
                        isCompulsory: true,
                        value: aepsController.selectedBiometricDevice.value,
                        options: biomatricDeviceList.map(
                          (element) {
                            return element;
                          },
                        ).toList(),
                        onChanged: (value) async {
                          aepsController.selectedBiometricDevice.value = value!;
                        },
                        validator: (value) {
                          if (aepsController.selectedBiometricDevice.value.isEmpty || aepsController.selectedBiometricDevice.value == 'Select biometric device') {
                            return 'Please select biometric device';
                          }
                          return null;
                        },
                      ),
                    ),
                    height(2.5.h),
                    GestureDetector(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          String capturedData = await captureFingerprint(
                            device: aepsController.selectedBiometricDevice.value,
                            paymentGateway: aepsController.selectedPaymentGateway.value,
                            isRegistration: false,
                          );
                          if (capturedData.isNotEmpty) {
                            aepsController.capturedFingerData.value = capturedData;
                            await aepsController.twoFaAuthenticationForTransaction();
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                        decoration: BoxDecoration(
                          color: ColorsForApp.primaryColor,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fingerprint,
                              size: 25,
                              color: ColorsForApp.whiteColor,
                            ),
                            width(3.w),
                            Text(
                              'Capture Fingerprint',
                              style: TextHelper.size15.copyWith(
                                fontFamily: mediumGoogleSansFont,
                                color: ColorsForApp.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Success dailog of captured fingerprint
  displayFingerprintSuccessDailog(BuildContext context, {required}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          contentPadding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ColorsForApp.primaryColor,
                      width: 1,
                    ),
                  ),
                ),
                child: Icon(
                  Icons.fingerprint,
                  size: 70,
                  color: ColorsForApp.primaryColor,
                ),
              ),
              height(1.5.h),
              Text(
                '${aepsController.selectedBiometricDevice.value == 'MANTRA IRIS' ? 'Iris' : 'Fingerprint'} captured successfully',
                style: TextHelper.size15.copyWith(
                  fontFamily: boldGoogleSansFont,
                  color: ColorsForApp.successColor,
                ),
              ),
              height(0.5.h),
              Text(
                'Please confirm do you want to continue?',
                style: TextHelper.size14.copyWith(
                  fontFamily: regularGoogleSansFont,
                ),
              ),
              height(1.5.h),
              // Order type
              Container(
                width: 100.w,
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: ColorsForApp.lightGreyColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Order type',
                      style: TextHelper.size13,
                    ),
                    Text(
                      aepsController.aepsTypeList[aepsController.selectedAepsType.value],
                      style: TextHelper.size13.copyWith(
                        fontFamily: boldGoogleSansFont,
                      ),
                    ),
                  ],
                ),
              ),
              // Withdraw value
              Container(
                width: 100.w,
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Withdraw value',
                      style: TextHelper.size13,
                    ),
                    Text(
                      aepsController.selectedAepsType.value == 0 || aepsController.selectedAepsType.value == 3 ? '₹ ${aepsController.amountController.text.isNotEmpty ? aepsController.amountController.text.trim() : 0}' : '0',
                      style: TextHelper.size13.copyWith(
                        fontFamily: boldGoogleSansFont,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      Get.back();
                    },
                    splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                    highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(
                        'Cancel',
                        style: TextHelper.size14.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.primaryColorBlue,
                        ),
                      ),
                    ),
                  ),
                  width(1.w),
                  InkWell(
                    onTap: () async {
                      if (aepsController.selectedAepsType.value == 0) {
                        Get.back();
                        bool result = await aepsController.cashWithdraw();
                        if (result == true) {
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          cashWithdrawBottomSheet();
                        }
                      } else if (aepsController.selectedAepsType.value == 1) {
                        Get.back();
                        bool result = isMiniApiOnBalanceEnquiry.isTrue? await aepsController.miniStatement(): await aepsController.balanceEnquiry();
                        if (result == true) {
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          balanceEnquiryBottomSheet();
                        }
                      } else if (aepsController.selectedAepsType.value == 2) {
                        Get.back();
                        bool result = await aepsController.miniStatement();
                        if (result == true) {
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          if (aepsController.transactionList.isNotEmpty) {
                            await Get.toNamed(Routes.AEPS_MINI_STATEMENT_SCREEN);
                            aepsPaymentFormKey.value = GlobalKey<FormState>();
                          } else {
                            errorSnackBar(message: 'No transactions found');
                          }
                        }
                      } else if (aepsController.selectedAepsType.value == 3) {
                        Get.back();
                        bool result = await aepsController.aadharPay();
                        if (result == true) {
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          aadharPayBottomSheet();
                        }
                      }
                    },
                    splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                    highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(
                        'Proceed',
                        style: TextHelper.size14.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.primaryColorBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // Cash withdraw bottomsheet
  Future<dynamic> cashWithdrawBottomSheet() {
    playSuccessSound();
    return Get.bottomSheet(
      Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 2.5,
                width: 30.w,
                decoration: BoxDecoration(
                  color: ColorsForApp.greyColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            height(15),
            Text(
              'Cash Withdraw',
              textAlign: TextAlign.center,
              style: TextHelper.size20.copyWith(
                fontFamily: boldGoogleSansFont,
              ),
            ),
            height(15),
            Text(
              '₹ ${aepsController.cashWithdrawModel.value.data!.amount != null ? aepsController.cashWithdrawModel.value.data!.amount! : '-'}',
              style: TextHelper.h1.copyWith(
                fontFamily: mediumGoogleSansFont,
                color: ColorsForApp.primaryColor,
              ),
            ),
            height(8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: ColorsForApp.greyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //agent name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agent name: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          retailerDashboardController.userBasicDetails.value.ownerName != null && retailerDashboardController.userBasicDetails.value.ownerName!.isNotEmpty ? retailerDashboardController.userBasicDetails.value.ownerName!.trim() : '',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.6.h),
                  //bank name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank name: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          aepsController.cashWithdrawModel.value.data!.adhaarNo != null && aepsController.cashWithdrawModel.value.data!.adhaarNo!.isNotEmpty
                              ? aepsController.cashWithdrawModel.value.data!.adhaarNo!
                              : aepsController.aadharNumberController.text.trim().toString(),
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.6.h),
                  //aadhaar number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aadhar number: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          aepsController.cashWithdrawModel.value.data!.adhaarNo != null && aepsController.cashWithdrawModel.value.data!.adhaarNo!.isNotEmpty
                              ? aepsController.cashWithdrawModel.value.data!.adhaarNo!
                              : aepsController.aadharNumberController.text.trim().toString(),
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.6.h),
                  //Txn ID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Txn ID: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          aepsController.cashWithdrawModel.value.orderId != null && aepsController.cashWithdrawModel.value.orderId!.isNotEmpty ? aepsController.cashWithdrawModel.value.orderId! : '-',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.6.h),
                  //RRN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RRN: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          aepsController.cashWithdrawModel.value.data!.rrn != null && aepsController.cashWithdrawModel.value.data!.rrn!.isNotEmpty ? aepsController.cashWithdrawModel.value.data!.rrn! : '-',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.6.h),
                  //Available balance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available balance: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          aepsController.cashWithdrawModel.value.data!.availableBalance != null && aepsController.cashWithdrawModel.value.data!.availableBalance!.isNotEmpty ? aepsController.cashWithdrawModel.value.data!.availableBalance! : '-',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // height(0.6.h),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'Date & Time: ',
                  //       style: TextHelper.size13.copyWith(
                  //         fontFamily: mediumFont,
                  //         color: ColorsForApp.greyColor,
                  //       ),
                  //     ),
                  //     width(5),
                  //     Flexible(
                  //       child: Text(
                  //         aepsController.cashWithdrawModel.value.data!.txnDate != null && aepsController.cashWithdrawModel.value.data!.txnDate!.isNotEmpty
                  //             ? aepsController.cashWithdrawModel.value.data!.txnTime != null && aepsController.cashWithdrawModel.value.data!.txnTime!.isNotEmpty
                  //                 ? '${aepsController.cashWithdrawModel.value.data!.txnDate!}, ${aepsController.cashWithdrawModel.value.data!.txnTime!}'
                  //                 : aepsController.cashWithdrawModel.value.data!.txnDate!
                  //             : '-',
                  //         textAlign: TextAlign.start,
                  //         style: TextHelper.size13.copyWith(
                  //           fontFamily: regularFont,
                  //           color: ColorsForApp.blackColor,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            height(20),
            Row(
              children: [
                // Done
                Expanded(
                  child: CommonButton(
                    onPressed: () {
                      if (Get.isSnackbarOpen) {
                        Get.back();
                      }
                      Get.back();
                      aepsController.resetAepsVariables();
                      aepsPaymentFormKey.value = GlobalKey<FormState>();
                    },
                    label: 'Done',
                    border: Border.all(color: ColorsForApp.primaryColor),
                    bgColor: ColorsForApp.whiteColor,
                    labelColor: ColorsForApp.primaryColor,
                  ),
                ),
                width(5.w),
                // Receipt
                Expanded(
                  child: CommonButton(
                    onPressed: () {
                      Get.toNamed(
                        Routes.RECEIPT_SCREEN,
                        arguments: [
                          aepsController.cashWithdrawModel.value.orderId.toString(), // Transaction id
                          0, // 0 for single, 1 for bulk
                          'AEPSCW', // Design
                        ],
                      );
                    },
                    label: 'Receipt',
                    bgColor: ColorsForApp.primaryColor,
                    labelColor: ColorsForApp.whiteColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      enableDrag: false,
      isDismissible: false,
    );
  }

  // Balance enquiry bottomsheet
  Future<dynamic> balanceEnquiryBottomSheet() {
    playSuccessSound();
    return Get.bottomSheet(
      WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Container(
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: ColorsForApp.whiteColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 2.5,
                  width: 30.w,
                  decoration: BoxDecoration(
                    color: ColorsForApp.greyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              height(15),
              Text(
                'Balance Enquiry',
                textAlign: TextAlign.center,
                style: TextHelper.size20.copyWith(
                  fontFamily: boldGoogleSansFont,
                ),
              ),
              height(15),
              Text(
                '₹ ${aepsController.balanceEnquiryModel.value.data!.availableBalance != null && aepsController.balanceEnquiryModel.value.data!.availableBalance!.isNotEmpty ? aepsController.balanceEnquiryModel.value.data!.availableBalance! : '-'}',
                style: TextHelper.h1.copyWith(
                  fontFamily: mediumGoogleSansFont,
                  color: ColorsForApp.primaryColor,
                ),
              ),
              height(8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: ColorsForApp.greyColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //agent name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Agent name: ',
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.greyColor,
                          ),
                        ),
                        width(5),
                        Flexible(
                          child: Text(
                            retailerDashboardController.userBasicDetails.value.ownerName != null && retailerDashboardController.userBasicDetails.value.ownerName!.isNotEmpty ? retailerDashboardController.userBasicDetails.value.ownerName!.trim() : '',
                            textAlign: TextAlign.start,
                            style: TextHelper.size13.copyWith(
                              fontFamily: regularGoogleSansFont,
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    height(0.6.h),
                    //bank name
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bank name: ',
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.greyColor,
                          ),
                        ),
                        width(5),
                        Flexible(
                          child: Text(
                            aepsController.balanceEnquiryModel.value.data!.bankName != null && aepsController.balanceEnquiryModel.value.data!.bankName!.isNotEmpty
                                ? aepsController.balanceEnquiryModel.value.data!.bankName!
                                : aepsController.bankController.text.trim().toString(),
                            textAlign: TextAlign.start,
                            style: TextHelper.size13.copyWith(
                              fontFamily: regularGoogleSansFont,
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    height(0.6.h),
                    //aadhaar
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aadhaar number: ',
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.greyColor,
                          ),
                        ),
                        width(5),
                        Flexible(
                          child: Text(
                            aepsController.balanceEnquiryModel.value.data!.adhaarNo != null && aepsController.balanceEnquiryModel.value.data!.adhaarNo!.isNotEmpty
                                ? aepsController.balanceEnquiryModel.value.data!.adhaarNo!
                                : aepsController.aadharNumberController.text.trim().toString(),
                            textAlign: TextAlign.start,
                            style: TextHelper.size13.copyWith(
                              fontFamily: regularGoogleSansFont,
                              color: ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              height(20),
              Row(
                children: [
                  // Done
                  Expanded(
                    child: CommonButton(
                      onPressed: () {
                        if (Get.isSnackbarOpen) {
                          Get.back();
                        }
                        Get.back();
                        aepsController.resetAepsVariables();
                        aepsPaymentFormKey.value = GlobalKey<FormState>();
                      },
                      label: 'Done',
                      border: Border.all(color: ColorsForApp.primaryColor),
                      bgColor: ColorsForApp.whiteColor,
                      labelColor: ColorsForApp.primaryColor,
                    ),
                  ),
                  width(5.w),
                  // Receipt
                  Expanded(
                    child: CommonButton(
                      onPressed: () {
                        Get.toNamed(
                          Routes.BALANCE_ENQUIRY_RECEIPT_SCREEN,
                          arguments: aepsController.balanceEnquiryModel.value,
                        );
                      },
                      label: 'Receipt',
                      bgColor: ColorsForApp.primaryColor,
                      labelColor: ColorsForApp.whiteColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      enableDrag: false,
      isDismissible: false,
    );
  }

  // Aadhar pay bottomsheet
  Future<dynamic> aadharPayBottomSheet() {
    playSuccessSound();
    return Get.bottomSheet(
      Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 2.5,
                width: 30.w,
                decoration: BoxDecoration(
                  color: ColorsForApp.greyColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            height(15),
            Text(
              'Aadhar Pay',
              textAlign: TextAlign.center,
              style: TextHelper.size20.copyWith(
                fontFamily: boldGoogleSansFont,
              ),
            ),
            height(15),
            Text(
              '₹ ${aepsController.aadharPayModel.value.data!.amount != null ? aepsController.aadharPayModel.value.data!.amount! : '-'}',
              style: TextHelper.h1.copyWith(
                fontFamily: mediumGoogleSansFont,
                color: ColorsForApp.primaryColor,
              ),
            ),
            height(8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: ColorsForApp.greyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //agent name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Agent name: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          retailerDashboardController.userBasicDetails.value.ownerName != null && retailerDashboardController.userBasicDetails.value.ownerName!.isNotEmpty ? retailerDashboardController.userBasicDetails.value.ownerName!.trim() : '',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.5.h),
                  //bank name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bank name: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          aepsController.aadharPayModel.value.data!.bankName != null && aepsController.aadharPayModel.value.data!.bankName!.isNotEmpty ? aepsController.aadharPayModel.value.data!.bankName! : '-',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.5.h),
                  //aadhaar number
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aadhaar number: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          aepsController.aadharPayModel.value.data!.adhaarNo != null && aepsController.aadharPayModel.value.data!.adhaarNo!.isNotEmpty ? aepsController.aadharPayModel.value.data!.adhaarNo! : '-',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.5.h),
                  //RRN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RRN: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          aepsController.aadharPayModel.value.data!.rrn != null && aepsController.aadharPayModel.value.data!.rrn!.isNotEmpty ? aepsController.aadharPayModel.value.data!.rrn! : '-',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.5.h),
                  //date and time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date & Time: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          aepsController.aadharPayModel.value.data!.txnDate != null && aepsController.aadharPayModel.value.data!.txnDate!.isNotEmpty
                              ? aepsController.aadharPayModel.value.data!.txnTime != null && aepsController.aadharPayModel.value.data!.txnTime!.isNotEmpty
                                  ? '${aepsController.aadharPayModel.value.data!.txnDate!}, ${aepsController.aadharPayModel.value.data!.txnTime!}'
                                  : aepsController.aadharPayModel.value.data!.txnDate!
                              : '-',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.5.h),
                  //available balance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available balance: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Flexible(
                        child: Text(
                          aepsController.aadharPayModel.value.data!.availableBalance != null && aepsController.aadharPayModel.value.data!.availableBalance!.isNotEmpty ? aepsController.aadharPayModel.value.data!.availableBalance! : '-',
                          textAlign: TextAlign.start,
                          style: TextHelper.size13.copyWith(
                            fontFamily: regularGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            height(20),
            CommonButton(
              label: 'Done',
              onPressed: () async {
                if (Get.isSnackbarOpen) {
                  Get.back();
                }
                Get.back();
                aepsController.resetAepsVariables();
                aepsPaymentFormKey.value = GlobalKey<FormState>();
              },
            ),
          ],
        ),
      ),
      enableDrag: false,
      isDismissible: false,
    );
  }
}

class CustomButton extends StatelessWidget {
  final String image;
  final String title;
  final Function()? onTap;
  final bool isSelected;
  const CustomButton({
    Key? key,
    required this.image,
    required this.title,
    this.onTap,
    required this.isSelected,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: ColorsForApp.lightGreyColor,
            border: Border(
              bottom: BorderSide(
                color: isSelected == true ? ColorsForApp.primaryColor : ColorsForApp.accentColor,
                width: 3,
              ),
            ),
          ),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: ColorsForApp.whiteColor,
              borderRadius: BorderRadius.circular(7),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  image,
                  height: 35,
                  width: 35,
                ),
                height(10),
                Text(
                  title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextHelper.size13,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';

import '../../controller/retailer/aeps_settlement_controller.dart';
import '../../model/aeps_settlement/aeps_bank_list_model.dart';
import '../../model/kyc/kyc_bank_list_model.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/permission_handler.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/text_field_with_title.dart';

class AepsAddBankScreen extends StatefulWidget {
  const AepsAddBankScreen({super.key});

  @override
  State<AepsAddBankScreen> createState() => _AepsAddBankScreenState();
}

class _AepsAddBankScreenState extends State<AepsAddBankScreen> {
  final AepsSettlementController aepsSettlementController = Get.find();
  final GlobalKey<FormState> addBankFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addUpiFormKey = GlobalKey<FormState>();

  late AepsBankListModel aepsBankData;

  @override
  void dispose() {
    aepsSettlementController.resetAepsSettlementBankVariables();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rejectedBankVariableDeclaration();
  }

  rejectedBankVariableDeclaration() async {
    aepsSettlementController.settlementAccountVerificationModel.value.name = "";
    aepsSettlementController.isAccountVerify.value = false;
    await aepsSettlementController.getBankListApi();
    if (Get.arguments != null) {
      showProgressIndicator();
      aepsBankData = Get.arguments;
      await Future.delayed(const Duration(seconds: 1), () async {
        aepsSettlementController.accountHolderNameBankController.text = aepsBankData.acHolderName!;
        aepsSettlementController.accountNumberController.text = aepsBankData.accountNumber!;
        aepsSettlementController.ifscCodeController.text = aepsBankData.ifsCCode!;
        aepsSettlementController.bankNameController.text = aepsBankData.bankName!;
        aepsSettlementController.selectedAccountTypeRadio.value = aepsBankData.accountType! == 0 ? 'Current' : 'Saving';
        aepsSettlementController.bankRemarksController.text = aepsBankData.createRemark ?? "";
        aepsSettlementController.bankChequeRejectedFile.value = aepsBankData.fileUrl ?? "";
      });
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScaffold(
        title: 'Add ${aepsSettlementController.selectedBankPaymentMethodRadio.value}',
        isShowLeadingIcon: true,
        mainBody: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(2.h),
                // Select payment method
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Payment Method',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorsForApp.lightBlackColor,
                    ),
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
                // Payment method radio
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Radio(
                      value: 'Bank',
                      groupValue: aepsSettlementController.selectedBankPaymentMethodRadio.value,
                      onChanged: (value) {
                        aepsSettlementController.selectedBankPaymentMethodRadio.value = value!;
                        resetUpiVariable();
                      },
                      activeColor: ColorsForApp.primaryColor,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    ),
                    width(5),
                    GestureDetector(
                      onTap: () {
                        aepsSettlementController.selectedBankPaymentMethodRadio.value = 'Bank';
                        resetUpiVariable();
                      },
                      child: Text(
                        'Bank',
                        style: TextHelper.size14.copyWith(
                          color: aepsSettlementController.selectedBankPaymentMethodRadio.value == 'Bank' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                          fontFamily: aepsSettlementController.selectedBankPaymentMethodRadio.value == 'Bank' ? mediumGoogleSansFont : regularGoogleSansFont,
                        ),
                      ),
                    ),
                    width(15),
                    Radio(
                      value: 'UPI',
                      groupValue: aepsSettlementController.selectedBankPaymentMethodRadio.value,
                      onChanged: (value) {
                        aepsSettlementController.selectedBankPaymentMethodRadio.value = value!;
                        resetBankVariables();
                      },
                      activeColor: ColorsForApp.primaryColor,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    ),
                    width(5),
                    GestureDetector(
                      onTap: () {
                        aepsSettlementController.selectedBankPaymentMethodRadio.value = 'UPI';
                        resetBankVariables();
                      },
                      child: Text(
                        'UPI',
                        style: TextHelper.size14.copyWith(
                          color: aepsSettlementController.selectedBankPaymentMethodRadio.value == 'UPI' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                          fontFamily: aepsSettlementController.selectedBankPaymentMethodRadio.value == 'UPI' ? mediumGoogleSansFont : regularGoogleSansFont,
                        ),
                      ),
                    ),
                  ],
                ),
                height(1.h),
                aepsSettlementController.selectedBankPaymentMethodRadio.value == 'Bank' ? paymentMethodBank(context) : paymentMethodUpi(),
                height(2.h),
                // Add bank/upi button
                CommonButton(
                  onPressed: () async {
                    if (aepsSettlementController.selectedBankPaymentMethodRadio.value == 'Bank' ? addBankFormKey.currentState!.validate() : addUpiFormKey.currentState!.validate()) {
                      showProgressIndicator();
                      if (isSettlementBankAccountVerify.isTrue && aepsSettlementController.selectedBankPaymentMethodRadio.value == 'Bank') {
                        if (aepsSettlementController.isAccountVerify.isTrue) {
                          await aepsSettlementController.addAepsSettlementBank(isLoaderShow: false);
                        } else {
                          errorSnackBar(message: "Please verify bank account");
                        }
                      } else {
                        await aepsSettlementController.addAepsSettlementBank(isLoaderShow: false);
                      }
                      dismissProgressIndicator();
                    }
                  },
                  label: 'Add ${aepsSettlementController.selectedBankPaymentMethodRadio.value}',
                ),
                height(2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Image souce dailog
  Future<dynamic> imageSourceDailog(BuildContext context) {
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
              color: ColorsForApp.lightBlackColor.withOpacity(0.7),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    File capturedFile = File(await captureImage());
                    if (capturedFile.path.isNotEmpty) {
                      int fileSize = capturedFile.lengthSync();
                      int maxAllowedSize = 6 * 1024 * 1024;
                      if (fileSize > maxAllowedSize) {
                        errorSnackBar(message: 'File size should be less than 6 MB');
                      } else {
                        aepsSettlementController.bankChequeFile.value = capturedFile;
                      }
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
                      (bool photoPermission) async {
                        if (photoPermission == true) {
                          Get.back();
                          await openImagePicker(ImageSource.gallery).then(
                            (pickedFile) async {
                              if (pickedFile.path.isNotEmpty || pickedFile.path != '') {
                                int fileSize = pickedFile.lengthSync();
                                int maxAllowedSize = 6 * 1024 * 1024;
                                String fileExtension = extension(pickedFile.path);
                                if (fileSize > maxAllowedSize) {
                                  errorSnackBar(message: 'File size should be less than 6 MB');
                                } else {
                                  if (fileExtension.toLowerCase() == '.jpeg' || fileExtension.toLowerCase() == '.jpg' || fileExtension.toLowerCase() == '.png') {
                                    aepsSettlementController.bankChequeFile.value = pickedFile;
                                  } else {
                                    errorSnackBar(message: 'Unsupported Format');
                                  }
                                }
                              }
                            },
                          );
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

  Widget paymentMethodBank(BuildContext context) {
    return Obx(
      () => Form(
        key: addBankFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account holder name
            CustomTextFieldWithTitle(
              controller: aepsSettlementController.accountHolderNameBankController,
              title: 'Account Holder Name',
              hintText: 'Account holder name',
              isCompulsory: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              textInputFormatter: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
              ],
              validator: (value) {
                if (aepsSettlementController.accountHolderNameBankController.text.trim().isEmpty) {
                  return 'Please enter account holder name';
                }
                return null;
              },
            ),
            // Bank name
            CustomTextFieldWithTitle(
              controller: aepsSettlementController.bankNameController,
              title: 'Bank Name',
              hintText: 'Bank name',
              isCompulsory: true,
              readOnly: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              textInputFormatter: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
              ],
              onTap: () async {
                KYCBankListModel selectedBank = await Get.toNamed(
                  Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                  arguments: [
                    aepsSettlementController.bankList,
                    'kycBankList',
                    // modelName
                  ],
                );
                if (selectedBank.bankName!.isNotEmpty) {
                  aepsSettlementController.bankNameController.text = selectedBank.bankName!;
                  aepsSettlementController.ifscCodeController.text = selectedBank.ifscCode!;
                  aepsSettlementController.isAccountVerify.value = false;
                  aepsSettlementController.settlementAccountVerificationModel.value.name = "";
                }
              },
              validator: (value) {
                if (aepsSettlementController.bankNameController.text.trim().isEmpty) {
                  return 'Please select bank name';
                }
                return null;
              },
              suffixIcon: Icon(
                Icons.arrow_drop_down_sharp,
                size: 18,
                color: ColorsForApp.secondaryColor,
              ),
              onChange: (value) {
                aepsSettlementController.isAccountVerify.value = false;
                aepsSettlementController.settlementAccountVerificationModel.value.name = "";
              },
            ),
            //IFSC
            CustomTextFieldWithTitle(
              controller: aepsSettlementController.ifscCodeController,
              title: 'IFSC  Code',
              hintText: 'IFSC code',
              maxLength: 11,
              isCompulsory: true,
              readOnly: aepsSettlementController.isAccountVerify.value == true ? true : false,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.characters,
              textInputFormatter: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
              ],
              validator: (value) {
                RegExp regex = RegExp(r"^[A-Z]{4}0[A-Z0-9]{6}$");
                if (aepsSettlementController.ifscCodeController.text.trim().isEmpty) {
                  return 'Please enter IFSC code';
                } else if (!regex.hasMatch(value!)) {
                  return 'Please enter valid IFSC code';
                }
                return null;
              },
            ),
            // Account number
            CustomTextFieldWithTitle(
                controller: aepsSettlementController.accountNumberController,
                title: 'Account Number',
                hintText: 'Account number',
                maxLength: 19,
                isCompulsory: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                suffixIcon: isSettlementBankAccountVerify.isTrue
                    ? GestureDetector(
                        onTap: () async {
                          if (aepsSettlementController.bankNameController.text.isEmpty) {
                            errorSnackBar(message: 'Please select bank name');
                          } else if (aepsSettlementController.ifscCodeController.text.isEmpty) {
                            errorSnackBar(message: 'Please enter ifsc code');
                          } else if (aepsSettlementController.accountNumberController.text.isEmpty) {
                            errorSnackBar(message: 'Please enter account number');
                          } else {
                            if (aepsSettlementController.ifscCodeController.text.isNotEmpty && aepsSettlementController.isAccountVerify.value == false) {
                              await aepsSettlementController.verifyAccount();
                            }
                          }
                        },
                        child: Obx(
                          () => Container(
                            width: 8.h,
                            decoration: BoxDecoration(
                              color: aepsSettlementController.isAccountVerify.value == true ? ColorsForApp.successColor.withOpacity(0.1) : ColorsForApp.primaryColorBlue.withOpacity(0.1),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                topRight: Radius.circular(7),
                                bottomRight: Radius.circular(7),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              aepsSettlementController.isAccountVerify.value == true ? 'Verified' : 'Verify',
                              style: TextHelper.size13.copyWith(
                                color: aepsSettlementController.isAccountVerify.value == true ? ColorsForApp.successColor : ColorsForApp.blackColor,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                validator: (value) {
                  if (aepsSettlementController.accountNumberController.text.isEmpty) {
                    return 'Please enter account number';
                  }
                  return null;
                },
                onChange: (value) {
                  aepsSettlementController.isAccountVerify.value = false;
                  aepsSettlementController.settlementAccountVerificationModel.value.name = "";
                }),
            Visibility(
                visible: (aepsSettlementController.settlementAccountVerificationModel.value.name ?? "").isNotEmpty ? true : false,
                child: Text(
                  aepsSettlementController.settlementAccountVerificationModel.value.name ?? "",
                  style: TextHelper.size13.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
                )),
            height(1.h),
            // Select account type
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Account Type',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: ColorsForApp.lightBlackColor,
                ),
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
            // Payment method radio
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                  value: 'Current',
                  groupValue: aepsSettlementController.selectedAccountTypeRadio.value,
                  onChanged: (value) {
                    aepsSettlementController.selectedAccountTypeRadio.value = value!;
                  },
                  activeColor: ColorsForApp.primaryColor,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                ),
                width(5),
                GestureDetector(
                  onTap: () {
                    aepsSettlementController.selectedAccountTypeRadio.value = 'Current';
                  },
                  child: Text(
                    'Current',
                    style: TextHelper.size14.copyWith(
                      color: aepsSettlementController.selectedAccountTypeRadio.value == 'Current' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                      fontFamily: aepsSettlementController.selectedAccountTypeRadio.value == 'Current' ? mediumGoogleSansFont : regularGoogleSansFont,
                    ),
                  ),
                ),
                width(15),
                Radio(
                  value: 'Saving',
                  groupValue: aepsSettlementController.selectedAccountTypeRadio.value,
                  onChanged: (value) {
                    aepsSettlementController.selectedAccountTypeRadio.value = value!;
                  },
                  activeColor: ColorsForApp.primaryColor,
                  visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                ),
                width(5),
                GestureDetector(
                  onTap: () {
                    aepsSettlementController.selectedAccountTypeRadio.value = 'Saving';
                  },
                  child: Text(
                    'Saving',
                    style: TextHelper.size14.copyWith(
                      color: aepsSettlementController.selectedAccountTypeRadio.value == 'Saving' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                      fontFamily: aepsSettlementController.selectedAccountTypeRadio.value == 'Saving' ? mediumGoogleSansFont : regularGoogleSansFont,
                    ),
                  ),
                ),
              ],
            ),
            height(1.h),
            // Remarks
            CustomTextFieldWithTitle(
              controller: aepsSettlementController.bankRemarksController,
              title: 'Remarks',
              hintText: 'Enter remarks',
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),
            // Bank cheque
            height(5),
            Text(
              'Upload Bank Cheque',
              style: TextHelper.size14.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            height(2),
            Text(
              'Bank cheque in jpg, png, jpeg format with maximum 6 MB can be uploaded.',
              style: TextHelper.size12.copyWith(
                color: ColorsForApp.errorColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            height(10),
            aepsSettlementController.bankChequeRejectedFile.value.isNotEmpty
                ? SizedBox(
                    height: 21.5.w,
                    width: 21.5.w,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        InkWell(
                          onTap: () async {
                            openUrl(url: aepsSettlementController.bankChequeRejectedFile.value);
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
                              child: Image.network(aepsSettlementController.bankChequeRejectedFile.value),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              aepsSettlementController.bankChequeRejectedFile.value = "";
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
                : aepsSettlementController.bankChequeFile.value.path.isNotEmpty
                    ? SizedBox(
                        height: 21.5.w,
                        width: 21.5.w,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            InkWell(
                              onTap: () async {
                                OpenResult openResult = await OpenFile.open(aepsSettlementController.bankChequeFile.value.path);
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
                                  child: Image.file(
                                    aepsSettlementController.bankChequeFile.value,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  aepsSettlementController.bankChequeFile.value = File('');
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
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              imageSourceDailog(context);
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
          ],
        ),
      ),
    );
  }

  Widget paymentMethodUpi() {
    return Obx(
      () => Form(
        key: addUpiFormKey,
        child: Column(
          children: [
            // Account holder name
            CustomTextFieldWithTitle(
              controller: aepsSettlementController.accountHolderNameUpiController,
              title: 'Account Holder Name',
              hintText: 'Account holder name',
              isCompulsory: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              textInputFormatter: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
              ],
              validator: (value) {
                if (aepsSettlementController.accountHolderNameUpiController.text.trim().isEmpty) {
                  return 'Please enter account holder name';
                }
                return null;
              },
            ),
            // UPI id
            CustomTextFieldWithTitle(
              controller: aepsSettlementController.upiIdController,
              title: 'UPI ID',
              hintText: 'UPI id',
              maxLength: 50,
              isCompulsory: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (value) {
                RegExp regex = RegExp(r"^[0-9A-Za-z.-]{2,256}@[A-Za-z]{2,64}$");
                if (aepsSettlementController.upiIdController.text.trim().isEmpty) {
                  return 'Please enter upi id';
                } else if (!regex.hasMatch(value!.trim())) {
                  return 'Please enter valid upi id';
                }
                return null;
              },
            ),
            // Remarks
            CustomTextFieldWithTitle(
              controller: aepsSettlementController.remarksController,
              title: 'Remarks',
              hintText: 'Enter remarks',
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),
          ],
        ),
      ),
    );
  }

  resetBankVariables() {
    aepsSettlementController.bankRemarksController.clear();
    aepsSettlementController.accountHolderNameBankController.clear();
    aepsSettlementController.upiIdController.clear();
    aepsSettlementController.selectedAccountTypeRadio.value = 'Current';
    aepsSettlementController.bankNameController.clear();
    aepsSettlementController.accountNumberController.clear();
    aepsSettlementController.ifscCodeController.clear();
    aepsSettlementController.bankChequeFile.value = File('');
    aepsSettlementController.settlementAccountVerificationModel.value.name = "";
    aepsSettlementController.isAccountVerify.value = false;
    aepsSettlementController.bankChequeRejectedFile.value = "";
  }

  resetUpiVariable() {
    aepsSettlementController.remarksController.clear();
    aepsSettlementController.upiIdController.clear();
    aepsSettlementController.accountHolderNameUpiController.clear();
  }
}

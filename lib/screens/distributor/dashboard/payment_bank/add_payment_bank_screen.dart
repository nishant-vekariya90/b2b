import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/permission_handler.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field_with_title.dart';
import '../../../../controller/distributor/payment_bank_controller.dart';

class AddPaymentBankScreen extends StatefulWidget {
  const AddPaymentBankScreen({super.key});

  @override
  State<AddPaymentBankScreen> createState() => _AddPaymentBankScreenState();
}

class _AddPaymentBankScreenState extends State<AddPaymentBankScreen> {
  final PaymentBankController paymentBankController = Get.find();
  final GlobalKey<FormState> addBankFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> addUpiFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    paymentBankController.resetAepsSettlementBankVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScaffold(
        title: 'Add ${paymentBankController.selectedBankPaymentMethodRadio.value}',
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
                      groupValue: paymentBankController.selectedBankPaymentMethodRadio.value,
                      onChanged: (value) {
                        paymentBankController.selectedBankPaymentMethodRadio.value = value!;
                        resetUpiVariables();
                      },
                      activeColor: ColorsForApp.primaryColor,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    ),
                    width(5),
                    GestureDetector(
                      onTap: () {
                        paymentBankController.selectedBankPaymentMethodRadio.value = 'Bank';
                        resetUpiVariables();
                      },
                      child: Text(
                        'Bank',
                        style: TextHelper.size14.copyWith(
                          color: paymentBankController.selectedBankPaymentMethodRadio.value == 'Bank' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                          fontWeight: paymentBankController.selectedBankPaymentMethodRadio.value == 'Bank' ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ),
                    width(15),
                    Radio(
                      value: 'UPI',
                      groupValue: paymentBankController.selectedBankPaymentMethodRadio.value,
                      onChanged: (value) {
                        paymentBankController.selectedBankPaymentMethodRadio.value = value!;
                        resetBankVariables();
                      },
                      activeColor: ColorsForApp.primaryColor,
                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    ),
                    width(5),
                    GestureDetector(
                      onTap: () {
                        paymentBankController.selectedBankPaymentMethodRadio.value = 'UPI';
                        resetBankVariables();
                      },
                      child: Text(
                        'UPI',
                        style: TextHelper.size14.copyWith(
                          color: paymentBankController.selectedBankPaymentMethodRadio.value == 'UPI' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                          fontWeight: paymentBankController.selectedBankPaymentMethodRadio.value == 'UPI' ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                height(1.h),
                paymentBankController.selectedBankPaymentMethodRadio.value == 'Bank' ? paymentMethodBank(context) : paymentMethodUpi(),
                height(2.h),
                // Add bank/upi button
                CommonButton(
                  onPressed: () async {
                    if (paymentBankController.selectedBankPaymentMethodRadio.value == 'Bank' ? addBankFormKey.currentState!.validate() : addUpiFormKey.currentState!.validate()) {
                      showProgressIndicator();
                      await paymentBankController.addPaymentBank(isLoaderShow: false);
                      dismissProgressIndicator();
                    }
                  },
                  label: 'Add ${paymentBankController.selectedBankPaymentMethodRadio.value}',
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
                        paymentBankController.bankChequeFile.value = capturedFile;
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
                                    paymentBankController.bankChequeFile.value = pickedFile;
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
    return Form(
      key: addBankFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account holder name
          CustomTextFieldWithTitle(
            controller: paymentBankController.accountHolderNameBankController,
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
              if (paymentBankController.accountHolderNameBankController.text.trim().isEmpty) {
                return 'Please enter account holder name';
              }
              return null;
            },
          ),
          // Account number
          CustomTextFieldWithTitle(
            controller: paymentBankController.accountNumberController,
            title: 'Account Number',
            hintText: 'Account number',
            maxLength: 19,
            isCompulsory: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            textInputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (value) {
              if (paymentBankController.accountNumberController.text.trim().isEmpty) {
                return 'Please enter account number';
              }
              return null;
            },
          ),
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
                groupValue: paymentBankController.selectedAccountTypeRadio.value,
                onChanged: (value) {
                  paymentBankController.selectedAccountTypeRadio.value = value!;
                },
                activeColor: ColorsForApp.primaryColor,
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              ),
              width(5),
              GestureDetector(
                onTap: () {
                  paymentBankController.selectedAccountTypeRadio.value = 'Current';
                },
                child: Text(
                  'Current',
                  style: TextHelper.size14.copyWith(
                    color: paymentBankController.selectedAccountTypeRadio.value == 'Current' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                    fontWeight: paymentBankController.selectedAccountTypeRadio.value == 'Current' ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
              width(15),
              Radio(
                value: 'Savings',
                groupValue: paymentBankController.selectedAccountTypeRadio.value,
                onChanged: (value) {
                  paymentBankController.selectedAccountTypeRadio.value = value!;
                },
                activeColor: ColorsForApp.primaryColor,
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
              ),
              width(5),
              GestureDetector(
                onTap: () {
                  paymentBankController.selectedAccountTypeRadio.value = 'Savings';
                },
                child: Text(
                  'Savings',
                  style: TextHelper.size14.copyWith(
                    color: paymentBankController.selectedAccountTypeRadio.value == 'Savings' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                    fontWeight: paymentBankController.selectedAccountTypeRadio.value == 'Savings' ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          height(1.h),
          // Bank name
          CustomTextFieldWithTitle(
            controller: paymentBankController.bankNameController,
            title: 'Bank Name',
            hintText: 'Bank name',
            isCompulsory: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            textInputFormatter: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
            ],
            validator: (value) {
              if (paymentBankController.bankNameController.text.trim().isEmpty) {
                return 'Please enter bank name';
              }
              return null;
            },
          ),
          // IFSC code
          CustomTextFieldWithTitle(
            controller: paymentBankController.ifscCodeController,
            title: 'IFSC  Code',
            hintText: 'IFSC code',
            maxLength: 11,
            isCompulsory: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            textInputFormatter: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
            ],
            validator: (value) {
              RegExp regex = RegExp(r"^[A-Z]{4}0[A-Z0-9]{6}$");
              if (paymentBankController.ifscCodeController.text.trim().isEmpty) {
                return 'Please enter ifsc code';
              } else if (!regex.hasMatch(value!)) {
                return 'Please enter valid ifsc code';
              }
              return null;
            },
          ),
          // Bank code
          CustomTextFieldWithTitle(
            controller: paymentBankController.bankBranchCodeController,
            title: 'Bank Code',
            hintText: 'Enter Code',
            maxLines: 1,
            maxLength: 6,
            isCompulsory: false,
            minLength: 6,
            onTap: () {},
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (paymentBankController.bankBranchCodeController.text.isNotEmpty) {
                if (paymentBankController.bankBranchCodeController.text.length != 6) {
                  return "please enter valid bank code";
                }
              }
              return null;
            },
          ),
          // Branch
          CustomTextFieldWithTitle(
            controller: paymentBankController.bankBranchNameController,
            title: 'Branch',
            hintText: 'Enter Branch',
            isCompulsory: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (paymentBankController.bankBranchNameController.text.trim().isEmpty) {
                return 'Please enter branch name';
              }
              return null;
            },
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
          paymentBankController.bankChequeFile.value.path.isNotEmpty
              ? SizedBox(
                  height: 21.5.w,
                  width: 21.5.w,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      InkWell(
                        onTap: () async {
                          OpenResult openResult = await OpenFile.open(paymentBankController.bankChequeFile.value.path);
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
                              paymentBankController.bankChequeFile.value,
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
                            paymentBankController.bankChequeFile.value = File('');
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
                      onTap: () {
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
    );
  }

  Widget paymentMethodUpi() {
    return Form(
      key: addUpiFormKey,
      child: Column(
        children: [
          // Account holder name
          CustomTextFieldWithTitle(
            controller: paymentBankController.accountHolderNameUpiController,
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
              if (paymentBankController.accountHolderNameUpiController.text.trim().isEmpty) {
                return 'Please enter account holder name';
              }
              return null;
            },
          ),
          // UPI id
          CustomTextFieldWithTitle(
            controller: paymentBankController.upiIdController,
            title: 'UPI ID',
            hintText: 'UPI id',
            maxLength: 50,
            isCompulsory: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: (value) {
              RegExp regex = RegExp(r"^[0-9A-Za-z.-]{2,256}@[A-Za-z]{2,64}$");
              if (paymentBankController.upiIdController.text.trim().isEmpty) {
                return 'Please enter upi id';
              } else if (!regex.hasMatch(value!.trim())) {
                return 'Please enter valid upi id';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  resetBankVariables() {
    paymentBankController.accountHolderNameBankController.clear();
    paymentBankController.accountNumberController.clear();
    paymentBankController.bankNameController.clear();
    paymentBankController.ifscCodeController.clear();
    paymentBankController.bankBranchCodeController.clear();
    paymentBankController.bankBranchNameController.clear();
    paymentBankController.bankChequeFile.value = File('');
    paymentBankController.selectedAccountTypeRadio.value = 'Current';
  }

  resetUpiVariables() {
    paymentBankController.accountHolderNameUpiController.clear();
    paymentBankController.upiIdController.clear();
  }
}

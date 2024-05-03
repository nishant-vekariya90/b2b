import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/dmt/dmt_b_controller.dart';
import '../../../../../../model/money_transfer/recipient_deposit_bank_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class DmtBAddRecipientScreen extends StatefulWidget {
  const DmtBAddRecipientScreen({super.key});

  @override
  State<DmtBAddRecipientScreen> createState() => _DmtBAddRecipientScreenState();
}

class _DmtBAddRecipientScreenState extends State<DmtBAddRecipientScreen> {
  final DmtBController dmtBController = Get.find();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      if (dmtBController.depositBankList.isEmpty) {
        await dmtBController.getDepositBankList();
      }
      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    dmtBController.clearAddRecipientVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CustomScaffold(
        title: 'Add Recipient',
        isShowLeadingIcon: true,
        mainBody: Form(
          key: dmtBController.addRecipientForm,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height(2.h),
                  // Select deposit bank
                  CustomTextFieldWithTitle(
                    controller: dmtBController.addRecipientDepositBankController,
                    title: 'Deposit Bank',
                    hintText: 'Select deposit bank',
                    readOnly: true,
                    isCompulsory: true,
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                    ),
                    onTap: () async {
                      if (dmtBController.isAccountVerify.value == false) {
                        RecipientDepositBankModel selectedDeposit = await Get.toNamed(
                          Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                          arguments: [
                            dmtBController.depositBankList, // modelList
                            'depositBankList', // modelName
                          ],
                        );
                        if (selectedDeposit.bankName != null && selectedDeposit.bankName!.isNotEmpty) {
                          dmtBController.addRecipientDepositBankController.text = selectedDeposit.bankName!;
                          dmtBController.addRecipientDepositBankId.value = selectedDeposit.id!.toString();
                          dmtBController.addRecipientIfscCodeController.text = selectedDeposit.ifscCode!.toString();
                        }
                      }
                    },
                    validator: (value) {
                      if (dmtBController.addRecipientDepositBankController.text.trim().isEmpty) {
                        return 'Please select deposit bank';
                      }
                      return null;
                    },
                  ),
                  // Ifsc code
                  CustomTextFieldWithTitle(
                    controller: dmtBController.addRecipientIfscCodeController,
                    title: 'IFSC Code',
                    hintText: 'Enter IFSC code',
                    readOnly: dmtBController.isAccountVerify.value == false ? false : true,
                    isCompulsory: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.characters,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                    ],
                    suffixIcon: Icon(
                      Icons.password,
                      size: 18,
                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                    ),
                    validator: (value) {
                      if (dmtBController.addRecipientIfscCodeController.text.trim().isEmpty) {
                        return 'Please enter IFSC code';
                      }
                      return null;
                    },
                  ),
                  // Account number
                  CustomTextFieldWithTitle(
                    controller: dmtBController.addRecipientAccountNumberController,
                    title: 'Account Number',
                    hintText: 'Enter account number',
                    maxLength: 19,
                    isCompulsory: true,
                    readOnly: dmtBController.isAccountVerify.value == true ? true : false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        if (dmtBController.addRecipientDepositBankController.text.isEmpty) {
                          errorSnackBar(message: 'Please select deposit bank');
                        } else if (dmtBController.addRecipientIfscCodeController.text.isEmpty) {
                          errorSnackBar(message: 'Please enter IFSC code');
                        } else if (dmtBController.addRecipientAccountNumberController.text.isEmpty) {
                          errorSnackBar(message: 'Please enter account number');
                        } else {
                          if (dmtBController.addRecipientDepositBankController.text.isNotEmpty && dmtBController.addRecipientIfscCodeController.text.isNotEmpty && dmtBController.isAccountVerify.value == false) {
                            bool result = await dmtBController.verifyAccount(
                              recipientName: dmtBController.addRecipientFullNameController.text.trim(),
                              accountNo: dmtBController.addRecipientAccountNumberController.text.trim(),
                              ifscCode: dmtBController.addRecipientIfscCodeController.text.trim(),
                              bankName: dmtBController.addRecipientDepositBankController.text.trim(),
                            );
                            if (result == true) {
                              successSnackBar(message: dmtBController.accountVerificationModel.value.message!);
                            }
                          }
                        }
                      },
                      child: Obx(
                        () => Container(
                          width: 8.h,
                          decoration: BoxDecoration(
                            color: dmtBController.isAccountVerify.value == true ? ColorsForApp.successColor.withOpacity(0.1) : ColorsForApp.primaryColorBlue.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(7),
                              bottomRight: Radius.circular(7),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            dmtBController.isAccountVerify.value == true ? 'Verified' : 'Verify',
                            style: TextHelper.size13.copyWith(
                              fontFamily: boldGoogleSansFont,
                              color: dmtBController.isAccountVerify.value == true ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (dmtBController.addRecipientAccountNumberController.text.isEmpty) {
                        return 'Please enter account number';
                      }
                      return null;
                    },
                  ),
                  // Full name
                  CustomTextFieldWithTitle(
                    controller: dmtBController.addRecipientFullNameController,
                    title: 'Full Name',
                    hintText: 'Enter full name',
                    isCompulsory: true,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.words,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                    ],
                    suffixIcon: Icon(
                      Icons.account_circle_outlined,
                      size: 18,
                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                    ),
                    validator: (value) {
                      if (dmtBController.addRecipientFullNameController.text.trim().isEmpty) {
                        return 'Please enter full name';
                      }
                      return null;
                    },
                  ),
                  height(2.h),
                  // Add button
                  CommonButton(
                    onPressed: () async {
                      // Unfocus text-field
                      FocusScope.of(context).unfocus();
                      if (Get.isSnackbarOpen) {
                        Get.back();
                      }
                      if (dmtBController.addRecipientForm.currentState!.validate()) {
                        showProgressIndicator();
                        if (Get.isSnackbarOpen) {
                          Get.back();
                        }
                        bool result = await dmtBController.addRecipient(isLoaderShow: false);
                        if (result == true) {
                          // Call for fetch updated balance
                          await dmtBController.validateRemitter(isLoaderShow: false);
                          // Call for fetch updated recipient list
                          await dmtBController.getRecipientList(isLoaderShow: false);
                          Get.back();
                          successSnackBar(message: dmtBController.addRecipientModel.value.message!);
                        }
                        dismissProgressIndicator();
                      }
                    },
                    label: 'Add',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

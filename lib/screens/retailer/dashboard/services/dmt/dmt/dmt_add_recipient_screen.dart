import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/dmt/dmt_controller.dart';
import '../../../../../../model/money_transfer/recipient_deposit_bank_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class DmtAddRecipientScreen extends StatefulWidget {
  const DmtAddRecipientScreen({super.key});

  @override
  State<DmtAddRecipientScreen> createState() => _DmtAddRecipientScreenState();
}

class _DmtAddRecipientScreenState extends State<DmtAddRecipientScreen> {
  final DmtController dmtController = Get.find();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      if (dmtController.depositBankList.isEmpty) {
        await dmtController.getDepositBankList();
      }
      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    dmtController.clearAddRecipientVariables();
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
          key: dmtController.addRecipientForm,
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
                    controller: dmtController.addRecipientDepositBankController,
                    title: 'Deposit Bank',
                    hintText: 'Select deposit bank',
                    readOnly: true,
                    isCompulsory: true,
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                    ),
                    onTap: () async {
                      if (dmtController.isAccountVerify.value == false) {
                        RecipientDepositBankModel selectedDeposit = await Get.toNamed(
                          Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                          arguments: [
                            dmtController.depositBankList, // modelList
                            'depositBankList', // modelName
                          ],
                        );
                        if (selectedDeposit.bankName != null && selectedDeposit.bankName!.isNotEmpty) {
                          dmtController.addRecipientDepositBankController.text = selectedDeposit.bankName!.toString();
                          dmtController.addRecipientDepositBankId.value = selectedDeposit.id!.toString();
                          dmtController.addRecipientIfscCodeController.text = selectedDeposit.ifscCode!.toString();
                        }
                      }
                    },
                    validator: (value) {
                      if (dmtController.addRecipientDepositBankController.text.trim().isEmpty) {
                        return 'Please select deposit bank';
                      }
                      return null;
                    },
                  ),
                  // Ifsc code
                  CustomTextFieldWithTitle(
                    controller: dmtController.addRecipientIfscCodeController,
                    title: 'IFSC Code',
                    hintText: 'Enter IFSC code',
                    maxLength: 11,
                    isCompulsory: true,
                    readOnly: dmtController.isAccountVerify.value == true ? true : false,
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
                      RegExp regex = RegExp(r"^[A-Z]{4}0[A-Z0-9]{6}$");
                      if (dmtController.addRecipientIfscCodeController.text.trim().isEmpty) {
                        return 'Please enter IFSC code';
                      } else if (!regex.hasMatch(value!)) {
                        return 'Please enter valid IFSC code';
                      }
                      return null;
                    },
                  ),
                  // Account number
                  CustomTextFieldWithTitle(
                    controller: dmtController.addRecipientAccountNumberController,
                    title: 'Account Number',
                    hintText: 'Enter account number',
                    maxLength: 19,
                    isCompulsory: true,
                    readOnly: dmtController.isAccountVerify.value == true ? true : false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        if (dmtController.addRecipientDepositBankController.text.isEmpty) {
                          errorSnackBar(message: 'Please select deposit bank');
                        } else if (dmtController.addRecipientIfscCodeController.text.isEmpty) {
                          errorSnackBar(message: 'Please enter IFSC code');
                        } else if (dmtController.addRecipientAccountNumberController.text.isEmpty) {
                          errorSnackBar(message: 'Please enter account number');
                        } else {
                          if (dmtController.addRecipientDepositBankController.text.isNotEmpty && dmtController.addRecipientIfscCodeController.text.isNotEmpty && dmtController.isAccountVerify.value == false) {
                            bool result = await dmtController.verifyAccount(
                              recipientName: dmtController.addRecipientFullNameController.text.trim(),
                              accountNo: dmtController.addRecipientAccountNumberController.text.trim(),
                              ifscCode: dmtController.addRecipientIfscCodeController.text.trim(),
                              bankName: dmtController.addRecipientDepositBankController.text.trim(),
                            );
                            if (result == true) {
                              successSnackBar(message: dmtController.accountVerificationModel.value.message!);
                            }
                          }
                        }
                      },
                      child: Obx(
                        () => Container(
                          width: 8.h,
                          decoration: BoxDecoration(
                            color: dmtController.isAccountVerify.value == true ? ColorsForApp.successColor.withOpacity(0.1) : ColorsForApp.primaryColorBlue.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(7),
                              bottomRight: Radius.circular(7),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            dmtController.isAccountVerify.value == true ? 'Verified' : 'Verify',
                            style: TextHelper.size13.copyWith(
                              fontFamily: boldGoogleSansFont,
                              color: dmtController.isAccountVerify.value == true ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (dmtController.addRecipientAccountNumberController.text.isEmpty) {
                        return 'Please enter account number';
                      }
                      return null;
                    },
                  ),
                  // Full name
                  CustomTextFieldWithTitle(
                    controller: dmtController.addRecipientFullNameController,
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
                      if (dmtController.addRecipientFullNameController.text.trim().isEmpty) {
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
                      if (dmtController.addRecipientForm.currentState!.validate()) {
                        showProgressIndicator();
                        bool result = await dmtController.addRecipient(isLoaderShow: false);
                        if (result == true) {
                          // Call for fetch updated balance
                          await dmtController.validateRemitter(isLoaderShow: false);
                          // Call for fetch updated recipient list
                          await dmtController.getRecipientList(isLoaderShow: false);
                          Get.back();
                          successSnackBar(message: dmtController.addRecipientModel.value.message!);
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

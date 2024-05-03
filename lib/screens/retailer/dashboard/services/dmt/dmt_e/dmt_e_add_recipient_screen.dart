import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/dmt/dmt_e_controller.dart';
import '../../../../../../model/money_transfer/recipient_deposit_bank_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class DmtEAddRecipientScreen extends StatefulWidget {
  const DmtEAddRecipientScreen({super.key});

  @override
  State<DmtEAddRecipientScreen> createState() => _DmtEAddRecipientScreenState();
}

class _DmtEAddRecipientScreenState extends State<DmtEAddRecipientScreen> {
  final DmtEController dmtEController = Get.find();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      if (dmtEController.depositBankList.isEmpty) {
        await dmtEController.getDepositBankList();
      }
      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    dmtEController.clearAddRecipientVariables();
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
          key: dmtEController.addRecipientForm,
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
                    controller: dmtEController.addRecipientDepositBankController,
                    title: 'Deposit Bank',
                    hintText: 'Select deposit bank',
                    readOnly: true,
                    isCompulsory: true,
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                    ),
                    onTap: () async {
                      if (dmtEController.isAccountVerify.value == false) {
                        RecipientDepositBankModel selectedDeposit = await Get.toNamed(
                          Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                          arguments: [
                            dmtEController.depositBankList, // modelList
                            'depositBankList', // modelName
                          ],
                        );
                        if (selectedDeposit.bankName != null && selectedDeposit.bankName!.isNotEmpty) {
                          dmtEController.addRecipientDepositBankController.text = selectedDeposit.bankName!;
                          dmtEController.addRecipientDepositBankId.value = selectedDeposit.id!.toString();
                          dmtEController.addRecipientIfscCodeController.text = selectedDeposit.ifscCode!.toString();
                        }
                      }
                    },
                    validator: (value) {
                      if (dmtEController.addRecipientDepositBankController.text.trim().isEmpty) {
                        return 'Please select deposit bank';
                      }
                      return null;
                    },
                  ),
                  // Ifsc code
                  CustomTextFieldWithTitle(
                    controller: dmtEController.addRecipientIfscCodeController,
                    title: 'IFSC Code',
                    hintText: 'Enter IFSC code',
                    readOnly: dmtEController.isAccountVerify.value == false ? false : true,
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
                      if (dmtEController.addRecipientIfscCodeController.text.trim().isEmpty) {
                        return 'Please enter IFSC code';
                      }
                      return null;
                    },
                  ),
                  // Account number
                  CustomTextFieldWithTitle(
                    controller: dmtEController.addRecipientAccountNumberController,
                    title: 'Account Number',
                    hintText: 'Enter account number',
                    maxLength: 19,
                    isCompulsory: true,
                    readOnly: dmtEController.isAccountVerify.value == true ? true : false,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        if (dmtEController.addRecipientDepositBankController.text.isEmpty) {
                          errorSnackBar(message: 'Please select deposit bank');
                        } else if (dmtEController.addRecipientIfscCodeController.text.isEmpty) {
                          errorSnackBar(message: 'Please enter IFSC code');
                        } else if (dmtEController.addRecipientAccountNumberController.text.isEmpty) {
                          errorSnackBar(message: 'Please enter account number');
                        } else {
                          if (dmtEController.addRecipientDepositBankController.text.isNotEmpty && dmtEController.addRecipientIfscCodeController.text.isNotEmpty && dmtEController.isAccountVerify.value == false) {
                            await dmtEController.verifyAccount();
                          }
                        }
                      },
                      child: Obx(
                        () => Container(
                          width: 8.h,
                          decoration: BoxDecoration(
                            color: dmtEController.isAccountVerify.value == true ? ColorsForApp.successColor.withOpacity(0.1) : ColorsForApp.primaryColorBlue.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(7),
                              bottomRight: Radius.circular(7),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            dmtEController.isAccountVerify.value == true ? 'Verified' : 'Verify',
                            style: TextHelper.size13.copyWith(
                              fontFamily: boldGoogleSansFont,
                              color: dmtEController.isAccountVerify.value == true ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (dmtEController.addRecipientAccountNumberController.text.isEmpty) {
                        return 'Please enter account number';
                      }
                      return null;
                    },
                  ),
                  // Full name
                  CustomTextFieldWithTitle(
                    controller: dmtEController.addRecipientFullNameController,
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
                      if (dmtEController.addRecipientFullNameController.text.trim().isEmpty) {
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
                      if (dmtEController.addRecipientForm.currentState!.validate()) {
                        showProgressIndicator();
                        bool result = await dmtEController.addRecipient(isLoaderShow: false);
                        if (result == true) {
                          // Call for fetch updated balance
                          await dmtEController.validateRemitter(isLoaderShow: false);
                          // Call for fetch updated recipient list
                          await dmtEController.getRecipientList(isLoaderShow: false);
                          Get.back();
                          successSnackBar(message: dmtEController.addRecipientModel.value.message!);
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

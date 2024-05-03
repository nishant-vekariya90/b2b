import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/distributor/credit_debit_controller.dart';
import '../../../generated/assets.dart';
import '../../../model/auth/user_type_model.dart';
import '../../../model/credit_debit/user_list_model.dart';
import '../../../model/credit_debit/wallet_type_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/text_field.dart';
import '../../../widgets/text_field_with_title.dart';

class CreditDebitScreen extends StatefulWidget {
  const CreditDebitScreen({super.key});

  @override
  State<CreditDebitScreen> createState() => _CreditDebitScreenState();
}

class _CreditDebitScreenState extends State<CreditDebitScreen> {
  final CreditDebitController creditDebitController = Get.find();
  final Rx<GlobalKey<FormState>> creditWalletFormKey = GlobalKey<FormState>().obs;
  final Rx<GlobalKey<FormState>> debitWalletFormKey = GlobalKey<FormState>().obs;
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      if (creditDebitController.userTypeList.isEmpty) {
        await creditDebitController.getUserType(isLoaderShow: false);
      }
      if (creditDebitController.walletList.isEmpty) {
        await creditDebitController.getWalletType(isLoaderShow: false);
      }
      isShowTpinField.value = checkTpinRequired(categoryCode: 'Wallet');
      dismissProgressIndicator();
    } catch (e) {
      isShowTpinField.value = false;
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    creditDebitController.resetCreditDebitWalletVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 10.h,
      title: 'Wallet Credit Debit',
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
                Assets.imagesLoginSuccess,
              ),
            ),
            width(2.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Credit Debit Wallet',
                    style: TextHelper.size14.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    'Enjoy our Credit Wallet & Debit Wallet Service for the uninterrupted online transactions.',
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
      mainBody: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height(2.h),
                    // Wallet method radio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: 'Credit',
                          groupValue: creditDebitController.selectedWalletMethodRadio.value,
                          onChanged: (value) {
                            if (creditDebitController.selectedWalletMethodRadio.value != 'Credit') {
                              creditDebitController.resetCreditDebitWalletVariables();
                            }
                            creditDebitController.selectedWalletMethodRadio.value = value!;
                          },
                          activeColor: ColorsForApp.primaryColor,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                        width(5),
                        GestureDetector(
                          onTap: () {
                            if (creditDebitController.selectedWalletMethodRadio.value != 'Credit') {
                              //clear data
                              creditDebitController.resetCreditDebitWalletVariables();
                            }
                            creditDebitController.selectedWalletMethodRadio.value = 'Credit';
                          },
                          child: Text(
                            'Credit',
                            style: TextHelper.size14.copyWith(
                              color: creditDebitController.selectedWalletMethodRadio.value == 'Credit' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                              fontWeight: creditDebitController.selectedWalletMethodRadio.value == 'Credit' ? FontWeight.w500 : FontWeight.w400,
                            ),
                          ),
                        ),
                        width(15),
                        Radio(
                          value: 'Debit',
                          groupValue: creditDebitController.selectedWalletMethodRadio.value,
                          onChanged: (value) {
                            if (creditDebitController.selectedWalletMethodRadio.value != 'Debit') {
                              creditDebitController.resetCreditDebitWalletVariables();
                            }
                            creditDebitController.selectedWalletMethodRadio.value = value!;
                          },
                          activeColor: ColorsForApp.primaryColor,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                        width(5),
                        GestureDetector(
                          onTap: () {
                            if (creditDebitController.selectedWalletMethodRadio.value != 'Debit') {
                              creditDebitController.resetCreditDebitWalletVariables();
                            }
                            creditDebitController.selectedWalletMethodRadio.value = 'Debit';
                          },
                          child: Text(
                            'Debit',
                            style: TextHelper.size14.copyWith(
                              color: creditDebitController.selectedWalletMethodRadio.value == 'Debit' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                              fontWeight: creditDebitController.selectedWalletMethodRadio.value == 'Debit' ? FontWeight.w500 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    creditDebitController.selectedWalletMethodRadio.value == 'Credit'
                        // Select credit
                        ? creditForm()
                        // Select debit
                        : debitForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget creditForm() {
    return Form(
      key: creditWalletFormKey.value,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height(10),
          // Select user type
          CustomTextFieldWithTitle(
            controller: creditDebitController.selectedUserTypeController,
            title: 'User type',
            hintText: 'Select user type',
            readOnly: true,
            isCompulsory: true,
            suffixIcon: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: ColorsForApp.secondaryColor.withOpacity(0.5),
            ),
            onTap: () async {
              UserTypeModel selectedUserType = await Get.toNamed(
                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                arguments: [
                  creditDebitController.userTypeList, // list
                  'userTypeList', // listType
                ],
              );
              if (creditDebitController.selectedUserTypeController.text != selectedUserType.name!) {
                creditDebitController.selectedUserNameController.clear();
                creditDebitController.selectedUserNameIdController.clear();
                creditDebitController.selectedUserBalance.value = '';
                creditDebitController.selectedOutstandingBalance.value = '';
                if (selectedUserType.name != null && selectedUserType.name!.isNotEmpty) {
                  creditDebitController.selectedUserTypeController.text = selectedUserType.name!;
                  creditDebitController.selectedUserTypeId.value = selectedUserType.id!.toString();
                }
              }
            },
            validator: (value) {
              if (creditDebitController.selectedUserTypeController.text.trim().isEmpty) {
                return 'Please select user type';
              }
              return null;
            },
          ),
          // Select user
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'User',
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
                controller: creditDebitController.selectedUserNameController,
                hintText: 'Select user',
                readOnly: true,
                isRequired: true,
                suffixIcon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: ColorsForApp.secondaryColor.withOpacity(0.5),
                ),
                onTap: () async {
                  if (creditDebitController.selectedUserTypeController.text.trim().isEmpty) {
                    errorSnackBar(message: 'Please select user type');
                  } else {
                    UserData selectedUser = await Get.toNamed(
                      Routes.SEARCHABLE_LIST_VIEW_PAGINATION_SCREEN,
                      arguments: 'userList',
                    );
                    if (selectedUser.ownerName != null && selectedUser.ownerName!.isNotEmpty) {
                      creditDebitController.selectedUserNameController.text = selectedUser.ownerName!;
                      creditDebitController.selectedUserNameIdController.text = selectedUser.id!.toString();
                      creditDebitController.selectedUserBalance.value = selectedUser.wallet1Bal!.toStringAsFixed(2);
                      creditDebitController.selectedOutstandingBalance.value = selectedUser.outstandingBal!.toStringAsFixed(2);
                    }
                  }
                },
                validator: (value) {
                  if (creditDebitController.selectedUserNameController.text.trim().isEmpty) {
                    return 'Please select user';
                  }
                  return null;
                },
              ),
            ],
          ),
          // Selected user wallet balance
          Obx(
            () => Visibility(
              visible: creditDebitController.selectedUserBalance.value.isNotEmpty ? true : false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height(0.6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wallet Balance: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Expanded(
                        child: Text(
                          creditDebitController.selectedUserBalance.value,
                          textAlign: TextAlign.justify,
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.successColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Selected user outstanding balance
          Obx(
            () => Visibility(
              visible: creditDebitController.selectedOutstandingBalance.value.isNotEmpty ? true : false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height(0.6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Outstanding Balance: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Expanded(
                        child: Text(
                          creditDebitController.selectedOutstandingBalance.value,
                          textAlign: TextAlign.justify,
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.successColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          height(1.5.h),
          // Select wallet type
          CustomTextFieldWithTitle(
            controller: creditDebitController.selectedWalletController,
            title: 'Wallet type',
            hintText: 'Select wallet type',
            readOnly: true,
            isCompulsory: true,
            suffixIcon: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: ColorsForApp.secondaryColor.withOpacity(0.5),
            ),
            onTap: () async {
              WalletTypeModel selectedWalletType = await Get.toNamed(
                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                arguments: [
                  creditDebitController.walletList, // list
                  'walletTypeList', // listType
                ],
              );
              if (selectedWalletType.name != null && selectedWalletType.name!.isNotEmpty) {
                creditDebitController.selectedWalletController.text = selectedWalletType.name!;
                creditDebitController.selectedWalletId.value = selectedWalletType.id!;
              }
            },
            validator: (value) {
              if (creditDebitController.selectedWalletController.text.trim().isEmpty) {
                return 'Please select wallet type';
              }
              return null;
            },
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
                controller: creditDebitController.amountController,
                hintText: 'Enter the amount',
                maxLength: 7,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                obscureText: false,
                onChange: (value) {
                  if (creditDebitController.amountController.text.isNotEmpty && int.parse(creditDebitController.amountController.text.trim()) > 0) {
                    creditDebitController.amountIntoWords.value = getAmountIntoWords(int.parse(creditDebitController.amountController.text.trim()));
                  } else {
                    creditDebitController.amountIntoWords.value = '';
                  }
                },
                validator: (value) {
                  if (creditDebitController.amountController.text.trim().isEmpty) {
                    return 'Please enter amount';
                  } else if (int.parse(creditDebitController.amountController.text.trim()) <= 0) {
                    return 'Amount should be greater than 0 ';
                  }
                  return null;
                },
              ),
            ],
          ),
          // Amount in text
          Obx(
            () => Visibility(
              visible: creditDebitController.amountIntoWords.value.isNotEmpty ? true : false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height(0.6.h),
                  Text(
                    creditDebitController.amountIntoWords.value,
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
          // Check is outstanding
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => Checkbox(
                  activeColor: ColorsForApp.primaryColor,
                  value: creditDebitController.isOutstanding.value,
                  onChanged: (bool? value) {
                    creditDebitController.isOutstanding.value = value!;
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
                  'Is outstanding',
                  style: TextHelper.size13,
                ),
              ),
            ],
          ),
          height(1.5.h),
          // TPIN
          Visibility(
            visible: isShowTpinField.value,
            child: Obx(
              () => CustomTextFieldWithTitle(
                controller: creditDebitController.tPinController,
                title: 'TPIN',
                hintText: 'Enter TPIN',
                maxLength: 4,
                isCompulsory: true,
                obscureText: creditDebitController.isShowTpin.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    creditDebitController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  onPressed: () {
                    creditDebitController.isShowTpin.value = !creditDebitController.isShowTpin.value;
                  },
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (creditDebitController.tPinController.text.trim().isEmpty) {
                    return 'Please enter TPIN';
                  }
                  /*else if (internalTransferController.tpinController.text.length < 4) {
                            return 'Please enter valid TPIN';
                          }*/
                  return null;
                },
              ),
            ),
          ),
          // Remarks
          CustomTextFieldWithTitle(
            controller: creditDebitController.remarkController,
            title: 'Remarks',
            hintText: 'Enter remarks',
            maxLines: 4,
            isCompulsory: true,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            validator: (value) {
              if (creditDebitController.remarkController.text.trim().isEmpty) {
                return 'Please enter remarks';
              }
              return null;
            },
          ),
          height(2.h),
          // Proceed button
          CommonButton(
            bgColor: ColorsForApp.primaryColor,
            labelColor: ColorsForApp.whiteColor,
            label: 'Proceed',
            onPressed: () async {
              if (creditWalletFormKey.value.currentState!.validate()) {
                await confirmationBottomSheet(context);
              }
            },
          ),
          height(2.h),
        ],
      ),
    );
  }

  Widget debitForm() {
    return Form(
      key: debitWalletFormKey.value,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height(10),
          // Select user type
          CustomTextFieldWithTitle(
            controller: creditDebitController.selectedUserTypeController,
            title: 'User type',
            hintText: 'Select user type',
            readOnly: true,
            isCompulsory: true,
            suffixIcon: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: ColorsForApp.secondaryColor.withOpacity(0.5),
            ),
            onTap: () async {
              UserTypeModel selectedUserType = await Get.toNamed(
                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                arguments: [
                  creditDebitController.userTypeList, // list
                  'userTypeList', // listType
                ],
              );
              if (creditDebitController.selectedUserTypeController.text != selectedUserType.name!) {
                creditDebitController.selectedUserNameController.clear();
                creditDebitController.selectedUserNameIdController.clear();
                creditDebitController.selectedUserBalance.value = '';
                if (selectedUserType.name != null && selectedUserType.name!.isNotEmpty) {
                  creditDebitController.selectedUserTypeController.text = selectedUserType.name!;
                  creditDebitController.selectedUserTypeId.value = selectedUserType.id!.toString();
                }
              }
            },
            validator: (value) {
              if (creditDebitController.selectedUserTypeController.text.trim().isEmpty) {
                return 'Please select user type';
              }
              return null;
            },
          ),
          // Select user
          CustomTextFieldWithTitle(
            controller: creditDebitController.selectedUserNameController,
            title: 'User',
            hintText: 'Select user',
            readOnly: true,
            isCompulsory: true,
            suffixIcon: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: ColorsForApp.secondaryColor.withOpacity(0.5),
            ),
            onTap: () async {
              if (creditDebitController.selectedUserTypeController.text.trim().isEmpty) {
                errorSnackBar(message: 'Please select user type');
              } else {
                UserData selectedUser = await Get.toNamed(
                  Routes.SEARCHABLE_LIST_VIEW_PAGINATION_SCREEN,
                  arguments: 'userList',
                );
                if (selectedUser.ownerName != null && selectedUser.ownerName!.isNotEmpty) {
                  creditDebitController.selectedUserNameController.text = selectedUser.ownerName!;
                  creditDebitController.selectedUserNameIdController.text = selectedUser.id!.toString();
                  creditDebitController.selectedUserBalance.value = selectedUser.wallet1Bal!.toStringAsFixed(2);
                  creditDebitController.selectedOutstandingBalance.value = selectedUser.outstandingBal!.toStringAsFixed(2);
                }
              }
            },
            validator: (value) {
              if (creditDebitController.selectedUserNameController.text.trim().isEmpty) {
                return 'Please select user';
              }
              return null;
            },
          ),
          Obx(
            () => Visibility(
              visible: creditDebitController.selectedUserBalance.value.isNotEmpty ? true : false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height(0.6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wallet Balance: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Expanded(
                        child: Text(
                          creditDebitController.selectedUserBalance.value,
                          textAlign: TextAlign.justify,
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.successColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Selected user outstanding balance
          Obx(
            () => Visibility(
              visible: creditDebitController.selectedOutstandingBalance.value.isNotEmpty ? true : false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height(0.6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Outstanding Balance: ',
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.greyColor,
                        ),
                      ),
                      width(5),
                      Expanded(
                        child: Text(
                          creditDebitController.selectedOutstandingBalance.value,
                          textAlign: TextAlign.justify,
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.successColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          height(1.5.h),
          // Select wallet type
          CustomTextFieldWithTitle(
            controller: creditDebitController.selectedWalletController,
            title: 'Wallet type',
            hintText: 'Select wallet type',
            readOnly: true,
            isCompulsory: true,
            suffixIcon: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: ColorsForApp.secondaryColor.withOpacity(0.5),
            ),
            onTap: () async {
              WalletTypeModel selectedWalletType = await Get.toNamed(
                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                arguments: [
                  creditDebitController.walletList, // list
                  'walletTypeList', // listType
                ],
              );
              if (selectedWalletType.name != null && selectedWalletType.name!.isNotEmpty) {
                creditDebitController.selectedWalletController.text = selectedWalletType.name!;
                creditDebitController.selectedWalletId.value = selectedWalletType.id!;
              }
            },
            validator: (value) {
              if (creditDebitController.selectedWalletController.text.trim().isEmpty) {
                return 'Please select wallet type';
              }
              return null;
            },
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
                controller: creditDebitController.amountController,
                hintText: 'Enter the amount',
                maxLength: 7,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                textInputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                obscureText: false,
                onChange: (value) {
                  if (creditDebitController.amountController.text.isNotEmpty && int.parse(creditDebitController.amountController.text.trim()) > 0) {
                    creditDebitController.amountIntoWords.value = getAmountIntoWords(int.parse(creditDebitController.amountController.text.trim()));
                  } else {
                    creditDebitController.amountIntoWords.value = '';
                  }
                },
                validator: (value) {
                  if (creditDebitController.amountController.text.trim().isEmpty) {
                    return 'Please enter amount';
                  } else if (int.parse(creditDebitController.amountController.text.trim()) <= 0) {
                    return 'Amount should be greater than 0 ';
                  }
                  return null;
                },
              ),
            ],
          ),
          // Amount in text
          Obx(
            () => Visibility(
              visible: creditDebitController.amountIntoWords.value.isNotEmpty ? true : false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height(0.6.h),
                  Text(
                    creditDebitController.amountIntoWords.value,
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
            visible: isShowTpinField.value,
            child: Obx(
              () => CustomTextFieldWithTitle(
                controller: creditDebitController.tPinController,
                title: 'TPIN',
                hintText: 'Enter TPIN',
                maxLength: 4,
                isCompulsory: true,
                obscureText: creditDebitController.isShowTpin.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    creditDebitController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  onPressed: () {
                    creditDebitController.isShowTpin.value = !creditDebitController.isShowTpin.value;
                  },
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                textInputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                validator: (value) {
                  if (creditDebitController.tPinController.text.trim().isEmpty) {
                    return 'Please enter TPIN';
                  }
                  /*else if (internalTransferController.tpinController.text.length < 4) {
                      return 'Please enter valid TPIN';
                    }*/
                  return null;
                },
              ),
            ),
          ),
          // Remarks
          CustomTextFieldWithTitle(
            controller: creditDebitController.remarkController,
            title: 'Remarks',
            hintText: 'Enter remarks',
            maxLines: 4,
            isCompulsory: true,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            validator: (value) {
              if (creditDebitController.remarkController.text.trim().isEmpty) {
                return 'Please enter remarks';
              }
              return null;
            },
          ),
          height(2.h),
          // Proceed button
          CommonButton(
            bgColor: ColorsForApp.primaryColor,
            labelColor: ColorsForApp.whiteColor,
            label: 'Proceed',
            onPressed: () async {
              if (debitWalletFormKey.value.currentState!.validate()) {
                await confirmationDebitBottomSheet(context);
              }
            },
          ),
          height(2.h),
        ],
      ),
    );
  }

  // Confirm credit wallet dialog
  Future<dynamic> confirmationBottomSheet(BuildContext context) {
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
              'Credit Wallet Confirmation',
              textAlign: TextAlign.center,
              style: TextHelper.size20.copyWith(
                fontFamily: boldGoogleSansFont,
              ),
            ),
            height(20),
            Text(
              '₹ ${creditDebitController.amountController.text.trim()}.00',
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
                children: [
                  Text(
                    "Credit into ${creditDebitController.selectedUserNameController.text.trim()}'s account",
                    style: TextHelper.size14,
                  ),
                  height(5),
                  Text(
                    '(${creditDebitController.selectedUserTypeController.text.trim()} - ${creditDebitController.selectedWalletController.text.trim()} wallet)',
                    style: TextHelper.size14,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: creditDebitController.remarkController.text.isNotEmpty ? true : false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    height(8),
                    Row(
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
                            creditDebitController.remarkController.text.trim(),
                            style: TextHelper.size13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            height(30),
            CommonButton(
              label: 'Credit',
              onPressed: () async {
                if (Get.isSnackbarOpen) {
                  Get.back();
                }
                bool result = await creditDebitController.creditDebitWallet(paymentMode: 1);
                if (result == true) {
                  creditDebitController.resetCreditDebitWalletVariables();
                  creditWalletFormKey.value = GlobalKey<FormState>();
                }
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  // Confirm debit wallet dialog
  Future<dynamic> confirmationDebitBottomSheet(BuildContext context) {
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
              'Debit Wallet Confirmation',
              textAlign: TextAlign.center,
              style: TextHelper.size20.copyWith(
                fontFamily: boldGoogleSansFont,
              ),
            ),
            height(20),
            Text(
              '₹ ${creditDebitController.amountController.text.trim()}.00',
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
                children: [
                  Text(
                    "Debit from ${creditDebitController.selectedUserNameController.text.trim()}'s account",
                    style: TextHelper.size14,
                  ),
                  height(5),
                  Text(
                    '(${creditDebitController.selectedUserTypeController.text.trim()} - ${creditDebitController.selectedWalletController.text.trim()} wallet)',
                    style: TextHelper.size14,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: creditDebitController.remarkController.text.isNotEmpty ? true : false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    height(8),
                    Row(
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
                            creditDebitController.remarkController.text.trim(),
                            style: TextHelper.size13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            height(30),
            CommonButton(
              label: 'Debit',
              onPressed: () async {
                if (Get.isSnackbarOpen) {
                  Get.back();
                }
                bool result = await creditDebitController.creditDebitWallet(paymentMode: 2);
                if (result == true) {
                  creditDebitController.resetCreditDebitWalletVariables();
                  debitWalletFormKey.value = GlobalKey<FormState>();
                }
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

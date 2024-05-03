import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/distributor/credit_debit_controller.dart';
import '../../../generated/assets.dart';
import '../../../model/auth/user_type_model.dart';
import '../../../model/credit_debit/user_list_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/text_field.dart';
import '../../../widgets/text_field_with_title.dart';

class OutstandingCollectionScreen extends StatefulWidget {
  const OutstandingCollectionScreen({super.key});

  @override
  State<OutstandingCollectionScreen> createState() => _OutstandingCollectionScreenState();
}

class _OutstandingCollectionScreenState extends State<OutstandingCollectionScreen> {
  final CreditDebitController outstandingCollectionController = Get.find();
  final Rx<GlobalKey<FormState>> outstandingCollectionFormKey = GlobalKey<FormState>().obs;
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      if (outstandingCollectionController.userTypeList.isEmpty) {
        await outstandingCollectionController.getUserType();
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
    outstandingCollectionController.resetCreditDebitWalletVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 10.h,
      title: 'Outstanding Collection',
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
                    'Credit Wallet',
                    style: TextHelper.size14.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    'Enjoy our Credit Wallet Service for the uninterrupted online transactions.',
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
          height(6.h),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Obx(
                () => Form(
                  key: outstandingCollectionFormKey.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(10),
                      // Select user type
                      CustomTextFieldWithTitle(
                        controller: outstandingCollectionController.selectedUserTypeController,
                        title: 'User type',
                        hintText: 'Select user type',
                        readOnly: true,
                        isCompulsory: true,
                        onTap: () async {
                          UserTypeModel selectedUserType = await Get.toNamed(
                            Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                            arguments: [
                              outstandingCollectionController.userTypeList, // list
                              'userTypeList', // listType
                            ],
                          );
                          if (outstandingCollectionController.selectedUserTypeController.text != selectedUserType.name!) {
                            outstandingCollectionController.selectedUserNameController.clear();
                            outstandingCollectionController.selectedUserNameIdController.clear();
                            outstandingCollectionController.selectedUserBalance.value = '';
                            outstandingCollectionController.selectedOutstandingBalance.value = '';
                            if (selectedUserType.name != null && selectedUserType.name!.isNotEmpty) {
                              outstandingCollectionController.selectedUserTypeController.text = selectedUserType.name!;
                              outstandingCollectionController.selectedUserTypeId.value = selectedUserType.id!.toString();
                            }
                          }
                        },
                        validator: (value) {
                          if (outstandingCollectionController.selectedUserTypeController.text.trim().isEmpty) {
                            return 'Please select user type';
                          }
                          return null;
                        },
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            UserTypeModel selectedUserType = await Get.toNamed(
                              Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                              arguments: [
                                outstandingCollectionController.userTypeList, // list
                                'userTypeList', // listType
                              ],
                            );
                            if (outstandingCollectionController.selectedUserTypeController.text != selectedUserType.name!) {
                              outstandingCollectionController.selectedUserNameController.clear();
                              outstandingCollectionController.selectedUserNameIdController.clear();
                              outstandingCollectionController.selectedUserBalance.value = '';
                              if (selectedUserType.name != null && selectedUserType.name!.isNotEmpty) {
                                outstandingCollectionController.selectedUserTypeController.text = selectedUserType.name!;
                                outstandingCollectionController.selectedUserTypeId.value = selectedUserType.id!.toString();
                              }
                            }
                          },
                          child: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: ColorsForApp.greyColor,
                          ),
                        ),
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
                            controller: outstandingCollectionController.selectedUserNameController,
                            hintText: 'Select user',
                            readOnly: true,
                            isRequired: true,
                            onTap: () async {
                              if (outstandingCollectionController.selectedUserTypeController.text.trim().isEmpty) {
                                errorSnackBar(message: 'Please select user type');
                              } else {
                                UserData selectedUser = await Get.toNamed(
                                  Routes.SEARCHABLE_LIST_VIEW_PAGINATION_SCREEN,
                                  arguments: 'userList',
                                );
                                if (selectedUser.ownerName != null && selectedUser.ownerName!.isNotEmpty) {
                                  outstandingCollectionController.selectedUserNameController.text = selectedUser.ownerName!;
                                  outstandingCollectionController.selectedUserNameIdController.text = selectedUser.id!.toString();
                                  outstandingCollectionController.selectedUserBalance.value = selectedUser.wallet1Bal!.toStringAsFixed(2);
                                  outstandingCollectionController.selectedOutstandingBalance.value = selectedUser.outstandingBal!.toStringAsFixed(2);
                                }
                              }
                            },
                            validator: (value) {
                              if (outstandingCollectionController.selectedUserNameController.text.trim().isEmpty) {
                                return 'Please select user';
                              }
                              return null;
                            },
                            suffixIcon: GestureDetector(
                              onTap: () async {
                                UserData selectedUser = await Get.toNamed(
                                  Routes.SEARCHABLE_LIST_VIEW_PAGINATION_SCREEN,
                                  arguments: 'userList',
                                );
                                if (selectedUser.ownerName != null && selectedUser.ownerName!.isNotEmpty) {
                                  outstandingCollectionController.selectedUserNameController.text = selectedUser.ownerName!;
                                  outstandingCollectionController.selectedUserNameIdController.text = selectedUser.id!.toString();
                                  outstandingCollectionController.selectedUserBalance.value = selectedUser.wallet1Bal!.toStringAsFixed(2);
                                }
                              },
                              child: Icon(
                                Icons.keyboard_arrow_right_rounded,
                                color: ColorsForApp.greyColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Selected user outstanding balance
                      Obx(
                        () => Visibility(
                          visible: outstandingCollectionController.selectedOutstandingBalance.value.isNotEmpty ? true : false,
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
                                      outstandingCollectionController.selectedOutstandingBalance.value,
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
                            controller: outstandingCollectionController.amountController,
                            hintText: 'Enter amount',
                            maxLength: 7,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                            obscureText: false,
                            onChange: (value) {
                              if (outstandingCollectionController.amountController.text.isNotEmpty) {
                                outstandingCollectionController.amountIntoWords.value = getAmountIntoWords(int.parse(outstandingCollectionController.amountController.text.trim()));
                              } else {
                                outstandingCollectionController.amountIntoWords.value = '';
                              }
                            },
                            validator: (value) {
                              if (outstandingCollectionController.amountController.text.trim().isEmpty) {
                                return 'Please enter amount';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      // Amount in text
                      Obx(
                        () => Visibility(
                          visible: outstandingCollectionController.amountIntoWords.value.isNotEmpty ? true : false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              height(0.6.h),
                              Text(
                                outstandingCollectionController.amountIntoWords.value,
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
                            controller: outstandingCollectionController.tPinController,
                            title: 'TPIN',
                            hintText: 'Enter TPIN',
                            maxLength: 4,
                            isCompulsory: true,
                            obscureText: outstandingCollectionController.isShowTpin.value,
                            suffixIcon: IconButton(
                              icon: Icon(
                                outstandingCollectionController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                                size: 18,
                                color: ColorsForApp.secondaryColor,
                              ),
                              onPressed: () {
                                outstandingCollectionController.isShowTpin.value = !outstandingCollectionController.isShowTpin.value;
                              },
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            textInputFormatter: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            ],
                            validator: (value) {
                              if (outstandingCollectionController.tPinController.text.trim().isEmpty) {
                                return 'Please enter TPIN';
                              } /*else if (internalTransferController.tpinController.text.length < 4) {
                          return 'Please enter valid TPIN';
                        }*/
                              return null;
                            },
                          ),
                        ),
                      ),
                      // Remarks
                      CustomTextFieldWithTitle(
                        controller: outstandingCollectionController.remarkController,
                        title: 'Remarks',
                        hintText: 'Enter remarks',
                        maxLines: 4,
                        isCompulsory: true,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        validator: (value) {
                          if (outstandingCollectionController.remarkController.text.trim().isEmpty) {
                            return 'Please enter remarks';
                          }
                          return null;
                        },
                      ),
                      height(20),
                      // Proceed button
                      CommonButton(
                        bgColor: ColorsForApp.primaryColor,
                        labelColor: ColorsForApp.whiteColor,
                        label: 'Submit',
                        onPressed: () async {
                          if (outstandingCollectionFormKey.value.currentState!.validate()) {
                            // await confirmationBottomSheet(context);
                            bool result = await outstandingCollectionController.outstandingCollectionAPI();
                            if (result == true) {
                              outstandingCollectionController.resetCreditDebitWalletVariables();
                              outstandingCollectionFormKey.value = GlobalKey<FormState>();
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

  // Confirm credit wallet dailog
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
              '₹ ${outstandingCollectionController.amountController.text.trim()}.00',
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
                    "Credit into ${outstandingCollectionController.selectedUserNameController.text.trim()}'s account",
                    style: TextHelper.size14,
                  ),
                  height(5),
                  Text(
                    '(${outstandingCollectionController.selectedUserTypeController.text.trim()} - ${outstandingCollectionController.selectedWalletController.text.trim()} wallet)',
                    style: TextHelper.size14,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: outstandingCollectionController.remarkController.text.isNotEmpty ? true : false,
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
                            outstandingCollectionController.remarkController.text.trim(),
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
                bool result = await outstandingCollectionController.creditDebitWallet(paymentMode: 1);
                if (result == true) {
                  outstandingCollectionController.resetCreditDebitWalletVariables();
                  outstandingCollectionFormKey.value = GlobalKey<FormState>();
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

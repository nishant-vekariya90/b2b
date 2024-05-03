import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sizer/sizer.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../controller/retailer/internal_transfer_controller.dart';
import '../widgets/button.dart';
import '../widgets/constant_widgets.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/otp_text_field.dart';
import '../widgets/text_field.dart';
import '../widgets/text_field_with_title.dart';

class InternalTransferScreen extends StatefulWidget {
  const InternalTransferScreen({Key? key}) : super(key: key);

  @override
  State<InternalTransferScreen> createState() => _InternalTransferScreenState();
}

class _InternalTransferScreenState extends State<InternalTransferScreen> {
  final InternalTransferController internalTransferController = Get.find();
  OTPInteractor otpInTractor = OTPInteractor();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    isShowTpinField.value = checkTpinRequired(categoryCode: 'Wallet');
    initController();
  }

  void initController() {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          internalTransferController.enteredOTP.value = code;
          internalTransferController.autoReadOtp.value = code;
          Get.log('\x1B[97m[OTP] => ${internalTransferController.enteredOTP.value}\x1B[0m');
        },
        otpInteractor: otpInTractor,
      ).startListenUserConsent((code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      });
    }
  }

  @override
  void dispose() {
    internalTransferController.clearInternalTransferVariable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Wallet To Wallet Transfer',
      isShowLeadingIcon: true,
      mainBody: Form(
        key: formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          children: [
            Obx(
              () => CustomTextFieldWithTitle(
                controller: internalTransferController.usernameController,
                title: 'Username',
                hintText: 'Enter username',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                isCompulsory: true,
                readOnly: false,
                onChange: (value) {
                  internalTransferController.isValidateUser.value = false;
                },
                validator: (value) {
                  if (value!.trim() == '') {
                    return 'Please enter username';
                  }
                  return null;
                },
                suffixIcon: InkWell(
                  onTap: () async {
                    if (internalTransferController.usernameController.text.trim() == '') {
                      errorSnackBar(message: 'Please enter username');
                    } else {
                      internalTransferController.isValidUser.value = true;
                      showProgressIndicator();
                      await internalTransferController.validateUsername(isLoaderShow: false, username: internalTransferController.usernameController.text);
                      dismissProgressIndicator();
                    }
                  },
                  child: Container(
                    width: 8.h,
                    decoration: BoxDecoration(
                      color: internalTransferController.validUserModel.value.name != null && internalTransferController.validUserModel.value.name!.isNotEmpty && internalTransferController.isValidateUser.value == true
                          ? ColorsForApp.successColor.withOpacity(0.1)
                          : ColorsForApp.primaryColorBlue.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(7),
                        bottomRight: Radius.circular(7),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: internalTransferController.validUserModel.value.name != null && internalTransferController.validUserModel.value.name!.isNotEmpty && internalTransferController.isValidateUser.value == true
                        ? Text(
                            'Validated',
                            style: TextHelper.size13.copyWith(
                              color: ColorsForApp.successColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            'Validate',
                            style: TextHelper.size13.copyWith(
                              color: ColorsForApp.lightBlackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            height(2),
            Obx(
              () => internalTransferController.validUserModel.value.name != null && internalTransferController.validUserModel.value.name!.isNotEmpty
                  ? Text(
                      "User Name: ${internalTransferController.validUserModel.value.name}",
                      style: TextHelper.size14.copyWith(
                        fontFamily: boldGoogleSansFont,
                        color: ColorsForApp.primaryColor,
                      ),
                    )
                  : Container(),
            ),
            height(10),
            CommonButton(
              shadowColor: ColorsForApp.whiteColor,
              onPressed: () async {
                if (internalTransferController.validUserModel.value.name != null && internalTransferController.validUserModel.value.name!.isNotEmpty) {
                  internalTransferController.addFavouriteUserApi();
                } else {
                  errorSnackBar(message: "Please validate your number");
                }
              },
              label: 'Add to Favourite',
              labelColor: ColorsForApp.whiteColor,
              bgColor: ColorsForApp.secondaryColor,
            ),
            height(2.h),
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
                  controller: internalTransferController.amountController,
                  hintText: 'Enter the amount',
                  maxLength: 7,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  obscureText: false,
                  onChange: (value) {
                    if (internalTransferController.amountController.text.isNotEmpty && int.parse(internalTransferController.amountController.text.trim()) > 0) {
                      internalTransferController.amountIntoWords.value = getAmountIntoWords(int.parse(internalTransferController.amountController.text.trim()));
                    } else {
                      internalTransferController.amountIntoWords.value = '';
                    }
                  },
                  validator: (value) {
                    if (internalTransferController.amountController.text.trim().isEmpty) {
                      return 'Please enter amount';
                    } else if (int.parse(internalTransferController.amountController.text.trim()) <= 0) {
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
                visible: internalTransferController.amountIntoWords.value.isNotEmpty ? true : false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height(0.6.h),
                    Text(
                      internalTransferController.amountIntoWords.value,
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
            CustomTextFieldWithTitle(
              controller: internalTransferController.remarkController,
              title: 'Remark',
              hintText: 'Enter remark',
              maxLines: 3,
              isCompulsory: true,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Please enter remark';
                }
                return null;
              },
            ),
            height(10),
            // TPIN
            Visibility(
              visible: isShowTpinField.value,
              child: Obx(
                () => CustomTextFieldWithTitle(
                  controller: internalTransferController.tpinController,
                  title: 'TPIN',
                  hintText: 'Enter TPIN',
                  maxLength: 4,
                  isCompulsory: true,
                  obscureText: internalTransferController.isShowTpin.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      internalTransferController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                      size: 18,
                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                    ),
                    onPressed: () {
                      internalTransferController.isShowTpin.value = !internalTransferController.isShowTpin.value;
                    },
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (internalTransferController.tpinController.text.trim().isEmpty) {
                      return 'Please enter TPIN';
                    }
                    return null;
                  },
                ),
              ),
            ),
            height(1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: CommonButton(
                    shadowColor: ColorsForApp.shadowColor,
                    onPressed: () {
                      internalTransferController.getFavUserListApi();
                      viewFavUserBottomSheet();
                    },
                    label: 'Favourites',
                    border: Border.all(
                      color: ColorsForApp.primaryColor,
                    ),
                    labelColor: ColorsForApp.primaryColor,
                    bgColor: ColorsForApp.whiteColor,
                  ),
                ),
                width(5.w),
                Expanded(
                  child: CommonButton(
                    shadowColor: ColorsForApp.shadowColor,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (internalTransferController.isValidUser.value == false) {
                          errorSnackBar(message: 'Please first validate username');
                        } else {
                          bool result = await internalTransferController.sendOtpForInternalTransfer();
                          if (result == true) {
                            if (internalTransferController.isVerify.value == false) {
                              internalTransferController.clearInternalTransferVariable();
                              formKey.currentState!.reset();
                            } else {
                              internalTransferModelBottomSheet();
                            }
                          }
                        }
                      }
                    },
                    label: 'Transfer',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // OTP bottom sheet
  Future internalTransferModelBottomSheet() {
    internalTransferController.startTimer();
    return customBottomSheet(
      enableDrag: false,
      isDismissible: false,
      preventToClose: false,
      isScrollControlled: true,
      children: [
        Text(
          'Verify Your OTP',
          style: TextHelper.size20.copyWith(
            fontFamily: boldGoogleSansFont,
            color: ColorsForApp.lightBlackColor,
          ),
        ),
        height(10),
        Text(
          'We have sent a 6-digit OTP',
          style: TextHelper.size15.copyWith(
            color: ColorsForApp.hintColor,
          ),
        ),
        height(20),
        Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: CustomOtpTextField(
              otpList: internalTransferController.autoReadOtp.isNotEmpty && internalTransferController.autoReadOtp.value != '' ? internalTransferController.autoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: true,
              onChanged: (value) {
                internalTransferController.enteredOTP.value = value;
              },
            ),
          ),
        ),
        height(15),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                internalTransferController.isResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: internalTransferController.isResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus the CustomOtpTextField
                          FocusScope.of(Get.context!).unfocus();
                          if (internalTransferController.isResendButtonShow.value == true) {
                            internalTransferController.enteredOTP.value = '';
                            initController();
                            bool result = await internalTransferController.sendOtpForInternalTransfer();
                            if (result == true) {
                              internalTransferController.resetTimer();
                              internalTransferController.startTimer();
                            }
                          }
                        },
                        child: Text(
                          'Resend',
                          style: TextHelper.size14.copyWith(
                            fontFamily: boldGoogleSansFont,
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                      )
                    : Text(
                        '${(internalTransferController.otpTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(internalTransferController.otpTotalSecond.value % 60).toString().padLeft(2, '0')}',
                        style: TextHelper.size14.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
              ),
            ],
          ),
        ),
        height(30),
      ],
      customButtons: Row(
        children: [
          Expanded(
            child: CommonButton(
              onPressed: () {
                Get.back();
                internalTransferController.enteredOTP.value = '';
                initController();
                internalTransferController.resetTimer();
              },
              label: 'Cancel',
              labelColor: ColorsForApp.primaryColor,
              bgColor: ColorsForApp.whiteColor,
              border: Border.all(
                color: ColorsForApp.primaryColor,
              ),
            ),
          ),
          width(15),
          Expanded(
            child: CommonButton(
              onPressed: () async {
                if (internalTransferController.enteredOTP.value.isEmpty || internalTransferController.enteredOTP.value.contains('null') || internalTransferController.enteredOTP.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  bool result = await internalTransferController.confirmInternalTransfer();
                  if (result == true) {
                    internalTransferController.clearInternalTransferVariable();
                    formKey.currentState!.reset();
                  }
                }
              },
              label: 'Verify',
              labelColor: ColorsForApp.whiteColor,
              bgColor: ColorsForApp.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Future viewFavUserBottomSheet() {
    return customBottomSheet(
      enableDrag: true,
      isDismissible: true,
      preventToClose: false,
      children: [
        InkWell(
            onTap: () {
              Get.back();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Favourite Users',
                  style: TextHelper.size18.copyWith(color: ColorsForApp.lightBlackColor.withOpacity(0.7), fontFamily: mediumGoogleSansFont),
                ),
                const Icon(
                  Icons.cancel,
                  size: 24,
                  color: Colors.black,
                ),
              ],
            )),
        height(3.h),
        Obx(
          () => internalTransferController.favUserList.isEmpty
              ? notFoundText(text: 'No Data found')
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: internalTransferController.favUserList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.back();
                        internalTransferController.validateUsername(isLoaderShow: false, username: internalTransferController.favUserList[index].favUser!);
                      },
                      child: customCard(
                        shadowColor: ColorsForApp.secondaryColor.withOpacity(0.5),
                        child: Column(
                          children: [
                            height(2.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Name',
                                  style: TextHelper.size16.copyWith(color: ColorsForApp.lightBlackColor.withOpacity(0.7), fontFamily: mediumGoogleSansFont),
                                ),
                                Text(
                                  internalTransferController.favUserList[index].favUserName.toString(),
                                  style: TextHelper.size16.copyWith(color: ColorsForApp.lightBlackColor.withOpacity(0.7), fontFamily: mediumGoogleSansFont),
                                ),
                                width(1.w),
                                InkWell(
                                    onTap: () {
                                      internalTransferController.removeFavouriteUser(id: internalTransferController.favUserList[index].id!);
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      size: 24,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                            height(1.h),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        height(2.h),
      ],
    );
  }
}

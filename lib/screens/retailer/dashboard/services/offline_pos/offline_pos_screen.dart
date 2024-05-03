import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/offline_pos_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/permission_handler.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field.dart';
import '../../../../../widgets/text_field_with_title.dart';

class OfflinePosScreen extends StatelessWidget {
  final OfflinePosController offlinePosController = Get.find();
  final Rx<GlobalKey<FormState>> offlinePosFormKey = GlobalKey<FormState>().obs;
  OfflinePosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 10.h,
      title: 'Offline POS',
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
                Assets.imagesOfflinePosTopBgImage,
              ),
            ),
            width(2.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Offline POS',
                    style: TextHelper.size14.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    'Allows merchants to accept card payments on mobile devices, enhancing flexibility and convenience.',
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
            key: offlinePosFormKey.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(2.h),
                // Transaction ref no
                CustomTextFieldWithTitle(
                  controller: offlinePosController.transactionRefNumberController,
                  title: 'Transaction Ref Number',
                  hintText: 'Enter transaction ref number',
                  maxLength: 20,
                  isCompulsory: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please enter transaction ref number';
                    } else if (value.trim().length < 4) {
                      return 'Please enter valid transaction ref number';
                    }
                    return null;
                  },
                ),
                // Card type
                CustomTextFieldWithTitle(
                  controller: offlinePosController.cardTypeController,
                  title: 'Card Type',
                  hintText: 'Select card type',
                  readOnly: true,
                  isCompulsory: true,
                  onTap: () async {
                    String selectedCardType = await Get.toNamed(
                      Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                      arguments: [
                        offlinePosController.cardTypeList, // modelList
                        'string', // listType
                      ],
                    );
                    if (selectedCardType != '' && selectedCardType.isNotEmpty) {
                      offlinePosController.cardTypeController.text = selectedCardType;
                    }
                  },
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please select card type';
                    }
                    return null;
                  },
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
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
                      controller: offlinePosController.amountController,
                      hintText: 'Enter amount',
                      maxLength: 9,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChange: (value) {
                        if (offlinePosController.amountController.text.isNotEmpty && int.parse(offlinePosController.amountController.text.trim()) > 0) {
                          offlinePosController.amountIntoWords.value = getAmountIntoWords(int.parse(offlinePosController.amountController.text.trim()));
                        } else {
                          offlinePosController.amountIntoWords.value = '';
                        }
                      },
                      validator: (value) {
                        String amountText = offlinePosController.amountController.text.trim();
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
                    visible: offlinePosController.amountIntoWords.value.isNotEmpty ? true : false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(0.6.h),
                        Text(
                          offlinePosController.amountIntoWords.value,
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
                // Link expiry date
                CustomTextFieldWithTitle(
                  controller: offlinePosController.transactionDateController,
                  title: 'Transaction Date',
                  hintText: 'Select transaction date',
                  readOnly: true,
                  isCompulsory: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  suffixIcon: Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  onTap: () async {
                    await customDatePicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year - 1),
                      initialDate: DateTime.now(),
                      lastDate: DateTime.now(),
                      controller: offlinePosController.transactionDateController,
                      dateFormat: 'MM/dd/yyyy',
                    );
                  },
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please select transaction date';
                    }
                    return null;
                  },
                ),
                // Transaction slip
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Upload transaction slip',
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
                height(5),
                Text(
                  'Transaction slip in jpg, png, jpeg format with maximum 6 MB can be uploaded.',
                  style: TextHelper.size12.copyWith(
                    color: ColorsForApp.errorColor,
                  ),
                ),
                height(10),
                offlinePosController.transactionSlipFile.value.path.isNotEmpty
                    ? SizedBox(
                        height: 21.5.w,
                        width: 21.5.w,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            InkWell(
                              onTap: () async {
                                OpenResult openResult = await OpenFile.open(offlinePosController.transactionSlipFile.value.path);
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
                                    offlinePosController.transactionSlipFile.value,
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
                                  offlinePosController.transactionSlipFile.value = File('');
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
                    : GestureDetector(
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
                          alignment: Alignment.center,
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
                height(2.h),
                // Submit button
                CommonButton(
                  label: 'Submit',
                  onPressed: () async {
                    // Unfocus text-field
                    FocusScope.of(context).unfocus();
                    if (Get.isSnackbarOpen) {
                      Get.back();
                    }
                    if (offlinePosFormKey.value.currentState!.validate()) {
                      if (offlinePosController.transactionSlipFile.value.path.isEmpty) {
                        errorSnackBar(message: 'Please upload transaction slip');
                      } else {
                        bool result = await offlinePosController.offlinePosOrderCreate();
                        if (result == true) {
                          offlinePosController.resetOfflinePosVariables();
                          offlinePosFormKey.value = GlobalKey<FormState>();
                        }
                      }
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

  // Image source dailog
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
            'Enhance your transaction by uploading a slip. Capture a photo or choose from your phone for quick processing.',
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
                        offlinePosController.transactionSlipFile.value = capturedFile;
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
                                    offlinePosController.transactionSlipFile.value = pickedFile;
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
}

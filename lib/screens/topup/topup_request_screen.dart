import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';

import '../../controller/topup_controller.dart';
import '../../generated/assets.dart';
import '../../model/master/bank_list_model.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/permission_handler.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/text_field.dart';
import '../../widgets/text_field_with_title.dart';

class TopupRequestScreen extends StatefulWidget {
  const TopupRequestScreen({Key? key}) : super(key: key);

  @override
  State<TopupRequestScreen> createState() => _TopupRequestScreenState();
}

class _TopupRequestScreenState extends State<TopupRequestScreen> {
  final TopupController topupController = Get.find();
  Rx<GlobalKey<FormState>> topupRequestFormKey = GlobalKey<FormState>().obs;
  File? pickedFile;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      await topupController.getRequestParentList(isLoaderShow: false);
      if (topupController.toRequestList.contains('Parent')) {
        await topupController.getMasterBankListByUser(isLoaderShow: false);
      }
      if (topupController.toRequestList.contains('Administrator')) {
        await topupController.getMasterBankListByAdmin(isLoaderShow: false);
      }
      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    topupController.resetTopupRequestVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 10.h,
      title: 'Top-up Request',
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
                    'Top-up Request',
                    style: TextHelper.size14.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    'Just few clicks can top-up you with immediate funds via parent or administrator.',
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
          height(1.h),
          Expanded(
            child: SingleChildScrollView(
              // physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Obx(
                () => Form(
                  key: topupRequestFormKey.value,
                  child: Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(10),
                        // Select topup request to
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Topup request to',
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
                        SizedBox(
                          height: 3.h,
                          width: 100.w,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: topupController.toRequestList.length,
                            itemBuilder: (context, index) {
                              String data = topupController.toRequestList[index];
                              return Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Radio(
                                      value: data,
                                      groupValue: topupController.selectedUserTypeRadio.value,
                                      onChanged: (value) {
                                        if (topupController.selectedUserTypeRadio.value != data) {
                                          topupController.depositBankController.clear();
                                          topupController.selectedBankId.value = 0;
                                        }
                                        topupController.selectedUserTypeRadio.value = value!;
                                      },
                                      activeColor: ColorsForApp.primaryColor,
                                      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                    ),
                                    width(5),
                                    GestureDetector(
                                      onTap: () {
                                        if (topupController.selectedUserTypeRadio.value != data) {
                                          topupController.depositBankController.clear();
                                          topupController.selectedBankId.value = 0;
                                        }
                                        topupController.selectedUserTypeRadio.value = data;
                                      },
                                      child: Text(
                                        data,
                                        style: TextHelper.size14.copyWith(
                                          color: topupController.selectedUserTypeRadio.value == data ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                                          fontFamily: topupController.selectedUserTypeRadio.value == data ? mediumGoogleSansFont : regularGoogleSansFont,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return width(15);
                            },
                          ),
                        ),
                        height(10),
                        // Select deposit bank
                        CustomTextFieldWithTitle(
                          controller: topupController.depositBankController,
                          title: 'Deposit bank',
                          hintText: 'Select deposit bank',
                          readOnly: true,
                          isCompulsory: true,
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: ColorsForApp.secondaryColor.withOpacity(0.5),
                          ),
                          onTap: () async {
                            MasterBankListModel selectedBank = await Get.toNamed(
                              Routes.SEARCHABLE_LIST_VIEW_WITH_IMAGE_SCREEN,
                              arguments: [
                                topupController.selectedUserTypeRadio.value == 'Parent' ? topupController.masterBankListByUser : topupController.masterBankListByAdmin, // modelList
                                'bankList', // modelName
                              ],
                            );
                            if (selectedBank.name != null && selectedBank.name!.isNotEmpty) {
                              topupController.depositBankController.text = selectedBank.name!;
                              topupController.selectedBankId.value = selectedBank.id!;
                            }
                          },
                          validator: (value) {
                            if (topupController.depositBankController.text.trim().isEmpty) {
                              return 'Please select deposit bank';
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
                              controller: topupController.amountController,
                              hintText: 'Enter amount',
                              maxLength: 7,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              textInputFormatter: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              suffixIcon: Icon(
                                Icons.currency_rupee_rounded,
                                size: 18,
                                color: ColorsForApp.secondaryColor.withOpacity(0.5),
                              ),
                              onChange: (value) {
                                if (topupController.amountController.text.isNotEmpty && int.parse(topupController.amountController.text.trim()) > 0) {
                                  topupController.amountIntoWords.value = getAmountIntoWords(int.parse(topupController.amountController.text.trim()));
                                } else {
                                  topupController.amountIntoWords.value = '';
                                }
                              },
                              validator: (value) {
                                if (topupController.amountController.text.trim().isEmpty) {
                                  return 'Please enter amount';
                                } else if (int.parse(topupController.amountController.text.trim()) <= 0) {
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
                            visible: topupController.amountIntoWords.value.isNotEmpty ? true : false,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height(0.6.h),
                                Text(
                                  topupController.amountIntoWords.value,
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
                        // Select payment mode
                        CustomTextFieldWithTitle(
                          controller: topupController.paymentModeController,
                          title: 'Payment mode',
                          hintText: 'Select payment mode',
                          readOnly: true,
                          isCompulsory: true,
                          suffixIcon: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: ColorsForApp.secondaryColor.withOpacity(0.5),
                          ),
                          onTap: () async {
                            String selectedPaymentMode = await Get.toNamed(
                              Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                              arguments: [
                                topupController.masterPaymentModeList, // list
                                'string', // listType
                              ],
                            );
                            if (selectedPaymentMode.isNotEmpty) {
                              topupController.paymentModeController.text = selectedPaymentMode;
                              topupController.selectedPaymentMode.value = selectedPaymentMode;
                            }
                          },
                          validator: (value) {
                            if (topupController.paymentModeController.text.trim().isEmpty) {
                              return 'Please select payment mode';
                            }
                            return null;
                          },
                        ),
                        topupController.selectedPaymentMode.value == 'Cash'
                            // Cash type
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text: 'Cash type',
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Radio(
                                        value: 'CDM Machine',
                                        groupValue: topupController.selectedCashTypeRadio.value,
                                        onChanged: (value) {
                                          topupController.selectedCashTypeRadio.value = value!;
                                        },
                                        activeColor: ColorsForApp.primaryColor,
                                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                      ),
                                      width(5),
                                      GestureDetector(
                                        onTap: () {
                                          topupController.selectedCashTypeRadio.value = 'CDM Machine';
                                        },
                                        child: Text(
                                          'CDM Machine',
                                          style: TextHelper.size14.copyWith(
                                            color: topupController.selectedCashTypeRadio.value == 'CDM Machine' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                                            fontWeight: topupController.selectedCashTypeRadio.value == 'CDM Machine' ? FontWeight.w500 : FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      width(15),
                                      Radio(
                                        value: 'Branch Deposit',
                                        groupValue: topupController.selectedCashTypeRadio.value,
                                        onChanged: (value) {
                                          topupController.selectedCashTypeRadio.value = value!;
                                        },
                                        activeColor: ColorsForApp.primaryColor,
                                        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                                      ),
                                      width(5),
                                      GestureDetector(
                                        onTap: () {
                                          topupController.selectedCashTypeRadio.value = 'Branch Deposit';
                                        },
                                        child: Text(
                                          'Branch Deposit',
                                          style: TextHelper.size14.copyWith(
                                            color: topupController.selectedCashTypeRadio.value == 'Branch Deposit' ? ColorsForApp.lightBlackColor : ColorsForApp.lightBlackColor.withOpacity(0.5),
                                            fontWeight: topupController.selectedCashTypeRadio.value == 'Branch Deposit' ? FontWeight.w500 : FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  height(10),
                                ],
                              )
                            : topupController.selectedPaymentMode.value == 'Cheque'
                                // Cheque type
                                ? CustomTextFieldWithTitle(
                                    controller: topupController.chequeNumberController,
                                    title: 'Cheque/DD number',
                                    hintText: 'Enter cheque/dd number',
                                    isCompulsory: true,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    textInputFormatter: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (value) {
                                      if (topupController.chequeNumberController.text.trim().isEmpty) {
                                        return 'Please enter cheque/dd number';
                                      }
                                      return null;
                                    },
                                  )
                                : topupController.selectedPaymentMode.value == 'RTGS' ||
                                        topupController.selectedPaymentMode.value == 'NEFT' ||
                                        topupController.selectedPaymentMode.value == 'Fund Transfer' ||
                                        topupController.selectedPaymentMode.value == 'IMPS'
                                    ? // UTR Number
                                    CustomTextFieldWithTitle(
                                        controller: topupController.utrController,
                                        title: 'UTR number',
                                        hintText: 'Enter utr number',
                                        isCompulsory: true,
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        validator: (value) {
                                          if (topupController.utrController.text.trim().isEmpty) {
                                            return 'Please enter utr number';
                                          }
                                          return null;
                                        },
                                      )
                                    : Container(),
                        // Payment Date
                        topupController.selectedPaymentMode.value == 'Cheque'
                            ? CustomTextFieldWithTitle(
                                controller: topupController.paymentDateController,
                                title: 'Payment date',
                                hintText: 'Select payment date',
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
                                    lastDate: DateTime(DateTime.now().year + 1),
                                    controller: topupController.paymentDateController,
                                    dateFormat: 'yyyy-MM-dd',
                                  );
                                },
                                validator: (value) {
                                  if (topupController.paymentDateController.text.trim().isEmpty) {
                                    return 'Please select payment date';
                                  }
                                  return null;
                                },
                              )
                            : CustomTextFieldWithTitle(
                                controller: topupController.paymentDateController,
                                title: 'Payment date',
                                hintText: 'Select payment date',
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
                                    controller: topupController.paymentDateController,
                                    dateFormat: 'yyyy-MM-dd',
                                  );
                                },
                                validator: (value) {
                                  if (topupController.paymentDateController.text.trim().isEmpty) {
                                    return 'Please select payment date';
                                  }
                                  return null;
                                },
                              ),
                        // User remark
                        CustomTextFieldWithTitle(
                          controller: topupController.userRemarkController,
                          title: 'User Remark',
                          hintText: 'Enter user remark',
                          isCompulsory: true,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (topupController.userRemarkController.text.trim().isEmpty) {
                              return 'Please enter remark';
                            }
                            return null;
                          },
                        ),
                        height(5),
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
                        topupController.transactionSlipFile.value.path.isNotEmpty
                            ? SizedBox(
                                height: 21.5.w,
                                width: 21.5.w,
                                child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        OpenResult openResult = await OpenFile.open(topupController.transactionSlipFile.value.path);
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
                                            topupController.transactionSlipFile.value,
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
                                          topupController.transactionSlipFile.value = File('');
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
                        // Proceed button
                        CommonButton(
                          bgColor: ColorsForApp.primaryColor,
                          labelColor: ColorsForApp.whiteColor,
                          label: 'Proceed',
                          onPressed: () async {
                            // Unfocus text-field
                            FocusScope.of(context).unfocus();
                            if (Get.isSnackbarOpen) {
                              Get.back();
                            }
                            if (topupRequestFormKey.value.currentState!.validate()) {
                              if (topupController.transactionSlipFile.value.path.isEmpty || topupController.transactionSlipFile.value.path == '') {
                                errorSnackBar(message: 'Please upload transaction slip');
                              } else {
                                await confirmationBottomSheet();
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
            ),
          ),
        ],
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
                        topupController.transactionSlipFile.value = capturedFile;
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
                                    topupController.transactionSlipFile.value = pickedFile;
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

  // Confirmattion bottomsheet
  Future<dynamic> confirmationBottomSheet() {
    return customBottomSheet(
      isScrollControlled: true,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Top-up Request Confirmation',
          textAlign: TextAlign.center,
          style: TextHelper.size20.copyWith(
            fontFamily: boldGoogleSansFont,
          ),
        ),
        height(2.h),
        Center(
          child: Text(
            '₹ ${topupController.amountController.text.trim()}.00',
            style: TextHelper.h1.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.primaryColor,
            ),
          ),
        ),
        height(1.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: ColorsForApp.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Deposit in ${topupController.depositBankController.text.trim()} bank',
                style: TextHelper.size14,
              ),
              height(5),
              Text(
                '(${topupController.paymentModeController.text.trim()} - ${topupController.selectedPaymentMode.value == 'Cash' ? topupController.selectedCashTypeRadio.value : topupController.selectedPaymentMode.value == 'Cheque' ? topupController.chequeNumberController.text.trim() : topupController.utrController.text.trim()})',
                style: TextHelper.size14,
              ),
            ],
          ),
        ),
        height(1.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
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
                  'Paid on ${topupController.paymentDateController.text.trim()}',
                  style: TextHelper.size13,
                ),
              ),
            ],
          ),
        ),
      ],
      isShowButton: true,
      buttonText: 'Top-up',
      onTap: () async {
        if (Get.isSnackbarOpen) {
          Get.back();
        }
        bool result = await topupController.topupRequest();
        if (result == true) {
          topupController.resetTopupRequestVariables();
          topupRequestFormKey.value = GlobalKey<FormState>();
        }
      },
    );
  }
}

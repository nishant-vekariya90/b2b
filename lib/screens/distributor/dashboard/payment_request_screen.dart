import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:sizer/sizer.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/permission_handler.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../controller/distributor/payment_controller.dart';
import '../../../model/payment/payment_model.dart';
import '../../../widgets/text_field_with_title.dart';

class PaymentRequestScreen extends StatefulWidget {
  const PaymentRequestScreen({Key? key}) : super(key: key);

  @override
  State<PaymentRequestScreen> createState() => _PaymentRequestScreenState();
}

class _PaymentRequestScreenState extends State<PaymentRequestScreen> {
  final PaymentController paymentController = Get.find();
  ScrollController scrollController = ScrollController();
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    try {
      isShowTpinField.value = checkTpinRequired(categoryCode: 'Wallet');
      await paymentController.getPaymentRequest(pageNumber: 1);
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels && paymentController.currentPage.value < paymentController.totalPages.value) {
          paymentController.currentPage.value++;
          await paymentController.getPaymentRequest(
            pageNumber: paymentController.currentPage.value,
            isLoaderShow: false,
          );
        }
      });
    } catch (e) {
      isShowTpinField.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Payment Request',
      isShowLeadingIcon: true,
      mainBody: Column(
        children: [
          Obx(
            () => Expanded(
              child: paymentController.paymentRequestList.isEmpty
                  ? notFoundText(text: 'No payment request found')
                  : RefreshIndicator(
                      color: ColorsForApp.primaryColor,
                      onRefresh: () async {
                        isLoading.value = true;
                        await Future.delayed(const Duration(seconds: 1), () async {
                          await paymentController.getPaymentRequest(pageNumber: 1, isLoaderShow: false);
                        });
                        isLoading.value = false;
                      },
                      child: ListView.separated(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                        itemCount: paymentController.paymentRequestList.length,
                        itemBuilder: (context, index) {
                          if (index == paymentController.paymentRequestList.length - 1 && paymentController.hasNext.value) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorsForApp.primaryColor,
                                ),
                              ),
                            );
                          } else {
                            PaymentData paymentData = paymentController.paymentRequestList[index];
                            return customCard(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Payment Mode : ${paymentData.paymentMode != null ? paymentController.masterPaymentModeList[paymentData.paymentMode!] : '-'}',
                                          style: TextHelper.size13.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                            color: ColorsForApp.lightBlackColor,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: paymentData.status == 0
                                                  ? ColorsForApp.chilliRedColor
                                                  : paymentData.status == 1
                                                      ? ColorsForApp.successColor
                                                      : ColorsForApp.orangeColor,
                                              width: 0.2,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            child: Text(
                                              paymentController.ticketStatus(paymentData.status!),
                                              style: TextHelper.size13.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                                color: paymentData.status == 0
                                                    ? ColorsForApp.chilliRedColor
                                                    : paymentData.status == 1
                                                        ? ColorsForApp.successColor
                                                        : ColorsForApp.orangeColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    height(1.5.h),
                                    Divider(
                                      height: 0,
                                      thickness: 0.2,
                                      color: ColorsForApp.greyColor,
                                    ),
                                    height(1.5.h),
                                    // Created By
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: customKeyValueText(
                                            key: 'Created By : ',
                                            value: paymentData.createdBy != null && paymentData.createdBy!.isNotEmpty ? paymentData.createdBy! : '-',
                                          ),
                                        ),
                                        width(2.w),
                                        // Amount
                                        Visibility(
                                          visible: paymentData.status != null ? true : false,
                                          child: Text(
                                            paymentData.amount != null ? '₹ ${paymentData.amount!.toStringAsFixed(2)}' : '₹ 0.00',
                                            style: TextHelper.size14.copyWith(
                                              fontFamily: boldGoogleSansFont,
                                              color: paymentData.status == 1 ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Deposit Bank
                                    customKeyValueText(
                                      key: 'Deposit Bank : ',
                                      value: paymentData.bankDetails != null && paymentData.bankDetails!.isNotEmpty ? paymentData.bankDetails! : '-',
                                    ),
                                    // Remark
                                    Visibility(
                                      visible: paymentData.status != null && paymentData.status! == 0 ? true : false,
                                      child: customKeyValueText(
                                        key: 'Remark : ',
                                        value: paymentData.remarks != null && paymentData.remarks!.isNotEmpty ? paymentData.remarks! : '-',
                                      ),
                                    ),
                                    paymentData.paymentMode != null && paymentData.paymentMode == 0
                                        // Cash type
                                        ? customKeyValueText(
                                            key: 'Cash Type : ',
                                            value: paymentData.cashType != null && paymentData.cashType!.isNotEmpty ? paymentData.cashType! : '-',
                                          )
                                        : paymentData.paymentMode != null && paymentData.paymentMode == 1
                                            // Cheque No.
                                            ? customKeyValueText(
                                                key: 'Cheque No. : ',
                                                value: paymentData.chequeNo != null && paymentData.chequeNo!.isNotEmpty ? paymentData.chequeNo! : '-',
                                              )
                                            // UTR No.
                                            : customKeyValueText(
                                                key: 'UTR No. : ',
                                                value: paymentData.utRNo != null && paymentData.utRNo!.isNotEmpty ? paymentData.utRNo! : '-',
                                              ),
                                    // Payment date
                                    customKeyValueText(
                                      key: 'Payment Date : ',
                                      value: paymentData.paymentDate != null && paymentData.paymentDate!.isNotEmpty ? paymentController.formatDateTime(paymentData.paymentDate!) : '-',
                                    ),
                                    // Created on
                                    customKeyValueText(
                                      key: 'Created On : ',
                                      value: paymentData.createdOn != null && paymentData.createdOn!.isNotEmpty ? paymentController.formatDateTime(paymentData.createdOn!) : '-',
                                    ),
                                    // Transaction slip
                                    Visibility(
                                      visible: paymentData.transactionSlip == null ? false : true,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Transaction slip : ',
                                            style: TextHelper.size12.copyWith(
                                              fontFamily: mediumGoogleSansFont,
                                              color: ColorsForApp.greyColor,
                                            ),
                                          ),
                                          width(5),
                                          Expanded(
                                            child: InkWell(
                                                onTap: () async {
                                                  await PermissionHandlerPermissionService.handleStoragePermission(context).then((bool storagePermission) async {
                                                    if (storagePermission == true) {
                                                      showProgressIndicator();
                                                      File? file;
                                                      try {
                                                        file = await DefaultCacheManager().getSingleFile((paymentData.transactionSlip!));
                                                      } catch (e) {
                                                        dismissProgressIndicator();
                                                      }
                                                      dismissProgressIndicator();
                                                      OpenResult openResult = await OpenFile.open(file!.path);
                                                      if (openResult.type != ResultType.done) {
                                                        errorSnackBar(message: openResult.message);
                                                      }
                                                    }
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'View slip',
                                                      style: TextHelper.size12.copyWith(
                                                        fontFamily: mediumGoogleSansFont,
                                                        color: ColorsForApp.primaryColorBlue,
                                                      ),
                                                      textAlign: TextAlign.justify,
                                                    ),
                                                    width(0.4.h),
                                                    Icon(
                                                      Icons.filter,
                                                      color: ColorsForApp.primaryColorBlue,
                                                      size: 3.5.w,
                                                    )
                                                  ],
                                                )),
                                          ),
                                          height(2.5.h),
                                        ],
                                      ),
                                    ),
                                    height(1.h),
                                    // Approve | Reject
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              paymentController.tpinController.clear();
                                              paymentController.remarksController.clear();
                                              await confirmationBottomSheet(
                                                context: context,
                                                paymentData: paymentData,
                                                status: 0,
                                              );
                                            },
                                            child: Container(
                                              height: 4.5.h,
                                              decoration: BoxDecoration(
                                                color: ColorsForApp.stepBorderColor.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Reject',
                                                style: TextHelper.size14.copyWith(
                                                  fontFamily: mediumGoogleSansFont,
                                                  color: ColorsForApp.lightBlackColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        width(4.w),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              paymentController.tpinController.clear();
                                              paymentController.remarksController.clear();
                                              await confirmationBottomSheet(
                                                context: context,
                                                paymentData: paymentData,
                                                status: 1,
                                              );
                                            },
                                            child: Container(
                                              height: 4.5.h,
                                              decoration: BoxDecoration(
                                                color: ColorsForApp.successColor,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Approve',
                                                style: TextHelper.size14.copyWith(
                                                  fontFamily: mediumGoogleSansFont,
                                                  color: ColorsForApp.whiteColor,
                                                ),
                                              ),
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
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return height(1.h);
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Confirm request dailog
  Future<dynamic> confirmationBottomSheet({required BuildContext context, required PaymentData paymentData, required int status}) {
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
              'Payment Request Confirmation',
              textAlign: TextAlign.center,
              style: TextHelper.size20.copyWith(
                fontFamily: boldGoogleSansFont,
              ),
            ),
            height(20),
            Text(
              paymentData.amount != null ? '₹ ${paymentData.amount!.toStringAsFixed(2)}' : '₹ 0.00',
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
                    'Deposit in ${paymentData.bankDetails != null && paymentData.bankDetails!.isNotEmpty ? paymentData.bankDetails! : '-'}',
                    textAlign: TextAlign.center,
                    style: TextHelper.size14,
                  ),
                  height(5),
                  Text(
                    '(${paymentData.paymentMode != null ? paymentController.masterPaymentModeList[paymentData.paymentMode!] : '-'} - ${paymentData.paymentMode != null && paymentData.paymentMode == 0 ? paymentData.cashType != null && paymentData.cashType!.isNotEmpty ? paymentData.cashType! : '-' : paymentData.paymentMode != null && paymentData.paymentMode == 1 ? paymentData.chequeNo != null && paymentData.chequeNo!.isNotEmpty ? paymentData.chequeNo! : '-' : paymentData.utRNo != null && paymentData.utRNo!.isNotEmpty ? paymentData.utRNo! : '-'})',
                    style: TextHelper.size14,
                  ),
                ],
              ),
            ),
            height(8),
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
                      'Paid on ${paymentData.paymentDate != null && paymentData.paymentDate!.isNotEmpty ? paymentController.formatDateTime(paymentData.paymentDate!) : '-'}',
                      style: TextHelper.size13,
                    ),
                  ),
                ],
              ),
            ),
            // TPIN
            Visibility(
              visible: isShowTpinField.value,
              child: Obx(
                () => CustomTextFieldWithTitle(
                  controller: paymentController.tpinController,
                  title: 'TPIN',
                  hintText: 'Enter TPIN',
                  maxLength: 4,
                  isCompulsory: true,
                  obscureText: paymentController.isShowTpin.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      paymentController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                      size: 18,
                      color: ColorsForApp.secondaryColor,
                    ),
                    onPressed: () {
                      paymentController.isShowTpin.value = !paymentController.isShowTpin.value;
                    },
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  validator: (value) {
                    if (paymentController.tpinController.text.trim().isEmpty) {
                      return 'Please enter TPIN';
                    } /*else if (paymentController.tpinController.text.length < 4) {
                      return 'Please enter valid TPIN';
                    }*/
                    return null;
                  },
                ),
              ),
            ),
            CustomTextFieldWithTitle(
              controller: paymentController.remarksController,
              title: 'Remark',
              hintText: 'Write remark',
              isCompulsory: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
            height(20),
            CommonButton(
              label: status == 0 ? 'Reject' : 'Approve',
              onPressed: () async {
                if (isShowTpinField.value == true) {
                  if (paymentController.tpinController.text.isEmpty) {
                    errorSnackBar(message: 'Please enter tpin');
                  } else if (paymentController.remarksController.text.isEmpty) {
                    errorSnackBar(message: 'Please enter remark');
                  } else {
                    if (Get.isSnackbarOpen) {
                      Get.back();
                    }
                    showProgressIndicator();
                    await paymentController.changePaymentStatus(
                      paymentData: paymentData,
                      status: status,
                      isLoaderShow: false,
                    );
                    dismissProgressIndicator();
                  }
                } else if (paymentController.remarksController.text.isEmpty) {
                  errorSnackBar(message: 'Please enter remark');
                } else {
                  if (Get.isSnackbarOpen) {
                    Get.back();
                  }
                  showProgressIndicator();
                  await paymentController.changePaymentStatus(
                    paymentData: paymentData,
                    status: status,
                    isLoaderShow: false,
                  );
                  dismissProgressIndicator();
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

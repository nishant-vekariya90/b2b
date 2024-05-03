import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:sizer/sizer.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/permission_handler.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../controller/distributor/payment_controller.dart';
import '../../../model/payment/payment_model.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final PaymentController paymentController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    paymentController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    paymentController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    paymentController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(paymentController.fromDate.value);
    paymentController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(paymentController.toDate.value);
    await paymentController.getPaymentHistory(pageNumber: paymentController.currentPage.value);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && paymentController.currentPage.value < paymentController.totalPages.value) {
        paymentController.currentPage.value++;
        await paymentController.getPaymentHistory(
          pageNumber: paymentController.currentPage.value,
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Payment History',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        height: 7.h,
        padding: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: ColorsForApp.stepBgColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            width(2.w),
            Expanded(
              child: Text(
                'Date',
                style: TextHelper.size15.copyWith(
                  fontFamily: mediumGoogleSansFont,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                customSimpleDialogForDatePicker(
                  context: context,
                  initialDateRange: DateRange(paymentController.fromDate.value, paymentController.toDate.value),
                  onDateRangeChanged: (DateRange? date) {
                    paymentController.fromDate.value = date!.start;
                    paymentController.toDate.value = date.end;
                  },
                  noText: 'Cancel',
                  onNo: () {
                    Get.back();
                  },
                  yesText: 'Proceed',
                  onYes: () async {
                    Get.back();
                    paymentController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(paymentController.fromDate.value);
                    paymentController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(paymentController.toDate.value);
                    await paymentController.getPaymentHistory(pageNumber: 1);
                  },
                );
              },
              child: Container(
                height: 5.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  color: ColorsForApp.whiteColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_calendar_rounded,
                      color: ColorsForApp.primaryColorBlue,
                      size: 18,
                    ),
                    width(2.5.w),
                    Obx(
                      () => Text(
                        '${paymentController.selectedFromDate.value} - ${paymentController.selectedToDate.value}',
                        style: TextHelper.size12.copyWith(
                          fontFamily: mediumGoogleSansFont,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      mainBody: Obx(
        () => paymentController.paymentHistoryList.isEmpty
            ? notFoundText(text: 'No payment history found')
            : RefreshIndicator(
                color: ColorsForApp.primaryColor,
                onRefresh: () async {
                  isLoading.value = true;
                  await Future.delayed(const Duration(seconds: 1), () async {
                    await paymentController.getPaymentHistory(pageNumber: 1, isLoaderShow: false);
                  });
                  isLoading.value = false;
                },
                child: ListView.separated(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                  itemCount: paymentController.paymentHistoryList.length,
                  itemBuilder: (context, index) {
                    if (index == paymentController.paymentHistoryList.length - 1 && paymentController.hasNext.value) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                      );
                    } else {
                      PaymentData paymentData = paymentController.paymentHistoryList[index];
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
                                                'View Slip',
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
                              height(0.5.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Visibility(
                                    visible: paymentData.status != null ? true : false,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          Get.toNamed(Routes.RAISE_COMPLAINT_SCREEN);
                                        },
                                        child: Container(
                                          height: 9 + 7.w,
                                          width: 22.w,
                                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                                          decoration: BoxDecoration(
                                            color: ColorsForApp.stepBorderColor.withOpacity(0.2),
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(18),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Help',
                                                textAlign: TextAlign.center,
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: mediumGoogleSansFont,
                                                  color: ColorsForApp.lightBlackColor,
                                                ),
                                              ),
                                              Icon(
                                                Icons.help_outline_rounded,
                                                color: ColorsForApp.primaryColorBlue,
                                                size: 4.8.w,
                                              )
                                            ],
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
    );
  }
}

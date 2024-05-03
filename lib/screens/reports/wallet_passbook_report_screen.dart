import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/report_controller.dart';
import '../../../generated/assets.dart';
import '../../../model/report/statement_report_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/string_constants.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/text_field.dart';

class WalletPassbookReportScreen extends StatefulWidget {
  const WalletPassbookReportScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WalletPassbookReportScreenState();
  }
}

class WalletPassbookReportScreenState extends State<WalletPassbookReportScreen> {
  final ReportController reportController = Get.find();
  ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> userNameKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    reportController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    reportController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    reportController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(reportController.fromDate.value);
    reportController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(reportController.toDate.value);
    await reportController.getStatementReportApi(pageNumber: reportController.currentPage.value);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && reportController.currentPage.value < reportController.totalPages.value) {
        reportController.currentPage.value++;
        if (reportController.searchUserController.text.isNotEmpty) {
          await reportController.getStatementReportApi(
            pageNumber: reportController.currentPage.value,
            userName: reportController.searchUserController.text,
            isLoaderShow: false,
          );
        } else {
          await reportController.getStatementReportApi(
            pageNumber: reportController.currentPage.value,
            isLoaderShow: false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Wallet Passbook Report',
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
                  initialDateRange: DateRange(reportController.fromDate.value, reportController.toDate.value),
                  onDateRangeChanged: (DateRange? date) {
                    reportController.fromDate.value = date!.start;
                    reportController.toDate.value = date.end;
                  },
                  noText: 'Cancel',
                  onNo: () {
                    Get.back();
                  },
                  yesText: 'Proceed',
                  onYes: () async {
                    Get.back();
                    reportController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(reportController.fromDate.value);
                    reportController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(reportController.toDate.value);
                    if (reportController.searchUserController.text.isNotEmpty) {
                      await reportController.getStatementReportApi(
                        pageNumber: 1,
                        userName: reportController.searchUserController.text,
                      );
                    } else {
                      await reportController.getStatementReportApi(pageNumber: 1);
                    }
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
                  mainAxisAlignment: MainAxisAlignment.center,
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
                        '${reportController.selectedFromDate.value} - ${reportController.selectedToDate.value}',
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
        () => Column(
          children: [
            height(2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Total credit
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Credit :',
                      style: TextHelper.size13.copyWith(
                        fontFamily: mediumGoogleSansFont,
                        color: ColorsForApp.lightBlackColor,
                      ),
                    ),
                    width(5),
                    Text(
                      '₹ ${reportController.totalCredit.value}',
                      textAlign: TextAlign.start,
                      style: TextHelper.size13.copyWith(color: ColorsForApp.successColor, fontFamily: mediumGoogleSansFont),
                    ),
                  ],
                ),
                // Total debit
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Debit :',
                      style: TextHelper.size13.copyWith(
                        fontFamily: mediumGoogleSansFont,
                        color: ColorsForApp.lightBlackColor,
                      ),
                    ),
                    width(5),
                    Text(
                      '₹ ${reportController.totalDebit.value}',
                      textAlign: TextAlign.start,
                      style: TextHelper.size13.copyWith(color: ColorsForApp.errorColor, fontFamily: mediumGoogleSansFont),
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
              visible: GetStorage().read(loginTypeKey) != "Retailer" ? true : false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          reportController.selectedPassbookIndex.value = 0;
                          reportController.currentPage.value = 1;
                          reportController.isFilteredUserPassbook.value = false;
                          reportController.searchUserController.clear();
                          showProgressIndicator();
                          await reportController.getStatementReportApi(
                            pageNumber: reportController.currentPage.value,
                            isLoaderShow: false,
                          );
                          dismissProgressIndicator();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 5.h,
                            constraints: BoxConstraints(minWidth: 30.w),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: const Alignment(-0.0, -0.7),
                                end: const Alignment(0, 1),
                                colors: reportController.selectedPassbookIndex.value == 0
                                    ? [
                                        ColorsForApp.whiteColor,
                                        ColorsForApp.selectedTabBackgroundColor,
                                      ]
                                    : [
                                        ColorsForApp.whiteColor,
                                        ColorsForApp.whiteColor,
                                      ],
                              ),
                              color: reportController.selectedPassbookIndex.value == 0 ? ColorsForApp.selectedTabBgColor : ColorsForApp.whiteColor,
                              border: Border(
                                bottom: BorderSide(
                                  color: reportController.selectedPassbookIndex.value == 0 ? ColorsForApp.primaryColor : ColorsForApp.accentColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'My Passbook',
                              style: TextHelper.size15.copyWith(
                                color: reportController.selectedPassbookIndex.value == 0 ? ColorsForApp.primaryColor : ColorsForApp.lightBlackColor,
                                fontFamily: reportController.selectedPassbookIndex.value == 0 ? mediumGoogleSansFont : regularGoogleSansFont,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    width(10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          reportController.selectedPassbookIndex.value = 1;
                          reportController.currentPage.value = 1;
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 5.h,
                            constraints: BoxConstraints(minWidth: 30.w),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: const Alignment(-0.0, -0.7),
                                end: const Alignment(0, 1),
                                colors: reportController.selectedPassbookIndex.value == 1
                                    ? [
                                        ColorsForApp.whiteColor,
                                        ColorsForApp.selectedTabBackgroundColor,
                                      ]
                                    : [
                                        ColorsForApp.whiteColor,
                                        ColorsForApp.whiteColor,
                                      ],
                              ),
                              color: reportController.selectedPassbookIndex.value == 1 ? ColorsForApp.selectedTabBgColor : ColorsForApp.whiteColor,
                              border: Border(
                                bottom: BorderSide(
                                  color: reportController.selectedPassbookIndex.value == 1 ? ColorsForApp.primaryColor : ColorsForApp.accentColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'User Passbook',
                              style: TextHelper.size15.copyWith(
                                  color: reportController.selectedPassbookIndex.value == 1 ? ColorsForApp.primaryColor : ColorsForApp.lightBlackColor,
                                  fontFamily: reportController.selectedPassbookIndex.value == 1 ? mediumGoogleSansFont : regularGoogleSansFont),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            height(1.h),
            Visibility(
              visible: reportController.selectedPassbookIndex.value == 1 ? true : false,
              child: Form(
                key: userNameKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: reportController.searchUserController,
                          style: TextHelper.size14.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                          hintText: 'Enter username',
                          hintTextColor: ColorsForApp.lightBlackColor.withOpacity(0.6),
                          focusedBorderColor: ColorsForApp.grayScale500,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          onChange: (value) {
                            if (value.length != 10) {
                              reportController.statementReportList.clear();
                            }
                          },
                          validator: (value) {
                            if (reportController.searchUserController.text.trim().isEmpty) {
                              return 'Please enter user name';
                            } /*else if (reportController
                                    .searchUserController.text.length !=
                                10) {
                              return 'Please enter valid user name';
                            }*/
                            return null;
                          },
                        ),
                      ),
                      width(2.w),
                      CommonButton(
                        width: 8.h,
                        onPressed: () async {
                          if (userNameKey.currentState!.validate()) {
                            FocusScope.of(context).unfocus();
                            showProgressIndicator();
                            bool result = await reportController.getStatementReportApi(
                              pageNumber: 1,
                              userName: reportController.searchUserController.text,
                              isLoaderShow: false,
                            );
                            dismissProgressIndicator();
                            if (result == true) {
                              reportController.isFilteredUserPassbook.value = true;
                            }
                          }
                        },
                        label: 'Search',
                        labelColor: Colors.black,
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.primaryColor,
                        ),
                        shadowColor: Colors.white,
                        bgColor: ColorsForApp.primaryShadeColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => Expanded(
                child: reportController.statementReportList.isEmpty || reportController.selectedPassbookIndex.value == 1 && reportController.isFilteredUserPassbook.value == false
                    ? notFoundText(text: 'No statement found')
                    : Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Material(
                          color: Colors.white,
                          elevation: 3,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                            side: BorderSide(color: Colors.white, width: 0.4),
                          ),
                          child: ListView.separated(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                            itemCount: reportController.statementReportList.length,
                            itemBuilder: (context, index) {
                              if (index == reportController.statementReportList.length - 1 && reportController.hasNext.value) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ColorsForApp.primaryColor,
                                    ),
                                  ),
                                );
                              } else {
                                StatementReportData statementReportData = reportController.statementReportList[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  child: Obx(
                                    () => InkWell(
                                      onTap: () {
                                        for (var element in reportController.statementReportList) {
                                          if (element.isVisible.value == true) {
                                            element.isVisible.value = false;
                                          }
                                        }
                                        statementReportData.isVisible.value = !statementReportData.isVisible.value;
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 6.h,
                                                width: 14.w,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                      statementReportData.crDrType == 'Credit' ? Assets.imagesIncomingArrow : Assets.imagesOutgoingArrow,
                                                    ),
                                                    scale: 2.5.w,
                                                  ),
                                                  color: ColorsForApp.stepBorderColor.withOpacity(0.1),
                                                  border: Border.all(
                                                    color: ColorsForApp.primaryShadeColor,
                                                    style: BorderStyle.solid,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Row(),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            statementReportData.transactionType != null && statementReportData.transactionType!.isNotEmpty ? statementReportData.transactionType! : '-',
                                                            style: TextHelper.size15.copyWith(
                                                              fontFamily: mediumGoogleSansFont,
                                                              color: ColorsForApp.lightBlackColor,
                                                            ),
                                                          ),
                                                          height(0.5.h),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Service Name :',
                                                                style: TextHelper.size12.copyWith(
                                                                  fontFamily: mediumGoogleSansFont,
                                                                  color: ColorsForApp.greyColor,
                                                                ),
                                                              ),
                                                              width(5),
                                                              Text(
                                                                statementReportData.serviceName != null && statementReportData.serviceName!.isNotEmpty ? statementReportData.serviceName! : '-',
                                                                textAlign: TextAlign.start,
                                                                style: TextHelper.size12.copyWith(
                                                                  color: ColorsForApp.lightBlackColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          height(0.5.h),
                                                          Text(
                                                            "${statementReportData.crDrType == "Credit" ? "Received on " : "Paid on "}${statementReportData.transactionDate != null && statementReportData.transactionDate!.isNotEmpty ? reportController.formatDateTime(statementReportData.transactionDate!) : '-'}",
                                                            style: TextHelper.size12.copyWith(
                                                              fontFamily: mediumGoogleSansFont,
                                                              color: ColorsForApp.greyColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Text(
                                                      statementReportData.amount != null ? '${statementReportData.crDrType == "Credit" ? "+ ₹ " : "- ₹ "}${statementReportData.amount!.toStringAsFixed(2)}' : '',
                                                      style: TextHelper.size14.copyWith(
                                                        color: statementReportData.crDrType == "Credit" ? ColorsForApp.successColor : ColorsForApp.lightBlackColor,
                                                        fontFamily: regularGoogleSansFont,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          height(1.h),
                                          Visibility(
                                            visible: statementReportData.isVisible.value,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 0,
                                                      width: 50 + 4.w,
                                                      color: Colors.transparent,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              // Username
                                                              Expanded(
                                                                child: customKeyValueText(
                                                                  key: 'Username : ',
                                                                  value: statementReportData.userName != null && statementReportData.userName!.isNotEmpty ? statementReportData.userName! : '-',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              // Opening Balance
                                                              Expanded(
                                                                child: customKeyValueText(
                                                                  key: 'TID : ',
                                                                  value: statementReportData.orderID != null ? statementReportData.orderID!.toString() : '-',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              // Wallet Txn Id
                                                              Expanded(
                                                                child: customKeyValueText(
                                                                  key: 'Wallet Txn Id :',
                                                                  value: statementReportData.id != null ? statementReportData.id!.toString() : '-',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              // Opening Balance
                                                              Expanded(
                                                                child: customKeyValueText(
                                                                  key: 'Opening Balance :',
                                                                  value: statementReportData.openingBal != null ? '₹ ${statementReportData.openingBal!.toStringAsFixed(2)}' : '-',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              // Closing Balance
                                                              Expanded(
                                                                child: customKeyValueText(
                                                                  key: 'Closing Balance :',
                                                                  value: statementReportData.closingBal != null ? '₹ ${statementReportData.closingBal!.toStringAsFixed(2)}' : '-',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              // Closing Balance
                                                              Expanded(
                                                                child: customKeyValueText(
                                                                  key: 'TDS Amount :',
                                                                  value: statementReportData.tds != null ? '₹ ${statementReportData.tds!.toStringAsFixed(2)}' : '-',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              // Transaction Date
                                                              Expanded(
                                                                child: customKeyValueText(
                                                                  key: 'Remarks :',
                                                                  value: statementReportData.remarks != null && statementReportData.remarks!.isNotEmpty ? statementReportData.remarks! : '-',
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          height(1.h),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                height(1.h),
                                              ],
                                            ),
                                          ),
                                          /* this receipt option is only for Tharpay project
                                         Visibility(
                                            visible: statementReportData.serviceName!.contains('PRODUCT')?false:true,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Get.toNamed(
                                                      Routes.RECEIPT_SCREEN,
                                                      arguments: [
                                                        statementReportData.payRefID.toString(), // Transaction id
                                                        0, // 0 for single, 1 for bulk
                                                        'WALLETTOBANK', // Design
                                                      ],
                                                    );
                                                  },
                                                  child: const Text('View Receipt'),
                                                ),
                                              ],
                                            ),
                                          ),*/
                                          Row(
                                            children: [
                                              Container(
                                                height: 0,
                                                width: 50 + 4.w,
                                                color: Colors.transparent,
                                              ),
                                              width(0.5.w),
                                              Expanded(
                                                child: Container(
                                                  height: 0.4,
                                                  color: ColorsForApp.greyColor.withOpacity(0.5),
                                                ),
                                              ),
                                              width(0.5.w),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return height(0.5.h);
                            },
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

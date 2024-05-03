import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/aeps_controller.dart';
import '../../../../../controller/retailer/retailer_dashboard_controller.dart';
import '../../../../../model/aeps/mini_statement_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/custom_scaffold.dart';

class AepsMiniStatementScreen extends StatefulWidget {
  const AepsMiniStatementScreen({super.key});

  @override
  State<AepsMiniStatementScreen> createState() => _AepsMiniStatementScreenState();
}

class _AepsMiniStatementScreenState extends State<AepsMiniStatementScreen> {
  final AepsController aepsController = Get.find();
  RetailerDashboardController retailerDashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        aepsController.resetAepsVariables();
        return true;
      },
      child: CustomScaffold(
        title: 'AEPS Mini Statement',
        isShowLeadingIcon: true,
        mainBody: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height(1.h),
            Container(
              color: ColorsForApp.whiteColor,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: ColorsForApp.primaryColorBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Agent Name
                        keyValueText(
                          key: 'Agent Name : ',
                          value: retailerDashboardController.userBasicDetails.value.ownerName != null && retailerDashboardController.userBasicDetails.value.ownerName!.isNotEmpty
                              ? retailerDashboardController.userBasicDetails.value.ownerName!.trim()
                              : '',
                        ),
                        height(8),
                        // Bank Name
                        keyValueText(
                          key: 'Bank Name : ',
                          value: aepsController.miniStatementModel.value.bankName != null && aepsController.miniStatementModel.value.bankName!.isNotEmpty
                              ? aepsController.miniStatementModel.value.bankName!
                              : aepsController.bankController.text.trim().isNotEmpty
                                  ? aepsController.bankController.text.trim()
                                  : '-',
                        ),
                        height(8),
                        // Aadhar No
                        keyValueText(
                          key: 'Aadhar No : ',
                          value: aepsController.miniStatementModel.value.data != null && aepsController.miniStatementModel.value.data!.adhaarNo != null && aepsController.miniStatementModel.value.data!.adhaarNo!.isNotEmpty
                              ? aepsController.miniStatementModel.value.data!.adhaarNo!
                              : aepsController.aadharNumberController.text.trim().isNotEmpty
                                  ? aepsController.aadharNumberController.text.trim()
                                  : '-',
                        ),
                        height(8),
                        // Account Balance
                        keyValueText(
                          key: 'Account Balance : ',
                          value: aepsController.miniStatementModel.value.data != null && aepsController.miniStatementModel.value.data!.balance != null && aepsController.miniStatementModel.value.data!.balance!.isNotEmpty
                              ? aepsController.miniStatementModel.value.data!.balance!
                              : '-',
                        ),
                        height(8),
                        // Date
                        keyValueText(
                          key: 'Date : ',
                          value: aepsController.miniStatementModel.value.data != null && aepsController.miniStatementModel.value.data!.localDate != null && aepsController.miniStatementModel.value.data!.localDate!.isNotEmpty
                              ? aepsController.miniStatementModel.value.data!.localDate!
                              : '-',
                        ),
                        height(8),
                        // Time
                        keyValueText(
                          key: 'Time : ',
                          value: aepsController.miniStatementModel.value.data != null && aepsController.miniStatementModel.value.data!.localTime != null && aepsController.miniStatementModel.value.data!.localTime!.isNotEmpty
                              ? aepsController.miniStatementModel.value.data!.localTime!
                              : '-',
                        ),
                        height(8),
                        // Transaction ID
                        keyValueText(
                          key: 'Txn ID: ',
                          value: aepsController.miniStatementModel.value.orderId != null && aepsController.miniStatementModel.value.orderId!.isNotEmpty ? aepsController.miniStatementModel.value.orderId! : '-',
                        ),
                        height(8),
                        //RRN
                        keyValueText(
                          key: 'RRN : ',
                          value: aepsController.miniStatementModel.value.data != null && aepsController.miniStatementModel.value.data!.rrn != null && aepsController.miniStatementModel.value.data!.rrn!.isNotEmpty
                              ? aepsController.miniStatementModel.value.data!.rrn!
                              : '-',
                        ),
                      ],
                    ),
                  ),
                  height(1.5.h),
                  Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 3.h,
                          width: 100.w,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Date
                              Expanded(
                                child: Text(
                                  'Date',
                                  textAlign: TextAlign.center,
                                  style: TextHelper.size14.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: ColorsForApp.lightBlackColor,
                              ),
                              // Type
                              Expanded(
                                child: Text(
                                  'Type',
                                  textAlign: TextAlign.center,
                                  style: TextHelper.size14.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: ColorsForApp.lightBlackColor,
                              ),
                              // Amount
                              Expanded(
                                child: Text(
                                  'Amount',
                                  textAlign: TextAlign.center,
                                  style: TextHelper.size14.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: ColorsForApp.lightBlackColor,
                              ),
                              // Narration
                              Expanded(
                                child: Text(
                                  'Narration',
                                  textAlign: TextAlign.center,
                                  style: TextHelper.size14.copyWith(
                                    fontFamily: mediumGoogleSansFont,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 0,
                          thickness: 1,
                          color: ColorsForApp.lightBlackColor,
                        ),
                        NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (overscroll) {
                            overscroll.disallowIndicator();
                            return true;
                          },
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: aepsController.miniStatementModel.value.data != null ? aepsController.miniStatementModel.value.data!.transactionList!.length : 0,
                            itemBuilder: (context, index) {
                              TransactionList transactionModel = aepsController.miniStatementModel.value.data!.transactionList![index];
                              return Container(
                                height: 4.h,
                                width: 100.w,
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Date
                                    Expanded(
                                      child: Text(
                                        transactionModel.date != null && transactionModel.date!.isNotEmpty ? transactionModel.date! : '-',
                                        textAlign: TextAlign.center,
                                        style: TextHelper.size14,
                                      ),
                                    ),
                                    // Type
                                    Expanded(
                                      child: Text(
                                        transactionModel.type != null && transactionModel.type!.isNotEmpty ? transactionModel.type! : '-',
                                        textAlign: TextAlign.center,
                                        style: TextHelper.size14,
                                      ),
                                    ),
                                    // Amount
                                    Expanded(
                                      child: Text(
                                        transactionModel.amount != null ? double.parse(transactionModel.amount!).toStringAsFixed(2) : '-',
                                        textAlign: TextAlign.center,
                                        style: TextHelper.size14,
                                      ),
                                    ),
                                    // Narration
                                    Expanded(
                                      child: Text(
                                        transactionModel.debitCredit != null && transactionModel.debitCredit!.isNotEmpty ? transactionModel.debitCredit! : '-',
                                        textAlign: TextAlign.center,
                                        style: TextHelper.size14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                height: 0,
                                color: ColorsForApp.lightBlackColor,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  height(1.h),
                ],
              ),
            ),
            height(10),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  // Done
                  Expanded(
                    child: CommonButton(
                      onPressed: () {
                        Get.back();
                        aepsController.resetAepsVariables();
                      },
                      label: 'Done',
                      border: Border.all(color: ColorsForApp.primaryColor),
                      bgColor: ColorsForApp.whiteColor,
                      labelColor: ColorsForApp.primaryColor,
                    ),
                  ),
                  width(5.w),
                  // Receipt
                  Expanded(
                    child: CommonButton(
                      onPressed: () {
                        Get.toNamed(
                          Routes.MINI_STATEMENT_RECEIPT_SCREEN,
                          arguments: aepsController.miniStatementModel.value,
                        );
                      },
                      label: 'Receipt',
                      bgColor: ColorsForApp.primaryColor,
                      labelColor: ColorsForApp.whiteColor,
                    ),
                  ),
                ],
              ),
              height(2.h),
            ],
          ),
        ),
      ),
    );
  }

  keyValueText({required String key, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          key,
          style: TextHelper.size14.copyWith(
            fontFamily: mediumGoogleSansFont,
          ),
        ),
        width(1.w),
        Text(
          value.isNotEmpty ? value : '',
          style: TextHelper.size14.copyWith(
            fontFamily: mediumGoogleSansFont,
            color: ColorsForApp.greyColor,
          ),
        ),
      ],
    );
  }
}

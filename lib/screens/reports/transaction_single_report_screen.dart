import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/report_controller.dart';
import '../../../generated/assets.dart';
import '../../../model/report/transaction_report_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../controller/receipt_controller.dart';

class TransactionSingleReportScreen extends StatelessWidget {
  TransactionSingleReportScreen({super.key});
  final ReportController reportController = Get.find();
  final ReceiptController receiptController = Get.find();
  final TransactionReportData transactionReportData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CustomScaffold(
        title: 'Transaction Details',
        isShowLeadingIcon: true,
        mainBody: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              height(2.h),
              CircleAvatar(
                radius: 25,
                backgroundColor: ColorsForApp.lightBlackColor,
                child: const Icon(
                  Icons.perm_identity,
                  size: 45,
                  color: Colors.white,
                ),
              ),
              height(2.h),
              Text(
                transactionReportData.userDetails != null && transactionReportData.userDetails!.isNotEmpty ? transactionReportData.userDetails! : '-',
                textAlign: TextAlign.center,
                style: TextHelper.size16.copyWith(
                  fontFamily: mediumGoogleSansFont,
                ),
              ),
              height(0.5.h),
              Text(
                transactionReportData.number != null && transactionReportData.number!.isNotEmpty ? transactionReportData.number! : '-',
                style: TextHelper.size15.copyWith(
                  fontFamily: mediumGoogleSansFont,
                  color: ColorsForApp.darkGreyColor,
                ),
              ),
              height(2.h),
              Text(
                '₹ ${transactionReportData.amount != null && transactionReportData.amount! > 0 ? transactionReportData.amount!.toStringAsFixed(2) : '0.00'}',
                style: TextHelper.h1.copyWith(
                  fontFamily: boldGoogleSansFont,
                ),
              ),
              height(3.h),
              // Transaction status
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    transactionReportData.status == 0
                        ? Assets.imagesRejected
                        : transactionReportData.status == 1
                            ? Assets.imagesApprove
                            : Assets.imagesPending,
                    scale: 5,
                  ),
                  width(0.6.w),
                  Text(
                    transactionReportData.status != null ? reportController.dmtTransactionStatus(transactionReportData.status!) : '-',
                    style: TextHelper.size15.copyWith(
                      fontFamily: mediumGoogleSansFont,
                    ),
                  ),
                ],
              ),
              height(0.6.h),
              const Divider(
                thickness: 0.3,
                endIndent: 100,
                indent: 100,
                color: Colors.black,
              ),
              height(0.6.h),
              // Transaction date
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transaction Date : ',
                    style: TextHelper.size14.copyWith(
                      fontFamily: regularGoogleSansFont,
                      color: ColorsForApp.lightBlackColor,
                    ),
                  ),
                  width(5),
                  Flexible(
                    child: Text(
                      transactionReportData.transactionDate != null && transactionReportData.transactionDate!.isNotEmpty ? reportController.formatDateTimeStyle(transactionReportData.transactionDate.toString()) : '-',
                      style: TextHelper.size14.copyWith(
                        fontFamily: mediumGoogleSansFont,
                        color: ColorsForApp.lightBlackColor,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  height(2.5.h),
                ],
              ),
              // Updated date
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Updated Date : ',
                    style: TextHelper.size14.copyWith(
                      fontFamily: regularGoogleSansFont,
                      color: ColorsForApp.lightBlackColor,
                    ),
                  ),
                  width(5),
                  Flexible(
                    child: Text(
                      transactionReportData.updatedDate != null && transactionReportData.updatedDate!.isNotEmpty ? reportController.formatDateTimeStyle(transactionReportData.updatedDate.toString()) : '-',
                      style: TextHelper.size14.copyWith(
                        fontFamily: mediumGoogleSansFont,
                        color: ColorsForApp.lightBlackColor,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  height(2.5.h),
                ],
              ),
              height(2.h),
              Container(
                width: 90.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 6),
                      child: Text(
                        'Payment Type : ${transactionReportData.paymentType != null && transactionReportData.paymentType!.isNotEmpty ? transactionReportData.paymentType! : '-'}',
                        style: TextHelper.size15.copyWith(
                          fontFamily: mediumGoogleSansFont,
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customKeyValueTextStyle(
                            key: 'Transaction Id : ',
                            value: transactionReportData.orderId != null ? transactionReportData.orderId.toString() : '-',
                          ),
                          customKeyValueTextStyle(
                            key: 'Bank Ref : ',
                            value: transactionReportData.operatorRef != null ? transactionReportData.operatorRef.toString() : '-',
                          ),
                          customKeyValueTextStyle(
                            key: 'Channel Name : ',
                            value: transactionReportData.channelName != null ? transactionReportData.channelName.toString() : '-',
                          ),
                          customKeyValueTextStyle(
                            key: 'Beneficiary Name : ',
                            value: transactionReportData.beneficiaryName != null && transactionReportData.beneficiaryName!.isNotEmpty ? transactionReportData.beneficiaryName! : '-',
                          ),
                          customKeyValueTextStyle(
                            key: 'Beneficiary Acc No. : ',
                            value: transactionReportData.accountNo != null && transactionReportData.accountNo!.isNotEmpty ? transactionReportData.accountNo! : '-',
                          ),
                          customKeyValueTextStyle(
                            key: 'Bank Name : ',
                            value: transactionReportData.bankName != null && transactionReportData.bankName!.isNotEmpty ? transactionReportData.bankName! : '-',
                          ),
                          customKeyValueTextStyle(
                            key: 'GST : ',
                            value: transactionReportData.gst.toString() != "" && transactionReportData.gst!.toString().isNotEmpty ? transactionReportData.gst!.toString() : '-',
                          ),
                          customKeyValueTextStyle(
                            key: 'TDS : ',
                            value: transactionReportData.tds.toString() != "" && transactionReportData.tds!.toString().isNotEmpty ? transactionReportData.tds!.toString() : '-',
                          ),
                          customKeyValueTextStyle(
                            key: 'IFSC Code : ',
                            value: transactionReportData.ifsc != null && transactionReportData.ifsc!.isNotEmpty ? transactionReportData.ifsc! : '-',
                          ),
                          customKeyValueTextStyle(
                            key: 'Charge : ',
                            value: transactionReportData.chargeAmt != null ? '₹ ${transactionReportData.chargeAmt!.toStringAsFixed(2)}' : '0.00',
                          ),
                          customKeyValueTextStyle(
                            key: 'Commission : ',
                            value: transactionReportData.commAmt != null ? '₹ ${transactionReportData.commAmt!.toStringAsFixed(2)}' : '0.00',
                          ),
                          customKeyValueTextStyle(
                            key: 'Total Amount : ',
                            value: transactionReportData.cost != null ? '₹ ${transactionReportData.cost!.toStringAsFixed(2)}' : '0.00',
                          ),
                          height(1.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              height(2.h),
            ],
          ),
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
                  Expanded(
                    child: CommonButton(
                      label: 'Single Receipt',
                      onPressed: () async {
                        Get.toNamed(
                          Routes.RECEIPT_SCREEN,
                          arguments: [
                            transactionReportData.id.toString(), // Transaction id
                            0, // 0 for single, 1 for bulk
                            'DMT', // Design
                          ],
                        );
                      },
                    ),
                  ),
                  width(5.w),
                  Expanded(
                    child: CommonButton(
                      label: 'Bulk Receipt',
                      onPressed: () async {
                        bool result = await receiptController.getReceipt(
                          transactionId: transactionReportData.id.toString(),
                          type: 1,
                          design: 'DMTBulk',
                        );
                        if (result == true) {
                          Get.toNamed(
                            Routes.TRANSACTION_BULK_REPORT_SCREEN,
                            arguments: transactionReportData,
                          );
                        }
                      },
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

  Widget customKeyValueTextStyle({required String key, required String value}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key,
              style: TextHelper.size14.copyWith(
                fontFamily: regularGoogleSansFont,
                color: ColorsForApp.lightBlackColor,
              ),
            ),
            width(5),
            Expanded(
              child: Text(
                value.isNotEmpty ? value : '',
                style: TextHelper.size14.copyWith(
                  fontFamily: mediumGoogleSansFont,
                  color: ColorsForApp.lightBlackColor,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
        height(0.8.h),
      ],
    );
  }
}

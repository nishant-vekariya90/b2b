import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/report_controller.dart';
import '../../../generated/assets.dart';
import '../../../model/report/transaction_report_model.dart';
import '../../../model/report/transaction_slab_report_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';

class TransactionBulkReportScreen extends StatefulWidget {
  const TransactionBulkReportScreen({super.key});

  @override
  State<TransactionBulkReportScreen> createState() => _TransactionBulkReportScreenState();
}

class _TransactionBulkReportScreenState extends State<TransactionBulkReportScreen> {
  final ReportController reportController = Get.find();
  final TransactionReportData transactionReportData = Get.arguments;
  final GlobalKey screenshotKey = GlobalKey();
  Rx<TransactionSlabReportModel> slabData = TransactionSlabReportModel().obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await reportController.getTransactionSlabReportApi(operatorId: transactionReportData.splitTransactionId.toString());
      slabData.value = reportController.transactionSlabList.firstWhere((element) => element.status != null && element.status == 1);
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CustomScaffold(
        title: 'Transaction Details',
        isShowLeadingIcon: true,
        mainBody: Obx(
          () => SingleChildScrollView(
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
                  '₹ ${reportController.totalAmount.value.toStringAsFixed(2)}',
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: ColorsForApp.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Order ID',
                                          style: TextHelper.size14.copyWith(
                                            fontFamily: boldGoogleSansFont,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Amount',
                                          style: TextHelper.size14.copyWith(
                                            fontFamily: boldGoogleSansFont,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Cost',
                                          style: TextHelper.size14.copyWith(
                                            fontFamily: boldGoogleSansFont,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'Status',
                                          style: TextHelper.size14.copyWith(
                                            fontFamily: boldGoogleSansFont,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                height(0.5.h),
                                Divider(
                                  thickness: 1,
                                  color: ColorsForApp.greyColor,
                                ),
                                height(0.5.h),
                                Obx(
                                  () => ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: reportController.transactionSlabList.length,
                                    itemBuilder: (context, index) {
                                      TransactionSlabReportModel slabData = reportController.transactionSlabList[index];
                                      return Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                slabData.id != null ? slabData.id.toString() : '-',
                                                style: TextHelper.size13,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                '₹ ${slabData.amount != null ? slabData.amount!.toStringAsFixed(2) : '0.00'}',
                                                style: TextHelper.size13,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                '₹ ${slabData.cost != null ? slabData.cost!.toStringAsFixed(2) : '0.00'}',
                                                style: TextHelper.size13,
                                              ),
                                            ),
                                          ),
                                          slabData.status != null && slabData.status == 1
                                              ? Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      'Success',
                                                      style: TextHelper.size13.copyWith(
                                                        color: ColorsForApp.successColor,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : slabData.status != null && slabData.status == 0
                                                  ? Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          'Failed',
                                                          style: TextHelper.size13.copyWith(
                                                            color: ColorsForApp.errorColor,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: Center(
                                                        child: Text(
                                                          '-',
                                                          style: TextHelper.size13,
                                                        ),
                                                      ),
                                                    ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 1.h),
                                        child: Divider(
                                          thickness: 1,
                                          height: 0,
                                          color: ColorsForApp.grayScale500.withOpacity(0.3),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          height(2.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                customKeyValueTextStyle(
                                  key: 'Channel Name : ',
                                  value: slabData.value.channelName != null && slabData.value.channelName != null ? slabData.value.channelName.toString() : '-',
                                ),
                                customKeyValueTextStyle(
                                  key: 'Beneficiary Name : ',
                                  value: slabData.value.customerName != null && slabData.value.customerName!.isNotEmpty ? slabData.value.customerName! : '-',
                                ),
                                customKeyValueTextStyle(
                                  key: 'Beneficiary Acc No. : ',
                                  value: slabData.value.accountNo != null && slabData.value.accountNo!.isNotEmpty ? slabData.value.accountNo! : '-',
                                ),
                                customKeyValueTextStyle(
                                  key: 'Bank Name : ',
                                  value: slabData.value.bankName != null && slabData.value.bankName!.isNotEmpty ? slabData.value.bankName! : '-',
                                ),
                                customKeyValueTextStyle(
                                  key: 'IFSC Code : ',
                                  value: slabData.value.ifsc != null && slabData.value.ifsc!.isNotEmpty ? slabData.value.ifsc! : '-',
                                ),
                                customKeyValueTextStyle(
                                  key: 'Charge : ₹',
                                  value: reportController.totalCharge.value.toStringAsFixed(2),
                                ),
                                customKeyValueTextStyle(
                                  key: 'Commission : ₹',
                                  value: reportController.totalCommission.value.toStringAsFixed(2),
                                ),
                                customKeyValueTextStyle(
                                  key: 'Total Amount : ₹',
                                  value: reportController.totalCost.value.toStringAsFixed(2),
                                ),
                                height(1.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                height(2.h),
              ],
            ),
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
              CommonButton(
                label: 'Receipt',
                onPressed: () async {
                  Get.toNamed(
                    Routes.RECEIPT_SCREEN,
                    arguments: [
                      transactionReportData.id.toString(), // Transaction id
                      1, // 0 for single, 1 for bulk
                      'DMTBulk', // Design
                    ],
                  );
                },
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

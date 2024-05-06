import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/report_controller.dart';
import '../../../generated/assets.dart';
import '../../../model/report/transaction_report_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';

class TransactionReportDetailsScreen extends StatelessWidget {
  TransactionReportDetailsScreen({super.key});
  final ReportController reportController = Get.find();
  final TransactionReportData transactionReportData = Get.arguments;
  final GlobalKey screenshotKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CustomScaffold(
        title: 'Transaction Details',
        isShowLeadingIcon: true,
        mainBody: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: RepaintBoundary(
            key: screenshotKey,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                    height(4.h),
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
                    Text(
                      transactionReportData.transactionDate != null && transactionReportData.transactionDate!.isNotEmpty ? reportController.formatDateTimeStyle(transactionReportData.transactionDate.toString()) : '-',
                      style: TextHelper.size14.copyWith(
                        color: ColorsForApp.darkGreyColor,
                      ),
                    ),
                    height(3.h),
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
                                height(1.h),
                                customKeyValueTextStyle(
                                  key: 'Transaction Id : ',
                                  value: transactionReportData.id != null ? transactionReportData.id.toString() : '-',
                                ),
                                height(1.h),
                                customKeyValueTextStyle(
                                  key: 'Cost : ₹',
                                  value: transactionReportData.cost != null ? transactionReportData.cost!.toStringAsFixed(2) : '0.00',
                                ),
                                height(1.h),
                                customKeyValueTextStyle(
                                  key: 'Charge : ₹',
                                  value: transactionReportData.chargeAmt != null ? transactionReportData.chargeAmt!.toStringAsFixed(2) : '0.00',
                                ),
                                height(1.h),
                                customKeyValueTextStyle(
                                  key: 'Commission : ₹',
                                  value: transactionReportData.commAmt != null ? transactionReportData.commAmt!.toStringAsFixed(2) : '0.00',
                                ),
                                height(1.h),
                                customKeyValueTextStyle(
                                  key: 'Total Amount : ₹',
                                  value: transactionReportData.amount != null ? transactionReportData.amount!.toStringAsFixed(2) : '0.00',
                                ),
                                height(1.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    height(2.h)
                  ],
                ),
              ),
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
                label: 'Share Receipt',
                onPressed: () async {
                  await takeAndShareScreenshot(context);
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
    return Row(
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
        height(2.5.h),
      ],
    );
  }

  Future<void> takeAndShareScreenshot(BuildContext context) async {
    showProgressIndicator();
    RenderRepaintBoundary boundary = screenshotKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 10);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List? uint8List = byteData?.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.png');
    await file.writeAsBytes(uint8List!);
    dismissProgressIndicator();
    // Share the screenshot using the share package.
    Share.shareFiles(
      [file.path],
      text: 'Transaction receipt',
    );
  }
}

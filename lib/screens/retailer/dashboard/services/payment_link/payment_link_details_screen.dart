import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/payment_link_controller.dart';
import '../../../../../model/payment_link/payment_link_attempt_model.dart';
import '../../../../../model/payment_link/payment_link_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';

class PaymentLinkDetailsScreen extends StatelessWidget {
  final PaymentLinkController paymentLinkController = Get.find();
  final PaymentLinkData paymentLinkData = Get.arguments;
  PaymentLinkDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Payment Link Details',
      isShowLeadingIcon: true,
      mainBody: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    height(2.h),
                    // Unique no
                    paymentLinkDetailsDataRow(
                      key: 'Unique No :',
                      value: paymentLinkData.uniqueNo != null && paymentLinkData.uniqueNo!.isNotEmpty ? paymentLinkData.uniqueNo!.toString() : '-',
                    ),
                    // Gateway
                    paymentLinkDetailsDataRow(
                      key: 'Gateway : ',
                      value: paymentLinkData.gateway != null && paymentLinkData.gateway!.isNotEmpty ? paymentLinkData.gateway! : '-',
                    ),
                    // Settlement cycle
                    paymentLinkDetailsDataRow(
                      key: 'Settlement Cycle :',
                      value: paymentLinkData.settlementCycleName != null && paymentLinkData.settlementCycleName!.isNotEmpty ? paymentLinkData.settlementCycleName!.toString() : '-',
                    ),
                    // Name
                    paymentLinkDetailsDataRow(
                      key: 'Name :',
                      value: paymentLinkData.name != null && paymentLinkData.name!.isNotEmpty ? paymentLinkData.name!.toString() : '-',
                    ),
                    // Mobile number
                    paymentLinkDetailsDataRow(
                      key: 'Mobile Number :',
                      value: paymentLinkData.mobileNo != null && paymentLinkData.mobileNo!.isNotEmpty ? paymentLinkData.mobileNo!.toString() : '-',
                    ),
                    // Email
                    paymentLinkDetailsDataRow(
                      key: 'Email ID :',
                      value: paymentLinkData.emailId != null && paymentLinkData.emailId!.isNotEmpty ? paymentLinkData.emailId!.toString() : '-',
                    ),
                    // Amount
                    paymentLinkDetailsDataRow(
                      key: 'Amount :',
                      value: paymentLinkData.amount != null ? '₹ ${paymentLinkData.amount!.toStringAsFixed(2)}' : '₹ 0.00',
                    ),
                    // Remarks
                    paymentLinkDetailsDataRow(
                      key: 'Remarks :',
                      value: paymentLinkData.remark != null && paymentLinkData.remark!.isNotEmpty ? paymentLinkData.remark!.toString() : '-',
                    ),
                    // Expiry date
                    paymentLinkDetailsDataRow(
                      key: 'Expiry Date :',
                      value: paymentLinkData.expiryDate != null && paymentLinkData.expiryDate!.isNotEmpty ? paymentLinkController.formatDateTime(paymentLinkData.expiryDate!.toString()) : '-',
                    ),
                    // Created on
                    paymentLinkDetailsDataRow(
                      key: 'Created On :',
                      value: paymentLinkData.createdOn != null && paymentLinkData.createdOn!.isNotEmpty ? paymentLinkController.formatDateTime(paymentLinkData.createdOn!.toString()) : '-',
                    ),
                    // Created by
                    paymentLinkDetailsDataRow(
                      key: 'Created By :',
                      value: paymentLinkData.createdBy != null && paymentLinkData.createdBy!.isNotEmpty ? paymentLinkData.createdBy!.toString() : '-',
                    ),
                    // Modified on
                    paymentLinkDetailsDataRow(
                      key: 'Modified On :',
                      value: paymentLinkData.modifyOn != null && paymentLinkData.modifyOn!.isNotEmpty ? paymentLinkController.formatDateTime(paymentLinkData.modifyOn!.toString()) : '-',
                    ),
                    // Modified by
                    paymentLinkDetailsDataRow(
                      key: 'Modified By :',
                      value: paymentLinkData.modifyBy != null && paymentLinkData.modifyBy!.isNotEmpty ? paymentLinkData.modifyBy!.toString() : '-',
                    ),
                  ],
                ),
              ),
            ),
            height(1.h),
            CommonButton(
              onPressed: () async {
                if (Get.isSnackbarOpen) {
                  Get.back();
                }
                bool result = await paymentLinkController.getPaymentLinkAttempts(paymentLinkId: paymentLinkData.id!);
                if (result == true) {
                  paymentLinkAttemptDetails();
                }
              },
              label: 'Payment Attempts',
              bgColor: ColorsForApp.whiteColor,
              labelColor: ColorsForApp.primaryColor,
              border: Border.all(
                color: ColorsForApp.primaryColor,
              ),
            ),
            height(2.h),
          ],
        ),
      ),
    );
  }

  // Payment link details data row
  Widget paymentLinkDetailsDataRow({required String key, required String value}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key,
              style: TextHelper.size15.copyWith(
                fontFamily: mediumGoogleSansFont,
              ),
            ),
            width(3.w),
            Expanded(
              child: Text(
                value != '' && value.isNotEmpty ? value : '-',
                textAlign: TextAlign.start,
                style: TextHelper.size15.copyWith(
                  color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
        height(1.7.h),
        Divider(
          height: 0,
          thickness: 0.2,
          color: ColorsForApp.greyColor,
        ),
        height(1.7.h),
      ],
    );
  }

  // Payment link attempts details bottom sheet
  Future paymentLinkAttemptDetails() {
    return customBottomSheet(
      isScrollControlled: false,
      enableDrag: false,
      children: [
        Text(
          'Payment Attempts',
          style: TextHelper.size18.copyWith(
            fontFamily: boldGoogleSansFont,
            color: ColorsForApp.lightBlackColor,
          ),
        ),
        height(0.6.h),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          itemCount: paymentLinkController.paymentLinkAttemptList.length,
          itemBuilder: (context, index) {
            PaymentLinkAttemptData paymentLinkAttemptData = paymentLinkController.paymentLinkAttemptList[index];
            return customCard(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height(1.5.h),
                    // Order Id
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Id :',
                                style: TextHelper.size13.copyWith(
                                  fontFamily: mediumGoogleSansFont,
                                  color: ColorsForApp.greyColor,
                                ),
                              ),
                              width(5),
                              Expanded(
                                child: Text(
                                  paymentLinkAttemptData.orderId != null && paymentLinkAttemptData.orderId!.isNotEmpty ? paymentLinkAttemptData.orderId! : '-',
                                  textAlign: TextAlign.start,
                                  style: TextHelper.size13.copyWith(
                                    color: ColorsForApp.lightBlackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: paymentLinkAttemptData.status != null && paymentLinkAttemptData.status == 1 ? ColorsForApp.lightSuccessColor : ColorsForApp.lightErrorColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
                            child: Text(
                              paymentLinkAttemptData.status != null && paymentLinkAttemptData.status == 1 ? 'Success' : 'Fail',
                              style: TextHelper.size12.copyWith(
                                fontFamily: mediumGoogleSansFont,
                                color: paymentLinkAttemptData.status != null && paymentLinkAttemptData.status == 1 ? ColorsForApp.successColor : ColorsForApp.errorColor,
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
                    // Account number
                    Visibility(
                      visible: paymentLinkAttemptData.accountNo != null && paymentLinkAttemptData.accountNo!.isNotEmpty,
                      child: customKeyValueText(
                        key: 'Number : ',
                        value: paymentLinkAttemptData.accountNo != null && paymentLinkAttemptData.accountNo!.isNotEmpty ? paymentLinkAttemptData.accountNo! : '-',
                      ),
                    ),
                    // VPA
                    Visibility(
                      visible: paymentLinkAttemptData.vpa != null && paymentLinkAttemptData.vpa!.isNotEmpty,
                      child: customKeyValueText(
                        key: 'VPA : ',
                        value: paymentLinkAttemptData.vpa != null && paymentLinkAttemptData.vpa!.isNotEmpty ? paymentLinkAttemptData.vpa! : '-',
                      ),
                    ),
                    // Type
                    Visibility(
                      visible: paymentLinkAttemptData.ifscCode != null && paymentLinkAttemptData.ifscCode!.isNotEmpty,
                      child: customKeyValueText(
                        key: 'Type : ',
                        value: paymentLinkAttemptData.ifscCode != null && paymentLinkAttemptData.ifscCode!.isNotEmpty ? paymentLinkAttemptData.ifscCode! : '-',
                      ),
                    ),
                    // Remarks
                    customKeyValueText(
                      key: 'Remarks : ',
                      value: paymentLinkAttemptData.remarks != null && paymentLinkAttemptData.remarks!.isNotEmpty ? paymentLinkAttemptData.remarks! : '-',
                    ),
                    // Transaction date
                    customKeyValueText(
                      key: 'Transaction Date : ',
                      value: paymentLinkAttemptData.createdOn != null && paymentLinkAttemptData.createdOn!.isNotEmpty ? paymentLinkController.formatDateTime(paymentLinkAttemptData.createdOn!) : '-',
                    ),
                    height(0.8.h),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

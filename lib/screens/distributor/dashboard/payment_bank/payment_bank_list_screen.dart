import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../controller/distributor/payment_bank_controller.dart';
import '../../../../model/payment_bank/payment_bank_list_model.dart';
import '../../../../routes/routes.dart';
import '../../../../widgets/button.dart';

class PaymentBankListScreen extends StatefulWidget {
  const PaymentBankListScreen({super.key});

  @override
  State<PaymentBankListScreen> createState() => _PaymentBankListScreenState();
}

class _PaymentBankListScreenState extends State<PaymentBankListScreen> {
  final PaymentBankController paymentBankController = Get.find();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await paymentBankController.getPaymentBankList();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Payment Bank/UPI',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        height: 7.h,
        padding: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: ColorsForApp.stepBgColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Token request
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (paymentBankController.selectedTabIndex.value != 0) {
                      paymentBankController.selectedTabIndex.value = 0;
                    }
                  },
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: paymentBankController.selectedTabIndex.value == 0 ? ColorsForApp.whiteColor : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Bank List',
                      style: TextHelper.size15.copyWith(
                        fontFamily: paymentBankController.selectedTabIndex.value == 0 ? mediumGoogleSansFont : regularGoogleSansFont,
                        color: paymentBankController.selectedTabIndex.value == 0 ? ColorsForApp.primaryColor : ColorsForApp.lightBlackColor,
                      ),
                    ),
                  ),
                ),
              ),
              // Credentials
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (paymentBankController.selectedTabIndex.value != 1) {
                      paymentBankController.selectedTabIndex.value = 1;
                    }
                  },
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: paymentBankController.selectedTabIndex.value == 1 ? ColorsForApp.whiteColor : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'UPI List',
                      style: TextHelper.size15.copyWith(
                        fontFamily: paymentBankController.selectedTabIndex.value == 1 ? mediumGoogleSansFont : regularGoogleSansFont,
                        color: paymentBankController.selectedTabIndex.value == 1 ? ColorsForApp.primaryColor : ColorsForApp.lightBlackColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      mainBody: Obx(
        () => paymentBankController.selectedTabIndex.value == 0
            // Bank list
            ? paymentBankController.allPaymentBankList.isEmpty
                ? notFoundText(text: 'No bank found')
                : RefreshIndicator(
                    color: ColorsForApp.primaryColor,
                    onRefresh: () async {
                      isLoading.value = true;
                      await Future.delayed(const Duration(seconds: 1), () async {
                        await paymentBankController.getPaymentBankList(isLoaderShow: false);
                      });
                      isLoading.value = false;
                    },
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                      itemCount: paymentBankController.allPaymentBankList.length,
                      itemBuilder: (context, index) {
                        PaymentBankListModel paymentBankListModel = paymentBankController.allPaymentBankList[index];
                        return customCard(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height(1.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Bank : ${paymentBankListModel.name != null && paymentBankListModel.name!.toString().isNotEmpty ? paymentBankListModel.name!.toString() : '-'}',
                                      style: TextHelper.size13.copyWith(
                                        fontFamily: mediumGoogleSansFont,
                                        color: ColorsForApp.lightBlackColor,
                                      ),
                                    ),
                                    Visibility(
                                      visible: paymentBankListModel.fileUrl != null && paymentBankListModel.fileUrl!.toString().isNotEmpty,
                                      child: GestureDetector(
                                        onTap: () {
                                          viewCheckBookDialog(context, paymentBankListModel, index);
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: ColorsForApp.primaryColor),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Image.network(
                                              paymentBankListModel.fileUrl.toString(),
                                              fit: BoxFit.cover,
                                              height: 45,
                                              width: 45,
                                            )),
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
                                customKeyValueText(
                                  key: 'ID : ',
                                  value: paymentBankListModel.id != null && paymentBankListModel.id!.toString().isNotEmpty ? paymentBankListModel.id!.toString() : '-',
                                ),
                                customKeyValueText(
                                  key: 'Account Holder Name : ',
                                  value: paymentBankListModel.accountName != null && paymentBankListModel.accountName!.isNotEmpty ? paymentBankListModel.accountName! : '-',
                                ),
                                customKeyValueText(
                                  key: 'Account Number : ',
                                  value: paymentBankListModel.accountNumber != null && paymentBankListModel.accountNumber!.isNotEmpty ? paymentBankListModel.accountNumber! : '-',
                                ),
                                customKeyValueText(
                                  key: 'IFSC Code : ',
                                  value: paymentBankListModel.ifsc != null && paymentBankListModel.ifsc!.isNotEmpty ? paymentBankListModel.ifsc! : '-',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return height(0.5.h);
                      },
                    ),
                  )
            // UPI list
            : paymentBankController.allPaymentUpiList.isEmpty
                ? notFoundText(text: 'No UPI found')
                : RefreshIndicator(
                    color: ColorsForApp.primaryColor,
                    onRefresh: () async {
                      isLoading.value = true;
                      await Future.delayed(const Duration(seconds: 1), () async {
                        await paymentBankController.getPaymentBankList(isLoaderShow: false);
                      });
                      isLoading.value = false;
                    },
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                      itemCount: paymentBankController.allPaymentUpiList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        PaymentBankListModel paymentBankListModel = paymentBankController.allPaymentUpiList[index];
                        return customCard(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height(1.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'UPI : ${paymentBankListModel.upiid != null && paymentBankListModel.upiid!.isNotEmpty ? paymentBankListModel.upiid! : '-'}',
                                      style: TextHelper.size13.copyWith(
                                        fontFamily: mediumGoogleSansFont,
                                        color: ColorsForApp.lightBlackColor,
                                      ),
                                    ),
                                    height(0.4.h),
                                  ],
                                ),
                                height(1.5.h),
                                Divider(
                                  height: 0,
                                  thickness: 0.2,
                                  color: ColorsForApp.greyColor,
                                ),
                                height(1.5.h),
                                customKeyValueText(
                                  key: 'ID : ',
                                  value: paymentBankListModel.id != null && paymentBankListModel.id!.toString().isNotEmpty ? paymentBankListModel.id.toString() : '-',
                                ),
                                customKeyValueText(
                                  key: 'Account Holder Name : ',
                                  value: paymentBankListModel.accountName != null && paymentBankListModel.accountName!.isNotEmpty ? paymentBankListModel.accountName! : '-',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return height(0.5.h);
                      },
                    ),
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsForApp.primaryColor,
        onPressed: () {
          Get.toNamed(Routes.ADD_PAYMENT_BANK_SCREEN);
        },
        child: Icon(
          Icons.add,
          color: ColorsForApp.whiteColor,
        ),
      ),
    );
  }

  Future<dynamic> viewCheckBookDialog(BuildContext context, PaymentBankListModel model, int index) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Center(
              child: Image.network(
                model.fileUrl.toString(),
                fit: BoxFit.fill,
                height: 70.h,
                width: 40.h,
              ),
            ));
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/dmt/dmt_o_controller.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../model/money_transfer/transaction_slab_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/string_constants.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';

class DmtOTransactionSlabScreen extends StatefulWidget {
  const DmtOTransactionSlabScreen({Key? key}) : super(key: key);

  @override
  State<DmtOTransactionSlabScreen> createState() => _DmtOTransactionSlabScreenState();
}

class _DmtOTransactionSlabScreenState extends State<DmtOTransactionSlabScreen> {
  DmtOController dmtOController = Get.find();
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).padding.top + 18.h,
                    width: 100.h,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(
                          Assets.imagesAppBarBgImage,
                        ),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 0),
                          color: ColorsForApp.greyColor.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(MediaQuery.of(context).padding.top + 1.h),
                        dataRow(
                          title: 'Remitter Name: ',
                          data: dmtOController.validateRemitterModel.value.data!.name != null && dmtOController.validateRemitterModel.value.data!.name!.isNotEmpty ? dmtOController.validateRemitterModel.value.data!.name! : '-',
                        ),
                        height(5),
                        dataRow(
                          title: 'Recipient Name: ',
                          data: dmtOController.rNameController.text.isNotEmpty ? dmtOController.rNameController.text : '-',
                        ),
                        height(5),
                        dataRow(
                          title: 'Account Number: ',
                          data: dmtOController.rAccountNumberController.text.isNotEmpty ? dmtOController.rAccountNumberController.text : '-',
                        ),
                        height(5),
                        dataRow(
                          title: 'IFSC: ',
                          data: dmtOController.rIfscCodeController.text.isNotEmpty ? dmtOController.rIfscCodeController.text : '-',
                        ),
                        height(5),
                        dataRow(
                          title: 'Payment Mode: ',
                          data: dmtOController.selectedPaymentType.value.isNotEmpty ? dmtOController.selectedPaymentType.value : '-',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 3.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          height(2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Amount',
                                    style: TextHelper.size14.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Surcharge',
                                    style: TextHelper.size14.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Margin',
                                    style: TextHelper.size14.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Total',
                                    style: TextHelper.size14.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height(5),
                          Divider(
                            thickness: 1,
                            color: ColorsForApp.greyColor,
                          ),
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: dmtOController.transactionSlabModel.value.slab!.length,
                              itemBuilder: (context, index) {
                                Slab slabData = dmtOController.transactionSlabModel.value.slab![index];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            '₹ ${slabData.amount != null ? slabData.amount!.toString() : '0'}',
                                            style: TextHelper.size13,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            '₹ ${slabData.serviceCharge != null ? slabData.serviceCharge.toString() : '0'}',
                                            style: TextHelper.size13,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            '₹ ${slabData.marginAmount != null ? slabData.marginAmount.toString() : '0'}',
                                            style: TextHelper.size13,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            '₹ ${slabData.total != null ? slabData.total.toString() : '0'}',
                                            style: TextHelper.size13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(5),
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
                  )
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 15.5.h,
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5.h,
                        width: 70.w,
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 1.2.h),
                        decoration: BoxDecoration(
                          color: ColorsForApp.primaryColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '₹ ${dmtOController.rAmountController.text}.00',
                          style: TextHelper.size16.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CommonButton(
                  onPressed: () {
                    dmtOController.rAmountController.clear();
                    dmtOController.rAmountIntoWords.value = '';
                    dmtOController.rTpinController.clear();
                    dmtOController.pendingSlabAmountController.clear();
                    dmtOController.successSlabAmountController.clear();
                    dmtOController.failedSlabAmountController.clear();
                    dmtOController.pendingSlabList.clear();
                    dmtOController.successSlabList.clear();
                    dmtOController.failedSlabList.clear();
                    Get.back();
                  },
                  label: 'Cancel',
                  labelColor: ColorsForApp.primaryColor,
                  bgColor: ColorsForApp.whiteColor,
                  border: Border.all(
                    color: ColorsForApp.primaryColor,
                  ),
                ),
              ),
              width(5.w),
              Expanded(
                child: CommonButton(
                  onPressed: () async {
                    showProgressIndicator();
                    await fetchDataForSlabs();
                    dismissProgressIndicator();
                    if (count == dmtOController.transactionSlabModel.value.slab!.length && isInternetAvailable.value == true) {
                      Get.toNamed(Routes.DMT_O_TRANSACTION_STATUS_SCREEN);
                    }
                  },
                  label: 'Proceed',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchDataForSlabs() async {
    if (dmtOController.transactionSlabModel.value.slab!.isNotEmpty) {
      isTransactionInit.value = true;
      try {
        double totalAmount = 0;
        double totalFailedAmount = 0;
        for (Slab slab in dmtOController.transactionSlabModel.value.slab!) {
          try {
            // Make an API call for the current slab
            count++;
            int result = await dmtOController.transaction(
              amount: slab.amount!,
              slabNo: slab.slno!,
              isLoaderShow: false,
            );
            if (result == 0) {
              slab.status = 'Failed';
              totalFailedAmount += double.parse(slab.amount!);
              dmtOController.failedSlabAmountController.text = totalFailedAmount.toString();
              dmtOController.failedSlabList.add(slab.status);
            } else if (result == 1) {
              slab.status = 'Success';
              slab.orderId = dmtOController.transactionModel.value.data!.orderId ?? '';
              slab.bankTxnId = dmtOController.transactionModel.value.data!.bankTxnId ?? '';
              slab.txnRefNumber = dmtOController.transactionModel.value.data!.txnRefNumber ?? '';
              totalAmount += double.parse(slab.amount!);
              dmtOController.successSlabAmountController.text = totalAmount.toString();
              dmtOController.successSlabList.add(slab.status);
            } else if (result == 2) {
              slab.status = 'Pending';
              slab.orderId = dmtOController.transactionModel.value.data!.orderId ?? '';
              slab.bankTxnId = dmtOController.transactionModel.value.data!.bankTxnId ?? '';
              slab.txnRefNumber = dmtOController.transactionModel.value.data!.txnRefNumber ?? '';
              totalFailedAmount += double.parse(slab.amount!);
              dmtOController.pendingSlabAmountController.text = totalFailedAmount.toString();
              dmtOController.pendingSlabList.add(slab.status);
            }
          } catch (error) {
            slab.status = '$error';
          }
        }
      } catch (e) {
        dismissProgressIndicator();
        debugPrint(e.toString());
      } finally {
        dismissProgressIndicator();
        isTransactionInit.value = false;
      }
    }
    setState(() {});
  }

  Row dataRow({required String title, required String data}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextHelper.size14.copyWith(
            fontFamily: mediumGoogleSansFont,
            color: ColorsForApp.lightBlackColor.withOpacity(0.4),
          ),
        ),
        Text(
          data.isNotEmpty ? data : '-',
          style: TextHelper.size13.copyWith(
            fontFamily: mediumGoogleSansFont,
            color: ColorsForApp.lightBlackColor,
          ),
        )
      ],
    );
  }
}

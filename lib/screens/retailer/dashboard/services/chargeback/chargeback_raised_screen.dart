import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/chargeback_controller.dart';
import '../../../../../model/chargeback/chargeback_raised_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';

class ChargebackRaisedScreen extends StatefulWidget {
  const ChargebackRaisedScreen({super.key});

  @override
  State<ChargebackRaisedScreen> createState() => _ChargebackRaisedScreenState();
}

class _ChargebackRaisedScreenState extends State<ChargebackRaisedScreen> {
  ChargebackController chargebackController = Get.find();
  ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> orderUpdateKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    await chargebackController.getChargebackRaisedListApi(pageNumber: chargebackController.currentPage.value);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && chargebackController.currentPage.value < chargebackController.totalPages.value) {
        chargebackController.currentPage.value++;
        await chargebackController.getChargebackRaisedListApi(
          pageNumber: chargebackController.currentPage.value,
          isLoaderShow: false,
        );
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    chargebackController.selectedCommissionIndex.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
       CustomScaffold(
        title: chargebackController.selectedCommissionIndex.value == 0? 'Chargeback Raised' : 'Chargeback History',
        isShowLeadingIcon: true,
        appBarHeight: 7.h,
        topCenterWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Obx(()=>
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        showProgressIndicator();
                          if(chargebackController.selectedCommissionIndex.value == 1) {
                              chargebackController.currentPage.value = 1;
                              chargebackController.totalPages = 1.obs;
                              chargebackController.hasNext = false.obs;
                              await chargebackController.getChargebackRaisedListApi(pageNumber: chargebackController.currentPage.value, isLoaderShow: false,);
                              chargebackController.selectedCommissionIndex.value = 0;
                          }
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
                              colors: chargebackController.selectedCommissionIndex.value == 0
                                  ? [
                                ColorsForApp.whiteColor,
                                ColorsForApp.selectedTabBackgroundColor,
                              ]
                                  : [
                                ColorsForApp.whiteColor,
                                ColorsForApp.whiteColor,
                              ],
                            ),
                            color: chargebackController.selectedCommissionIndex.value == 0 ? ColorsForApp.selectedTabBgColor : ColorsForApp.whiteColor,
                            border: Border(
                              bottom: BorderSide(
                                color: chargebackController.selectedCommissionIndex.value == 0 ? ColorsForApp.primaryColor : ColorsForApp.accentColor,
                                width: 2,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Raised',
                            style: TextHelper.size13.copyWith(
                              color: chargebackController.selectedCommissionIndex.value == 0 ? ColorsForApp.primaryColor : ColorsForApp.blackColor,
                              fontFamily: chargebackController.selectedCommissionIndex.value == 0 ? mediumGoogleSansFont : regularGoogleSansFont,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  width(10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        showProgressIndicator();
                        if (chargebackController.selectedCommissionIndex.value == 0) {
                          chargebackController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
                          chargebackController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
                          chargebackController.selectedFromDate.value = DateFormat('yyyy-MM-dd').format(chargebackController.fromDate.value);
                          chargebackController.selectedToDate.value = DateFormat('yyyy-MM-dd').format(chargebackController.toDate.value);
                          chargebackController.currentPage.value = 1;
                          chargebackController.totalPages = 1.obs;
                          chargebackController.hasNext = false.obs;
                          await chargebackController.getChargebackHistoryApi(pageNumber: chargebackController.currentPage.value, isLoaderShow: false);
                          chargebackController.selectedCommissionIndex.value = 1;
                        }
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
                              colors: chargebackController.selectedCommissionIndex.value == 1
                                  ? [
                                ColorsForApp.whiteColor,
                                ColorsForApp.selectedTabBackgroundColor,
                              ]
                                  : [
                                ColorsForApp.whiteColor,
                                ColorsForApp.whiteColor,
                              ],
                            ),
                            color: chargebackController.selectedCommissionIndex.value == 1 ? ColorsForApp.selectedTabBgColor : ColorsForApp.whiteColor,
                            border: Border(
                              bottom: BorderSide(
                                color: chargebackController.selectedCommissionIndex.value == 1 ? ColorsForApp.primaryColor : ColorsForApp.accentColor,
                                width: 2,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'History',
                            style: TextHelper.size13.copyWith(
                                color: chargebackController.selectedCommissionIndex.value == 1 ? ColorsForApp.primaryColor : ColorsForApp.blackColor,
                                fontFamily: chargebackController.selectedCommissionIndex.value == 1 ? mediumGoogleSansFont : regularGoogleSansFont),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ),
        ),
        mainBody: Column(
          children: [
            chargebackController.selectedCommissionIndex.value == 1?
            Container(
              height: 7.h,
              padding: EdgeInsets.all(1.h),
              decoration: BoxDecoration(
                color: ColorsForApp.stepBgColor,
                borderRadius: BorderRadius.circular(20),
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
                        initialDateRange: DateRange(chargebackController.fromDate.value, chargebackController.toDate.value),
                        onDateRangeChanged: (DateRange? date) {
                          chargebackController.fromDate.value = date!.start;
                          chargebackController.toDate.value = date.end;
                        },
                        noText: 'Cancel',
                        onNo: () {
                          Get.back();
                        },
                        yesText: 'Proceed',
                        onYes: () async {
                          Get.back();
                          chargebackController.selectedFromDate.value = DateFormat('yyyy-MM-dd').format(chargebackController.fromDate.value);
                          chargebackController.selectedToDate.value = DateFormat('yyyy-MM-dd').format(chargebackController.toDate.value);
                          await chargebackController.getChargebackHistoryApi(pageNumber: 1);
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
                              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(chargebackController.selectedFromDate.value))} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(chargebackController.selectedToDate.value))}',
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
            ) : const SizedBox.shrink(),
            height(1.h),
            Expanded(
              child: Obx(()=>
                  chargebackController.chargebackRaisedList.isEmpty
                      ? notFoundText(text: 'No data found')
                      : RefreshIndicator(
                    color: ColorsForApp.primaryColor,
                    onRefresh: () async {
                      isLoading.value = true;
                      await Future.delayed(const Duration(seconds: 1), () async {
                         chargebackController.selectedCommissionIndex.value == 0?
                         await chargebackController.getChargebackRaisedListApi(pageNumber: 1, isLoaderShow: false):
                         await chargebackController.getChargebackHistoryApi(pageNumber: 1, isLoaderShow: false);
                      });
                      isLoading.value = false;
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      itemCount: chargebackController.chargebackRaisedList.length,
                      itemBuilder: (context, index) {
                        if (index == chargebackController.chargebackRaisedList.length - 1 && chargebackController.hasNext.value) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ColorsForApp.primaryColor,
                              ),
                            ),
                          );
                        } else {
                          ChargebackRaisedData chargebackRaisedData = chargebackController.chargebackRaisedList[index];
                          return GestureDetector(
                                onTap: () {
                                  if(chargebackRaisedData.status == 0 || chargebackRaisedData.status == 4){
                                    Get.toNamed(Routes.CHARGEBACK_DOCUMENTS_SCREEN,arguments: chargebackRaisedData.uniqueId);
                                  }
                                },
                                child: customCard(
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4.w, vertical: 1.h),
                                      child: Column(
                                        children: [
                                          height(1.h),
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [

                                              Expanded(
                                                  child: Text( chargebackRaisedData
                                                      .subject !=
                                                      null &&
                                                      chargebackRaisedData.subject!
                                                          .isNotEmpty
                                                      ? chargebackRaisedData
                                                      .subject!
                                                      : '-',style: TextHelper.size16,)
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8),
                                                    border: Border.all(
                                                        color: chargebackRaisedData
                                                            .status == 0
                                                            ? ColorsForApp
                                                            .primaryColor
                                                            : chargebackRaisedData
                                                            .status == 1 || chargebackRaisedData.status == 3
                                                            ? ColorsForApp
                                                            .successColor
                                                            : ColorsForApp
                                                            .orangeColor,
                                                        width: 0.2)),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .all(8),
                                                  child: Text(
                                                    chargebackController
                                                        .chargebackRaisedStatus(
                                                        chargebackRaisedData
                                                            .status!),
                                                    style: TextHelper
                                                        .size13
                                                        .copyWith(
                                                      color: chargebackRaisedData
                                                          .status == 0
                                                          ? ColorsForApp
                                                          .primaryColor
                                                          : chargebackRaisedData
                                                          .status == 1 || chargebackRaisedData.status == 3
                                                          ? ColorsForApp
                                                          .successColor
                                                          : ColorsForApp
                                                          .orangeColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          customKeyValueText(
                                            key: 'Amount :',
                                            value: chargebackRaisedData
                                                .amount !=
                                                null
                                                ? '₹ ${chargebackRaisedData
                                                .amount!.toStringAsFixed(2)}'
                                                : '-',
                                          ),
                                          customKeyValueText(
                                            key: 'Txn Id :',
                                            value: chargebackRaisedData
                                                .orderId !=
                                                null &&
                                                chargebackRaisedData.orderId!
                                                    .isNotEmpty
                                                ? chargebackRaisedData.orderId!
                                                : '-',
                                          ),
                                          customKeyValueText(
                                            key: 'Category Name :',
                                            value: chargebackRaisedData
                                                .categoryName !=
                                                null &&
                                                chargebackRaisedData.categoryName!
                                                    .isNotEmpty
                                                ? chargebackRaisedData
                                                .categoryName!
                                                : '-',
                                          ),
                                          customKeyValueText(
                                            key: 'Expiry Date :',
                                            value: chargebackRaisedData
                                                .expiryDate !=
                                                null &&
                                                chargebackRaisedData.expiryDate!
                                                    .isNotEmpty
                                                ? chargebackRaisedData.expiryDate!
                                                : '-',
                                          ),
                                          customKeyValueText(
                                            key: 'Raised on :',
                                            value: chargebackRaisedData.createdOn !=
                                                null &&
                                                chargebackRaisedData.createdOn!
                                                    .isNotEmpty
                                                ? DateFormat(
                                                'MMMM dd yyyy, hh:mm aaa').format(
                                                DateTime.parse(chargebackRaisedData
                                                    .createdOn!)).toString()
                                                : '-',
                                          ),
                                        ],
                                      )),
                                ),

                          );
                        }
                      },
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

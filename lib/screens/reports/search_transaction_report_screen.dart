import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controller/report_controller.dart';
import '../../generated/assets.dart';
import '../../model/report/search_transaction_report_model.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';
import '../../widgets/base_dropdown.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/text_field.dart';

class SearchTransactionReportScreen extends StatefulWidget {
  const SearchTransactionReportScreen({super.key});

  @override
  State<SearchTransactionReportScreen> createState() => _SearchTransactionReportScreenState();
}

class _SearchTransactionReportScreenState extends State<SearchTransactionReportScreen> {
  final ReportController reportController = Get.find();
  ScrollController scrollController = ScrollController();
  RxList searchedList = [].obs;

  @override
  void initState() {
    super.initState();
  }

  Future<void> callAsyncApi() async {
    try {
      await reportController.getSearchTransactionReport(isLoaderShow: false, mobileNo: '', accountNo: '', clientRefId: '', apiRefId: '', operatorRefId: '', orderId: '', userId: 0);
      searchedList.assignAll(reportController.searchTransactionReportDataList);
    } catch (e) {
      dismissProgressIndicator();
    }
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // appBarHeight: 15.h,
      title: 'Search Transactions',
      isShowLeadingIcon: true,
      topCenterWidget: Column(
          children: [
            Card(
              color: ColorsForApp.whiteColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              child:Obx(
                    ()=> BaseDropDown(
                  value: reportController.searchType.value.isEmpty ? null : reportController.searchType.value,
                  options: reportController.searchTypeList.map((element) {
                    return element;
                  },
                  ).toList(),
                  hintText: 'Select',
                  onChanged: (value) async {
                    reportController.searchType.value = value!;
                    reportController.searchTransactionController.clear();
                    searchedList.clear();
                  },
                ),
              ),
            ),
            Card(
              color: ColorsForApp.whiteColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              child: CustomTextField(
                controller: reportController.searchTransactionController,
                style: TextHelper.size14.copyWith(
                  fontFamily: mediumGoogleSansFont,
                ),  
                hintText: 'Search here...',
                suffixIcon: Icon(
                  Icons.search,
                  color: ColorsForApp.lightBlackColor,
                ),
                hintTextColor: ColorsForApp.lightBlackColor.withOpacity(0.6),
                focusedBorderColor: ColorsForApp.grayScale500,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) async {
                  if (value.isEmpty && reportController.searchType.value.isEmpty) {
                    await reportController.getSearchTransactionReport(isLoaderShow: false, mobileNo: '', accountNo: '', clientRefId: '', apiRefId: '', operatorRefId: '', orderId: '', userId: 0);
                    searchedList.assignAll(reportController.searchTransactionReportDataList);
                  } else {
                    if(reportController.searchType.value=="Mobile") {
                      await reportController.getSearchTransactionReport(
                        mobileNo: reportController.searchTransactionController.text,
                        accountNo: "",
                        clientRefId: "",
                        apiRefId: "",
                        operatorRefId: "",
                        orderId: "",
                        userId: 0,
                        isLoaderShow: false,
                      );
                      searchedList.assignAll(reportController.searchTransactionReportDataList);
                    }else if(reportController.searchType.value=="Account Number") {
                      await reportController.getSearchTransactionReport(
                        mobileNo: "",
                        accountNo: reportController.searchTransactionController.text,
                        clientRefId: "",
                        apiRefId: "",
                        operatorRefId: "",
                        orderId: "",
                        userId: 0,
                        isLoaderShow: false,
                      );
                      searchedList.assignAll(reportController.searchTransactionReportDataList);
                    }else if(reportController.searchType.value=="Api Ref Id") {
                      await reportController.getSearchTransactionReport(
                        mobileNo: "",
                        accountNo: "",
                        clientRefId: "",
                        apiRefId: reportController.searchTransactionController.text,
                        operatorRefId: "",
                        orderId: "",
                        userId: 0,
                        isLoaderShow: false,
                      );
                      searchedList.assignAll(reportController.searchTransactionReportDataList);
                    }else if(reportController.searchType.value=="RRN") {
                      await reportController.getSearchTransactionReport(
                        mobileNo: "",
                        accountNo: "",
                        clientRefId: "",
                        apiRefId: "",
                        operatorRefId: "",
                        orderId: reportController.searchTransactionController.text,
                        userId: 0,
                        isLoaderShow: false,
                      );
                      searchedList.assignAll(reportController.searchTransactionReportDataList);
                    }else if(reportController.searchType.value=="Client Ref Id") {
                      await reportController.getSearchTransactionReport(
                        mobileNo: "",
                        accountNo: "",
                        clientRefId: reportController.searchTransactionController.text,
                        apiRefId: "",
                        operatorRefId: "",
                        orderId: "",
                        userId: 0,
                        isLoaderShow: false,
                      );
                      searchedList.assignAll(reportController.searchTransactionReportDataList);
                    }else if(reportController.searchType.value=="TID") {
                      await reportController.getSearchTransactionReport(
                        mobileNo: "",
                        accountNo: "",
                        clientRefId: "",
                        apiRefId: "",
                        operatorRefId: "",
                        orderId: "",
                        userId: int.parse(reportController.searchTransactionController.text),
                        isLoaderShow: false,
                      );
                      searchedList.assignAll(reportController.searchTransactionReportDataList);
                    }

                  }



                },
              ),
            ),
          ],
      ),
      mainBody: Obx(
        () => searchedList.isEmpty
            ? notFoundText(text: 'No transactions found')
            : ListView.separated(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(2.w),
                  itemCount: searchedList.length,
                  itemBuilder: (context, index) {
                    SearchTransactionData searchTransactionModel = searchedList[index];
                      return customCard(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 6.h,
                                    width: 14.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          searchTransactionModel.status == 0
                                              ? Assets.imagesExclamationMark
                                              : searchTransactionModel.status == 1
                                              ? Assets.imagesGreenCheck
                                              : searchTransactionModel.status == 5
                                              ? Assets.imagesGreenCheck
                                              : Assets.imagesTimer,
                                        ),
                                        scale: 2.6.w,
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  searchTransactionModel.number != null && searchTransactionModel.number!.isNotEmpty ? searchTransactionModel.number! : '-',
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
                                                      'User Name :',
                                                      style: TextHelper.size12.copyWith(
                                                        fontFamily: mediumGoogleSansFont,
                                                        color: ColorsForApp.greyColor,
                                                      ),
                                                    ),
                                                    width(5),
                                                    Text(
                                                      searchTransactionModel.userDetails != null && searchTransactionModel.userDetails!.isNotEmpty ? searchTransactionModel.userDetails! : '-',
                                                      textAlign: TextAlign.start,
                                                      style: TextHelper.size12,
                                                    ),
                                                  ],
                                                ),
                                                height(0.5.h),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Txn ID :',
                                                      style: TextHelper.size12.copyWith(
                                                        fontFamily: mediumGoogleSansFont,
                                                        color: ColorsForApp.greyColor,
                                                      ),
                                                    ),
                                                    width(5),
                                                    Text(
                                                      searchTransactionModel.orderId != null && searchTransactionModel.orderId!.isNotEmpty ? searchTransactionModel.orderId! : '-',
                                                      textAlign: TextAlign.start,
                                                      style: TextHelper.size12,
                                                    ),
                                                  ],
                                                ),
                                                height(0.5.h),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Category :',
                                                      style: TextHelper.size12.copyWith(
                                                        fontFamily: mediumGoogleSansFont,
                                                        color: ColorsForApp.greyColor,
                                                      ),
                                                    ),
                                                    width(5),
                                                    Expanded(
                                                      child: Text(
                                                        searchTransactionModel.categoryName != null && searchTransactionModel.categoryName!.isNotEmpty ? searchTransactionModel.categoryName! : '-',
                                                        textAlign: TextAlign.start,
                                                        style: TextHelper.size12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                height(0.5.h),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Date :',
                                                      style: TextHelper.size12.copyWith(
                                                        fontFamily: mediumGoogleSansFont,
                                                        color: ColorsForApp.greyColor,
                                                      ),
                                                    ),
                                                    width(5),
                                                    Text(
                                                      searchTransactionModel.transactionDate != null && searchTransactionModel.transactionDate!.isNotEmpty ? reportController.formatDateTime(searchTransactionModel.transactionDate!) : '-',
                                                      textAlign: TextAlign.start,
                                                      style: TextHelper.size12,
                                                    ),
                                                  ],
                                                ),
                                                height(0.5.h),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Charges :',
                                                      style: TextHelper.size12.copyWith(
                                                        fontFamily: mediumGoogleSansFont,
                                                        color: ColorsForApp.greyColor,
                                                      ),
                                                    ),
                                                    width(5),
                                                    Text(
                                                      (searchTransactionModel.chargeAmt ?? '-').toString(),
                                                      textAlign: TextAlign.start,
                                                      style: TextHelper.size12,
                                                    ),
                                                  ],
                                                ),
                                                height(0.5.h),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Cost :',
                                                      style: TextHelper.size12.copyWith(
                                                        fontFamily: mediumGoogleSansFont,
                                                        color: ColorsForApp.greyColor,
                                                      ),
                                                    ),
                                                    width(5),
                                                    Text(
                                                      (searchTransactionModel.cost ?? '-').toString(),
                                                      textAlign: TextAlign.start,
                                                      style: TextHelper.size12,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                searchTransactionModel.amount != null ? ' ₹ ${searchTransactionModel.amount!.toStringAsFixed(2)}' : '',
                                                style: TextHelper.size14.copyWith(color: searchTransactionModel.status == 1 ? ColorsForApp.successColor : ColorsForApp.lightBlackColor, fontFamily: regularGoogleSansFont),
                                              ),
                                              height(0.5.h),
                                              Visibility(
                                                visible: searchTransactionModel.status != null && searchTransactionModel.status! == 1 ? false : true,
                                                child: Text(
                                                  " ${searchTransactionModel.status == 0 ? "Failed" : searchTransactionModel.status == 2 ? "Pending" : searchTransactionModel.status == 5 ? "Accepted" : searchTransactionModel.status == 3 ? "Processing" : searchTransactionModel.status == 4 ? "Reversal" : ""}",
                                                  style: TextHelper.size14.copyWith(
                                                    fontFamily: regularGoogleSansFont,
                                                    color: searchTransactionModel.status == 0 || searchTransactionModel.status == 4
                                                        ? ColorsForApp.chilliRedColor
                                                        : searchTransactionModel.status == 5
                                                        ? ColorsForApp.successColor
                                                        : Colors.orange,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Visibility(
                                visible: !searchTransactionModel.isVisible.value,
                                child: height(0.8.h),
                              ),
                              Visibility(
                                visible: searchTransactionModel.isVisible.value,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
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
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Visibility(
                                                      visible: searchTransactionModel.status != null && searchTransactionModel.status! == 1 ? false : true,
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
                                                                  "Help",
                                                                  textAlign: TextAlign.center,
                                                                  style: TextHelper.size13.copyWith(
                                                                    fontFamily: mediumGoogleSansFont,
                                                                    color: ColorsForApp.lightBlackColor,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons.help_outline_rounded,
                                                                  color: ColorsForApp.primaryColorBlue,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        if (searchTransactionModel.categoryName == 'DMT') {
                                                          Get.toNamed(
                                                            Routes.TRANSACTION_SINGLE_REPORT_SCREEN,
                                                            arguments: searchTransactionModel,
                                                          );
                                                        } else if (searchTransactionModel.categoryName != null &&
                                                            (searchTransactionModel.categoryName == 'AEPS' ||
                                                                searchTransactionModel.categoryName == 'BBPS' ||
                                                                searchTransactionModel.categoryName == 'Telecom' ||
                                                                searchTransactionModel.categoryName == 'MATM')) {
                                                          Get.toNamed(
                                                            Routes.RECEIPT_SCREEN,
                                                            arguments: [
                                                              searchTransactionModel.id.toString(), // Transaction id
                                                              0, // 0 for single, 1 for bulk
                                                              searchTransactionModel.operatorName!.contains('AEPS BALANCE INQUIRY')
                                                                  ? 'AEPSBE'
                                                                  : searchTransactionModel.operatorName!.contains('AEPS MINI STATEMENT')
                                                                  ? 'AEPSmini'
                                                                  : searchTransactionModel.operatorName!.contains('AEPS CASH WITHDRAWAL')
                                                                  ? 'AEPSCW'
                                                                  : searchTransactionModel.categoryName == 'BBPS'
                                                                  ? 'BBPS'
                                                                  : searchTransactionModel.categoryName == 'Telecom'
                                                                  ? 'Recharge'
                                                                  : searchTransactionModel.categoryName == 'MATM'
                                                                  ? 'MATMCW'
                                                                  : '', // Design
                                                            ],
                                                          );
                                                        } else {
                                                          Get.toNamed(
                                                            Routes.TRANSACTION_REPORT_DETAILS_SCREEN,
                                                            arguments: searchTransactionModel,
                                                          );
                                                        }

                                                      },
                                                      child: Container(
                                                        height: 9 + 7.w,
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
                                                              searchTransactionModel.categoryName == 'DMT' ? 'More details' : 'Receipt',
                                                              textAlign: TextAlign.center,
                                                              style: TextHelper.size13.copyWith(
                                                                fontFamily: mediumGoogleSansFont,
                                                                color: ColorsForApp.lightBlackColor,
                                                              ),
                                                            ),
                                                            width(2.w),
                                                            Icon(
                                                              Icons.more_horiz,
                                                              color: ColorsForApp.primaryColorBlue,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      height(1.h),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                          ),
                        ),
                      );

                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return height(0.4.h);
                  },
                ),
      ),
    );
  }
}

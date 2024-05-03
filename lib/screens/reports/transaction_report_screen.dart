import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/transaction_report_controller.dart';
import '../../../generated/assets.dart';
import '../../../model/report/category_model.dart';
import '../../../model/report/service_model.dart';
import '../../../model/report/transaction_report_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/string_constants.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/text_field_with_title.dart';

class TransactionReportScreen extends StatefulWidget {
  const TransactionReportScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TransactionReportScreenState();
  }
}

class TransactionReportScreenState extends State<TransactionReportScreen> {
  final TransactionReportController transactionReportController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    transactionReportController.fromDate.value = DateTime.now().subtract(const Duration(days: 6));
    transactionReportController.toDate.value = DateTime.now().subtract(const Duration(days: 0));
    transactionReportController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(transactionReportController.fromDate.value);
    transactionReportController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(transactionReportController.toDate.value);
    showProgressIndicator();
    if (GetStorage().read(loginTypeKey).toString().toLowerCase().contains('distributor')) {
      await transactionReportController.getUserType(isLoaderShow: false);
    }
    await transactionReportController.getCategoryList(isLoaderShow: false);
    await transactionReportController.getTransactionReportApi(pageNumber: 1, isLoaderShow: false);
    dismissProgressIndicator();
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && transactionReportController.currentPage.value < transactionReportController.totalPages.value) {
        transactionReportController.currentPage.value++;
        await transactionReportController.getTransactionReportApi(
          pageNumber: transactionReportController.currentPage.value,
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  void dispose() {
    if (GetStorage().read(loginTypeKey).toString().toLowerCase().contains('retailer')) {
      transactionReportController.resetRetailerFilterVariable();
    } else if (GetStorage().read(loginTypeKey).toString().toLowerCase().contains('distributor')) {
      transactionReportController.resetAreaDistributorFilterVariable();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Transactions Report',
      isShowLeadingIcon: true,
      action: [
        Obx(
          () => IconButton(
            onPressed: () {
              if (GetStorage().read(loginTypeKey).toString().toLowerCase().contains('retailer')) {
                retailerFilterBottomSheet();
              } else if (GetStorage().read(loginTypeKey).toString().toLowerCase().contains('distributor')) {
                distributorFilterBottomSheet();
              }
            },
            icon: Icon(
              transactionReportController.isShowClearFiltersButton.value == true ? Icons.filter_alt_rounded : Icons.filter_alt_outlined,
              color: ColorsForApp.lightBlackColor,
            ),
          ),
        ),
      ],
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
                  initialDateRange: DateRange(transactionReportController.fromDate.value, transactionReportController.toDate.value),
                  onDateRangeChanged: (DateRange? date) {
                    transactionReportController.fromDate.value = date!.start;
                    transactionReportController.toDate.value = date.end;
                  },
                  noText: 'Cancel',
                  onNo: () {
                    Get.back();
                  },
                  yesText: 'Proceed',
                  onYes: () async {
                    Get.back();
                    transactionReportController.selectedFromDate.value = DateFormat('MM/dd/yyyy').format(transactionReportController.fromDate.value);
                    transactionReportController.selectedToDate.value = DateFormat('MM/dd/yyyy').format(transactionReportController.toDate.value);
                    await transactionReportController.getTransactionReportApi(pageNumber: 1);
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
                        '${transactionReportController.selectedFromDate.value} - ${transactionReportController.selectedToDate.value}',
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
            height(1.h),
            Expanded(
              child: transactionReportController.transactionReportList.isEmpty
                  ? notFoundText(text: 'No transaction found')
                  : ListView.separated(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      itemCount: transactionReportController.transactionReportList.length,
                      itemBuilder: (context, index) {
                        if (index == transactionReportController.transactionReportList.length - 1 && transactionReportController.hasNext.value) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: ColorsForApp.primaryColor,
                              ),
                            ),
                          );
                        } else {
                          TransactionReportData transactionReportData = transactionReportController.transactionReportList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            child: Obx(
                              () => InkWell(
                                canRequestFocus: true,
                                focusColor: ColorsForApp.primaryColorBlue,
                                splashColor: ColorsForApp.primaryShadeColor,
                                hoverColor: ColorsForApp.primaryColor,
                                highlightColor: ColorsForApp.primaryColor,
                                autofocus: true,
                                onTap: () {
                                  for (TransactionReportData element in transactionReportController.transactionReportList) {
                                    if (element.isVisible.value == true) {
                                      element.isVisible.value = false;
                                    }
                                  }
                                  transactionReportData.isVisible.value = !transactionReportData.isVisible.value;
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
                                                transactionReportData.status == 0
                                                    ? Assets.imagesExclamationMark
                                                    : transactionReportData.status == 1
                                                        ? Assets.imagesGreenCheck
                                                        : transactionReportData.status == 5
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
                                                        transactionReportData.number != null && transactionReportData.number!.isNotEmpty ? transactionReportData.number! : '-',
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
                                                            'Category :',
                                                            style: TextHelper.size12.copyWith(
                                                              fontFamily: mediumGoogleSansFont,
                                                              color: ColorsForApp.greyColor,
                                                            ),
                                                          ),
                                                          width(5),
                                                          Text(
                                                            transactionReportData.categoryName != null && transactionReportData.categoryName!.isNotEmpty ? transactionReportData.categoryName! : '-',
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
                                                            'Service :',
                                                            style: TextHelper.size12.copyWith(
                                                              fontFamily: mediumGoogleSansFont,
                                                              color: ColorsForApp.greyColor,
                                                            ),
                                                          ),
                                                          width(5),
                                                          Text(
                                                            transactionReportData.serviceName != null && transactionReportData.serviceName!.isNotEmpty ? transactionReportData.serviceName! : '-',
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
                                                            'Operator :',
                                                            style: TextHelper.size12.copyWith(
                                                              fontFamily: mediumGoogleSansFont,
                                                              color: ColorsForApp.greyColor,
                                                            ),
                                                          ),
                                                          width(5),
                                                          Expanded(
                                                            child: Text(
                                                              transactionReportData.operatorName != null && transactionReportData.operatorName!.isNotEmpty ? transactionReportData.operatorName! : '-',
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
                                                            transactionReportData.transactionDate != null && transactionReportData.transactionDate!.isNotEmpty ? transactionReportController.formatDateTime(transactionReportData.transactionDate!) : '-',
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
                                                      transactionReportData.amount != null ? ' ₹ ${transactionReportData.amount!.toStringAsFixed(2)}' : '',
                                                      style: TextHelper.size14.copyWith(color: transactionReportData.status == 1 ? ColorsForApp.successColor : ColorsForApp.lightBlackColor, fontFamily: regularGoogleSansFont),
                                                    ),
                                                    height(0.5.h),
                                                    Visibility(
                                                      visible: transactionReportData.status != null && transactionReportData.status! == 1 ? false : true,
                                                      child: Text(
                                                        " ${transactionReportData.status == 0 ? "Failed" : transactionReportData.status == 2 ? "Pending" : transactionReportData.status == 5 ? "Accepted" : transactionReportData.status == 3 ? "Processing" : transactionReportData.status == 4 ? "Reversal" : ""}",
                                                        style: TextHelper.size14.copyWith(
                                                          fontFamily: regularGoogleSansFont,
                                                          color: transactionReportData.status == 0 || transactionReportData.status == 4
                                                              ? ColorsForApp.chilliRedColor
                                                              : transactionReportData.status == 5
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
                                      visible: !transactionReportData.isVisible.value,
                                      child: height(0.8.h),
                                    ),
                                    Visibility(
                                      visible: transactionReportData.isVisible.value,
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
                                                            visible: transactionReportData.status != null && transactionReportData.status! == 1 ? false : true,
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
                                                              if (transactionReportData.categoryName == 'DMT') {
                                                                Get.toNamed(
                                                                  Routes.TRANSACTION_SINGLE_REPORT_SCREEN,
                                                                  arguments: transactionReportData,
                                                                );
                                                              } else if (transactionReportData.categoryName != null &&
                                                                  (transactionReportData.categoryName == 'AEPS' ||
                                                                      transactionReportData.categoryName == 'BBPS' ||
                                                                      transactionReportData.categoryName == 'Telecom' ||
                                                                      transactionReportData.categoryName == 'MATM')) {
                                                                Get.toNamed(
                                                                  Routes.RECEIPT_SCREEN,
                                                                  arguments: [
                                                                    transactionReportData.id.toString(), // Transaction id
                                                                    0, // 0 for single, 1 for bulk
                                                                    transactionReportData.operatorName!.contains('AEPS BALANCE INQUIRY')
                                                                        ? 'AEPSBE'
                                                                        : transactionReportData.operatorName!.contains('AEPS MINI STATEMENT')
                                                                            ? 'AEPSmini'
                                                                            : transactionReportData.operatorName!.contains('AEPS CASH WITHDRAWAL')
                                                                                ? 'AEPSCW'
                                                                                : transactionReportData.categoryName == 'BBPS'
                                                                                    ? 'BBPS'
                                                                                    : transactionReportData.categoryName == 'Telecom'
                                                                                        ? 'Recharge'
                                                                                        : transactionReportData.categoryName == 'MATM'
                                                                                            ? 'MATMCW'
                                                                                            : '', // Design
                                                                  ],
                                                                );
                                                              } else {
                                                                Get.toNamed(
                                                                  Routes.TRANSACTION_REPORT_DETAILS_SCREEN,
                                                                  arguments: transactionReportData,
                                                                );
                                                              }
                                                              // if (transactionReportData.operatorName == "DMT") {
                                                              //   Get.toNamed(Routes.TRANSACTION_SINGLE_REPORT_SCREEN,
                                                              //       arguments: [transactionReportData]);
                                                              // } else if (transactionReportData.categoryId == 1) {
                                                              //   Get.toNamed(
                                                              //     Routes.RECEIPT_SCREEN,
                                                              //     arguments: [
                                                              //       transactionReportData.id.toString(), // Transaction id
                                                              //       transactionReportData.categoryName == 'DMT' ? 1 : 0, // 0 for single, 1 for bulk
                                                              //       transactionReportData.categoryName == 'BBPS'
                                                              //           ? 'BBPS'
                                                              //           : transactionReportData.categoryName == 'AEPS'
                                                              //               ? 'AEPSmini'
                                                              //               : transactionReportData.categoryName == 'DMT'
                                                              //                   ? 'DMT'
                                                              //                   : transactionReportData.categoryName == 'Telecom'
                                                              //                       ? 'Recharge'
                                                              //                       : '', // Design
                                                              //     ],
                                                              //   );
                                                              // }
                                                              // } else {
                                                              //   Get.toNamed(Routes.TRANSACTION_DETAILS_SCREEN, arguments: [transactionReportData]);
                                                              // }
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
                                                                    transactionReportData.categoryName == 'DMT' ? 'More details' : 'Receipt',
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
          ],
        ),
      ),
    );
  }

  // Retailer filter bottomSheet
  Future retailerFilterBottomSheet() {
    return customBottomSheet(
      children: [
        // Filter text
        Row(
          children: [
            Icon(
              Icons.filter_alt_rounded,
              color: ColorsForApp.primaryColor,
            ),
            width(5),
            Text(
              'Filter',
              style: TextHelper.size18.copyWith(
                color: ColorsForApp.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Obx(
              () => Visibility(
                visible: transactionReportController.isShowClearFiltersButton.value == true ? true : false,
                child: GestureDetector(
                  onTap: () async {
                    Get.back();
                    transactionReportController.resetRetailerFilterVariable();
                    await transactionReportController.getTransactionReportApi(pageNumber: 1);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.7,
                        color: ColorsForApp.greyColor.withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Clear Filter',
                      style: TextHelper.size13.copyWith(
                        fontFamily: mediumGoogleSansFont,
                        letterSpacing: 0.5,
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        height(2.h),
        // Select category
        CustomTextFieldWithTitle(
          controller: transactionReportController.selectedCategoryController,
          title: 'Category',
          hintText: 'Select category',
          readOnly: true,
          onTap: () async {
            CategoryModel selectedCategory = await Get.toNamed(
              Routes.SEARCHABLE_LIST_VIEW_SCREEN,
              arguments: [
                transactionReportController.categoryList, // list
                'categoryList', // listType
              ],
            );
            if (transactionReportController.selectedCategoryController.text != selectedCategory.name!) {
              transactionReportController.selectedServiceController.clear();
              transactionReportController.selectedServiceId.value = '';
              if (selectedCategory.name != null && selectedCategory.name!.isNotEmpty) {
                transactionReportController.selectedCategoryController.text = selectedCategory.name!;
                transactionReportController.selectedCategoryId.value = selectedCategory.id!.toString();
                await transactionReportController.getServiceList(
                  categoryId: transactionReportController.selectedCategoryId.value,
                );
              }
            }
          },
          validator: (value) {
            if (transactionReportController.selectedCategoryController.text.trim().isEmpty) {
              return 'Please select category';
            }
            return null;
          },
          suffixIcon: GestureDetector(
            onTap: () async {
              CategoryModel selectedCategory = await Get.toNamed(
                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                arguments: [
                  transactionReportController.categoryList, // list
                  'categoryList', // listType
                ],
              );
              if (transactionReportController.selectedCategoryController.text != selectedCategory.name!) {
                transactionReportController.selectedServiceController.clear();
                transactionReportController.selectedServiceId.value = '';
                if (selectedCategory.name != null && selectedCategory.name!.isNotEmpty) {
                  transactionReportController.selectedCategoryController.text = selectedCategory.name!;
                  transactionReportController.selectedCategoryId.value = selectedCategory.id!.toString();
                  await transactionReportController.getServiceList(
                    categoryId: transactionReportController.selectedCategoryId.value,
                  );
                }
              }
            },
            child: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: ColorsForApp.greyColor,
            ),
          ),
        ),
        // Select service
        CustomTextFieldWithTitle(
          controller: transactionReportController.selectedServiceController,
          title: 'Service',
          hintText: 'Select service',
          readOnly: true,
          onTap: () async {
            if (transactionReportController.selectedCategoryController.text.trim().isEmpty) {
              errorSnackBar(message: 'Please select category');
            } else {
              ServiceModel selectedService = await Get.toNamed(
                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                arguments: [
                  transactionReportController.serviceList, // list
                  'serviceList', // listType
                ],
              );
              if (selectedService.name != null && selectedService.name!.isNotEmpty) {
                transactionReportController.selectedServiceController.text = selectedService.name!;
                transactionReportController.selectedServiceId.value = selectedService.id!.toString();
              }
            }
          },
          // validator: (value) {
          //   if (transactionReportController.selectedServiceController.text.trim().isEmpty) {
          //     return 'Please select service';
          //   }
          //   return null;
          // },
          suffixIcon: GestureDetector(
            onTap: () async {
              if (transactionReportController.selectedCategoryController.text.trim().isEmpty) {
                errorSnackBar(message: 'Please select category');
              } else {
                ServiceModel selectedService = await Get.toNamed(
                  Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                  arguments: [
                    transactionReportController.serviceList, // list
                    'serviceList', // listType
                  ],
                );
                if (selectedService.name != null && selectedService.name!.isNotEmpty) {
                  transactionReportController.selectedServiceController.text = selectedService.name!;
                  transactionReportController.selectedServiceId.value = selectedService.id!.toString();
                }
              }
            },
            child: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: ColorsForApp.greyColor,
            ),
          ),
        ),
        height(8),
      ],
      enableDrag: false,
      isDismissible: false,
      preventToClose: false,
      isScrollControlled: true,
      customButtons: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CommonButton(
              shadowColor: ColorsForApp.shadowColor,
              onPressed: () {
                Get.back();
              },
              label: 'Cancel',
              border: Border.all(
                color: ColorsForApp.primaryColor,
              ),
              labelColor: ColorsForApp.primaryColor,
              bgColor: ColorsForApp.whiteColor,
            ),
          ),
          width(5.w),
          Expanded(
            child: CommonButton(
              shadowColor: ColorsForApp.shadowColor,
              onPressed: () async {
                if (transactionReportController.selectedCategoryId.value.isNotEmpty || transactionReportController.selectedServiceId.value.isNotEmpty) {
                  await transactionReportController.getTransactionReportApi(pageNumber: 1);
                  Get.back();
                  transactionReportController.isShowClearFiltersButton.value = true;
                } else {
                  errorSnackBar(message: 'Please select atleast one filter');
                }
              },
              label: 'Apply',
              labelColor: ColorsForApp.whiteColor,
              bgColor: ColorsForApp.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Distributor filter bottomSheet
  Future distributorFilterBottomSheet() {
    return customBottomSheet(
      children: [
        // Filter text
        Row(
          children: [
            Icon(
              Icons.filter_alt_rounded,
              color: ColorsForApp.primaryColor,
            ),
            width(5),
            Text(
              'Filter',
              style: TextHelper.size18.copyWith(
                color: ColorsForApp.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Obx(
              () => Visibility(
                visible: transactionReportController.isShowClearFiltersButton.value == true ? true : false,
                child: GestureDetector(
                  onTap: () async {
                    Get.back();
                    transactionReportController.resetAreaDistributorFilterVariable();
                    await transactionReportController.getTransactionReportApi(pageNumber: 1);
                    transactionReportController.isShowClearFiltersButton.value = false;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.7,
                        color: ColorsForApp.greyColor.withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Clear Filter',
                      style: TextHelper.size13.copyWith(
                        fontFamily: mediumGoogleSansFont,
                        letterSpacing: 0.5,
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        height(2.h),
        // // Select user type
        // CustomTextFieldWithTitle(
        //   controller: transactionReportController.selectedUserTypeController,
        //   title: 'User type',
        //   hintText: 'Select user type',
        //   readOnly: true,
        //   onTap: () async {
        //     UserTypeModel selectedUserType = await Get.toNamed(
        //       Routes.SEARCHABLE_LIST_VIEW_SCREEN,
        //       arguments: [
        //         transactionReportController.userTypeList, // list
        //         'userTypeList', // listType
        //       ],
        //     );
        //     if (transactionReportController.selectedUserTypeController.text != selectedUserType.name!) {
        //       transactionReportController.selectedAreaDistributorController.clear();
        //       transactionReportController.selectedAreaDistributorId.value = '';
        //       if (selectedUserType.name != null && selectedUserType.name!.isNotEmpty) {
        //         transactionReportController.selectedUserTypeController.text = selectedUserType.name!;
        //         transactionReportController.selectedUserTypeId.value = selectedUserType.id!.toString();
        //         transactionReportController.selectedUserTypeCode.value = selectedUserType.code!;
        //         await transactionReportController.getUserListVaiUserType(
        //           userTypeId: transactionReportController.selectedUserTypeId.value,
        //           pageNumber: 1,
        //         );
        //       }
        //     }
        //   },
        //   validator: (value) {
        //     if (transactionReportController.selectedUserTypeController.text.trim().isEmpty) {
        //       return 'Please select user type';
        //     }
        //     return null;
        //   },
        //   suffixIcon: GestureDetector(
        //     onTap: () async {
        //       UserTypeModel selectedUserType = await Get.toNamed(
        //         Routes.SEARCHABLE_LIST_VIEW_SCREEN,
        //         arguments: [
        //           transactionReportController.userTypeList, // list
        //           'userTypeList', // listType
        //         ],
        //       );
        //       if (transactionReportController.selectedUserTypeController.text != selectedUserType.name!) {
        //         transactionReportController.selectedAreaDistributorController.clear();
        //         transactionReportController.selectedAreaDistributorId.value = '';
        //         if (selectedUserType.name != null && selectedUserType.name!.isNotEmpty) {
        //           transactionReportController.selectedUserTypeController.text = selectedUserType.name!;
        //           transactionReportController.selectedUserTypeId.value = selectedUserType.id!.toString();
        //           transactionReportController.selectedUserTypeCode.value = selectedUserType.code!;
        //           await transactionReportController.getUserListVaiUserType(
        //             userTypeId: transactionReportController.selectedUserTypeId.value,
        //             pageNumber: 1,
        //           );
        //         }
        //       }
        //     },
        //     child: Icon(
        //       Icons.keyboard_arrow_right_rounded,
        //       color: ColorsForApp.greyColor,
        //     ),
        //   ),
        // ),
        // // Select area distributor
        // Obx(
        //   () => Visibility(
        //     visible: transactionReportController.selectedUserTypeId.value.isNotEmpty && transactionReportController.selectedUserTypeCode.value == 'AD'
        //         ? true
        //         : false,
        //     child: CustomTextFieldWithTitle(
        //       controller: transactionReportController.selectedAreaDistributorController,
        //       title: 'Area distributor',
        //       hintText: 'Select area distributor',
        //       readOnly: true,
        //       onTap: () async {
        //         if (transactionReportController.selectedUserTypeController.text.trim().isEmpty) {
        //           errorSnackBar(message: 'Please select user type');
        //         } else {
        //           UserData selectedUser = await Get.toNamed(
        //             Routes.SEARCHABLE_LIST_VIEW_SCREEN,
        //             arguments: [
        //               transactionReportController.userList, // list
        //               'userListTransaction', // listType
        //             ],
        //           );
        //           if (transactionReportController.selectedAreaDistributorController.text != selectedUser.ownerName!) {
        //             transactionReportController.selectedRetailerController.clear();
        //             transactionReportController.selectedRetailerId.value = '';
        //             if (selectedUser.ownerName != null && selectedUser.ownerName!.isNotEmpty) {
        //               transactionReportController.selectedAreaDistributorController.text = selectedUser.ownerName!;
        //               transactionReportController.selectedAreaDistributorId.value = selectedUser.id!.toString();
        //               await transactionReportController.getChildUserListVaiParent(
        //                 parentId: selectedUser.unqID.toString(),
        //                 pageNumber: 1,
        //               );
        //             }
        //           }
        //         }
        //       },
        //       suffixIcon: GestureDetector(
        //         onTap: () async {
        //           if (transactionReportController.selectedUserTypeController.text.trim().isEmpty) {
        //             errorSnackBar(message: 'Please select user type');
        //           } else {
        //             UserData selectedUser = await Get.toNamed(
        //               Routes.SEARCHABLE_LIST_VIEW_SCREEN,
        //               arguments: [
        //                 transactionReportController.userList, // list
        //                 'userListTransaction', // listType
        //               ],
        //             );
        //             if (transactionReportController.selectedAreaDistributorController.text != selectedUser.ownerName!) {
        //               transactionReportController.selectedRetailerController.clear();
        //               transactionReportController.selectedRetailerId.value = '';
        //               if (selectedUser.ownerName != null && selectedUser.ownerName!.isNotEmpty) {
        //                 transactionReportController.selectedAreaDistributorController.text = selectedUser.ownerName!;
        //                 transactionReportController.selectedAreaDistributorId.value = selectedUser.id!.toString();
        //                 await transactionReportController.getChildUserListVaiParent(
        //                   parentId: selectedUser.unqID.toString(),
        //                   pageNumber: 1,
        //                 );
        //               }
        //             }
        //           }
        //         },
        //         child: Icon(
        //           Icons.keyboard_arrow_right_rounded,
        //           color: ColorsForApp.greyColor,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // // Select retailer
        // Obx(
        //   () => Visibility(
        //     visible:
        //         (transactionReportController.selectedUserTypeId.value.isNotEmpty && transactionReportController.selectedUserTypeCode.value == 'RT') ||
        //                 (transactionReportController.selectedUserTypeId.value.isNotEmpty &&
        //                     transactionReportController.selectedUserTypeCode.value == 'AD' &&
        //                     transactionReportController.selectedAreaDistributorId.value.isNotEmpty)
        //             ? true
        //             : false,
        //     child: CustomTextFieldWithTitle(
        //       controller: transactionReportController.selectedRetailerController,
        //       title: 'Retailer',
        //       hintText: 'Select retailer',
        //       readOnly: true,
        //       onTap: () async {
        //         if (transactionReportController.selectedUserTypeController.text.trim().isEmpty) {
        //           errorSnackBar(message: 'Please select user type');
        //         } else {
        //           UserData selectedUser = await Get.toNamed(
        //             Routes.SEARCHABLE_LIST_VIEW_SCREEN,
        //             arguments: [
        //               (transactionReportController.selectedUserTypeId.value.isNotEmpty &&
        //                       transactionReportController.selectedUserTypeCode.value == 'RT')
        //                   ? transactionReportController.userList
        //                   : transactionReportController.childUserList, // list
        //               'userListTransaction', // listType
        //             ],
        //           );
        //           if (selectedUser.ownerName != null && selectedUser.ownerName!.isNotEmpty) {
        //             transactionReportController.selectedRetailerController.text = selectedUser.ownerName!;
        //             transactionReportController.selectedRetailerId.value = selectedUser.id!.toString();
        //           }
        //         }
        //       },
        //       suffixIcon: GestureDetector(
        //         onTap: () async {
        //           if (transactionReportController.selectedUserTypeController.text.trim().isEmpty) {
        //             errorSnackBar(message: 'Please select user type');
        //           } else {
        //             UserData selectedUser = await Get.toNamed(
        //               Routes.SEARCHABLE_LIST_VIEW_SCREEN,
        //               arguments: [
        //                 transactionReportController.userList, // list
        //                 'userListTransaction', // listType
        //               ],
        //             );
        //             if (selectedUser.ownerName != null && selectedUser.ownerName!.isNotEmpty) {
        //               transactionReportController.selectedRetailerController.text = selectedUser.ownerName!;
        //               transactionReportController.selectedRetailerId.value = selectedUser.id!.toString();
        //             }
        //           }
        //         },
        //         child: Icon(
        //           Icons.keyboard_arrow_right_rounded,
        //           color: ColorsForApp.greyColor,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // Seach by username
        CustomTextFieldWithTitle(
          controller: transactionReportController.searchUsernameController,
          title: 'Username',
          hintText: 'Search by username',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        ),
        // Select category
        CustomTextFieldWithTitle(
          controller: transactionReportController.selectedCategoryController,
          title: 'Category',
          hintText: 'Select category',
          readOnly: true,
          onTap: () async {
            CategoryModel selectedCategory = await Get.toNamed(
              Routes.SEARCHABLE_LIST_VIEW_SCREEN,
              arguments: [
                transactionReportController.categoryList, // list
                'categoryList', // listType
              ],
            );
            if (transactionReportController.selectedCategoryController.text != selectedCategory.name!) {
              transactionReportController.selectedServiceController.clear();
              transactionReportController.selectedServiceId.value = '';
              if (selectedCategory.name != null && selectedCategory.name!.isNotEmpty) {
                transactionReportController.selectedCategoryController.text = selectedCategory.name!;
                transactionReportController.selectedCategoryId.value = selectedCategory.id!.toString();
                await transactionReportController.getServiceList(
                  categoryId: transactionReportController.selectedCategoryId.value,
                );
              }
            }
          },
          validator: (value) {
            if (transactionReportController.selectedCategoryController.text.trim().isEmpty) {
              return 'Please select category';
            }
            return null;
          },
          suffixIcon: GestureDetector(
            onTap: () async {
              CategoryModel selectedCategory = await Get.toNamed(
                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                arguments: [
                  transactionReportController.categoryList, // list
                  'categoryList', // listType
                ],
              );
              if (transactionReportController.selectedCategoryController.text != selectedCategory.name!) {
                transactionReportController.selectedServiceController.clear();
                transactionReportController.selectedServiceId.value = '';
                if (selectedCategory.name != null && selectedCategory.name!.isNotEmpty) {
                  transactionReportController.selectedCategoryController.text = selectedCategory.name!;
                  transactionReportController.selectedCategoryId.value = selectedCategory.id!.toString();
                  await transactionReportController.getServiceList(
                    categoryId: transactionReportController.selectedCategoryId.value,
                  );
                }
              }
            },
            child: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: ColorsForApp.greyColor,
            ),
          ),
        ),
        // Select service
        CustomTextFieldWithTitle(
          controller: transactionReportController.selectedServiceController,
          title: 'Service',
          hintText: 'Select service',
          readOnly: true,
          onTap: () async {
            if (transactionReportController.selectedCategoryController.text.trim().isEmpty) {
              errorSnackBar(message: 'Please select category');
            } else {
              ServiceModel selectedService = await Get.toNamed(
                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                arguments: [
                  transactionReportController.serviceList, // list
                  'serviceList', // listType
                ],
              );
              if (selectedService.name != null && selectedService.name!.isNotEmpty) {
                transactionReportController.selectedServiceController.text = selectedService.name!;
                transactionReportController.selectedServiceId.value = selectedService.id!.toString();
              }
            }
          },
          validator: (value) {
            if (transactionReportController.selectedServiceController.text.trim().isEmpty) {
              return 'Please select service';
            }
            return null;
          },
          suffixIcon: GestureDetector(
            onTap: () async {
              if (transactionReportController.selectedCategoryController.text.trim().isEmpty) {
                errorSnackBar(message: 'Please select category');
              } else {
                ServiceModel selectedService = await Get.toNamed(
                  Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                  arguments: [
                    transactionReportController.serviceList, // list
                    'serviceList', // listType
                  ],
                );
                if (selectedService.name != null && selectedService.name!.isNotEmpty) {
                  transactionReportController.selectedServiceController.text = selectedService.name!;
                  transactionReportController.selectedServiceId.value = selectedService.id!.toString();
                }
              }
            },
            child: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: ColorsForApp.greyColor,
            ),
          ),
        ),
        height(8),
      ],
      enableDrag: false,
      isDismissible: false,
      preventToClose: false,
      isScrollControlled: true,
      customButtons: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CommonButton(
              shadowColor: ColorsForApp.shadowColor,
              onPressed: () {
                Get.back();
              },
              label: 'Cancel',
              border: Border.all(
                color: ColorsForApp.primaryColor,
              ),
              labelColor: ColorsForApp.primaryColor,
              bgColor: ColorsForApp.whiteColor,
            ),
          ),
          width(5.w),
          Expanded(
            child: CommonButton(
              shadowColor: ColorsForApp.shadowColor,
              onPressed: () async {
                if (transactionReportController.searchUsernameController.text.isNotEmpty || transactionReportController.selectedCategoryId.value.isNotEmpty || transactionReportController.selectedServiceId.value.isNotEmpty) {
                  await transactionReportController.getTransactionReportApi(pageNumber: 1);
                  transactionReportController.isShowClearFiltersButton.value = true;
                  Get.back();
                } else {
                  errorSnackBar(message: 'Please select filter first');
                }
              },
              label: 'Apply',
              labelColor: ColorsForApp.whiteColor,
              bgColor: ColorsForApp.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

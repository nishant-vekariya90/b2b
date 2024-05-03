import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../controller/retailer/offline_token_controller.dart';
import '../../model/product/order_report_model.dart';

class OfflineTokenReportScreen extends StatefulWidget {
  const OfflineTokenReportScreen({super.key});

  @override
  State<OfflineTokenReportScreen> createState() => _OfflineTokenReportScreenState();
}

class _OfflineTokenReportScreenState extends State<OfflineTokenReportScreen> {
  final OfflineTokenController offlineTokenController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    offlineTokenController.isOfflineTokenPurchaseReportListLoading.value = true;
    await offlineTokenController.getPurchaseTokenReport(pageNumber: 1, isLoaderShow: false);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && offlineTokenController.tokenReportCurrentPage.value < offlineTokenController.tokenReportTotalPages.value) {
        offlineTokenController.tokenReportCurrentPage.value++;
        await offlineTokenController.getPurchaseTokenReport(
          pageNumber: offlineTokenController.tokenReportCurrentPage.value,
          isLoaderShow: false,
        );
      }
    });
  }

  @override
  void dispose() {
    offlineTokenController.tokenReportCurrentPage.value = 1;
    offlineTokenController.tokenReportTotalPages.value = 1;
    offlineTokenController.tokenReportHasNext.value = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Purchase Token Report',
      isShowLeadingIcon: true,
      mainBody: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height(2.h),
            Obx(
              () => Expanded(
                child: offlineTokenController.isOfflineTokenPurchaseReportListLoading.value == true
                    ? purchaseTokenReportDataShimmerWidget()
                    : offlineTokenController.purchaseOrderReportList.isEmpty
                        ? notFoundText(text: 'No token report found')
                        : purchaseTokenReportDataWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Purchase token report data widget
  Widget purchaseTokenReportDataWidget() {
    return RefreshIndicator(
      color: ColorsForApp.primaryColor,
      onRefresh: () async {
        isLoading.value = true;
        await Future.delayed(const Duration(seconds: 1), () async {
          await offlineTokenController.getPurchaseTokenReport(pageNumber: 1, isLoaderShow: false);
        });
        isLoading.value = false;
      },
      child: ListView.separated(
        controller: scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.zero,
        itemCount: offlineTokenController.purchaseOrderReportList.length,
        itemBuilder: (context, index) {
          if (index == offlineTokenController.purchaseOrderReportList.length - 1 && offlineTokenController.tokenReportHasNext.value) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorsForApp.primaryColor,
              ),
            );
          } else {
            OrderListData orderReportData = offlineTokenController.purchaseOrderReportList[index];
            return customCard(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    height(1.5.h),
                    // Order id | Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Order Id
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
                                  orderReportData.orderID != null && orderReportData.orderID!.isNotEmpty ? orderReportData.orderID!.toString() : '-',
                                  textAlign: TextAlign.start,
                                  style: TextHelper.size13.copyWith(
                                    color: ColorsForApp.lightBlackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        width(2.w),
                        // Amount
                        Text(
                          orderReportData.total != null ? '₹ ${orderReportData.total!.toStringAsFixed(2)}' : '₹ 0.00',
                          style: TextHelper.size14.copyWith(
                            fontFamily: boldGoogleSansFont,
                            color: orderReportData.status != null && orderReportData.status == 3
                                ? ColorsForApp.successColor
                                : orderReportData.status != null && orderReportData.status == 0
                                    ? ColorsForApp.errorColor
                                    : ColorsForApp.pendingColor,
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
                    // Status
                    customKeyValueText(
                      key: 'Status : ',
                      value: orderReportData.status != null ? offlineTokenController.orderReportStatus(orderReportData.status!) : '-',
                    ),
                    // Quantity
                    customKeyValueText(
                      key: 'Quantity : ',
                      value: orderReportData.quantity != null ? orderReportData.quantity!.toString() : '-',
                    ),
                    // Product Name
                    customKeyValueText(
                      key: 'Product Name : ',
                      value: orderReportData.productName != null && orderReportData.productName!.isNotEmpty ? orderReportData.productName!.toString() : '-',
                    ),
                    // Payment Method
                    customKeyValueText(
                      key: 'Payment Method : ',
                      value: orderReportData.paymentMethod != null && orderReportData.paymentMethod!.isNotEmpty ? orderReportData.paymentMethod!.toString() : '-',
                    ),
                    // Remarks
                    Visibility(
                      visible: orderReportData.status != null && (orderReportData.status == 0 || orderReportData.status == 3) ? true : false,
                      child: customKeyValueText(
                        key: 'Remarks : ',
                        value: orderReportData.remark != null && orderReportData.remark!.isNotEmpty ? orderReportData.remark!.toString() : '-',
                      ),
                    ),
                    // Purchased On
                    customKeyValueText(
                      key: 'Purchased On : ',
                      value: orderReportData.createdOn != null && orderReportData.createdOn!.isNotEmpty ? offlineTokenController.formatDateTime(orderReportData.createdOn!) : '-',
                    ),
                    height(1.h),
                  ],
                ),
              ),
            );
          }
        },
        separatorBuilder: (context, index) {
          return height(0.5.h);
        },
      ),
    );
  }

  // Purchase token report data shimmer widget
  Widget purchaseTokenReportDataShimmerWidget() {
    return ListView.separated(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 5,
      itemBuilder: (context, index) {
        return customCard(
          child: Shimmer.fromColors(
            baseColor: ColorsForApp.shimmerBaseColor,
            highlightColor: ColorsForApp.shimmerHighlightColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(1.5.h),
                      // Order id | Amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Order id
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 2.h,
                                width: 10.w,
                                decoration: BoxDecoration(
                                  color: ColorsForApp.greyColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              width(10),
                              Container(
                                height: 2.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                  color: ColorsForApp.greyColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                          // Amount
                          Container(
                            height: 1.5.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
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
                      // Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1.5.h,
                            width: 15.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          width(10),
                          Container(
                            height: 1.5.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      height(0.8.h),
                      // Quantity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1.5.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          width(10),
                          Container(
                            height: 1.5.h,
                            width: 15.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      height(0.8.h),
                      // Product Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1.5.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          width(10),
                          Container(
                            height: 1.5.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      height(0.8.h),
                      // Payment Method
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1.5.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          width(10),
                          Container(
                            height: 1.5.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      height(0.8.h),
                      // Purchased On
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1.5.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          width(10),
                          Container(
                            height: 1.5.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      height(0.8.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return height(0.5.h);
      },
    );
  }
}

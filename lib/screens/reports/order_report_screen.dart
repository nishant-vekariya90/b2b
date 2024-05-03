import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../controller/report_controller.dart';
import '../../model/category_for_tpin_model.dart';
import '../../model/product/order_report_model.dart';
import '../../utils/string_constants.dart';
import '../../widgets/text_field_with_title.dart';

class OrderReportScreen extends StatefulWidget {
  const OrderReportScreen({super.key});

  @override
  State<OrderReportScreen> createState() => _OrderReportScreenState();
}

class _OrderReportScreenState extends State<OrderReportScreen> {
  ReportController reportController = Get.find();
  ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> orderUpdateKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    await reportController.getOrderReportApi(pageNumber: reportController.orderCurrentPage.value);
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && reportController.orderCurrentPage.value < reportController.orderTotalPages.value) {
        reportController.orderCurrentPage.value++;
        await reportController.getOrderReportApi(
          pageNumber: reportController.orderCurrentPage.value,
          isLoaderShow: false,
        );
      }
    });
    CategoryForTpinModel categoryForTpinModel = categoryForTpinList.firstWhere((element) => element.code != null && element.code!.toLowerCase() == 'product');
    reportController.isShowTpinField.value = categoryForTpinModel.isTpin!;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Order Report',
      isShowLeadingIcon: true,
      mainBody: Column(
        children: [
          Obx(
            () => Expanded(
              child: reportController.leadReportList.isEmpty
                  ? notFoundText(text: 'No data found')
                  : RefreshIndicator(
                      color: ColorsForApp.primaryColor,
                      onRefresh: () async {
                        isLoading.value = true;
                        await Future.delayed(const Duration(seconds: 1), () async {
                          await reportController.getOrderReportApi(pageNumber: 1, isLoaderShow: false);
                        });
                        isLoading.value = false;
                      },
                      child: ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                        itemCount: reportController.leadReportList.length,
                        itemBuilder: (context, index) {
                          if (index == reportController.orderReportList.length - 1 && reportController.orderHasNext.value) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorsForApp.primaryColor,
                                ),
                              ),
                            );
                          } else {
                            OrderListData orderReportData = reportController.orderReportList[index];
                            return customCard(
                              child: InkWell(
                                onTap: () {
                                  for (var element in reportController.orderReportList) {
                                    if (element.isShowMoreDetails.value == true) {
                                      element.isShowMoreDetails.value = false;
                                    }
                                  }
                                  orderReportData.isShowMoreDetails.value = !orderReportData.isShowMoreDetails.value;
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      height(1.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Name : ${orderReportData.name == null || orderReportData.name == '' ? '-' : orderReportData.name!}",
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                                color: ColorsForApp.lightBlackColor,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Created On : ${orderReportData.createdOn == null || orderReportData.createdOn == '' ? '-' : reportController.formatDateTime(orderReportData.createdOn!)}",
                                            style: TextHelper.size11.copyWith(
                                              fontFamily: mediumGoogleSansFont,
                                              color: ColorsForApp.greyColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      height(0.8.h),
                                      customKeyValueText(key: "Product Name:", value: orderReportData.productName == null || orderReportData.productName == '' ? '-' : orderReportData.productName.toString()),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "Oty : ${orderReportData.quantity == null ? '-' : orderReportData.quantity.toString()}",
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                                color: ColorsForApp.lightBlackColor,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Amount : ₹ ${orderReportData.total == null ? '-' : orderReportData.total!.toStringAsFixed(2)}",
                                            style: TextHelper.size14.copyWith(
                                              fontFamily: mediumGoogleSansFont,
                                              color: ColorsForApp.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      height(0.8.h),
                                      Obx(() => Visibility(visible: orderReportData.isShowMoreDetails.value, child: orderDetailsUI(context, orderReportData))),
                                      height(1.5.h),
                                      Divider(
                                        height: 0,
                                        thickness: 0.2,
                                        color: ColorsForApp.greyColor,
                                      ),
                                      height(1.5.h),
                                      // Order cancel button
                                      Visibility(
                                        visible: orderReportData.status == 1 || orderReportData.status == 2 ? true : false,
                                        child: InkWell(
                                          onTap: () {
                                            updateOrderStatusBottomSheet(context: context, unqId: orderReportData.unqId!, orderId: orderReportData.orderID!);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 0.7.h),
                                            decoration: BoxDecoration(
                                              color: ColorsForApp.orangeColor,
                                              borderRadius: const BorderRadius.only(
                                                bottomLeft: Radius.circular(16),
                                                bottomRight: Radius.circular(16),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.cancel,
                                                  size: 16,
                                                  color: ColorsForApp.whiteColor,
                                                ),
                                                width(5),
                                                Text(
                                                  'Cancel Order',
                                                  style: TextHelper.size12.copyWith(
                                                    fontFamily: mediumGoogleSansFont,
                                                    color: ColorsForApp.whiteColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      // order Dispatched
                                      Visibility(
                                        visible: orderReportData.status == 3 ? true : false,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 0.7.h),
                                          decoration: BoxDecoration(
                                            color: ColorsForApp.primaryColor,
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(16),
                                              bottomRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Delivered',
                                                style: TextHelper.size12.copyWith(
                                                  fontFamily: mediumGoogleSansFont,
                                                  color: ColorsForApp.whiteColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // order Cancelled
                                      Visibility(
                                        visible: orderReportData.status == 0 ? true : false,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 0.7.h),
                                          decoration: BoxDecoration(
                                            color: ColorsForApp.lightGreyColor,
                                            borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(16),
                                              bottomRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Status:',
                                                style: TextHelper.size12.copyWith(
                                                  fontFamily: mediumGoogleSansFont,
                                                  color: ColorsForApp.greyColor,
                                                ),
                                              ),
                                              width(5),
                                              Text(
                                                'Cancelled order',
                                                style: TextHelper.size12.copyWith(
                                                  fontFamily: mediumGoogleSansFont,
                                                  color: ColorsForApp.greyColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
    );
  }

  Widget orderDetailsUI(BuildContext context, OrderListData orderReportData) {
    return Column(
      children: [
        customKeyValueText(key: "Email:", value: orderReportData.email == null || orderReportData.email == '' ? '-' : orderReportData.email!),
        customKeyValueText(key: "Mobile:", value: orderReportData.contact == null || orderReportData.contact == '' ? '-' : orderReportData.contact!),
        customKeyValueText(key: "TxnId:", value: orderReportData.orderID == null ? '-' : orderReportData.orderID.toString()),
        customKeyValueText(key: "Tax:", value: orderReportData.tax == null ? '-' : orderReportData.tax.toString()),
        customKeyValueText(key: "Product details:", value: orderReportData.itemDesc == null || orderReportData.itemDesc == '' ? '-' : orderReportData.productName.toString()),
        customKeyValueText(key: "Address:", value: orderReportData.address == null || orderReportData.address == '' ? '-' : orderReportData.address.toString()),
        customKeyValueText(key: "Payment Method:", value: orderReportData.paymentMethod == null || orderReportData.paymentMethod == '' ? '-' : orderReportData.paymentMethod.toString()),
        customKeyValueText(key: "Delivery Date:", value: orderReportData.sellerName == null || orderReportData.deliveryBy == '' ? '-' : orderReportData.deliveryBy.toString()),
      ],
    );
  }

  updateOrderStatusBottomSheet({required BuildContext context, required String unqId, required String orderId}) {
    return Get.bottomSheet(
      isScrollControlled: true,
      Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Form(
          key: orderUpdateKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 2.5,
                  width: 100.w * 0.3,
                  decoration: BoxDecoration(
                    color: ColorsForApp.greyColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              height(5),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Update order status',
                  style: TextHelper.size18.copyWith(
                    fontFamily: boldGoogleSansFont,
                    color: ColorsForApp.primaryColor,
                  ),
                ),
              ),
              height(15),
              CustomTextFieldWithTitle(
                controller: reportController.commentController,
                title: 'Comment',
                hintText: 'Enter comment',
                isCompulsory: true,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                suffixIcon: Icon(
                  Icons.comment,
                  size: 18,
                  color: ColorsForApp.secondaryColor,
                ),
                validator: (value) {
                  if (reportController.commentController.text.trim().isEmpty) {
                    return 'Please enter comment';
                  } else if (reportController.commentController.text.length < 3) {
                    return 'Please enter valid comment';
                  }
                  return null;
                },
              ),
              height(5),
              // TPIN
              Visibility(
                visible: reportController.isShowTpinField.value,
                child: Obx(
                  () => CustomTextFieldWithTitle(
                    controller: reportController.tPinTxtController,
                    title: 'TPIN',
                    hintText: 'Enter TPIN',
                    maxLength: 4,
                    isCompulsory: true,
                    obscureText: reportController.isShowTpin.value,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    suffixIcon: IconButton(
                      icon: Icon(
                        reportController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                        size: 18,
                        color: ColorsForApp.secondaryColor,
                      ),
                      onPressed: () {
                        reportController.isShowTpin.value = !reportController.isShowTpin.value;
                      },
                    ),
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (reportController.tPinTxtController.text.trim().isEmpty) {
                        return 'Please enter TPIN';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              height(15),
              CommonButton(
                label: 'Update',
                onPressed: () async {
                  Get.back();
                  if (orderUpdateKey.currentState!.validate()) {
                    await reportController.updateOrderStatusApi(unqId: unqId, orderId: orderId);
                    await reportController.getOrderReportApi(pageNumber: reportController.orderCurrentPage.value);
                    reportController.commentController.clear();
                    reportController.tPinTxtController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

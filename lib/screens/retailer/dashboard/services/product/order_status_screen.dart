import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/product_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/transaction_process_status_screen.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key});

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  ProductController productController = Get.find();

  @override
  initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    int result = -1;
    try {
      if (isInternetAvailable.value) {
        result = await callWithTimeout(() async {
          return await productController.orderPlace(isLoaderShow: false);
        });
      } else {
        result = -1;
        errorSnackBar(message: noInternetMsg);
      }
    } catch (e) {
      result = -1;
      errorSnackBar(message: apiTimeOutMsg);
    } finally {
      if (result == 0) {
        Future.delayed(const Duration(seconds: 1), () {
          productController.orderStatus.value = result;
        });
      } else if (result == 1) {
        Future.delayed(const Duration(seconds: 1), () {
          productController.orderStatus.value = result;
          playSuccessSound();
        });
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          productController.orderStatus.value = result;
        });
      }
    }
  }

  Future<int> callWithTimeout(Future<int> Function() apiCall) async {
    try {
      return await apiCall().timeout(const Duration(seconds: 59));
    } on TimeoutException {
      return 3;
    } catch (e) {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (productController.orderStatus.value >= 0) {
          productController.resetProductDetailsVariables();
          // pop route from stack when navigation from product category
          if (productController.isRouteFromBestSeller.value == false) {
            Get.back(); // current page
            Get.back(); // address page
            Get.back(); // product details page
            Get.back(); // all product page
          } // pop route from stack when navigation from best seller's buy now
          else {
            Get.back(); // current page
            Get.back(); // address page
            Get.back(); // product details page
          }
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        body: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: productController.orderStatus.value == 0
                ? BuildFailedStatus()
                : productController.orderStatus.value == 1
                    ? BuildSuccessStatus()
                    : const TransactionProcessStatusScreen(),
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                children: <Widget>[
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}

class BuildFailedStatus extends StatelessWidget {
  final String failedHeroTag = 'failedHero';
  final ProductController productController = Get.find();
  BuildFailedStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<int>(0),
      child: Hero(
        tag: failedHeroTag,
        child: Container(
          height: 100.h,
          width: 100.w,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                Assets.imagesFailedTransactionBg,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            Assets.animationsFailedTransaction,
                            height: 18.h,
                          ),
                          height(1.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '₹ ${productController.totalPrice.value}.00',
                                  style: TextHelper.size18.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(1.h),
                                Text(
                                  'Mobile number  ${productController.mobileTxtController.text}',
                                  style: TextHelper.size17.copyWith(
                                    fontFamily: boldGoogleSansFont,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(0.5.h),
                                Text(
                                  DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
                                  style: TextHelper.size14.copyWith(
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(1.h),
                                Text(
                                  productController.orderPlacedModel.value.message != null && productController.orderPlacedModel.value.message!.isNotEmpty
                                      ? productController.orderPlacedModel.value.message!
                                      : '',
                                  textAlign: TextAlign.center,
                                  style: TextHelper.size15.copyWith(
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                                height(7.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 6.h,
                        child: CommonButton(
                          onPressed: () {
                            productController.resetProductDetailsVariables();
                            // pop route from stack when navigation from product category
                            if (productController.isRouteFromBestSeller.value == false) {
                              Get.back(); // current page
                              Get.back(); // address page
                              Get.back(); // product details page
                              Get.back(); // all product page
                            } // pop route from stack when navigation from best seller's buy now
                            else {
                              Get.back(); // current page
                              Get.back(); // address page
                              Get.back(); // product details page
                            }
                          },
                          label: 'Done',
                          width: 92.w,
                          bgColor: ColorsForApp.whiteColor,
                          labelColor: ColorsForApp.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BuildSuccessStatus extends StatelessWidget {
  final String successHeroTag = 'successHero';
  final ProductController productController = Get.find();
  BuildSuccessStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsForApp.creamColor,
      body: Container(
        key: const ValueKey<int>(1),
        height: 100.h,
        width: 100.w,
        alignment: Alignment.center,
        color: const Color(0xFFEBEBEB),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100.w,
                        height: 25.h,
                        child: SvgPicture.asset(Assets.imagesBags),
                      ),
                      height(3.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '₹ ${productController.totalPrice.value}.00',
                              style: TextHelper.size18.copyWith(
                                fontFamily: boldGoogleSansFont,
                                color: ColorsForApp.primaryColor,
                              ),
                            ),
                            height(1.h),
                            Text(
                              'Mobile number  ${productController.mobileTxtController.text}',
                              style: TextHelper.size17.copyWith(
                                fontFamily: boldGoogleSansFont,
                                color: ColorsForApp.primaryColor,
                              ),
                            ),
                            height(0.5.h),
                            Text(
                              DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
                              style: TextHelper.size14.copyWith(
                                color: ColorsForApp.primaryColor,
                              ),
                            ),
                            height(1.h),
                            Text(
                              productController.orderPlacedModel.value.message != null && productController.orderPlacedModel.value.message!.isNotEmpty
                                  ? productController.orderPlacedModel.value.message!
                                  : '',
                              textAlign: TextAlign.center,
                              style: TextHelper.size15.copyWith(
                                color: ColorsForApp.primaryColor,
                              ),
                            ),
                            height(3.h),
                            Text(
                              "Your order will be delivered soon.\n Thank you for choosing our app 🙏.",
                              style: TextHelper.size15.copyWith(
                                height: 1.3,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Lottie.asset(
              Assets.animationsSuccessConfetti,
              height: 100.h,
              width: 100.w,
              alignment: Alignment.center,
              repeat: false,
              fit: BoxFit.fitHeight,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        color: const Color(0xFFEBEBEB),
        child: CommonButton(
          onPressed: () {
            productController.resetProductDetailsVariables();
            // pop route from stack when navigation from product category
            if (productController.isRouteFromBestSeller.value == false) {
              Get.back(); // current page
              Get.back(); // address page
              Get.back(); // product details page
              Get.back(); // all product page
            } // pop route from stack when navigation from best seller's buy now
            else {
              Get.back(); // current page
              Get.back(); // address page
              Get.back(); // product details page
            }
          },
          label: 'Continue shopping',
          border: Border.all(color: ColorsForApp.primaryColor),
          bgColor: ColorsForApp.primaryColor,
          labelColor: ColorsForApp.whiteColor,
        ),
      ),
    );
  }
}

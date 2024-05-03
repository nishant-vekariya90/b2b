import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/bus_booking_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/network_image.dart';
import '../../../../../widgets/transaction_process_status_screen.dart';

class BusProcessStatusScreen extends StatefulWidget {
  const BusProcessStatusScreen({super.key});

  @override
  State<BusProcessStatusScreen> createState() =>
      _TransactionProcessStatusScreenState();
}

class _TransactionProcessStatusScreenState extends State<BusProcessStatusScreen>
    with SingleTickerProviderStateMixin {
  final BusBookingController busBookingController = Get.find();

  @override
  initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    int result = -1;
    busBookingController.busBookingStatus.value = (-1);
    try {
      if (isInternetAvailable.value) {
        busBookingController.busBookingPassenger();
        //successSnackBar(message: 'Booking functionality is under development.');
        result = await callWithTimeout(() async {
          return await busBookingController.busBookApi(isLoaderShow: false);
          //return 1;
        });
      } else {
        result = -1;
        errorSnackBar(message: noInternetMsg);
      }
    } catch (e) {
      debugPrint(e.toString());
      result = -1;
      errorSnackBar(message: apiTimeOutMsg);
    } finally {
      if (result == 0) {
        Future.delayed(const Duration(seconds: 1), () {
          busBookingController.busBookingStatus.value = result;
        });
      } else if (result == 1) {
        Future.delayed(const Duration(seconds: 1), () {
          busBookingController.busBookingStatus.value = result;
          playSuccessSound();
        });
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          busBookingController.busBookingStatus.value = result;
        });
      }
    }
  }

  Future<int> callWithTimeout(Future<int> Function() apiCall) async {
    try {
      return await apiCall().timeout(const Duration(minutes: 10));
    } on TimeoutException {
      return 3;
    } catch (e) {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: busBookingController.busBookingStatus.value == 0
                ? BuildFailedStatus()
                : busBookingController.busBookingStatus.value == 1
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
  final BusBookingController busBookingController = Get.find();

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
                        busFailedWidget(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget busFailedWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${busBookingController.busBookModel.value.message}',
            textAlign: TextAlign.center,
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
            '',
            textAlign: TextAlign.center,
            style: TextHelper.size15.copyWith(
              color: ColorsForApp.whiteColor,
            ),
          ),
          height(7.h),
        ],
      ),
    );
  }
}


class BuildSuccessStatus extends StatelessWidget {
  final String successHeroTag = 'successHero';
  final BusBookingController busBookingController = Get.find();

  BuildSuccessStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (isPop){
        if(isPop){
          if (isPop == true) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              busBookingController.resetBusVariables();
              Get.offNamedUntil(Routes.RETAILER_DASHBOARD_SCREEN, (route) => true);
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor: ColorsForApp.primaryColor,
        body: Container(
          key: const ValueKey<int>(1),
          decoration: BoxDecoration(
            color: ColorsForApp.primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Hero(
            tag: successHeroTag,
            child: Container(
              height: 100.h,
              width: 100.w,
              alignment: Alignment.center,
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
                            Lottie.asset(
                              Assets.animationsSuccessTransaction,
                              height: 20.h,
                              fit: BoxFit.cover,
                            ),
                            height(1.h),
                            busSuccessDetailsWidget(),
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
          ),
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 5.h),
          color: ColorsForApp.primaryColor,
          child:
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonButton(
                onPressed: () {
                  Get.toNamed(
                    Routes.RECEIPT_SCREEN,
                    arguments: [
                      busBookingController.busBookModel.value.orderId.toString(), // Order id
                      0,
                      'BusReceipt', // Design for flight
                    ],
                  );

                },
                label: 'Download ticket',
                style: TextHelper.size16.copyWith(
                  fontFamily: mediumNunitoFont,
                  color: ColorsForApp.whiteColor,
                ),
                border: Border.all(
                  color: ColorsForApp.whiteColor,
                ),
                bgColor: ColorsForApp.flightOrangeColor,
              ),
              height(2.h),
              CommonButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    busBookingController.resetBusVariables();
                    Get.offNamedUntil(Routes.RETAILER_DASHBOARD_SCREEN, (route) => true);
                  });
                },
                label: 'Book another ticket',
                style: TextHelper.size16.copyWith(
                  fontFamily: mediumNunitoFont,
                  color: ColorsForApp.blackColor,
                ),
                border: Border.all(
                  color: ColorsForApp.whiteColor,
                ),
                bgColor: ColorsForApp.whiteColor,
              ),
            ],
          ),

        ),
      ),
    );
  }



  Widget busSuccessDetailsWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Ticket No: ${busBookingController.busBookModel.value.ticketNo}',
            style: TextHelper.size14.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.whiteColor,
            ),
          ),
          Text(
            'PNR: ${busBookingController.busBookModel.value.pnr}',
            textAlign: TextAlign.center,
            style: TextHelper.size14.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.whiteColor,
            ),
          ),
          Text(
            'Order id: ${busBookingController.busBookModel.value.orderId}',
            textAlign: TextAlign.center,
            style: TextHelper.size14.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.whiteColor,
            ),
          ),
          height(0.5.h),
          Text(
            DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
            textAlign: TextAlign.center,
            style: TextHelper.size14.copyWith(
              color: ColorsForApp.whiteColor,
            ),
          ),
          height(1.h),
          Text(
            'Your ticket has been successfully booked. Thank you for choosing us. Have a pleasant journey! 😊',
            textAlign: TextAlign.center,
            style: TextHelper.size15.copyWith(
                color: ColorsForApp.whiteColor, fontFamily: boldGoogleSansFont),
          ),
          SizedBox(
            width: 100.w,
            child: const Opacity(
              opacity: 0.5,
              child: ShowNetworkImage(
                networkUrl: Assets.imagesTicketDetailBg,
                isAssetImage: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}

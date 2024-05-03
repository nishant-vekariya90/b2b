import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/flight_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/network_image.dart';
import '../../../../../widgets/transaction_process_status_screen.dart';

class FlightProcessStatusScreen extends StatefulWidget {
  const FlightProcessStatusScreen({super.key});

  @override
  State<FlightProcessStatusScreen> createState() => _TransactionProcessStatusScreenState();
}

class _TransactionProcessStatusScreenState extends State<FlightProcessStatusScreen> with SingleTickerProviderStateMixin {
  final FlightController flightController = Get.find();

  @override
  initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    int result = -1;
    try {
      if (isInternetAvailable.value) {
        // check journyType & call api according type
        if (flightController.searchedTripType.value == TripType.RETURN_DOM) {
          flightController.onwardBookingPassenger();
          flightController.returnBookingPassenger();
          result = await callWithTimeout(() async {
            return await flightController.domReturnFlightBook(isLoaderShow: false);
          });
        } else {
          flightController.onwardBookingPassenger();
          result = await callWithTimeout(() async {
            return await flightController.flightBookApi(isLoaderShow: false);
          });
        }
      } else {
        result = 0;
        errorSnackBar(message: noInternetMsg);
      }
    } catch (e) {
      result = 0;
    } finally {
      if (result == 0) {
        Future.delayed(const Duration(seconds: 1), () {
          flightController.flightBookingStatus.value = result;
        });
      } else if (result == 1) {
        Future.delayed(const Duration(seconds: 1), () {
          flightController.flightBookingStatus.value = result;
          playSuccessSound();
        });
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          flightController.flightBookingStatus.value = result;
        });
      }
    }
  }

  Future<int> callWithTimeout(Future<int> Function() apiCall) async {
    try {
      return await apiCall().timeout(const Duration(seconds: 100));
    } on TimeoutException {
      return 3;
    } catch (e) {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: flightController.flightBookingStatus.value == 0
                ? BuildFailedStatus()
                : flightController.flightBookingStatus.value == 1
                    ? BuildSuccessStatus()
                    : flightController.flightBookingStatus.value == 3
                        ? BuildTimeOutStatus()
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
  final FlightController flightController = Get.find();
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
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Assets.imagesFlightFormBgImage,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: SizedBox(
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
                      Assets.animationsFlightBookingFaildAnimation,
                      height: 18.h,
                    ),
                    height(1.h),
                    Obx(
                      () => flightController.searchedTripType.value == TripType.RETURN_DOM ? returnFlightFailedWidegt() : onewayFlightFailedWidegt(),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 6.h,
                  child: CommonButton(
                    onPressed: () {
                      flightController.tPinTxtController.clear();
                      Get.back();
                    },
                    width: 92.w,
                    label: 'Try Again',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget onewayFlightFailedWidegt() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Mobile Number: ${flightController.mobileTextController.text}',
            style: TextHelper.size17.copyWith(
              fontFamily: boldNunitoFont,
              color: ColorsForApp.lightBlackColor,
            ),
          ),
          height(0.5.h),
          Text(
            DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
            style: TextHelper.size14.copyWith(
              fontFamily: regularNunitoFont,
              color: ColorsForApp.lightBlackColor,
            ),
          ),
          height(1.h),
          Text(
            flightController.domFlightBookModel.value.message != null && flightController.domFlightBookModel.value.message!.isNotEmpty ? flightController.domFlightBookModel.value.message! : '',
            textAlign: TextAlign.center,
            style: TextHelper.size15.copyWith(
              fontFamily: mediumNunitoFont,
              color: ColorsForApp.blackColor,
            ),
          ),
          height(7.h),
        ],
      ),
    );
  }

  Widget returnFlightFailedWidegt() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Mobile Number: ${flightController.mobileTextController.text}',
            style: TextHelper.size17.copyWith(
              fontFamily: boldNunitoFont,
              color: ColorsForApp.blackColor,
            ),
          ),
          height(0.5.h),
          Text(
            DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
            style: TextHelper.size14.copyWith(
              fontFamily: regularNunitoFont,
              color: ColorsForApp.blackColor,
            ),
          ),
          height(1.h),
          Text(
            flightController.domReturnFlightBookModel.value.message != null && flightController.domReturnFlightBookModel.value.message!.isNotEmpty ? flightController.domReturnFlightBookModel.value.message! : '',
            textAlign: TextAlign.center,
            style: TextHelper.size15.copyWith(
              fontFamily: mediumNunitoFont,
              color: ColorsForApp.blackColor,
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
  final FlightController flightController = Get.find();
  BuildSuccessStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // onPopInvoked: (isPop) {
      //   if (isPop == true) {
      //     WidgetsBinding.instance.addPostFrameCallback((_) {
      //       if (flightController.isSeatMealBaggageCheckbox.value == true) {
      //         Get.back(); // current page
      //         Get.back(); // review trip
      //         Get.back(); // flight_extra_service
      //         Get.back(); // add_passenger
      //         Get.back(); // flight_details
      //         Get.back(); // flight_serach
      //       } else {
      //         Get.back(); // current page
      //         Get.back(); // review_trip
      //         Get.back(); // add_passenger
      //         Get.back(); // flight_deatils
      //       }
      //     });
      //   }
      // },
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
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    Assets.imagesFlightTopBgImage,
                  ),
                ),
              ),
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
                            flightController.searchedTripType.value == TripType.RETURN_DOM ? domReturnSuccessDetailsWidget() : onewaySuccessDetailsWidget(),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              flightController.searchedTripType.value == TripType.RETURN_DOM
                  ? domReturnButtonWidget()
                  : CommonButton(
                      onPressed: () {
                        Get.toNamed(
                          Routes.RECEIPT_SCREEN,
                          arguments: [
                            flightController.domFlightBookModel.value.orderId.toString(), // Order id
                            0,
                            'FlightRecipt', // Design for flight
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
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (flightController.isSeatMealBaggageCheckbox.value == true) {
                    Get.back(); // current page
                    Get.back(); // review trip
                    Get.back(); // flight_extra_service
                    Get.back(); // add_passenger
                    Get.back(); // flight_details
                    Get.back(); // flight_serach
                    flightController.tPinTxtController.clear();
                  } else {
                    Get.back(); // current page
                    Get.back(); // review_trip
                    Get.back(); // add_passenger
                    Get.back(); // flight_deatils
                    flightController.tPinTxtController.clear();
                  }
                  // });
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

  Widget domReturnButtonWidget() {
    return Row(
      children: [
        Visibility(
          visible: flightController.domReturnFlightBookModel.value.onewayResponse!.orderId != null && flightController.domReturnFlightBookModel.value.onewayResponse!.orderId!.isNotEmpty ? true : false,
          child: Expanded(
            child: CommonButton(
              onPressed: () {
                Get.toNamed(
                  Routes.RECEIPT_SCREEN,
                  arguments: [
                    flightController.domReturnFlightBookModel.value.onewayResponse!.orderId.toString(), // Order id
                    flightController.isSeatMealBaggageCheckbox.value,
                    'FlightRecipt', // Design for flight
                  ],
                );
              },
              label: 'Oneway Ticket',
              style: TextHelper.size16.copyWith(
                fontFamily: mediumNunitoFont,
                color: ColorsForApp.whiteColor,
              ),
              border: Border.all(
                color: ColorsForApp.whiteColor,
              ),
              bgColor: ColorsForApp.flightOrangeColor,
            ),
          ),
        ),
        Visibility(
          visible: flightController.domReturnFlightBookModel.value.returnResponse!.orderId != null && flightController.domReturnFlightBookModel.value.returnResponse!.orderId!.isNotEmpty ? true : false,
          child: Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 2.w),
              child: CommonButton(
                onPressed: () {
                  Get.toNamed(
                    Routes.RECEIPT_SCREEN,
                    arguments: [
                      flightController.domReturnFlightBookModel.value.returnResponse!.orderId.toString(), // Order id
                      flightController.isSeatMealBaggageCheckbox.value,
                      'FlightRecipt', // Design for flight
                    ],
                  );
                },
                label: 'Return Ticket',
                style: TextHelper.size16.copyWith(
                  fontFamily: mediumNunitoFont,
                  color: ColorsForApp.whiteColor,
                ),
                border: Border.all(
                  color: ColorsForApp.whiteColor,
                ),
                bgColor: ColorsForApp.flightOrangeColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget onewaySuccessDetailsWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Booking id  ${flightController.domFlightBookModel.value.bookingId != null && flightController.domFlightBookModel.value.bookingId!.isNotEmpty ? flightController.domFlightBookModel.value.bookingId! : '-'}',
            style: TextHelper.size14.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.whiteColor,
            ),
          ),
          Text(
            'Order id  ${flightController.domFlightBookModel.value.orderId != null && flightController.domFlightBookModel.value.orderId!.isNotEmpty ? flightController.domFlightBookModel.value.orderId! : '-'}',
            style: TextHelper.size14.copyWith(
              fontFamily: mediumGoogleSansFont,
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
            flightController.domFlightBookModel.value.message != null && flightController.domFlightBookModel.value.message!.isNotEmpty ? 'Your flight has been successfully booked. Thank you for choosing us. Have a pleasant journey! 😊' : '',
            textAlign: TextAlign.center,
            style: TextHelper.size15.copyWith(color: ColorsForApp.whiteColor, fontFamily: boldGoogleSansFont),
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

  Widget domReturnSuccessDetailsWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // If both flight booked successfully then show this message
          Text(
            (flightController.domReturnFlightBookModel.value.onewayResponse!.message != null && flightController.domReturnFlightBookModel.value.onewayResponse!.message!.isNotEmpty) ||
                    (flightController.domReturnFlightBookModel.value.onewayResponse!.message != null && flightController.domReturnFlightBookModel.value.onewayResponse!.message!.isNotEmpty)
                ? 'Your flight has been successfully booked. Thank you for choosing us. Have a pleasant journey! 😊'
                : '',
            textAlign: TextAlign.center,
            style: TextHelper.size15.copyWith(color: ColorsForApp.whiteColor, fontFamily: boldGoogleSansFont),
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
            'Oneway Details',
            style: TextHelper.size14.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.whiteColor,
            ),
          ),
          Text(
            'Booking ID  ${flightController.domReturnFlightBookModel.value.onewayResponse!.bookingId != null && flightController.domReturnFlightBookModel.value.onewayResponse!.bookingId!.isNotEmpty ? flightController.domReturnFlightBookModel.value.onewayResponse!.bookingId! : '-'}',
            style: TextHelper.size14.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.whiteColor,
            ),
          ),
          Text(
            'Order ID ${flightController.domReturnFlightBookModel.value.onewayResponse!.orderId != null && flightController.domReturnFlightBookModel.value.onewayResponse!.orderId!.isNotEmpty ? flightController.domReturnFlightBookModel.value.onewayResponse!.orderId! : '-'}',
            style: TextHelper.size14.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.whiteColor,
            ),
          ),
          Divider(
            color: ColorsForApp.whiteColor.withOpacity(0.3),
          ),
          Text(
            'Return Details',
            style: TextHelper.size14.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.whiteColor,
            ),
          ),
          height(1.h),
          // return success msg
          flightController.domReturnFlightBookModel.value.returnResponse!.statusCode == 0
              ? Text(
                  flightController.domReturnFlightBookModel.value.returnResponse!.message != null && flightController.domReturnFlightBookModel.value.returnResponse!.message!.isNotEmpty
                      ? flightController.domReturnFlightBookModel.value.returnResponse!.message!
                      : '',
                  textAlign: TextAlign.center,
                  style: TextHelper.size15.copyWith(color: ColorsForApp.whiteColor, fontFamily: boldGoogleSansFont),
                )
              : const SizedBox.shrink(),
          height(1.h),

          Text(
            'Booking ID  ${flightController.domReturnFlightBookModel.value.returnResponse!.bookingId != null && flightController.domReturnFlightBookModel.value.returnResponse!.bookingId!.isNotEmpty ? flightController.domReturnFlightBookModel.value.returnResponse!.bookingId! : 'NA'}',
            style: TextHelper.size14.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.whiteColor,
            ),
          ),
          Text(
            'Order ID ${flightController.domReturnFlightBookModel.value.returnResponse!.orderId != null && flightController.domReturnFlightBookModel.value.returnResponse!.orderId!.isNotEmpty ? flightController.domReturnFlightBookModel.value.returnResponse!.orderId! : 'NA'}',
            style: TextHelper.size14.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.whiteColor,
            ),
          ),
          height(2.h),
          SizedBox(
            width: 100.w,
            height: 20.h,
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

class BuildTimeOutStatus extends StatelessWidget {
  final String timeOutHeroTag = 'timeOutHero';
  final FlightController flightController = Get.find();
  BuildTimeOutStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        key: const ValueKey<int>(3),
        child: Hero(
          tag: timeOutHeroTag,
          child: Container(
            height: 100.h,
            width: 100.w,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Assets.imagesFlightFormBgImage,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: SizedBox(
              height: 100.h,
              width: 100.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          Assets.animationsFlightBookingFaildAnimation,
                          height: 18.h,
                        ),
                        height(1.h),
                        Text(
                          'Mobile Number: ${flightController.mobileTextController.text}',
                          style: TextHelper.size17.copyWith(
                            fontFamily: boldNunitoFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                        height(0.5.h),
                        Text(
                          DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
                          style: TextHelper.size14.copyWith(
                            fontFamily: regularNunitoFont,
                            color: ColorsForApp.lightBlackColor,
                          ),
                        ),
                        height(1.h),
                        Text(
                          apiTimeOutMsg,
                          textAlign: TextAlign.center,
                          style: TextHelper.size15.copyWith(
                            fontFamily: mediumNunitoFont,
                            color: ColorsForApp.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 6.h,
                    child: CommonButton(
                      onPressed: () {
                        flightController.tPinTxtController.clear();
                        Get.back();
                      },
                      width: 92.w,
                      label: 'Try Again',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

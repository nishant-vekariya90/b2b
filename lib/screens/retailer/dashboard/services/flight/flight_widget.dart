import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/flight_controller.dart';
import '../../../../../model/flight/flight_fare_quote_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/dash_line.dart';
import '../../../../../widgets/network_image.dart';

int generateUniqueNumber() {
  Random random = Random();
  int randomNumber = random.nextInt(1000000); // Generate a random number between 0 and 999999
  int timestamp = DateTime.now().millisecondsSinceEpoch; // Get the current timestamp in milliseconds
  String uniqueString = '$timestamp$randomNumber'; // Concatenate timestamp and random number
  return int.parse(uniqueString); // Parse the concatenated string to integer
}

final FlightController flightController = Get.find();

class FlightContinueButton extends StatelessWidget {
  final String? title;
  final String? offeredFare;
  final Widget? leftIconWidget;
  final Widget? continueButton;
  final Function()? onPriceTap;

  const FlightContinueButton({
    super.key,
    this.title,
    this.offeredFare,
    this.leftIconWidget,
    this.continueButton,
    this.onPriceTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: ColorsForApp.whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onPriceTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    title != null && title!.isNotEmpty
                        ? title!.contains(RegExp(r'[0-9]'))
                            ? Text(
                                '${flightController.convertCurrencySymbol(flightCurrency)}${flightController.formatFlightPrice(title ?? '0')}',
                                style: TextHelper.size13.copyWith(
                                  fontFamily: mediumNunitoFont,
                                  color: ColorsForApp.grayScale500,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: ColorsForApp.grayScale500,
                                ),
                              )
                            : Text(
                                title ?? '',
                                style: TextHelper.size13.copyWith(
                                  fontFamily: mediumNunitoFont,
                                  color: ColorsForApp.grayScale500,
                                ),
                              )
                        : const SizedBox.shrink(),
                    // Offered fare | Down arrow
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Amount
                        offeredFare != null && offeredFare!.isNotEmpty
                            ? Text(
                                '${flightController.convertCurrencySymbol(flightCurrency)}${flightController.formatFlightPrice(offeredFare ?? '0')}',
                                style: TextHelper.size17.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: extraBoldNunitoFont,
                                ),
                              )
                            : const SizedBox.shrink(),
                        // Icon
                        leftIconWidget != null ? leftIconWidget! : const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
              ),
              // Continue button
              continueButton!,
            ],
          ),
        ],
      ),
    );
  }
}

// Fare breakup bottomsheet
Future<void> showFareBreakupBottomSheet({
  FareQuoteData? onwardFareQuoteData,
  FareQuoteData? returnFareQuoteData,
  String? seatCount,
  String? seatPrice,
  String? mealCount,
  String? mealPrice,
  String? baggageCount,
  String? baggagePrice,
  bool isShowRefundable = false,
}) {
  return customBottomSheet(
    isScrollControlled: true,
    children: [
      // Fare Breakup title
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Fare breakup text
          Text(
            'Fare Breakup',
            style: TextHelper.h5.copyWith(
              fontFamily: extraBoldNunitoFont,
            ),
          ),
          // Refundable
          isShowRefundable
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
                  decoration: BoxDecoration(
                    color: ColorsForApp.flightOrangeColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'REFUNDABLE',
                    style: TextHelper.size11.copyWith(
                      fontSize: 7.5.sp,
                      fontFamily: regularNunitoFont,
                      color: ColorsForApp.whiteColor,
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
      height(1.5.h),
      // Base fare text
      Text(
        'Base Fare',
        style: TextHelper.size16.copyWith(
          fontFamily: boldNunitoFont,
        ),
      ),
      height(0.5.h),
      // Adults row
      passengerWiseBaseFareWidget(
        title: 'Adult(s)',
        count: onwardFareQuoteData?.adtFareSummary?.count != null && onwardFareQuoteData?.adtFareSummary?.count != null
            ? onwardFareQuoteData?.adtFareSummary?.count ?? '0'
            : returnFareQuoteData?.adtFareSummary?.count ?? '0',
        currency: onwardFareQuoteData?.currency != null && onwardFareQuoteData?.currency != null ? onwardFareQuoteData?.currency ?? '₹' : returnFareQuoteData?.currency ?? '₹',
        perPassengerBaseFare:
            (double.parse(onwardFareQuoteData?.adtFareSummary?.perPassengerBaseFare ?? '0') + double.parse(returnFareQuoteData?.adtFareSummary?.perPassengerBaseFare ?? '0')).toString(),
        totalBaseFare: (double.parse(onwardFareQuoteData?.adtFareSummary?.baseFare ?? '0') + double.parse(returnFareQuoteData?.adtFareSummary?.baseFare ?? '0')).toString(),
      ),
      // Children row
      (int.parse(onwardFareQuoteData?.chdFareSummary?.count ?? '0') > 0 || int.parse(returnFareQuoteData?.chdFareSummary?.count ?? '0') > 0)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(0.5.h),
                // For Children
                passengerWiseBaseFareWidget(
                  title: 'Children',
                  count: onwardFareQuoteData?.chdFareSummary?.count != null && onwardFareQuoteData?.chdFareSummary?.count != null
                      ? onwardFareQuoteData?.chdFareSummary?.count ?? '0'
                      : returnFareQuoteData?.chdFareSummary?.count ?? '0',
                  currency: onwardFareQuoteData?.currency != null && onwardFareQuoteData?.currency != null ? onwardFareQuoteData?.currency ?? '₹' : returnFareQuoteData?.currency ?? '₹',
                  perPassengerBaseFare:
                      (double.parse(onwardFareQuoteData?.chdFareSummary?.perPassengerBaseFare ?? '0') + double.parse(returnFareQuoteData?.chdFareSummary?.perPassengerBaseFare ?? '0')).toString(),
                  totalBaseFare: (double.parse(onwardFareQuoteData?.chdFareSummary?.baseFare ?? '0') + double.parse(returnFareQuoteData?.chdFareSummary?.baseFare ?? '0')).toString(),
                ),
              ],
            )
          : const SizedBox.shrink(),
      // Infant row
      (double.parse(onwardFareQuoteData?.inFareSummary?.count ?? '0') > 0 || double.parse(returnFareQuoteData?.inFareSummary?.count ?? '0') > 0)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(0.5.h),
                // For Infant
                passengerWiseBaseFareWidget(
                  title: 'Infant(s)',
                  count: onwardFareQuoteData?.inFareSummary?.count != null && onwardFareQuoteData?.inFareSummary?.count != null
                      ? onwardFareQuoteData?.inFareSummary?.count ?? '0'
                      : returnFareQuoteData?.inFareSummary?.count ?? '0',
                  currency: onwardFareQuoteData?.currency != null && onwardFareQuoteData?.currency != null ? onwardFareQuoteData?.currency ?? '₹' : returnFareQuoteData?.currency ?? '₹',
                  perPassengerBaseFare:
                      (double.parse(onwardFareQuoteData?.inFareSummary?.perPassengerBaseFare ?? '0') + double.parse(returnFareQuoteData?.inFareSummary?.perPassengerBaseFare ?? '0')).toString(),
                  totalBaseFare: (double.parse(onwardFareQuoteData?.inFareSummary?.baseFare ?? '0') + double.parse(returnFareQuoteData?.inFareSummary?.baseFare ?? '0')).toString(),
                ),
              ],
            )
          : const SizedBox.shrink(),
      // Taxes & Fees
      (double.parse(onwardFareQuoteData?.tax ?? '0') > 0 || double.parse(returnFareQuoteData?.tax ?? '0') > 0)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(0.5.h),
                // Taxes & Fees
                fareBreakupTotalGrandTotalRowWidget(
                  title: 'Taxes & Fees',
                  titleStyle: TextHelper.size15.copyWith(
                    fontFamily: boldNunitoFont,
                  ),
                  currency: onwardFareQuoteData?.currency != null && onwardFareQuoteData?.currency != null ? onwardFareQuoteData?.currency ?? '₹' : returnFareQuoteData?.currency ?? '₹',
                  totalPrice: (double.parse(onwardFareQuoteData?.tax ?? '0') + double.parse(returnFareQuoteData?.tax ?? '0')).toString(),
                  totalPriceStyle: TextHelper.size14.copyWith(
                    fontFamily: regularNunitoFont,
                    color: ColorsForApp.greyColor.withOpacity(0.7),
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
      height(2.h),
      // Divider
      Divider(
        color: ColorsForApp.grayScale200,
        height: 0,
      ),
      height(2.h),
      // Total Airfare
      fareBreakupTotalGrandTotalRowWidget(
        title: 'Total Airfare',
        currency: onwardFareQuoteData?.currency != null && onwardFareQuoteData?.currency != null ? onwardFareQuoteData?.currency ?? '₹' : returnFareQuoteData?.currency ?? '₹',
        totalPrice: (double.parse(onwardFareQuoteData?.offeredFare ?? '0') + double.parse(returnFareQuoteData?.offeredFare ?? '0')).toString(),
      ),
      // Discount | Seat | Meal | Baggage
      (double.parse(onwardFareQuoteData?.discount ?? '0') > 0 ||
              double.parse(returnFareQuoteData?.discount ?? '0') > 0 ||
              int.parse(seatCount ?? '0') > 0 ||
              int.parse(mealCount ?? '0') > 0 ||
              int.parse(baggageCount ?? '0') > 0)
          ? Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(0.5.h),
                // Seats row
                int.parse(seatCount ?? '0') > 0
                    ? passengerWiseExtraServiceWidget(
                        title: 'Seat',
                        count: seatCount ?? '0',
                        currency: onwardFareQuoteData?.currency != null && onwardFareQuoteData?.currency != null ? onwardFareQuoteData?.currency ?? '₹' : returnFareQuoteData?.currency ?? '₹',
                        price: seatPrice ?? '0',
                      )
                    : const SizedBox.shrink(),
                // Meals row
                int.parse(mealCount ?? '0') > 0
                    ? passengerWiseExtraServiceWidget(
                        title: 'Meal',
                        count: mealCount ?? '0',
                        currency: onwardFareQuoteData?.currency != null && onwardFareQuoteData?.currency != null ? onwardFareQuoteData?.currency ?? '₹' : returnFareQuoteData?.currency ?? '₹',
                        price: mealPrice ?? '0',
                      )
                    : const SizedBox.shrink(),
                // Baggage row
                int.parse(baggageCount ?? '0') > 0
                    ? passengerWiseExtraServiceWidget(
                        title: 'Baggage',
                        count: baggageCount ?? '0',
                        currency: onwardFareQuoteData?.currency != null && onwardFareQuoteData?.currency != null ? onwardFareQuoteData?.currency ?? '₹' : returnFareQuoteData?.currency ?? '₹',
                        price: baggagePrice ?? '0',
                      )
                    : const SizedBox.shrink(),
                // Instant Discount
                double.parse(onwardFareQuoteData?.discount ?? '0') > 0 || double.parse(returnFareQuoteData?.discount ?? '0') > 0
                    ? fareBreakupTotalGrandTotalRowWidget(
                        title: 'Instant Discount',
                        titleStyle: TextHelper.size14.copyWith(
                          fontFamily: regularNunitoFont,
                          color: ColorsForApp.greyColor.withOpacity(0.7),
                        ),
                        currency: onwardFareQuoteData?.currency != null && onwardFareQuoteData?.currency != null ? onwardFareQuoteData?.currency ?? '₹' : returnFareQuoteData?.currency ?? '₹',
                        totalPrice: (double.parse(onwardFareQuoteData?.discount ?? '0') + double.parse(returnFareQuoteData?.discount ?? '0')).toString(),
                        totalPriceStyle: TextHelper.size14.copyWith(
                          fontFamily: regularNunitoFont,
                          color: ColorsForApp.successColor,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            )
          : const SizedBox.shrink(),
      height(2.h),
      // Divider
      Divider(
        color: ColorsForApp.grayScale200,
        height: 0,
      ),
      height(2.h),
      // Grand total
      fareBreakupTotalGrandTotalRowWidget(
        title: 'Grand Total',
        currency: onwardFareQuoteData?.currency != null && onwardFareQuoteData?.currency != null ? onwardFareQuoteData?.currency ?? '₹' : returnFareQuoteData?.currency ?? '₹',
        totalPrice: ((double.parse(onwardFareQuoteData?.offeredFare ?? '0') + double.parse(returnFareQuoteData?.offeredFare ?? '0')) -
                ((double.parse(onwardFareQuoteData?.discount ?? '0') + double.parse(returnFareQuoteData?.discount ?? '0'))) +
                (double.parse(flightController.totalSeatPrice.value) + double.parse(flightController.totalMealPrice.value) + double.parse(flightController.totalBaggagePrice.value)))
            .toString(),
      ),
      // Excluding convenience fee text
      Text(
        '(Excluding convenience fee)',
        style: TextHelper.size12.copyWith(
          fontFamily: regularNunitoFont,
        ),
      ),
      height(1.h),
    ],
    customButtons: CommonButton(
      onPressed: () async {
        Get.back();
      },
      label: 'Continue',
    ),
  );
}

// Passenger wise base fare widget
Widget passengerWiseBaseFareWidget({required String title, required String count, required String currency, required String perPassengerBaseFare, required String totalBaseFare}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Title (count x baseFare)
      Text(
        '$title ($count X ${flightController.convertCurrencySymbol(currency)}${flightController.formatFlightPrice(perPassengerBaseFare)})',
        style: TextHelper.size14.copyWith(
          fontFamily: regularNunitoFont,
          color: ColorsForApp.greyColor.withOpacity(0.7),
        ),
      ),
      // Total base fare
      Text(
        '${flightController.convertCurrencySymbol(currency)}${flightController.formatFlightPrice(totalBaseFare)}',
        style: TextHelper.size14.copyWith(
          fontFamily: regularNunitoFont,
          color: ColorsForApp.greyColor.withOpacity(0.7),
        ),
      ),
    ],
  );
}

// Passenger wise extra service widget
Widget passengerWiseExtraServiceWidget({required String title, required String count, required String currency, required String price}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Title x Count
      Text(
        '$title x $count',
        style: TextHelper.size14.copyWith(
          fontFamily: regularNunitoFont,
          color: ColorsForApp.greyColor.withOpacity(0.7),
        ),
      ),
      // Total price
      Text(
        '${flightController.convertCurrencySymbol(currency)}${flightController.formatFlightPrice(price)}',
        style: TextHelper.size14.copyWith(
          fontFamily: regularNunitoFont,
          color: ColorsForApp.greyColor.withOpacity(0.7),
        ),
      ),
    ],
  );
}

// Fare brekup total | grand total row widget
Widget fareBreakupTotalGrandTotalRowWidget({required String title, TextStyle? titleStyle, required String currency, required String totalPrice, TextStyle? totalPriceStyle}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Title
      Text(
        title,
        style: titleStyle ??
            TextHelper.size17.copyWith(
              fontFamily: extraBoldNunitoFont,
              color: ColorsForApp.blackColor,
            ),
      ),
      // Total price
      Text(
        '${title == 'Instant Discount' ? '- ' : ''}${flightController.convertCurrencySymbol(currency)}${flightController.formatFlightPrice(totalPrice)}',
        style: totalPriceStyle ??
            TextHelper.size17.copyWith(
              fontFamily: extraBoldNunitoFont,
              color: ColorsForApp.blackColor,
            ),
      ),
    ],
  );
}

// Title with icon widget
Widget titleWithIconWidget({required String icon, required String title}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Icon(icon),
      SizedBox(
        height: 24,
        width: 24,
        child: ShowNetworkImage(
          networkUrl: icon,
          isAssetImage: true,
        ),
      ),
      width(2.w),
      Text(
        title,
        style: TextHelper.size15.copyWith(
          fontFamily: extraBoldNunitoFont,
        ),
      ),
    ],
  );
}

Widget flightMinDetails({required IconData icon, required String title}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(
        icon,
        size: 15,
        color: Colors.grey,
      ),
      width(1.w),
      Text(
        title.toTitleCase(),
        style: TextHelper.size13.copyWith(
          fontFamily: regularNunitoFont,
          color: ColorsForApp.lightBlackColor,
        ),
      ),
    ],
  );
}

Widget dashLineWidget() {
  return DashedLine(
    width: 1.5.w,
    color: ColorsForApp.grayScale500.withOpacity(0.3),
  );
}

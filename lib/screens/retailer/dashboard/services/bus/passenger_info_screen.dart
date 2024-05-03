import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/bus_booking_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/bus/passenger_info_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/dash_line.dart';
import '../../../../../widgets/searchable_dropdown_textfield.dart';
import '../../../../../widgets/text_field.dart';
import '../../../../../widgets/text_field_with_title.dart';

// ignore: must_be_immutable
class BusPassengerInfoScreen extends StatefulWidget {
  const BusPassengerInfoScreen({super.key});

  @override
  State<BusPassengerInfoScreen> createState() => _BusPassengerInfoScreenState();
}

class _BusPassengerInfoScreenState extends State<BusPassengerInfoScreen> {
  BusBookingController busBookingController = Get.find();
  final GlobalKey<FormState> bookingConfirmationformKey = GlobalKey<FormState>();

  @override
  void initState() {
    busBookingController.setPassengerInfoController();
    busBookingController.passengerMobileTxtController.clear();
    busBookingController.passengerEmailTxtController.clear();
    busBookingController.passengerAddressTxtController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Passenger Information",
      appBarTextStyle: TextHelper.size18.copyWith(
        color: ColorsForApp.whiteColor,
        fontFamily: mediumGoogleSansFont,
      ),
      leadingIconColor: ColorsForApp.whiteColor,
      appBarBgImage: Assets.imagesFlightTopBgImage,
      appBarHeight: 25.h,
      isShowLeadingIcon: true,
      topCenterWidget: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${busBookingController.availableTripsModel.travels}",
              style: TextHelper.size15.copyWith(
                color: ColorsForApp.whiteColor,
                fontFamily: boldNunitoFont,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "${busBookingController.availableTripsModel.busType}",
              style: TextHelper.size12.copyWith(
                fontFamily: mediumNunitoFont,
                color: ColorsForApp.whiteColor,
              ),
            ),
            height(1.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(busBookingController.fromLocationTxtController.text,
                          style: TextHelper.size15.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: boldNunitoFont,
                          )),
                      height(0.5.h),
                      Text("${busBookingController.boardingLocation!.value.name}",
                          style: TextHelper.size12.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: mediumNunitoFont,
                          )),
                      height(0.4.h),
                      Text("${busBookingController.boardingLocation!.value.landmark}",
                          style: TextHelper.size11.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: regularNunitoFont,
                          )),
                      height(0.4.h),
                      Text(busBookingController.convertMinutesToHours(busBookingController.availableTripsModel.departureTime.toString()),
                          style: TextHelper.size11.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: regularNunitoFont,
                          )),
                    ],
                  ),
                ),
                width(3.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(Assets.animationsBus,
                          //width: 60.w,
                          height: 7.h,
                          fit: BoxFit.fitHeight),
                      Text(busBookingController.departureDate.value.toString(),
                          style: TextHelper.size13.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: mediumNunitoFont,
                          )),
                      Text(busBookingController.availableTripsModel.duration.toString(),
                          style: TextHelper.size13.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: mediumNunitoFont,
                          )),
                    ],
                  ),
                ),
                width(3.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(busBookingController.toLocationTxtController.text,
                          style: TextHelper.size15.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: boldNunitoFont,
                          )),
                      height(0.5.h),
                      Text('${busBookingController.droppingLocation!.value.name}',
                          textAlign: TextAlign.end,
                          style: TextHelper.size12.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: mediumNunitoFont,
                          )),
                      height(0.4.h),
                      Text(
                        '${busBookingController.droppingLocation!.value.landmark}',
                        textAlign: TextAlign.end,
                        style: TextHelper.size11.copyWith(
                          color: ColorsForApp.whiteColor,
                          fontFamily: mediumNunitoFont,
                        ),
                      ),
                      height(0.4.h),
                      Text(busBookingController.convertMinutesToHours(busBookingController.availableTripsModel.arrivalTime.toString()),
                          style: TextHelper.size11.copyWith(
                            color: ColorsForApp.whiteColor,
                            fontFamily: regularNunitoFont,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            height(1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${busBookingController.selectedSeatList.length} seat${busBookingController.selectedSeatList.length > 1 ? "s" : ''}",
                  style: TextHelper.size14.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsForApp.whiteColor,
                    fontFamily: mediumGoogleSansFont,
                  ),
                ),
                Visibility(
                  visible: false,
                  child: InkWell(
                    onTap: () {
                      busBookingController.tPinTxtController.clear();
                      busDetailsBottomSheet();
                    },
                    child: Text(
                      "view details",
                      style: TextHelper.size14.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: ColorsForApp.whiteColor,
                        fontWeight: FontWeight.bold,
                        color: ColorsForApp.whiteColor,
                        fontFamily: mediumGoogleSansFont,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            height(0.5.h),
          ],
        ),
      ),
      mainBody: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height(1.h),
            addPassenger(),
            height(3.h),
            Visibility(
              visible: false,
              child: RichText(
                text: TextSpan(
                  text: 'By clicking \'Pay now\',I accept',
                  style: TextHelper.size13.copyWith(
                    fontFamily: regularNunitoFont,
                    color: ColorsForApp.lightBlackColor,
                  ),
                  children: [
                    TextSpan(
                      text: ' Terms & Conditions',
                      style: TextHelper.size13.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: ColorsForApp.primaryColorBlue,
                        fontFamily: boldNunitoFont,
                        color: ColorsForApp.primaryColorBlue,
                      ),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: TextHelper.size13.copyWith(
                        fontFamily: regularNunitoFont,
                        color: ColorsForApp.lightBlackColor,
                      ),
                    ),
                    TextSpan(
                      text: ' Privacy Policy',
                      style: TextHelper.size13.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: ColorsForApp.primaryColorBlue,
                        fontFamily: boldNunitoFont,
                        color: ColorsForApp.primaryColorBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Amount",
                  style: TextHelper.size14.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: mediumNunitoFont,
                    color: ColorsForApp.lightBlackColor.withOpacity(0.8),
                  ),
                ),
                Text(
                  "₹ ${busBookingController.totalFareOfSeats}",
                  style: TextHelper.size16.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsForApp.primaryColor,
                    fontFamily: extraBoldNunitoFont,
                  ),
                ),
              ],
            ),
            Text(
              "Tax included",
              style: TextHelper.size13.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: mediumNunitoFont,
                color: ColorsForApp.grayScale500,
              ),
            ),
            height(1.h),
            CommonButton(
                onPressed: () {
                  if (busBookingController.fKey.currentState!.validate()) {
                    // Get.toNamed(Routes.BOOKING_SUCCESS_SCREEN);
                    debugPrint("Valid");
                    busBookingController.tPinTxtController.clear();
                    busDetailsBottomSheet();
                  }
                },
                label: "Preview"),
          ],
        ),
      ),
    );
  }

  Widget addPassenger() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 3.w,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: ColorsForApp.whiteColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ColorsForApp.grayScale200,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Passengers",
            style: TextHelper.size15.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
          ),
          Form(
            key: busBookingController.fKey,
            child: Column(
              children: [
                height(1.h),
                CustomTextField(
                  hintText: "Mobile",
                  maxLength: 10,
                  validator: (value) => value == null || value.trim().isEmpty || value.length < 10 ? "Enter valid mobile number" : null,
                  controller: busBookingController.passengerMobileTxtController,
                  keyboardType: TextInputType.number,
                  textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                ),
                height(1.h),
                CustomTextField(
                  hintText: "Email",
                  validator: (value) => busBookingController.isValidEmail(value.toString()) == true ? null : 'Enter valid email',
                  controller: busBookingController.passengerEmailTxtController,
                  keyboardType: TextInputType.emailAddress,
                ),
                height(1.h),
                CustomTextField(
                  hintText: "Address",
                  controller: busBookingController.passengerAddressTxtController,
                  validator: (value) {
                    if (value == null || busBookingController.passengerAddressTxtController.text.isEmpty || busBookingController.passengerAddressTxtController.text.length < 5) {
                      return "Address must be at least 5 characters";
                    }
                    return null;
                  },
                ),
                height(1.h),
                ListView.separated(
                  itemCount: busBookingController.passengerList == null ? 0 : busBookingController.passengerList!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return passengerForm("Passenger ${index + 1}", busBookingController.passengerList![index]);
                  },
                  separatorBuilder: (BuildContext context, int index) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: DashedLine(
                      color: ColorsForApp.grayScale500,
                      width: 2.w,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget contactDetails() {
  Future busDetailsBottomSheet() {
    return customBottomSheet(
      enableDrag: true,
      isDismissible: true,
      preventToClose: true,
      isScrollControlled: true,
      children: [
        Text(
          "Review booking details",
          style: TextHelper.size16.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
        ),
        height(2.h),
        Text(
          "${busBookingController.availableTripsModel.travels}",
          style: TextHelper.size15.copyWith(
            fontFamily: boldNunitoFont,
          ),
        ),
        Text(
          "${busBookingController.availableTripsModel.busType}",
          style: TextHelper.size12.copyWith(
            fontFamily: mediumNunitoFont,
            color: ColorsForApp.grayScale500,
          ),
        ),
        height(4.h),
        Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorsForApp.primaryShadeColor.withOpacity(0.6),
                      radius: 4.w,
                      child: const Icon(
                        Icons.location_pin,
                        size: 17,
                      ),
                    ),
                  ],
                ),
                height(10.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: ColorsForApp.primaryShadeColor.withOpacity(0.6),
                      radius: 4.w,
                      child: const Icon(
                        Icons.location_pin,
                        size: 17,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            width(3.w),
            Container(
              width: 2.w,
              height: 15.h,
              decoration: BoxDecoration(
                color: ColorsForApp.grayScale200,
                borderRadius: const BorderRadius.all(
                  Radius.elliptical(10, 10),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.circle,
                    size: 2.w,
                  ),
                  Icon(
                    Icons.circle,
                    size: 2.w,
                  )
                ],
              ),
            ),
            width(3.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        busBookingController.boardingLocation!.value.name.toString(),
                        style: TextHelper.size15.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
                      ),
                      Text(
                        busBookingController.boardingLocation!.value.landmark.toString(),
                        style: TextHelper.size12.copyWith(
                          fontFamily: regularNunitoFont,
                        ),
                      ),
                    ],
                  ),
                  height(6.h),
                  // const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        busBookingController.droppingLocation!.value.name.toString(),
                        style: TextHelper.size15.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
                      ),
                      Text(
                        busBookingController.droppingLocation!.value.landmark.toString(),
                        style: TextHelper.size12.copyWith(
                          fontFamily: regularNunitoFont,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Divider(
            color: ColorsForApp.grayScale500,
            thickness: 1,
          ),
        ),
        Text(
          "Passengers",
          style: TextHelper.size15.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
        ),
        height(1.h),
        ListView.separated(
          itemCount: busBookingController.passengerList == null ? 0 : busBookingController.passengerList!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            PassengerInfoModel passenger = busBookingController.passengerList![index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: ColorsForApp.primaryShadeColor.withOpacity(0.6),
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        passenger.passengerNameTxtController.text.toString(),
                        style: TextHelper.size14.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
                      ),
                      Text(
                        "${passenger.gender.toString()}, ${passenger.passengerAgeTxtController.text.toString()} years",
                        style: TextHelper.size12.copyWith(fontFamily: mediumNunitoFont, color: ColorsForApp.primaryColor),
                      ),
                      Text(
                        "${passenger.docType.toString()}: ${passenger.passengerIdTxtController.text.toString()}",
                        style: TextHelper.size12.copyWith(fontFamily: mediumNunitoFont, color: ColorsForApp.primaryColor),
                      ),
                    ],
                  ),
                  Text(
                    "Seat No. ${passenger.seat.toString()}",
                    style: TextHelper.size12.copyWith(fontFamily: mediumNunitoFont, color: ColorsForApp.primaryColor),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: DashedLine(
              color: ColorsForApp.grayScale500,
              width: 2.w,
              height: 1,
            ),
          ),
        ),
        height(2.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fare Breakup',
              style: TextHelper.size15.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
            ),
            Text(
              '${busBookingController.selectedSeatList.length} seat${busBookingController.selectedSeatList.length > 1 ? "s" : ''}',
              style: TextHelper.size13.copyWith(color: ColorsForApp.grayScale500, fontFamily: regularNunitoFont),
            ),
            height(1.h),
            regularTextWithRow("Base fare", "₹ ${busBookingController.baseFareOfSeats}"),
            regularTextWithRow("GST", "₹ ${busBookingController.taxFareOfSeats}"),
            height(1.5.h),
            Divider(
              height: 0,
              thickness: 0.2,
              color: ColorsForApp.greyColor,
            ),
            height(1.5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextHelper.size16.copyWith(
                    fontFamily: mediumNunitoFont,
                    color: ColorsForApp.lightBlackColor,
                  ),
                ),
                Text("₹ ${busBookingController.totalFareOfSeats}",
                    style: TextHelper.size16.copyWith(
                      fontFamily: boldNunitoFont,
                      color: ColorsForApp.greyColor,
                    ))
              ],
            ),
          ],
        ),
        height(2.h),
        // TPIN
        Form(
            key: bookingConfirmationformKey,
            child: Column(
              children: [
                Visibility(
                  // visible: flightController.isShowTpinField.value,
                  visible: true,
                  child: Obx(
                    () => CustomTextFieldWithTitle(
                      controller: busBookingController.tPinTxtController,
                      title: 'TPIN',
                      hintText: 'Enter TPIN',
                      maxLength: 4,
                      isCompulsory: true,
                      obscureText: busBookingController.isShowTpin.value,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      suffixIcon: IconButton(
                        icon: Icon(
                          busBookingController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                          size: 18,
                          color: ColorsForApp.secondaryColor,
                        ),
                        onPressed: () {
                          busBookingController.isShowTpin.value = !busBookingController.isShowTpin.value;
                        },
                      ),
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (busBookingController.tPinTxtController.text.trim().isEmpty) {
                          return 'Please enter TPIN';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                CommonButton(
                    onPressed: () async {
                      if (bookingConfirmationformKey.currentState!.validate()) {
                        debugPrint("Valid");
                        Get.toNamed(Routes.BUS_BOOKING_PROCESS_SCREEN);
                        /*busBookingController.busBookingPassenger();
                        return await busBookingController.busBookApi(isLoaderShow: false);*/
                      }
                    },
                    label: "Book now"),
              ],
            )),
      ],
    );
  }

  Widget regularTextWithRow(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextHelper.size13.copyWith(
              fontFamily: mediumNunitoFont,
              color: ColorsForApp.greyColor,
            )),
        Text(price,
            style: TextHelper.size14.copyWith(
              fontFamily: boldNunitoFont,
              color: ColorsForApp.greyColor,
            )),
      ],
    );
  }

  Widget passengerForm(String title, PassengerInfoModel passengerInfoModel) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: ColorsForApp.primaryShadeColor.withOpacity(0.6),
                  radius: 5.w,
                  child: const Icon(
                    Icons.person,
                    size: 17,
                  ),
                ),
                width(2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextHelper.size14.copyWith(
                          fontFamily: boldNunitoFont,
                        ),
                      ),
                      Text(
                        "Seat No: ${passengerInfoModel.seat}",
                        style: TextHelper.size12.copyWith(
                          color: ColorsForApp.grayScale500,
                          fontFamily: boldNunitoFont,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: CustomDropDownTextField(
                    validator: (value) {
                      if (value == null) {
                        return "Select title";
                      }
                      return null;
                    },
                    options: const ["Mr", "Ms", "Mrs", "Other/Mx"],
                    hintText: 'Title',
                    value: passengerInfoModel.title,
                    borderRadius: BorderRadius.circular(10),
                    onChanged: (value) {
                      passengerInfoModel.title = value;
                    },
                  ),
                ),
                width(2.w),
                Expanded(
                  flex: 5,
                  child: CustomTextField(
                    hintText: "Full Name",
                    validator: (value) => value == null || value.trim().isEmpty ? "Enter name" : null,
                    controller: passengerInfoModel.passengerNameTxtController,
                    keyboardType: TextInputType.name,
                    textInputFormatter: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\ ]"))],
                  ),
                ),
              ],
            ),
          ),
          height(1.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /*Text(
                  "Gender",
                  style: TextHelper.size14.copyWith(
                      fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
                ),*/
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                          value: 'Male',
                          groupValue: passengerInfoModel.gender,
                          onChanged: (value) {
                            setState(() {
                              passengerInfoModel.gender = value!;
                            });
                          },
                          activeColor: ColorsForApp.primaryColor,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                        width(5),
                        Text(
                          'Male',
                          style: TextHelper.size14.copyWith(
                            color: busBookingController.selectedGender.value == 'Male' ? ColorsForApp.primaryColor : ColorsForApp.grayScale500,
                            fontWeight: busBookingController.selectedGender.value == 'Male' ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        width(15),
                        Radio(
                          value: 'Female',
                          groupValue: passengerInfoModel.gender,
                          onChanged: (value) {
                            setState(() {
                              passengerInfoModel.gender = value!;
                            });
                          },
                          activeColor: ColorsForApp.primaryColor,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                        width(5),
                        Text(
                          'Female',
                          style: TextHelper.size14.copyWith(
                            color: busBookingController.selectedGender.value == 'Female' ? ColorsForApp.primaryColor : ColorsForApp.grayScale500,
                            fontWeight: busBookingController.selectedGender.value == 'Female' ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        width(5),
                        Radio(
                          value: 'Other',
                          groupValue: passengerInfoModel.gender,
                          onChanged: (value) {
                            setState(() {
                              passengerInfoModel.gender = value!;
                            });
                          },
                          activeColor: ColorsForApp.primaryColor,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                        width(5),
                        Text(
                          'Other',
                          style: TextHelper.size14.copyWith(
                            color: busBookingController.selectedGender.value == 'Other' ? ColorsForApp.primaryColor : ColorsForApp.grayScale500,
                            fontWeight: busBookingController.selectedGender.value == 'Other' ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    )),
                width(2.w),
                Expanded(
                  child: CustomTextField(
                    hintText: "Age",
                    maxLength: 3,
                    validator: (value) => value == null || value.trim().isEmpty ||int.parse(value.trim().toString())  <1 ? "Enter age" : null,
                    controller: passengerInfoModel.passengerAgeTxtController,
                    textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          height(1.h),
          CustomDropDownTextField(
            options: const ["Aadhaar Card", "Pan Card"],
            hintText: 'Document',
            validator: (value) {
              if (value == null) {
                return "Select Document Type";
              }
              return null;
            },
            value: passengerInfoModel.docType,
            borderRadius: BorderRadius.circular(10),
            onChanged: (value) {
              setState(() {
                passengerInfoModel.docType = value;
                passengerInfoModel.maxLengthDoc = calculateMaxLength(passengerInfoModel.docType);
                passengerInfoModel.passengerIdTxtController.clear();
              });
            },
          ),
          height(1.h),
          CustomTextField(
            hintText: "ID number",
            controller: passengerInfoModel.passengerIdTxtController,
            textCapitalization: TextCapitalization.characters,
            readOnly: passengerInfoModel.maxLengthDoc == null?true:false,
            textInputFormatter: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]'))
            ],
            onTap: ()=> passengerInfoModel.maxLengthDoc == null ? errorSnackBar(message: "Select document type"):null,
            maxLength: passengerInfoModel.maxLengthDoc,
            validator: (value) {
              String document = passengerInfoModel.docType ?? "Select Document Type";
              if (value!.trim().isEmpty) {
                return "Enter $document number";
              } else if (document == "Aadhaar Card" && (!busBookingController.aadhaarRegex.hasMatch(value))) {
                return "Enter valid Aadhaar Card number";
              } else if (document == "Pan Card" && (!busBookingController.panRegex.hasMatch(value))) {
                return "Enter valid Pan Card number";
              } else {
                return null;
              }
            },
          ),          height(1.h),
        ],
      );
  int? calculateMaxLength(String? documentType) {
    switch (documentType) {
      case "Aadhaar Card":
        return 12;
      case "Pan Card":
        return 10;
      default:
        return null;
    }
  }
}

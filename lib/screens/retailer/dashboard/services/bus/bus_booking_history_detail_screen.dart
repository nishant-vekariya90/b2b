import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/bus_booking_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/bus/bus_booking_passengers_detail_model.dart';
import '../../../../../model/bus/bus_booking_report_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';

class BusBookingHistoryDetailScreen extends StatefulWidget {
  const BusBookingHistoryDetailScreen({super.key});

  @override
  State<BusBookingHistoryDetailScreen> createState() =>
      _BusBookingHistoryDetailScreenState();
}

class _BusBookingHistoryDetailScreenState extends State<BusBookingHistoryDetailScreen> {
  final BusBookingController busBookingController = Get.find();
  final BusBookingReportData busBookingReportData = Get.arguments;
  String cancelText = "";
  int hours =0;
  List<String> cancelItems = <String>[];
  List<String> separatedCancelItems = <String>[];
  String currentTime="";
  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      busBookingController.getBusPassengersListApi(
          busId: busBookingReportData.id, isLoaderShow: true);
      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          appBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomPaint(
                  painter: CardShadow(),
                  child: ClipPath(
                    clipper: CardShape(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 20.h,
                          width: 100.w,
                          color: Colors.white,
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    height(2.h),
                                    Image.asset(
                                      busBookingController.busTicketStatus(
                                                  busBookingReportData
                                                      .status!) ==
                                              'Booked'
                                          ? Assets.imagesApprove
                                          : busBookingController
                                                      .busTicketStatus(
                                                          busBookingReportData
                                                              .status!) ==
                                                  'Cancelled'
                                              ? Assets.iconsIcTicketCancelled
                                              : busBookingController
                                                          .busTicketStatus(
                                                              busBookingReportData
                                                                  .status!) ==
                                                      'Pending'
                                                  ? Assets.imagesPending
                                                  : busBookingController
                                                              .busTicketStatus(
                                                                  busBookingReportData
                                                                      .status!) ==
                                                          'PartialCancel'
                                                      ? Assets.iconsIcTicketCancelled
                                                      : busBookingController
                                                                  .busTicketStatus(
                                                                      busBookingReportData
                                                                          .status!) ==
                                                              'PendingCancelled'
                                                          ? Assets.imagesPending
                                                          : '_',
                                      scale: 2,
                                    ),
                                    height(1.h),
                                    Text(
                                      busBookingController.busTicketStatus(
                                                  busBookingReportData
                                                      .status!) ==
                                              'Booked'
                                          ? 'Booking Confirmed'
                                          : busBookingController
                                                      .busTicketStatus(
                                                          busBookingReportData
                                                              .status!) ==
                                                  'Cancelled'
                                              ? 'Cancelled'
                                              : busBookingController
                                                          .busTicketStatus(
                                                              busBookingReportData
                                                                  .status!) ==
                                                      'Pending'
                                                  ? 'Pending'
                                                  : busBookingController
                                                              .busTicketStatus(
                                                                  busBookingReportData
                                                                      .status!) ==
                                                          'PartialCancel'
                                                      ? 'PartialCancel'
                                                      : busBookingController
                                                                  .busTicketStatus(
                                                                      busBookingReportData
                                                                          .status!) ==
                                                              'PendingCancelled'
                                                          ? 'PendingCancelled'
                                                          : '_',
                                      style: TextHelper.size18.copyWith(
                                        fontFamily: extraBoldNunitoFont,
                                        color: ColorsForApp.lightBlackColor,
                                      ),
                                    ),
                                    height(1.h),
                                    Text(
                                      textAlign: TextAlign.center,
                                      'Ticket Emailed to ${busBookingReportData.email!.isEmpty ? '_' : busBookingReportData.email}\n and sms send to ${busBookingReportData.mobileNo!.isEmpty ? '_' : busBookingReportData.mobileNo}. have a safe trip.',
                                      style: TextHelper.size14.copyWith(
                                        fontFamily: regularNunitoFont,
                                        color: ColorsForApp.primaryColor,
                                      ),
                                    ),
                                    height(1.h),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: busBookingController.busTicketStatus(
                                            busBookingReportData.status!) ==
                                        'Booked'
                                    ? true
                                    : false,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: EdgeInsets.all(3.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          Routes.RECEIPT_SCREEN,
                                          arguments: [
                                            busBookingReportData.orderId.toString(), // Order id
                                            0,
                                            'BusReceipt', // Design for flight
                                          ],
                                        );
                                      },
                                      child: Container(
                                        height: 5.h,
                                        width: 5.w,
                                        color: ColorsForApp.whiteColor,
                                        child: Center(
                                          child: Image.asset(
                                            Assets.imagesFlightDownload,
                                            scale: 4,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: ColorsForApp.whiteColor,
                          padding: EdgeInsets.all(3.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              height(2.h),
                              Row(
                                children: [
                                  Expanded(
                                      child: locationDetails(
                                          location: busBookingReportData
                                                  .fromCityName ??
                                              'NA',
                                          address: busBookingReportData
                                                  .pickupLocation ??
                                              'NA',
                                          crossAxisAlignment: TextAlign.start)),
                                  SvgPicture.asset(
                                    Assets.imagesBlueCircleSvg,
                                    width: 2.w,
                                  ),
                                  Dash(
                                    length: 20.w,
                                    dashColor: ColorsForApp.grayScale500,
                                  ),
                                  SvgPicture.asset(
                                    Assets.imagesGreenCircleSvg,
                                    width: 2.w,
                                  ),
                                  Expanded(
                                      child: locationDetails(
                                          location:
                                              busBookingReportData.toCityName ??
                                                  'NA',
                                          address: busBookingReportData
                                                  .dropingPointName ??
                                              'NA',
                                          crossAxisAlignment: TextAlign.end)),
                                ],
                              ),
                              Divider(
                                color:
                                    ColorsForApp.grayScale500.withOpacity(0.5),
                              ),
                              Text(
                                  busBookingReportData.travels != null
                                      ? busBookingReportData.travels.toString()
                                      : 'NA',
                                  style: TextHelper.size18.copyWith(
                                      fontFamily: boldNunitoFont,
                                      color: ColorsForApp.primaryColor)),
                              height(1.h),
                              Row(
                                children: [
                                  Expanded(
                                      child: detailSection(
                                    sectionTitle: "Ticket No",
                                    sectionValue:
                                        busBookingReportData.ticketNo != null
                                            ? busBookingReportData.ticketNo
                                                .toString()
                                            : 'NA',
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    valueStyle: TextHelper.size12.copyWith(
                                        color: ColorsForApp.flightOrangeColor,
                                        fontFamily: boldNunitoFont),
                                  )),
                                  Expanded(
                                      child: detailSection(
                                    sectionTitle: "DOJ",
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    sectionValue: busBookingReportData.doj !=
                                            null
                                        ? busBookingController.formatDateTime(
                                            dateTimeFormat: 'yMMMd',
                                            dateTimeString: busBookingReportData
                                                .doj
                                                .toString())
                                        : 'NA',
                                  )),
                                ],
                              ),
                              height(1.h),
                              Row(
                                children: [
                                  Expanded(
                                      child: detailSection(
                                          sectionTitle: "Bus type",
                                          sectionValue:
                                              busBookingReportData.busType !=
                                                      null
                                                  ? busBookingReportData.busType
                                                      .toString()
                                                  : 'NA',
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start)),
                                  Expanded(
                                      child: detailSection(
                                          sectionTitle: "Pickup Time",
                                          sectionValue: busBookingController
                                              .convertMinutesToHours(
                                                  busBookingReportData
                                                      .picktupTime
                                                      .toString()),
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start))
                                ],
                              ),
                              height(1.h),
                              detailSection(
                                sectionTitle: "Fare",
                                crossAxisAlignment: CrossAxisAlignment.start,
                                valueStyle: TextHelper.size13.copyWith(
                                    color: ColorsForApp.flightOrangeColor,
                                    fontFamily: boldNunitoFont),
                                sectionValue: busBookingReportData.fare != null
                                    ? '₹ ${busBookingReportData.fare.toString()}'
                                    : 'NA',
                              ),
                              Divider(
                                color:
                                    ColorsForApp.grayScale500.withOpacity(0.5),
                              ),
                              height(1.h),
                              Visibility(
                                visible: busBookingController.busTicketStatus(
                                                busBookingReportData.status!) ==
                                            "PendingCancelled" ||
                                        busBookingController.busTicketStatus(
                                                busBookingReportData.status!) ==
                                            "Cancelled" ||
                                        busBookingController.busTicketStatus(
                                                busBookingReportData.status!) ==
                                            "PartialCancel"
                                    ? true
                                    : false,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Cancellation details',
                                        style: TextHelper.size14.copyWith(
                                            fontFamily: boldNunitoFont,
                                            color: ColorsForApp.primaryColor)),
                                    height(0.5.h),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: detailSection(
                                          sectionTitle: "Cancellation charge",
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          sectionValue: busBookingReportData
                                                      .cancellationCharge !=
                                                  null
                                              ? '₹ ${busBookingReportData.cancellationCharge.toString()}'
                                              : 'NA',
                                        )),
                                        Expanded(
                                            child: detailSection(
                                          sectionTitle: "Cancellation date",
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          sectionValue: busBookingReportData
                                                      .cancellationDate !=
                                                  null
                                              ? busBookingController
                                                  .formatDateTime(
                                                      dateTimeFormat: 'yMMMd',
                                                      dateTimeString:
                                                          busBookingReportData
                                                              .cancellationDate
                                                              .toString())
                                              : 'NA',
                                        )),
                                      ],
                                    ),
                                    height(0.5.h),
                                    detailSection(
                                      sectionTitle: "Refund amount",
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      sectionValue:
                                          '₹ ${busBookingReportData.refundAmount ?? 'NA'}',
                                    ),
                                    Divider(
                                      color: ColorsForApp.grayScale500
                                          .withOpacity(0.5),
                                    ),
                                  ],
                                ),
                              ),
                              height(1.h),
                              Obx(
                                () => ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (ctx, index) {
                                      return passengerDetails(
                                          partialBusPassengersDetailData:
                                              busBookingController
                                                  .busPassengersList[index]);
                                    },
                                    separatorBuilder: (context, index) =>
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1.h),
                                          child: LayoutBuilder(
                                              builder: (context, size) {
                                            return Dash(
                                              length: size.maxWidth,
                                              dashColor:
                                                  ColorsForApp.grayScale500,
                                            );
                                          }),
                                        ),
                                    itemCount: busBookingController
                                        .busPassengersList.length),
                              ),
                              height(3.h),
                              Visibility(
                                 visible: busBookingController.busTicketStatus(
                                  busBookingReportData.status!) ==
                                  'Booked'
                                  ? true
                                  : false,
                                child: GestureDetector(
                                  onTap: (){
                                    busBookingReportData.cancellationPolicy !=null && busBookingReportData.cancellationPolicy.toString().isNotEmpty?
                                    cancellationPolicy():errorSnackBar(message: 'Cancellation info not found for this ticket');
                                  },
                                  child: SizedBox(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Cancellation policy',
                                          style: TextHelper.size13.copyWith(
                                            fontFamily: boldNunitoFont,
                                            color: ColorsForApp.lightBlackColor,
                                          ),
                                        ),
                                        width(0.5.h),
                                         const Icon(Icons.info_outline,size: 15,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              height(1.h),
                              Visibility(
                                  visible: busBookingController.busTicketStatus(busBookingReportData.status!) == "Booked" ||
                                          busBookingController.busTicketStatus(
                                                  busBookingReportData
                                                      .status!) ==
                                              "PartialCancel",
                                  child: CommonButton(
                                    onPressed: () {
                                      fullBookingCancellationDialog(
                                          uniqueId: busBookingReportData.unqID
                                              .toString(),
                                          seatNumber: '',
                                          isPartial: false);
                                    },
                                    label: "Cancel ticket",
                                    bgColor: Colors.redAccent,
                                  ),
                                ),
                              height(3.h),
                            ],
                          ),
                        ),
                        //height(1.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget appBar() {
    return Container(
      decoration: BoxDecoration(
        color: ColorsForApp.whiteColor,
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            Assets.imagesFlightTopBgImage,
          ),
        ),
      ),
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Icon(
                  Icons.arrow_back,
                  color: ColorsForApp.whiteColor,
                ),
              ),
            ),
            title: Text(
              'Bus Ticket',
              style: TextHelper.size18.copyWith(
                color: ColorsForApp.whiteColor,
                fontFamily: regularNunitoFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ],
      ),
    );
  }

  Widget passengerDetails(
          {required BusBookingPassengersDetailData
              partialBusPassengersDetailData}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(partialBusPassengersDetailData.name ?? 'NA',
                        style: TextHelper.size12.copyWith(
                            fontFamily: boldNunitoFont,
                            color: ColorsForApp.primaryColor)),
                    Row(
                      children: [
                        detailSection(
                            isHorizontal: true,
                            sectionTitle: "Age: ",
                            sectionValue: partialBusPassengersDetailData.age !=
                                    null
                                ? '${partialBusPassengersDetailData.age.toString()} years'
                                : 'NA',
                            valueStyle: TextHelper.size12.copyWith(
                                fontFamily: boldNunitoFont,
                                color: ColorsForApp.primaryColor)),
                        width(3.w),
                        detailSection(
                            isHorizontal: true,
                            sectionTitle: "Seat: ",
                            sectionValue:
                                partialBusPassengersDetailData.seatNumber ??
                                    'NA',
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            valueStyle: TextHelper.size12.copyWith(
                                fontFamily: boldNunitoFont,
                                color: ColorsForApp.flightOrangeColor)),
                        width(3.w),
                        detailSection(
                            isHorizontal: true,
                            sectionTitle: "Gender: ",
                            sectionValue:
                                partialBusPassengersDetailData.gender ?? 'NA',
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            valueStyle: TextHelper.size12.copyWith(
                                fontFamily: boldNunitoFont,
                                color: ColorsForApp.primaryColor)),
                      ],
                    ),
                  ],
                ),
              ),
              busBookingReportData.partialCancellable == true &&
                      busBookingController.busTicketStatus(
                              partialBusPassengersDetailData.status!) ==
                          "Booked"
                  ? Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.green,
                                  strokeAlign: BorderSide.strokeAlignInside)),
                          padding: EdgeInsets.all(1.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 12.sp,
                              ),
                              width(1.w),
                              Text(
                                "Booked",
                                style: TextHelper.size12.copyWith(
                                    fontFamily: regularNunitoFont,
                                    color: Colors.green),
                              ),
                            ],
                          ),
                        ),
                        height(1.h),
                        InkWell(
                          onTap: () {
                            fullBookingCancellationDialog(
                                uniqueId: busBookingReportData.unqID.toString(),
                                seatNumber: partialBusPassengersDetailData
                                    .seatNumber
                                    .toString(),
                                isPartial: busBookingController
                                    .isBookedMultiple.value);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.all(1.w),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.cancel,
                                  color: ColorsForApp.whiteColor,
                                  size: 12.sp,
                                ),
                                width(1.w),
                                Text(
                                  busBookingController.isBookedMultiple.value
                                      ? "Cancel"
                                      : "Full Cancel",
                                  style: TextHelper.size12.copyWith(
                                      fontFamily: regularNunitoFont,
                                      color: ColorsForApp.whiteColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : busBookingController.busTicketStatus(
                              partialBusPassengersDetailData.status!) ==
                          "Cancelled"
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1,
                                  color: Colors.redAccent,
                                  strokeAlign: BorderSide.strokeAlignInside)),
                          padding: EdgeInsets.all(1.w),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.xmark,
                                color: Colors.redAccent,
                                size: 12.sp,
                              ),
                              width(1.w),
                              Text(
                                "Cancelled",
                                style: TextHelper.size12.copyWith(
                                    fontFamily: regularNunitoFont,
                                    color: Colors.redAccent),
                              ),
                            ],
                          ),
                        )
                      : busBookingController.busTicketStatus(
                                  partialBusPassengersDetailData.status!) ==
                              "Booked"
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.green,
                                      strokeAlign:
                                          BorderSide.strokeAlignInside)),
                              padding: EdgeInsets.all(1.w),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 12.sp,
                                  ),
                                  width(1.w),
                                  Text(
                                    "Booked",
                                    style: TextHelper.size12.copyWith(
                                        fontFamily: regularNunitoFont,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.redAccent,
                                      strokeAlign:
                                          BorderSide.strokeAlignInside)),
                              padding: EdgeInsets.all(1.w),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.xmark,
                                    color: Colors.deepOrange,
                                    size: 12.sp,
                                  ),
                                  width(1.w),
                                  Text(
                                    "Pending",
                                    style: TextHelper.size12.copyWith(
                                        fontFamily: regularNunitoFont,
                                        color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            )
            ],
          ),
          // height(1.h),
        ],
      );

  Widget locationDetails(
      {required String location,
      required String address,
      TextAlign? crossAxisAlignment}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          location,
          textAlign: crossAxisAlignment,
          style: TextHelper.size16.copyWith(
              fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
        ),
        Text(address,
            textAlign: crossAxisAlignment,
            style: TextHelper.size12.copyWith(
                fontFamily: mediumNunitoFont,
                color: ColorsForApp.primaryColor.withOpacity(0.5))),
      ],
    );
  }

  Widget detailSection(
          {required String sectionTitle,
          required String sectionValue,
          TextStyle? valueStyle,
          CrossAxisAlignment? crossAxisAlignment,
          isHorizontal = false}) =>
      isHorizontal
          ? Row(
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.center,
              children: [
                Text(
                  sectionTitle,
                  style: TextHelper.size11.copyWith(
                      fontFamily: regularNunitoFont,
                      color: ColorsForApp.primaryColor.withOpacity(0.5)),
                ),
                // height(0.5.h),
                Text(
                  sectionValue,
                  style: valueStyle ??
                      TextHelper.size12.copyWith(
                          fontFamily: boldNunitoFont,
                          color: ColorsForApp.primaryColor),
                ),
              ],
            )
          : Column(
              crossAxisAlignment:
                  crossAxisAlignment ?? CrossAxisAlignment.center,
              children: [
                Text(
                  sectionTitle,
                  style: TextHelper.size11.copyWith(
                      fontFamily: regularNunitoFont,
                      color: ColorsForApp.primaryColor.withOpacity(0.5)),
                ),
                // height(0.5.h),
                Text(
                  sectionValue,
                  style: valueStyle ??
                      TextHelper.size12.copyWith(
                          fontFamily: boldNunitoFont,
                          color: ColorsForApp.primaryColor),
                ),
              ],
            );

  fullBookingCancellationDialog(
      {required String uniqueId,
      required String seatNumber,
      required bool isPartial}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Text(
            'Cancel Ticket',
            style: TextHelper.size20.copyWith(
              fontFamily: mediumGoogleSansFont,
            ),
          ),
          content: Text(
            'Are you sure you want to cancel ticket?',
            style: TextHelper.size14.copyWith(
              color: ColorsForApp.lightBlackColor.withOpacity(0.7),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
              child: InkWell(
                onTap: () async {
                  Get.back();
                },
                splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    'Cancel',
                    style: TextHelper.size14.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.primaryColorBlue,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
              child: InkWell(
                onTap: () async {
                  Get.back();
                  showProgressIndicator();

                  bool result = isPartial ? await busBookingController.partialBusBookingCancel(
                          uniqueId: uniqueId,
                          id: seatNumber,
                          isLoaderShow: false)
                      : await busBookingController.fullBusBookingCancel(
                          uniqueId: uniqueId, isLoaderShow: false);
                  dismissProgressIndicator();
                  if (result) {
                    Get.back();
                    busBookingController.getBusBookingReportApi(pageNumber: 1, isLoaderShow: true);
                  }
                },
                splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    'Confirm',
                    style: TextHelper.size14.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.primaryColorBlue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  cancellationPolicy() => customBottomSheet(
    children: [
      cancellationPolicyTable()
    ],
    mainAxisAlignment: MainAxisAlignment.start,
  );

  //cancellation policy table
  Widget cancellationPolicyTable() {
    List<Map<String, dynamic>> policyList = parseCancellationPolicy(busBookingReportData.cancellationPolicy !=null && busBookingReportData.cancellationPolicy.toString().isNotEmpty ?busBookingReportData.cancellationPolicy.toString():'');
    return
      Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: ColorsForApp.lightGreyColor)),
        child:  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DataTable(
              dividerThickness: 1 ,
              columns: const [
                DataColumn(label: Expanded(child: Text('Time before Travel',style: TextStyle(color: Colors.black,fontFamily: extraBoldNunitoFont,fontSize: 14),))),
                DataColumn(label: Expanded(child: Text('Cancellation \nRate',textAlign:TextAlign.center,style: TextStyle(color: Colors.black,fontFamily: extraBoldNunitoFont,fontSize: 14),))),
              ],
              rows: policyList.map((policy) {
                return DataRow(
                  cells: [
                    DataCell(Center(child: Text(policy['Time before Travel'],style: TextHelper.size13.copyWith(color: ColorsForApp.blackColor,fontFamily: regularNunitoFont),))),
                    DataCell(Center(child: Text(policy['Percentage'],style: TextHelper.size13.copyWith(color: ColorsForApp.blackColor,fontFamily: regularNunitoFont),))),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      );
  }
  //Varies Cancellation policy
  List<Map<String, dynamic>> parseCancellationPolicy(String policyString) {
    List<Map<String, dynamic>> policyList = [];
    List<String> policies = policyString.split(';');
    String currentTime = "${busBookingReportData.doj.toString()}  ${busBookingController.convertMinutesToHours(busBookingReportData.picktupTime.toString())}";

    if(policies.isNotEmpty){
      for (var policy in policies) {
        List<String> policyDetails = policy.split(':');

        if(policyDetails[1]=="-1") {
          hours = int.parse(policyDetails[0]);

          Map<String, dynamic> policyMap = {
            'Time before Travel': 'Before $hours hours \n$currentTime',
            'Percentage': '${policyDetails[2]} %',
          };
          policyList.add(policyMap);
        }else if(policyDetails[0]=="0"){
          hours = int.parse(policyDetails[1]) - int.parse(policyDetails[0]);
          Map<String, dynamic> policyMap = {
            'Time before Travel': '$hours hours Before \n$currentTime',
            'Percentage': '${policyDetails[2]} %',
          };
          policyList.add(policyMap);
        }else{
          Map<String, dynamic> policyMap = {
            'Time before Travel': '${policyDetails[0]} To ${policyDetails[1]} hours Before \n$currentTime',
            'Percentage': '${policyDetails[2]} %',
          };
          policyList.add(policyMap);
        }
      }
    }else{
      Map<String, dynamic> policyMap = {
        'Time before Travel': 'Not Available',
        'Percentage': 'Not Available',
      };
      policyList.add(policyMap);
    }
    return policyList;
  }

}

Path getPath(double width, double height) {
  final cut = width * 0.05;
  Path path = Path()..lineTo(0, height);
  for (int i = 1; i <= 20; i++) {
    if (i % 2 == 0) {
      path.lineTo(cut * i, height);
    } else {
      path.lineTo(cut * i, height - cut);
    }
  }
  path.lineTo(width, 0);
  return path;
}

class CardShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => getPath(size.width, size.height);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class CardShadow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawShadow(getPath(size.width, size.height), Colors.black, 5, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/bus_booking_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/bus/bus_bpdp_details_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';

class BoardingDroppingScreen extends StatefulWidget {
  const BoardingDroppingScreen({super.key});

  @override
  State<BoardingDroppingScreen> createState() => _BoardingDroppingScreenState();
}

class _BoardingDroppingScreenState extends State<BoardingDroppingScreen> {
  final BusBookingController busBookingController = Get.find();
  final List tabSections = ["Boarding Points", "Dropping Points"];
  final String tripId = Get.arguments ?? '';

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      busBookingController.selectedTab.value = 0;
      busBookingController.boardingPointList.clear();
      busBookingController.droppingPointList.clear();
      busBookingController.boardingLocation = BoardingPoints().obs;
      busBookingController.droppingLocation = BoardingPoints().obs;
      busBookingController.selectedBoardingPoint = ''.obs;
      busBookingController.selectedDroppingPoint = ''.obs;
      await busBookingController.getBpDpPointList(isLoaderShow: false);
      // dateOfBoarding = DateTime.parse(busBookingController.dateOfJourney.toString());
      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Boarding & Dropping points",
      appBarTextStyle: TextHelper.size18.copyWith(
        color: ColorsForApp.whiteColor,
        fontFamily: mediumNunitoFont,
      ),
      appBarBgImage: Assets.imagesFlightTopBgImage,
      appBarHeight: 28.h,
      isShowLeadingIcon: true,
      leadingIconColor: ColorsForApp.whiteColor,
      mainBody: Container(
        color: ColorsForApp.busBgColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => Row(
                children: List.generate(
                    tabSections.length,
                    (index) => Expanded(
                            child: InkWell(
                          onTap: () {
                            if (index == 1 && busBookingController.boardingLocation!.value.id == null) {
                              errorSnackBar(message: 'Please select boarding point first');
                            } else {
                              busBookingController.selectedTab.value = index;
                            }
                          },
                          child: tabSection(
                              label: tabSections[index],
                              selectedPoint: '',
                              //selectedPoint: index == 0 ? busBookingController.selectedBoardingPoint.value : busBookingController.selectedDroppingPoint.value,
                              isSelected: index == busBookingController.selectedTab.value),
                        ))).toList(),
              ),
            ),
            height(1.h),
            Expanded(
              child: Obx(
                () => busBookingController.selectedTab.value == 0 ? boardingTab() : droppingTab(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget boardingTab() => pointSelectionContainer(
      label: "All boarding points from ${busBookingController.fromLocationTxtController.text}",
      data: busBookingController.boardingPointList,
      onSelection: (value) {
        busBookingController.boardingLocation = value;
        busBookingController.selectedTab.value = 1;
      },
      selectedLocation: busBookingController.boardingLocation);

  Widget droppingTab() => pointSelectionContainer(
      label: "All dropping points to ${busBookingController.toLocationTxtController.text}",
      data: busBookingController.droppingPointList,
      onSelection: (value) {
        busBookingController.droppingLocation = value;
        bpDpConfirmation();
      },
      selectedLocation: busBookingController.droppingLocation);

  Widget pointSelectionContainer({required String label, required List<BoardingPoints> data, required Function(Rx<BoardingPoints>) onSelection, required Rx<BoardingPoints>? selectedLocation}) => Obx(
        () => Container(
          decoration: BoxDecoration(
            color: ColorsForApp.whiteColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                offset: const Offset(3, 3),
                blurStyle: BlurStyle.normal,
                blurRadius: 5,
                color: ColorsForApp.grayScale500,
              )
            ],
          ),
          clipBehavior: Clip.hardEdge,
          // padding: EdgeInsets.all(2.w),
          margin: EdgeInsets.all(3.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w).add(EdgeInsets.only(top: 3.w)),
                child: Text(
                  label,
                  style: TextHelper.size14.copyWith(fontFamily: boldNunitoFont, color: ColorsForApp.primaryColor),
                ),
              ),
              height(1.h),
              const Divider(
                height: 1,
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (c, i) => InkWell(
                      onTap: () {
                        setState(() {
                          onSelection(data[i].obs);
                          /*  busBookingController.selectedTab.value == 1 ?
                      busBookingController.selectedBoardingPoint.value= data[i].name.toString():
                      busBookingController.selectedTab.value == 0 ? busBookingController.selectedDroppingPoint.value= data[i].name.toString():'s';*/
                        });
                      },
                      child: stopSelectors(location: data[i], selectedLocation: (selectedLocation != null ? (selectedLocation.value.landmark == data[i].landmark!.toString()) : false).obs)),
                  separatorBuilder: (BuildContext context, int index) => const Divider(
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget stopSelectors({required BoardingPoints location, required RxBool selectedLocation}) => Container(
        padding: EdgeInsets.all(2.w),
        // color: Colors.red,
        decoration: selectedLocation.value
            ? BoxDecoration(
                gradient: LinearGradient(
                  stops: const [0.7, 1],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white,
                    Colors.grey.withOpacity(0.2),
                  ],
                ),
              )
            : const BoxDecoration(),
        child: Row(
          children: [
            Column(
              children: [
                CircleAvatar(
                  backgroundColor: ColorsForApp.primaryShadeColor.withOpacity(0.6),
                  radius: 5.w,
                  child: const Icon(
                    Icons.location_pin,
                    size: 17,
                  ),
                ),
              ],
            ),
            width(4.w),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name!.toString(),
                  style: TextHelper.size15.copyWith(
                    fontFamily: extraBoldNunitoFont,
                  ),
                ),
                Text(
                  location.address!.toString(),
                  style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.blackColor),
                ),
                Text(
                  "Contacts - ${location.contactNumber!.toString()}",
                  style: TextHelper.size11.copyWith(
                    fontFamily: regularNunitoFont,
                  ),
                ),
              ],
            )),
            //Radio(value: location.name!.toString(), groupValue: selectedLocation, onChanged: onSelect),
          ],
        ),
      );

  Widget tabSection({required String label, required String selectedPoint, required bool isSelected}) => Container(
        height: 7.5.h,
        decoration: BoxDecoration(
            border: isSelected
                ? Border(
                    bottom: BorderSide(color: ColorsForApp.primaryColor, width: 2.5),
                  )
                : Border(
                    bottom: BorderSide(color: ColorsForApp.grayScale500),
                  )),
        child: Center(
            child: Text(
          label,
          style: TextHelper.size15.copyWith(fontFamily: isSelected ? boldNunitoFont : regularNunitoFont),
        )),
      );

  bpDpConfirmation() => customBottomSheet(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "Boarding & dropping confirmation",
                  style: TextHelper.size15.copyWith(fontFamily: boldNunitoFont),
                ),
              ),
              SizedBox(
                height: 40,
                width: 30,
                child: Center(
                  child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.close,
                        color: ColorsForApp.lightBlackColor,
                      )),
                ),
              ),
            ],
          ),
          height(0.5.h),
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Are you sure you want to travel from',
                    style: TextHelper.size14.copyWith(
                      fontFamily: regularNunitoFont,
                      color: ColorsForApp.lightBlackColor,
                    ),
                    children: [
                      TextSpan(
                        text: ' ${busBookingController.boardingLocation!.value.landmark}, ${busBookingController.boardingLocation!.value.name}',
                        style: TextHelper.size14.copyWith(fontFamily: boldNunitoFont),
                      ),
                      TextSpan(
                        text: ' to ',
                        style: TextHelper.size14.copyWith(
                          fontFamily: regularNunitoFont,
                          color: ColorsForApp.lightBlackColor,
                        ),
                      ),
                      TextSpan(
                        text: '${busBookingController.droppingLocation!.value.landmark}, ${busBookingController.droppingLocation!.value.name}',
                        style: TextHelper.size14.copyWith(fontFamily: boldNunitoFont),
                      ),
                      TextSpan(
                        text: ' ?',
                        style: TextHelper.size14.copyWith(
                          fontFamily: regularNunitoFont,
                          color: ColorsForApp.lightBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          height(1.h),
          CommonButton(
            width: 100.w,
            onPressed: () {
              Get.toNamed(Routes.BUS_PASSENGER_INFO_SCREEN);
            },
            label: "Continue",
            style: TextHelper.size14.copyWith(color: ColorsForApp.whiteColor, fontFamily: boldNunitoFont),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.start,
      );
}

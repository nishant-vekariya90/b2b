import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/bus_booking_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/custom_scaffold.dart';

class BusFilterSortingScreen extends StatefulWidget {
  const BusFilterSortingScreen({super.key});

  @override
  State<BusFilterSortingScreen> createState() => _BusFilterSortingScreenState();
}

class _BusFilterSortingScreenState extends State<BusFilterSortingScreen> {
  final BusBookingController busBookingController = Get.find();
  // Selecting both filters
  bool filterAM = true; // To filter data between 00:00 AM to 06:00 AM
  bool filterPM = true;

  @override
  void initState() {
    super.initState();
    // callAsyncApi();
  }

  // Future<void> callAsyncApi() async {
  //   try {
  //     showProgressIndicator();
  //     await busBookingController.getAvailableBusList(isLoaderShow: false);
  //     dismissProgressIndicator();
  //   } catch (e) {
  //     dismissProgressIndicator();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      onBackIconTap: () {
        busBookingController.resetAll();
        // busBookingController.processQueue.clear();
        Get.back();
      },
      title: "Filter Buses",
      appBarTextStyle: TextHelper.size18.copyWith(
        color: ColorsForApp.whiteColor,
        fontFamily: mediumNunitoFont,
      ),
      appBarBgImage: Assets.imagesFlightTopBgImage,
      appBarHeight: 28.h,
      isShowLeadingIcon: true,
      leadingIconColor: ColorsForApp.whiteColor,
      mainBody: Row(
        children: [
          Expanded(
            child: Container(
              color: ColorsForApp.primaryShadeColor,
              child: ListView.separated(
                itemCount: busBookingController.filterMethods.length,
                itemBuilder: (ctx, index) => Obx(
                  () => tabSection(
                      isSelected: busBookingController.selectedTabIndex.value == index,
                      onTap: () {
                        busBookingController.selectedTabIndex.value = index;
                      },
                      label: busBookingController.filterMethods[index]),
                ),
                separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 1,
                  color: ColorsForApp.grayScale500.withOpacity(0.5),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: ColorsForApp.whiteColor,
              padding: EdgeInsets.only(top: 1.h),
              child: Obx(() => tabSwitch()),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(offset: const Offset(0, -1), blurRadius: 3, blurStyle: BlurStyle.normal, color: ColorsForApp.grayScale500)
        ], color: ColorsForApp.whiteColor),
        padding: const EdgeInsets.all(5),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(1.5.w),
                child: CommonButton(
                  onPressed: () {
                    Get.back();
                    busBookingController.resetAll();
                  },
                  label: 'Clear All',
                  style: TextHelper.size12.copyWith(color: ColorsForApp.lightBlackColor, fontFamily: mediumNunitoFont),
                  bgColor: ColorsForApp.whiteColor,
                  border: Border.all(color: ColorsForApp.lightBlackColor),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: CommonButton(
                onPressed: () {
                  busBookingController.applyFilters();
                  // busBookingController.queueProcess();
                  Get.back();
                },
                style: TextHelper.size14.copyWith(color: ColorsForApp.whiteColor, fontFamily: mediumNunitoFont),
                label: 'Apply',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabSwitch() {
    switch (busBookingController.selectedTabIndex.value) {
      case 0:
        return sortBy();
      case 1:
        return busDepartureTime();
      case 2:
        return busArriveTime();
      case 3:
        return busType();

      case 4:
        busBookingController.searchController.clear();
        busBookingController.searchField.value = "";
        return busOperator();

      // case 5:
      //   busBookingController.searchController.clear();
      //   busBookingController.searchField.value = "";
      //   return boardingPoint();
      // case 6:
      //   busBookingController.searchController.clear();
      //   busBookingController.searchField.value = "";
      //   return droppingPoint();

      // case 7:
      //   busBookingController.searchController.clear();
      //   busBookingController.searchField.value = "";
      //   return busFacility();
      // case 8:
      //   return busFeatures();
      //
      // case 9:
      //   return rtcBusType();
    }
    return const Center(child: CircularProgressIndicator());
  }

  Widget sortBy() => ListView.builder(
        itemCount: busBookingController.sortMethods.length,
        itemBuilder: (context, index) => Row(
          children: [
            Obx(
              () => Radio(
                  activeColor: ColorsForApp.primaryColor,
                  value: busBookingController.sortMethods[index],
                  groupValue: busBookingController.selectedSortingMethod.value,
                  onChanged: (value) {
                    busBookingController.selectedSortingMethod.value = value;
                  }),
              // (value) => busBookingController.processQueue.add(() {
              // busBookingController.selectedSortingMethod.value = value;
              // }))
            ),
            Text(
              busBookingController.sortMethods[index],
              style: TextHelper.size13.copyWith(color: ColorsForApp.primaryColor.withOpacity(0.75), fontFamily: mediumNunitoFont),
            ),
          ],
        ),
      );

  Widget busDepartureTime() => ListView.builder(
        // shrinkWrap: true,
        itemCount: busBookingController.time.length,
        itemBuilder: (context, index) => Obx(() {
          bool isSelected =
              busBookingController.isSelected(busBookingController.selectedDepartTime, busBookingController.time[index]['name']);
          return customCheckBoxTile(
              value: isSelected,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    busBookingController.time[index]['name'],
                    style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont),
                  ),
                  Text(
                    busBookingController.time[index]['desc'],
                    style:
                        TextHelper.size11.copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.primaryColor.withOpacity(0.5)),
                  ),
                ],
              ),
              icon: Icon(
                Icons.sunny,
                size: 14.sp,
                color: ColorsForApp.primaryColor.withOpacity(0.75),
              ),
              onChanged: (value) {
                if (value!) {
                  busBookingController.addInList(busBookingController.selectedDepartTime, busBookingController.time[index]['name']);
                } else {
                  busBookingController.removeFromList(
                      busBookingController.selectedDepartTime, busBookingController.time[index]['name']);
                }
              });
        }),
      );

  Widget busType() => ListView.builder(
        // shrinkWrap: true,
        itemCount: busBookingController.busFeatures.length,
        itemBuilder: (context, index) => Obx(() {
          bool isSelected =
              busBookingController.isSelected(busBookingController.selectedFilters, busBookingController.busFeatures[index]);
          return customCheckBoxTile(
            title: Text(
              busBookingController.busFeatures[index],
              style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont),
            ),
            icon: Icon(
              Icons.event_seat,
              size: 14.sp,
              color: ColorsForApp.primaryColor.withOpacity(0.75),
            ),
            value: isSelected,
            onChanged: (value) {
              busBookingController.toggleFilter(busBookingController.busFeatures[index]);
              // busBookingController.selectedFilters.contains(value);
            },
          );
        }),
      );

  // Widget boardingPoint() => Column(
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.all(2.w),
  //           child: Obx(
  //             () => searchBar(
  //               onChange: (value) => busBookingController.searchField.value = value.toLowerCase(),
  //               controller: busBookingController.searchController,
  //               showClear: busBookingController.searchField.isEmpty,
  //               onClear: () {
  //                 busBookingController.searchField.value = "";
  //                 busBookingController.searchController.clear();
  //               },
  //             ),
  //           ),
  //         ),
  //         Obx(
  //           () {
  //             // List<BoardingPoints> filteredPoints = busBookingController.boardingPointList.where((point) => point.name.toString().toLowerCase().contains(busBookingController.searchField.value)).toList();
  //
  //             debugPrint("Boarding Points =>${busBookingController.boardingPointList.length}");
  //
  //             return ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: busBookingController.boardingPointList.length,
  //               itemBuilder: (context, index) => Obx(() {
  //                 final availableTrips = busBookingController.boardingPointList[index];
  //                 bool isSelected =
  //                     busBookingController.isSelected(busBookingController.selectedBoardingPoints, availableTrips.name.toString());
  //                 return customCheckBoxTile(
  //                   title: Text(
  //                     availableTrips.name.toString(),
  //                     style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont),
  //                   ),
  //                   value: isSelected,
  //                   onChanged: (value) {
  //                     busBookingController.toggleFilter(availableTrips.name.toString());
  //                   },
  //                 );
  //               }),
  //             );
  //           },
  //         ),
  //       ],
  //     );
  // Widget droppingPoint() => Column(
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.all(2.w),
  //           child: Obx(
  //             () => searchBar(
  //               onChange: (value) => busBookingController.searchField.value = value.toLowerCase(),
  //               controller: busBookingController.searchController,
  //               showClear: busBookingController.searchField.isEmpty,
  //               onClear: () {
  //                 busBookingController.searchField.value = "";
  //                 busBookingController.searchController.clear();
  //               },
  //             ),
  //           ),
  //         ),
  //         Obx(
  //           () {
  //             List<Map<String, dynamic>> filteredPoints = busBookingController.droppingPoints
  //                 .where((point) => point['name'].toLowerCase().contains(busBookingController.searchField.value))
  //                 .toList();
  //             return ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: filteredPoints.length,
  //               itemBuilder: (context, index) => Obx(() {
  //                 bool isSelected =
  //                     busBookingController.isSelected(busBookingController.selectedDroppingPoints, filteredPoints[index]['name']);
  //                 return customCheckBoxTile(
  //                   title: Text(
  //                     filteredPoints[index]['name'],
  //                     style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont),
  //                   ),
  //                   value: isSelected,
  //                   onChanged: (value) {
  //                     if (value!) {
  //                       busBookingController.addInList(busBookingController.selectedDroppingPoints, filteredPoints[index]['name']);
  //                     } else {
  //                       busBookingController.removeFromList(
  //                           busBookingController.selectedDroppingPoints, filteredPoints[index]['name']);
  //                     }
  //                   },
  //                 );
  //               }),
  //             );
  //           },
  //         ),
  //       ],
  //     );

  Widget busOperator() => Column(
        children: [
          Padding(
            padding: EdgeInsets.all(2.w),
            child: Obx(
              () => searchBar(
                onChange: (value) => busBookingController.searchField.value = value.toLowerCase(),
                controller: busBookingController.searchController,
                showClear: busBookingController.searchField.isEmpty,
                onClear: () {
                  busBookingController.searchField.value = "";
                  busBookingController.searchController.clear();
                },
              ),
            ),
          ),
          Obx(() {
            // Extract travel names and remove duplicates
            List<String> uniqueTravelNames = [];
            for (var trip in busBookingController.availableTrips) {
              if (!uniqueTravelNames.contains(trip.travels.toString())) {
                uniqueTravelNames.add(trip.travels.toString());
              }
            }
            List filteredPoints = uniqueTravelNames
                .where((point) => point.toString().toLowerCase().contains(busBookingController.searchField.value))
                .toSet()
                .toList();
            return Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                itemCount: filteredPoints.length,
                itemBuilder: (context, index) => Obx(() {
                  final availableTrips = filteredPoints[index];
                  bool isSelected = busBookingController.isSelected(busBookingController.selectedBusOperators, availableTrips);
                  return customCheckBoxTile(
                    title: Text(
                      availableTrips,
                      style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont),
                    ),
                    value: isSelected,
                    onChanged: (value) {
                      if (value!) {
                        busBookingController.addInList(busBookingController.selectedBusOperators, availableTrips);
                        busBookingController.busTravelName.value = availableTrips;
                      } else {
                        busBookingController.removeFromList(busBookingController.selectedBusOperators, availableTrips);
                      }
                    },
                  );
                }),
                separatorBuilder: (BuildContext context, int index) {
                  return height(0.5.h);
                },
              ),
            );
          }),
        ],
      );

  // Widget busFacility() => Column(
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.all(2.w),
  //           child: Obx(
  //             () => searchBar(
  //               onChange: (value) => busBookingController.searchField.value =
  //                   value.toLowerCase(),
  //               controller: busBookingController.searchController,
  //               showClear: busBookingController.searchField.isEmpty,
  //               onClear: () {
  //                 busBookingController.searchField.value = "";
  //                 busBookingController.searchController.clear();
  //               },
  //             ),
  //           ),
  //         ),
  //         Obx(
  //           () {
  //             List filteredPoints = busBookingController.busFacilities.where((point) => point.toLowerCase().contains(busBookingController.searchField.value)).toList();
  //             return ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: filteredPoints.length,
  //               itemBuilder: (context, index) => Obx(() {
  //                 bool isSelected = busBookingController.isSelected(
  //                     busBookingController.selectedBusFacilities,
  //                     filteredPoints[index]);
  //                 return customCheckBoxTile(
  //                   title: Text(
  //                     filteredPoints[index],
  //                     style: TextHelper.size13
  //                         .copyWith(fontFamily: regularNunitoFont),
  //                   ),
  //                   value: isSelected,
  //                   onChanged: (value) {
  //                     if (value!) {
  //                       busBookingController.addInList(
  //                           busBookingController.selectedBusFacilities,
  //                           filteredPoints[index]);
  //                     } else {
  //                       busBookingController.removeFromList(
  //                           busBookingController.selectedBusFacilities,
  //                           filteredPoints[index]);
  //                     }
  //                   },
  //                 );
  //               }),
  //             );
  //           },
  //         ),
  //       ],
  //     );

  // Widget busFeatures() => ListView.builder(
  //       itemCount: busBookingController.busFeatures.length,
  //       itemBuilder: (context, index) => Obx(() {
  //         bool isSelected =
  //             busBookingController.isSelected(busBookingController.selectedFilters, busBookingController.busFeatures[index]);
  //         return customCheckBoxTile(
  //           title: Text(
  //             busBookingController.busFeatures[index],
  //             style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont),
  //           ),
  //           value: isSelected,
  //           onChanged: (value) {
  //             if (value!) {
  //               busBookingController.addInList(busBookingController.selectedFilters, busBookingController.busFeatures[index]);
  //             } else {
  //               busBookingController.removeFromList(busBookingController.selectedFilters, busBookingController.busFeatures[index]);
  //             }
  //           },
  //         );
  //       }),
  //     );

  Widget busArriveTime() => ListView.builder(
        // shrinkWrap: true,
        itemCount: busBookingController.time.length,
        itemBuilder: (context, index) => Obx(() {
          bool isSelected =
              busBookingController.isSelected(busBookingController.selectedArriveTime, busBookingController.time[index]['name']);
          return customCheckBoxTile(
              value: isSelected,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    busBookingController.time[index]['name'],
                    style: TextHelper.size13.copyWith(fontFamily: regularNunitoFont),
                  ),
                  Text(
                    busBookingController.time[index]['desc'],
                    style:
                        TextHelper.size11.copyWith(fontFamily: regularNunitoFont, color: ColorsForApp.primaryColor.withOpacity(0.5)),
                  ),
                ],
              ),
              icon: Icon(
                Icons.sunny,
                size: 14.sp,
                color: ColorsForApp.primaryColor.withOpacity(0.75),
              ),
              onChanged: (value) {
                if (value!) {
                  busBookingController.addInList(busBookingController.selectedArriveTime, busBookingController.time[index]['name']);
                } else {
                  busBookingController.removeFromList(
                      busBookingController.selectedArriveTime, busBookingController.time[index]['name']);
                }
              });
        }),
      );

  Widget searchBar(
          {required Function(String) onChange,
          required Function() onClear,
          required TextEditingController controller,
          required bool showClear}) =>
      TextField(
          onChanged: onChange,
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: showClear
                ? Icon(
                    Icons.search_rounded,
                    color: ColorsForApp.primaryColor.withOpacity(0.5),
                  )
                : IconButton(
                    onPressed: onClear,
                    icon: Icon(
                      Icons.clear,
                      color: ColorsForApp.primaryColor.withOpacity(0.5),
                    ),
                  ),
            label: Text(
              "search",
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            filled: true,
            focusColor: Colors.green,
            contentPadding: EdgeInsets.symmetric(horizontal: 5.5.w),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: ColorsForApp.primaryShadeColor,
            enabledBorder:
                OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: const BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50), borderSide: BorderSide(color: ColorsForApp.primaryColor.withOpacity(0.25))),
          ));

  Widget customCheckBoxTile({required bool value, required Widget title, required void Function(bool?) onChanged, Widget? icon}) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
              ),
              child: icon ?? Container(),
            ),
            Expanded(child: title),
            Transform.scale(
              scale: 0.75,
              child: Checkbox(
                value: value,
                // onChanged: (value) => busBookingController.processQueue.add(() => onChanged(value)),
                onChanged: onChanged,
                side: BorderSide(
                  color: ColorsForApp.primaryColor.withOpacity(0.5),
                  width: 2,
                ),
                activeColor: ColorsForApp.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              ),
            )
          ],
        ),
      );

  Widget tabSection({required String label, required bool isSelected, Function()? onTap}) => InkWell(
        onTap: onTap,
        child: Container(
          height: 7.5.h,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(5.w),
            color: isSelected ? ColorsForApp.whiteColor : ColorsForApp.primaryShadeColor,
          ),
          child: Text(
            label,
            style: TextHelper.size12.copyWith(
                fontFamily: isSelected ? mediumNunitoFont : regularNunitoFont,
                color: isSelected ? ColorsForApp.orangeColor : ColorsForApp.lightBlackColor),
          ),
        ),
      );
}

// Class representing a time range
class TimeRange {
  final TimeOfDay minTime;
  final TimeOfDay maxTime;

  TimeRange(this.minTime, this.maxTime);
}

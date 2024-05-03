import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../api/api_manager.dart';
import '../../model/bus/bus_available_trips_model.dart';
import '../../model/bus/bus_book_model.dart';
import '../../model/bus/bus_booking_passengers_detail_model.dart';
import '../../model/bus/bus_booking_report_model.dart';
import '../../model/bus/bus_bpdp_details_model.dart';
import '../../model/bus/bus_from_cities_model.dart';
import '../../model/bus/bus_trip_details_model.dart';
import '../../model/bus/full_bus_booking_cancel_model.dart';
import '../../model/bus/partial_bus_booking_cancel_model.dart';
import '../../model/bus/passenger_info_model.dart';
import '../../model/bus/why_book_model.dart';
import '../../repository/retailer/bus_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class BusBookingController extends GetxController with GetTickerProviderStateMixin {
  BusRepository busRepository = BusRepository(APIManager());

  //Variables for bus home screen
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;
  // Rx<DateTime> fromDate = DateTime.now().obs;
  // Rx<DateTime> toDate = DateTime.now().obs;
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;
  RxString selectedBoardingPoint = ''.obs;
  RxString selectedDroppingPoint = ''.obs;
  TextEditingController fromLocationTxtController = TextEditingController();
  TextEditingController toLocationTxtController = TextEditingController();
  TextEditingController departureDateTxtController = TextEditingController();
  TextEditingController searchTxtController = TextEditingController();
  TextEditingController tPinTxtController = TextEditingController();
  TextEditingController passengerMobileTxtController = TextEditingController();
  TextEditingController passengerEmailTxtController = TextEditingController();
  TextEditingController passengerAddressTxtController = TextEditingController();
  RxInt busBookingStatus = (-1).obs;

  //Variables to show tpin field....
  RxBool isShowTpinField = false.obs;
  RxBool isShowTpin = true.obs;

  //Bus City List, Available Trips List & Model Class Object
  AvailableTrips availableTripsModel = AvailableTrips();
  RxList<BusCities> fromCitiesList = <BusCities>[].obs;
  RxList<AvailableTrips> availableTrips = <AvailableTrips>[].obs;

  //Boarding & Dropping Points List
  RxList<BoardingPoints> boardingPointList = <BoardingPoints>[].obs;
  RxList<BoardingPoints> droppingPointList = <BoardingPoints>[].obs;

  RxList<AvailableTrips> filteredBusList = <AvailableTrips>[].obs;
  RxList<AvailableTrips> searchedList = <AvailableTrips>[].obs;
  Set<String> busOperators = {};

  Rx<String> departureDate = DateFormat("yMMMMd").format(DateTime.now()).obs;
  RxInt selectedDateTab = 0.obs;
  Rx<BusBookModel> busBookModel = BusBookModel().obs;
  List<Map<String, dynamic>> finalBusPassengerList = [];

  //Variables for bus details
  RxString selectedGender = "".obs;
  RxString day = "Wed,".obs;
  RxString date = "20 Mar ".obs;
  RxString restStopTime = "02:00 AM".obs;
  RxString starRating = "4.7".obs;
  RxString ratings = "1427".obs;
  late AnimationController animationController;
  late AnimationController isVisibleController;
  late Animation<double> animation;
  RxBool isVisible = false.obs;
  RxInt tabIndex = 0.obs;
  Rx<BusSeatsModel> selectedSeatData = BusSeatsModel().obs;
  RxList<BusSeatsModel> selectedSeatDataMain = <BusSeatsModel>[].obs;
  RxList<BusSeatsModel> selectedSeatList = <BusSeatsModel>[].obs;
  RxDouble totalFareOfSeats = 0.0.obs;
  RxDouble baseFareOfSeats = 0.0.obs;
  RxDouble taxFareOfSeats = 0.0.obs;

  RxString busTravelName = "".obs;

  //Regex for Aadhaar and PAN
  RegExp aadhaarRegex = RegExp(r'^[2-9]{1}[0-9]{11}$');
  RegExp panRegex = RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]{1}$");
  RxList<BusSeatsModel> seatsDataLower = <BusSeatsModel>[].obs;
  RxList<BusSeatsModel> seatsDataUpper = <BusSeatsModel>[].obs;
  RxInt maxBusColumnLowerCount = 0.obs;
  RxInt maxBusRowLowerCount = 0.obs;

  RxInt maxBusColumnUpperCount = 0.obs;
  RxInt maxBusRowUpperCount = 0.obs;

  RxBool isLowerDeckSelected = true.obs;
  RxBool canLowerDeckSelect = true.obs;
  RxBool isUpperDeckSelected = false.obs;
  RxBool canUpperDeckSelect = false.obs;
  List seatStatusList = [
    "Available",
    "Sleeper",
    "Booked",
    "Selected by you",
    "Available only for female passenger",
    "Blocked by female passenger",
    "Available for male passenger"
  ];
  RxList<WhyBookBusModel> whyBusBookList = <WhyBookBusModel>[].obs;

  List imageDetailsList = [
    "assets/images/busPng.png",
    "assets/images/busPng.png",
    "assets/images/busPng.png",
    "assets/images/busPng.png",
    "assets/images/busPng.png",
  ];
  List<String> busDetailsList = [

  ];
  RxInt selectedBusDetails = 0.obs;
  ItemScrollController itemScrollController = ItemScrollController();
  ItemScrollController itemScrollTabController = ItemScrollController();
  ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  TabController? busBookingTabController;
  TabController? selectSeatTabController;
  TabController? boardingDroppingTabController;
  RxInt currentTabIndex = 0.obs;
  List<Tab> myBookingsStatusTabList = [
    const Tab(text: 'COMPLETED'),
    const Tab(text: 'CANCELLED'),
  ];
  List<Tab> seatsLocationTabList = [
    const Tab(text: 'Upper deck'),
    const Tab(text: 'Lower desk'),
  ];
  List<Tab> boardingDroppingTabList = [
    const Tab(text: 'Boarding'),
    const Tab(text: 'Dropping'),
  ];
  TextEditingController journeyDateController = TextEditingController(text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
  RxInt selectedTab = 0.obs;
  Rx<BoardingPoints>? boardingLocation; // = BoardingPoints();
  Rx<BoardingPoints>? droppingLocation; // = BoardingPoints();
  RxList<Map<String, dynamic>> droppingPoints = [
    {
      "name": "Sangli Station",
      "date": DateTime(2024, 5, 11, 15, 30), // Example date: May 10, 2024
      "address": "Swargate, Pune, Maharashtra, India"
    },
    {
      "name": "Shivajinagar",
      "date": DateTime(2024, 5, 11, 17, 30), // Example date: May 11, 2024
      "address": "Shivajinagar, Pune, Maharashtra, India"
    },
    {
      "name": "Kothrud",
      "date": DateTime(2024, 5, 12, 19, 30), // Example date: May 12, 2024
      "address": "Kothrud, Pune, Maharashtra, India"
    },
  ].obs;

  /// Filter screen
  List<String> filterMethods = [
    "Sort by",
    "Bus departure time from source",
    "Bus arrival time at destination",
    "Bus Type",
    "Bus Operator",
  ];
  RxInt selectedTabIndex = 0.obs;
  List<String> busFeatures = ["Primo bus", "Seater", "AC", "Sleeper", "Non AC"];

  /// Sort ///
  List sortMethods = ["Relevance", "Cheapest", "Early Departure", "Early Arrival"];
  RxString selectedSortingMethod = "Relevance".obs;

  /// Filters ///
  RxList<String> selectedFilters = <String>[].obs;
  List<String> selectedDepartTime = <String>[].obs;
  List<String> selectedArriveTime = <String>[].obs;
  // List<String> selectedBoardingPoints = <String>[].obs;
  // List<String> selectedDroppingPoints = <String>[].obs;
  TextEditingController searchController = TextEditingController();
  TextEditingController busSearchController = TextEditingController();
  RxString searchField = "".obs;
  List<String> selectedBusOperators = <String>[].obs;
  // List<String> selectedBusFacilities = <String>[].obs;
  // List<String> selectedRtcBusType = <String>[].obs;

  //////////////////
  ///Add Passenger///
  //////////////////

  TextEditingController passengerNameTxtController = TextEditingController();
  TextEditingController passengerAgeTxtController = TextEditingController();
  TextEditingController passengerCityTxtController = TextEditingController();
  TextEditingController passengerStateTxtController = TextEditingController();

  /// Booking Success ///
  Map<String, dynamic> boardingDetails = {
    "name": "Swargate",
    "date": DateTime(2024, 5, 10, 15, 30), // Example date: May 10, 2024
    "address": "Swargate, Pune, Maharashtra, India",
    "city": "Pune",
    "landmark": "Swargate"
  };
  Map<String, dynamic> droppingDetails = {
    "name": "Sangli Station",
    "date": DateTime(2024, 5, 11, 11, 30), // Example date: May 10, 2024
    "address": "Swargate, Pune, Maharashtra, India",
    "city": "Sangli",
    "landmark": "Railway Station"
  };
  String busType = "Sleeper";
  bool isCanceled = false;

  //for selected bus
  RxString liveTrackingAvailability = "false".obs;
  RxString cancellationAvailability = "false".obs;
  RxString isPrimo = "false".obs;
  RxString selectedBusImage = "".obs;

  //Cities List
  RxString sourceId = "".obs;
  RxString destinationId = "".obs;
  RxString dateOfJourney = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;
  RxString tripID = "".obs;
  GlobalKey<FormState> fKey = GlobalKey();
  List<PassengerInfoModel>? passengerList;
  RxBool isBookedMultiple = false.obs;
  RxList<BusBookingPassengersDetailData> busPassengersList = <BusBookingPassengersDetailData>[].obs;
  RxInt busPassengerCount = 0.obs;

  String busTicketStatus(int intStatus) {
    String status = '_';
    if (intStatus == 0) {
      status = 'Cancelled';
    } else if (intStatus == 1) {
      status = 'Booked';
    } else if (intStatus == 2) {
      status = 'Pending';
    } else if (intStatus == 3) {
      status = 'PartialCancel';
    } else if (intStatus == 4) {
      status = 'PendingCancelled';
    }
    return status;
  }

  // Format date time
  String formatDateTime({required String dateTimeFormat, required String dateTimeString}) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat(dateTimeFormat).format(dateTime);
  }

  // Convert duration in hours and minutes
  String formatDuration(String minutesString) {
    int minutes = int.tryParse(minutesString) ?? 0;
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;

    String hoursText = hours > 0 ? '${hours}h' : '';
    String minutesText = remainingMinutes > 0 ? '${remainingMinutes}m' : '';

    // Handle cases where either hours or minutes are zero
    if (hoursText.isNotEmpty && minutesText.isNotEmpty) {
      return '$hoursText $minutesText';
    } else if (hoursText.isNotEmpty) {
      return hoursText;
    } else if (minutesText.isNotEmpty) {
      return minutesText;
    } else {
      return '0 m'; // If both hours and minutes are zero
    }
  }

  void setWhyBookList(String liveTracking, String partialCancellationPolicy) {
    whyBusBookList.clear();

    if (liveTracking.toLowerCase() == "true") {
      whyBusBookList.add(WhyBookBusModel(
          title: 'Live Tracking',
          description:
              'You can now track your bus and plan your commute to the boarding point !. Family members and friends can also check the bus location to coordinate pick ups and rest assured about your safety',
        ),);
    }

    if (partialCancellationPolicy.toLowerCase() == 'true') {
      whyBusBookList.add(
        WhyBookBusModel(
          title: 'Partial cancellation',
          description:
              'Partial cancellation is allowed for this bus',
        ),
      );
    }

  }

  void toggleVisibility() {
    isVisible.value = !isVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    busBookingTabController = TabController(length: myBookingsStatusTabList.length, vsync: this, initialIndex: 0);
    departureDateTxtController.text = DateFormat("yMMMMd").format(DateTime.now());
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 0.5).animate(animationController);
    boardingDroppingTabController = TabController(length: boardingDroppingTabList.length, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    animationController.dispose();
    isVisible.value = false;
    super.dispose();
  }

  void setTodayDate() {
    selectedDateTab.value = 0;
    departureDate.value = DateFormat("yMMMMd").format(DateTime.now());
    departureDateTxtController.text = DateFormat("yyyy-MM-dd").format(DateTime.now());
    dateOfJourney.value = departureDateTxtController.text;
  }

  void setTomorrowDate() {
    selectedDateTab.value = 1;
    departureDate.value = DateFormat("yMMMMd").format(DateTime.now().add(const Duration(days: 1)));
    departureDateTxtController.text = DateFormat("yyyy-MM-dd").format(DateTime.now().add(const Duration(days: 1)));
    dateOfJourney.value = departureDateTxtController.text;
  }

  bool parseBool(String value) {
    return value.toLowerCase() == 'true';
  }

  // List<Function> processQueue = [];
  // queueProcess() {
  //   for (var element in processQueue) {
  //     element();
  //   }
  //   processQueue.clear();
  //   applyFilters();
  // }

  // Toggle the filter selection
  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
    applyFilters();
  }

  // Filter the trips based on selected filters
  getFilteredTrips() {
    // List<AvailableTrips> filteredBusList = availableTrips;
    // try {
    //   if (selectedFilters.isEmpty) {
    //     return availableTrips;
    //   } else {
    filteredBusList.value = filteredBusList.where((trip) {
      return selectedFilters.every((filter) {
        switch (filter) {
          case 'Primo Bus':
            return parseBool(trip.primo.toString());
          case 'AC':
            return parseBool(trip.ac.toString());
          case 'Non AC':
            return parseBool(trip.nonAC.toString());
          case 'Seater':
            return parseBool(trip.seater.toString());
          case 'Sleeper':
            return parseBool(trip.sleeper.toString());
          default:
            return false;
        }
      });
    }).toList();
    //   }
    // } catch (e) {
    //   debugPrint('Error occurred: $e');
    //   return [];
    // }
  }

  void searchFromList(String searchQuery) {
    searchedList.assignAll(filteredBusList.where((item) {
      final query = searchQuery.toLowerCase();
      return item.travels!.toLowerCase().contains(query);
    }));
    // return searchedList.length;
  }

  void applyFilters() {
    filteredBusList.assignAll(availableTrips);

    getFilteredTrips();

    // Filter By Departure Time
    if (selectedDepartTime.isNotEmpty) {
      for (int i = 0; i < selectedDepartTime.length; i++) {
        filterListByDeparture(selectedDepartTime);
      }
      print("filterListByDeparture----->${filteredBusList.length}");
    }

    // Filter By Arrival Time
    if (selectedArriveTime.isNotEmpty) {
      for (int i = 0; i < selectedArriveTime.length; i++) {
        filterListByArrival(selectedArriveTime);
      }
      print("filterListByArrival----->${filteredBusList.length}");
    }

    // Filter list by travel names
    if (selectedBusOperators.isNotEmpty) {
      filterListByTravelNames(selectedBusOperators);
    }

    // search by text
    searchFromList(busSearchController.text);

    // Sort list
    if (selectedSortingMethod.value != "Relevance") {
      sortList(selectedSortingMethod.value);
    }
  }

  // Sorts the list by value
  void sortList(String value) {
    searchedList.sort((a, b) {
      switch (value) {
        case 'Cheapest':
          double priceA = getFare(a.fares!);
          double priceB = getFare(b.fares!);
          return priceA.compareTo(priceB);
        case 'Early Departure':
          return convertMinutesToHours(a.departureTime.toString()).compareTo(convertMinutesToHours(b.departureTime.toString()));
        case 'Early Arrival':
          return convertMinutesToHours(a.arrivalTime.toString()).compareTo(convertMinutesToHours(b.arrivalTime.toString()));
        default:
          return 0;
      }
    });
  }

  //Filter List by Departure Times
  void filterListByDeparture(List<String> selectedFilters) {
    // Filter the trips based on the selected filters
    filteredBusList.value = filteredBusList.where((trip) {
      DateTime departureTime = convertMinutesTo24HourTime(int.parse(trip.departureTime.toString()));
      bool passesFilter = false;

      // Check if the departure time satisfies any of the selected filters
      for (String filter in selectedFilters) {
        switch (filter) {
          case 'Early Morning':
            passesFilter = departureTime.hour < 6;
            break;
          case 'Morning':
            passesFilter = departureTime.hour >= 6 && departureTime.hour < 12;
            break;
          case 'Afternoon':
            passesFilter = departureTime.hour >= 12 && departureTime.hour < 18;
            break;
          case 'Evening':
            passesFilter = departureTime.hour >= 18;
            break;
          default:
            passesFilter = true; // Include all trips if no filter is selected
        }
        if (passesFilter) {
          // print("departure time----->$departureTime");

          break;
        } // If any filter passes, no need to check further
      }

      return passesFilter;
    }).toList();

    // Sort the filtered trips by departure time
    // filteredTrips.sort((a, b) {
    //   DateTime timeA = convertMinutesTo24HourTime(int.parse(a.departureTime.toString()));
    //   DateTime timeB = convertMinutesTo24HourTime(int.parse(b.departureTime.toString()));
    //   return timeA.compareTo(timeB);
    // });

    // Update the availableTrips list with the filtered and sorted trips
    // filteredBusList.clear();
    // filteredBusList.assignAll(filteredTrips);
  }

  //Filter List by Arrival Times
  void filterListByArrival(List<String> selectedFilters) {
    // Filter the trips based on the selected filters
    filteredBusList.value = filteredBusList.where((trip) {
      DateTime arrivalTime = convertMinutesTo24HourTime(int.parse(trip.arrivalTime.toString()));
      bool passesFilter = false;

      // Check if the departure time satisfies any of the selected filters
      for (String filter in selectedFilters) {
        switch (filter) {
          case 'Early Morning':
            passesFilter = arrivalTime.hour < 6 || (arrivalTime.hour == 6 && arrivalTime.minute == 0);
            break;
          case 'Morning':
            passesFilter = arrivalTime.hour >= 6 && arrivalTime.hour < 12;
            break;
          case 'Afternoon':
            passesFilter = arrivalTime.hour >= 12 && arrivalTime.hour < 18;
            break;
          case 'Evening':
            passesFilter = arrivalTime.hour >= 18 || arrivalTime.hour == 0;
            break;
          default:
            passesFilter = true; // Include all trips if no filter is selected
        }
        if (passesFilter) break; // If any filter passes, no need to check further
      }

      return passesFilter;
    }).toList();

    // Sort the filtered trips by departure time
    filteredBusList.sort((a, b) {
      DateTime timeA = convertMinutesTo24HourTime(int.parse(a.arrivalTime.toString()));
      DateTime timeB = convertMinutesTo24HourTime(int.parse(b.arrivalTime.toString()));
      return timeA.compareTo(timeB);
    });

    // Update the availableTrips list with the filtered and sorted trips
    // filteredBusList.assignAll(filteredTrips);
  }

  void filterListByTravelNames(List<String> selectedTravelNames) {
    // Initialize a list to store filtered and sorted trips
    List<AvailableTrips> filteredAndSortedTrips = [];

    // Iterate through each selected travel name
    for (String selectedTravelName in selectedTravelNames) {
      // Filter the list by the selected travel name
      List<AvailableTrips> filteredTrips = filteredBusList.where((trip) => trip.travels == selectedTravelName).toList();

      // Sort the filtered list by travel name
      filteredTrips.sort((a, b) => a.travels!.compareTo(b.travels!));

      // Append filtered and sorted trips to the result list
      filteredAndSortedTrips.addAll(filteredTrips);
    }
    // Now you can use or return the filteredAndSortedTrips list as needed
    if (selectedTravelNames.isNotEmpty) {
      filteredBusList.assignAll(filteredAndSortedTrips);
      print("filterListByTravelNames----->${filteredBusList.length}");
      //
    }
  }

  bool isSelected(List<String> searchInList, String search) => searchInList.contains(search);

  void addInList(List searchIn, String stop) {
    searchIn.add(stop);
  }

  void removeFromList(List searchIn, String stop) {
    searchIn.removeWhere((st) => stop == st);
  }

  RxList<Map> time = [
    {'name': "Early Morning", 'desc': "Before 6 AM", 'start': DateTime(2020, 1, 1, 0), 'end': DateTime(2020, 1, 1, 6)},
    {'name': "Morning", 'desc': "6AM-12PM", 'start': DateTime(2020, 1, 1, 6), 'end': DateTime(2020, 1, 1, 12)},
    {'name': "Afternoon", 'desc': "12PM-6PM", 'start': DateTime(2020, 1, 1, 12), 'end': DateTime(2020, 1, 1, 18)},
    {'name': "Evening", 'desc': "After 6 PM", 'start': DateTime(2020, 1, 1, 18), 'end': DateTime(2020, 1, 2, 0)},
  ].obs;

  void resetAll() {
    selectedSortingMethod.value = "Relevance";
    selectedDepartTime.clear();
    selectedArriveTime.clear();
    selectedFilters.clear();

    // selectedBoardingPoints.clear();
    // selectedDroppingPoints.clear();
    searchField = "".obs;

    selectedBusOperators.clear();
    // selectedBusFacilities.clear();
    // selectedRtcBusType.clear();
    filteredBusList.clear();
    applyFilters();
  }

//Method of convert minutes to hrs
  String convertMinutesToHours(String minutesString) {
    int minutes = int.tryParse(minutesString) ?? 0;

    // Calculate hours and minutes
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    int arrHours = hours % 24;
    int arrMinutes = remainingMinutes;

    String aarHour = "";
    if (arrHours < 9) {
      aarHour = "0$arrHours";
    } else {
      aarHour = arrHours.toString();
    }
    String aarMinute = "";
    if (arrMinutes < 9) {
      aarMinute = "0$arrMinutes";
    } else {
      aarMinute = arrMinutes.toString();
    }

    // Format the time
    String hourString = aarHour.toString().padLeft(2, '0');
    String minuteString = aarMinute.toString().padLeft(2, '0');

    return '$hourString:$minuteString ';
  }

  // Function to convert minutes to 24-hour time format
  DateTime convertMinutesTo24HourTime(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    return DateTime(2024, 1, 1, hours, remainingMinutes); // Using arbitrary date for parsing
  }

  //Get Bus Cities List
  Future<void> getCitiesList({bool isLoaderShow = true}) async {
    try {
      BusFromCitiesModel busFromCitiesModel = await busRepository.getCitiesListApiCall(isLoaderShow: isLoaderShow);

      if (busFromCitiesModel.statusCode == 1) {
        fromCitiesList.clear();
        if (busFromCitiesModel.cities != null && busFromCitiesModel.cities!.isNotEmpty) {
          for (var element in busFromCitiesModel.cities!) {
            if (element.name.toString().isNotEmpty) {
              fromCitiesList.add(element);
            }
          }
          fromCitiesList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        }
      } else {
        fromCitiesList.clear();
        errorSnackBar(message: busFromCitiesModel.message ?? '');
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  //Get Available Bus List
  Future<void> getAvailableBusList({bool isLoaderShow = true}) async {
    try {
      BusAvailableTripsModel busAvailableTripsModel = await busRepository.getAvailableTripsListApiCall(
          isLoaderShow: isLoaderShow, sourceId: sourceId.value, destinationId: destinationId.value, journeyDate: dateOfJourney.value);
      if (busAvailableTripsModel.statusCode == 1) {
        if (busAvailableTripsModel.availableTrips!.isNotEmpty) {
          availableTrips.clear();
          filteredBusList.clear();

          if (busAvailableTripsModel.availableTrips != null && busAvailableTripsModel.availableTrips!.isNotEmpty) {
            availableTrips.value = busAvailableTripsModel.availableTrips!.toList();
            filteredBusList.value = busAvailableTripsModel.availableTrips!.toList();
            busOperators.assignAll(availableTrips.map((element) => element.travels!));
            // for (AvailableTrips trip in busAvailableTripsModel.availableTrips!) {
            //   busOperators.add(trip.travels.toString());
            //   /* if (trip.id == '5000003748661014421') {
            //     availableTrips.add(trip);
            //     filteredBusList.add(trip);
            //   }*/
            // }
            print("---------Bus Length----> ${busOperators.length}");
          }
        } else {
          availableTrips.clear();
          filteredBusList.clear();
          errorSnackBar(message: 'No trips found');
        }
      } else {
        availableTrips.clear();
        filteredBusList.clear();
        errorSnackBar(message: busAvailableTripsModel.message ?? '');
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  //Get Seat Layout
  Future<void> getTripDetails({bool isLoaderShow = true}) async {
    try {
      BusTripDetailsModel busTripDetailsModel = await busRepository.getTripDetailsApiCall(
        isLoaderShow: isLoaderShow,
        tripId: tripID.value,
      );
      if (busTripDetailsModel.statusCode == 1) {
        seatsDataLower.clear();
        seatsDataUpper.clear();
        if (busTripDetailsModel.seats != null && busTripDetailsModel.seats!.isNotEmpty) {
          //Upper Birth zIndex==1
          //Lower Birth zIndex==0
          selectedSeatDataMain.value = busTripDetailsModel.seats!.toList();
          //Add list for lower deck, Count lower row & column
          for (var element in busTripDetailsModel.seats!) {
            if (element.zIndex == 0) {
              seatsDataLower.add(element);

              if (element.row! > maxBusRowLowerCount.value) {
                maxBusRowLowerCount.value = element.row!;
              }
              if (element.column! > maxBusColumnLowerCount.value) {
                maxBusColumnLowerCount.value = element.column!;
              }
            }
          }
          if (kDebugMode) {
            print("Max Row Lower: $maxBusRowLowerCount");
            print("Max Column Lower: $maxBusColumnLowerCount");
          }
          if (seatsDataLower.isNotEmpty) {
            isLowerDeckSelected.value = true;
            canLowerDeckSelect.value = true;
            isUpperDeckSelected.value = false;
            canUpperDeckSelect.value = false;
          } else {
            isLowerDeckSelected.value = false;
            canLowerDeckSelect.value = false;
          }

          //Add list for upper deck, Count upper row & column
          for (var element in busTripDetailsModel.seats!) {
            if (element.zIndex == 1) {
              seatsDataUpper.add(element);

              if (element.row! > maxBusRowUpperCount.value) {
                maxBusRowUpperCount.value = element.row!;
              }
              if (element.column! > maxBusColumnUpperCount.value) {
                maxBusColumnUpperCount.value = element.column!;
              }
            }
          }
          if (kDebugMode) {
            print("Max Row Upper: $maxBusRowUpperCount");
            print("Max Column Upper: $maxBusColumnUpperCount");
          }
          if (seatsDataUpper.isNotEmpty) {
            isUpperDeckSelected.value = true;
            canUpperDeckSelect.value = true;
            isLowerDeckSelected.value = false;
            canLowerDeckSelect.value = false;
          } else {
            isUpperDeckSelected.value = false;
            canUpperDeckSelect.value = false;
          }

          //successSnackBar(message: 'List Added');
        }
      } else {
        seatsDataLower.clear();
        seatsDataUpper.clear();
        errorSnackBar(message: busTripDetailsModel.message ?? '');
      }
    } catch (e) {
      seatsDataLower.clear();
      seatsDataUpper.clear();
      dismissProgressIndicator();
    }
  }

//Get Boarding & Dropping Point List
  Future<void> getBpDpPointList({bool isLoaderShow = true}) async {
    try {
      BusBpDpDetailsModel bpDpDetailsModel = await busRepository.getBpDpDetailsApiCall(
        isLoaderShow: isLoaderShow,
        tripId: tripID.value,
      );
      if (bpDpDetailsModel.statusCode == 1) {
        if (bpDpDetailsModel.boardingPoints!.isNotEmpty && bpDpDetailsModel.droppingPoints!.isNotEmpty) {
          boardingPointList.clear();
          droppingPointList.clear();

          if (bpDpDetailsModel.boardingPoints != null && bpDpDetailsModel.boardingPoints!.isNotEmpty) {
            boardingPointList.value = bpDpDetailsModel.boardingPoints!.toList();
          }
          if (bpDpDetailsModel.droppingPoints != null && bpDpDetailsModel.droppingPoints!.isNotEmpty) {
            droppingPointList.value = bpDpDetailsModel.droppingPoints!.toList();
          }
        } else {
          boardingPointList.clear();
          droppingPointList.clear();
          errorSnackBar(message: 'No boarding & dropping points found');
        }
      } else {
        boardingPointList.clear();
        droppingPointList.clear();
        errorSnackBar(message: bpDpDetailsModel.message ?? '');
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  bool isValidEmail(String email) {
    // Regular expression for validating email addresses
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[\w-]+$', caseSensitive: false);

    return emailRegex.hasMatch(email);
  }

  void busBookingPassenger() {
    //for (BusSeatsModel passenger in selectedSeatList) {
    finalBusPassengerList.clear();
    for (int i = 0; i < selectedSeatList.length; i++) {
      var passengerMap = {
        "seatName": selectedSeatList[i].name,
        "fare": selectedSeatList[i].fare.toString(),
        "ladiesSeat": selectedSeatList[i].ladiesSeat.toString(),
        "address": passengerAddressTxtController.text.trim().toString(),
        "age": passengerList![i].passengerAgeTxtController.text.trim().toString(),
        "email": passengerEmailTxtController.text.trim().toString(),
        "gender": passengerList![i].gender.toString(),
        "idNumber": passengerList![i].passengerIdTxtController.text.trim().toString(),
        "idType": passengerList![i].docType.toString(),
        "mobile": passengerMobileTxtController.text.trim().toString(),
        "name": passengerList![i].passengerNameTxtController.text.trim().toString(),
        "primary": i == 0 ? true.toString() : false.toString(),
        "title": passengerList![i].title
      };
      log("passengerMap ==> $passengerMap");
      finalBusPassengerList.add(passengerMap);
    }
  }

  setPassengerInfoController() {
    passengerList =
        List.generate(selectedSeatList.length, (index) => PassengerInfoModel(seat: selectedSeatList[index].name.toString()));
  }

//Booking API
  Future<int> busBookApi({bool isLoaderShow = true}) async {
    try {
      BusBookModel busBookModel = await busRepository.busBookApiCall(
        params: {
          "channel": channelID,
          "latitude": latitude,
          "longitude": longitude,
          "tpin": tPinTxtController.text.trim(),
          "amount": totalFareOfSeats.toString(),
          //"amount": 1.0.toString(),
          "orderId": "App${DateTime.now().millisecondsSinceEpoch.toString()}",
          "fromCityCode": availableTripsModel.source,
          "fromCityName": fromLocationTxtController.text.toString(),
          "toCityCode": availableTripsModel.destination,
          "toCityName": toLocationTxtController.text.toString(),
          "doj": dateOfJourney.value.toString(),
          "availableTripId": availableTripsModel.id,
          "boardingPointId": boardingLocation!.value.id.toString(),
          "droppingPointId": droppingLocation!.value.id.toString(),
          "source": availableTripsModel.source,
          "sourceName": fromLocationTxtController.text.toString(),
          "destination": availableTripsModel.destination,
          "destinationName": toLocationTxtController.text.toString(),
          "inventoryItems": finalBusPassengerList
        },
        isLoaderShow: isLoaderShow,
      );
      this.busBookModel = BusBookModel().obs;
      if (busBookModel.statusCode == 1) {
        this.busBookModel.value = busBookModel;
        return busBookModel.statusCode!;
      } else {
        this.busBookModel.value = busBookModel;
        errorSnackBar(message: busBookModel.message ?? '');
        return 0;
      }
    } catch (e) {
      busBookModel = BusBookModel().obs;
      dismissProgressIndicator();
      return -1;
    }
  }

  // Bus booking report
  RxList<BusBookingReportData> busBookingReportList = <BusBookingReportData>[].obs;

  Future<bool> getBusBookingReportApi({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      BusBookingReportModel busBookingReportModel = await busRepository.getBusBookingReportApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (busBookingReportModel.statusCode == 1) {
        if (busBookingReportModel.pagination!.currentPage == 1) {
          busBookingReportList.clear();
        }
        for (BusBookingReportData element in busBookingReportModel.data!) {
          busBookingReportList.add(element);
        }
        currentPage.value = busBookingReportModel.pagination!.currentPage!;
        totalPages.value = busBookingReportModel.pagination!.totalPages!;
        hasNext.value = busBookingReportModel.pagination!.hasNext!;
        return true;
      } else if (busBookingReportModel.statusCode == 0) {
        busBookingReportList.clear();
        return false;
      } else {
        busBookingReportList.clear();
        errorSnackBar(message: busBookingReportModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  } // flight booking history

  // Partial bus booking cancel
  Rx<PartialBusBookingCancelModel> partialFlightBookingCancelModel = PartialBusBookingCancelModel().obs;

  Future<bool> partialBusBookingCancel({required String uniqueId, required id, bool isLoaderShow = true}) async {
    try {
      PartialBusBookingCancelModel partialBusBookingCancelModel = await busRepository.partialBusBookingCancelApiCall(
        params: {
          "uniqueId": uniqueId,
          "seatNumber": [id],
          "reason": "Partial Cancel"
        },
        isLoaderShow: isLoaderShow,
      );
      if (partialBusBookingCancelModel.statusCode == 1) {
        partialFlightBookingCancelModel.value = partialBusBookingCancelModel;
        successSnackBar(message: partialBusBookingCancelModel.message ?? '');
        return true;
      } else {
        errorSnackBar(message: partialBusBookingCancelModel.message ?? '');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Full flight booking cancel
  Rx<FullBusBookingCancelModel> fullFlightBookingCancelModel = FullBusBookingCancelModel().obs;

  Future<bool> fullBusBookingCancel({required String uniqueId, bool isLoaderShow = true}) async {
    try {
      FullBusBookingCancelModel fullFlightBookingCancelModel = await busRepository.fullBusBookingCancelApiCall(
        params: {"uniqueId": uniqueId, "reason": "Full cancellation", "channel": channelID},
        isLoaderShow: isLoaderShow,
      );
      if (fullFlightBookingCancelModel.statusCode == 1) {
        this.fullFlightBookingCancelModel.value = fullFlightBookingCancelModel;
        successSnackBar(message: fullFlightBookingCancelModel.message ?? '');
        return true;
      } else {
        errorSnackBar(message: fullFlightBookingCancelModel.message ?? '');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> getBusPassengersListApi({required busId, bool isLoaderShow = true}) async {
    try {
      BusBookingPassengersDetailModel passengerDetailsModel = await busRepository.getBusPassengerDetailsListApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        busTxnId: busId,
        isLoaderShow: isLoaderShow,
      );
      if (passengerDetailsModel.statusCode == 1) {
        busPassengerCount.value = passengerDetailsModel.pagination!.totalCount!;
        if (passengerDetailsModel.pagination!.currentPage == 1) {
          busPassengersList.clear();
        }
        for (BusBookingPassengersDetailData element in passengerDetailsModel.data!) {
          busPassengersList.add(element);
        }
        // currentPage.value = passengerDetailsModel.pagination!.currentPage!;
        // totalPages.value = passengerDetailsModel.pagination!.totalPages!;
        // hasNext.value = passengerDetailsModel.pagination!.hasNext!;
        // busPassengersList.add(FlightPassengersDetailData(status: 1, name: "sasasas", seatNumber: "as"));

        isBookingGtTwo();
        return true;
      } else if (passengerDetailsModel.statusCode == 0) {
        busPassengersList.clear();
        return false;
      } else {
        busPassengersList.clear();
        errorSnackBar(message: passengerDetailsModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  void isBookingGtTwo() {
    int count = 0;
    for (BusBookingPassengersDetailData element in busPassengersList) {
      if (element.status == 1) {
        count++;
      }
      if (count > 1) {
        isBookedMultiple.value = true;
        return;
      }
    }
    return;
  }

  double getFare(List<String> fares) {
    // Convert fares to doubles
    List<double> faresDouble = fares.map(double.parse).toList();
    // Find the smallest fare
    double smallestFare = faresDouble.reduce((min, current) => min < current ? min : current);
    //debugPrint("Smallest fare: $smallestFare");
    return smallestFare;
  }

  resetBusVariables() {
    //Variables for bus home screen
    currentPage.value = 1;
    totalPages.value = 1;
    hasNext.value = false;
    // fromDate.value = DateTime.now();
    // toDate.value = DateTime.now();
    selectedFromDate.value = '';
    selectedToDate.value = '';
    selectedBoardingPoint.value = '';
    selectedDroppingPoint.value = '';
    fromLocationTxtController.clear();
    toLocationTxtController.clear();
    departureDateTxtController.clear();
    searchTxtController.clear();
    tPinTxtController.clear();
    passengerMobileTxtController.clear();
    passengerEmailTxtController.clear();
    passengerAddressTxtController.clear();
    busBookingStatus.value = (-1);

    //Variables to show tpin field....
    isShowTpinField.value = false;
    isShowTpin.value = true;

    //Bus City List, Available Trips List & Model Class Object
    availableTripsModel = AvailableTrips();
    fromCitiesList.value = <BusCities>[];
    availableTrips.value = <AvailableTrips>[];

    //Boarding & Dropping Points List
    boardingPointList.value = <BoardingPoints>[];
    droppingPointList.value = <BoardingPoints>[];

    filteredBusList.value = <AvailableTrips>[];
    busOperators = {};

    departureDate.value = DateFormat("yMMMMd").format(DateTime.now());
    selectedDateTab.value = 0;
    busBookModel = BusBookModel().obs;
    finalBusPassengerList = [];

    //Variables for bus details
    selectedGender.value = "";
    day.value = "Wed,";
    date.value = "20 Mar ";
    restStopTime.value = "02:00 AM";
    starRating.value = "4.7";
    ratings.value = "1427";

    isVisible.value = false;
    tabIndex.value = 0;
    selectedSeatData.value = BusSeatsModel();
    selectedSeatDataMain.value = <BusSeatsModel>[];
    selectedSeatList.value = <BusSeatsModel>[];
    totalFareOfSeats.value = 0.0;
    baseFareOfSeats.value = 0.0;
    taxFareOfSeats.value = 0.0;

    busTravelName.value = "";

    //Regex for Aadhaar and PAN
    aadhaarRegex = RegExp(r'^[2-9]{1}[0-9]{11}$');
    panRegex = RegExp(r"^[A-Z]{5}[0-9]{4}[A-Z]{1}$");
    seatsDataLower.value = <BusSeatsModel>[];
    seatsDataUpper.value = <BusSeatsModel>[];
    maxBusColumnLowerCount.value = 0;
    maxBusRowLowerCount.value = 0;

    maxBusColumnUpperCount.value = 0;
    maxBusRowUpperCount.value = 0;

    isLowerDeckSelected.value = true;
    canLowerDeckSelect.value = true;
    isUpperDeckSelected.value = false;
    canUpperDeckSelect.value = false;
    seatStatusList = [
      "Available",
      "Sleeper",
      "Booked",
      "Selected by you",
      "Available only for female passenger",
      "Blocked by female passenger",
      "Available for male passenger"
    ];
    whyBusBookList.value = <WhyBookBusModel>[];

    selectedBusDetails.value = 0;
    itemScrollController = ItemScrollController();
    itemScrollTabController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();
    currentTabIndex.value = 0;
    myBookingsStatusTabList = [
      const Tab(text: 'COMPLETED'),
      const Tab(text: 'CANCELLED'),
    ];
    seatsLocationTabList = [
      const Tab(text: 'Upper deck'),
      const Tab(text: 'Lower desk'),
    ];
    boardingDroppingTabList = [
      const Tab(text: 'Boarding'),
      const Tab(text: 'Dropping'),
    ];
    journeyDateController = TextEditingController(text: DateFormat("yyyy-MM-dd").format(DateTime.now()));
    selectedTab.value = 0;

    /// Filter screen
    filterMethods = [
      "Sort by",
      "Bus departure time from source",
      "Bus arrival time at destination",
      "Bus Type",
      "Bus Operator",
    ];
    selectedTabIndex.value = 0;
    busFeatures = ["Primo bus", "Seater", "AC", "Sleeper", "Non AC"];

    /// Sort ///
    sortMethods = ["Relevance", "Cheapest", "Early Departure", "Early Arrival"];
    selectedSortingMethod.value = "Relevance";
    selectedDepartTime = <String>[];
    selectedArriveTime = <String>[];

    // selectedBoardingPoints = <String>[];
    // selectedDroppingPoints = <String>[];
    searchController.clear();
    busSearchController.clear();
    searchField.value = "";
    selectedBusOperators = <String>[];
    // selectedBusFacilities = <String>[];
    // selectedRtcBusType = <String>[];

    //////////////////
    ///Add Passenger///
    //////////////////

    passengerNameTxtController.clear();
    passengerAgeTxtController.clear();
    passengerCityTxtController.clear();
    passengerStateTxtController.clear();

    /// Booking Success ///
    boardingDetails = {
      "name": "Swargate",
      "date": DateTime(2024, 5, 10, 15, 30), // Example date: May 10, 2024
      "address": "Swargate, Pune, Maharashtra, India",
      "city": "Pune",
      "landmark": "Swargate"
    };
    droppingDetails = {
      "name": "Sangli Station",
      "date": DateTime(2024, 5, 11, 11, 30), // Example date: May 10, 2024
      "address": "Swargate, Pune, Maharashtra, India",
      "city": "Sangli",
      "landmark": "Railway Station"
    };
    busType = "Sleeper";
    isCanceled = false;

    //for selected bus
    liveTrackingAvailability.value = "false";
    cancellationAvailability.value = "false";
    isPrimo.value = "false";
    selectedBusImage.value = "";

    //Cities List
    sourceId.value = "";
    destinationId.value = "";
    dateOfJourney.value = DateFormat("yyyy-MM-dd").format(DateTime.now());
    tripID.value = "";
    fKey = GlobalKey();
    passengerList = <PassengerInfoModel>[];
    isBookedMultiple.value = false;
    busPassengersList.value = <BusBookingPassengersDetailData>[];
    busPassengerCount.value = 0;
  }
}

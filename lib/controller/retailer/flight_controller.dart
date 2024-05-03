// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../api/api_manager.dart';
import '../../model/flight/airline_model.dart';
import '../../model/flight/airport_model.dart';
import '../../model/flight/country_model.dart';
import '../../model/flight/dom_flight_book_model.dart';
import '../../model/flight/dom_return_flight_book_model.dart';
import '../../model/flight/fare_price_model.dart';
import '../../model/flight/fligh_booking_history_model.dart';
import '../../model/flight/flight_booking_details_model.dart';
import '../../model/flight/flight_fare_quote_model.dart';
import '../../model/flight/flight_fare_rule_model.dart';
import '../../model/flight/flight_filter_model.dart';
import '../../model/flight/flight_passenger_details_model.dart';
import '../../model/flight/flight_search_model.dart';
import '../../model/flight/flight_ssr_model.dart';
import '../../model/flight/from_to_location_model.dart';
import '../../model/flight/full_flight_booking_cancel_model.dart';
import '../../model/flight/master_search_flight_common_model.dart';
import '../../model/flight/partial_flight_booking_cancel_model.dart';
import '../../model/flight/passengers_detail_model.dart';
import '../../model/flight/seat_layout_model.dart';
import '../../repository/retailer/flight_repository.dart';
import '../../utils/app_colors.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

enum TripType { NONE, ONEWAY_DOM, RETURN_DOM, MULTICITY_DOM, ONEWAY_INT, RETURN_INT, MULTICITY_INT }

class FlightController extends GetxController with GetTickerProviderStateMixin {
  FlightRepository flightRepository = FlightRepository(APIManager());

  /////////////////////
  /// Search Flight ///
  /////////////////////

  // For swap location animation
  late AnimationController animationController;
  late Animation<double> animation;
  RxBool isAnimationDone = false.obs;

  // Set animation controllers value
  setAnimationController() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    animation = Tween<double>(begin: 0, end: 0.5).animate(animationController);
  }

  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;
  RxString fromLocationName = 'Delhi'.obs;
  RxString fromLocationCode = 'DEL'.obs;
  RxString toLocationName = 'Mumbai'.obs;
  RxString toLocationCode = 'BOM'.obs;
  int maxMultiStopCount = 5;
  RxList<MultiStopFromToDateModel> multiStopLocationList = <MultiStopFromToDateModel>[].obs;
  RxString departureDate = ''.obs;
  RxString returnDate = ''.obs;
  List<String> tripTypeList = ['One Way', 'Round Trip', 'Advance Search', 'Multi Stop'];
  RxInt selectedFlight = 0.obs;
  TextEditingController departureDateController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();
  int travellersAdultCount = 1;
  int travellersChildCount = 0;
  int travellersInfantCount = 0;
  Color adultDecreaseColor = ColorsForApp.grayScale500.withOpacity(0.6);
  Color adultIncreaseColor = ColorsForApp.flightOrangeColor;
  Color childDecreaseColor = ColorsForApp.grayScale500.withOpacity(0.6);
  Color childIncreaseColor = ColorsForApp.flightOrangeColor;
  Color infantDecreaseColor = ColorsForApp.grayScale500.withOpacity(0.6);
  Color infantIncreaseColor = ColorsForApp.flightOrangeColor;
  RxString travellersCount = ''.obs;
  RxString flightUniqueId = ''.obs;
  RxString flightSequenceNumber = ''.obs;
  RxBool directFlightCheckBox = false.obs;
  TextEditingController preferredAirlineController = TextEditingController();

  String flightBookingHistoryStatus(int intStatus) {
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
      status = 'Pending Cancelled';
    }
    return status;
  }

  // Switch location
  void switchLocation() {
    // Store current values
    String tempFromCode = fromLocationCode.value;
    String tempFromName = fromLocationName.value;
    // Switch values
    fromLocationCode.value = toLocationCode.value;
    fromLocationName.value = toLocationName.value;
    toLocationCode.value = tempFromCode;
    toLocationName.value = tempFromName;
  }

  // Set flight booking variables value
  void setFlightBookingVariables() {
    setTravellersCount();
  }

  // Set travellers count
  void setTravellersCount() {
    List<String> tempTravellersCountList = [];
    if (travellersAdultCount > 0) {
      tempTravellersCountList.add(travellersAdultCount == 1 ? '1 Adult' : '$travellersAdultCount Adults');
    }
    if (travellersChildCount > 0) {
      tempTravellersCountList.add(travellersChildCount == 1 ? '1 Child' : '$travellersChildCount Children');
    }
    if (travellersInfantCount > 0) {
      tempTravellersCountList.add(travellersInfantCount == 1 ? '1 Infant' : '$travellersInfantCount Infants');
    }
    travellersCount.value = tempTravellersCountList.join(', ');
  }

  // Add multi stop location in list
  void addMultiStopLocation() {
    if (multiStopLocationList.length < maxMultiStopCount) {
      if (multiStopLocationList.last.fromLocationCode!.value.isEmpty || multiStopLocationList.last.fromLocationName!.value.isEmpty) {
        errorSnackBar(message: 'Please select the source first.');
      } else if (multiStopLocationList.last.toLocationCode!.value.isEmpty || multiStopLocationList.last.toLocationName!.value.isEmpty) {
        errorSnackBar(message: 'Please select the destination first.');
      } else if (multiStopLocationList.last.date!.value.isEmpty) {
        errorSnackBar(message: 'Please select the travel date first.');
      } else {
        multiStopLocationList.add(
          MultiStopFromToDateModel(
            fromLocationName: multiStopLocationList[multiStopLocationList.length - 1].toLocationName?.value.obs,
            fromLocationCode: multiStopLocationList[multiStopLocationList.length - 1].toLocationCode?.value.obs,
            toLocationName: ''.obs,
            toLocationCode: ''.obs,
            date: ''.obs,
          ),
        );
      }
    }
  }

  // Remove multi stop location controller from list
  void removeMultiStopLocation({required int index}) {
    multiStopLocationList.removeAt(index);
  }

  // Get trip type list
  RxList<MasterSearchFlightCommonModel> masterTripTypeList = <MasterSearchFlightCommonModel>[].obs;
  RxString selectedTripType = ''.obs;
  Future<void> getTripTypeList({bool isLoaderShow = true}) async {
    try {
      List<MasterSearchFlightCommonModel> tripTypeModel = await flightRepository.getTripTypeListApiCall(isLoaderShow: isLoaderShow);
      if (tripTypeModel.isNotEmpty) {
        masterTripTypeList.clear();
        for (MasterSearchFlightCommonModel element in tripTypeModel) {
          if (element.status == 1) {
            masterTripTypeList.add(element);
          }
        }
        masterTripTypeList.sort((a, b) => a.rank!.compareTo(b.rank!));
        selectedTripType.value = masterTripTypeList.first.code ?? '';
      } else {
        masterTripTypeList.clear();
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Get airport list
  RxList<AirportData> masterAirportList = <AirportData>[].obs;
  Future<void> getAirportList({String searchText = '', required int pageNumber, bool isLoaderShow = true}) async {
    try {
      AirportModel airportModel = await flightRepository.getAirportListApiCall(
        searchText: searchText,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );

      if (airportModel.data!.isNotEmpty) {
        if (airportModel.pagination!.currentPage == 1) {
          masterAirportList.clear();
        }
        for (AirportData element in airportModel.data!) {
          if (element.status == 1) {
            masterAirportList.add(element);
          }
        }
        currentPage.value = airportModel.pagination!.currentPage!;
        totalPages.value = airportModel.pagination!.totalPages!;
        hasNext.value = airportModel.pagination!.hasNext!;
        masterAirportList.sort((a, b) => a.cityName!.toLowerCase().compareTo(b.cityName!.toLowerCase()));
      } else {
        masterAirportList.clear();
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Get traveller type list
  RxList<MasterSearchFlightCommonModel> masterTravellerTypeList = <MasterSearchFlightCommonModel>[].obs;
  Rx<bool> isShowAdult = false.obs;
  Rx<bool> isShowChildren = false.obs;
  Rx<bool> isShowInfants = false.obs;
  Future<void> getTravellerTypeList({bool isLoaderShow = true}) async {
    try {
      List<MasterSearchFlightCommonModel> travellerTypeModel = await flightRepository.getTravellerTypeListApiCall(isLoaderShow: isLoaderShow);
      if (travellerTypeModel.isNotEmpty) {
        masterTravellerTypeList.clear();
        for (MasterSearchFlightCommonModel element in travellerTypeModel) {
          if (element.status == 1) {
            if (element.code == 'ADULTS') {
              isShowAdult.value = true;
            }
            if (element.code == 'CHILDREN') {
              isShowChildren.value = true;
            }
            if (element.code == 'INFANTS') {
              isShowInfants.value = true;
            }
            masterTravellerTypeList.add(element);
          }
        }
        masterTravellerTypeList.sort((a, b) => a.rank!.compareTo(b.rank!));
      } else {
        masterTravellerTypeList.clear();
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Get travel class list
  RxList<MasterSearchFlightCommonModel> masterTravelClassList = <MasterSearchFlightCommonModel>[].obs;
  RxString selectedTravelClassName = ''.obs;
  RxString selectedTravelClassCode = ''.obs;
  Future<void> getTravelClassList({bool isLoaderShow = true}) async {
    try {
      List<MasterSearchFlightCommonModel> travelClassModel = await flightRepository.getTravelClassListApiCall(isLoaderShow: isLoaderShow);
      if (travelClassModel.isNotEmpty) {
        masterTravelClassList.clear();
        for (MasterSearchFlightCommonModel element in travelClassModel) {
          if (element.status == 1) {
            masterTravelClassList.add(element);
          }
        }
        masterTravelClassList.sort((a, b) => a.rank!.compareTo(b.rank!));
        selectedTravelClassName.value = masterTravelClassList.first.name!;
        selectedTravelClassCode.value = masterTravelClassList.first.code!;
      } else {
        masterTravelClassList.clear();
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Get fare type list
  RxList<MasterSearchFlightCommonModel> masterFareTypeList = <MasterSearchFlightCommonModel>[].obs;
  RxString selectedSpecialFareName = ''.obs;
  RxString selectedSpecialFareCode = ''.obs;
  Future<void> getFareTypeList({bool isLoaderShow = true}) async {
    try {
      List<MasterSearchFlightCommonModel> fareTypeModel = await flightRepository.getFareTypeApiCall(isLoaderShow: isLoaderShow);
      if (fareTypeModel.isNotEmpty) {
        masterFareTypeList.clear();
        for (MasterSearchFlightCommonModel element in fareTypeModel) {
          if (element.status == 1) {
            masterFareTypeList.add(element);
          }
        }
        masterFareTypeList.sort((a, b) => a.rank!.compareTo(b.rank!));
        selectedSpecialFareName.value = masterFareTypeList.first.name!;
        selectedSpecialFareCode.value = masterFareTypeList.first.code!;
      } else {
        masterFareTypeList.clear();
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Get number of stops list
  RxList<MasterSearchFlightCommonModel> masterNumberOfStopsList = <MasterSearchFlightCommonModel>[].obs;
  Future<void> getNumberOfStopsList({bool isLoaderShow = true}) async {
    try {
      List<MasterSearchFlightCommonModel> numberOfStopsModel = await flightRepository.getNumberOfStopsApiCall(isLoaderShow: isLoaderShow);
      if (numberOfStopsModel.isNotEmpty) {
        masterNumberOfStopsList.clear();
        for (MasterSearchFlightCommonModel element in numberOfStopsModel) {
          if (element.status == 1) {
            masterNumberOfStopsList.add(element);
          }
        }
        masterNumberOfStopsList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      } else {
        masterNumberOfStopsList.clear();
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Get airline list
  RxList<AirlineModel> masterAirlineList = <AirlineModel>[].obs;
  RxList<AirlineModel> preferredAirlineList = <AirlineModel>[].obs;
  RxList<String> selectedPreferredAirlines = <String>[].obs;
  Future<void> getAirlineList({bool isLoaderShow = true}) async {
    try {
      List<AirlineModel> airlineModel = await flightRepository.getAirlineListApiCall(isLoaderShow: isLoaderShow);
      if (airlineModel.isNotEmpty) {
        masterAirlineList.clear();
        preferredAirlineList.clear();
        for (AirlineModel element in airlineModel) {
          if (element.status == 1) {
            masterAirlineList.add(element);
            if (element.isPreferred == true) {
              preferredAirlineList.add(element);
            }
          }
        }
        masterAirlineList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        preferredAirlineList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      } else {
        masterAirlineList.clear();
        preferredAirlineList.clear();
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Get calender fares
  RxList<FarePriceSearchResults> farePriceList = <FarePriceSearchResults>[].obs;
  Future<bool> getFlightFarePrice({required List<Map<String, dynamic>> segments, bool isLoaderShow = true}) async {
    try {
      FarePriceModel farePriceModel = await flightRepository.getFlightFareApiCall(
        params: {
          'journeyType': 'ONEWAY',
          'preferredAirlines': selectedPreferredAirlines,
          'sources': null,
          'travelClass': selectedTravelClassCode.value,
          'segments': segments,
          'channel': channelID,
        },
        isLoaderShow: isLoaderShow,
      );
      if (farePriceModel.statusCode == 1) {
        if (farePriceModel.data != null && farePriceModel.data!.response!.searchResults != null) {
          for (FarePriceSearchResults element in farePriceModel.data!.response!.searchResults!) {
            farePriceList.add(element);
          }
          return true;
        } else {
          farePriceList.clear();
          return false;
        }
      } else {
        farePriceList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Reset flight search variabls
  void resetFlightSearchVariables() {
    selectedTripType.value = '';
    fromLocationName.value = 'Delhi';
    fromLocationCode.value = 'DEL';
    toLocationName.value = 'Mumbai';
    toLocationCode.value = 'BOM';
    departureDate.value = '';
    returnDate.value = '';
    travellersAdultCount = 1;
    travellersChildCount = 0;
    travellersInfantCount = 0;
    adultDecreaseColor = ColorsForApp.grayScale500;
    adultIncreaseColor = ColorsForApp.primaryColor;
    childDecreaseColor = ColorsForApp.grayScale500;
    childIncreaseColor = ColorsForApp.primaryColor;
    infantDecreaseColor = ColorsForApp.grayScale500;
    infantIncreaseColor = ColorsForApp.primaryColor;
    travellersCount.value = '';
    selectedTravelClassName.value = masterTravelClassList.isNotEmpty ? masterTravelClassList.first.name ?? '' : '';
    selectedTravelClassCode.value = masterTravelClassList.isNotEmpty ? masterTravelClassList.first.code ?? '' : '';
    selectedSpecialFareName.value = masterFareTypeList.isNotEmpty ? masterFareTypeList.first.name ?? '' : '';
    selectedSpecialFareCode.value = masterFareTypeList.isNotEmpty ? masterFareTypeList.first.code ?? '' : '';
    directFlightCheckBox.value = false;
    preferredAirlineController.clear();
    if (multiStopLocationList.isNotEmpty) {
      multiStopLocationList.clear();
      multiStopLocationList.add(
        MultiStopFromToDateModel(
          fromLocationName: 'Delhi'.obs,
          fromLocationCode: 'DEL'.obs,
          toLocationName: 'Mumbai'.obs,
          toLocationCode: 'BOM'.obs,
          date: DateFormat(flightDateFormat).format(DateTime.now()).obs,
        ),
      );
    }
  }

  //////////////////////////
  /// Flight Search list ///
  //////////////////////////

  Rx<TripType> searchedTripType = TripType.NONE.obs;
  ScrollController onwardScrollController = ScrollController();
  ScrollController returnScrollController = ScrollController();
  // Get dom flight search list
  RxList<FlightData> allFlightList = <FlightData>[].obs;
  RxList<FlightData> filteredFlightList = <FlightData>[].obs;
  RxList<FlightData> allReturnFlightList = <FlightData>[].obs;
  RxList<FlightData> filteredReturnFlightList = <FlightData>[].obs;
  RxList<FlightData> allReturnInternationalMulticityFlightList = <FlightData>[].obs;
  RxList<FlightData> filteredReturnInternationalMulticityFlightList = <FlightData>[].obs;
  FlightData selectedFlightData = FlightData();
  RxInt selectedFlightIndexForReturnFlightDetails = 0.obs;
  RxInt selectedFlightIndexForIntReturnMulticityFlightDetails = 0.obs;

  // Variables for return trip
  RxInt selectedOnewayFlightIndex = (-1).obs;
  RxInt selectedReturnFlightIndex = (-1).obs;
  RxString totalOfferedFareOfReturnFlight = '0'.obs;
  RxString totalPublishedFareOfReturnFlight = '0'.obs;
  FlightData selectedOnwardFlightData = FlightData();
  FlightData selectedReturnFlightData = FlightData();

  // Calculate total fare according to selected flight
  calculateTotalPrice() {
    if (selectedOnewayFlightIndex.value >= 0 && selectedReturnFlightIndex.value >= 0) {
      // Offered price
      double departureOfferedPrice = double.parse(filteredFlightList[selectedOnewayFlightIndex.value].offeredFare ?? '0');
      double returnOfferedPrice = double.parse(filteredReturnFlightList[selectedReturnFlightIndex.value].offeredFare ?? '0');
      totalOfferedFareOfReturnFlight.value = (departureOfferedPrice + returnOfferedPrice).toString();
      // Published price
      double departurePublishedPrice = double.parse(filteredFlightList[selectedOnewayFlightIndex.value].publishedFare ?? '0');
      double returnPublishedPrice = double.parse(filteredReturnFlightList[selectedReturnFlightIndex.value].publishedFare ?? '0');
      totalPublishedFareOfReturnFlight.value = (departurePublishedPrice + returnPublishedPrice).toString();
    }
  }

  // Get new flight search list
  Future<void> getFlightSearchList({required List<Map<String, dynamic>> segments, bool isLoaderShow = true}) async {
    try {
      FlightSearchModel flightSearchModel = await flightRepository.getFlightSearchApiCall(
        params: {
          'journeyType': selectedTripType.value,
          'segments': segments,
          'adultCount': travellersAdultCount.toString(),
          'childCount': travellersChildCount.toString(),
          'infantCount': travellersInfantCount.toString(),
          'travelClass': selectedTravelClassCode.value,
          'travelStop': directFlightCheckBox.value == true ? 'NONSTOP' : '',
          'resultFareType': selectedSpecialFareCode.value,
          'preferredAirlines': selectedPreferredAirlines,
          'sources': null,
          'channel': channelID,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (flightSearchModel.statusCode == 1) {
        allFlightList.clear();
        filteredFlightList.clear();
        allReturnFlightList.clear();
        filteredReturnFlightList.clear();
        allReturnInternationalMulticityFlightList.clear();
        switch (selectedTripType.value) {
          case 'ONEWAY':
            searchedTripType.value = flightSearchModel.isINT ?? false ? TripType.ONEWAY_INT : TripType.ONEWAY_DOM;
            break;
          case 'RETURN':
            searchedTripType.value = flightSearchModel.isINT ?? false ? TripType.RETURN_INT : TripType.RETURN_DOM;
            break;
          case 'MULTICITY':
            searchedTripType.value = flightSearchModel.isINT ?? false ? TripType.MULTICITY_INT : TripType.MULTICITY_DOM;
            break;
          default:
            searchedTripType.value = TripType.NONE;
        }
        if (searchedTripType.value == TripType.RETURN_INT || searchedTripType.value == TripType.MULTICITY_DOM || searchedTripType.value == TripType.MULTICITY_INT) {
          // For international return | multicity flight list
          if (flightSearchModel.data != null && flightSearchModel.data!.isNotEmpty) {
            allReturnInternationalMulticityFlightList.value = flightSearchModel.data!.map((element) {
              return FlightData.fromJson(element.toJson());
            }).toList();
            filteredReturnInternationalMulticityFlightList.value = sortFlights(flightList: allReturnInternationalMulticityFlightList, sortCriteria: selectedSortingMethod.value);
            generateFiltersDataFromFlightsList(flightList: filteredReturnInternationalMulticityFlightList);
          }
        } else {
          if (flightSearchModel.data != null && flightSearchModel.data!.isNotEmpty) {
            // For oneway | onward flight list
            allFlightList.value = flightSearchModel.data!.map((element) {
              return FlightData.fromJson(element.toJson());
            }).toList();
            filteredFlightList.value = sortFlights(flightList: allFlightList, sortCriteria: selectedSortingMethod.value);
            generateFiltersDataFromFlightsList(flightList: filteredFlightList);
          }
          if (searchedTripType.value == TripType.RETURN_DOM && flightSearchModel.returnData != null && flightSearchModel.returnData!.isNotEmpty) {
            // For return flight list
            allReturnFlightList.value = flightSearchModel.returnData!.map((element) {
              return FlightData.fromJson(element.toJson());
            }).toList();
            filteredReturnFlightList.value = sortFlights(flightList: allReturnFlightList, sortCriteria: selectedReturnSortingMethod.value);
            generateFiltersDataFromFlightsList(flightList: filteredReturnFlightList);
          }
        }
      } else {
        switch (selectedTripType.value) {
          case 'ONEWAY':
            searchedTripType.value = flightSearchModel.isINT ?? false ? TripType.ONEWAY_INT : TripType.ONEWAY_DOM;
            break;
          case 'RETURN':
            searchedTripType.value = flightSearchModel.isINT ?? false ? TripType.RETURN_INT : TripType.RETURN_DOM;
            break;
          case 'MULTICITY':
            searchedTripType.value = flightSearchModel.isINT ?? false ? TripType.MULTICITY_INT : TripType.MULTICITY_DOM;
            break;
          default:
            searchedTripType.value = TripType.NONE;
        }
        allFlightList.clear();
        allReturnFlightList.clear();
        allReturnInternationalMulticityFlightList.clear();
        filteredFlightList.clear();
        filteredReturnFlightList.clear();
        filteredReturnInternationalMulticityFlightList.clear();
        errorSnackBar(message: flightSearchModel.message ?? '');
      }
    } catch (e) {
      debugPrint(e.toString());
      dismissProgressIndicator();
    }
  }

  // Reset oneway/return searched flights variables
  void resetOnewayReturnSearchedFlightVariables() {
    allFlightList.clear();
    allReturnFlightList.clear();
    allReturnInternationalMulticityFlightList.clear();
    filteredFlightList.clear();
    filteredReturnFlightList.clear();
    filteredReturnInternationalMulticityFlightList.clear();
    flightFilterModelList.clear();
    selectedFlightData = FlightData();
    selectedOnewayFlightIndex.value = (-1);
    selectedReturnFlightIndex.value = (-1);
    totalOfferedFareOfReturnFlight.value = '0';
    totalPublishedFareOfReturnFlight.value = '0';
    passengerListForExtraServices.clear();
    clearAllFilter();
    selectedSortingMethod.value = 'Cheapest';
    selectedReturnSortingMethod.value = 'Cheapest';
    searchedTripType.value = TripType.NONE;
  }

  ////////////////////////////
  /// Search Flight Filter ///
  ////////////////////////////

  // Oneway/Onward flights filter
  RxBool isFilterApplied = false.obs;
  RxInt selectedFlightIndexForFilter = 0.obs;
  RxList<FlightFilterModel> flightFilterModelList = <FlightFilterModel>[].obs;
  List<Map<String, dynamic>> selectedFlightFiltersList = <Map<String, dynamic>>[];

  // Get filtered count
  int getFilteredCount() {
    int tempCount = 0;
    if (selectedFlightFiltersList.isNotEmpty) {
      for (Map<String, dynamic> element in selectedFlightFiltersList) {
        if (element.isNotEmpty) {
          tempCount = tempCount + element.length;
        }
      }
    }
    return tempCount;
  }

  // Generate filters data from flights list
  generateFiltersDataFromFlightsList({required List<FlightData> flightList}) {
    for (int i = 0; i < flightList.first.details!.length; i++) {
      List minMaxPriceList = minMaxPrice(flightList: flightList);
      flightFilterModelList.add(
        FlightFilterModel.fromJson({
          'source': flightList.first.details![i].first.sourceCity!,
          'destination': flightList.first.details![i].first.destinationCity!,
          'sourceCode': flightList.first.details![i].first.sourceAirportCode!,
          'destinationCode': flightList.first.details![i].first.destinationAirportCode!,
          'date': flightList.first.details![i].first.departure!,
          'stopsList': getStopsListForFilter(flightList: flightList, index: i),
          'minPrice': minMaxPriceList[0],
          'maxPrice': minMaxPriceList[1],
          'airlinesList': getAirlineNameListForFilter(flightList: flightList, index: i),
          'priceRange': minMaxPriceList[2],
        }),
      );
    }
  }

  // Stops list for filter
  Map<String, String> getStopsListForFilter({required List<FlightData> flightList, required int index}) {
    Map<String, String> tempStopsList = <String, String>{};
    tempStopsList.clear();
    for (FlightData flightData in flightList) {
      String stops = flightData.details![index].first.stops != null && flightData.details![index].first.stops!.isNotEmpty ? flightData.details![index].first.stops ?? '0' : '0';
      double offeredFare = double.parse(flightData.offeredFare ?? '0');
      if (!tempStopsList.containsKey(stops) || offeredFare < double.parse(tempStopsList[stops] ?? '0')) {
        tempStopsList[stops] = offeredFare.toString();
      }
    }
    return tempStopsList;
  }

  //  Min | Max price for filter
  List minMaxPrice({required List<FlightData> flightList}) {
    double minPrice = 0.0;
    double maxPrice = 0.0;
    RangeValues priceRange = RangeValues(minPrice, maxPrice);
    minPrice = double.parse(flightList.first.offeredFare!);
    maxPrice = double.parse(flightList.first.offeredFare!);
    for (FlightData element in flightList) {
      if (element.offeredFare != null && element.offeredFare!.isNotEmpty) {
        double currentPrice = double.parse(element.offeredFare!);
        if (minPrice > currentPrice) {
          minPrice = currentPrice;
        }
        if (minPrice < currentPrice) {
          maxPrice = currentPrice;
        }
      }
    }
    priceRange = RangeValues(minPrice, maxPrice);
    return [minPrice, maxPrice, priceRange];
  }

  // Airline list for filter
  Map<String, Map<String, String>> getAirlineNameListForFilter({required List<FlightData> flightList, required int index}) {
    Map<String, Map<String, String>> tempAirlineNameList = <String, Map<String, String>>{};
    tempAirlineNameList.clear();
    for (FlightData flightData in flightList) {
      String airlineName = flightData.details![index].first.airlineName != null && flightData.details![index].first.airlineName!.isNotEmpty ? flightData.details![index].first.airlineName! : '';
      String airlineLogo = flightData.details![index].first.airlineLogo != null && flightData.details![index].first.airlineLogo!.isNotEmpty ? flightData.details![index].first.airlineLogo! : '';
      double offeredFare = double.parse(flightData.offeredFare ?? '0');
      if (!tempAirlineNameList.containsKey(airlineName) || offeredFare < double.parse(tempAirlineNameList[airlineName]!['price'] ?? '0')) {
        tempAirlineNameList[airlineName] = {
          'airlineLogo': airlineLogo,
          'price': offeredFare.toString(),
        };
      }
    }
    return tempAirlineNameList;
  }

  // Make selected filter map
  List<Map<String, dynamic>> makeSelectedFilter() {
    List<Map<String, dynamic>> filters = <Map<String, dynamic>>[];
    for (int i = 0; i < flightFilterModelList.length; i++) {
      Map<String, dynamic> filtersMap = <String, dynamic>{};
      // Add hide non refundable flights
      if (flightFilterModelList[i].isHideNonRefundable!.value == true) {
        if (searchedTripType.value == TripType.RETURN_DOM) {
          filtersMap['hideNonRefundableFlights'] = flightFilterModelList[i].isHideNonRefundable!.value;
        } else {
          filtersMap['hideNonRefundableFlights'] = flightFilterModelList[0].isHideNonRefundable!.value;
        }
      }
      // Add selected stops
      if (flightFilterModelList[i].selectedStops!.value.isNotEmpty) {
        filtersMap['stops'] = flightFilterModelList[i].selectedStops!.value;
      }
      // Add price range
      if (flightFilterModelList[i].minPrice!.value < flightFilterModelList[i].priceRange!.value.start) {
        if (searchedTripType.value == TripType.RETURN_DOM) {
          filtersMap['minPrice'] = flightFilterModelList[i].priceRange!.value.start;
        } else {
          filtersMap['minPrice'] = flightFilterModelList[0].priceRange!.value.start;
        }
      }
      if (flightFilterModelList[i].maxPrice!.value > flightFilterModelList[i].priceRange!.value.end) {
        if (searchedTripType.value == TripType.RETURN_DOM) {
          filtersMap['maxPrice'] = flightFilterModelList[i].priceRange!.value.end;
        } else {
          filtersMap['maxPrice'] = flightFilterModelList[0].priceRange!.value.end;
        }
      }
      // Add selected departure time options
      if (flightFilterModelList[i].isSelectedEarlyMorningDeparture!.value == true) {
        filtersMap['earlyMorningDeparture'] = TimeRange(const TimeOfDay(hour: 0, minute: 0), const TimeOfDay(hour: 5, minute: 59));
      }
      if (flightFilterModelList[i].isSelectedMorningDeparture!.value == true) {
        filtersMap['morningDeparture'] = TimeRange(const TimeOfDay(hour: 6, minute: 0), const TimeOfDay(hour: 11, minute: 59));
      }
      if (flightFilterModelList[i].isSelectedAfternoonDeparture!.value == true) {
        filtersMap['afternoonDeparture'] = TimeRange(const TimeOfDay(hour: 12, minute: 0), const TimeOfDay(hour: 17, minute: 59));
      }
      if (flightFilterModelList[i].isSelectedEveningDeparture!.value == true) {
        filtersMap['eveningDeparture'] = TimeRange(const TimeOfDay(hour: 18, minute: 0), const TimeOfDay(hour: 23, minute: 59));
      }
      // Add selected arrival time options
      if (flightFilterModelList[i].isSelectedEarlyMorningArrival!.value == true) {
        filtersMap['earlyMorningArrival'] = TimeRange(const TimeOfDay(hour: 0, minute: 0), const TimeOfDay(hour: 5, minute: 59));
      }
      if (flightFilterModelList[i].isSelectedMorningArrival!.value == true) {
        filtersMap['morningArrival'] = TimeRange(const TimeOfDay(hour: 6, minute: 0), const TimeOfDay(hour: 11, minute: 59));
      }
      if (flightFilterModelList[i].isSelectedAfternoonArrival!.value == true) {
        filtersMap['afternoonArrival'] = TimeRange(const TimeOfDay(hour: 12, minute: 0), const TimeOfDay(hour: 17, minute: 59));
      }
      if (flightFilterModelList[i].isSelectedEveningArrival!.value == true) {
        filtersMap['eveningArrival'] = TimeRange(const TimeOfDay(hour: 18, minute: 0), const TimeOfDay(hour: 23, minute: 59));
      }
      // Add selected airline names
      if (flightFilterModelList[i].selectedAirlinesList!.isNotEmpty) {
        filtersMap['airlineName'] = flightFilterModelList[i].selectedAirlinesList!;
      }

      filters.add(filtersMap);
    }
    return filters;
  }

  // Get filtered flight list
  List<FlightData> getFilteredFlightList({required List<FlightData> allFlightList, int? index}) {
    selectedFlightFiltersList = makeSelectedFilter();

    // If there are no filters, return all flights
    if (selectedFlightFiltersList.isEmpty) {
      isFilterApplied.value = false;
      return allFlightList;
    }

    // Apply filters to the list of flights
    List<FlightData> filteredFlights = allFlightList.where((flightData) {
      // Iterate through each filter
      for (int i = 0; i < selectedFlightFiltersList.length; i++) {
        Map<String, dynamic> currentFilter = selectedFlightFiltersList[index ?? i];
        if (currentFilter.isEmpty) continue;
        // Apply each filter to the flight data
        DateTime departure = DateTime.now();
        DateTime arrival = DateTime.now();
        if (flightData.details!.isNotEmpty && flightData.details!.first.isNotEmpty) {
          departure = DateTime(0, 1, 1, DateTime.parse(flightData.details![index ?? i].first.departure ?? '').hour, DateTime.parse(flightData.details![index ?? i].first.departure ?? '').minute);
          arrival = DateTime(0, 1, 1, DateTime.parse(flightData.details![index ?? i].first.arrival ?? '').hour, DateTime.parse(flightData.details![index ?? i].first.arrival ?? '').minute);
        }

        // Check for departure time ranges
        bool isDepartureTimeInRange = currentFilter.entries.where((filter) {
          String key = filter.key;
          dynamic value = filter.value;
          if (key == 'earlyMorningDeparture' || key == 'morningDeparture' || key == 'afternoonDeparture' || key == 'eveningDeparture') {
            value as TimeRange;
            DateTime minDateTime = DateTime(0, 1, 1, value.minTime.hour, value.minTime.minute);
            DateTime maxDateTime = DateTime(0, 1, 1, value.maxTime.hour, value.maxTime.minute);
            return departure.isAfter(minDateTime) && departure.isBefore(maxDateTime);
          } else {
            return false;
          }
        }).isNotEmpty;

        // Check for arrival time ranges
        bool isArrivalTimeInRange = currentFilter.entries.where((filter) {
          String key = filter.key;
          dynamic value = filter.value;
          if (key == 'earlyMorningArrival' || key == 'morningArrival' || key == 'afternoonArrival' || key == 'eveningArrival') {
            value as TimeRange;
            DateTime minDateTime = DateTime(0, 1, 1, value.minTime.hour, value.minTime.minute);
            DateTime maxDateTime = DateTime(0, 1, 1, value.maxTime.hour, value.maxTime.minute);
            return arrival.isAfter(minDateTime) && arrival.isBefore(maxDateTime);
          } else {
            return false;
          }
        }).isNotEmpty;

        bool matchesFilter = currentFilter.entries.every((filter) {
          String key = filter.key;
          dynamic value = filter.value;

          // Use helper functions for clarity and consistency
          switch (key) {
            case 'hideNonRefundableFlights':
              return flightData.isRefundable ?? false;
            case 'stops':
              return checkStops(flightData.details![index ?? i].first, value);
            case 'minPrice':
              return checkPrice(flightData.offeredFare, minValue: value);
            case 'maxPrice':
              return checkPrice(flightData.offeredFare, maxValue: value);
            case 'earlyMorningDeparture':
            case 'morningDeparture':
            case 'afternoonDeparture':
            case 'eveningDeparture':
              return isDepartureTimeInRange;
            case 'earlyMorningArrival':
            case 'morningArrival':
            case 'afternoonArrival':
            case 'eveningArrival':
              return isArrivalTimeInRange;
            case 'airlineName':
              return checkAirlineName(flightData.details![index ?? i].first.airlineName, value);
            default:
              return true;
          }
        });

        if (!matchesFilter) {
          return false; // Return false if any filter does not match
        }
      }
      // If all filters match, return true
      return true;
    }).toList();

    isFilterApplied.value = true;
    return filteredFlights;
  }

  // Get filtered return flight list
  List<FlightData> getFilteredReturnFlightList({required List<FlightData> allFlightList}) {
    selectedFlightFiltersList = makeSelectedFilter();

    // If there are no filters, return all flights
    if (selectedFlightFiltersList.isEmpty) {
      isFilterApplied.value = false;
      return allFlightList;
    }

    // Apply filters to the list of flights
    List<FlightData> filteredFlights = allFlightList.where((flightData) {
      // Iterate through each filter
      for (int i = 0; i < selectedFlightFiltersList.length; i++) {
        Map<String, dynamic> currentFilter = selectedFlightFiltersList[1];
        if (currentFilter.isEmpty) continue;
        // Apply each filter to the flight data
        DateTime departure = DateTime.now();
        DateTime arrival = DateTime.now();
        if (flightData.details!.isNotEmpty && flightData.details!.first.isNotEmpty) {
          departure = DateTime(0, 1, 1, DateTime.parse(flightData.details![0].first.departure ?? '').hour, DateTime.parse(flightData.details![0].first.departure ?? '').minute);
          arrival = DateTime(0, 1, 1, DateTime.parse(flightData.details![0].first.arrival ?? '').hour, DateTime.parse(flightData.details![0].first.arrival ?? '').minute);
        }

        // Check for departure time ranges
        bool isDepartureTimeInRange = currentFilter.entries.where((filter) {
          String key = filter.key;
          dynamic value = filter.value;
          if (key == 'earlyMorningDeparture' || key == 'morningDeparture' || key == 'afternoonDeparture' || key == 'eveningDeparture') {
            value as TimeRange;
            DateTime minDateTime = DateTime(0, 1, 1, value.minTime.hour, value.minTime.minute);
            DateTime maxDateTime = DateTime(0, 1, 1, value.maxTime.hour, value.maxTime.minute);
            return departure.isAfter(minDateTime) && departure.isBefore(maxDateTime);
          } else {
            return false;
          }
        }).isNotEmpty;

        // Check for arrival time ranges
        bool isArrivalTimeInRange = currentFilter.entries.where((filter) {
          String key = filter.key;
          dynamic value = filter.value;
          if (key == 'earlyMorningArrival' || key == 'morningArrival' || key == 'afternoonArrival' || key == 'eveningArrival') {
            value as TimeRange;
            DateTime minDateTime = DateTime(0, 1, 1, value.minTime.hour, value.minTime.minute);
            DateTime maxDateTime = DateTime(0, 1, 1, value.maxTime.hour, value.maxTime.minute);
            return arrival.isAfter(minDateTime) && arrival.isBefore(maxDateTime);
          } else {
            return false;
          }
        }).isNotEmpty;

        bool matchesFilter = currentFilter.entries.every((filter) {
          String key = filter.key;
          dynamic value = filter.value;

          // Use helper functions for clarity and consistency
          switch (key) {
            case 'hideNonRefundableFlights':
              return flightData.isRefundable ?? false;
            case 'stops':
              return checkStops(flightData.details![0].first, value);
            case 'minPrice':
              return checkPrice(flightData.offeredFare, minValue: value);
            case 'maxPrice':
              return checkPrice(flightData.offeredFare, maxValue: value);
            case 'earlyMorningDeparture':
            case 'morningDeparture':
            case 'afternoonDeparture':
            case 'eveningDeparture':
              return isDepartureTimeInRange;
            case 'earlyMorningArrival':
            case 'morningArrival':
            case 'afternoonArrival':
            case 'eveningArrival':
              return isArrivalTimeInRange;
            case 'airlineName':
              return checkAirlineName(flightData.details![0].first.airlineName, value);
            default:
              return true;
          }
        });

        if (!matchesFilter) {
          return false; // Return false if any filter does not match
        }
      }
      // If all filters match, return true
      return true;
    }).toList();

    isFilterApplied.value = true;
    return filteredFlights;
  }

  // Define helper functions for filtering
  bool checkStops(FlightDetails flightDetails, String value) {
    String stops = flightDetails.stops ?? '0';
    int flightStops = int.parse(stops);
    int filteredStops = int.parse(value);
    return filteredStops == 0 || filteredStops == 1
        ? flightStops == filteredStops
        : filteredStops >= 2
            ? flightStops >= filteredStops
            : false;
  }

  bool checkPrice(String? offeredFare, {double? minValue, double? maxValue}) {
    if (offeredFare == null || offeredFare.isEmpty) return false;
    double price = double.parse(offeredFare);
    if (minValue != null && price < minValue) return false;
    if (maxValue != null && price > maxValue) return false;
    return true;
  }

  bool checkAirlineName(String? airlineName, List<String> selectedAirlines) {
    if (airlineName == null) return false;
    return selectedAirlines.contains(airlineName);
  }

  // Clear all filter
  clearAllFilter() {
    flightFilterModelList.value = flightFilterModelList.map((element) {
      return FlightFilterModel.fromJson({
        'source': element.source!.value,
        'destination': element.destination!.value,
        'sourceCode': element.sourceCode!.value,
        'destinationCode': element.destinationCode!.value,
        'date': element.date!.value,
        'stopsList': element.stopsList!,
        'minPrice': element.minPrice!.value,
        'maxPrice': element.maxPrice!.value,
        'airlinesList': element.airlinesList!,
        'priceRange': RangeValues(element.minPrice!.value, element.maxPrice!.value),
      });
    }).toList();
    isFilterApplied.value = false;
    selectedFlightIndexForFilter.value = 0;
    filteredFlightList.value = allFlightList;
    filteredReturnFlightList.value = allReturnFlightList;
    filteredReturnInternationalMulticityFlightList.value = allReturnInternationalMulticityFlightList;
  }

  /// Sort ///
  RxString selectedSortingMethod = 'Cheapest'.obs;
  RxString selectedReturnSortingMethod = 'Cheapest'.obs;
  List sortingMethodsList = ['Cheapest', 'Early Departure', 'Early Arrival', 'Late Departure', 'Late Arrival', 'Fastest'];

  List<FlightData> sortFlights({required List<FlightData> flightList, required String sortCriteria}) {
    List<FlightData> tempFlightList = flightList.map((e) => FlightData.fromJson(e.toJson())).toList();
    tempFlightList.sort((a, b) {
      switch (sortCriteria) {
        case 'Cheapest':
          final double aFare = double.parse(a.offeredFare ?? '0');
          final double bFare = double.parse(b.offeredFare ?? '0');
          return aFare.compareTo(bFare);
        case 'Early Departure':
          final DateTime aDeparture = DateTime.tryParse(a.details?.first.first.departure ?? '') ?? DateTime.now();
          final DateTime bDeparture = DateTime.tryParse(b.details?.first.first.departure ?? '') ?? DateTime.now();
          return aDeparture.compareTo(bDeparture);
        case 'Early Arrival':
          final DateTime aArrival = DateTime.tryParse(a.details?.first.first.arrival ?? '') ?? DateTime.now();
          final DateTime bArrival = DateTime.tryParse(b.details?.first.first.arrival ?? '') ?? DateTime.now();
          return aArrival.compareTo(bArrival);
        case 'Late Departure':
          final DateTime aDeparture = DateTime.tryParse(a.details?.first.first.departure ?? '') ?? DateTime.now();
          final DateTime bDeparture = DateTime.tryParse(b.details?.first.first.departure ?? '') ?? DateTime.now();
          return bDeparture.compareTo(aDeparture);
        case 'Late Arrival':
          final DateTime aArrival = DateTime.tryParse(a.details?.first.first.arrival ?? '') ?? DateTime.now();
          final DateTime bArrival = DateTime.tryParse(b.details?.first.first.arrival ?? '') ?? DateTime.now();
          return bArrival.compareTo(aArrival);
        case 'Fastest':
          final int aFastest = int.parse(a.details?.first.first.totalDuration ?? '0');
          final int bFastest = int.parse(b.details?.first.first.totalDuration ?? '0');
          return aFastest.compareTo(bFastest);
        default:
          return 0;
      }
    });
    return tempFlightList;
  }

  //////////////////////
  /// Flight Details ///
  //////////////////////

  // Get flight fare quote
  Rx<FareQuoteData> flightFareQuoteData = FareQuoteData().obs;
  Rx<FareQuoteData> onwardFlightFareQuoteData = FareQuoteData().obs;
  Rx<FareQuoteData> returnFlightFareQuoteData = FareQuoteData().obs;
  Future<FareQuoteData> getFlightFareQuote({required String token, required String resultIndex, bool isLoaderShow = true}) async {
    try {
      FlightFareQuoteModel flightFareQuoteModel = await flightRepository.getFlightFareQuoteApiCall(
        params: {
          'token': token,
          'resultIndex': resultIndex,
          'channel': channelID,
        },
        isLoaderShow: isLoaderShow,
      );
      if (flightFareQuoteModel.statusCode == 1 && flightFareQuoteModel.data != null) {
        flightFareQuoteData.value = flightFareQuoteModel.data!;
        return flightFareQuoteModel.data!;
      } else {
        debugPrint(flightFareQuoteModel.message ?? '');
        return FareQuoteData();
      }
    } catch (e) {
      dismissProgressIndicator();
      return FareQuoteData();
    }
  }

  // Get flight fare rule
  Rx<FareRuleData> flightFareRuleData = FareRuleData().obs;
  Rx<FareRuleData> onwardFlightFareRuleData = FareRuleData().obs;
  Rx<FareRuleData> returnFlightFareRuleData = FareRuleData().obs;
  Future<FareRuleData> getFlightFareRule({required String token, required String resultIndex, bool isLoaderShow = true}) async {
    try {
      FlightFareRuleModel flightFareRuleModel = await flightRepository.getFlightFareRuleApiCall(
        params: {
          'token': token,
          'resultIndex': resultIndex,
          'channel': channelID,
        },
        isLoaderShow: isLoaderShow,
      );
      if (flightFareRuleModel.statusCode == 1) {
        flightFareRuleData.value = flightFareRuleModel.fareRule!;
        return flightFareRuleModel.fareRule!;
      } else {
        debugPrint(flightFareRuleModel.message ?? '');
        return FareRuleData();
      }
    } catch (e) {
      dismissProgressIndicator();
      return FareRuleData();
    }
  }

  // Calculate total fare breakup
  String calculateTotalFareBreakup({String? onwardFare, String? returnFare, String? onwardDiscount, String? returnDiscount, String? seatPrice, String? mealPrice, String? baggagePrice}) {
    return ((double.parse(onwardFare ?? '0') + double.parse(returnFare ?? '0')) -
            (double.parse(onwardDiscount ?? '0') + double.parse(returnDiscount ?? '0')) +
            double.parse(seatPrice ?? '0') +
            double.parse(mealPrice ?? '0') +
            double.parse(baggagePrice ?? '0'))
        .toStringAsFixed(2);
  }

  // Reset oneway/return flights details variables
  void resetOnewayReturnFlightDetailsVariables() {
    selectedFlightIndexForReturnFlightDetails.value = 0;
    selectedFlightIndexForIntReturnMulticityFlightDetails.value = 0;
    flightFareQuoteData.value = FareQuoteData();
    onwardFlightFareQuoteData.value = FareQuoteData();
    returnFlightFareQuoteData.value = FareQuoteData();
    flightFareRuleData.value = FareRuleData();
    onwardFlightFareRuleData.value = FareRuleData();
    returnFlightFareRuleData.value = FareRuleData();
  }

////////////////////////
  /// Extra services ///
  //////////////////////

  Rx<FlightSsrData> flightSsrData = FlightSsrData().obs;
  Rx<FlightSsrData> onwardFlightSsrData = FlightSsrData().obs;
  Rx<FlightSsrData> returnFlightSsrData = FlightSsrData().obs;

  // Get flight extra services
  Future<FlightSsrData> getFlightSsr({required String token, required String resultIndex, bool isReturn = false, bool isLoaderShow = true}) async {
    try {
      FlightSsrModel flightSsrModel = await flightRepository.getFlightSsrApiCall(
        params: {
          'token': token,
          'resultIndex': resultIndex,
          'channel': channelID,
        },
        isLoaderShow: isLoaderShow,
      );
      if (flightSsrModel.statusCode == 1 && flightSsrModel.data != null) {
        getFlightListFromSsr(flightSsrData: flightSsrModel.data!, isReturn: isReturn);
        return flightSsrModel.data!;
      } else {
        return FlightSsrData();
      }
    } catch (e) {
      dismissProgressIndicator();
      return FlightSsrData();
    }
  }

  // Generate flights list from ssr data
  RxList<SsrFlightListModel> seatFlightList = <SsrFlightListModel>[].obs;
  RxList<SsrFlightListModel> mealFlightList = <SsrFlightListModel>[].obs;
  RxList<SsrFlightListModel> intMealFlightList = <SsrFlightListModel>[].obs;
  RxList<SsrFlightListModel> baggageFlightList = <SsrFlightListModel>[].obs;

  getFlightListFromSsr({required FlightSsrData flightSsrData, bool isReturn = false}) {
    // For seatServices
    if (flightSsrData.seatServices != null && flightSsrData.seatServices!.isNotEmpty) {
      for (SeatServices seatServices in flightSsrData.seatServices!) {
        SeatData seatData = seatServices.seatSegment!.first.seat!.firstWhere(
          (element) =>
              element.airlineCode != null &&
              element.airlineCode!.isNotEmpty &&
              element.flightNumber != null &&
              element.flightNumber!.isNotEmpty &&
              element.origin != null &&
              element.origin!.isNotEmpty &&
              element.destination != null &&
              element.destination!.isNotEmpty,
        );
        if (seatData.airlineCode != null && seatData.airlineCode!.isNotEmpty) {
          seatFlightList.add(
            SsrFlightListModel(
              origin: seatData.origin,
              destination: seatData.destination,
              airlineCode: seatData.airlineCode,
              flightNumber: seatData.flightNumber,
              airlineLogo: masterAirlineList.firstWhere((element) => seatData.airlineCode != null && seatData.airlineCode!.isNotEmpty ? element.code == seatData.airlineCode : false).fileURL,
              passengerDetailsList: passengerListForExtraServices.map((passenger) => PassengerDetailsModel.fromJson(passenger.toJson())).toList(),
              flightsSeatList: setSeatList(seatServices: seatServices),
              tripType: isReturn == true ? 'RETURN' : 'ONWARD',
            ),
          );
        }
      }
    }

    // For mealServices
    if (flightSsrData.mealServices != null && flightSsrData.mealServices!.isNotEmpty) {
      for (MealServices mealServices in flightSsrData.mealServices!) {
        MealData mealData = mealServices.mealSegment!.firstWhere(
          (element) => element.origin != null && element.origin!.isNotEmpty && element.destination != null && element.destination!.isNotEmpty,
        );
        mealFlightList.add(
          SsrFlightListModel(
            origin: mealData.origin,
            destination: mealData.destination,
            airlineCode: mealData.airlineCode,
            flightNumber: mealData.flightNumber,
            airlineLogo: masterAirlineList.firstWhereOrNull((element) => mealData.airlineCode != null && mealData.airlineCode!.isNotEmpty ? element.code == mealData.airlineCode : false)?.fileURL ?? '',
            passengerDetailsList: setMealPassengerList(mealDataList: mealServices.mealSegment != null && mealServices.mealSegment!.isNotEmpty ? mealServices.mealSegment! : null),
            tripType: isReturn == true ? 'RETURN' : 'ONWARD',
          ),
        );
      }
    }
    // For intMealServices
    else if (flightSsrData.intMealServices != null && flightSsrData.intMealServices!.isNotEmpty) {
      intMealFlightList.add(
        SsrFlightListModel(
          passengerDetailsList: setMealPassengerList(intMealDataList: flightSsrData.intMealServices != null && flightSsrData.intMealServices!.isNotEmpty ? flightSsrData.intMealServices! : null),
          tripType: isReturn == true ? 'RETURN' : 'ONWARD',
        ),
      );
    }

    // For baggageServices
    if (flightSsrData.baggageServices != null && flightSsrData.baggageServices!.isNotEmpty) {
      for (BaggageServices baggageServices in flightSsrData.baggageServices!) {
        BaggageData baggageData = baggageServices.baggageSegment!.firstWhere(
          (element) => element.origin != null && element.origin!.isNotEmpty && element.destination != null && element.destination!.isNotEmpty,
        );
        baggageFlightList.add(
          SsrFlightListModel(
            origin: baggageData.origin,
            destination: baggageData.destination,
            airlineCode: baggageData.airlineCode,
            flightNumber: baggageData.flightNumber,
            airlineLogo: masterAirlineList.firstWhereOrNull((element) => baggageData.airlineCode != null && baggageData.airlineCode!.isNotEmpty ? element.code == baggageData.airlineCode : false)?.fileURL ?? '',
            passengerDetailsList: setBaggagePassengerList(baggageDataList: baggageServices.baggageSegment != null && baggageServices.baggageSegment!.isNotEmpty ? baggageServices.baggageSegment : null),
            tripType: isReturn == true ? 'RETURN' : 'ONWARD',
          ),
        );
      }
    }
  }

  RxString selectedExtraServices = 'Seat'.obs;
  RxInt selectedFlightIndexForSeatServices = 0.obs;
  RxInt selectedFlightIndexForMealServices = 0.obs;
  RxInt selectedFlightIndexForBaggageServices = 0.obs;
  RxInt selectedPassengerIndexForExtraServices = 0.obs;
  RxString totalSeatCount = '0'.obs;
  RxString totalSeatPrice = '0'.obs;
  RxString totalMealCount = '0'.obs;
  RxString totalMealPrice = '0'.obs;
  RxString totalBaggageCount = '0'.obs;
  RxString totalBaggagePrice = '0'.obs;

  // Set seat list
  SeatLayoutModel setSeatList({SeatServices? seatServices}) {
    SeatLayoutModel seatLayoutModel = SeatLayoutModel();
    if (seatServices != null && seatServices.seatSegment != null && seatServices.seatSegment!.isNotEmpty) {
      seatLayoutModel = SeatLayoutModel(
        maxRowCount: 0.obs,
        maxColumnCount: 0.obs,
        maxSeatsServiceForColumnHeader: SeatSegmentData(),
        flightSeatList: seatServices.seatSegment!.obs,
      );

      for (SeatSegmentData seatSegment in seatServices.seatSegment!) {
        for (SeatData seat in seatSegment.seat!) {
          if (seat.code != 'NoSeat') {
            int maxCount = seat.code!.codeUnitAt(seat.code!.length - 1) - 'A'.codeUnitAt(0) + 1;
            if (maxCount > seatLayoutModel.maxColumnCount!.value) {
              seatLayoutModel.maxColumnCount!.value = maxCount;
              seatLayoutModel.maxSeatsServiceForColumnHeader = seatSegment;
            }
          }
        }
      }
      seatLayoutModel.maxRowCount!.value = seatLayoutModel.flightSeatList!.length;
    }
    return SeatLayoutModel.fromJson(seatLayoutModel.toJson());
  }

  // Set meal list
  List<PassengerDetailsModel> setMealPassengerList({List<MealData>? mealDataList, List<IntMealData>? intMealDataList}) {
    List<PassengerDetailsModel> passengerDetailsList = passengerListForExtraServices.map((passenger) => PassengerDetailsModel.fromJson(passenger.toJson())).toList();
    if (mealDataList != null && mealDataList.isNotEmpty) {
      List<MealData> tempMealList = <MealData>[];
      for (MealData meal in mealDataList) {
        if (meal.code != null && meal.code!.isNotEmpty && meal.code != 'NoMeal') {
          tempMealList.add(meal);
        }
      }
      for (PassengerDetailsModel passenger in passengerDetailsList) {
        passenger.mealDataList = tempMealList.map((e) => MealData.fromJson(e.toJson())).toList();
      }
    } else if (intMealDataList != null && intMealDataList.isNotEmpty) {
      List<IntMealData> tempIntMealList = <IntMealData>[];
      for (IntMealData meal in intMealDataList) {
        if (meal.code != null && meal.code!.isNotEmpty && meal.description != null && meal.description!.isNotEmpty) {
          tempIntMealList.add(meal);
        }
      }
      for (PassengerDetailsModel passenger in passengerDetailsList) {
        passenger.intMealList = tempIntMealList.map((e) => IntMealData.fromJson(e.toJson())).toList();
      }
    }
    return passengerDetailsList;
  }

  // Set baggage list
  List<PassengerDetailsModel> setBaggagePassengerList({List<BaggageData>? baggageDataList}) {
    List<PassengerDetailsModel> passengerDetailsList = passengerListForExtraServices.map((passenger) => PassengerDetailsModel.fromJson(passenger.toJson())).toList();
    if (baggageDataList != null && baggageDataList.isNotEmpty) {
      List<BaggageData> tempBaggageList = <BaggageData>[];
      for (BaggageData baggage in baggageDataList) {
        if (baggage.weight != null && baggage.weight!.isNotEmpty && baggage.code != null && baggage.code!.isNotEmpty && baggage.code != 'NoBaggage') {
          tempBaggageList.add(baggage);
        }
      }

      for (PassengerDetailsModel passenger in passengerDetailsList) {
        passenger.baggageDataList = tempBaggageList.map((e) => BaggageData.fromJson(e.toJson())).toList();
      }
    }
    return passengerDetailsList;
  }

  // Calculate total seat price
  List calculateTotalSeatPrice() {
    int totalSeatCount = 0;
    double totalSeatPrice = 0.0;
    for (SsrFlightListModel element in seatFlightList) {
      List<PassengerDetailsModel>? passengerList = element.passengerDetailsList;
      for (PassengerDetailsModel passengerDetailsModel in passengerList!) {
        if (passengerDetailsModel.selectedSeatModel != null && passengerDetailsModel.selectedSeatModel!.isSeatSelected!.value == true) {
          double seatPrice = double.parse(passengerDetailsModel.selectedSeatModel!.price ?? '0');
          totalSeatPrice += seatPrice;
          totalSeatCount++;
        }
      }
    }
    return [totalSeatCount.toString(), totalSeatPrice.toString()];
  }

  // Calculate total meal price
  List calculateTotalMealPrice() {
    int totalMealCount = 0;
    double totalMealPrice = 0.0;
    for (SsrFlightListModel element in mealFlightList) {
      List<PassengerDetailsModel>? passengerList = element.passengerDetailsList;
      for (PassengerDetailsModel passengerDetailsModel in passengerList!) {
        if (passengerDetailsModel.selectedMealModel != null && passengerDetailsModel.selectedMealModel!.isMealSelected!.value == true) {
          double mealPrice = double.parse(passengerDetailsModel.selectedMealModel!.price ?? '0');
          totalMealPrice += mealPrice;
          totalMealCount++;
        }
      }
    }
    return [totalMealCount.toString(), totalMealPrice.toString()];
  }

  // Calculate total int meal price
  List calculateTotalIntMealPrice() {
    int totalMealCount = 0;
    double totalMealPrice = 0.0;
    for (SsrFlightListModel element in intMealFlightList) {
      List<PassengerDetailsModel>? passengerList = element.passengerDetailsList;
      for (PassengerDetailsModel passengerDetailsModel in passengerList!) {
        if (passengerDetailsModel.selectedIntMealModel != null && passengerDetailsModel.selectedIntMealModel!.isMealSelected!.value == true) {
          totalMealCount++;
        }
      }
    }
    return [totalMealCount.toString(), totalMealPrice.toString()];
  }

  // Calculate total baggage price
  List calculateTotalBaggagePrice() {
    int totalBaggageCount = 0;
    double totalBaggagePrice = 0.0;
    for (SsrFlightListModel element in baggageFlightList) {
      List<PassengerDetailsModel>? passengerList = element.passengerDetailsList;
      for (PassengerDetailsModel passengerDetailsModel in passengerList!) {
        if (passengerDetailsModel.selectedBaggageModel != null && passengerDetailsModel.selectedBaggageModel!.isBaggageSelected!.value == true) {
          double baggagePrice = double.parse(passengerDetailsModel.selectedBaggageModel!.price ?? '0');
          totalBaggagePrice += baggagePrice;
          totalBaggageCount++;
        }
      }
    }
    return [totalBaggageCount.toString(), totalBaggagePrice.toString()];
  }

  // Format seat price
  String formatPrice({required String price}) {
    if (double.parse(price) >= 1000) {
      double formattedPrice = double.parse(price) / 1000;
      return '${formattedPrice.toStringAsFixed(1)}k';
    } else {
      return price.toString();
    }
  }

  // Reset flights ssr details variables
  void resetFlightSsrDetailsVariables() {
    selectedExtraServices.value = 'Seat';
    seatFlightList.clear();
    mealFlightList.clear();
    intMealFlightList.clear();
    baggageFlightList.clear();
    selectedFlightIndexForSeatServices.value = 0;
    selectedFlightIndexForMealServices.value = 0;
    selectedFlightIndexForBaggageServices.value = 0;
    selectedPassengerIndexForExtraServices.value = 0;
    totalSeatCount.value = '0';
    totalSeatPrice.value = '0';
    totalMealCount.value = '0';
    totalMealPrice.value = '0';
    totalBaggageCount.value = '0';
    totalBaggagePrice.value = '0';
  }

  /////////////////////
  /// Add Passenger ///
  /////////////////////

  RxString selectedNameTitleRadio = 'Mr'.obs;
  RxString selectedGenderRadio = 'Male'.obs;
  RxBool isGstCheckBoxSelected = false.obs;
  RxBool isSeatMealBaggageCheckbox = false.obs;
  TextEditingController passengerFirstNameController = TextEditingController();
  TextEditingController passengerLastNameController = TextEditingController();
  TextEditingController passengerDobController = TextEditingController();
  TextEditingController passengerAddressController = TextEditingController();
  TextEditingController passengerPinCodeController = TextEditingController();
  TextEditingController passengerPasswordNoController = TextEditingController();
  TextEditingController passengerPasswordExpiryDateController = TextEditingController();
  TextEditingController gstNumberTextController = TextEditingController();
  TextEditingController gstEmailTextController = TextEditingController();
  TextEditingController companyNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController mobileTextController = TextEditingController();
  TextEditingController cityTextController = TextEditingController();
  TextEditingController countryTextController = TextEditingController();
  RxString selectedCountryCode = ''.obs;
  RxString selectedCellCountryCode = ''.obs;
  RxString selectednationality = ''.obs;
  RxList<PassengerDetailsModel> passengerListForExtraServices = <PassengerDetailsModel>[].obs;

  bool areAllPassengersFilled() {
    return passengerListForExtraServices.every((passenger) => passenger.isFilled);
  }

  // Get country list
  RxList<CountryModel> masterCountryList = <CountryModel>[].obs;
  Future<bool> getCountryList({bool isLoaderShow = true}) async {
    try {
      List<CountryModel> countryList = await flightRepository.getCountryListApiCall(isLoaderShow: isLoaderShow);
      if (countryList.isNotEmpty) {
        masterCountryList.clear();
        for (CountryModel element in countryList) {
          if (element.status == 1) {
            masterCountryList.add(element);
          }
        }
        masterCountryList.sort((a, b) => a.name!.compareTo(b.name!));
        return true;
      } else {
        masterCountryList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  resetVariablesAddPassengers() {
    gstNumberTextController.clear();
    gstEmailTextController.clear();
    companyNameTextController.clear();
    selectedNameTitleRadio = 'Mr.'.obs;
    isGstCheckBoxSelected = false.obs;
    isSeatMealBaggageCheckbox = false.obs;
    // passengersNameList.clear();
  }

  //////////////////////////
  /// Review Trip Details///
  //////////////////////////

  RxString sourceTime = '03:55 PM'.obs;
  RxString destinationTime = '06:20 PM'.obs;

  RxString leftTimeForFlightBooking = '10m:50s'.obs;

  //////////////////////
  /// Flight Booking ///
  //////////////////////

  RxBool isShowTpinField = false.obs;
  RxBool isShowTpin = true.obs;
  TextEditingController tPinTxtController = TextEditingController();
  RxInt flightBookingStatus = (-1).obs;
  List<Map<String, dynamic>> finalOnewayPassengerList = [];
  List<Map<String, dynamic>> finalReturnPassengerList = [];

  // Passenger obj for oneward
  void onwardBookingPassenger() {
    finalOnewayPassengerList.clear();
    List<SsrFlightListModel> onwardSeatFlightList = seatFlightList.where((element) => element.tripType == 'ONWARD').toList();
    List<SsrFlightListModel> onwardMealFlightList = mealFlightList.where((element) => element.tripType == 'ONWARD').toList();
    List<SsrFlightListModel> onwardIntMealFlightList = intMealFlightList.where((element) => element.tripType == 'ONWARD').toList();
    List<SsrFlightListModel> onwardBaggageFlightList = baggageFlightList.where((element) => element.tripType == 'ONWARD').toList();
    createPassengerObjForAllTripType(
      seatFlightList: onwardSeatFlightList,
      mealFlightList: onwardMealFlightList,
      intMealFlightList: onwardIntMealFlightList,
      baggageFlightList: onwardBaggageFlightList,
      isDomReturn: false,
    );
  }

  // Passenger obj for dom return
  void returnBookingPassenger() {
    finalReturnPassengerList.clear();
    List<SsrFlightListModel> returnSeatFlightList = seatFlightList.where((element) => element.tripType == 'RETURN').toList();
    List<SsrFlightListModel> returnMealFlightList = mealFlightList.where((element) => element.tripType == 'RETURN').toList();
    List<SsrFlightListModel> returnIntMealFlightList = intMealFlightList.where((element) => element.tripType == 'RETURN').toList();
    List<SsrFlightListModel> returnBaggageFlightList = baggageFlightList.where((element) => element.tripType == 'RETURN').toList();
    createPassengerObjForAllTripType(
      seatFlightList: returnSeatFlightList,
      mealFlightList: returnMealFlightList,
      intMealFlightList: returnIntMealFlightList,
      baggageFlightList: returnBaggageFlightList,
      isDomReturn: true,
    );
  }

  createPassengerObjForAllTripType(
      {required List<SsrFlightListModel> seatFlightList, required List<SsrFlightListModel> mealFlightList, required List<SsrFlightListModel> intMealFlightList, required List<SsrFlightListModel> baggageFlightList, required bool isDomReturn}) {
    for (int i = 0; i < passengerListForExtraServices.length; i++) {
      PassengerDetailsModel passengerDetailsModel = passengerListForExtraServices[i];
      List<SeatData> selectSeatList = <SeatData>[];
      List<MealData> selectMealList = <MealData>[];
      IntMealData selectIntMealObj = IntMealData();
      List<BaggageData> selectBaggageList = <BaggageData>[];

      // Create seat list per passenger
      if (seatFlightList.isNotEmpty) {
        for (SsrFlightListModel seatData in seatFlightList) {
          List<PassengerDetailsModel> selectedPassenger = seatData.passengerDetailsList!.where((element) => element.passengerId == passengerDetailsModel.passengerId).toList();
          for (PassengerDetailsModel passenger in selectedPassenger) {
            if (passenger.selectedSeatModel != null && passenger.passengerId == passengerDetailsModel.passengerId) {
              SeatData seat = SeatData(
                airlineCode: passenger.selectedSeatModel!.airlineCode,
                flightNumber: passenger.selectedSeatModel!.flightNumber,
                origin: passenger.selectedSeatModel!.origin,
                destination: passenger.selectedSeatModel!.destination,
                seatId: passenger.selectedSeatModel!.seatId,
                seatNo: passenger.selectedSeatModel!.seatNo,
                seatTypes: passenger.selectedSeatModel!.seatTypes,
                price: passenger.selectedSeatModel!.price,
                craftType: passenger.selectedSeatModel!.craftType,
                code: passenger.selectedSeatModel!.code,
                description: passenger.selectedSeatModel!.description,
                airlineDescription: passenger.selectedSeatModel!.airlineDescription,
                availablityType: passenger.selectedSeatModel!.availablityType,
                rowNo: passenger.selectedSeatModel!.rowNo,
                seatType: passenger.selectedSeatModel!.seatTypes,
                seatWayType: passenger.selectedSeatModel!.seatWayType,
                compartment: passenger.selectedSeatModel!.rowNo,
                deck: passenger.selectedSeatModel!.deck,
              );
              selectSeatList.add(seat);
            }
          }
        }
      }

      // Create meal list per passenger
      if (mealFlightList.isNotEmpty) {
        for (SsrFlightListModel element in mealFlightList) {
          List<PassengerDetailsModel> selectedPassenger = element.passengerDetailsList!.where((element) => element.passengerId == passengerDetailsModel.passengerId).toList();
          for (PassengerDetailsModel passenger in selectedPassenger) {
            if (passenger.selectedMealModel != null && passenger.passengerId == passengerDetailsModel.passengerId) {
              MealData meal = MealData(
                airlineCode: passenger.selectedMealModel!.airlineCode,
                flightNumber: passenger.selectedMealModel!.flightNumber,
                origin: passenger.selectedMealModel!.origin,
                destination: passenger.selectedMealModel!.destination,
                mealId: passenger.selectedMealModel!.mealId,
                price: passenger.selectedMealModel!.price!,
                code: passenger.selectedMealModel!.code,
                description: passenger.selectedMealModel!.description,
                airlineDescription: passenger.selectedMealModel!.airlineDescription,
                quantity: passenger.selectedMealModel!.quantity,
                mealTypes: passenger.selectedMealModel!.mealTypes,
                wayType: passenger.selectedMealModel!.wayType,
              );
              selectMealList.add(meal);
            }
          }
        }
      }
      // Create int meal list per passenger
      else if (intMealFlightList.isNotEmpty) {
        List<PassengerDetailsModel> selectedPassenger = intMealFlightList[0].passengerDetailsList!.where((element) => element.passengerId == passengerDetailsModel.passengerId).toList();
        for (PassengerDetailsModel passenger in selectedPassenger) {
          if (passenger.selectedIntMealModel != null && passenger.passengerId == passengerDetailsModel.passengerId) {
            selectIntMealObj = IntMealData(
              code: passenger.selectedIntMealModel!.code,
              description: passenger.selectedIntMealModel!.description,
            );
          }
        }
      }

      // Create baggage list per passenger
      if (baggageFlightList.isNotEmpty) {
        for (SsrFlightListModel element in baggageFlightList) {
          List<PassengerDetailsModel> selectedPassenger = element.passengerDetailsList!.where((element) => element.passengerId == passengerDetailsModel.passengerId).toList();
          for (PassengerDetailsModel passenger in selectedPassenger) {
            if (passenger.selectedBaggageModel != null && passenger.passengerId == passengerDetailsModel.passengerId) {
              BaggageData baggage = BaggageData(
                airlineCode: passenger.selectedBaggageModel!.airlineCode,
                flightNumber: passenger.selectedBaggageModel!.flightNumber,
                origin: passenger.selectedBaggageModel!.origin,
                destination: passenger.selectedBaggageModel!.destination,
                baggageId: passenger.selectedBaggageModel!.baggageId,
                price: passenger.selectedBaggageModel!.price,
                code: passenger.selectedBaggageModel!.code,
                description: passenger.selectedBaggageModel!.description,
                weight: passenger.selectedBaggageModel!.weight,
              );
              selectBaggageList.add(baggage);
            }
          }
        }
      }

      var passengerMap = {
        'title': passengerDetailsModel.title,
        'firstName': passengerDetailsModel.firstName,
        'lastName': passengerDetailsModel.lastName,
        'paxType': passengerDetailsModel.type.contains('Adult')
            ? '1'
            : passengerDetailsModel.type.contains('Child')
                ? '2'
                : passengerDetailsModel.type.contains('Infant')
                    ? '3'
                    : '',
        'gender': passengerDetailsModel.gender.contains('Male')
            ? 1
            : passengerDetailsModel.gender.contains('Female')
                ? 2
                : 1,
        'dateOfBirth': DateFormat('yyyy-MM-dd').format(DateFormat(flightDateFormat).parse(passengerDetailsModel.dateOfBirth)),
        'passportNumber': passengerDetailsModel.passportNumber,
        'passportExpiry': passengerDetailsModel.passportExpiryDate!.isNotEmpty ? DateFormat('yyyy-MM-dd').format(DateFormat(flightDateFormat).parse(passengerDetailsModel.passportExpiryDate!)) : '',
        'nationality': selectednationality.value,
        'countryCode': selectedCountryCode.value,
        'countryName': countryTextController.text.trim(),
        'contactNo': mobileTextController.text.trim(),
        'email': emailTextController.text.trim(),
        'city': cityTextController.text.trim(),
        'pinCode': passengerPinCodeController.text.trim(),
        'addressLine1': passengerAddressController.text.trim(),
        'addressLine2': '',
        'ffAirlineCode': '',
        'ffNumber': '',
        'fareBook': {
          'currency': flightCurrency,
          'baseFare': 0,
          'tax': 0,
          'taxBreakup': '0',
          'yqTax': 0,
          'additionalTxnFeeOfrd': 0,
          'additionalTxnFeePub': 0,
          'pgCharge': 0,
          'otherCharges': 0,
          'chargeBU': '0',
          'discount': 0,
          'publishedFare': 0,
          'commissionEarned': 0,
          'plbEarned': 0,
          'incentiveEarned': 0,
          'offeredFare': 0,
          'tdsOnCommission': 0,
          'tdsOnPLB': 0,
          'tdsOnIncentive': 0,
          'serviceFee': 0,
          'totalBaggageCharges': 0,
          'totalMealCharges': 0,
          'totalSeatCharges': 0,
          'totalSpecialServiceCharges': 0
        },
        'seatDetails': selectSeatList.isNotEmpty ? selectSeatList : null,
        'mealsDetails': selectMealList.isNotEmpty ? selectMealList : null,
        'intMealsDetails': selectIntMealObj.code != null && selectIntMealObj.code!.isNotEmpty && selectIntMealObj.description != null && selectIntMealObj.description!.isNotEmpty ? selectIntMealObj : null,
        'baggageDetails': selectBaggageList.isNotEmpty ? selectBaggageList : null
      };
      if (isDomReturn == true) {
        finalReturnPassengerList.add(passengerMap);
      } else {
        finalOnewayPassengerList.add(passengerMap);
      }
    }
  }

  // Flight booking
  Rx<FlightBookModel> domFlightBookModel = FlightBookModel().obs;
  Future<int> flightBookApi({bool isLoaderShow = true}) async {
    try {
      FlightBookModel flightBookModel = await flightRepository.flightBookApiCall(
        params: {
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'email': emailTextController.text.trim(),
          'mobileNo': mobileTextController.text.trim(),
          'source': fromLocationCode.value,
          'destination': toLocationCode.value,
          'sourceAirportCode': selectedFlightData.details![0][0].sourceAirportCode,
          'sourceAirportName': selectedFlightData.details![0][0].sourceAirportName,
          'sourceCountryCode': selectedFlightData.details![0][0].sourceCountryCode,
          'destinationAirportCode': selectedFlightData.details![0][0].destinationAirportCode,
          'destinationAirportName': selectedFlightData.details![0][0].destinationAirportName,
          'destinationCountryCode': selectedFlightData.details![0][0].destinationCountryCode,
          'departureDate': DateFormat('yyyy-MM-dd').format(DateFormat(flightDateFormat).parse(departureDate.value)),
          'returnDate': '',
          'airlineLogo': selectedFlightData.details![0][0].airlineLogo,
          'airline': selectedFlightData.details![0][0].airlineName,
          'cabinClass': selectedTravelClassCode.value,
          'journeyType': selectedTripType.value,
          'amount': selectedFlightData.offeredFare ?? '0', // pass offered fare here
          'baseFare': flightFareQuoteData.value.baseFare ?? '0',
          'tax': flightFareQuoteData.value.tax ?? '0',
          'yqTax': '0',
          'otherCharges': '0',
          'discount': '0',
          'publishedFare': '0',
          'offeredFare': '0',
          'tdsOnCommission': '0',
          'tdsOnPLB': '0',
          'tdsOnIncentive': '0',
          'flightNumber': flightFareQuoteData.value.flightNumber ?? '',
          'fareType': selectedSpecialFareCode.value,
          'fareOptions': '',
          'serviceCharges': '0',
          'duration': selectedFlightData.details![0][0].totalDuration ?? '',
          'travelGuideLines': '',
          'cellCountryCode': selectedCellCountryCode.value,
          'nationality': selectednationality.value,
          'sequenceNumber': 0,
          'token': flightFareQuoteData.value.token,
          'resultIndex': flightFareQuoteData.value.resultIndex,
          'isLcc': selectedFlightData.isLCC,
          'currency': flightCurrency,
          'isPriceChangeAccepted': true,
          'gstCompanyAddress': '',
          'gstCompanyContactNumber': '',
          'gstCompanyName': companyNameTextController.text.trim(),
          'gstNumber': gstNumberTextController.text.trim(),
          'gstCompanyEmail': gstEmailTextController.text.trim(),
          'passengers': finalOnewayPassengerList,
          'tpin': tPinTxtController.text.trim(),
          'channel': channelID,
          'latitude': latitude,
          'longitude': longitude,
          'ipAddress': ipAddress,
        },
        isLoaderShow: isLoaderShow,
      );
      if (flightBookModel.statusCode == 1) {
        domFlightBookModel.value = flightBookModel;
        return flightBookModel.statusCode!;
      } else {
        domFlightBookModel.value = flightBookModel;
        return 0;
      }
    } catch (e) {
      dismissProgressIndicator();
      return 0;
    }
  }

  Rx<ReturnFlightBookModel> domReturnFlightBookModel = ReturnFlightBookModel().obs;
  Future<int> domReturnFlightBook({bool isLoaderShow = true}) async {
    try {
      ReturnFlightBookModel domReturnFlightBookModel = await flightRepository.domReturnFlightBookApiCall(
        params: {
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'email': emailTextController.text.trim(),
          'mobileNo': mobileTextController.text.trim(),
          'journeyType': selectedTripType.value,
          'cellCountryCode': selectedCellCountryCode.value,
          'isPriceChangeAccepted': false,
          'oneWayDetails': {
            'isLcc': selectedOnwardFlightData.isLCC,
            'source': fromLocationCode.value,
            'destination': toLocationCode.value,
            'sourceAirportCode': selectedOnwardFlightData.details![0][0].sourceAirportCode,
            'sourceAirportName': selectedOnwardFlightData.details![0][0].sourceAirportName,
            'sourceCountryCode': selectedOnwardFlightData.details![0][0].sourceCountryCode,
            'destinationAirportCode': selectedOnwardFlightData.details![0][0].destinationAirportCode,
            'destinationAirportName': selectedOnwardFlightData.details![0][0].destinationAirportName,
            'destinationCountryCode': selectedOnwardFlightData.details![0][0].destinationCountryCode,
            'departureDate': DateFormat('yyyy-MM-dd').format(DateFormat(flightDateFormat).parse(departureDate.value)),
            'returnDate': DateFormat('yyyy-MM-dd').format(DateFormat(flightDateFormat).parse(returnDate.value)),
            'airlineLogo': selectedOnwardFlightData.details![0][0].airlineLogo,
            'airline': selectedOnwardFlightData.details![0][0].airlineName,
            'cabinClass': selectedTravelClassCode.value,
            'amount': selectedOnwardFlightData.offeredFare ?? '0',
            'baseFare': onwardFlightFareQuoteData.value.baseFare ?? '0',
            'tax': onwardFlightFareQuoteData.value.tax ?? '0',
            'flightNumber': selectedOnwardFlightData.details![0][0].flightDetails![0].flightNumber ?? '',
            'fareType': selectedSpecialFareCode.value,
            'fareOptions': '',
            'serviceCharges': '0',
            'duration': selectedOnwardFlightData.details![0][0].totalDuration ?? '',
            'travelGuideLines': '',
            'sequenceNumber': 0,
            'token': onwardFlightFareQuoteData.value.token ?? '',
            'resultIndex': onwardFlightFareQuoteData.value.resultIndex ?? '',
            'passengers': finalOnewayPassengerList,
          },
          'returnDetails': {
            'isLcc': selectedReturnFlightData.isLCC,
            'source': toLocationCode.value,
            'destination': fromLocationCode.value,
            'sourceAirportCode': selectedReturnFlightData.details![0][0].sourceAirportCode,
            'sourceAirportName': selectedReturnFlightData.details![0][0].sourceAirportName,
            'sourceCountryCode': selectedReturnFlightData.details![0][0].sourceCountryCode,
            'destinationAirportCode': selectedReturnFlightData.details![0][0].destinationAirportCode,
            'destinationAirportName': selectedReturnFlightData.details![0][0].destinationAirportName,
            'destinationCountryCode': selectedReturnFlightData.details![0][0].destinationCountryCode,
            'departureDate': DateFormat('yyyy-MM-dd').format(DateFormat(flightDateFormat).parse(returnDate.value)),
            'returnDate': '',
            'airlineLogo': selectedReturnFlightData.details![0][0].airlineLogo,
            'airline': selectedReturnFlightData.details![0][0].airlineName,
            'cabinClass': selectedTravelClassCode.value,
            'amount': selectedReturnFlightData.offeredFare ?? '0',
            'baseFare': returnFlightFareQuoteData.value.baseFare ?? '',
            'tax': returnFlightFareQuoteData.value.tax ?? '',
            'flightNumber': selectedReturnFlightData.details![0][0].flightDetails![0].flightNumber ?? '',
            'fareType': selectedSpecialFareCode.value,
            'fareOptions': '',
            'cellCountryCode': selectedCellCountryCode.value,
            'serviceCharges': '0',
            'duration': selectedReturnFlightData.details![0][0].totalDuration ?? '',
            'travelGuideLines': '',
            'sequenceNumber': 0,
            'token': returnFlightFareQuoteData.value.token ?? '',
            'resultIndex': returnFlightFareQuoteData.value.resultIndex ?? '',
            'passengers': finalReturnPassengerList,
          },
          'tpin': tPinTxtController.text.trim(),
          'channel': channelID,
          'latitude': latitude,
          'longitude': longitude,
          'ipAddress': ipAddress,
        },
        isLoaderShow: isLoaderShow,
      );
      if (domReturnFlightBookModel.statusCode == 1) {
        this.domReturnFlightBookModel.value = domReturnFlightBookModel;
        return domReturnFlightBookModel.statusCode!;
      } else {
        this.domReturnFlightBookModel.value = domReturnFlightBookModel;
        errorSnackBar(message: domReturnFlightBookModel.message ?? '');
        return 0;
      }
    } catch (e) {
      dismissProgressIndicator();
      return -1;
    }
  }

  //////////////////////
  /// Flight History ///
  //////////////////////

  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;
  TextEditingController remarkController = TextEditingController();

  /// Flight Boarding Pass ///
  RxString flightCode = 'FKVSD'.obs;
  RxString bookingId = '2522255522'.obs;
  Rx<DateTime> bookingDate = DateTime.now().obs;
  RxString gate = 'C2'.obs;
  RxString seat = 'A2'.obs;

  // Flight booking details
  Rx<FlightBookingDetailsModel> flightBookingDetailsModel = FlightBookingDetailsModel().obs;
  Future<void> getFlightBookingDetails({required String orderId, bool isLoaderShow = true}) async {
    try {
      FlightBookingDetailsModel flightBookingDetailsModel = await flightRepository.getFlightBookingDetailsApiCall(
        params: {
          'orderId': orderId,
          'ipAddress': ipAddress,
        },
        isLoaderShow: isLoaderShow,
      );
      if (flightBookingDetailsModel.statusCode == 1) {
        this.flightBookingDetailsModel.value = flightBookingDetailsModel;
      } else {
        errorSnackBar(message: flightBookingDetailsModel.message ?? '');
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Partial flight booking cancel
  Rx<PartialFlightBookingCancelModel> partialFlightBookingCancelModel = PartialFlightBookingCancelModel().obs;
  Future<bool> partialFlightBookingCancel({required String uniqueId, required List passengerIdList, bool isLoaderShow = true}) async {
    try {
      PartialFlightBookingCancelModel partialFlightBookingCancelModel = await flightRepository.partialFlightBookingCancelApiCall(
        params: {
          'sequenceNumber': '0',
          'remarks': remarkController.text.trim(),
          'passengerId': passengerIdList,
          'unqId': uniqueId,
          'channel': channelID,
        },
        isLoaderShow: isLoaderShow,
      );
      if (partialFlightBookingCancelModel.statusCode == 1) {
        this.partialFlightBookingCancelModel.value = partialFlightBookingCancelModel;
        successSnackBar(message: partialFlightBookingCancelModel.message ?? '');
        return true;
      } else {
        errorSnackBar(message: partialFlightBookingCancelModel.message ?? '');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Full flight booking cancel
  Rx<FullFlightBookingCancelModel> fullFlightBookingCancelModel = FullFlightBookingCancelModel().obs;
  Future<bool> fullFlightBookingCancel({required String uniqueId, bool isLoaderShow = true}) async {
    try {
      FullFlightBookingCancelModel fullFlightBookingCancelModel = await flightRepository.fullFlightBookingCancelApiCall(
        params: {
          'sequenceNumber': '0',
          'remarks': remarkController.text.trim(),
          'unqId': uniqueId,
          'channel': channelID,
        },
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

  // flight booking history
  RxList<FlightHistoryModelList> flightHistoryList = <FlightHistoryModelList>[].obs;
  Future<bool> getFlightBookingHistoryApi({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      FlightBookingHistoryModel flightBookingHistoryModel = await flightRepository.getFlightHistoryListApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (flightBookingHistoryModel.statusCode == 1) {
        if (flightBookingHistoryModel.pagination!.currentPage == 1) {
          flightHistoryList.clear();
        }
        for (FlightHistoryModelList element in flightBookingHistoryModel.data!) {
          flightHistoryList.add(element);
        }
        currentPage.value = flightBookingHistoryModel.pagination!.currentPage!;
        totalPages.value = flightBookingHistoryModel.pagination!.totalPages!;
        hasNext.value = flightBookingHistoryModel.pagination!.hasNext!;
        return true;
      } else if (flightBookingHistoryModel.statusCode == 0) {
        flightHistoryList.clear();
        return false;
      } else {
        flightHistoryList.clear();
        errorSnackBar(message: flightBookingHistoryModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  } // flight booking history

  RxList<FlightPassengersDetailData> flightPassengersList = <FlightPassengersDetailData>[].obs;
  RxInt flightPassengerCount = 0.obs;
  Future<bool> getFlightPassengersListApi({required flightId, bool isLoaderShow = true}) async {
    try {
      FlightBookingPassengersDetailModel passengerDetailsModel = await flightRepository.getFlightPassengerDetailsListApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        flightId: flightId,
        isLoaderShow: isLoaderShow,
      );
      if (passengerDetailsModel.statusCode == 1) {
        flightPassengerCount.value = passengerDetailsModel.pagination!.totalCount!;
        if (passengerDetailsModel.pagination!.currentPage == 1) {
          flightPassengersList.clear();
        }
        for (FlightPassengersDetailData element in passengerDetailsModel.passengersDataList!) {
          flightPassengersList.add(element);
        }
        currentPage.value = passengerDetailsModel.pagination!.currentPage!;
        totalPages.value = passengerDetailsModel.pagination!.totalPages!;
        hasNext.value = passengerDetailsModel.pagination!.hasNext!;
        return true;
      } else if (passengerDetailsModel.statusCode == 0) {
        flightPassengersList.clear();
        return false;
      } else {
        flightPassengersList.clear();
        errorSnackBar(message: passengerDetailsModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Format flight dates
  String formatReturnFlightDates({required DateTime departureDate, required DateTime returnDate}) {
    String returnDateString = DateFormat('dd MMM yy').format(returnDate);

    // Check if departure and return dates have the same month
    if (departureDate.month == returnDate.month) {
      return '${DateFormat('dd').format(departureDate)} - $returnDateString';
    } else {
      return '${DateFormat('dd MMM').format(departureDate)} - $returnDateString';
    }
  }

  // Format date time
  String formatDateTime({required String dateTimeFormat, required String dateTimeString}) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat(dateTimeFormat).format(dateTime);
  }

  // Calculate diffrence between arrival & departure dateTime
  String calculateDepartureArrivalDateTimeDiffrence({required String departureDateTime, required String arrivalDateTime}) {
    final DateTime tempDepartureDateTime = DateTime.parse(departureDateTime);
    final DateTime tempArrivalDateTime = DateTime.parse(arrivalDateTime);
    // Extract date parts from the dates
    DateTime departureDateOnly = DateTime(tempDepartureDateTime.year, tempDepartureDateTime.month, tempDepartureDateTime.day);
    DateTime arrivalDateOnly = DateTime(tempArrivalDateTime.year, tempArrivalDateTime.month, tempArrivalDateTime.day);
    // Calculate the difference between departure and arrival dates
    int dayDifference = arrivalDateOnly.difference(departureDateOnly).inDays;
    if (dayDifference > 0) {
      return '(+${dayDifference}d)';
    } else {
      return '';
    }
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

  // Format stops(Non-stop)
  String formatStops({required FlightDetails flightData, bool isShowLayoverStop = false}) {
    if (flightData.stops != null && flightData.stops!.isNotEmpty) {
      int stops = int.tryParse(flightData.stops ?? '0') ?? 0;

      if (stops == 0) {
        return 'Non-Stop';
      } else if (stops == 1) {
        if (isShowLayoverStop == true) {
          String stopWithLayoverStop = getAirportCodeOfLayoverCity(flightList: flightData.flightDetails!);
          return '1 Stop ($stopWithLayoverStop)';
        } else {
          return '1 Stop';
        }
      } else {
        if (isShowLayoverStop == true) {
          String stopWithLayoverStop = getAirportCodeOfLayoverCity(flightList: flightData.flightDetails!);
          return '$stops Stops ($stopWithLayoverStop)';
        } else {
          return '$stops Stops';
        }
      }
    } else {
      return 'Non-Stop';
    }
  }

  // Get airport code of layover city
  String getAirportCodeOfLayoverCity({required List<Flight> flightList}) {
    List layoverCodes = [];
    if (flightList.isNotEmpty) {
      for (int i = 1; i < flightList.length; i++) {
        layoverCodes.add(flightList[i].sourceAirportCode);
      }
    }
    return layoverCodes.join(', ');
  }

  // Get layover data
  String getlayoverData({required List<Flight> flightList}) {
    List layoverCityTime = [];
    for (int i = 1; i < flightList.length; i++) {
      layoverCityTime.add('${formatDuration(flightList[i].layOverTime ?? '0')} layover at ${flightList[i].sourceCity}');
    }
    return layoverCityTime.join(', ');
  }

  // Format flight price
  String formatFlightPrice(String priceString) {
    double doubleValue = double.parse(priceString);
    return NumberFormat('##,##,###').format(doubleValue);
  }

  // Convert string to currency symbol
  String convertCurrencySymbol(String currencyName) {
    NumberFormat formatCurrency = NumberFormat.simpleCurrency(locale: 'en_IN', name: currencyName);
    return formatCurrency.currencySymbol;
  }
}

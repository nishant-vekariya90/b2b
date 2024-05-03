import 'package:flutter/cupertino.dart';

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
import '../../utils/string_constants.dart';

class BusRepository {
  final APIManager apiManager;

  BusRepository(this.apiManager);

  // Get cities list api call
  Future<BusFromCitiesModel> getCitiesListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/bus/cities',
      isLoaderShow: isLoaderShow,
    );
    var response = BusFromCitiesModel.fromJson(jsonData);
    return response;
  }

  // Get available list api call
  Future<BusAvailableTripsModel> getAvailableTripsListApiCall({required String sourceId, required String destinationId, required String journeyDate, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/bus/search?SourceId=$sourceId&DestinationId=$destinationId&DateOfJourny=$journeyDate',
      isLoaderShow: isLoaderShow,
    );
    var response = BusAvailableTripsModel.fromJson(jsonData);
    return response;
  }

  // Get Trip Details api call
  Future<BusTripDetailsModel> getTripDetailsApiCall({required String tripId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      //1000001848732524688
      url: '${baseUrl}transaction/api/transaction-module/bus/trip-details?TripId=$tripId',
      isLoaderShow: isLoaderShow,
    );
    var response = BusTripDetailsModel.fromJson(jsonData);
    return response;
  }

  // Get Boarding & Dropping points details api call
  Future<BusBpDpDetailsModel> getBpDpDetailsApiCall({required String tripId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}transaction/api/transaction-module/bus/bpdp-details?TripId=$tripId',
      isLoaderShow: isLoaderShow,
    );
    var response = BusBpDpDetailsModel.fromJson(jsonData);
    return response;
  }

  // Bus book api call
  Future<BusBookModel> busBookApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    debugPrint('busBookApiParams==> $params');
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/bus/booking',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = BusBookModel.fromJson(jsonData);
    return response;
  }

  // Partial bus booking cancel api call
  Future<PartialBusBookingCancelModel> partialBusBookingCancelApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/bus/partial-cancellation',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = PartialBusBookingCancelModel.fromJson(jsonData);
    return response;
  }

  // Full bus booking cancel api call
  Future<FullBusBookingCancelModel> fullBusBookingCancelApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/bus/cancellation',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FullBusBookingCancelModel.fromJson(jsonData);
    return response;
  }

  // passengers detail api call
  Future<BusBookingPassengersDetailModel> getBusPassengerDetailsListApiCall({required String fromDate, required String toDate, required int busTxnId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/buspassengers?FromDate=$fromDate&ToDate=$toDate&BusTxnId=$busTxnId',
      isLoaderShow: isLoaderShow,
    );
    var response = BusBookingPassengersDetailModel.fromJson(jsonData);
    return response;
  }

  // bus booking report api call
  Future<BusBookingReportModel> getBusBookingReportApiCall({String? username, String? categoryId, String? serviceId, required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/transactionbusbooking/userwise?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = BusBookingReportModel.fromJson(jsonData);
    return response;
  }
}

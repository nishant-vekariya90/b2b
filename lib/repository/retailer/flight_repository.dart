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
import '../../model/flight/flight_search_model.dart';
import '../../model/flight/flight_ssr_model.dart';
import '../../model/flight/full_flight_booking_cancel_model.dart';
import '../../model/flight/master_search_flight_common_model.dart';
import '../../model/flight/partial_flight_booking_cancel_model.dart';
import '../../model/flight/passengers_detail_model.dart';
import '../../utils/string_constants.dart';

class FlightRepository {
  final APIManager apiManager;
  FlightRepository(this.apiManager);

  // Get trip type list api call
  Future<List<MasterSearchFlightCommonModel>> getTripTypeListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/flight-triptypes',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<MasterSearchFlightCommonModel> object = response.map((e) => MasterSearchFlightCommonModel.fromJson(e)).toList();
    return object;
  }

  // Get airport list api call
  Future<AirportModel> getAirportListApiCall({String? searchText, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/flight-airport-lists?Field=$searchText&PageNumber=$pageNumber&PageSize=30',
      isLoaderShow: isLoaderShow,
    );

    var response = AirportModel.fromJson(jsonData);
    return response;
  }

  // Get traveller type list api call
  Future<List<MasterSearchFlightCommonModel>> getTravellerTypeListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/flight-travellertypes',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<MasterSearchFlightCommonModel> object = response.map((e) => MasterSearchFlightCommonModel.fromJson(e)).toList();
    return object;
  }

  // Get travel class list api call
  Future<List<MasterSearchFlightCommonModel>> getTravelClassListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/flight-travelclass',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<MasterSearchFlightCommonModel> object = response.map((e) => MasterSearchFlightCommonModel.fromJson(e)).toList();
    return object;
  }

  // Get fare type list api call
  Future<List<MasterSearchFlightCommonModel>> getFareTypeApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/flightfaretype',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<MasterSearchFlightCommonModel> object = response.map((e) => MasterSearchFlightCommonModel.fromJson(e)).toList();
    return object;
  }

  // Get number of stops api call
  Future<List<MasterSearchFlightCommonModel>> getNumberOfStopsApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/flight-numberofstops',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<MasterSearchFlightCommonModel> object = response.map((e) => MasterSearchFlightCommonModel.fromJson(e)).toList();
    return object;
  }

  // Get airline list api call
  Future<List<AirlineModel>> getAirlineListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/flightairlines',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<AirlineModel> object = response.map((e) => AirlineModel.fromJson(e)).toList();
    return object;
  }

  //Get cities list
  Future<List<CountryModel>> getCountryListApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/countries',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<CountryModel> objects = response.map((jsonMap) => CountryModel.fromJson(jsonMap)).toList();
    return objects;
  }

  // Get new flight serach list api call
  Future<FlightSearchModel> getFlightSearchApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/flight/searchv1',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FlightSearchModel.fromJson(jsonData);
    return response;
  }

  // Get flight fare rule api call
  Future<FlightFareRuleModel> getFlightFareRuleApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/flight/fare-rule',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FlightFareRuleModel.fromJson(jsonData);
    return response;
  }

  // Get flight fare price  api call
  Future<FarePriceModel> getFlightFareApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/flight/calender-fare',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FarePriceModel.fromJson(jsonData);
    return response;
  }

  // Get flight fare quote api call
  Future<FlightFareQuoteModel> getFlightFareQuoteApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/flight/fare-quote',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FlightFareQuoteModel.fromJson(jsonData);
    return response;
  }

  // Get flight ssr api call
  Future<FlightSsrModel> getFlightSsrApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/flight/ssr',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FlightSsrModel.fromJson(jsonData);
    return response;
  }

  // Oneway flight book api call
  Future<FlightBookModel> flightBookApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/flight/booking',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FlightBookModel.fromJson(jsonData);
    return response;
  }

  // Dom return flight book api call
  Future<ReturnFlightBookModel> domReturnFlightBookApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/flight/dom-return-booking',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = ReturnFlightBookModel.fromJson(jsonData);
    return response;
  }

  // Get flight booking details api call
  Future<FlightBookingDetailsModel> getFlightBookingDetailsApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/flight/bookingdetails',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FlightBookingDetailsModel.fromJson(jsonData);
    return response;
  }

  // Partial flight booking cancel api call
  Future<PartialFlightBookingCancelModel> partialFlightBookingCancelApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/flight/partial-cancellation',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = PartialFlightBookingCancelModel.fromJson(jsonData);
    return response;
  }

  // Full flight booking cancel api call
  Future<FullFlightBookingCancelModel> fullFlightBookingCancelApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/flight/full-cancellation',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = FullFlightBookingCancelModel.fromJson(jsonData);
    return response;
  }

  // flight booking history api call
  Future<FlightBookingHistoryModel> getFlightHistoryListApiCall(
      {String? username, String? categoryId, String? serviceId, required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/flighttransaction?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = FlightBookingHistoryModel.fromJson(jsonData);
    return response;
  }

  // passengers detail api call
  Future<FlightBookingPassengersDetailModel> getFlightPassengerDetailsListApiCall({required String fromDate, required String toDate, required int flightId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/flightpassengers?FromDate=$fromDate&ToDate=$toDate&FlightId=$flightId',
      isLoaderShow: isLoaderShow,
    );
    var response = FlightBookingPassengersDetailModel.fromJson(jsonData);
    return response;
  }
}

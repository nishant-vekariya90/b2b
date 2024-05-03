


import '../api/api_manager.dart';
import '../model/AxisSipExportModel.dart';
import '../model/auth/user_type_model.dart';
import '../model/credit_debit/user_list_model.dart';
import '../model/product/order_report_model.dart';
import '../model/product/order_update_status_model.dart';
import '../model/report/aeps_wallet_passbook_model.dart';
import '../model/report/axis_sip_report_model.dart';
import '../model/report/bank_sathi_lead_report_model.dart';
import '../model/report/bank_withdrawal_report_model.dart';
import '../model/report/bussiness_performance_model.dart';
import '../model/report/category_model.dart';
import '../model/report/commission_details_export_model.dart';
import '../model/report/commission_details_model.dart';
import '../model/report/notification_report_model.dart';
import '../model/report/payment_load_report_model.dart';
import '../model/report/search_transaction_report_model.dart';
import '../model/report/service_model.dart';
import '../model/report/settled_commission_model.dart';
import '../model/report/statement_report_model.dart';
import '../model/report/transaction_report_model.dart';
import '../model/report/transaction_slab_report_model.dart';
import '../model/report/unsettled_commission_model.dart';
import '../model/report/view_ticket_model.dart';
import '../model/success_model.dart';
import '../utils/string_constants.dart';

class ReportRepository {
  final APIManager apiManager;
  ReportRepository(this.apiManager);

  // Get user type api call
  Future<List<UserTypeModel>> userTypeApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/user-module/usertypes/${getStoredUserBasicDetails().userTypeID}',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<UserTypeModel> objects = response.map((e) => UserTypeModel.fromJson(e)).toList();
    return objects;
  }

  // Get user list via user type api call
  Future<UserListModel> getUserListVaiUserTypeApiCall({String? searchText, String? userTypeId, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: searchText != null && searchText.isNotEmpty
          ? '${baseUrl}authentication/api/authentication-module/Account/dis-users?SearchUserName=$searchText&UserTypeId=$userTypeId&PageNumber=$pageNumber&PageSize=20'
          : '${baseUrl}authentication/api/authentication-module/Account/dis-users?UserTypeId=$userTypeId&PageNumber=$pageNumber&PageSize=20',
      isLoaderShow: isLoaderShow,
    );
    var response = UserListModel.fromJson(jsonData);
    return response;
  }

  // Search user list via user type api call
  Future<UserListModel> searchUserListVaiUserTypeApiCall({required String searchText, required String userTypeId, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}authentication/api/authentication-module/Account/child-user-of-parent?SearchUserName=$searchText&UserTypeId=$userTypeId&PageNumber=$pageNumber&PageSize=20',
      isLoaderShow: isLoaderShow,
    );
    var response = UserListModel.fromJson(jsonData);
    return response;
  }

  // Get child user list via parent api call
  Future<UserListModel> getChildUserListVaiParentApiCall({String? searchText, String? parentId, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: searchText != null && searchText.isNotEmpty
          ? '${baseUrl}authentication/api/authentication-module/Account/child-user-of-parent-from-userid?SearchUserName=$searchText&Referenceid=$parentId&PageNumber=$pageNumber&PageSize=20'
          : '${baseUrl}authentication/api/authentication-module/Account/child-user-of-parent-from-userid?Referenceid=$parentId&PageNumber=$pageNumber&PageSize=20',
      isLoaderShow: isLoaderShow,
    );
    var response = UserListModel.fromJson(jsonData);
    return response;
  }

  //////////////////////////
  /// Transaction Report ///
  //////////////////////////

  // Get category List
  Future<List<CategoryModel>> getCategoryApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/service-configurations/category',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<CategoryModel> objects = response.map((e) => CategoryModel.fromJson(e)).toList();
    return objects;
  }

  // Get service List
  Future<List<ServiceModel>> getServiceApiCall({required String categoryId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/service-configurations/service?CategoryID=$categoryId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<ServiceModel> objects = response.map((e) => ServiceModel.fromJson(e)).toList();
    return objects;
  }

  // Get transaction report api call
  Future<TransactionReportModel> getTransactionReportListApiCall(
      {String? username, String? categoryId, String? serviceId, required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url:
          '${baseUrl}reporting/api/report-module/transactiondata/user-wise-child-transaction?SearchUserName=$username&CategoryId=$categoryId&ServiceId=$serviceId&FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=20',
      isLoaderShow: isLoaderShow,
    );
    var response = TransactionReportModel.fromJson(jsonData);
    return response;
  }

  ////////////////////////
  /// Statement Report ///
  ////////////////////////

  // Get statement report api call
  Future<StatementReportModel> getStatementReportListApiCall({String? userName, required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: userName != null && userName.isNotEmpty
          ? '${baseUrl}reporting/api/report-module/ledgerdatawallet1/parent-wise?SearchUserName=$userName&FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10'
          : '${baseUrl}reporting/api/report-module/ledgerdatawallet1/user-wise?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = StatementReportModel.fromJson(jsonData);
    return response;
  }

  // Get bak withdrawal report api call
  Future<BankWithdrawalReportModel> getBankWithdrawalListApiCall({required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/settlementrequests/user-wise?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = BankWithdrawalReportModel.fromJson(jsonData);
    return response;
  }

  // Get payment load report api call
  Future<PaymentLoadReportModel> getPaymentLoadReportApi({required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/transactiondata/Payment-Load-Async?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = PaymentLoadReportModel.fromJson(jsonData);
    return response;
  }

  // Get raised complaint api
  Future<RaisedComplaintReportModel> getRaisedComplaintReportApi({required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/tableticket/user-wise-ticket?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = RaisedComplaintReportModel.fromJson(jsonData);
    return response;
  }

  // Get transaction slab list
  Future<List<TransactionSlabReportModel>> getTransactionSlabReportApi({required String operatorId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/transactiondata/split-transaction/$operatorId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<TransactionSlabReportModel> object = response.map((e) => TransactionSlabReportModel.fromJson(e)).toList();
    return object;
  }

  // Business performance
  Future<BusinessPerformanceModel> businessPerformanceReportApiCall({
    bool isLoaderShow = true,
    required String fromDate,
    required String toDate,
  }) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/distributorreportings/distributor-business-performance?FromDate=$fromDate&ToDate=$toDate',
      isLoaderShow: isLoaderShow,
    );
    var response = BusinessPerformanceModel.fromJson(jsonData);
    return response;
  }

  // Get aeps wallet passbook api call
  Future<AepsWalletPassbookModel> getAepsWalletPassbookApiCall({String? userName, required String fromDate, required String toDate, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: userName != null && userName.isNotEmpty
          ? '${baseUrl}reporting/api/report-module/ledgerdatawallet2/parent-wise?SearchUserName=$userName&FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10'
          : '${baseUrl}reporting/api/report-module/ledgerdatawallet2/user-wise?FromDate=$fromDate&ToDate=$toDate&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = AepsWalletPassbookModel.fromJson(jsonData);
    return response;
  }

  ////////////////////////
  /// Order Report ///
  ////////////////////////

  // Get order report api call
  Future<OrderReportModel> getOrderReportApiCall({required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/productordetitems/user-wise?IsVisible=true&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = OrderReportModel.fromJson(jsonData);
    return response;
  }

  // Get order report api call
  Future<OrderUpdateStatusModel> updateOrderStatusApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.putAPICall(
      url: '${baseUrl}transaction/api/transaction-module/Product/update-order-status',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = OrderUpdateStatusModel.fromJson(jsonData);
    return response;
  }

  ////////////////////////
  /// Bank Sathi Report ///
  ////////////////////////

  // Get lead report api call
  Future<BankSathiLeadReportModel> getLeadReportApiCall({required String fromDate, required String toDate,required String serviceCode,  required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/transactionLead/transaction-lead-userwise-report?fromDate=$fromDate&toDate=$toDate&ServiceCode=$serviceCode&pageNumber=$pageNumber&pageSize=10&UserDetails=',
      isLoaderShow: isLoaderShow,
    );
    var response = BankSathiLeadReportModel.fromJson(jsonData);
    return response;
  }

  // Get notification report api call
  Future<NotificationReportModel> getNotificationReportApiCall({required String fromDate, required String toDate,  required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/logsnotification/userwise-list?PageNumber=$pageNumber&PageSize=6',
      isLoaderShow: isLoaderShow,
    );
    var response = NotificationReportModel.fromJson(jsonData);
    return response;
  }

// read notification api call
  Future<SuccessModel> readNotificationApiCall({bool isLoaderShow = true, required var params, required String uniqueId}) async {
    var jsonData = await apiManager.putAPICall(
      url: '${baseUrl}reporting/api/report-module/logsnotification/$uniqueId',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = SuccessModel.fromJson(jsonData);
    return response;
  }



  ////////////////////////
  /// Commission Report ///
  ////////////////////////

  // Get settlement commission report
  Future<SettledCommissionModel> getSettlementCommissionReportApi({required String year, required String month, required String pageNumber,bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/transactiondata/dist-setteled-comm?Month=$month&Year=$year&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = SettledCommissionModel.fromJson(jsonData);
    return response;
  }

  // Get unSettlement commission report
  Future<UnSettledCommissionModel> getUnSettlementCommissionReportApi({required String year, required String month, required String pageNumber,bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/transactiondata/dist-unsetteled-comm?Month=$month&Year=$year&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = UnSettledCommissionModel.fromJson(jsonData);
    return response;
  }


  // Get commission details report
  Future<CommissionDetailsModal> getCommissionDetailsReportApi({required String year, required String month, required String pageNumber,bool isLoaderShow = true,required int commissionDetailsIndex}) async {
    var jsonData = await apiManager.getAPICall(
      url:
      commissionDetailsIndex == 0?
      '${baseUrl}reporting/api/report-module/transactiondata/dist-unsetteled-comm-user?Month=$month&Year=$year&PageNumber=$pageNumber&PageSize=10':
      '${baseUrl}reporting/api/report-module/transactiondata/dist-setteled-comm-user?Month=$month&Year=$year&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = CommissionDetailsModal.fromJson(jsonData);
    return response;
  }


  // Get commission details report
  Future<CommissionDetailsExportModel> getCommissionDetailsExportReportApi({required String year, required String month, required String pageNumber,bool isLoaderShow = true,required int commissionDetailsIndex}) async {
    var jsonData = await apiManager.getAPICall(
      url:
      commissionDetailsIndex == 0?
      '${baseUrl}reporting/api/report-module/transactiondata/dist-unsetteled-comm-user-export?Month=$month&Year=$year&PageNumber=$pageNumber&PageSize=10':
      '${baseUrl}reporting/api/report-module/transactiondata/dist-setteled-comm-user-export?Month=$month&Year=$year&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = CommissionDetailsExportModel.fromJson(jsonData);
    return response;
  }



  // Get axis sip report api
  Future<AxisSipReportModel> getAxisSipReportApi({required String fromDate, required String toDate,required String serviceCode,  required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/transactionLead/transaction-lead-userwise-report?fromDate=$fromDate&toDate=$toDate&ServiceCode=$serviceCode&pageNumber=$pageNumber&pageSize=10&UserDetails=',
      isLoaderShow: isLoaderShow,
    );
    var response = AxisSipReportModel.fromJson(jsonData);
    return response;
  }
  // Get export api call
  Future<AxisSipExportModel> getExportSipApiCall({required String fromDate, required String toDate,required String serviceCode,  required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/transactionLead/transaction-sip-userwise-export?fromDate=$fromDate&toDate=$toDate&ServiceCode=$serviceCode&pageNumber=$pageNumber&pageSize=10&UserDetails=',

      isLoaderShow: isLoaderShow,
    );
    var response = AxisSipExportModel.fromJson(jsonData);
    return response;
  }

  //Get Search Transaction Report api

  Future<SearchTransactionReportModel> getSearchTransactionReportApi({required String mobileNo, required String accountNo,required String apiRefId, required String operatorRefId, required String clientRefId,required String orderId,required int userId, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}reporting/api/report-module/transactiondata/search-transaction-via-user?MobileNo=$mobileNo&AccountNumber=$accountNo&APIRefId=$apiRefId&OperatorRefId=$operatorRefId&ClientRefId=$clientRefId&OrderId=$orderId&UserId=$userId',
      isLoaderShow: isLoaderShow,
    );
    var response = SearchTransactionReportModel.fromJson(jsonData);
    return response;
  }


}

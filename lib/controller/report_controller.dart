import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
import '../model/report/commission_details_export_model.dart';
import '../model/report/commission_details_model.dart';
import '../model/report/notification_report_model.dart';
import '../model/report/payment_load_report_model.dart';
import '../model/report/search_transaction_report_model.dart';
import '../model/report/settled_commission_model.dart';
import '../model/report/statement_report_model.dart';
import '../model/report/transaction_slab_report_model.dart';
import '../model/report/unsettled_commission_model.dart';
import '../model/report/view_ticket_model.dart';
import '../model/success_model.dart';
import '../repository/report_repository.dart';
import '../utils/string_constants.dart';
import '../widgets/constant_widgets.dart';

class ReportController extends GetxController {
  ReportRepository reportRepository = ReportRepository(APIManager());

  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt serviceId = 1.obs;
  RxInt categoryId = 1.obs;
  RxDouble totalCredit = 0.00.obs;
  RxDouble totalDebit = 0.00.obs;
  RxInt transactionTypeIndex = 0.obs;
  RxString selectedCategoryType = ''.obs;
  RxString exportSipUrl = ''.obs;
  RxString selectedService = ''.obs;
  RxBool hasNext = false.obs;
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;
  RxBool isReportDetailsVisible = false.obs;
  RxList<String> transactionTypeList = <String>["ALL", "Telecom", "DMT", "BBPS", "AEPS", "MATM"].obs;
  RxBool isShowClearFiltersButton = false.obs;
  RxBool isFilteredUserPassbook = false.obs;

  TextEditingController fromDateController = TextEditingController(text: DateFormat("MM/dd/yyyy").format(DateTime.now()));
  TextEditingController toDateController = TextEditingController(text: DateFormat("MM/dd/yyyy").format(DateTime.now()));

  String formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('dd MMM, hh:mm a');
    return formatter.format(dateTime);
  }

  String formatDateTimeStyle(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('dd MMM, yyyy hh:mm a');
    return formatter.format(dateTime);
  }

  String formatDateTimeNormal(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(dateTime);
  }

  //for select usertype and user for reports

  TextEditingController searchUserController = TextEditingController();
  TextEditingController selectedUserTypeController = TextEditingController();
  RxString selectedUserId = ''.obs;
  TextEditingController selectedUserNameController = TextEditingController();
  TextEditingController selectedUserNameIdController = TextEditingController();
  RxString selectedUserBalance = ''.obs;

  // Get user list vai user type
  RxList<UserData> userList = <UserData>[].obs;
  RxList<BusinessPerformanceData> businessPerformanceDataList = <BusinessPerformanceData>[].obs;

  Future<bool> getUserListVaiUserType({required String userTypeId, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      UserListModel userListModel = await reportRepository.getUserListVaiUserTypeApiCall(
        userTypeId: userTypeId,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (userListModel.status == 1 && userListModel.data != null && userListModel.data!.isNotEmpty) {
        userList.clear();
        for (UserData element in userListModel.data!) {
          userList.add(element);
        }
        userList.sort((a, b) => a.ownerName!.toLowerCase().compareTo(b.ownerName!.toLowerCase()));
        return true;
      } else {
        userList.clear();
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //User type api call
  RxList<UserTypeModel> userTypeList = <UserTypeModel>[].obs;

  ////////////////////////
  /// Statement Report ///
  ////////////////////////
  RxInt selectedPassbookIndex = 0.obs;
  RxList<StatementReportData> statementReportList = <StatementReportData>[].obs;

  // Get statement report
  Future<bool> getStatementReportApi({String? userName, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      StatementReportModel statementReportModel = await reportRepository.getStatementReportListApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        userName: userName,
        isLoaderShow: isLoaderShow,
      );
      if (statementReportModel.statusCode == 1) {
        if (statementReportModel.pagination!.currentPage == 1) {
          statementReportList.clear();
        }
        for (StatementReportData element in statementReportModel.data!) {
          statementReportList.add(element);
        }
        currentPage.value = statementReportModel.pagination!.currentPage!;
        totalPages.value = statementReportModel.pagination!.totalPages!;
        totalCredit.value = statementReportModel.pagination!.totalCredit!;
        totalDebit.value = statementReportModel.pagination!.totalDebit!;
        hasNext.value = statementReportModel.pagination!.hasNext!;
        return true;
      } else if (statementReportModel.statusCode == 0) {
        statementReportList.clear();
        // errorSnackBar(message: statementReportModel.message);
        return true;
      } else {
        statementReportList.clear();
        // errorSnackBar(message: statementReportModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get bank withdrawal report
  RxList<BankWithdrawalReportData> bankWithdrawalReportList = <BankWithdrawalReportData>[].obs;

  Future<bool> getBankWithdrawalReportApi({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      BankWithdrawalReportModel bankWithdrawalReportModel = await reportRepository.getBankWithdrawalListApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (bankWithdrawalReportModel.status == 1) {
        if (bankWithdrawalReportModel.pagination!.currentPage == 1) {
          bankWithdrawalReportList.clear();
        }
        for (BankWithdrawalReportData element in bankWithdrawalReportModel.data!) {
          bankWithdrawalReportList.add(element);
        }
        currentPage.value = bankWithdrawalReportModel.pagination!.currentPage!;
        totalPages.value = bankWithdrawalReportModel.pagination!.totalPages!;
        hasNext.value = bankWithdrawalReportModel.pagination!.hasNext!;
        return true;
      } else if (bankWithdrawalReportModel.status == 0) {
        bankWithdrawalReportList.clear();
        return false;
      } else {
        bankWithdrawalReportList.clear();
        errorSnackBar(message: bankWithdrawalReportModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  RxList<PaymentLoadData> paymentLoadList = <PaymentLoadData>[].obs;

  Future<bool> getPaymentLoadReportApi({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      PaymentLoadReportModel paymentLoadReportModel = await reportRepository.getPaymentLoadReportApi(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (paymentLoadReportModel.statusCode == 1) {
        if (paymentLoadReportModel.pagination!.currentPage == 1) {
          paymentLoadList.clear();
        }
        for (PaymentLoadData element in paymentLoadReportModel.data!) {
          paymentLoadList.add(element);
        }
        currentPage.value = paymentLoadReportModel.pagination!.currentPage!;
        totalPages.value = paymentLoadReportModel.pagination!.totalPages!;
        hasNext.value = paymentLoadReportModel.pagination!.hasNext!;
        return true;
      } else if (paymentLoadReportModel.statusCode == 0) {
        paymentLoadList.clear();
        return false;
      } else {
        paymentLoadList.clear();
        errorSnackBar(message: paymentLoadReportModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //get raised complaint report
  RxList<RaisedComplaintReportData> raisedComplaintReportList = <RaisedComplaintReportData>[].obs;

  Future<bool> getRaisedComplaintReportApi({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      RaisedComplaintReportModel raisedComplaintReportModel = await reportRepository.getRaisedComplaintReportApi(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (raisedComplaintReportModel.status == 1) {
        if (raisedComplaintReportModel.pagination!.currentPage == 1) {
          raisedComplaintReportList.clear();
        }
        for (RaisedComplaintReportData element in raisedComplaintReportModel.data!) {
          raisedComplaintReportList.add(element);
        }
        currentPage.value = raisedComplaintReportModel.pagination!.currentPage!;
        totalPages.value = raisedComplaintReportModel.pagination!.totalPages!;
        hasNext.value = raisedComplaintReportModel.pagination!.hasNext!;
        return true;
      } else if (raisedComplaintReportModel.status == 0) {
        raisedComplaintReportList.clear();
        return false;
      } else {
        raisedComplaintReportList.clear();
        errorSnackBar(message: raisedComplaintReportModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }




  //get Axis Sip report
  RxList<AxisSipListModel> axisSipReportList = <AxisSipListModel>[].obs;

  Future<bool> getAxisSipReportApi({required int pageNumber,required String serviceCode, bool isLoaderShow = true}) async {
    try {
      AxisSipReportModel axisSipReportModel = await reportRepository.getAxisSipReportApi(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        serviceCode: serviceCode,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (axisSipReportModel.statusCode == 1) {
        if (axisSipReportModel.pagination!.currentPage == 1) {
          axisSipReportList.clear();
        }
        for (AxisSipListModel element in axisSipReportModel.axisSipModelList!) {
          axisSipReportList.add(element);
        }
        currentPage.value = axisSipReportModel.pagination!.currentPage!;
        totalPages.value = axisSipReportModel.pagination!.totalPages!;
        hasNext.value = axisSipReportModel.pagination!.hasNext!;
        return true;
      } else if (axisSipReportModel.statusCode == 0) {
        axisSipReportList.clear();
        return false;
      } else {
        axisSipReportList.clear();
        errorSnackBar(message: axisSipReportModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  RxList<TransactionSlabReportModel> transactionSlabList = <TransactionSlabReportModel>[].obs;
  RxDouble totalCost = 0.0.obs;
  RxDouble totalCharge = 0.0.obs;
  RxDouble totalCommission = 0.0.obs;
  RxDouble totalAmount = 0.0.obs;

  Future<bool> getTransactionSlabReportApi({required String operatorId, bool isLoaderShow = true}) async {
    try {
      List<TransactionSlabReportModel> transactionSlabModel = await reportRepository.getTransactionSlabReportApi(
        operatorId: operatorId,
        isLoaderShow: isLoaderShow,
      );
      if (transactionSlabModel.isNotEmpty) {
        transactionSlabList.value = [];
        totalCost.value = 0.0;
        totalCharge.value = 0.0;
        totalCommission.value = 0.0;
        totalAmount.value = 0.0;
        for (TransactionSlabReportModel element in transactionSlabModel) {
          totalCost.value += element.cost!;
          totalCharge.value += element.chargeAmt!;
          totalCommission.value += element.commAmt!;
          totalAmount.value += element.amount!;
          transactionSlabList.add(element);
        }
        return true;
      } else {
        transactionSlabList.value = [];
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> getBusinessPerformanceReportApi({required String fromDate, required String toDate, bool isLoaderShow = true}) async {
    try {
      BusinessPerformanceModel businessPerformanceModel = await reportRepository.businessPerformanceReportApiCall(fromDate: fromDate, toDate: toDate);
      if (businessPerformanceModel.statusCode == 1 && businessPerformanceModel.data != null && businessPerformanceModel.data!.isNotEmpty) {
        businessPerformanceDataList.clear();
        for (BusinessPerformanceData element in businessPerformanceModel.data!) {
          businessPerformanceDataList.add(element);
        }
        return true;
      } else {
        businessPerformanceDataList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  String bankWithdrawalStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Rejected';
    } else if (intStatus == 1) {
      status = 'Approved';
    } else if (intStatus == 2) {
      status = 'Pending';
    }
    return status;
  }

  String transactionStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Failed';
    } else if (intStatus == 1) {
      status = 'Successful';
    } else if (intStatus == 2) {
      status = 'Pending';
    }
    return status;
  }

  String dmtTransactionStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Failed';
    } else if (intStatus == 1) {
      status = 'Transferred';
    } else if (intStatus == 2) {
      status = 'Pending';
    }
    return status;
  }

  String giftCardBStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Failed';
    } else if (intStatus == 1) {
      status = 'Success';
    } else if (intStatus == 2) {
      status = 'Pending';
    }
    return status;
  }

  String raisedTicketStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Closed';
    } else if (intStatus == 1) {
      status = 'Resolved';
    } else if (intStatus == 2) {
      status = 'Pending';
    }
    return status;
  }

  String settlementCommissionStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Failed';
    } else if (intStatus == 1) {
      status = 'Settled';
    } else if (intStatus == 2) {
      status = 'Pending';
    }
    return status;
  }

  String ticketPriority(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Low';
    } else if (intStatus == 1) {
      status = 'Medium';
    } else if (intStatus == 2) {
      status = 'High';
    } else if (intStatus == 3) {
      status = 'Server';
    }
    return status;
  }

  //format DateTime in AMPM
  String formatDateTimeAMPM(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('MM/dd/yyyy hh:mm:ss a');
    return formatter.format(dateTime);
  }

  RxList<AepsPassbookWalletData> aepsWalletPassbookList = <AepsPassbookWalletData>[].obs;
  Future<bool> getAepsWalletPassbookApi({String? userName, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      AepsWalletPassbookModel aepsWalletPassbookModel = await reportRepository.getAepsWalletPassbookApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        userName: userName,
        isLoaderShow: isLoaderShow,
      );
      if (aepsWalletPassbookModel.statusCode == 1) {
        if (aepsWalletPassbookModel.pagination!.currentPage == 1) {
          aepsWalletPassbookList.clear();
        }
        for (AepsPassbookWalletData element in aepsWalletPassbookModel.data!) {
          aepsWalletPassbookList.add(element);
        }
        currentPage.value = aepsWalletPassbookModel.pagination!.currentPage!;
        totalPages.value = aepsWalletPassbookModel.pagination!.totalPages!;
        hasNext.value = aepsWalletPassbookModel.pagination!.hasNext!;
        return true;
      } else if (aepsWalletPassbookModel.statusCode == 0) {
        aepsWalletPassbookList.clear();
        // errorSnackBar(message: statementReportModel.message);
        return true;
      } else {
        aepsWalletPassbookList.clear();
        // errorSnackBar(message: statementReportModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  ////////////
  // Order Report//
  //////////////

  RxList<OrderListData> orderReportList = <OrderListData>[].obs;
  RxInt orderCurrentPage = 1.obs;
  RxInt orderTotalPages = 1.obs;
  RxBool orderHasNext = false.obs;
  TextEditingController commentController = TextEditingController();
  TextEditingController tPinTxtController = TextEditingController();
  RxBool isShowTpinField = false.obs;
  RxBool isShowTpin = true.obs;

  Future<bool> getOrderReportApi({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      OrderReportModel orderReportModel = await reportRepository.getOrderReportApiCall(
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (orderReportModel.statusCode == 1) {
        if (orderReportModel.pagination!.currentPage == 1) {
          orderReportList.clear();
        }
        for (OrderListData element in orderReportModel.data!) {
          orderReportList.add(element);
        }
        orderCurrentPage.value = orderReportModel.pagination!.currentPage!;
        orderTotalPages.value = orderReportModel.pagination!.totalPages!;
        orderHasNext.value = orderReportModel.pagination!.hasNext!;
        return true;
      } else if (orderReportModel.statusCode == 0) {
        orderReportList.clear();
        return true;
      } else {
        orderReportList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> updateOrderStatusApi({bool isLoaderShow = true, required String unqId, required String orderId}) async {
    try {
      OrderUpdateStatusModel orderUpdateStatusModel = await reportRepository.updateOrderStatusApiCall(
        params: {
          "unqId": unqId,
          "status": 0,
          "comment": commentController.text.trim(),
          "channel": channelID,
          "tpin": tPinTxtController.text.isNotEmpty ? tPinTxtController.text.trim() : null,
          "orderId": "12367"
        },
        isLoaderShow: isLoaderShow,
      );
      if (orderUpdateStatusModel.statusCode == 1) {
        successSnackBar(message: orderUpdateStatusModel.message);
        return true;
      } else {
        errorSnackBar(message: orderUpdateStatusModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  ////////////
  // Bank Sathi Report//
  //////////////

  RxList<BankSathiLeadReportData> leadReportList = <BankSathiLeadReportData>[].obs;
  RxInt leadReportCurrentPage = 1.obs;
  RxInt leadReportTotalPages = 1.obs;
  RxBool leadReportHasNext = false.obs;

  Future<bool> getLeadReportApi({required int pageNumber,required serviceCode, bool isLoaderShow = true}) async {
    try {
      BankSathiLeadReportModel leadReportModel = await reportRepository.getLeadReportApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        serviceCode: serviceCode,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (leadReportModel.statusCode == 1) {
        if (leadReportModel.pagination!.currentPage == 1) {
          leadReportList.clear();
        }
        for (BankSathiLeadReportData element in leadReportModel.data!) {
          leadReportList.add(element);
        }
        leadReportCurrentPage.value = leadReportModel.pagination!.currentPage!;
        leadReportTotalPages.value = leadReportModel.pagination!.totalPages!;
        leadReportHasNext.value = leadReportModel.pagination!.hasNext!;
        return true;
      } else if (leadReportModel.statusCode == 0) {
        leadReportList.clear();
        return true;
      } else {
        leadReportList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //notification report
  RxList<NotificationReportData> notificationReportList = <NotificationReportData>[].obs;

  RxInt notificationUnReadCount = 0.obs;
  RxBool isMoreDetails = false.obs;

  Future<bool> getNotificationReportApi({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      NotificationReportModel notificationReportModel = await reportRepository.getNotificationReportApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (notificationReportModel.statusCode == 1) {
        if (notificationReportModel.pagination!.currentPage == 1) {
          notificationReportList.clear();
        }
        notificationUnReadCount.value=0;
        //sorting notification list based on isRead value to show unread notification in ascending order
        notificationReportModel.notificationDataList!.sort((a, b) => (a.isRead == b.isRead) ? 0 : a.isRead! ? 1 : -1);

        for (NotificationReportData element in notificationReportModel.notificationDataList!) {
          notificationReportList.add(element);
          if(!element.isRead!){
            //incrementing unread notification count if notification is not read
           notificationUnReadCount.value++;
          }
        }
        currentPage.value = notificationReportModel.pagination!.currentPage!;
        totalPages.value = notificationReportModel.pagination!.totalPages!;
        hasNext.value = notificationReportModel.pagination!.hasNext!;
        return true;
      } else if (notificationReportModel.statusCode == 0) {
        notificationReportList.clear();
        return false;
      } else {
        notificationReportList.clear();
        errorSnackBar(message: notificationReportModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //read notification api
  Future<bool> readNotificationApi({bool isLoaderShow = true, required String id}) async {
    try {
      SuccessModel successModel = await reportRepository.readNotificationApiCall(
        params: {
          "isRead": true
        },
        isLoaderShow: isLoaderShow,
        uniqueId: id,
      );
      if (successModel.statusCode == 1) {
        notificationUnReadCount.value--;
        return true;
      } else {
        errorSnackBar(message: successModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }



  clearLeadReportVariables() {
    selectedFromDate.value = '';
    selectedToDate.value = '';
  }


  ///////////////////////////////
  //     Commission Report     //
  ///////////////////////////////

  RxInt selectedCommissionIndex = 0.obs;

  RxString selectedMonth = ''.obs;
  RxString selectedMonthName = ''.obs;
  RxString selectedYear = ''.obs;


  RxList<SettledCommissionModelData> settledReportDataList = <SettledCommissionModelData>[].obs;
  RxList<UnSettledCommissionModelData> unSettledReportDataList = <UnSettledCommissionModelData>[].obs;
  RxList<CommissionDetailsModalData> commissionDetailsReportDataList = <CommissionDetailsModalData>[].obs;
  RxString commissionDetailsExportReportUrl = "".obs;

  settledCommissionStatus(int? status){
    if(status == 1){
      return "Settled";
    }else if(status == 2){
      return "Pending";
    }
  }

  Future<bool> getSettledCommissionReportApi({required int pageNumber, bool isLoaderShow = true}) async {
    settledReportDataList.clear();
    try {
      SettledCommissionModel settlementCommissionModel = await reportRepository.getSettlementCommissionReportApi(
        pageNumber: pageNumber.toString(),
        isLoaderShow: isLoaderShow,
        year: selectedYear.value,
        month: selectedMonth.value,
      );
      if (settlementCommissionModel.statusCode == 1) {
        if (settlementCommissionModel.pagination!.currentPage == 1) {
          settledReportDataList.clear();
        }
        for(var element in settlementCommissionModel.data!){
          settledReportDataList.add(element);
        }
        currentPage.value = settlementCommissionModel.pagination!.currentPage!;
        totalPages.value = settlementCommissionModel.pagination!.totalPages!;
        hasNext.value = settlementCommissionModel.pagination!.hasNext!;
        return true;
      } else if (settlementCommissionModel.statusCode == 0) {
        settledReportDataList.clear();
        return false;
      } else {
        settledReportDataList.clear();
        errorSnackBar(message: settlementCommissionModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> getUnsettledCommissionReportApi({required int pageNumber, bool isLoaderShow = true}) async {
    unSettledReportDataList.clear();
    try {
      UnSettledCommissionModel unSettledCommissionModel = await reportRepository.getUnSettlementCommissionReportApi(
        pageNumber: pageNumber.toString(),
        isLoaderShow: isLoaderShow,
        year: selectedYear.value,
        month: selectedMonth.value,
      );

      if (unSettledCommissionModel.statusCode == 1) {
        if (unSettledCommissionModel.pagination!.currentPage == 1) {
          unSettledReportDataList.clear();
        }
        for(var element in unSettledCommissionModel.data!){
          unSettledReportDataList.add(element);
        }
        currentPage.value = unSettledCommissionModel.pagination!.currentPage!;
        totalPages.value = unSettledCommissionModel.pagination!.totalPages!;
        hasNext.value = unSettledCommissionModel.pagination!.hasNext!;
        return true;
      } else if (unSettledCommissionModel.statusCode == 0) {
        unSettledReportDataList.clear();
        return false;
      } else {
        unSettledReportDataList.clear();
        errorSnackBar(message: unSettledCommissionModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> getCommissionDetailsReportApi({required int pageNumber, bool isLoaderShow = true,required int commissionDetailsIndex}) async {
    commissionDetailsReportDataList.clear();
    try {
      CommissionDetailsModal commissionDetailsModal = await reportRepository.getCommissionDetailsReportApi(
        pageNumber: pageNumber.toString(),
        isLoaderShow: isLoaderShow,
        year: selectedYear.value,
        month: selectedMonth.value,
        commissionDetailsIndex: commissionDetailsIndex,
      );

      if (commissionDetailsModal.statusCode == 1) {
        if (commissionDetailsModal.pagination!.currentPage == 1) {
          commissionDetailsReportDataList.clear();
        }
        for(var element in commissionDetailsModal.data!){
          commissionDetailsReportDataList.add(element);
        }
        currentPage.value = commissionDetailsModal.pagination!.currentPage!;
        totalPages.value = commissionDetailsModal.pagination!.totalPages!;
        hasNext.value = commissionDetailsModal.pagination!.hasNext!;
        return true;
      } else if (commissionDetailsModal.statusCode == 0) {
        commissionDetailsReportDataList.clear();
        return false;
      } else {
        commissionDetailsReportDataList.clear();
        errorSnackBar(message: commissionDetailsModal.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> getCommissionDetailsExportReportApi({required int pageNumber, bool isLoaderShow = true,required int commissionDetailsIndex}) async {
    commissionDetailsExportReportUrl.value = "";
    try {
      CommissionDetailsExportModel commissionDetailsExportModel = await reportRepository.getCommissionDetailsExportReportApi(
        pageNumber: pageNumber.toString(),
        isLoaderShow: isLoaderShow,
        year: selectedYear.value,
        month: selectedMonth.value,
        commissionDetailsIndex: commissionDetailsIndex,
      );
      if (commissionDetailsExportModel.statusCode == 1) {
        commissionDetailsExportReportUrl.value = commissionDetailsExportModel.url!.toString();
        return true;
      } else if (commissionDetailsExportModel.statusCode == 0) {
        return false;
      } else {
        errorSnackBar(message: commissionDetailsExportModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //Get wallet type
  Future<bool> getAxisSipExportApi({required int pageNumber,required String serviceCode, bool isLoaderShow = true}) async {
    try {
      AxisSipExportModel axisSipReportModel = await reportRepository.getExportSipApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        serviceCode: serviceCode,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (axisSipReportModel.item1 == true) {
        exportSipUrl.value=axisSipReportModel.item2!;
        return true;
      } else {
        errorSnackBar(message: "Something went wrong");
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

//Search Transaction Report
  RxList<SearchTransactionData> searchTransactionReportDataList = <SearchTransactionData>[].obs;
  TextEditingController searchTransactionController = TextEditingController();
  RxString searchType = "".obs;
  RxList<String> searchTypeList = ["Mobile", "Account Number", "Api Ref Id", "RRN", "Client Ref Id", "TID"].obs;


  Future<bool> getSearchTransactionReport({required String mobileNo,required String accountNo,required String apiRefId,required String operatorRefId,required String clientRefId,required String orderId,required int userId,bool isLoaderShow = true}) async {
    searchTransactionReportDataList.clear();
    try {
      SearchTransactionReportModel searchTransactionReportModel = await reportRepository.getSearchTransactionReportApi(
        mobileNo: mobileNo,
        accountNo: accountNo,
        apiRefId: apiRefId,
        operatorRefId: operatorRefId,
        clientRefId: clientRefId,
        orderId: orderId,
        userId: userId,
        isLoaderShow: isLoaderShow,
      );

      if (searchTransactionReportModel.statusCode == 1) {
        for(var element in searchTransactionReportModel.data!){
          searchTransactionReportDataList.add(element);
        }

        return true;
      } else if (searchTransactionReportModel.statusCode == 0) {
        searchTransactionReportDataList.clear();
        return false;
      } else {
        searchTransactionReportDataList.clear();
        errorSnackBar(message: searchTransactionReportModel.message);
        return false;
      }
    } catch (e) {
      print("Exception => $e");
      dismissProgressIndicator();
      return false;
    }
  }


}

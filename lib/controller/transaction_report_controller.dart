import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../api/api_manager.dart';
import '../model/auth/user_type_model.dart';
import '../model/credit_debit/user_list_model.dart';
import '../model/report/category_model.dart';
import '../model/report/service_model.dart';
import '../model/report/transaction_report_model.dart';
import '../repository/report_repository.dart';
import '../widgets/constant_widgets.dart';

class TransactionReportController extends GetxController {
  ReportRepository reportRepository = ReportRepository(APIManager());

  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;
  RxBool isShowClearFiltersButton = false.obs;

  // Format dateTime
  String formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('MM/dd/yyyy hh:mm:ss a');
    return formatter.format(dateTime);
  }

  // Get user type
  RxList<UserTypeModel> userTypeList = <UserTypeModel>[].obs;
  Future<bool> getUserType({bool isLoaderShow = true}) async {
    try {
      List<UserTypeModel> userTypeModel = await reportRepository.userTypeApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (userTypeModel.isNotEmpty) {
        userTypeList.clear();
        userTypeList.addAll(userTypeModel.where((element) => element.status == 1 && element.isUser == true));
        return true;
      } else {
        userTypeList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get user list vai user type
  RxList<UserData> userList = <UserData>[].obs;
  Future<bool> getUserListVaiUserType({String? searchText, required String userTypeId, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      UserListModel userListModel = await reportRepository.getUserListVaiUserTypeApiCall(
        searchText: searchText,
        userTypeId: userTypeId,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (userListModel.status == 1 && userListModel.data != null && userListModel.data!.isNotEmpty) {
        userList.clear();
        for (UserData element in userListModel.data!) {
          if (element.status == 1) {
            userList.add(element);
          }
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

  Future<bool> getUserListVaiSearch({required String searchText, required String userTypeId, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      UserListModel userListModel = await reportRepository.searchUserListVaiUserTypeApiCall(
        searchText: searchText,
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

  // Get user list vai user type
  RxList<UserData> childUserList = <UserData>[].obs;
  Future<bool> getChildUserListVaiParent({String? searchText, required String parentId, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      UserListModel userListModel = await reportRepository.getChildUserListVaiParentApiCall(
        searchText: searchText,
        parentId: parentId,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (userListModel.status == 1 && userListModel.data != null && userListModel.data!.isNotEmpty) {
        childUserList.clear();
        for (UserData element in userListModel.data!) {
          if (element.status == 1) {
            childUserList.add(element);
          }
        }
        childUserList.sort((a, b) => a.ownerName!.toLowerCase().compareTo(b.ownerName!.toLowerCase()));
        return true;
      } else {
        childUserList.clear();
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get category list
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  Future<bool> getCategoryList({bool isLoaderShow = true}) async {
    try {
      List<CategoryModel> categoryListModel = await reportRepository.getCategoryApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (categoryListModel.isNotEmpty) {
        categoryList.clear();
        categoryList.addAll(categoryListModel.where((element) => element.status != null && element.status == 1));
        categoryList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        return true;
      } else {
        categoryList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get Service List
  RxList<ServiceModel> serviceList = <ServiceModel>[].obs;
  Future<bool> getServiceList({required String categoryId, bool isLoaderShow = true}) async {
    try {
      List<ServiceModel> serviceListModel = await reportRepository.getServiceApiCall(
        categoryId: categoryId,
        isLoaderShow: isLoaderShow,
      );

      if (serviceListModel.isNotEmpty) {
        serviceList.clear();
        serviceList.addAll(serviceListModel.where((element) => element.status != null && element.status == 1));
        serviceList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        return true;
      } else {
        serviceList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get transaction report
  RxInt selectedPassbookIndex = 0.obs;
  RxList<TransactionReportData> transactionReportList = <TransactionReportData>[].obs;
  TextEditingController selectedUserTypeController = TextEditingController();
  RxString selectedUserTypeId = ''.obs;
  RxString selectedUserTypeCode = ''.obs;
  TextEditingController selectedAreaDistributorController = TextEditingController();
  RxString selectedAreaDistributorId = ''.obs;
  TextEditingController selectedRetailerController = TextEditingController();
  RxString selectedRetailerId = ''.obs;
  TextEditingController searchUsernameController = TextEditingController();
  TextEditingController selectedCategoryController = TextEditingController();
  RxString selectedCategoryId = ''.obs;
  TextEditingController selectedServiceController = TextEditingController();
  RxString selectedServiceId = ''.obs;
  Future<bool> getTransactionReportApi({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      TransactionReportModel transactionReportModel = await reportRepository.getTransactionReportListApiCall(
        username: searchUsernameController.text,
        categoryId: selectedCategoryId.value.isNotEmpty ? selectedCategoryId.value : '',
        serviceId: selectedServiceId.value.isNotEmpty ? selectedServiceId.value : '',
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (transactionReportModel.statusCode == 1) {
        if (transactionReportModel.pagination!.currentPage == 1) {
          transactionReportList.clear();
        }
        for (TransactionReportData element in transactionReportModel.data!) {
          transactionReportList.add(element);
        }
        currentPage.value = transactionReportModel.pagination!.currentPage!;
        totalPages.value = transactionReportModel.pagination!.totalPages!;
        hasNext.value = transactionReportModel.pagination!.hasNext!;
        return true;
      } else if (transactionReportModel.statusCode == 0) {
        transactionReportList.clear();
        return false;
      } else {
        transactionReportList.clear();
        errorSnackBar(message: transactionReportModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  resetRetailerFilterVariable() {
    selectedCategoryController.clear();
    selectedCategoryId.value = '';
    selectedServiceController.clear();
    selectedServiceId.value = '';
    isShowClearFiltersButton.value = false;
  }

  resetAreaDistributorFilterVariable() {
    selectedUserTypeController.clear();
    selectedUserTypeId.value = '';
    selectedAreaDistributorController.clear();
    selectedAreaDistributorId.value = '';
    selectedRetailerController.clear();
    selectedRetailerId.value = '';
    searchUsernameController.clear();
    selectedCategoryController.clear();
    selectedCategoryId.value = '';
    selectedServiceController.clear();
    selectedServiceId.value = '';
    isShowClearFiltersButton.value = false;
  }
}

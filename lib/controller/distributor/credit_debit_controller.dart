import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../api/api_manager.dart';
import '../../model/auth/user_type_model.dart';
import '../../model/credit_debit/debit_history_model.dart';
import '../../model/credit_debit/user_list_model.dart';
import '../../model/credit_debit/wallet_model.dart';
import '../../model/credit_debit/wallet_type_model.dart';
import '../../repository/distributor/credit_debit_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class CreditDebitController extends GetxController {
  CreditDebitRepository creditDebitRepository = CreditDebitRepository(APIManager());
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;
  RxString selectedWalletMethodRadio = 'Credit'.obs;
  // Get user type
  RxList<UserTypeModel> userTypeList = <UserTypeModel>[].obs;
  Future<bool> getUserType({bool isLoaderShow = true}) async {
    try {
      List<UserTypeModel> userTypeModelList = await creditDebitRepository.getUserTypeApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (userTypeModelList.isNotEmpty) {
        userTypeList.clear();
        for (UserTypeModel element in userTypeModelList) {
          if (element.status == 1 && element.isUser == true) {
            userTypeList.add(element);
          }
        }
        return true;
      } else {
        userTypeList.clear();
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get user list vai user type
  RxList<UserData> userList = <UserData>[].obs;
  RxBool isOutstanding = false.obs;
  Future<bool> getUserListVaiUserType({required String userTypeId, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      UserListModel userListModel = await creditDebitRepository.getUserListVaiUserTypeApiCall(
        userTypeId: userTypeId,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (userListModel.status == 1 && userListModel.data != null && userListModel.data!.isNotEmpty) {
        if (userListModel.pagination!.currentPage == 1) {
          userList.clear();
        }
        for (UserData element in userListModel.data!) {
          if (element.status == 1) {
            userList.add(element);
          }
        }
        currentPage.value = userListModel.pagination!.currentPage!;
        totalPages.value = userListModel.pagination!.totalPages!;
        hasNext.value = userListModel.pagination!.hasNext!;
        userList.sort((a, b) => a.ownerName!.toLowerCase().compareTo(b.ownerName!.toLowerCase()));
        return true;
      } else {
        userList.clear();
        errorSnackBar(message: userListModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get user list vai search
  Future<bool> getUserListVaiSearch({required String text, required String userTypeId, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      UserListModel userListModel = await creditDebitRepository.searchUserListVaiUserTypeApiCall(
        text: text,
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
        errorSnackBar(message: userListModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get wallet type
  RxList<WalletTypeModel> walletList = <WalletTypeModel>[].obs;
  Future<bool> getWalletType({bool isLoaderShow = true}) async {
    try {
      List<WalletTypeModel> walletTypeModel = await creditDebitRepository.getWalletTypeApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (walletTypeModel.isNotEmpty) {
        walletList.clear();
        for (WalletTypeModel element in walletTypeModel) {
          if (element.status == 1) {
            walletList.add(element);
          }
        }
        return true;
      } else {
        walletList.clear();
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Credit debit wallet
  Rx<CreditDebitWalletModel> creditDebitWalletModel = CreditDebitWalletModel().obs;
  TextEditingController selectedUserTypeController = TextEditingController();
  RxString selectedUserTypeId = ''.obs;
  TextEditingController selectedUserNameController = TextEditingController();
  TextEditingController selectedUserNameIdController = TextEditingController();
  RxString selectedUserBalance = ''.obs;
  RxString selectedOutstandingBalance = ''.obs;
  TextEditingController selectedPaymentModeController = TextEditingController();
  TextEditingController selectedPaymentModeIdController = TextEditingController();
  TextEditingController selectedWalletController = TextEditingController();
  RxInt selectedWalletId = 0.obs;
  TextEditingController amountController = TextEditingController();
  RxString amountIntoWords = ''.obs;
  TextEditingController tPinController = TextEditingController();
  RxBool isShowTpin = true.obs;
  TextEditingController remarkController = TextEditingController();

  Future<bool> creditDebitWallet({required int paymentMode, bool isLoaderShow = true}) async {
    try {
      creditDebitWalletModel.value = await creditDebitRepository.creditDebitWalletApiCall(
        params: {
          'userTypeId': selectedUserTypeId.value,
          'crDrUserId': selectedUserNameIdController.text.trim(),
          'paymentMode': paymentMode.toString(),
          'wallet': selectedWalletId.value,
          'amount': amountController.text.trim(),
          'tpin': tPinController.text.isNotEmpty ? tPinController.text.trim() : null,
          'comment': remarkController.text.trim(),
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'isCredit': isOutstanding.value,
          'channel': channelID,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (creditDebitWalletModel.value.statusCode == 1) {
        Get.back();
        successSnackBar(message: creditDebitWalletModel.value.message!);
        return true;
      } else {
        Get.back();
        errorSnackBar(message: creditDebitWalletModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  RxList<CreditDebitData> creditDebitHistoryDataList = <CreditDebitData>[].obs;

  String formatDateTimeNormal(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat("MM/dd/yyyy");
    return formatter.format(dateTime);
  }

  TextEditingController fromDateController = TextEditingController(text: DateFormat("yyyy/MM/dd").format(DateTime.now()));
  TextEditingController toDateController = TextEditingController(text: DateFormat("yyyy/MM/dd").format(DateTime.now()));

  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;

  Future<bool> getCreditDebitHistoryApi({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      CreditDebitHistoryModel creditDebitHistoryModel = await creditDebitRepository.getCreditDebitHistoryApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (creditDebitHistoryModel.statusCode == 1) {
        for (CreditDebitData element in creditDebitHistoryModel.data!) {
          creditDebitHistoryDataList.add(element);
        }
        currentPage.value = creditDebitHistoryModel.pagination!.currentPage!;
        totalPages.value = creditDebitHistoryModel.pagination!.totalPages!;
        hasNext.value = creditDebitHistoryModel.pagination!.hasNext!;
        return true;
      } else if (creditDebitHistoryModel.statusCode == 0) {
        creditDebitHistoryDataList.clear();
        return false;
      } else {
        creditDebitHistoryDataList.clear();
        errorSnackBar(message: creditDebitHistoryModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Submit outstanding collection
  Future<bool> outstandingCollectionAPI({bool isLoaderShow = true}) async {
    try {
      creditDebitWalletModel.value = await creditDebitRepository.outstandingApiCall(
        params: {
          'userTypeId': selectedUserTypeId.value,
          'crDrUserId': selectedUserNameIdController.text.trim(),
          'amount': amountController.text.trim(),
          'tpin': tPinController.text.isNotEmpty ? tPinController.text.trim() : null,
          'comment': remarkController.text.trim(),
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'channel': channelID,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (creditDebitWalletModel.value.statusCode == 1) {
        Get.back();
        successSnackBar(message: creditDebitWalletModel.value.message!);
        return true;
      } else {
        errorSnackBar(message: creditDebitWalletModel.value.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Reset credit debit wallet variables
  resetCreditDebitWalletVariables() {
    userList.clear();
    selectedUserTypeController.clear();
    selectedUserTypeId.value = '';
    selectedUserBalance.value = '';
    selectedOutstandingBalance.value = '';
    selectedUserNameController.clear();
    selectedUserNameIdController.clear();
    selectedPaymentModeIdController.clear();
    selectedWalletController.clear();
    selectedWalletId.value = 0;
    amountController.clear();
    amountIntoWords.value = '';
    tPinController.clear();
    isShowTpin.value = true;
    isOutstanding.value = false;
    remarkController.clear();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_manager.dart';
import '../../model/auth/user_type_model.dart';
import '../../model/report/agent_performance_model.dart';
import '../../model/view_user_model.dart';
import '../../repository/distributor/agent_performance_repository.dart';
import '../../repository/distributor/view_user_repository.dart';
import '../../widgets/constant_widgets.dart';

class ViewUserController extends GetxController {
  ViewUserRepository viewUserRepository = ViewUserRepository(APIManager());
  AgentPerformanceRepository agentPerformanceRepository = AgentPerformanceRepository(APIManager());

  // For view user
  TextEditingController searchReportTxtController = TextEditingController();
  RxBool isShowClearFiltersButton = false.obs;

  RxString selectedSearchUserId = ''.obs;
  TextEditingController searchUserNameTxtController = TextEditingController();

  //Agent Performance
  RxList<AgentPerformanceData> agentPerformanceList = <AgentPerformanceData>[].obs;

  // converting integer status into string
  String kycStatus(int intStatus) {
    String status = '';
    if (intStatus == 1) {
      status = 'Submitted';
    } else if (intStatus == 2) {
      status = 'Not Submitted';
    } else if (intStatus == 3) {
      status = 'Approved';
    } else if (intStatus == 4) {
      status = 'Rejected';
    } else if (intStatus == 5) {
      status = 'Revision';
    } else if (intStatus == 6) {
      status = 'Registered';
    }
    return status;
  }

  // User type api call
  RxList<UserTypeModel> userTypeList = <UserTypeModel>[].obs;

  Future<bool> getUserType({bool isLoaderShow = true}) async {
    try {
      List<UserTypeModel> userTypeModel = await viewUserRepository.userTypeApiCall(isLoaderShow: isLoaderShow);
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

  // View user
  RxList<UserData> userList = <UserData>[].obs;
  RxInt userCurrentPage = 1.obs;
  RxInt userTotalPages = 1.obs;
  RxBool userHasNext = false.obs;
  TextEditingController searchUsernameController = TextEditingController();
  TextEditingController selectedUserTypeController = TextEditingController();
  RxString selectedUserTypeId = ''.obs;
  Future<bool> getViewUserListApi({String? username, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      ViewUserModel viewUserModel = await viewUserRepository.viewUserApiCall(
        username: username,
        userTypeId: selectedUserTypeId.value.isNotEmpty ? selectedUserTypeId.value : '',
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (viewUserModel.status == 1) {
        if (viewUserModel.pagination!.currentPage! == 1) {
          userList.clear();
        }
        for (UserData element in viewUserModel.data!) {
          userList.add(element);
        }
        userCurrentPage.value = viewUserModel.pagination!.currentPage!;
        userTotalPages.value = viewUserModel.pagination!.totalPages!;
        userHasNext.value = viewUserModel.pagination!.hasNext!;
        return true;
      } else {
        userList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // View child user
  RxList<UserData> childUserList = <UserData>[].obs;

  RxInt childUserCurrentPage = 1.obs;
  RxInt childUserTotalPages = 1.obs;
  RxBool childUserHasNext = false.obs;
  TextEditingController searchChildUsernameController = TextEditingController();
  Future<bool> getViewChildUserListApi({String? username, required String uniqueId, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      ViewUserModel viewUserModel = await viewUserRepository.viewChildUserApiCall(
        uniqueId: uniqueId,
        username: username,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (viewUserModel.status == 1) {
        if (viewUserModel.pagination!.currentPage! == 1) {
          childUserList.clear();
        }
        for (UserData element in viewUserModel.data!) {
          childUserList.add(element);
        }
        childUserCurrentPage.value = viewUserModel.pagination!.currentPage!;
        childUserTotalPages.value = viewUserModel.pagination!.totalPages!;
        childUserHasNext.value = viewUserModel.pagination!.hasNext!;
        return true;
      } else {
        childUserList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //Agent performance api
  Future<bool> getAgentPerformanceApi({required String fromDate, required String toDate, required String searchUserID, bool isLoaderShow = true}) async {
    try {
      AgentPerformanceModel agentPerformanceModel = await agentPerformanceRepository.agentPerformanceApiCall(fromDate: fromDate, toDate: toDate, searchUserID: searchUserID);
      if (agentPerformanceModel.statusCode == 1 && agentPerformanceModel.data != null && agentPerformanceModel.data!.isNotEmpty) {
        agentPerformanceList.clear();
        for (AgentPerformanceData element in agentPerformanceModel.data!) {
          agentPerformanceList.add(element);
        }
        return true;
      } else {
        agentPerformanceList.clear();
        dismissProgressIndicator();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}

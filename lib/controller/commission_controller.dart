import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_manager.dart';
import '../../model/commission/commission_model.dart';
import '../repository/commission_repository.dart';
import '../../widgets/constant_widgets.dart';

class CommissionController extends GetxController {
  CommissionRepository commissionRepository = CommissionRepository(APIManager());
  TextEditingController searchController = TextEditingController();
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;

  // Get commission
  RxList<CommissionModelList> commissionList = <CommissionModelList>[].obs;
  Future<bool> getCommission({String? searchOperatorName, required int pageNumber, bool isLoaderShow = true}) async {
    try {
      CommissionModel commissionModel = await commissionRepository.getCommissionApiCall(
        searchOperatorName: searchOperatorName,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      if (commissionModel.statusCode == 1) {
        if (commissionModel.pagination!.currentPage == 1) {
          commissionList.clear();
        }
        for (CommissionModelList element in commissionModel.data!) {
          commissionList.add(element);
        }
        currentPage.value = commissionModel.pagination!.currentPage!;
        totalPages.value = commissionModel.pagination!.totalPages!;
        hasNext.value = commissionModel.pagination!.hasNext!;
        return true;
      } else {
        commissionList.clear();
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}

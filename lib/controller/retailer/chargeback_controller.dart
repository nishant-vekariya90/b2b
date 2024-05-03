import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../api/api_manager.dart';
import '../../model/chargeback/chargeback_doc_model.dart';
import '../../model/chargeback/chargeback_raised_model.dart';
import '../../model/success_model.dart';
import '../../repository/retailer/chargeback_repository.dart';
import '../../widgets/constant_widgets.dart';

class ChargebackController extends GetxController{
  ChargebackRepository chargebackRepository = ChargebackRepository(APIManager());

  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxInt selectedCommissionIndex = 0.obs;
  RxBool hasNext = false.obs;
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  RxString selectedFromDate = ''.obs;
  RxString selectedToDate = ''.obs;
  List finalDocsStepObjList = [];


  String formatDateTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    final DateFormat formatter = DateFormat('dd MMM, hh:mm a');
    return formatter.format(dateTime);
  }


  String chargebackRaisedStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'Raised';
    } else if (intStatus == 1) {
      status = 'Approved';
    } else if (intStatus == 2) {
      status = 'Inprocess';
    } else if(intStatus == 3){
      status = 'Closed';
    } else if(intStatus == 4){
      status = 'Revision';
    } else if(intStatus == 5){
      status = 'Initiated';
    }
    return status;
  }


  // Get chargeback raised list
  RxList<ChargebackRaisedData> chargebackRaisedList = <ChargebackRaisedData>[].obs;

  // Get chargeback raised list api
  Future<bool> getChargebackRaisedListApi({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      ChargebackRaisedModel chargebackRaisedModel = await chargebackRepository.getChargebackRaisedApiCall(
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      chargebackRaisedList.clear();
      if (chargebackRaisedModel.statusCode == 1) {
        if (chargebackRaisedModel.pagination!.currentPage == 1) {
          chargebackRaisedList.clear();
        }
        for (var element in chargebackRaisedModel.data!) {
          chargebackRaisedList.add(element);
        }
        currentPage.value = chargebackRaisedModel.pagination!.currentPage!;
        totalPages.value = chargebackRaisedModel.pagination!.totalPages!;
        hasNext.value = chargebackRaisedModel.pagination!.hasNext!;
        return true;
      } else if (chargebackRaisedModel.statusCode == 0) {
        chargebackRaisedList.clear();
        return false;
      } else {
        chargebackRaisedList.clear();
        errorSnackBar(message: chargebackRaisedModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //Get chargeback history list api
  Future<bool> getChargebackHistoryApi({required int pageNumber, bool isLoaderShow = true}) async {
    try {
      ChargebackRaisedModel chargebackRaisedModel = await chargebackRepository.getChargebackHistoryApiCall(
        fromDate: selectedFromDate.value,
        toDate: selectedToDate.value,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
      );
      chargebackRaisedList.clear();
      if (chargebackRaisedModel.statusCode == 1) {
        if (chargebackRaisedModel.pagination!.currentPage == 1) {
          chargebackRaisedList.clear();
        }
        for (var element in chargebackRaisedModel.data!) {
          chargebackRaisedList.add(element);
        }
        currentPage.value = chargebackRaisedModel.pagination!.currentPage!;
        totalPages.value = chargebackRaisedModel.pagination!.totalPages!;
        hasNext.value = chargebackRaisedModel.pagination!.hasNext!;
        return true;
      } else if (chargebackRaisedModel.statusCode == 0) {
        chargebackRaisedList.clear();
        return true;
      } else {
        chargebackRaisedList.clear();
        errorSnackBar(message: chargebackRaisedModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }


  RxList<ChargebackDocModel> chargeBackDocList = <ChargebackDocModel>[].obs;

  Future<bool> getChargebackDocApi({required String uniqueId,bool isLoaderShow = true}) async {
    try {
      List<ChargebackDocModel> response = await chargebackRepository.getChargebackDocApiCall(isLoaderShow: isLoaderShow,uniqueId: uniqueId);
      chargeBackDocList.clear();
      if (response.isNotEmpty) {
        chargeBackDocList.addAll(response);
        return true;
      } else {
        chargeBackDocList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }


  Future<bool> uploadDocumentsApi({bool isLoaderShow = true}) async {
    try {
      SuccessModel successModel = await chargebackRepository.uploadDocsApiCall(
        params:finalDocsStepObjList,
        isLoaderShow: isLoaderShow,
      );
      if (successModel.statusCode == 1) {
        successSnackBar(message: successModel.message);
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

}
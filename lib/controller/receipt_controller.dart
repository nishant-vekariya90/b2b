import 'dart:io';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../api/api_manager.dart';
import '../model/receipt_model.dart';
import '../repository/receipt_repository.dart';
import '../utils/string_constants.dart';
import '../widgets/constant_widgets.dart';

class ReceiptController extends GetxController {
  ReceiptRepository receiptRepository = ReceiptRepository(APIManager());

  // Get receipt
  RxString generatedReceipt = ''.obs;
  RxString generatedPdfFilePath = ''.obs;
  RxBool isPdfLoad = false.obs;

  // Get receipt for Recharge, DMT, BBPS
  Future<bool> getReceipt({required String transactionId, required int type, required String design, bool isLoaderShow = true}) async {
    try {
      ReceiptModel receiptModel = await receiptRepository.getReceiptApiCall(
        transactionId: transactionId,
        type: type,
        design: design,
        isLoaderShow: isLoaderShow,
      );
      if (receiptModel.statusCode == 1 && receiptModel.receipt != null && receiptModel.receipt!.isNotEmpty) {
        generatedReceipt.value = unescapeHtml(receiptModel.receipt!);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get receipt for balance enquiry
  Future<bool> getReceiptForBalanceEnquiry({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    try {
      ReceiptModel receiptModel = await receiptRepository.getReceiptForBalanceEnquiryApiCall(
        params: params,
        isLoaderShow: isLoaderShow,
      );
      if (receiptModel.statusCode == 1 && receiptModel.receipt != null && receiptModel.receipt!.isNotEmpty) {
        generatedReceipt.value = unescapeHtml(receiptModel.receipt!);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get receipt for mini statement
  Future<bool> getReceiptForMiniStatement({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    try {
      ReceiptModel receiptModel = await receiptRepository.getReceiptForMiniStatementApiCall(
        params: params,
        isLoaderShow: isLoaderShow,
      );
      if (receiptModel.statusCode == 1 && receiptModel.receipt != null && receiptModel.receipt!.isNotEmpty) {
        generatedReceipt.value = unescapeHtml(receiptModel.receipt!);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get receipt for flight booking
  Future<bool> getFlightBookingReceipt({required String orderId, bool isLoaderShow = true}) async {
    try {
      ReceiptModel receiptModel = await receiptRepository.getFlightReceiptApiCall(
        orderId: orderId,
        isLoaderShow: isLoaderShow,
      );
      if (receiptModel.statusCode == 1 && receiptModel.receipt != null && receiptModel.receipt!.isNotEmpty) {
        generatedReceipt.value = unescapeHtml(receiptModel.receipt!);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

// Get receipt for bus booking
  Future<bool> getBusBookingReceipt({required String orderId, bool isLoaderShow = true}) async {
    try {
      ReceiptModel receiptModel = await receiptRepository.getBusReceiptApiCall(
        orderId: orderId,
        isLoaderShow: isLoaderShow,
      );
      if (receiptModel.statusCode == 1 && receiptModel.receipt != null && receiptModel.receipt!.isNotEmpty) {
        generatedReceipt.value = unescapeHtml(receiptModel.receipt!);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Create new folder in Documents/DCIM directory
  Future<Directory> createFolder({required String path}) async {
    final dir = Directory(
      '${(Platform.isAndroid ? Directory(path) //FOR ANDROID
              : await getApplicationSupportDirectory() //FOR IOS
          ).path}/$appName',
    );
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await dir.exists())) {
      return dir;
    } else {
      dir.create();
      return dir;
    }
  }

  // Download pdf
  downloadPdf() async {
    showProgressIndicator();
    try {
      Directory directory = await createFolder(path: 'storage/emulated/0/Documents');
      await FlutterHtmlToPdf.convertFromHtmlContent(
        "'''${generatedReceipt.value}'''",
        directory.path,
        DateTime.now().millisecondsSinceEpoch.toString(),
      );
      successSnackBar(message: 'Receipt download successfully.');
    } catch (e) {
      errorSnackBar(message: e.toString());
    } finally {
      dismissProgressIndicator();
    }
  }
}

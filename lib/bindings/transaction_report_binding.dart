import '../controller/receipt_controller.dart';
import '../controller/report_controller.dart';
import 'package:get/get.dart';
import '../controller/transaction_report_controller.dart';

class TransactionReportBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionReportController>(() => TransactionReportController());
    Get.lazyPut<ReportController>(() => ReportController());
    Get.lazyPut<ReceiptController>(() => ReceiptController());

  }
}

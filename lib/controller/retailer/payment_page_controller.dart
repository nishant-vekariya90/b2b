import 'package:get/get.dart';
import '../../api/api_manager.dart';
import '../../model/payment_page/payment_page_model.dart';
import '../../repository/retailer/payment_page_repository.dart';
import '../../widgets/constant_widgets.dart';

class PaymentPageController extends GetxController {
  PaymentPageRepository paymentPageRepository = PaymentPageRepository(APIManager());

  @override
  onInit() {
    super.onInit();
    getPaymentPageLink();
  }

  // Get payment page link
  Rx<PaymentPageModel> paymentPageModel = PaymentPageModel().obs;
  RxString paymentPageLink = ''.obs;
  RxBool isLinkCopied = false.obs;
  Future<bool> getPaymentPageLink({bool isLoaderShow = true}) async {
    try {
      paymentPageModel.value = await paymentPageRepository.paymentPageApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (paymentPageModel.value.statusCode == 1) {
        if (paymentPageModel.value.link!.isNotEmpty) {
          paymentPageLink.value = paymentPageModel.value.link!.first;
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}

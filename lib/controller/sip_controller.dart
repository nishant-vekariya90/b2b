import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../api/api_manager.dart';
import '../model/sip/axis_sip_model.dart';
import '../repository/sip_repository.dart';
import '../utils/string_constants.dart';
import '../widgets/constant_widgets.dart';

class SipController extends GetxController {
 SipRepository sipRepository = SipRepository(APIManager());


  TextEditingController nameTxtController = TextEditingController();
  TextEditingController panCardTxtController = TextEditingController();
  TextEditingController mobileNoTxtController = TextEditingController();
  TextEditingController sipUrlLinkTxtController = TextEditingController();

 Future<bool> axisSipApi({bool isLoaderShow = true}) async {
  try {
    AxisSipModel axisSipModel = await sipRepository.axisSipApiCall(
    params: {
     "name": nameTxtController.text.trim(),
     "mobileNo": mobileNoTxtController.text.trim(),
     "pan": panCardTxtController.text.trim(),
     "channel": 2,
     "tpin": "",
     "orderId": "App${DateTime.now().millisecondsSinceEpoch.toString()}",
     "latitude": latitude,
     "longitude": longitude
    },
    isLoaderShow: isLoaderShow);
   if (axisSipModel.statusCode == 1) {
    sipUrlLinkTxtController.text = axisSipModel.redirectUrl!;
    return true;
   } else {
    errorSnackBar(message: axisSipModel.message);
    dismissProgressIndicator();
    return false;
   }
  } catch (e) {
   dismissProgressIndicator();
   return false;
  }
 }
}
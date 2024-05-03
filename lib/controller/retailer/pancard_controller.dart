import 'package:get/get.dart';
import '../../api/api_manager.dart';
import '../../model/pancard/pancard_model.dart';
import '../../repository/retailer/pancard_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class PancardController extends GetxController {
  PancardRepository pancardRepository = PancardRepository(APIManager());

  // Pancard api
  Rx<PancardModel> pancardModel = PancardModel().obs;
  RxBool isPancardSiteLoad = false.obs;
  Future<bool> pancardAPI({bool isLoaderShow = true}) async {
    try {
      pancardModel.value = await pancardRepository.pancardApiCall(
        params: {
          'tpin': null,
          'channel': channelID,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (pancardModel.value.statusCode == 1) {
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

import 'package:get/get.dart';
import '../../api/api_manager.dart';
import '../../model/cms/cms_model.dart';
import '../../repository/retailer/cms_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class CmsController extends GetxController {
  CmsRepository cmsRepository = CmsRepository(APIManager());

  // Cms api
  Rx<CmsModel> cmsModel = CmsModel().obs;
  RxBool isCmsSiteLoad = false.obs;
  Future<bool> cmsAPI({bool isLoaderShow = true}) async {
    try {
      cmsModel.value = await cmsRepository.cmsApiCall(
        params: {
          'cmsType': 'FINO',
          'tpin': null,
          'channel': channelID,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (cmsModel.value.statusCode == 1) {
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

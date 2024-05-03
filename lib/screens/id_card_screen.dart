import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controller/setting_controller.dart';
import '../generated/assets.dart';
import '../utils/string_constants.dart';
import '../widgets/constant_widgets.dart';
import '../widgets/custom_scaffold.dart';

class IdCardScreen extends StatefulWidget {
  const IdCardScreen({super.key});

  @override
  State<IdCardScreen> createState() => _IdCardScreenState();
}

class _IdCardScreenState extends State<IdCardScreen> {
  SettingController settingController = Get.find();
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      dynamic profilePath;
      if (getStoredUserBasicDetails().profileImage != null && getStoredUserBasicDetails().profileImage!.isNotEmpty) {
        profilePath = getStoredUserBasicDetails().profileImage!;
      } else {
        profilePath = Assets.imagesProfile;
      }
      bool result = await settingController.getIdCard(isLoaderShow: false);
      if (result == true && settingController.idCard.value.isNotEmpty && settingController.idCard.value != '') {
        webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                if (progress == 100) {
                  dismissProgressIndicator();
                }
              },
            ),
          )
          ..loadHtmlString(
            settingController.idCardModel.value.htmlBody!
                .replaceAll('#img', profilePath)
                .replaceAll('#name', getStoredUserBasicDetails().ownerName.toString())
                .replaceAll('#username', getStoredUserBasicDetails().userName.toString())
                .replaceAll('#userType', getStoredUserBasicDetails().userType.toString())
                .replaceAll('#mobile', getStoredUserBasicDetails().mobile.toString())
                .replaceAll('#email', getStoredUserBasicDetails().email.toString()),
          );
        settingController.isIdCardLoad.value = true;
      } else {
        settingController.isIdCardLoad.value = false;
        dismissProgressIndicator();
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Id Card',
      isShowLeadingIcon: true,
      mainBody: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Obx(
          () => settingController.isIdCardLoad.value
              ? WebViewWidget(
                  controller: webViewController,
                )
              : Container(),
        ),
      ),
    );
  }
}

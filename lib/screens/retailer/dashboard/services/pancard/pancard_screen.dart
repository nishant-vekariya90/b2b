import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/retailer/pancard_controller.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PancardScreen extends StatefulWidget {
  const PancardScreen({super.key});

  @override
  State<PancardScreen> createState() => _PancardScreenState();
}

class _PancardScreenState extends State<PancardScreen> {
  final PancardController pancardController = Get.find();
  final GlobalKey webViewKey = GlobalKey();
  late WebViewController webViewController;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      bool result = await pancardController.pancardAPI(isLoaderShow: false);
      if (result == true && pancardController.pancardModel.value.requestForm != null && pancardController.pancardModel.value.requestForm!.isNotEmpty) {
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
          ..loadHtmlString(pancardController.pancardModel.value.requestForm!);
        pancardController.isPancardSiteLoad.value = true;
      } else {
        pancardController.isPancardSiteLoad.value = false;
        dismissProgressIndicator();
        Get.back();
        errorSnackBar(message: pancardController.pancardModel.value.message!);
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Pancard',
      isShowLeadingIcon: true,
      mainBody: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Obx(
          () => pancardController.isPancardSiteLoad.value
              ? WebViewWidget(
                  controller: webViewController,
                )
              : Container(),
        ),
      ),
    );
  }
}

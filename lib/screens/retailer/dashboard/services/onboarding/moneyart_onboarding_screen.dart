import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MoneyartOnboardingScreen extends StatefulWidget {
  const MoneyartOnboardingScreen({super.key});

  @override
  State<MoneyartOnboardingScreen> createState() => _MoneyartOnboardingScreenState();
}

class _MoneyartOnboardingScreenState extends State<MoneyartOnboardingScreen> {
  final GlobalKey webViewKey = GlobalKey();
  late WebViewController webViewController;
  String url = Get.arguments[0];
  String message = Get.arguments[1];
  RxBool isSiteLoad = false.obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      if (url.isNotEmpty && url != '') {
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
          ..loadHtmlString(url);
        isSiteLoad.value = true;
      } else {
        isSiteLoad.value = false;
        dismissProgressIndicator();
        Get.back();
        errorSnackBar(message: message);
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Onboarding',
      isShowLeadingIcon: true,
      mainBody: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Obx(
          () => isSiteLoad.value
              ? WebViewWidget(
                  controller: webViewController,
                )
              : Container(),
        ),
      ),
    );
  }
}

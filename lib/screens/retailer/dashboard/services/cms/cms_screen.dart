import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/retailer/cms_controller.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CmsScreen extends StatefulWidget {
  const CmsScreen({super.key});

  @override
  State<CmsScreen> createState() => _CmsScreenState();
}

class _CmsScreenState extends State<CmsScreen> {
  final CmsController cmsController = Get.find();
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
      bool result = await cmsController.cmsAPI(isLoaderShow: false);
      if (result == true && cmsController.cmsModel.value.redirectUrl != null && cmsController.cmsModel.value.redirectUrl!.isNotEmpty) {
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
          ..loadRequest(Uri.parse(cmsController.cmsModel.value.redirectUrl!));
        cmsController.isCmsSiteLoad.value = true;
      } else {
        cmsController.isCmsSiteLoad.value = false;
        dismissProgressIndicator();
        errorSnackBar(message: cmsController.cmsModel.value.message!);
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CustomScaffold(
        title: 'CMS',
        isShowLeadingIcon: true,
        mainBody: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Obx(
            () => cmsController.isCmsSiteLoad.value
                ? WebViewWidget(
                    controller: webViewController,
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}

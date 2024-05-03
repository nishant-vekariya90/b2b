import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../controller/setting_controller.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/text_styles.dart';
import '../../../../widgets/constant_widgets.dart';
import '../../../../widgets/custom_scaffold.dart';

class WebsiteContentScreen extends StatefulWidget {
  const WebsiteContentScreen({super.key});

  @override
  State<WebsiteContentScreen> createState() => _WebsiteContentScreenState();
}

class _WebsiteContentScreenState extends State<WebsiteContentScreen> {
  final SettingController settingController = SettingController();
  final String title = Get.arguments;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      if (title == 'Privacy Policy') {
        await settingController.getWebsiteContent(contentType: 1);
      } else if (title == 'Terms and Conditions') {
        await settingController.getWebsiteContent(contentType: 2);
      }
      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: title,
      isShowLeadingIcon: true,
      mainBody: ClipRRect(
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(20),
          right: Radius.circular(20),
        ),
        child: Obx(
          () => settingController.websiteContentModel.value.value != null && settingController.websiteContentModel.value.value!.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Html(
                      data: settingController.websiteContentModel.value.value ?? '-',
                      style: {
                        "p": Style(
                          fontFamily: regularGoogleSansFont,
                          color: ColorsForApp.lightBlackColor,
                          fontSize: FontSize(13),
                        ),
                        "ul": Style(
                          fontFamily: regularGoogleSansFont,
                          color: ColorsForApp.lightBlackColor.withOpacity(0.8),
                          fontSize: FontSize(13),
                          wordSpacing: 1,
                        ),
                        "li": Style(
                          fontFamily: regularGoogleSansFont,
                          color: ColorsForApp.lightBlackColor.withOpacity(0.8),
                          fontSize: FontSize(13),
                          wordSpacing: 1,
                        ),
                      },
                    ),
                  ),
                )
              : notFoundText(
                  text: 'Not found',
                ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../generated/assets.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import 'button.dart';
import 'constant_widgets.dart';

class CustomScaffold extends StatelessWidget {
  final String appBarBgImage;
  final bool? isShowLeadingIcon;
  final Color? leadingIconColor;
  final void Function()? onBackIconTap;
  final String title;
  final TextStyle? appBarTextStyle;
  final bool? isShowExtraTitle;
  final Widget? extraTitle;
  final Widget? floatingActionButton;
  final List<Widget>? action;
  final Widget mainBody;
  final double? appBarHeight;
  final Widget? topCenterWidget;
  final Widget? bottomNavigationBar;

  const CustomScaffold({
    super.key,
    this.appBarBgImage = Assets.imagesAppBarBgImage,
    this.isShowLeadingIcon = false,
    this.leadingIconColor,
    this.onBackIconTap,
    this.isShowExtraTitle = false,
    this.extraTitle,
    this.floatingActionButton,
    required this.title,
    this.appBarTextStyle,
    this.action,
    required this.mainBody,
    this.appBarHeight,
    this.topCenterWidget,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    double tempAppBarHeight = AppBar().preferredSize.height + MediaQuery.of(context).padding.top + kToolbarHeight;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Stack(
        children: [
          // Appbar background image
          Container(
            height: topCenterWidget != null ? tempAppBarHeight + (appBarHeight ?? 10.h) : tempAppBarHeight,
            width: 100.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  appBarBgImage,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main appbar, body
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: isShowLeadingIcon == true
                    ? InkWell(
                        onTap: onBackIconTap ??
                            () {
                              Get.back();
                            },
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: leadingIconColor ?? ColorsForApp.lightBlackColor,
                        ),
                      )
                    : null,
                centerTitle: true,
                title: isShowExtraTitle == true
                    ? Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              title,
                              style: appBarTextStyle ??
                                  TextHelper.size18.copyWith(
                                    color: ColorsForApp.lightBlackColor,
                                    fontFamily: mediumGoogleSansFont,
                                  ),
                            ),
                          ),
                          height(3),
                          extraTitle!,
                        ],
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          title,
                          style: appBarTextStyle ??
                              TextHelper.size18.copyWith(
                                color: ColorsForApp.lightBlackColor,
                                fontFamily: mediumGoogleSansFont,
                              ),
                        ),
                      ),
                actions: action ?? [],
                bottom: topCenterWidget != null
                    ? PreferredSize(
                        preferredSize: Size.fromHeight((appBarHeight ?? 10.h) + 2.h),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 1.5.h),
                          child: topCenterWidget,
                        ),
                      )
                    : null,
              ),
              body: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: mainBody,
                ),
              ),
              floatingActionButton: floatingActionButton,
              bottomNavigationBar: bottomNavigationBar,
            ),
          ),
        ],
      ),
    );
  }
}

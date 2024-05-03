import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/gift_card_b_controller.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../model/gift_card_b/bank_sathi_category_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';

class GiftCardBVerifyScreen extends StatefulWidget {
  const GiftCardBVerifyScreen({super.key});

  @override
  State<GiftCardBVerifyScreen> createState() => _GiftCardBVerifyScreenState();
}

class _GiftCardBVerifyScreenState extends State<GiftCardBVerifyScreen> {
  final GiftCardBController giftCardBController = Get.find();
  final GlobalKey<FormState> validateFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await giftCardBController.getCategoryListApi(isLoaderShow: true);
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CustomScaffold(
          title: 'Select Categories',
          isShowLeadingIcon: true,
          appBarHeight: 11.h,
          topCenterWidget: Container(
            height: 11.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              border: Border.all(
                color: ColorsForApp.lightGreyColor,
              ),
            ),
            child: Lottie.asset(Assets.animationsBankSathiAnimation),
          ),
          mainBody: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                height(3.h),
                // Category
                Expanded(
                  child: giftCardBController.categoryList.isNotEmpty ? categoryGridView(context) : notFoundText(text: 'No data found'),
                ),
              ],
            ),
          )),
    );
  }

  Widget categoryGridView(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.5, crossAxisSpacing: 15, mainAxisSpacing: 15),
        itemCount: giftCardBController.categoryList.length,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        itemBuilder: (context, index) {
          BKCategoryListModel giftCardData = giftCardBController.categoryList[index];
          return Container(
            decoration: BoxDecoration(
              color: ColorsForApp.whiteColor,
              border: Border.all(
                color: ColorsForApp.primaryColor.withOpacity(0.3),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            ),
            child: InkWell(
              onTap: () async {
                giftCardBController.selectedCategoryId.value = giftCardData.id!;
                giftCardBController.categoryTxtController.text = giftCardData.title!;
                Get.toNamed(Routes.ELIGIBLE_PRODUCT_lIST_SCREEN);
                // Commented for now it may be used in future
                // int result = await giftCardBController.verifyGiftCardBUserApi();
                // if (result == 1) {
                //   // user is verified show all products list
                //   Get.toNamed(Routes.ELIGIBLE_PRODUCT_lIST_SCREEN);
                // } else if (result == 5) {
                //   // user is unverified open onboarding screen
                //   Get.toNamed(Routes.GIFTCARD_B_ONBORDING_SCREEN);
                // }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.5.w,
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                  Image.asset(
                    giftCardData.logo!,
                    height: 28,
                    width: 28,
                  ),
                  height(1.h),
                  Text(
                    giftCardData.title!,
                    style: TextHelper.size15.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  )
                ]),
              ),
            ),
          );
        });
  }
}

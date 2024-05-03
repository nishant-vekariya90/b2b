import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/gift_card_b_controller.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../model/gift_card_b/bank_account_product_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/network_image.dart';

class EligibleProductListScreen extends StatefulWidget {
  const EligibleProductListScreen({super.key});

  @override
  State<EligibleProductListScreen> createState() => _EligibleProductListScreenState();
}

class _EligibleProductListScreenState extends State<EligibleProductListScreen> {
  final GiftCardBController giftCardBController = Get.find();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      // // fetch bank accounts products
      // if(giftCardBController.selectedCategoryId.value == 13){
      //   await giftCardBController.getBankAccountProductListApi();
      // }
      // // fetch credit cards products
      // else if(giftCardBController.selectedCategoryId.value == 3){
      //   await giftCardBController.getCreditCardProductListApi();
      // }
      // // fetch personal loan products
      // else if(giftCardBController.selectedCategoryId.value == 4){
      //   await giftCardBController.getPersonalLoanProductListApi();
      // }else {
      //   // fetch others products
      //   await giftCardBController.getOtherProductListApi();
      // }
      await giftCardBController.getOtherProductListApi();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    giftCardBController.resetAllEligibleProductPageVariable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 5.h,
      title: giftCardBController.categoryTxtController.text,
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        child: searchBar(context),
      ),
      mainBody: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Obx(
          () => Column(children: [
            height(1.h),
            // Gift cards list view
            Expanded(
              child: giftCardBController.filteredEligibleProductList.isNotEmpty ? giftCardsListView(context) : notFoundWithAnimationText(text: 'No data found'),
            ),
            height(1.h),
          ]),
        ),
      ),
    );
  }

  Widget searchBar(BuildContext context) {
    return SizedBox(
        height: 6.h,
        child: TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            focusColor: ColorsForApp.primaryColor,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: ColorsForApp.lightGreyColor),
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: ColorsForApp.lightGreyColor),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5, color: ColorsForApp.lightGreyColor),
              borderRadius: BorderRadius.circular(12),
            ),
            hintText: 'Search here...',
            hintStyle: TextHelper.size13.copyWith(
              fontWeight: FontWeight.w400,
              color: ColorsForApp.grayScale500,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          onChanged: (value) {
            giftCardBController.searchInProductList(value);
          },
        ));
  }

  Widget giftCardsListView(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
        ),
        itemCount: giftCardBController.filteredEligibleProductList.length,
        itemBuilder: (context, index) {
          EligibleProductList giftCardData = giftCardBController.filteredEligibleProductList[index];
          return customCard(
            shadowColor: ColorsForApp.accentColor,
            child: InkWell(
              onTap: () {
                // fetch credit card details
                // if (giftCardBController.selectedCategoryId.value == 3) {
                //   giftCardBController.selectedProductId.value = giftCardData.productId!;
                //   giftCardBController.selectedCardId.value = giftCardData.cardId!;
                //   Get.toNamed(Routes.ELIGIBLE_PRODUCT_DETAILS_SCREEN);
                // } else {
                //   // fetch other product details
                //   giftCardBController.selectedProductId.value = giftCardData.productId!;
                //   Get.toNamed(Routes.ELIGIBLE_PRODUCT_DETAILS_SCREEN);
                // }

                giftCardBController.selectedProductId.value = giftCardData.productId!;
                giftCardBController.selectedProductName.value = giftCardData.title!;
                Get.toNamed(Routes.ELIGIBLE_PRODUCT_DETAILS_SCREEN);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                child: Stack(
                  children: [
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      Expanded(
                        child: ShowNetworkImage(
                          networkUrl: giftCardData.logo != null && giftCardData.logo!.isNotEmpty ? giftCardData.logo! : '',
                          defaultImagePath: Assets.imagesImageNotAvailable,
                          isShowBorder: false,
                          fit: BoxFit.contain,
                          boxShape: BoxShape.rectangle,
                        ),
                      ),
                      height(1.h),
                      Text(
                        giftCardData.title!,
                        style: TextHelper.size15.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.primaryColor,
                        ),
                      )
                    ])
                  ],
                ),
              ),
            ),
          );
        });
  }
}

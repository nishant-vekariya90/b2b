import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/gift_card_controller.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../model/gift_card/gift_cards_list_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/network_image.dart';

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({super.key});

  @override
  State<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends State<GiftCardScreen> {
  final GiftCardController giftCardController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await giftCardController.getGiftCardsListApi(
        pageNumber: giftCardController.currentPage.value,
      );
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels && giftCardController.currentPage.value < giftCardController.totalPages.value) {
          giftCardController.currentPage.value++;
          await giftCardController.getGiftCardsListApi(
            pageNumber: giftCardController.currentPage.value,
            isLoaderShow: false,
          );
        }
      });
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    giftCardController.resetAllGiftCardVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Get.previousRoute == "/giftcard_onbording_screen") {
          Get.back();
        } else {
          Get.back();
        }
        return true;
      },
      child: Scaffold(
          backgroundColor: ColorsForApp.whiteColor,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                if (Get.previousRoute == "/giftcard_onbording_screen") {
                  Get.back();
                } else {
                  Get.back();
                }
              },
              icon: const Icon(Icons.arrow_back_outlined),
            ),
            iconTheme: IconThemeData(color: ColorsForApp.primaryColor),
            centerTitle: false,
            title: Text(
              'Gift Card',
              style: TextHelper.size18.copyWith(color: ColorsForApp.primaryColor, fontWeight: FontWeight.bold, fontFamily: boldGoogleSansFont),
            ), // Padding
          ),
          body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Obx(() => Column(children: [
                    searchBar(context),
                    height(1.h),
                    // Gift cards list view
                    Expanded(
                      child: giftCardController.filteredGiftCardsList.isNotEmpty ? giftCardsListView(context) : notFoundWithAnimationText(text: ''),
                    ),
                    height(1.h),
                  ])))),
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
            hintText: 'Search gift cards here...',
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
          ),
          onChanged: (value) {
            giftCardController.searchInGiftCardList(value);
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
        itemCount: giftCardController.filteredGiftCardsList.length + 1,
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index == giftCardController.filteredGiftCardsList.length) {
            // Show loader when reaching the end
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Center(
                child: CircularProgressIndicator(
                  color: ColorsForApp.primaryColor,
                ),
              ),
            );
          } else {
            GiftCardsListModel giftCardData = giftCardController.filteredGiftCardsList[index];
            return customCard(
              child: InkWell(
                onTap: () {
                  giftCardController.selectedGiftCardId.value = giftCardData.id.toString();
                  Get.toNamed(Routes.GIFTCARD_DETAIL_SCREEN);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                  child: Stack(
                    children: [
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        Expanded(
                          child: ShowNetworkImage(
                            networkUrl: giftCardData.image!.isNotEmpty ? giftCardData.image! : '',
                            defaultImagePath: Assets.imagesImageNotAvailable,
                            isShowBorder: false,
                            fit: BoxFit.contain,
                            boxShape: BoxShape.rectangle,
                          ),
                        ),
                        height(1.h),
                        Text(
                          giftCardData.brand!,
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
          }
        });
  }
}

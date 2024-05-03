import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/bbps_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/bbps/bbps_category_list_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/network_image.dart';
import '../../../../../widgets/text_field.dart';

class BbpsCategoryScreen extends StatefulWidget {
  const BbpsCategoryScreen({super.key});

  @override
  State<BbpsCategoryScreen> createState() => _BbpsCategoryScreenState();
}

class _BbpsCategoryScreenState extends State<BbpsCategoryScreen> {
  BbpsController bbpsController = Get.find();
  RxList searchedList = [].obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await bbpsController.getBbpsCategoryList();
      searchedList.assignAll(bbpsController.bbpsCategoryList);
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  searchFromList(String value) async {
    searchedList.clear();
    if (value.isEmpty) {
      searchedList.assignAll(bbpsController.bbpsCategoryList);
    } else {
      List<BbpsCategoryListModel> tempList = bbpsController.bbpsCategoryList.where((element) {
        return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
      }).toList();
      searchedList.assignAll(tempList);
    }
  }

  @override
  void dispose() {
    bbpsController.bbpsCategoryList.clear();
    bbpsController.bbpsSearchCategoryController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 17.5.h,
      title: 'BBPS',
      isShowLeadingIcon: true,
      topCenterWidget: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 10.h,
            width: 100.w,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: BoxDecoration(
              color: ColorsForApp.whiteColor,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage(Assets.imagesTopCardBgStart),
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(2.w),
                  child: const ShowNetworkImage(
                    networkUrl: Assets.imagesBbpsIcon,
                    isAssetImage: true,
                  ),
                ),
                width(2.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bill Payment',
                        style: TextHelper.size14.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
                      height(0.5.h),
                      Text(
                        'Simplify Payments, \nAmplify Peace of Mind.',
                        maxLines: 3,
                        style: TextHelper.size12.copyWith(
                          color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          height(1.h),
          // Search text field
          SizedBox(
            height: 6.5.h,
            width: 100.w,
            child: Card(
              color: ColorsForApp.whiteColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              child: CustomTextField(
                controller: bbpsController.bbpsSearchCategoryController,
                style: TextHelper.size14.copyWith(
                  fontFamily: mediumGoogleSansFont,
                ),
                hintText: 'Search here...',
                suffixIcon: Icon(
                  Icons.search,
                  color: ColorsForApp.lightBlackColor,
                ),
                hintTextColor: ColorsForApp.lightBlackColor.withOpacity(0.6),
                focusedBorderColor: ColorsForApp.grayScale500,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                onChange: (value) {
                  searchFromList(value);
                },
              ),
            ),
          ),
        ],
      ),
      mainBody: Column(
        children: [
          height(2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              width(4.w),
              Image.asset(
                Assets.imagesBbpsIcon,
                width: 26,
                height: 26,
              ),
              width(2.w),
              Text(
                'Categories',
                style: TextHelper.size16.copyWith(
                  fontFamily: boldGoogleSansFont,
                  color: ColorsForApp.primaryColor,
                ),
              ),
            ],
          ),
          height(2.h),
          Obx(
            () => Expanded(
              child: searchedList.isEmpty
                  ? notFoundText(text: 'No category found')
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: searchedList.length,
                      itemBuilder: (context, index) {
                        BbpsCategoryListModel bbpsCategoryData = searchedList[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                await Get.toNamed(
                                  Routes.BBPS_SUB_CATEGORY_SCREEN,
                                  arguments: bbpsCategoryData,
                                );
                                bbpsController.bbpsSearchCategoryController.clear();
                                searchedList.assignAll(bbpsController.bbpsCategoryList);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorsForApp.primaryShadeColor,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 8.w,
                                      width: 8.w,
                                      child: ShowNetworkImage(
                                        networkUrl: bbpsCategoryData.fileUrl != null && bbpsCategoryData.fileUrl!.isNotEmpty ? bbpsCategoryData.fileUrl! : '',
                                        defaultImagePath: Assets.imagesBbpsIcon,
                                        isShowBorder: false,
                                        fit: BoxFit.contain,
                                        boxShape: BoxShape.rectangle,
                                      ),
                                    ),
                                    width(3.w),
                                    Flexible(
                                      child: Text(
                                        bbpsCategoryData.name != null && bbpsCategoryData.name!.isNotEmpty ? bbpsCategoryData.name! : '-',
                                        style: TextHelper.size14.copyWith(
                                          fontFamily: mediumGoogleSansFont,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            index == searchedList.length - 1 ? height(2.h) : const SizedBox(),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return height(1.h);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

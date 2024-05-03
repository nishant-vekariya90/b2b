import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/bbps_o_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/bbps/bbps_category_list_model.dart';
import '../../../../../model/bbps/bbps_sub_category_list_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/network_image.dart';
import '../../../../../widgets/text_field.dart';

class BbpsOSubCategoryScreen extends StatefulWidget {
  const BbpsOSubCategoryScreen({super.key});

  @override
  State<BbpsOSubCategoryScreen> createState() => _BbpsOSubCategoryScreenState();
}

class _BbpsOSubCategoryScreenState extends State<BbpsOSubCategoryScreen> {
  BbpsOController bbpsOController = Get.find();
  RxList searchedList = [].obs;
  BbpsCategoryListModel selectedBbpsOCategory = Get.arguments;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await bbpsOController.getBbpsSubCategoryList(serviceId: selectedBbpsOCategory.id!);
      searchedList.assignAll(bbpsOController.bbpsSubCategoryList);
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  searchFromList(String value) async {
    searchedList.clear();
    if (value.isEmpty) {
      searchedList.assignAll(bbpsOController.bbpsSubCategoryList);
    } else {
      List<BbpsSubCategoryListModel> tempList = bbpsOController.bbpsSubCategoryList.where((element) {
        return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
      }).toList();
      searchedList.assignAll(tempList);
    }
  }

  @override
  void dispose() {
    bbpsOController.bbpsSubCategoryList.clear();
    bbpsOController.bbpsSearchSubCategoryController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 6.5.h,
      title: selectedBbpsOCategory.name != null && selectedBbpsOCategory.name!.isNotEmpty ? selectedBbpsOCategory.name!.toString() : '-',
      isShowLeadingIcon: true,
      topCenterWidget: SizedBox(
        height: 6.5.h,
        width: 100.w,
        child: Card(
          color: ColorsForApp.whiteColor,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          child: CustomTextField(
            controller: bbpsOController.bbpsSearchSubCategoryController,
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
                'Sub Categories',
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
                  ? notFoundText(text: 'No sub category found')
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: searchedList.length,
                      itemBuilder: (context, index) {
                        BbpsSubCategoryListModel bbpsOSubCategoryData = searchedList[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                FocusScope.of(context).unfocus();
                                await Get.toNamed(
                                  Routes.BBPS_O_FETCH_BILL_SCREEN,
                                  arguments: bbpsOSubCategoryData,
                                );
                                bbpsOController.bbpsSearchSubCategoryController.clear();
                                searchedList.assignAll(bbpsOController.bbpsSubCategoryList);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorsForApp.primaryShadeColor,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 8.w,
                                      width: 8.w,
                                      child: ShowNetworkImage(
                                        networkUrl: bbpsOSubCategoryData.fileUrl != null && bbpsOSubCategoryData.fileUrl!.isNotEmpty ? bbpsOSubCategoryData.fileUrl! : '',
                                        defaultImagePath: Assets.imagesBbpsIcon,
                                        isShowBorder: false,
                                        fit: BoxFit.contain,
                                        boxShape: BoxShape.rectangle,
                                      ),
                                    ),
                                    width(3.w),
                                    Flexible(
                                      child: Text(
                                        bbpsOSubCategoryData.name != null && bbpsOSubCategoryData.name!.isNotEmpty ? bbpsOSubCategoryData.name! : '-',
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

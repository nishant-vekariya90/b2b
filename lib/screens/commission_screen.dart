import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controller/commission_controller.dart';
import '../generated/assets.dart';
import '../model/commission/commission_model.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../widgets/button.dart';
import '../widgets/constant_widgets.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/network_image.dart';
import '../widgets/text_field.dart';

class CommissionScreen extends StatefulWidget {
  const CommissionScreen({super.key});

  @override
  State<CommissionScreen> createState() => _CommissionScreenState();
}

class _CommissionScreenState extends State<CommissionScreen> {
  final CommissionController commissionController = Get.find();
  ScrollController scrollController = ScrollController();
  RxList searchedList = [].obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await commissionController.getCommission(pageNumber: 1);
      searchedList.assignAll(commissionController.commissionList);
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels && commissionController.currentPage.value < commissionController.totalPages.value) {
          commissionController.currentPage.value++;
          await commissionController.getCommission(
            searchOperatorName: commissionController.searchController.text.isNotEmpty ? commissionController.searchController.text : null,
            pageNumber: commissionController.currentPage.value,
            isLoaderShow: false,
          );
          searchedList.assignAll(commissionController.commissionList);
        }
      });
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  searchFromList(String value) async {
    searchedList.clear();
    if (value.isEmpty) {
      await commissionController.getCommission(pageNumber: 1, isLoaderShow: false);
      searchedList.assignAll(commissionController.commissionList);
    } else {
      await commissionController.getCommission(
        searchOperatorName: value,
        pageNumber: 1,
        isLoaderShow: false,
      );
      searchedList.assignAll(commissionController.commissionList);

      // List<CommissionModelList> tempList = commissionController.commissionList.where((element) {
      //   return element.operatorName?.toLowerCase().contains(value.toLowerCase()) ?? false;
      // }).toList();
      // searchedList.assignAll(tempList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 6.5.h,
      title: 'Commission',
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
          child:
          CustomTextField(
            controller: commissionController.searchController,
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
      mainBody: Obx(
        () => searchedList.isEmpty
            ? notFoundText(text: 'No commission found')
            : RefreshIndicator(
                color: ColorsForApp.primaryColor,
                onRefresh: () async {
                  isLoading.value = true;
                  await Future.delayed(const Duration(seconds: 1), () async {
                    await commissionController.getCommission(pageNumber: 1, isLoaderShow: false);
                    commissionController.searchController.clear();
                    searchedList.assignAll(commissionController.commissionList);
                  });
                  isLoading.value = false;
                },
                child: ListView.separated(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(2.w),
                  itemCount: searchedList.length,
                  itemBuilder: (context, index) {
                    if (index == searchedList.length - 1 && commissionController.hasNext.value) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                      );
                    } else {
                      CommissionModelList commissionModel = searchedList[index];
                      return customCard(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Image with title
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  width(1.w),
                                  SizedBox(
                                    height: 13.w,
                                    width: 13.w,
                                    child: ShowNetworkImage(
                                      networkUrl: commissionModel.fileUrl != null && commissionModel.fileUrl!.isNotEmpty ? commissionModel.fileUrl! : '-',
                                      defaultImagePath: Assets.imagesJio,
                                    ),
                                  ),
                                  width(4.w),
                                  Flexible(
                                    child: Text(
                                      commissionModel.operatorName != null && commissionModel.operatorName!.isNotEmpty ? commissionModel.operatorName! : '-',
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                      style: TextHelper.size15.copyWith(
                                        fontFamily: boldGoogleSansFont,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              height(1.h),
                              Divider(
                                color: ColorsForApp.lightBlackColor,
                                height: 0,
                              ),
                              height(1.h),
                              // Commission & Surcharge
                              SizedBox(
                                height: 10.h,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Commission
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Charge',
                                            textAlign: TextAlign.center,
                                            style: TextHelper.size13.copyWith(
                                              fontFamily: regularGoogleSansFont,
                                            ),
                                          ),
                                          height(1.h),
                                          SizedBox(
                                            height: 5.h,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '%',
                                                        style: TextHelper.size12.copyWith(
                                                          color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                                                        ),
                                                      ),
                                                      Text(
                                                        commissionModel.chargePer != null ? commissionModel.chargePer!.toStringAsFixed(2) : '0.00',
                                                        style: TextHelper.size13,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  color: ColorsForApp.grayScale500,
                                                  thickness: 1,
                                                  width: 1,
                                                  indent: 2,
                                                  endIndent: 2,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '₹',
                                                        style: TextHelper.size12.copyWith(
                                                          color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                                                        ),
                                                      ),
                                                      Text(
                                                        commissionModel.chargeVal != null ? commissionModel.chargeVal!.toStringAsFixed(2) : '0.00',
                                                        style: TextHelper.size13,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(
                                      color: ColorsForApp.grayScale500,
                                      thickness: 1,
                                      width: 1,
                                      indent: 2,
                                    ),
                                    // Surcharge
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Commission',
                                            textAlign: TextAlign.center,
                                            style: TextHelper.size13.copyWith(
                                              fontFamily: regularGoogleSansFont,
                                            ),
                                          ),
                                          height(5),
                                          SizedBox(
                                            height: 5.h,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '%',
                                                        style: TextHelper.size12.copyWith(
                                                          color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                                                        ),
                                                      ),
                                                      Text(
                                                        commissionModel.commPer != null ? commissionModel.commPer!.toStringAsFixed(2) : '0.00',
                                                        style: TextHelper.size13,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                VerticalDivider(
                                                  color: ColorsForApp.grayScale500,
                                                  thickness: 1,
                                                  width: 1,
                                                  indent: 2,
                                                  endIndent: 2,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '₹',
                                                        style: TextHelper.size12.copyWith(
                                                          color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                                                        ),
                                                      ),
                                                      Text(
                                                        commissionModel.commVal != null ? commissionModel.commVal!.toStringAsFixed(2) : '0.00',
                                                        style: TextHelper.size13,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return height(0.4.h);
                  },
                ),
              ),
      ),
    );
  }
}

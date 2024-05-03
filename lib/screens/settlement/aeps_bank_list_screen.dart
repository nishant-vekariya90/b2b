import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../controller/retailer/aeps_settlement_controller.dart';
import '../../generated/assets.dart';
import '../../model/aeps_settlement/aeps_bank_list_model.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/network_image.dart';

class AepsBankListScreen extends StatefulWidget {
  const AepsBankListScreen({super.key});

  @override
  State<AepsBankListScreen> createState() => _AepsBankListScreenState();
}

class _AepsBankListScreenState extends State<AepsBankListScreen> {
  final AepsSettlementController aepsSettlementController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels && aepsSettlementController.currentPage.value < aepsSettlementController.totalPages.value) {
          aepsSettlementController.currentPage.value++;
          await aepsSettlementController.getAepsBankList(
            pageNumber: aepsSettlementController.currentPage.value,
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
    aepsSettlementController.selectedTabIndex.value = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'View Bank/UPI',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        height: 7.h,
        padding: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: ColorsForApp.stepBgColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Token request
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (aepsSettlementController.selectedTabIndex.value != 0) {
                      aepsSettlementController.selectedTabIndex.value = 0;
                    }
                  },
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: aepsSettlementController.selectedTabIndex.value == 0 ? ColorsForApp.whiteColor : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Bank List',
                      style: TextHelper.size15.copyWith(
                        fontFamily: aepsSettlementController.selectedTabIndex.value == 0 ? mediumGoogleSansFont : regularGoogleSansFont,
                        color: aepsSettlementController.selectedTabIndex.value == 0 ? ColorsForApp.primaryColor : ColorsForApp.blackColor,
                      ),
                    ),
                  ),
                ),
              ),
              // Credentials
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (aepsSettlementController.selectedTabIndex.value != 1) {
                      aepsSettlementController.selectedTabIndex.value = 1;
                    }
                  },
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: aepsSettlementController.selectedTabIndex.value == 1 ? ColorsForApp.whiteColor : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'UPI List',
                      style: TextHelper.size15.copyWith(
                        fontFamily: aepsSettlementController.selectedTabIndex.value == 1 ? mediumGoogleSansFont : regularGoogleSansFont,
                        color: aepsSettlementController.selectedTabIndex.value == 1 ? ColorsForApp.primaryColor : ColorsForApp.blackColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      mainBody: Obx(
        () => aepsSettlementController.selectedTabIndex.value == 0
            // Bank list
            ? aepsSettlementController.allAepsBankList.isEmpty
                ? notFoundText(text: 'No bank found')
                : RefreshIndicator(
                    color: ColorsForApp.primaryColor,
                    onRefresh: () async {
                      isLoading.value = true;
                      await Future.delayed(const Duration(seconds: 1), () async {
                        await aepsSettlementController.getAepsBankList(pageNumber: 1, isLoaderShow: false);
                      });
                      isLoading.value = false;
                    },
                    child: ListView.separated(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                      itemCount: aepsSettlementController.allAepsBankList.length,
                      itemBuilder: (context, index) {
                        if (index == aepsSettlementController.allAepsBankList.length - 1 && aepsSettlementController.hasNext.value) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorsForApp.primaryColor,
                            ),
                          );
                        } else {
                          AepsBankListModel aepsBankListModel = aepsSettlementController.allAepsBankList[index];
                          return GestureDetector(
                            onTap:(){
                              if(aepsBankListModel.status == 0){
                                Get.toNamed(Routes.AEPS_ADD_BANK_SCREEN,arguments: aepsBankListModel);
                              }
                            },
                            child: customCard(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Bank :',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: mediumGoogleSansFont,
                                                  color: ColorsForApp.blackColor,
                                                ),
                                              ),
                                              width(5),
                                              Flexible(
                                                child: Text(
                                                  aepsBankListModel.bankName != null && aepsBankListModel.bankName!.isNotEmpty ? aepsBankListModel.bankName! : '-',
                                                  textAlign: TextAlign.justify,
                                                  style: TextHelper.size13.copyWith(
                                                    fontFamily: mediumGoogleSansFont,
                                                    color: ColorsForApp.blackColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        width(2.w),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: aepsBankListModel.status == 0
                                                  ? ColorsForApp.chilliRedColor
                                                  : aepsBankListModel.status == 1
                                                      ? ColorsForApp.successColor
                                                      : ColorsForApp.orangeColor,
                                              width: 0.2,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            child: Text(
                                              aepsSettlementController.ticketStatus(aepsBankListModel.status!),
                                              style: TextHelper.size13.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                                color: aepsBankListModel.status == 0
                                                    ? ColorsForApp.chilliRedColor
                                                    : aepsBankListModel.status == 1
                                                        ? ColorsForApp.successColor
                                                        : ColorsForApp.orangeColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        width(2.w),
                                        aepsBankListModel.status == 0?Icon(Icons.edit,size: 2.h,color: ColorsForApp.primaryColor):const SizedBox.shrink()
                                      ],
                                    ),
                                    height(1.5.h),
                                    Divider(
                                      height: 0,
                                      thickness: 0.2,
                                      color: ColorsForApp.greyColor,
                                    ),
                                    height(1.5.h),
                                    // customKeyValueText(
                                    //   key: 'ID : ',
                                    //   value: aepsBankListModel.id != null && aepsBankListModel.id!.toString().isNotEmpty
                                    //       ? aepsBankListModel.id!.toString()
                                    //       : '-',
                                    // ),
                                    customKeyValueText(
                                      key: 'Account Holder Name : ',
                                      value: aepsBankListModel.acHolderName != null && aepsBankListModel.acHolderName!.isNotEmpty ? aepsBankListModel.acHolderName! : '-',
                                    ),
                                    customKeyValueText(
                                      key: 'Account Number : ',
                                      value: aepsBankListModel.accountNumber != null && aepsBankListModel.accountNumber!.isNotEmpty ? aepsBankListModel.accountNumber! : '-',
                                    ),
                                    customKeyValueText(
                                      key: 'IFSC Code : ',
                                      value: aepsBankListModel.ifsCCode != null && aepsBankListModel.ifsCCode!.isNotEmpty ? aepsBankListModel.ifsCCode! : '-',
                                    ),
                                    customKeyValueText(
                                      key: 'Account Type : ',
                                      value: aepsBankListModel.accountType != null
                                          ? aepsBankListModel.accountType! == 0
                                          ? 'Current'
                                          : 'Saving'
                                          : '-',
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              customKeyValueText(
                                                key: 'Added On : ',
                                                value: aepsBankListModel.createdOn != null && aepsBankListModel.createdOn!.isNotEmpty ? aepsSettlementController.formatDateTime(aepsBankListModel.createdOn!) : '-',
                                              ),
                                              customKeyValueText(
                                                key: 'Remark : ',
                                                value: aepsBankListModel.createRemark != null && aepsBankListModel.createRemark!.isNotEmpty ? aepsBankListModel.createRemark! : '-',
                                              ),
                                              Visibility(
                                                visible: aepsBankListModel.approveRemark != null && aepsBankListModel.approveRemark!.isNotEmpty ? true : false,
                                                child: customKeyValueText(
                                                  key: 'Admin Remark : ',
                                                  value: aepsBankListModel.approveRemark != null && aepsBankListModel.approveRemark!.isNotEmpty ? aepsBankListModel.approveRemark! : '-',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: aepsBankListModel.fileUrl != null && aepsBankListModel.fileUrl!.isNotEmpty ? true : false,
                                          child: SizedBox(
                                            height: 6.h,
                                            width: 15.w,
                                            child: GestureDetector(
                                              onTap: (){
                                                openUrl(url: aepsBankListModel.fileUrl!);
                                              },
                                              child: ShowNetworkImage(
                                                networkUrl: aepsBankListModel.fileUrl,
                                                defaultImagePath: Assets.iconsPdfIcon,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return height(0.5.h);
                      },
                    ),
                  )
            // UPI list
            : aepsSettlementController.allAepsUpiList.isEmpty
                ? notFoundText(text: 'No UPI found')
                : RefreshIndicator(
                    color: ColorsForApp.primaryColor,
                    onRefresh: () async {
                      isLoading.value = true;
                      await Future.delayed(const Duration(seconds: 1), () async {
                        await aepsSettlementController.getAepsBankList(pageNumber: 1, isLoaderShow: false);
                      });
                      isLoading.value = false;
                    },
                    child: ListView.separated(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                      itemCount: aepsSettlementController.allAepsUpiList.length,
                      itemBuilder: (context, index) {
                        if (index == aepsSettlementController.allAepsUpiList.length - 1 && aepsSettlementController.hasNext.value) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: ColorsForApp.primaryColor,
                            ),
                          );
                        } else {
                          AepsBankListModel aepsBankListModel = aepsSettlementController.allAepsUpiList[index];
                          return customCard(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'UPI :',
                                              style: TextHelper.size13.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                                color: ColorsForApp.blackColor,
                                              ),
                                            ),
                                            width(5),
                                            Flexible(
                                              child: Text(
                                                aepsBankListModel.upiid != null && aepsBankListModel.upiid!.isNotEmpty ? aepsBankListModel.upiid! : '-',
                                                textAlign: TextAlign.justify,
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: mediumGoogleSansFont,
                                                  color: ColorsForApp.blackColor,
                                                ),
                                              ),
                                            ),
                                            height(2.5.h),
                                          ],
                                        ),
                                      ),
                                      width(2.w),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: aepsBankListModel.status == 0
                                                ? ColorsForApp.chilliRedColor
                                                : aepsBankListModel.status == 1
                                                    ? ColorsForApp.successColor
                                                    : ColorsForApp.orangeColor,
                                            width: 0.2,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          child: Text(
                                            aepsSettlementController.ticketStatus(aepsBankListModel.status!),
                                            style: TextHelper.size13.copyWith(
                                              fontFamily: mediumGoogleSansFont,
                                              color: aepsBankListModel.status == 0
                                                  ? ColorsForApp.chilliRedColor
                                                  : aepsBankListModel.status == 1
                                                      ? ColorsForApp.successColor
                                                      : ColorsForApp.orangeColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  height(1.5.h),
                                  Divider(
                                    height: 0,
                                    thickness: 0.2,
                                    color: ColorsForApp.greyColor,
                                  ),
                                  height(1.5.h),
                                  // customKeyValueText(
                                  //   key: 'ID : ',
                                  //   value: aepsBankListModel.id != null && aepsBankListModel.id!.toString().isNotEmpty
                                  //       ? aepsBankListModel.id.toString()
                                  //       : '-',
                                  // ),
                                  customKeyValueText(
                                    key: 'Account Holder Name : ',
                                    value: aepsBankListModel.acHolderName != null && aepsBankListModel.acHolderName!.isNotEmpty ? aepsBankListModel.acHolderName! : '-',
                                  ),
                                  customKeyValueText(
                                    key: 'Created On : ',
                                    value: aepsBankListModel.createdOn != null && aepsBankListModel.createdOn!.isNotEmpty ? aepsSettlementController.formatDateTime(aepsBankListModel.createdOn!) : '-',
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return height(0.5.h);
                      },
                    ),
                  ),
      ),
      // Add bank button
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsForApp.primaryColor,
        onPressed: () {
          Get.toNamed(Routes.AEPS_ADD_BANK_SCREEN);
        },
        child: Icon(
          Icons.add_rounded,
          color: ColorsForApp.whiteColor,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/recharge_controller.dart';
import '../../../../../model/recharge_and_biils/m_plans_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/dash_line.dart';

class MPlanScreen extends StatefulWidget {
  const MPlanScreen({Key? key}) : super(key: key);

  @override
  State<MPlanScreen> createState() => _MPlanScreenState();
}

class _MPlanScreenState extends State<MPlanScreen> {
  final RechargeController rechargeController = Get.find();
  List<String> keysList = [];

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await rechargeController.getMPlansList();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    rechargeController.mPlansList.clear();
    rechargeController.selectedIndex.value = 0;
    rechargeController.selectedMPlansList.value = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: MPlanDetails());
        return false;
      },
      child: CustomScaffold(
        title: 'M Plans',
        isShowLeadingIcon: true,
        onBackIconTap: () {
          Get.back(result: MPlanDetails());
        },
        mainBody: Column(
          children: [
            Expanded(
              child: Container(
                height: 100.h,
                width: 100.w,
                decoration: BoxDecoration(
                  color: ColorsForApp.whiteColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Obx(
                  () => rechargeController.mPlansList.isEmpty
                      ? notFoundText(text: 'No plans found')
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            height(1.h),
                            // Horizontal tabbar
                            SizedBox(
                              height: 4.5.h,
                              width: 100.w,
                              child: Obx(
                                () => ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                                  itemCount: rechargeController.mPlansList.length,
                                  itemBuilder: (context, index) {
                                    keysList = rechargeController.mPlansList.keys.toList();
                                    return Obx(
                                      () => Padding(
                                        padding: index == 0
                                            ? EdgeInsets.only(left: 2.w)
                                            : index == rechargeController.mPlansList.length - 1
                                                ? EdgeInsets.only(right: 2.w)
                                                : EdgeInsets.zero,
                                        child: GestureDetector(
                                          onTap: () {
                                            rechargeController.selectedIndex.value = index;
                                            rechargeController.selectedMPlansList.value = rechargeController.mPlansList[keysList[index]]!;
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: Container(
                                              constraints: BoxConstraints(minWidth: 30.w),
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: const Alignment(-0.0, -0.7),
                                                  end: const Alignment(0, 1),
                                                  colors: rechargeController.selectedIndex.value == index
                                                      ? [
                                                          ColorsForApp.whiteColor,
                                                          ColorsForApp.selectedTabBackgroundColor,
                                                        ]
                                                      : [
                                                          ColorsForApp.whiteColor,
                                                          ColorsForApp.whiteColor,
                                                        ],
                                                ),
                                                color: rechargeController.selectedIndex.value == index ? ColorsForApp.selectedTabBgColor : ColorsForApp.whiteColor,
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: rechargeController.selectedIndex.value == index ? ColorsForApp.primaryColor : ColorsForApp.accentColor,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                keysList[index].toString(),
                                                style: TextHelper.size15.copyWith(
                                                  color: ColorsForApp.primaryColor,
                                                  fontFamily: rechargeController.selectedIndex.value == index ? mediumGoogleSansFont : regularGoogleSansFont,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (BuildContext context, int index) {
                                    return width(2.w);
                                  },
                                ),
                              ),
                            ),
                            height(10),
                            // Plan list
                            Expanded(
                              child: Obx(
                                () => ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                                  itemCount: rechargeController.selectedMPlansList.length,
                                  itemBuilder: (context, index) {
                                    MPlanDetails mPlanDetails = rechargeController.selectedMPlansList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.back(result: mPlanDetails);
                                      },
                                      child: Card(
                                        elevation: 2,
                                        color: ColorsForApp.whiteColor,
                                        shadowColor: ColorsForApp.primaryColor,
                                        margin: EdgeInsets.symmetric(vertical: 0.7.h),
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 0.5,
                                            color: ColorsForApp.grayScale500,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  height(1.5.h),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      // Price
                                                      Expanded(
                                                        flex: 2,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            mPlanDetails.rs != null && mPlanDetails.rs!.isNotEmpty
                                                                ? Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: [
                                                                      Text(
                                                                        '₹',
                                                                        style: TextHelper.size15.copyWith(
                                                                          color: ColorsForApp.primaryColor,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        mPlanDetails.rs!,
                                                                        style: TextHelper.size20.copyWith(
                                                                          fontFamily: boldGoogleSansFont,
                                                                          color: ColorsForApp.primaryColor,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Text(
                                                                    'NA',
                                                                    style: TextHelper.size15.copyWith(
                                                                      fontFamily: boldGoogleSansFont,
                                                                      color: ColorsForApp.primaryColor,
                                                                    ),
                                                                  ),
                                                          ],
                                                        ),
                                                      ),
                                                      // Validity
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              mPlanDetails.validity != null && mPlanDetails.validity!.isNotEmpty ? mPlanDetails.validity! : 'NA',
                                                              style: TextHelper.size14.copyWith(
                                                                color: ColorsForApp.primaryColor,
                                                                fontFamily: mediumGoogleSansFont,
                                                              ),
                                                            ),
                                                            height(5),
                                                            Text(
                                                              'Validity',
                                                              style: TextHelper.size12.copyWith(
                                                                color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // Right aroow
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Icon(
                                                              Icons.chevron_right_rounded,
                                                              size: 30,
                                                              color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // No service validity
                                                  Visibility(
                                                    visible: mPlanDetails.validity != null && mPlanDetails.validity! == 'NA' ? true : false,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        height(5),
                                                        Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                          decoration: BoxDecoration(
                                                            color: ColorsForApp.shadowColor.withOpacity(0.1),
                                                            borderRadius: BorderRadius.circular(100),
                                                          ),
                                                          child: Text(
                                                            'No Service Validity',
                                                            style: TextHelper.size10.copyWith(
                                                              color: ColorsForApp.lightBlackColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            height(1.5.h),
                                            // Dashed line
                                            DashedLine(
                                              width: 5,
                                              color: ColorsForApp.greyColor.withOpacity(0.5),
                                            ),
                                            // Description
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.info_outline_rounded,
                                                    size: 16,
                                                    color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                                                  ),
                                                  width(1.w),
                                                  Flexible(
                                                    child: Text(
                                                      mPlanDetails.desc != null && mPlanDetails.desc!.isNotEmpty ? mPlanDetails.desc! : 'NA',
                                                      style: TextHelper.size11.copyWith(
                                                        color: ColorsForApp.lightBlackColor.withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

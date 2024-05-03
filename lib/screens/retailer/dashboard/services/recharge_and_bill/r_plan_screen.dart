import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/recharge_controller.dart';
import '../../../../../model/recharge_and_biils/r_plans_model.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/dash_line.dart';

class RPlanScreen extends StatefulWidget {
  const RPlanScreen({Key? key}) : super(key: key);

  @override
  State<RPlanScreen> createState() => _RPlanScreenState();
}

class _RPlanScreenState extends State<RPlanScreen> {
  final RechargeController rechargeController = Get.find();
  List<String> keysList = [];

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await rechargeController.getRPlansList();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    rechargeController.rPlansList.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: RPlanDetails());
        return false;
      },
      child: CustomScaffold(
        title: 'R Plans',
        isShowLeadingIcon: true,
        onBackIconTap: () {
          Get.back(result: RPlanDetails());
        },
        mainBody: Column(
          children: [
            Expanded(
              child: Container(
                height: 100.h,
                width: 100.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Obx(
                  () => rechargeController.rPlansList.isEmpty
                      ? notFoundText(text: 'No plans found')
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            height(1.h),
                            Expanded(
                              child: Obx(
                                () => ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                                  itemCount: rechargeController.rPlansList.length,
                                  itemBuilder: (context, index) {
                                    RPlanDetails rPlanDetails = rechargeController.rPlansList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Get.back(result: rPlanDetails);
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
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            rPlanDetails.rs != null && rPlanDetails.rs!.isNotEmpty
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
                                                                        rPlanDetails.rs!,
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
                                                      // Right arrow
                                                      Column(
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
                                                    ],
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
                                                      rPlanDetails.desc != null && rPlanDetails.desc!.isNotEmpty
                                                          ? rPlanDetails.desc!.trim()
                                                          : rPlanDetails.shortdesc != null && rPlanDetails.shortdesc!.isNotEmpty
                                                              ? rPlanDetails.shortdesc!.trim()
                                                              : 'NA',
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

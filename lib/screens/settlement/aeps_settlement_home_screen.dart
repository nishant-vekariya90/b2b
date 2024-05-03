import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../routes/routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/string_constants.dart';
import '../../utils/text_styles.dart';
import '../../widgets/button.dart';
import '../../widgets/constant_widgets.dart';
import '../../widgets/custom_scaffold.dart';

class AepsSettlementHomeScreen extends StatelessWidget {
  const AepsSettlementHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Settlement',
      isShowLeadingIcon: true,
      mainBody: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            height(4.h),
            Text(
              'You can transfer your AEPS amount to your bank account or include it in your main wallet',
              textAlign: TextAlign.center,
              style: TextHelper.size15.copyWith(
                fontFamily: mediumGoogleSansFont,
                color: ColorsForApp.greyColor.withOpacity(0.9),
              ),
            ),
            height(4.h),
            settlementServiceList.isNotEmpty
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
                    itemCount: settlementServiceList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          if (settlementServiceList[index].code == 'WALLETTOBANK') {
                            if (settlementServiceList[index].isAccess == false) {
                              showCommonMessageDialog(context, 'Access', 'You don\'t have access please contact to administrator');
                            } else {
                              Get.toNamed(Routes.AEPS_TO_BANK_SCREEN);
                            }
                          } else if (settlementServiceList[index].code == 'WALLETTOWALLET') {
                            if (settlementServiceList[index].isAccess == false) {
                              showCommonMessageDialog(context, 'Access', 'You don\'t have access please contact to administrator');
                            } else {
                              Get.toNamed(Routes.AEPS_TO_MAIN_WALLET_SCREEN);
                            }
                          } else if (settlementServiceList[index].code == 'WALLETTODIRECTBANK') {
                            if (settlementServiceList[index].isAccess == false) {
                              showCommonMessageDialog(context, 'Access', 'You don\'t have access please contact to administrator');
                            } else {
                              Get.toNamed(Routes.AEPS_TO_DIRECT_BANK_SCREEN);
                            }
                          } else if (settlementServiceList[index].code == 'SETTLEMENTHISTORY') {
                            if (settlementServiceList[index].isAccess == false) {
                              showCommonMessageDialog(context, 'Access', 'You don\'t have access please contact to administrator');
                            } else {
                              Get.toNamed(Routes.AEPS_SETTLEMENT_HISTORY_SCREEN);
                            }
                          }
                        },
                        child: Container(
                          height: 13.h,
                          width: 30.w,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: ColorsForApp.stepBorderColor.withOpacity(0.1),
                            border: Border.all(color: ColorsForApp.primaryShadeColor, style: BorderStyle.solid),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.account_balance_outlined,
                                size: 28,
                              ),
                              Text(
                                settlementServiceList[index].title,
                                textAlign: TextAlign.center,
                                style: TextHelper.size15.copyWith(
                                  fontFamily: mediumGoogleSansFont,
                                  color: ColorsForApp.lightBlackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : notFoundText(text: 'No services found'),
          ],
        ),
      ),
    );
  }
}

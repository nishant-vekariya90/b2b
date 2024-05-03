import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/recharge_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/master/operator_list_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field.dart';
import '../../../../../widgets/text_field_with_title.dart';

class DthRechargeScreen extends StatefulWidget {
  const DthRechargeScreen({Key? key}) : super(key: key);

  @override
  State<DthRechargeScreen> createState() => _DthRechargeScreenState();
}

class _DthRechargeScreenState extends State<DthRechargeScreen> {
  final RechargeController rechargeController = Get.find();
  final Rx<GlobalKey<FormState>> dthRechargeFormKey = GlobalKey<FormState>().obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      await rechargeController.getMasterOperatorList(operator: 'dth', isLoaderShow: false);
      rechargeController.isShowTpinField.value = checkTpinRequired(categoryCode: 'Telecom');
      dismissProgressIndicator();
    } catch (e) {
      rechargeController.isShowTpinField.value = false;
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    rechargeController.resetRechargeVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 10.h,
      title: 'DTH Recharge',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
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
              child: Image.asset(
                Assets.imagesDthRechargeTopBg,
              ),
            ),
            width(2.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DTH Recharge',
                    style: TextHelper.size14.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    'Hassle-free DTH recharge so that you never miss your favorite programs.',
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
      mainBody: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Obx(
          () => Form(
            key: dthRechargeFormKey.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(2.h),
                // Subscriber Id
                CustomTextFieldWithTitle(
                  controller: rechargeController.mobileNumberController,
                  title: 'Subscriber ID/Mobile no',
                  hintText: 'Enter subscriber id/mobile no',
                  maxLength: 18,
                  isCompulsory: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (rechargeController.mobileNumberController.text.trim().isEmpty) {
                      return 'Please enter subscriber id';
                    } else if (rechargeController.mobileNumberController.text.length < 5 || rechargeController.mobileNumberController.text.length > 18) {
                      return 'Please enter valid subscriber id';
                    }
                    return null;
                  },
                ),
                // Operator
                CustomTextFieldWithTitle(
                  controller: rechargeController.operatorController,
                  title: 'Operator',
                  hintText: 'Select operator',
                  readOnly: true,
                  isCompulsory: true,
                  onTap: () async {
                    MasterOperatorListModel selectedOperator = await Get.toNamed(
                      Routes.SEARCHABLE_LIST_VIEW_WITH_IMAGE_SCREEN,
                      arguments: [
                        rechargeController.masterOperatorList, // modelList
                        'operatorList', // modelName
                      ],
                    );
                    if (selectedOperator.name != null && selectedOperator.name!.isNotEmpty) {
                      rechargeController.operatorController.text = selectedOperator.name!;
                      rechargeController.selectedOperatorCode.value = selectedOperator.apiCode!;
                    }
                  },
                  suffixIcon: Icon(
                    Icons.chevron_right_rounded,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  validator: (value) {
                    if (rechargeController.operatorController.text.trim().isEmpty) {
                      return 'Please select operator';
                    }
                    return null;
                  },
                ),
                // Amount
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Amount',
                        style: TextHelper.size14,
                        children: [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: ColorsForApp.errorColor,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    height(0.8.h),
                    CustomTextField(
                      controller: rechargeController.amountController,
                      hintText: 'Enter amount',
                      maxLength: 7,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      suffixIcon: Icon(
                        Icons.currency_rupee_rounded,
                        size: 18,
                        color: ColorsForApp.secondaryColor.withOpacity(0.5),
                      ),
                      onChange: (value) {
                        if (rechargeController.amountController.text.isNotEmpty && int.parse(rechargeController.amountController.text.trim()) > 0) {
                          rechargeController.amountIntoWords.value = getAmountIntoWords(int.parse(rechargeController.amountController.text.trim()));
                        } else {
                          rechargeController.amountIntoWords.value = '';
                        }
                      },
                      validator: (value) {
                        String amountText = rechargeController.amountController.text.trim();
                        if (amountText.isEmpty) {
                          return 'Please enter amount';
                        } else if (int.parse(amountText) <= 0) {
                          return 'Amount should be greater than 0';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                // Amount in text
                Obx(
                  () => Visibility(
                    visible: rechargeController.amountIntoWords.value.isNotEmpty ? true : false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(0.6.h),
                        Text(
                          rechargeController.amountIntoWords.value,
                          style: TextHelper.size13.copyWith(
                            fontFamily: mediumGoogleSansFont,
                            color: ColorsForApp.successColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                height(1.5.h),
                // TPIN
                Visibility(
                  visible: rechargeController.isShowTpinField.value,
                  child: Obx(
                    () => CustomTextFieldWithTitle(
                      controller: rechargeController.tPinController,
                      title: 'TPIN',
                      hintText: 'Enter TPIN',
                      maxLength: 4,
                      isCompulsory: true,
                      obscureText: rechargeController.isShowTpin.value,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      suffixIcon: IconButton(
                        onPressed: () {
                          rechargeController.isShowTpin.value = !rechargeController.isShowTpin.value;
                        },
                        icon: Icon(
                          rechargeController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                          size: 18,
                          color: ColorsForApp.secondaryColor.withOpacity(0.5),
                        ),
                      ),
                      validator: (value) {
                        if (rechargeController.tPinController.text.trim().isEmpty) {
                          return 'Please enter TPIN';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                height(1.h),
                // Proceed button
                CommonButton(
                  label: 'Proceed',
                  onPressed: () async {
                    if (dthRechargeFormKey.value.currentState!.validate()) {
                      confirmationBottomSheet();
                    }
                  },
                ),
                height(2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Confirm recharge dailog
  Future<dynamic> confirmationBottomSheet() {
    return customBottomSheet(
      isScrollControlled: true,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Recharge Confirmation',
          textAlign: TextAlign.center,
          style: TextHelper.size20.copyWith(
            fontFamily: boldGoogleSansFont,
          ),
        ),
        height(2.h),
        Center(
          child: Text(
            '₹ ${rechargeController.amountController.text.trim()}.00',
            style: TextHelper.h1.copyWith(
              fontFamily: mediumGoogleSansFont,
              color: ColorsForApp.primaryColor,
            ),
          ),
        ),
        height(1.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: ColorsForApp.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Recharge for ${rechargeController.operatorController.text.trim()}',
                style: TextHelper.size14,
              ),
              height(5),
              Text(
                '(${rechargeController.mobileNumberController.text.trim()})',
                style: TextHelper.size14,
              ),
            ],
          ),
        ),
      ],
      isShowButton: true,
      buttonText: 'Recharge',
      onTap: () async {
        // Unfocus text-field
        FocusScope.of(context).unfocus();
        if (Get.isSnackbarOpen) {
          Get.back();
        }
        Get.back();
        rechargeController.rechargeStatus.value = -1;
        await Get.toNamed(
          Routes.RECHARGE_STATUS_SCREEN,
          arguments: 'dth',
        );
        dthRechargeFormKey.value = GlobalKey<FormState>();
      },
    );
  }
}

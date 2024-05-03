import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/gift_card_controller.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../model/category_for_tpin_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/string_constants.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/network_image.dart';
import '../../../../../../widgets/text_field.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class GiftCardDetailScreen extends StatefulWidget {
  const GiftCardDetailScreen({super.key});

  @override
  State<GiftCardDetailScreen> createState() => _GiftCardDetailScreenState();
}

class _GiftCardDetailScreenState extends State<GiftCardDetailScreen> {
  final GiftCardController giftCardController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    callAsyncApi();
    super.initState();
  }

  Future<void> callAsyncApi() async {
    try {
      await giftCardController.giftCardDetailsApi(isLoaderShow: true);
      CategoryForTpinModel categoryForTpinModel = categoryForTpinList.firstWhere((element) => element.code != null && element.code!.toLowerCase() == 'giftcard');
      giftCardController.isShowTpinField.value = categoryForTpinModel.isTpin!;
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    giftCardController.amountController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsForApp.creamColor,
        appBar: appBar,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          physics: const BouncingScrollPhysics(),
          child: Obx(
            () => giftCardController.giftCardDetailsModel.value.data != null
                ? Form(
                    key: formKey,
                    child: Column(
                      children: [
                        topGiftCardBanner(context),
                        height(3.h),
                        giftDetails(context),
                        height(2.h),
                        redeemCardUI(context),
                        height(2.h),
                        termsAndConditionUI(context),
                      ],
                    ),
                  )
                : Container(),
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () {
            if (formKey.currentState!.validate()) {
              orderConfirmationBottomSheet(context: context);
            }
          },
          child: Container(
            height: 7.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: ColorsForApp.primaryColorBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "BUY NOW",
                  textAlign: TextAlign.center,
                  style: TextHelper.size16.copyWith(color: ColorsForApp.whiteColor, fontWeight: FontWeight.bold, fontFamily: boldGoogleSansFont),
                ),
                width(10.w),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar get appBar {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      title: Text(
        "Buy Gift card",
        style: TextHelper.size18.copyWith(color: ColorsForApp.primaryColor, fontWeight: FontWeight.bold, fontFamily: boldGoogleSansFont),
      ),
    );
  }

  Widget topGiftCardBanner(BuildContext context) {
    return Container(
      width: 100.w,
      height: 20.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(11.0),
        image: const DecorationImage(
          image: AssetImage(
            Assets.imagesCashbackBanner,
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(5, 5), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Flexible(
            child: Text(giftCardController.giftCardDetailsModel.value.data!.brandName ?? '-', style: TextHelper.size20.copyWith(color: ColorsForApp.whiteColor, fontWeight: FontWeight.bold, fontFamily: boldGoogleSansFont)),
          ),
          width(5.w),
          Container(
            height: 10.h,
            width: 30.w,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: ColorsForApp.creamColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(11.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ShowNetworkImage(
                networkUrl: giftCardController.giftCardDetailsModel.value.data!.image!.isNotEmpty ? giftCardController.giftCardDetailsModel.value.data!.image! : '',
                defaultImagePath: Assets.imagesImageNotAvailable,
                isShowBorder: false,
                fit: BoxFit.contain,
                boxShape: BoxShape.rectangle,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget giftDetails(BuildContext context) {
    return Container(
      width: 100.w,
      // height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.blue,
        image: const DecorationImage(
          image: AssetImage(
            Assets.imagesWhiteCardWithCurveCenter,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(11.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 10.h,
                width: 25.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(
                    color: ColorsForApp.greyColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ShowNetworkImage(
                    networkUrl: giftCardController.giftCardDetailsModel.value.data!.image!.isNotEmpty ? giftCardController.giftCardDetailsModel.value.data!.image! : '',
                    defaultImagePath: Assets.imagesImageNotAvailable,
                    isShowBorder: false,
                    fit: BoxFit.contain,
                    boxShape: BoxShape.rectangle,
                  ),
                ),
              ),
              width(3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      giftCardController.giftCardDetailsModel.value.data!.brandName ?? '-',
                      style: TextHelper.size17.copyWith(
                        color: ColorsForApp.lightBlackColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: boldGoogleSansFont,
                      ),
                    ),
                    height(0.4.h),
                    Text(
                      "Code: ${giftCardController.giftCardDetailsModel.value.data!.code}",
                      style: TextHelper.size13.copyWith(
                        color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "Redemption Mode: ${giftCardController.giftCardDetailsModel.value.data!.redemptionMode}",
                      style: TextHelper.size13.copyWith(
                        color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          height(1.h),
          CustomTextField(
            controller: giftCardController.amountController,
            hintText: 'Enter amount',
            maxLength: 7,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            textInputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            obscureText: false,
            onChange: (value) {
              if (giftCardController.amountController.text.isNotEmpty && int.parse(giftCardController.amountController.text.trim()) > 0) {
                giftCardController.amountIntoWords.value = getAmountIntoWords(int.parse(giftCardController.amountController.text.trim()));
              } else {
                giftCardController.amountIntoWords.value = '';
              }
            },
            validator: (value) {
              String amountText = giftCardController.amountController.text.trim();
              if (amountText.isEmpty) {
                return 'Please enter amount';
              }
              if (int.parse(amountText) <= 0) {
                return 'Amount should be greater than 0';
              }
              if (giftCardController.giftCardDetailsModel.value.data!.price!.min != null && giftCardController.giftCardDetailsModel.value.data!.price!.min != 0) {
                if (giftCardController.giftCardDetailsModel.value.data!.price!.min! > int.parse(giftCardController.amountController.text.trim())) {
                  return "Amount must be grater than Min amount";
                }
              }
              if (giftCardController.giftCardDetailsModel.value.data!.price!.max != null && giftCardController.giftCardDetailsModel.value.data!.price!.max != 0) {
                if (int.parse(giftCardController.amountController.text.trim()) > giftCardController.giftCardDetailsModel.value.data!.price!.max!) {
                  return 'Amount must be less than Max amount';
                }
              }
              return null;
            },
          ),
          // Amount in text
          Obx(
            () => Visibility(
              visible: giftCardController.amountIntoWords.value.isNotEmpty ? true : false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 0.6.h),
                  Text(
                    giftCardController.amountIntoWords.value,
                    style: TextHelper.size13.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.successColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          height(1.h),
          Row(
            children: [
              Text("Min: ₹${giftCardController.giftCardDetailsModel.value.data!.price!.min}"),
              width(1.h),
              Text("Max: ₹${giftCardController.giftCardDetailsModel.value.data!.price!.max}"),
            ],
          )
        ],
      ),
    );
  }

  Widget redeemCardUI(BuildContext context) {
    return Container(
      width: 100.w,
      // height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("How to redeem", style: TextHelper.size14.copyWith(color: ColorsForApp.lightBlackColor, fontWeight: FontWeight.bold, fontFamily: boldGoogleSansFont)),
          height(1.h),
          /* Linkify(
            onOpen: (link) async {
              if (!await launchUrl(Uri.parse(link.url))) {
                throw Exception('Could not launch ${link.url}');
              }
            },
            text: "Made by https://cretezy.com",
            style: TextStyle(color: Colors.yellow),
            linkStyle: TextStyle(color: Colors.red),
          ),*/
          Text(giftCardController.giftCardDetailsModel.value.data!.howToRedeem!,
              style: TextHelper.size14.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w400,
              )),
        ],
      ),
    );
  }

  Widget termsAndConditionUI(BuildContext context) {
    return Container(
      width: 100.w,
      // height: 20.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.receipt_long,
                size: 16,
                color: ColorsForApp.primaryColor,
              ),
              width(5),
              Text("Terms and conditions", style: TextHelper.size14.copyWith(color: ColorsForApp.lightBlackColor, fontWeight: FontWeight.bold, fontFamily: boldGoogleSansFont)),
            ],
          ),
          height(1.h),
          /* Linkify(
            onOpen: (link) async {
              if (!await launchUrl(Uri.parse(link.url))) {
                throw Exception('Could not launch ${link.url}');
              }
            },
            text: "Made by https://cretezy.com",
            style: TextStyle(color: Colors.yellow),
            linkStyle: TextStyle(color: Colors.red),
          ),*/
          ExpandableText(
            giftCardController.giftCardDetailsModel.value.data!.tnc!,
            expandText: 'Read more',
            collapseText: 'Read less',
            maxLines: 4,
            linkColor: Colors.blue,
          ),
          /*Text(giftCardController.giftCardDetailsModel.value.data!.tnc!,
              style: TextHelper.size14.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
              )),*/
        ],
      ),
    );
  }

  orderConfirmationBottomSheet({required BuildContext context}) {
    return Get.bottomSheet(
      isScrollControlled: true,
      Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 2.5,
                width: 100.w * 0.3,
                decoration: BoxDecoration(
                  color: ColorsForApp.greyColor.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            height(5),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Order Confirmation',
                style: TextHelper.size18.copyWith(
                  fontFamily: boldGoogleSansFont,
                  color: ColorsForApp.primaryColor,
                ),
              ),
            ),
            height(15),
            Align(
              alignment: Alignment.center,
              child: Text(
                '₹ ${giftCardController.amountController.text}',
                style: TextHelper.h1.copyWith(
                  fontFamily: mediumGoogleSansFont,
                  color: ColorsForApp.primaryColor,
                ),
              ),
            ),
            height(5),
            // TPIN
            Visibility(
              visible: giftCardController.isShowTpinField.value,
              child: Obx(
                () => CustomTextFieldWithTitle(
                  controller: giftCardController.tPinTxtController,
                  title: 'TPIN',
                  hintText: 'Enter TPIN',
                  maxLength: 4,
                  isCompulsory: true,
                  obscureText: giftCardController.isShowTpin.value,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    icon: Icon(
                      giftCardController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                      size: 18,
                      color: ColorsForApp.secondaryColor,
                    ),
                    onPressed: () {
                      giftCardController.isShowTpin.value = !giftCardController.isShowTpin.value;
                    },
                  ),
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (giftCardController.tPinTxtController.text.trim().isEmpty) {
                      return 'Please enter TPIN';
                    }
                    return null;
                  },
                ),
              ),
            ),
            height(15),
            CommonButton(
              label: 'Confirm order',
              onPressed: () async {
                if (giftCardController.isShowTpinField.value == true) {
                  if (giftCardController.tPinTxtController.text.trim().isEmpty) {
                    errorSnackBar(message: 'Please enter TPIN');
                  } else {
                    if (isInternetAvailable.value) {
                      if (Get.isSnackbarOpen) {
                        Get.back();
                      }
                      Get.back();
                      giftCardController.orderStatus.value = -1;
                      await Get.toNamed(
                        Routes.GIFTCARD_BUY_STATUS_SCREEN,
                      );
                    } else {
                      errorSnackBar(message: noInternetMsg);
                    }
                  }
                } else {
                  if (isInternetAvailable.value) {
                    if (Get.isSnackbarOpen) {
                      Get.back();
                    }
                    Get.back();
                    giftCardController.orderStatus.value = -1;
                    await Get.toNamed(
                      Routes.GIFTCARD_BUY_STATUS_SCREEN,
                    );
                  } else {
                    errorSnackBar(message: noInternetMsg);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

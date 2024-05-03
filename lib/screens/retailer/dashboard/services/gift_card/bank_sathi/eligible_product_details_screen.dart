import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/gift_card_b_controller.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../model/category_for_tpin_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/string_constants.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/network_image.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class EligibleProductDetailsScreen extends StatefulWidget {
  const EligibleProductDetailsScreen({super.key});

  @override
  State<EligibleProductDetailsScreen> createState() => _EligibleProductDetailsScreenState();
}

class _EligibleProductDetailsScreenState extends State<EligibleProductDetailsScreen> {
  final GiftCardBController giftCardBController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      showProgressIndicator();
      CategoryForTpinModel categoryForTpinModel = categoryForTpinList.firstWhere((element) => element.code != null && element.code!.toLowerCase() == 'giftcard');
      giftCardBController.isShowTpinField.value = categoryForTpinModel.isTpin!;
      await giftCardBController.getOtherProductDetailsApi();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    giftCardBController.resetProductDetailsVaribales();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorsForApp.lightBrown,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: ColorsForApp.lightBlackColor),
          centerTitle: false,
          title: Text(
            'Product details',
            style: TextHelper.size18.copyWith(color: ColorsForApp.primaryColor, fontWeight: FontWeight.bold, fontFamily: boldGoogleSansFont),
          ), // Padding
        ),
        body: Column(
          children: [
            Container(
              //height: MediaQuery.of(context).size.height * .35,
              padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 2.h),
              width: double.infinity,
              child: productDetails(context),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Obx(
                  () => Column(
                    children: [
                      height(1.h),
                      Expanded(
                        child: giftCardBController.bkProductDetailsModel.value.attribute != null
                            ? DefaultTabController(
                                length: giftCardBController.bkProductDetailsModel.value.attribute!.length,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5.h,
                                      child: TabBar(
                                        isScrollable: true,
                                        tabAlignment: TabAlignment.start,
                                        automaticIndicatorColorAdjustment: true,
                                        labelStyle: TextHelper.size14.copyWith(
                                          color: ColorsForApp.primaryColor,
                                          fontFamily: boldGoogleSansFont,
                                        ),
                                        labelColor: ColorsForApp.primaryColor,
                                        physics: const ClampingScrollPhysics(),
                                        unselectedLabelColor: ColorsForApp.greyColor,
                                        unselectedLabelStyle: TextHelper.size14.copyWith(
                                          color: ColorsForApp.primaryColor,
                                        ),
                                        indicatorSize: TabBarIndicatorSize.label,
                                        padding: EdgeInsets.zero,
                                        indicatorColor: ColorsForApp.primaryColor,
                                        tabs: giftCardBController.bkProductDetailsModel.value.attribute!.map<Widget>((tab) {
                                          return Tab(
                                            text: tab.tabName!,
                                            iconMargin: EdgeInsets.zero,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    height(1.h),
                                    Expanded(
                                      child: giftCardBController.bkProductDetailsModel.value.attribute != null
                                          ? TabBarView(
                                              children: giftCardBController.bkProductDetailsModel.value.attribute!.map<Widget>((tab) {
                                                return ListView(
                                                  physics: const BouncingScrollPhysics(),
                                                  children: tab.content!.map<Widget>((content) {
                                                    return ListTile(
                                                        title: Text(
                                                          content.title ?? '',
                                                          style: TextHelper.size14.copyWith(color: ColorsForApp.primaryColor, fontFamily: boldGoogleSansFont),
                                                        ),
                                                        subtitle: Text(
                                                          content.content ?? '',
                                                          style: TextHelper.size14.copyWith(color: ColorsForApp.lightBlackColor, fontFamily: regularGoogleSansFont),
                                                        ));
                                                  }).toList(),
                                                );
                                              }).toList(),
                                            )
                                          : notFoundText(text: 'No data fount'),
                                    ),
                                  ],
                                ),
                              )
                            : notFoundText(text: "No product details found"),
                      ),
                      height(1.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                        child: CommonButton(
                          onPressed: () async {
                            orderConfirmationBottomSheet(context: context);
                          },
                          label: 'Buy Now',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget productDetails(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(
            Assets.imagesWhiteCardWithCurveCenter,
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(5, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(11.0),
      ),
      child: Obx(() => Column(
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
                        networkUrl: giftCardBController.bkProductDetailsModel.value.logo != null && giftCardBController.bkProductDetailsModel.value.logo!.isNotEmpty ? giftCardBController.bkProductDetailsModel.value.logo! : '',
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
                          giftCardBController.bkProductDetailsModel.value.title ?? '-',
                          style: TextHelper.size17.copyWith(
                            color: ColorsForApp.lightBlackColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: boldGoogleSansFont,
                          ),
                        ),
                        height(0.4.h),
                        Text(
                          giftCardBController.bkProductDetailsModel.value.subTitle ?? '-',
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
            ],
          )),
    );
  }

  orderConfirmationBottomSheet({required BuildContext context}) {
    return Get.bottomSheet(
      isScrollControlled: true,
      Expanded(
        child: Container(
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: ColorsForApp.whiteColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
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
                  height(10),
                  Obx(
                    () => Text(
                      giftCardBController.bkProductDetailsModel.value.title ?? '-',
                      style: TextHelper.size17.copyWith(
                        color: ColorsForApp.lightBlackColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: boldGoogleSansFont,
                      ),
                    ),
                  ),
                  // TPIN
                  Visibility(
                    visible: giftCardBController.isShowTpinField.value,
                    child: Obx(
                      () => CustomTextFieldWithTitle(
                        controller: giftCardBController.tPinTxtController,
                        title: 'TPIN',
                        hintText: 'Enter TPIN',
                        maxLength: 4,
                        isCompulsory: true,
                        obscureText: giftCardBController.isShowTpin.value,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        suffixIcon: IconButton(
                          icon: Icon(
                            giftCardBController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                            size: 18,
                            color: ColorsForApp.secondaryColor,
                          ),
                          onPressed: () {
                            giftCardBController.isShowTpin.value = !giftCardBController.isShowTpin.value;
                          },
                        ),
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (giftCardBController.tPinTxtController.text.trim().isEmpty) {
                            return 'Please enter TPIN';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  height(8),
                  // Mobile number
                  CustomTextFieldWithTitle(
                    controller: giftCardBController.mobileTxtController,
                    title: 'Mobile Number',
                    hintText: 'Enter mobile number',
                    maxLength: 10,
                    isCompulsory: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    textInputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                      if (giftCardBController.mobileTxtController.text.trim().isEmpty) {
                        return 'Please enter mobile number';
                      } else if (giftCardBController.mobileTxtController.text.length < 10) {
                        return 'Please enter valid mobile number';
                      }
                      return null;
                    },
                    suffixIcon: Icon(
                      Icons.call,
                      size: 18,
                      color: ColorsForApp.secondaryColor,
                    ),
                  ),
                  height(8),
                  // customer name
                  CustomTextFieldWithTitle(
                    controller: giftCardBController.customerNameTxtController,
                    title: 'Customer Name',
                    hintText: 'Enter customer name',
                    isCompulsory: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (giftCardBController.customerNameTxtController.text.trim().isEmpty) {
                        return 'Please enter customer name';
                      } else if (giftCardBController.customerNameTxtController.text.length < 3) {
                        return 'Please enter valid name';
                      }
                      return null;
                    },
                    suffixIcon: Icon(
                      Icons.call,
                      size: 18,
                      color: ColorsForApp.secondaryColor,
                    ),
                  ),
                  height(8),
                  // Pan number
                  CustomTextFieldWithTitle(
                    controller: giftCardBController.panNumberTxtController,
                    title: 'Pan Number',
                    hintText: 'Enter pan number',
                    maxLength: 10,
                    isCompulsory: true,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
                      if (value!.isEmpty) {
                        return 'Please enter pan card number';
                      } else if (!panRegex.hasMatch(value)) {
                        return 'Please enter valid pan number';
                      }
                      return null;
                    },
                    suffixIcon: Icon(
                      Icons.contact_emergency,
                      size: 18,
                      color: ColorsForApp.secondaryColor,
                    ),
                  ),
                  CommonButton(
                    label: 'Confirm order',
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (isInternetAvailable.value) {
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          Get.back();
                          bool result = await giftCardBController.checkCustomerExitApi();
                          if (result == true) {
                            giftCardBController.orderStatus.value = -1;
                            await Get.toNamed(
                              Routes.GIFTCARD_B_BUY_STATUS_SCREEN,
                            );
                          }
                        } else {
                          errorSnackBar(message: noInternetMsg);
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

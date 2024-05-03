import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/offline_token_controller.dart';
import '../../../../../../model/offline_token/offline_token_credentials_model.dart';
import '../../../../../../model/product/all_product_model.dart';
import '../../../../../../model/product/product_child_category_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';
import '../../../../../../widgets/otp_text_field.dart';
import '../../../../../../widgets/text_field.dart';
import '../../../../../../widgets/text_field_with_title.dart';

class DigitalSignatureTokenScreen extends StatefulWidget {
  const DigitalSignatureTokenScreen({Key? key}) : super(key: key);

  @override
  State<DigitalSignatureTokenScreen> createState() => _DigitalSignatureTokenScreenState();
}

class _DigitalSignatureTokenScreenState extends State<DigitalSignatureTokenScreen> {
  final OfflineTokenController offlineTokenController = Get.find();
  final Rx<GlobalKey<FormState>> offlineTokenRequestFormKey = GlobalKey<FormState>().obs;
  final Rx<GlobalKey<FormState>> offlineTokenCredentialsFormKey = GlobalKey<FormState>().obs;
  ScrollController scrollController = ScrollController();
  OTPInteractor otpInTractor = OTPInteractor();
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    try {
      showProgressIndicator();
      await offlineTokenController.getMainCategoryList(code: 'DSCOF', isLoaderShow: false);
      await offlineTokenController.getOfflineTokenCredentialsList(type: 'DSCTOKEN', pageNumber: 1, isLoaderShow: false);
      isShowTpinField.value = checkTpinRequired(categoryCode: 'OFFLINE');
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels && offlineTokenController.currentPage.value < offlineTokenController.totalPages.value) {
          offlineTokenController.currentPage.value++;
          await offlineTokenController.getOfflineTokenCredentialsList(
            type: 'DSCTOKEN',
            pageNumber: offlineTokenController.currentPage.value,
            isLoaderShow: false,
          );
        }
      });
      dismissProgressIndicator();
    } catch (e) {
      isShowTpinField.value = false;
      dismissProgressIndicator();
    }
  }

  Future<void> initController() async {
    if (Platform.isAndroid) {
      OTPTextEditController(
        codeLength: 6,
        onCodeReceive: (code) {
          offlineTokenController.showPasswordOtp.value = code;
          offlineTokenController.showPasswordAutoReadOtp.value = code;
          Get.log('\x1B[97m[OTP] => ${offlineTokenController.showPasswordOtp.value}\x1B[0m');
        },
        otpInteractor: otpInTractor,
      ).startListenUserConsent((code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      });
    }
  }

  @override
  void dispose() {
    offlineTokenController.resetOfflineTokenVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 7.h,
      title: 'Digital Signature Token',
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
                    if (offlineTokenController.selectedTabIndex.value != 0) {
                      offlineTokenController.selectedTabIndex.value = 0;
                    }
                  },
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: offlineTokenController.selectedTabIndex.value == 0 ? ColorsForApp.whiteColor : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Token Request',
                      style: TextHelper.size15.copyWith(
                        fontFamily: offlineTokenController.selectedTabIndex.value == 0 ? mediumGoogleSansFont : regularGoogleSansFont,
                        color: offlineTokenController.selectedTabIndex.value == 0 ? ColorsForApp.primaryColor : ColorsForApp.lightBlackColor,
                      ),
                    ),
                  ),
                ),
              ),
              // Credentials
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (offlineTokenController.selectedTabIndex.value != 1) {
                      offlineTokenController.selectedTabIndex.value = 1;
                    }
                  },
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: offlineTokenController.selectedTabIndex.value == 1 ? ColorsForApp.whiteColor : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Credentials',
                      style: TextHelper.size15.copyWith(
                        fontFamily: offlineTokenController.selectedTabIndex.value == 1 ? mediumGoogleSansFont : regularGoogleSansFont,
                        color: offlineTokenController.selectedTabIndex.value == 1 ? ColorsForApp.primaryColor : ColorsForApp.lightBlackColor,
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
        () => offlineTokenController.selectedTabIndex.value == 0
            ? digitalSignatureTokenRequestWidget(context)
            : offlineTokenController.isOfflineTokenCredentialsListLoading.value == true
                ? digitalSignatureTokenCredentialsDataShimmerWidget()
                : offlineTokenController.offlineTokenCredentialsList.isEmpty
                    ? notFoundText(text: 'No token credential found')
                    : digitalSignatureTokenCredentialsDataWidget(),
      ),
    );
  }

  // Digital signature token request widget
  Widget digitalSignatureTokenRequestWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Obx(
          () => Form(
            key: offlineTokenRequestFormKey.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(2.h),
                // Select company name
                CustomTextFieldWithTitle(
                  controller: offlineTokenController.selectedCompanyNameController,
                  title: 'Company Name',
                  hintText: 'Select company name',
                  isCompulsory: true,
                  readOnly: true,
                  onTap: () async {
                    if (Get.isSnackbarOpen) {
                      Get.back();
                    }
                    ProductChildCategoryModel selectedCompanyDetails = await Get.toNamed(
                      Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                      arguments: [
                        offlineTokenController.childCategoryList, // modelList
                        'tokenTypeList', // listType
                      ],
                    );
                    if (selectedCompanyDetails.id != null) {
                      offlineTokenController.selectedCompanyNameController.text = selectedCompanyDetails.name != null && selectedCompanyDetails.name!.isNotEmpty ? selectedCompanyDetails.name.toString() : '';
                      offlineTokenController.selectedProductNameController.clear();
                      offlineTokenController.selectedProductDescription.value = '';
                      offlineTokenController.selectedProductUniqueId.value = '';
                      offlineTokenController.numberOfTokenController.clear();
                      offlineTokenController.tokenValueController.clear();
                      offlineTokenController.totalAmountController.clear();
                      offlineTokenController.amountIntoWords.value = '';
                      bool result = await offlineTokenController.getProductDetails(childCategoryId: selectedCompanyDetails.id!);
                      if (result == false) {
                        errorSnackBar(message: 'Oops! Something went wrong. Please contact to administrator');
                      }
                    }
                  },
                  suffixIcon: GestureDetector(
                    onTap: () async {
                      if (Get.isSnackbarOpen) {
                        Get.back();
                      }
                      ProductChildCategoryModel selectedCompanyDetails = await Get.toNamed(
                        Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                        arguments: [
                          offlineTokenController.childCategoryList, // modelList
                          'tokenTypeList', // listType
                        ],
                      );
                      if (selectedCompanyDetails.id != null) {
                        offlineTokenController.selectedCompanyNameController.text = selectedCompanyDetails.name != null && selectedCompanyDetails.name!.isNotEmpty ? selectedCompanyDetails.name.toString() : '';
                        offlineTokenController.selectedProductNameController.clear();
                        offlineTokenController.selectedProductDescription.value = '';
                        offlineTokenController.selectedProductUniqueId.value = '';
                        offlineTokenController.numberOfTokenController.clear();
                        offlineTokenController.tokenValueController.clear();
                        offlineTokenController.totalAmountController.clear();
                        offlineTokenController.amountIntoWords.value = '';
                        bool result = await offlineTokenController.getProductDetails(childCategoryId: selectedCompanyDetails.id!);
                        if (result == false) {
                          errorSnackBar(message: 'Oops! Something went wrong. Please contact to administrator');
                        }
                      }
                    },
                    child: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: ColorsForApp.secondaryColor.withOpacity(0.5),
                    ),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please select company name';
                    }
                    return null;
                  },
                ),
                // Select product name
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Product Name',
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
                      controller: offlineTokenController.selectedProductNameController,
                      hintText: 'Select product name',
                      readOnly: true,
                      onTap: () async {
                        if (Get.isSnackbarOpen) {
                          Get.back();
                        }
                        AllProductListModel selectedProductDetails = await Get.toNamed(
                          Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                          arguments: [
                            offlineTokenController.productDetailsList, // modelList
                            'productDetailsList', // listType
                          ],
                        );
                        if (selectedProductDetails.id != null) {
                          offlineTokenController.selectedProductUniqueId.value = selectedProductDetails.unqId != null && selectedProductDetails.unqId!.isNotEmpty ? selectedProductDetails.unqId.toString() : '';
                          offlineTokenController.tokenValueController.text = selectedProductDetails.price != null ? selectedProductDetails.price!.toStringAsFixed(1) : '0.0';
                          offlineTokenController.selectedProductNameController.text = selectedProductDetails.name != null && selectedProductDetails.name!.isNotEmpty ? selectedProductDetails.name.toString() : '';
                          offlineTokenController.selectedProductDescription.value = selectedProductDetails.description != null && selectedProductDetails.description!.isNotEmpty ? selectedProductDetails.description.toString() : '';
                          offlineTokenController.minQuantity.value = selectedProductDetails.minQnty != null ? selectedProductDetails.minQnty! : 1;
                          offlineTokenController.maxQuantity.value = selectedProductDetails.maxQnty != null ? selectedProductDetails.maxQnty! : 1000;
                          offlineTokenController.numberOfTokenController.clear();
                          offlineTokenController.totalAmountController.clear();
                          offlineTokenController.amountIntoWords.value = '';
                        }
                      },
                      suffixIcon: GestureDetector(
                        onTap: () async {
                          if (Get.isSnackbarOpen) {
                            Get.back();
                          }
                          AllProductListModel selectedProductDetails = await Get.toNamed(
                            Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                            arguments: [
                              offlineTokenController.productDetailsList, // modelList
                              'productDetailsList', // listType
                            ],
                          );
                          if (selectedProductDetails.id != null) {
                            offlineTokenController.selectedProductUniqueId.value = selectedProductDetails.unqId != null && selectedProductDetails.unqId!.isNotEmpty ? selectedProductDetails.unqId.toString() : '';
                            offlineTokenController.tokenValueController.text = selectedProductDetails.price != null ? selectedProductDetails.price!.toStringAsFixed(1) : '0.0';
                            offlineTokenController.selectedProductNameController.text = selectedProductDetails.name != null && selectedProductDetails.name!.isNotEmpty ? selectedProductDetails.name.toString() : '';
                            offlineTokenController.selectedProductDescription.value = selectedProductDetails.description != null && selectedProductDetails.description!.isNotEmpty ? selectedProductDetails.description.toString() : '';
                            offlineTokenController.minQuantity.value = selectedProductDetails.minQnty != null ? selectedProductDetails.minQnty! : 1;
                            offlineTokenController.maxQuantity.value = selectedProductDetails.maxQnty != null ? selectedProductDetails.maxQnty! : 1000;
                            offlineTokenController.numberOfTokenController.clear();
                            offlineTokenController.totalAmountController.clear();
                            offlineTokenController.amountIntoWords.value = '';
                          }
                        },
                        child: Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: ColorsForApp.secondaryColor.withOpacity(0.5),
                        ),
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Please select product name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                // Selected product's description
                Visibility(
                  visible: offlineTokenController.selectedProductDescription.value.isNotEmpty ? true : false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(0.6.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Description: ',
                            style: TextHelper.size13.copyWith(
                              fontFamily: mediumGoogleSansFont,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              offlineTokenController.selectedProductDescription.value,
                              style: TextHelper.size13.copyWith(
                                color: ColorsForApp.greyColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                height(1.5.h),
                // Token value
                CustomTextFieldWithTitle(
                  controller: offlineTokenController.tokenValueController,
                  title: 'Token Value',
                  hintText: '0.0',
                  isCompulsory: true,
                  readOnly: true,
                  filled: true,
                  fillColor: ColorsForApp.lightGreyColor.withOpacity(0.5),
                ),
                // Number of token
                CustomTextFieldWithTitle(
                  controller: offlineTokenController.numberOfTokenController,
                  title: 'Number Of Token',
                  hintText: 'Enter number of token',
                  maxLength: offlineTokenController.maxQuantity.value.toString().length,
                  isCompulsory: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChange: (value) {
                    if (value!.isNotEmpty) {
                      if (offlineTokenController.tokenValueController.value.text.trim().isNotEmpty &&
                          (int.parse(offlineTokenController.numberOfTokenController.text) >= offlineTokenController.minQuantity.value && int.parse(offlineTokenController.numberOfTokenController.text) <= offlineTokenController.maxQuantity.value)) {
                        offlineTokenController.totalAmountController.text =
                            double.parse((double.parse(offlineTokenController.tokenValueController.text.trim()) * int.parse(offlineTokenController.numberOfTokenController.text)).toString()).toStringAsFixed(1);
                        if (offlineTokenController.totalAmountController.text.isNotEmpty) {
                          offlineTokenController.amountIntoWords.value = getAmountIntoWords(double.parse(offlineTokenController.totalAmountController.text.trim()).toInt());
                        } else {
                          offlineTokenController.amountIntoWords.value = '';
                        }
                      } else {
                        offlineTokenController.totalAmountController.clear();
                        offlineTokenController.amountIntoWords.value = '';
                      }
                    } else {
                      offlineTokenController.totalAmountController.clear();
                      offlineTokenController.amountIntoWords.value = '';
                    }
                  },
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please enter number of token';
                    } else if (int.parse(value) < offlineTokenController.minQuantity.value || int.parse(value) > offlineTokenController.maxQuantity.value) {
                      return 'Number of token should be between ${offlineTokenController.minQuantity.value} to ${offlineTokenController.maxQuantity.value}';
                    }
                    return null;
                  },
                ),
                // Total amount
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Total Amount',
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
                      controller: offlineTokenController.totalAmountController,
                      hintText: '0.0',
                      readOnly: true,
                      filled: true,
                      fillColor: ColorsForApp.lightGreyColor.withOpacity(0.5),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ],
                ),
                // Amount in text
                Visibility(
                  visible: offlineTokenController.amountIntoWords.value.isNotEmpty ? true : false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(0.6.h),
                      Text(
                        offlineTokenController.amountIntoWords.value,
                        style: TextHelper.size13.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.successColor,
                        ),
                      ),
                    ],
                  ),
                ),
                height(1.5.h),
                // TPIN
                Visibility(
                  visible: isShowTpinField.value,
                  child: Obx(
                    () => CustomTextFieldWithTitle(
                      controller: offlineTokenController.tPinController,
                      title: 'TPIN',
                      hintText: 'Enter TPIN',
                      maxLength: 4,
                      isCompulsory: true,
                      obscureText: offlineTokenController.isHideTpin.value,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      suffixIcon: IconButton(
                        icon: Icon(
                          offlineTokenController.isHideTpin.value ? Icons.visibility : Icons.visibility_off,
                          size: 18,
                          color: ColorsForApp.secondaryColor.withOpacity(0.5),
                        ),
                        onPressed: () {
                          offlineTokenController.isHideTpin.value = !offlineTokenController.isHideTpin.value;
                        },
                      ),
                      validator: (value) {
                        if (offlineTokenController.tPinController.text.trim().isEmpty) {
                          return 'Please enter TPIN';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                height(1.h),
                // Purchase button
                CommonButton(
                  label: 'Purchase',
                  onPressed: () async {
                    // Unfocus text-field
                    FocusScope.of(context).unfocus();
                    if (Get.isSnackbarOpen) {
                      Get.back();
                    }
                    if (offlineTokenRequestFormKey.value.currentState!.validate()) {
                      if (offlineTokenController.tokenValueController.text.trim().isEmpty || offlineTokenController.totalAmountController.text.trim().isEmpty) {
                        errorSnackBar(message: 'Oops! Something went wrong. Please contact to administrator');
                      } else {
                        bool result = await offlineTokenController.offlineTokenOrderRequest();
                        if (result == true) {
                          offlineTokenController.resetOfflineTokenVariables();
                          offlineTokenRequestFormKey.value = GlobalKey<FormState>();
                        }
                      }
                    }
                  },
                ),
                height(2.h),
                // Report button
                CommonButton(
                  bgColor: ColorsForApp.whiteColor,
                  border: Border.all(
                    color: ColorsForApp.primaryColor,
                  ),
                  labelColor: ColorsForApp.primaryColor,
                  label: 'Purchase Token Report',
                  onPressed: () async {
                    // Unfocus text-field
                    FocusScope.of(context).unfocus();
                    if (Get.isSnackbarOpen) {
                      Get.back();
                    }
                    Get.toNamed(Routes.OFFLINE_TOKEN_REPORT_SCREEN);
                  },
                ),
                height(3.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Digital signature token credentials data shimmer widget
  Widget digitalSignatureTokenCredentialsDataShimmerWidget() {
    return ListView.separated(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return customCard(
          child: Shimmer.fromColors(
            baseColor: ColorsForApp.shimmerBaseColor,
            highlightColor: ColorsForApp.shimmerHighlightColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(1.5.h),
                      // Status | UTI protal button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Status
                          Container(
                            height: 2.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          // UTI protal button
                          Container(
                            height: 3.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
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
                      // Company name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1.5.h,
                            width: 20.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          width(10),
                          Container(
                            height: 1.5.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      height(0.8.h),
                      // Username
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1.5.h,
                            width: 10.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          width(10),
                          Container(
                            height: 1.5.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      height(0.8.h),
                      // Remark
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 1.5.h,
                            width: 10.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          width(10),
                          Container(
                            height: 1.5.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: ColorsForApp.greyColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ],
                      ),
                      height(0.8.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return height(0.5.h);
      },
    );
  }

  // Digital signature token credentials data widget
  Widget digitalSignatureTokenCredentialsDataWidget() {
    return RefreshIndicator(
      color: ColorsForApp.primaryColor,
      onRefresh: () async {
        isLoading.value = true;
        await Future.delayed(const Duration(seconds: 1), () async {
          await offlineTokenController.getOfflineTokenCredentialsList(
            type: 'DSCTOKEN',
            pageNumber: 1,
            isLoaderShow: false,
          );
        });
        isLoading.value = false;
      },
      child: ListView.separated(
        controller: scrollController,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        itemCount: offlineTokenController.offlineTokenCredentialsList.length,
        itemBuilder: (context, index) {
          if (index == offlineTokenController.offlineTokenCredentialsList.length - 1 && offlineTokenController.hasNext.value) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorsForApp.primaryColor,
              ),
            );
          } else {
            OfflineTokenCredentialsData digitalSignatureTokenCredentialsData = offlineTokenController.offlineTokenCredentialsList[index];
            return customCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        height(1.5.h),
                        // Id | UTI portal login button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Id
                            Text(
                              'Id : ',
                              style: TextHelper.size13.copyWith(
                                fontFamily: mediumGoogleSansFont,
                                color: ColorsForApp.greyColor,
                              ),
                            ),
                            width(5),
                            Expanded(
                              child: Text(
                                digitalSignatureTokenCredentialsData.id != null ? digitalSignatureTokenCredentialsData.id!.toString() : '-',
                                textAlign: TextAlign.start,
                                style: TextHelper.size13.copyWith(
                                  color: ColorsForApp.lightBlackColor,
                                ),
                              ),
                            ),
                            // Portal login button
                            InkWell(
                              onTap: () {
                                if (digitalSignatureTokenCredentialsData.loginUrl != null && digitalSignatureTokenCredentialsData.loginUrl!.isNotEmpty) {
                                  openUrl(url: digitalSignatureTokenCredentialsData.loginUrl.toString());
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorsForApp.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Text(
                                  digitalSignatureTokenCredentialsData.serviceName != null && digitalSignatureTokenCredentialsData.serviceName!.isNotEmpty ? '${digitalSignatureTokenCredentialsData.serviceName!} Portal Login' : 'Portal Login',
                                  style: TextHelper.size13.copyWith(
                                    fontFamily: mediumGoogleSansFont,
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
                        // Company name
                        customKeyValueText(
                          key: 'Company Name : ',
                          value: digitalSignatureTokenCredentialsData.serviceName != null && digitalSignatureTokenCredentialsData.serviceName!.isNotEmpty ? digitalSignatureTokenCredentialsData.serviceName!.toString() : '-',
                        ),
                        // Name
                        customKeyValueText(
                          key: 'Name : ',
                          value: digitalSignatureTokenCredentialsData.userName != null && digitalSignatureTokenCredentialsData.userName!.isNotEmpty ? digitalSignatureTokenCredentialsData.userName!.toString() : '-',
                        ),
                        // Username
                        customKeyValueText(
                          key: 'Username : ',
                          value: digitalSignatureTokenCredentialsData.login != null && digitalSignatureTokenCredentialsData.login!.isNotEmpty ? digitalSignatureTokenCredentialsData.login!.toString() : '-',
                        ),
                        // Password
                        Obx(
                          () => customKeyValueText(
                            key: 'Password : ',
                            value: digitalSignatureTokenCredentialsData.password != null && digitalSignatureTokenCredentialsData.password!.isNotEmpty
                                ? digitalSignatureTokenCredentialsData.isShowPassword!.value == true
                                    ? digitalSignatureTokenCredentialsData.password != null && digitalSignatureTokenCredentialsData.password!.isNotEmpty
                                        ? digitalSignatureTokenCredentialsData.password!.toString()
                                        : ''
                                    : digitalSignatureTokenCredentialsData.maskedPassword != null && digitalSignatureTokenCredentialsData.maskedPassword!.isNotEmpty
                                        ? digitalSignatureTokenCredentialsData.maskedPassword!.toString()
                                        : ''
                                : '-',
                          ),
                        ),
                        // Reset password status
                        customKeyValueText(
                          key: 'Reset Password Status : ',
                          value: digitalSignatureTokenCredentialsData.resetPinStatus != null ? offlineTokenController.tokenCredentialsResetPinStatus(digitalSignatureTokenCredentialsData.resetPinStatus!) : '-',
                        ),
                        // Remark
                        customKeyValueText(
                          key: 'Remark : ',
                          value: digitalSignatureTokenCredentialsData.remark != null && digitalSignatureTokenCredentialsData.remark!.isNotEmpty ? digitalSignatureTokenCredentialsData.remark!.toString() : '-',
                        ),
                      ],
                    ),
                  ),
                  height(0.5.h),
                  // Copy link | Reset Password
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Show password | copy/copied password
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              if (Get.isSnackbarOpen) {
                                Get.back();
                              }
                              if (digitalSignatureTokenCredentialsData.password != null && digitalSignatureTokenCredentialsData.password!.isNotEmpty) {
                                if (digitalSignatureTokenCredentialsData.isShowPassword!.value == false) {
                                  // Show otp bottomsheep for otp
                                  bool result = await offlineTokenController.generateShowPasswordOtp(uniqueId: digitalSignatureTokenCredentialsData.unqID!);
                                  if (result == true) {
                                    showPasswordOtpBottomSheet(pancardTokenCredentialsData: digitalSignatureTokenCredentialsData);
                                  }
                                } else {
                                  if (digitalSignatureTokenCredentialsData.isPasswordCopied!.value == false) {
                                    vibrateDevice();
                                    Clipboard.setData(
                                      ClipboardData(text: digitalSignatureTokenCredentialsData.password.toString()),
                                    );
                                    digitalSignatureTokenCredentialsData.isPasswordCopied!.value = true;
                                    Future.delayed(const Duration(seconds: 1), () {
                                      digitalSignatureTokenCredentialsData.isPasswordCopied!.value = false;
                                    });
                                  }
                                }
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              decoration: BoxDecoration(
                                color: digitalSignatureTokenCredentialsData.isShowPassword!.value == true
                                    ? digitalSignatureTokenCredentialsData.isPasswordCopied!.value == true
                                        ? ColorsForApp.successColor
                                        : ColorsForApp.primaryColor
                                    : ColorsForApp.primaryColor,
                                border: Border.all(
                                  color: digitalSignatureTokenCredentialsData.isShowPassword!.value == true
                                      ? digitalSignatureTokenCredentialsData.isPasswordCopied!.value == true
                                          ? ColorsForApp.successColor
                                          : ColorsForApp.primaryColor
                                      : ColorsForApp.primaryColor,
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    digitalSignatureTokenCredentialsData.isShowPassword!.value == true ? Icons.copy_rounded : Icons.visibility,
                                    size: 16,
                                    color: ColorsForApp.whiteColor,
                                  ),
                                  width(5),
                                  Text(
                                    digitalSignatureTokenCredentialsData.isShowPassword!.value == true
                                        ? digitalSignatureTokenCredentialsData.isPasswordCopied!.value == true
                                            ? 'Password Copied'
                                            : 'Copy Password'
                                        : 'Show Password',
                                    style: TextHelper.size12.copyWith(
                                      fontFamily: mediumGoogleSansFont,
                                      color: ColorsForApp.whiteColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Reset Password
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              showProgressIndicator();
                              bool result = await offlineTokenController.generateResetPasswordRequest(
                                uniqueId: digitalSignatureTokenCredentialsData.unqID ?? '',
                                isLoaderShow: false,
                              );
                              if (result == true) {
                                await offlineTokenController.getOfflineTokenCredentialsList(
                                  type: 'DSCTOKEN',
                                  pageNumber: 1,
                                  isLoaderShow: false,
                                );
                                successSnackBar(message: offlineTokenController.generateResetPasswordRequestModel.value.message!);
                              }
                              dismissProgressIndicator();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              decoration: BoxDecoration(
                                color: ColorsForApp.whiteColor,
                                border: Border.all(
                                  color: ColorsForApp.primaryColor,
                                ),
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh_rounded,
                                    size: 16,
                                    color: ColorsForApp.primaryColor,
                                  ),
                                  width(5),
                                  Text(
                                    'Reset Password',
                                    style: TextHelper.size12.copyWith(
                                      fontFamily: mediumGoogleSansFont,
                                      color: ColorsForApp.primaryColor,
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
                ],
              ),
            );
          }
        },
        separatorBuilder: (context, index) {
          return height(0.5.h);
        },
      ),
    );
  }

  // OTP Verification bottom sheet
  Future showPasswordOtpBottomSheet({required OfflineTokenCredentialsData pancardTokenCredentialsData}) {
    offlineTokenController.startShowPasswordTimer();
    initController();
    return customBottomSheet(
      enableDrag: false,
      isDismissible: false,
      preventToClose: false,
      isScrollControlled: true,
      children: [
        Text(
          'Verify Your OTP',
          style: TextHelper.size20.copyWith(
            fontFamily: boldGoogleSansFont,
            color: ColorsForApp.lightBlackColor,
          ),
        ),
        height(10),
        Text(
          'Please enter the verification code that has been sent to your mobile number.',
          style: TextHelper.size15.copyWith(
            color: ColorsForApp.hintColor,
          ),
        ),
        height(20),
        Obx(
          () => Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: CustomOtpTextField(
              otpList: offlineTokenController.showPasswordAutoReadOtp.isNotEmpty && offlineTokenController.showPasswordAutoReadOtp.value != '' ? offlineTokenController.showPasswordAutoReadOtp.split('') : [],
              numberOfFields: 6,
              height: 40,
              width: 35,
              contentPadding: const EdgeInsets.all(7),
              clearText: offlineTokenController.clearShowPasswordOtp.value,
              onChanged: (value) {
                offlineTokenController.clearShowPasswordOtp.value = false;
                offlineTokenController.showPasswordOtp.value = value;
              },
            ),
          ),
        ),
        height(1.5.h),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                offlineTokenController.isShowPasswordResendButtonShow.value == true ? 'Didn\'t received OTP? ' : 'Resend OTP in ',
                style: TextHelper.size14,
              ),
              Container(
                alignment: Alignment.center,
                child: offlineTokenController.isShowPasswordResendButtonShow.value == true
                    ? GestureDetector(
                        onTap: () async {
                          // Unfocus text-field
                          FocusScope.of(context).unfocus();
                          if (offlineTokenController.isShowPasswordResendButtonShow.value == true) {
                            bool result = await offlineTokenController.resendShowPasswordOtp();
                            if (result == true) {
                              successSnackBar(message: offlineTokenController.resendShowPasswordOtpModel.value.message);
                              initController();
                              offlineTokenController.resetShowPasswordTimer();
                              offlineTokenController.startShowPasswordTimer();
                            }
                          }
                        },
                        child: Text(
                          'Resend',
                          style: TextHelper.size14.copyWith(
                            fontFamily: boldGoogleSansFont,
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                      )
                    : Text(
                        '${(offlineTokenController.showPasswordTotalSecond.value ~/ 60).toString().padLeft(2, '0')}:${(offlineTokenController.showPasswordTotalSecond.value % 60).toString().padLeft(2, '0')}',
                        style: TextHelper.size14.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
      customButtons: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CommonButton(
              onPressed: () {
                Get.back();
                offlineTokenController.resetShowPasswordTimer();
              },
              label: 'Cancel',
              labelColor: ColorsForApp.primaryColor,
              bgColor: ColorsForApp.whiteColor,
              border: Border.all(
                color: ColorsForApp.primaryColor,
              ),
            ),
          ),
          width(3.w),
          Expanded(
            child: CommonButton(
              onPressed: () async {
                if (offlineTokenController.showPasswordOtp.value.isEmpty || offlineTokenController.showPasswordOtp.value.contains('null') || offlineTokenController.showPasswordOtp.value.length < 6) {
                  errorSnackBar(message: 'Please enter OTP');
                } else {
                  showProgressIndicator();
                  bool result = await offlineTokenController.validateShowPasswordOtp(
                    uniqueId: pancardTokenCredentialsData.unqID!,
                    isLoaderShow: false,
                  );
                  if (result == true) {
                    offlineTokenController.resetShowPasswordTimer();
                    pancardTokenCredentialsData.isShowPassword!.value = true;
                    pancardTokenCredentialsData.password = offlineTokenController.validateShowPasswordOtpModel.value.password;
                    Get.back();
                    successSnackBar(message: offlineTokenController.validateShowPasswordOtpModel.value.message);
                  }
                  dismissProgressIndicator();
                }
              },
              label: 'Verify',
            ),
          ),
        ],
      ),
    );
  }
}

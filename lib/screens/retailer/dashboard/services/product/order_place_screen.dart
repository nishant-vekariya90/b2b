import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/product_controller.dart';
import '../../../../../model/auth/adress_by_pincode_model.dart';
import '../../../../../model/auth/cities_model.dart';
import '../../../../../model/auth/states_model.dart';
import '../../../../../model/category_for_tpin_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field_with_title.dart';

class OrderPlaceScreen extends StatefulWidget {
  const OrderPlaceScreen({super.key});

  @override
  State<OrderPlaceScreen> createState() => _OrderPlaceScreenState();
}

class _OrderPlaceScreenState extends State<OrderPlaceScreen> {
  final ProductController productController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await productController.getStatesAPI();
      CategoryForTpinModel categoryForTpinModel = categoryForTpinList.firstWhere((element) => element.code != null && element.code!.toLowerCase() == 'product');
      productController.isShowTpinField.value = categoryForTpinModel.isTpin!;
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        productController.resetProductDetailsVariables();
        Get.back();
        return true;
      },
      child: CustomScaffold(
        title: 'Address Details',
        appBarHeight: 13.h,
        isShowLeadingIcon: true,
        onBackIconTap: () {
          productController.resetProductDetailsVariables();
          Get.back();
        },
        mainBody: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Form(
            key: formKey,
            child: addressForm(context),
          ),
        ),
      ),
    );
  }

  Widget addressForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        height(2.h),
        // Name
        CustomTextFieldWithTitle(
          controller: productController.nameTxtController,
          title: 'Name',
          hintText: 'Enter name',
          maxLength: 200,
          isCompulsory: true,
          // readOnly: userData.name!=null?true:false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          textInputFormatter: [
            FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
          ],
          validator: (value) {
            if (productController.nameTxtController.text.trim().isEmpty) {
              return 'Please enter name';
            } else if (productController.nameTxtController.text.length < 3) {
              return 'Please enter valid name';
            }
            return null;
          },
          suffixIcon: Icon(
            Icons.person,
            size: 18,
            color: ColorsForApp.secondaryColor,
          ),
        ),
        // Mobile number
        CustomTextFieldWithTitle(
          controller: productController.mobileTxtController,
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
            if (productController.mobileTxtController.text.trim().isEmpty) {
              return 'Please enter mobile number';
            } else if (productController.mobileTxtController.text.length < 10) {
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
        // Alternative mobile number
        CustomTextFieldWithTitle(
          controller: productController.altMobileTxtController,
          title: 'Alternative Mobile Number',
          hintText: 'Enter alternative mobile number',
          maxLength: 10,
          isCompulsory: false,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          textInputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          validator: (value) {
            if (value!.isNotEmpty) {
              if (productController.mobileTxtController.text == value) {
                return 'Mobile number and alternative number must be different';
              } else if (productController.altMobileTxtController.text.length < 10) {
                return 'Please enter valid mobile number';
              }
              return null;
            }
            return null;
          },
          suffixIcon: Icon(
            Icons.call,
            size: 18,
            color: ColorsForApp.secondaryColor,
          ),
        ),
        // Email
        CustomTextFieldWithTitle(
          controller: productController.emailTxtController,
          title: 'Email',
          hintText: 'Enter email',
          isCompulsory: true,
          //readOnly: userData.email!=null?true:false,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (productController.emailTxtController.text.trim().isEmpty) {
              return 'Please enter email';
            } else if (!GetUtils.isEmail(productController.emailTxtController.text.trim())) {
              return 'Please enter a valid email';
            }
            return null;
          },
          suffixIcon: Icon(
            Icons.email,
            size: 18,
            color: ColorsForApp.secondaryColor,
          ),
        ),
        // Address
        CustomTextFieldWithTitle(
          controller: productController.addressTxtController,
          title: 'Address',
          hintText: 'Enter address',
          isCompulsory: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (productController.addressTxtController.text.trim().isEmpty) {
              return 'Please enter address';
            }
            return null;
          },
          suffixIcon: Icon(
            Icons.home,
            size: 18,
            color: ColorsForApp.secondaryColor,
          ),
        ),
        // Address 2
        CustomTextFieldWithTitle(
          controller: productController.address2TxtController,
          title: 'Address line2',
          hintText: 'Enter address line2',
          isCompulsory: false,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          /*validator: (value) {
                  if (productController.address2TxtController.text.trim().isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },*/
          suffixIcon: Icon(
            Icons.home,
            size: 18,
            color: ColorsForApp.secondaryColor,
          ),
        ),
        // House no
        CustomTextFieldWithTitle(
          controller: productController.houseNumberTxtController,
          title: 'House No',
          hintText: 'Enter house no',
          isCompulsory: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (productController.houseNumberTxtController.text.trim().isEmpty) {
              return 'Please enter house no';
            }
            return null;
          },
          suffixIcon: Icon(
            Icons.home,
            size: 18,
            color: ColorsForApp.secondaryColor,
          ),
        ),
        // PinCode
        CustomTextFieldWithTitle(
          controller: productController.pinCodeTxtController,
          title: 'Pincode',
          hintText: 'Select pincode',
          keyboardType: TextInputType.number,
          maxLength: 6,
          isCompulsory: true,
          onChange: (value) async {
            // fetch address using pinCode
            if (value!.length >= 6) {
              bool result = await productController.getStateCityByPinCodeAPI(isLoaderShow: true, pinCode: productController.pinCodeTxtController.text);
              if (result == true) {
                // set district data
                productController.districtTxtController.text = productController.getCityStateBlockData.value.data!.blockName!;
                // set state data
                productController.stateTxtController.text = productController.getCityStateBlockData.value.data!.stateName!;
                productController.selectedStateId.value = productController.getCityStateBlockData.value.data!.stateID!.toString();
                // set city data
                productController.cityTxtController.text = productController.getCityStateBlockData.value.data!.cityName!;
                productController.selectedCityId.value = productController.getCityStateBlockData.value.data!.cityID!.toString();
              }
            } else {
              productController.getCityStateBlockData.value.data = StateCityBlockDataModel();
              productController.stateTxtController.clear();
              productController.cityTxtController.clear();
              productController.selectedStateId.value = '';
              productController.selectedCityId.value = '';
            }
          },
          suffixIcon: Icon(
            Icons.location_on_rounded,
            size: 18,
            color: ColorsForApp.secondaryColor,
          ),
        ),
        // State txt
        CustomTextFieldWithTitle(
          controller: productController.stateTxtController,
          title: 'State',
          hintText: 'Select state',
          isCompulsory: true,
          readOnly: true,
          onTap: () async {
            //Check If we got state ,city,block from pinCode then dropdown should be disable
            StatesModel selectedState = await Get.toNamed(
              Routes.SEARCHABLE_LIST_VIEW_SCREEN,
              arguments: [
                productController.statesList, // modelList
                'statesList', // modelName
              ],
            );
            if (selectedState.name != null && selectedState.name!.isNotEmpty) {
              productController.stateTxtController.text = selectedState.name!;
              productController.selectedStateId.value = selectedState.id!.toString();
              await productController.getCitiesAPI();
            }
          },
          suffixIcon: Icon(
            Icons.location_on_rounded,
            size: 18,
            color: ColorsForApp.secondaryColor,
          ),
        ),
        // District txt
        CustomTextFieldWithTitle(
          controller: productController.districtTxtController,
          title: 'District',
          hintText: 'Select state',
          isCompulsory: true,
          readOnly: false,
          suffixIcon: Icon(
            Icons.location_on_rounded,
            size: 18,
            color: ColorsForApp.secondaryColor,
          ),
        ),
        // City txt
        CustomTextFieldWithTitle(
          controller: productController.cityTxtController,
          title: 'City',
          hintText: 'Select city',
          isCompulsory: true,
          readOnly: true,
          onTap: () async {
            //Check If we got state ,city,block from pinCode then dropdown should be disable
            CitiesModel selectedCity = await Get.toNamed(
              Routes.SEARCHABLE_LIST_VIEW_SCREEN,
              arguments: [
                productController.citiesList, // modelList
                'citiesList', // modelName
              ],
            );
            if (selectedCity.name != null && selectedCity.name!.isNotEmpty) {
              productController.cityTxtController.text = selectedCity.name!;
              productController.selectedCityId.value = selectedCity.id!.toString();
            }
          },
          suffixIcon: Icon(
            Icons.location_on_rounded,
            size: 18,
            color: ColorsForApp.secondaryColor,
          ),
        ),
        CommonButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                orderConfirmationBottomSheet(context: context);
              }
            },
            label: 'Proceed'),
        height(1.h),
      ],
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
            height(5),
            Obx(
              () => Align(
                alignment: Alignment.center,
                child: Text(
                  '₹ ${productController.totalPrice.value}',
                  style: TextHelper.h1.copyWith(
                    fontFamily: mediumGoogleSansFont,
                    color: ColorsForApp.primaryColor,
                  ),
                ),
              ),
            ),
            height(5),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product Name: ${productController.productNameController.text}',
                    style: TextHelper.size15.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                  Text(
                    'Oty: ${productController.quantity.value}',
                    style: TextHelper.size15.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            height(5),
            // TPIN
            Visibility(
              visible: productController.isShowTpinField.value,
              child: Obx(
                () => CustomTextFieldWithTitle(
                  controller: productController.tPinTxtController,
                  title: 'TPIN',
                  hintText: 'Enter TPIN',
                  maxLength: 4,
                  isCompulsory: true,
                  obscureText: productController.isShowTpin.value,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    icon: Icon(
                      productController.isShowTpin.value ? Icons.visibility : Icons.visibility_off,
                      size: 18,
                      color: ColorsForApp.secondaryColor,
                    ),
                    onPressed: () {
                      productController.isShowTpin.value = !productController.isShowTpin.value;
                    },
                  ),
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (productController.tPinTxtController.text.trim().isEmpty) {
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
                if (productController.isShowTpinField.value == true) {
                  if (productController.tPinTxtController.text.trim().isEmpty) {
                    errorSnackBar(message: 'Please enter TPIN');
                  } else {
                    if (isInternetAvailable.value) {
                      if (Get.isSnackbarOpen) {
                        Get.back();
                      }
                      Get.back();
                      productController.orderStatus.value = -1;
                      await Get.toNamed(
                        Routes.ORDER_STATUS_SCREEN,
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
                    productController.orderStatus.value = -1;
                    await Get.toNamed(
                      Routes.ORDER_STATUS_SCREEN,
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

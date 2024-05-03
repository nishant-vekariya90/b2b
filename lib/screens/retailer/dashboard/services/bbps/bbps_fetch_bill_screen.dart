import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/retailer/bbps_controller.dart';
import '../../../../../model/bbps/bbps_operator_grouping_list_model.dart';
import '../../../../../model/bbps/bbps_parameters_list_model.dart';
import '../../../../../model/bbps/bbps_sub_category_list_model.dart';
import '../../../../../model/bbps/fetch_bill_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field.dart';
import '../../../../../widgets/text_field_with_title.dart';

class BBPSFetchBillPage extends StatefulWidget {
  const BBPSFetchBillPage({super.key});

  @override
  State<BBPSFetchBillPage> createState() => _BBPSFetchBillPageState();
}

class _BBPSFetchBillPageState extends State<BBPSFetchBillPage> {
  BbpsController bbpsController = Get.find();
  BbpsSubCategoryListModel selectedBbpsSubCategory = Get.arguments;
  final Rx<GlobalKey<FormState>> bbpsKey = GlobalKey<FormState>().obs;
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await bbpsController.getBbpsParametersFieldList(operatorId: selectedBbpsSubCategory.id!);
      isShowTpinField.value = checkTpinRequired(categoryCode: 'BBPS');
    } catch (e) {
      isShowTpinField.value = false;
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    bbpsController.agentMobileNumberController.clear();
    bbpsController.tPinController.clear();
    bbpsController.bbpsParametersFieldList.clear();
    bbpsController.bbpsGroupingList.clear();
    bbpsController.valueControllers.clear();
    bbpsController.selectedGroupingValueControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: selectedBbpsSubCategory.name != null && selectedBbpsSubCategory.name!.isNotEmpty ? selectedBbpsSubCategory.name!.toString() : '-',
      isShowLeadingIcon: true,
      mainBody: Obx(
        () => bbpsController.bbpsParametersFieldList.isNotEmpty
            ? Form(
                key: bbpsKey.value,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(2.h),
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bbpsController.bbpsParametersFieldList.length,
                        itemBuilder: (context, index) {
                          BbpsParametersListModel bbpsParametersListData = bbpsController.bbpsParametersFieldList[index];
                          return bbpsParametersListData.hasGrouping == true
                              // Dropdown/Textfield for hasGrouping
                              ? bbpsController.bbpsGroupingList.isNotEmpty
                                  // Dropdown for hasGrouping
                                  ? CustomTextFieldWithTitle(
                                      controller: bbpsController.selectedGroupingValueControllers[index],
                                      title: bbpsParametersListData.name,
                                      hintText: 'Select ${bbpsParametersListData.name}',
                                      readOnly: true,
                                      isCompulsory: bbpsParametersListData.ismandatory,
                                      onTap: () async {
                                        BbpsOperatorGroupingListModel operatorGrouping = await Get.toNamed(
                                          Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                                          arguments: [
                                            bbpsController.bbpsGroupingList, // modelList
                                            'operatorGroupingList', // listType
                                          ],
                                        );
                                        if (operatorGrouping.name != null && operatorGrouping.name!.isNotEmpty) {
                                          bbpsController.selectedGroupingValueControllers[index].text = operatorGrouping.name!;
                                          bbpsController.valueControllers[index].text = operatorGrouping.value!;
                                        }
                                      },
                                      suffixIcon: GestureDetector(
                                        onTap: () async {
                                          BbpsOperatorGroupingListModel operatorGrouping = await Get.toNamed(
                                            Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                                            arguments: [
                                              bbpsController.bbpsGroupingList, // modelList
                                              'operatorGroupingList', // listType
                                            ],
                                          );
                                          if (operatorGrouping.name != null && operatorGrouping.name!.isNotEmpty) {
                                            bbpsController.selectedGroupingValueControllers[index].text = operatorGrouping.name!;
                                            bbpsController.valueControllers[index].text = operatorGrouping.value!;
                                          }
                                        },
                                        child: Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          color: ColorsForApp.greyColor,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (bbpsParametersListData.ismandatory == true && bbpsController.selectedGroupingValueControllers[index].text.trim().isEmpty) {
                                          return 'Please select ${bbpsParametersListData.name!.toLowerCase()}';
                                        }
                                        return null;
                                      },
                                    )
                                  // Textfield for hasGrouping
                                  : bbpsParametersListData.maxlength! > 0
                                      ? CustomTextFieldWithTitle(
                                          controller: bbpsController.valueControllers[index],
                                          title: bbpsParametersListData.name,
                                          hintText: 'Enter ${bbpsParametersListData.name}',
                                          isCompulsory: bbpsParametersListData.ismandatory,
                                          minLength: bbpsParametersListData.minlength,
                                          maxLength: bbpsParametersListData.maxlength,
                                          keyboardType: bbpsParametersListData.fieldtype!.toLowerCase() == 'text' || bbpsParametersListData.fieldtype!.toLowerCase() == 'input' ? TextInputType.text : TextInputType.number,
                                          textInputFormatter: [
                                            FilteringTextInputFormatter.allow(RegExp(bbpsParametersListData.pattern!)),
                                          ],
                                          textInputAction: index == bbpsController.bbpsParametersFieldList.length - 1 ? TextInputAction.done : TextInputAction.next,
                                          validator: (value) {
                                            if (bbpsParametersListData.ismandatory == true) {
                                              if (bbpsController.valueControllers[index].text.isEmpty && bbpsParametersListData.minlength != 0) {
                                                return 'Please enter ${bbpsParametersListData.name!.toLowerCase()}';
                                              } else if (bbpsParametersListData.minlength! > 0 && bbpsController.valueControllers[index].text.length < bbpsParametersListData.minlength!) {
                                                return 'Please enter valid ${bbpsParametersListData.name!.toLowerCase()}';
                                              } else if (bbpsParametersListData.maxlength! > 0 && bbpsController.valueControllers[index].text.length > bbpsParametersListData.maxlength!) {
                                                return 'Please enter valid ${bbpsParametersListData.name!.toLowerCase()}';
                                              }
                                            }
                                            return null;
                                          },
                                        )
                                      : Container()
                              // For textfield
                              : bbpsParametersListData.maxlength! > 0 && bbpsController.valueControllers.isNotEmpty
                                  ? CustomTextFieldWithTitle(
                                      controller: bbpsController.valueControllers[index],
                                      title: '${bbpsParametersListData.name}',
                                      hintText: 'Enter ${bbpsParametersListData.name}',
                                      isCompulsory: bbpsParametersListData.ismandatory,
                                      minLength: bbpsParametersListData.minlength,
                                      maxLength: bbpsParametersListData.maxlength,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: bbpsParametersListData.fieldtype!.toLowerCase() == 'text' || bbpsParametersListData.fieldtype!.toLowerCase() == 'input' ? TextInputType.text : TextInputType.number,
                                      textInputFormatter: bbpsParametersListData.pattern != null && bbpsParametersListData.pattern!.isNotEmpty
                                          ? [
                                              FilteringTextInputFormatter.allow(RegExp(bbpsParametersListData.pattern!)),
                                            ]
                                          : [],
                                      validator: (value) {
                                        if (bbpsParametersListData.ismandatory == true) {
                                          if (bbpsController.valueControllers[index].text.isEmpty && bbpsParametersListData.minlength != 0) {
                                            return 'Please enter ${bbpsParametersListData.name!.toLowerCase()}';
                                          } else if (bbpsParametersListData.minlength! > 0 && bbpsController.valueControllers[index].text.length < bbpsParametersListData.minlength!) {
                                            return 'Please enter valid ${bbpsParametersListData.name!.toLowerCase()}';
                                          } else if (bbpsParametersListData.maxlength! > 0 && bbpsController.valueControllers[index].text.length > bbpsParametersListData.maxlength!) {
                                            return 'Please enter valid ${bbpsParametersListData.name!.toLowerCase()}';
                                          }
                                        }
                                        return null;
                                      },
                                    )
                                  : Container();
                        },
                      ),
                      // Agent mobile number
                      CustomTextFieldWithTitle(
                        controller: bbpsController.agentMobileNumberController,
                        title: 'Agent mobile number',
                        hintText: 'Enter agent mobile number',
                        maxLength: 10,
                        isCompulsory: true,
                        textInputAction: isShowTpinField.value ? TextInputAction.next : TextInputAction.done,
                        textInputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        suffixIcon: Icon(
                          Icons.call_rounded,
                          size: 18,
                          color: ColorsForApp.stepBorderColor,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (bbpsController.agentMobileNumberController.text.trim().isEmpty) {
                            return 'Please enter mobile number';
                          } else if (bbpsController.agentMobileNumberController.text.trim().length != 10) {
                            return 'Please enter valid mobile number';
                          }
                          return null;
                        },
                      ),
                      Visibility(
                        visible: selectedBbpsSubCategory.isPartial == true ? true : false,
                        child: CustomTextFieldWithTitle(
                          controller: bbpsController.amountController,
                          title: 'Amount',
                          hintText: 'Enter amount',
                          isCompulsory: true,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          textInputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          suffixIcon: Icon(
                            Icons.attach_money_outlined,
                            size: 18,
                            color: ColorsForApp.stepBorderColor,
                          ),
                          validator: (value) {
                            if (bbpsController.amountController.text.trim().isEmpty) {
                              return 'Please enter amount';
                            }
                            return null;
                          },
                        ),
                      ),
                      // Tpin
                      Visibility(
                        visible: isShowTpinField.value,
                        child: CustomTextFieldWithTitle(
                          controller: bbpsController.tPinController,
                          title: 'TPIN',
                          hintText: 'Enter your TPIN',
                          obscureText: bbpsController.isHideTPIN.value,
                          maxLength: 4,
                          isCompulsory: true,
                          textInputAction: TextInputAction.done,
                          suffixIcon: IconButton(
                            icon: Icon(
                              bbpsController.isHideTPIN.value ? Icons.visibility_off : Icons.visibility,
                              size: 18,
                              color: ColorsForApp.secondaryColor,
                            ),
                            onPressed: () {
                              bbpsController.isHideTPIN.value = !bbpsController.isHideTPIN.value;
                            },
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (bbpsController.tPinController.text.trim().isEmpty) {
                              return 'Please enter TPIN';
                            }
                            // else if (bbpsController.tPinController.text.length < 4) {
                            //   return 'Please enter valid TPIN';
                            // }
                            return null;
                          },
                        ),
                      ),
                      height(10),
                      // Proceed button
                      CommonButton(
                        bgColor: ColorsForApp.primaryColor,
                        labelColor: ColorsForApp.whiteColor,
                        label: 'Proceed',
                        onPressed: () async {
                          if (bbpsKey.value.currentState!.validate()) {
                            if (selectedBbpsSubCategory.isValidate == true) {
                              bool result = await bbpsController.fetchBbpsBill(
                                operatorCode: selectedBbpsSubCategory.apiCode.toString(),
                                isLoaderShow: true,
                              );
                              if (result == true) {
                                if (bbpsController.fetchBillModel.value.data != null) {
                                  if (context.mounted) {
                                    displayBill(
                                      context: context,
                                      fetchBillModel: bbpsController.fetchBillModel.value.data!,
                                      operatorCode: selectedBbpsSubCategory.apiCode.toString(),
                                    );
                                  }
                                } else {
                                  errorSnackBar(message: bbpsController.fetchBillModel.value.message!);
                                }
                              }
                            } else {
                              if (Get.isSnackbarOpen) {
                                Get.back();
                              }
                              bbpsController.bbpsStatus.value = -1;
                              await Get.toNamed(Routes.BBPS_STATUS_SCREEN, arguments: selectedBbpsSubCategory.apiCode.toString());
                              bbpsKey.value = GlobalKey<FormState>();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            : notFoundText(text: 'No field found'),
      ),
    );
  }

  displayBill({required BuildContext context, required FetchBillData fetchBillModel, required String operatorCode}) {
    bbpsController.amountController.text = fetchBillModel.amount!;
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
            height(5),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Bill Fetched Successfully!',
                style: TextHelper.size18.copyWith(
                  fontFamily: boldGoogleSansFont,
                  color: ColorsForApp.successColor,
                ),
              ),
            ),
            height(15),
            Align(
              alignment: Alignment.center,
              child: Text(
                fetchBillModel.billerName!,
                textAlign: TextAlign.center,
                style: TextHelper.size15.copyWith(
                  color: ColorsForApp.lightBlackColor,
                  fontFamily: mediumGoogleSansFont,
                ),
              ),
            ),
            height(8),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Bill Number : ${fetchBillModel.billerNumber}',
                style: TextHelper.size14.copyWith(
                  color: ColorsForApp.lightBlackColor,
                ),
              ),
            ),
            height(5),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Bill Date : ${fetchBillModel.billDate}',
                style: TextHelper.size14.copyWith(
                  color: ColorsForApp.lightBlackColor,
                ),
              ),
            ),
            height(5),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Bill Due Date : ${fetchBillModel.billDueDate}',
                style: TextHelper.size14.copyWith(
                  color: ColorsForApp.lightBlackColor,
                ),
              ),
            ),
            height(5),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Partial : ${fetchBillModel.partial}',
                style: TextHelper.size14.copyWith(
                  color: ColorsForApp.lightBlackColor,
                ),
              ),
            ),
            height(5),
            fetchBillModel.partial == 'Y'
                ? Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 8),
                    child: CustomTextField(
                      controller: bbpsController.amountController,
                      hintText: 'Enter Amount',
                      keyboardType: TextInputType.number,
                      readOnly: fetchBillModel.partial == 'Y' ? false : true,
                      textInputAction: TextInputAction.done,
                    ),
                  )
                : Text(
                    'Amount  : ₹ ${fetchBillModel.amount}',
                    style: TextHelper.size14.copyWith(
                      color: ColorsForApp.lightBlackColor,
                    ),
                  ),
            height(15),
            CommonButton(
              label: 'Proceed To Pay',
              onPressed: () async {
                if (bbpsController.amountController.text.toString().isEmpty) {
                  errorSnackBar(message: 'please enter amount');
                } else if (double.parse(bbpsController.amountController.text.trim()) <= 0) {
                  errorSnackBar(message: 'amount should be greater than zero');
                } else if (double.parse(bbpsController.amountController.text.trim()) > double.parse(fetchBillModel.amount!.trim())) {
                  errorSnackBar(message: 'amount should not be greater than ${bbpsController.fetchBillModel.value.data!.amount!.trim()}');
                } else {
                  if (Get.isSnackbarOpen) {
                    Get.back();
                  }
                  Get.back();
                  bbpsController.bbpsStatus.value = -1;
                  await Get.toNamed(
                    Routes.BBPS_STATUS_SCREEN,
                    arguments: operatorCode,
                  );
                  bbpsKey.value = GlobalKey<FormState>();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

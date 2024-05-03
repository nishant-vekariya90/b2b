import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../../controller/retailer/bbps_o_controller.dart';
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

class BbpsOFetchBillPage extends StatefulWidget {
  const BbpsOFetchBillPage({super.key});

  @override
  State<BbpsOFetchBillPage> createState() => _BbpsOFetchBillPageState();
}

class _BbpsOFetchBillPageState extends State<BbpsOFetchBillPage> {
  BbpsOController bbpsOController = Get.find();
  BbpsSubCategoryListModel selectedBbpsOSubCategory = Get.arguments;
  final Rx<GlobalKey<FormState>> bbpsOKey = GlobalKey<FormState>().obs;
  RxBool isShowTpinField = false.obs;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await bbpsOController.getBbpsParametersFieldList(operatorId: selectedBbpsOSubCategory.id!);
      isShowTpinField.value = checkTpinRequired(categoryCode: 'BBPS');
    } catch (e) {
      isShowTpinField.value = false;
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    bbpsOController.agentMobileNumberController.clear();
    bbpsOController.tPinController.clear();
    bbpsOController.bbpsParametersFieldList.clear();
    bbpsOController.bbpsGroupingList.clear();
    bbpsOController.valueControllers.clear();
    bbpsOController.selectedGroupingValueControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: selectedBbpsOSubCategory.name != null && selectedBbpsOSubCategory.name!.isNotEmpty ? selectedBbpsOSubCategory.name!.toString() : '-',
      isShowLeadingIcon: true,
      mainBody: Obx(
        () => bbpsOController.bbpsParametersFieldList.isNotEmpty
            ? Form(
                key: bbpsOKey.value,
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
                        itemCount: bbpsOController.bbpsParametersFieldList.length,
                        itemBuilder: (context, index) {
                          BbpsParametersListModel bbpsOParametersListData = bbpsOController.bbpsParametersFieldList[index];
                          return bbpsOParametersListData.hasGrouping == true
                              // Dropdown/Textfield for hasGrouping
                              ? bbpsOController.bbpsGroupingList.isNotEmpty
                                  // Dropdown for hasGrouping
                                  ? CustomTextFieldWithTitle(
                                      controller: bbpsOController.selectedGroupingValueControllers[index],
                                      title: bbpsOParametersListData.name,
                                      hintText: 'Select ${bbpsOParametersListData.name}',
                                      readOnly: true,
                                      isCompulsory: bbpsOParametersListData.ismandatory,
                                      onTap: () async {
                                        BbpsOperatorGroupingListModel operatorGrouping = await Get.toNamed(
                                          Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                                          arguments: [
                                            bbpsOController.bbpsGroupingList, // modelList
                                            'operatorGroupingList', // listType
                                          ],
                                        );
                                        if (operatorGrouping.name != null && operatorGrouping.name!.isNotEmpty) {
                                          bbpsOController.selectedGroupingValueControllers[index].text = operatorGrouping.name!;
                                          bbpsOController.valueControllers[index].text = operatorGrouping.value!;
                                        }
                                      },
                                      suffixIcon: GestureDetector(
                                        onTap: () async {
                                          BbpsOperatorGroupingListModel operatorGrouping = await Get.toNamed(
                                            Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                                            arguments: [
                                              bbpsOController.bbpsGroupingList, // modelList
                                              'operatorGroupingList', // listType
                                            ],
                                          );
                                          if (operatorGrouping.name != null && operatorGrouping.name!.isNotEmpty) {
                                            bbpsOController.selectedGroupingValueControllers[index].text = operatorGrouping.name!;
                                            bbpsOController.valueControllers[index].text = operatorGrouping.value!;
                                          }
                                        },
                                        child: Icon(
                                          Icons.keyboard_arrow_right_rounded,
                                          color: ColorsForApp.greyColor,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (bbpsOParametersListData.ismandatory == true && bbpsOController.selectedGroupingValueControllers[index].text.trim().isEmpty) {
                                          return 'Please select ${bbpsOParametersListData.name!.toLowerCase()}';
                                        }
                                        return null;
                                      },
                                    )
                                  // Textfield for hasGrouping
                                  : bbpsOParametersListData.maxlength! > 0
                                      ? CustomTextFieldWithTitle(
                                          controller: bbpsOController.valueControllers[index],
                                          title: bbpsOParametersListData.name,
                                          hintText: 'Enter ${bbpsOParametersListData.name}',
                                          isCompulsory: bbpsOParametersListData.ismandatory,
                                          minLength: bbpsOParametersListData.minlength,
                                          maxLength: bbpsOParametersListData.maxlength,
                                          keyboardType: bbpsOParametersListData.fieldtype!.toLowerCase() == 'text' || bbpsOParametersListData.fieldtype!.toLowerCase() == 'input' ? TextInputType.text : TextInputType.number,
                                          textInputFormatter: [
                                            FilteringTextInputFormatter.allow(RegExp(bbpsOParametersListData.pattern!)),
                                          ],
                                          textInputAction: index == bbpsOController.bbpsParametersFieldList.length - 1 ? TextInputAction.done : TextInputAction.next,
                                          validator: (value) {
                                            if (bbpsOParametersListData.ismandatory == true) {
                                              if (bbpsOController.valueControllers[index].text.isEmpty && bbpsOParametersListData.minlength != 0) {
                                                return 'Please enter ${bbpsOParametersListData.name!.toLowerCase()}';
                                              } else if (bbpsOParametersListData.minlength! > 0 && bbpsOController.valueControllers[index].text.length < bbpsOParametersListData.minlength!) {
                                                return 'Please enter valid ${bbpsOParametersListData.name!.toLowerCase()}';
                                              } else if (bbpsOParametersListData.maxlength! > 0 && bbpsOController.valueControllers[index].text.length > bbpsOParametersListData.maxlength!) {
                                                return 'Please enter valid ${bbpsOParametersListData.name!.toLowerCase()}';
                                              }
                                            }
                                            return null;
                                          },
                                        )
                                      : Container()
                              // For textfield
                              : bbpsOParametersListData.maxlength! > 0 && bbpsOController.valueControllers.isNotEmpty
                                  ? CustomTextFieldWithTitle(
                                      controller: bbpsOController.valueControllers[index],
                                      title: '${bbpsOParametersListData.name}',
                                      hintText: 'Enter ${bbpsOParametersListData.name}',
                                      isCompulsory: bbpsOParametersListData.ismandatory,
                                      minLength: bbpsOParametersListData.minlength,
                                      maxLength: bbpsOParametersListData.maxlength,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: bbpsOParametersListData.fieldtype!.toLowerCase() == 'text' || bbpsOParametersListData.fieldtype!.toLowerCase() == 'input' ? TextInputType.text : TextInputType.number,
                                      textInputFormatter: bbpsOParametersListData.pattern != null && bbpsOParametersListData.pattern!.isNotEmpty
                                          ? [
                                              FilteringTextInputFormatter.allow(RegExp(bbpsOParametersListData.pattern!)),
                                            ]
                                          : [],
                                      validator: (value) {
                                        if (bbpsOParametersListData.ismandatory == true) {
                                          if (bbpsOController.valueControllers[index].text.isEmpty && bbpsOParametersListData.minlength != 0) {
                                            return 'Please enter ${bbpsOParametersListData.name!.toLowerCase()}';
                                          } else if (bbpsOParametersListData.minlength! > 0 && bbpsOController.valueControllers[index].text.length < bbpsOParametersListData.minlength!) {
                                            return 'Please enter valid ${bbpsOParametersListData.name!.toLowerCase()}';
                                          } else if (bbpsOParametersListData.maxlength! > 0 && bbpsOController.valueControllers[index].text.length > bbpsOParametersListData.maxlength!) {
                                            return 'Please enter valid ${bbpsOParametersListData.name!.toLowerCase()}';
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
                        controller: bbpsOController.agentMobileNumberController,
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
                          if (bbpsOController.agentMobileNumberController.text.trim().isEmpty) {
                            return 'Please enter mobile number';
                          } else if (bbpsOController.agentMobileNumberController.text.trim().length != 10) {
                            return 'Please enter valid mobile number';
                          }
                          return null;
                        },
                      ),
                      Visibility(
                        visible: selectedBbpsOSubCategory.isPartial == true ? true : false,
                        child: CustomTextFieldWithTitle(
                          controller: bbpsOController.amountController,
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
                            if (bbpsOController.amountController.text.trim().isEmpty) {
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
                          controller: bbpsOController.tPinController,
                          title: 'TPIN',
                          hintText: 'Enter your TPIN',
                          obscureText: bbpsOController.isHideTPIN.value,
                          maxLength: 4,
                          isCompulsory: true,
                          textInputAction: TextInputAction.done,
                          suffixIcon: IconButton(
                            icon: Icon(
                              bbpsOController.isHideTPIN.value ? Icons.visibility_off : Icons.visibility,
                              size: 18,
                              color: ColorsForApp.secondaryColor,
                            ),
                            onPressed: () {
                              bbpsOController.isHideTPIN.value = !bbpsOController.isHideTPIN.value;
                            },
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (bbpsOController.tPinController.text.trim().isEmpty) {
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
                          if (bbpsOKey.value.currentState!.validate()) {
                            if (selectedBbpsOSubCategory.isValidate == true) {
                              bool result = await bbpsOController.fetchBbpsBill(
                                operatorCode: selectedBbpsOSubCategory.apiCode.toString(),
                                isLoaderShow: true,
                              );
                              if (result == true) {
                                if (bbpsOController.fetchBillModel.value.data != null) {
                                  if (context.mounted) {
                                    displayBill(
                                      context: context,
                                      fetchBillModel: bbpsOController.fetchBillModel.value.data!,
                                      operatorCode: selectedBbpsOSubCategory.apiCode.toString(),
                                    );
                                  }
                                } else {
                                  errorSnackBar(message: bbpsOController.fetchBillModel.value.message!);
                                }
                              }
                            } else {
                              if (Get.isSnackbarOpen) {
                                Get.back();
                              }
                              bbpsOController.bbpsStatus.value = -1;
                              await Get.toNamed(Routes.BBPS_O_STATUS_SCREEN, arguments: '');
                              bbpsOKey.value = GlobalKey<FormState>();
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
    bbpsOController.amountController.text = fetchBillModel.amount!;
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
                      controller: bbpsOController.amountController,
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
                if (bbpsOController.amountController.text.toString().isEmpty) {
                  errorSnackBar(message: 'please enter amount');
                } else if (double.parse(bbpsOController.amountController.text.trim()) <= 0) {
                  errorSnackBar(message: 'amount should be greater than zero');
                } else if (double.parse(bbpsOController.amountController.text.trim()) > double.parse(fetchBillModel.amount!.trim())) {
                  errorSnackBar(message: 'amount should not be greater than ${bbpsOController.fetchBillModel.value.data!.amount!.trim()}');
                } else {
                  if (Get.isSnackbarOpen) {
                    Get.back();
                  }
                  Get.back();
                  bbpsOController.bbpsStatus.value = -1;
                  await Get.toNamed(
                    Routes.BBPS_STATUS_SCREEN,
                    arguments: operatorCode,
                  );
                  bbpsOKey.value = GlobalKey<FormState>();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

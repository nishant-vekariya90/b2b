import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../controller/retailer/dmt/dmt_n_controller.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../../model/money_transfer/recipient_model.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/text_styles.dart';
import '../../../../../../widgets/button.dart';
import '../../../../../../widgets/constant_widgets.dart';
import '../../../../../../widgets/custom_scaffold.dart';

class DmtNRecipientListScreen extends StatefulWidget {
  const DmtNRecipientListScreen({Key? key}) : super(key: key);

  @override
  State<DmtNRecipientListScreen> createState() => _DmtNRecipientListScreenState();
}

class _DmtNRecipientListScreenState extends State<DmtNRecipientListScreen> {
  final DmtNController dmtNController = Get.find();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await dmtNController.getRecipientList();
      dismissProgressIndicator();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: CustomScaffold(
        appBarHeight: 15.h,
        title: 'Recipient List',
        isShowLeadingIcon: true,
        topCenterWidget: Container(
          height: 15.h,
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: ColorsForApp.whiteColor,
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage(Assets.imagesMoneyTransferTopCardbg),
              fit: BoxFit.cover,
            ),
          ),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height(2.h),
                Row(
                  children: [
                    Text(
                      'Name:',
                      style: TextHelper.size13.copyWith(
                        color: ColorsForApp.lightBlackColor,
                      ),
                    ),
                    width(1.w),
                    Text(
                      dmtNController.validateRemitterModel.value.data!.name != null && dmtNController.validateRemitterModel.value.data!.name!.isNotEmpty ? dmtNController.validateRemitterModel.value.data!.name! : '-',
                      style: TextHelper.size13.copyWith(
                        fontFamily: boldGoogleSansFont,
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                  ],
                ),
                height(5),
                Row(
                  children: [
                    Text(
                      'Mobile Number:',
                      style: TextHelper.size13.copyWith(
                        color: ColorsForApp.lightBlackColor,
                      ),
                    ),
                    width(1.w),
                    Text(
                      dmtNController.validateRemitterModel.value.data!.mobileNo != null && dmtNController.validateRemitterModel.value.data!.mobileNo!.isNotEmpty ? dmtNController.validateRemitterModel.value.data!.mobileNo! : '-',
                      style: TextHelper.size13.copyWith(
                        fontFamily: boldGoogleSansFont,
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                  ],
                ),
                height(1.h),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Bank 1',
                              style: TextHelper.size13.copyWith(
                                color: ColorsForApp.lightBlackColor,
                              ),
                            ),
                            height(0.5.h),
                            Text(
                              dmtNController.validateRemitterModel.value.data!.bank1Limit != null && dmtNController.validateRemitterModel.value.data!.bank1Limit!.isNotEmpty
                                  ? '₹ ${dmtNController.validateRemitterModel.value.data!.bank1Limit!.toString()}'
                                  : '₹ 0.0',
                              maxLines: 2,
                              style: TextHelper.size14.copyWith(
                                fontFamily: boldGoogleSansFont,
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: ColorsForApp.lightBlackColor,
                        thickness: 2,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Bank 2',
                              style: TextHelper.size13.copyWith(
                                color: ColorsForApp.lightBlackColor,
                              ),
                            ),
                            height(0.5.h),
                            Text(
                              dmtNController.validateRemitterModel.value.data!.bank2Limit != null && dmtNController.validateRemitterModel.value.data!.bank2Limit!.isNotEmpty
                                  ? '₹ ${dmtNController.validateRemitterModel.value.data!.bank2Limit!.toString()}'
                                  : '₹ 0.0',
                              maxLines: 2,
                              style: TextHelper.size14.copyWith(
                                fontFamily: boldGoogleSansFont,
                              ),
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: ColorsForApp.lightBlackColor,
                        thickness: 2,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Bank 3',
                              style: TextHelper.size13.copyWith(
                                color: ColorsForApp.lightBlackColor,
                              ),
                            ),
                            height(0.5.h),
                            Text(
                              dmtNController.validateRemitterModel.value.data!.bank3Limit != null && dmtNController.validateRemitterModel.value.data!.bank3Limit!.isNotEmpty
                                  ? '₹ ${dmtNController.validateRemitterModel.value.data!.bank3Limit!.toString()}'
                                  : '₹ 0.0',
                              maxLines: 2,
                              style: TextHelper.size14.copyWith(
                                fontFamily: boldGoogleSansFont,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                height(1.h),
              ],
            ),
          ),
        ),
        mainBody: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: ColorsForApp.selectedTabBgColor,
                  border: Border(
                    bottom: BorderSide(
                      color: ColorsForApp.primaryColor,
                      width: 2,
                    ),
                  ),
                  gradient: LinearGradient(
                    begin: const Alignment(-0.0, -0.7),
                    end: const Alignment(0, 1),
                    colors: [
                      ColorsForApp.whiteColor,
                      ColorsForApp.selectedTabBackgroundColor,
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Recipient list',
                      style: TextHelper.size15.copyWith(
                        fontFamily: mediumGoogleSansFont,
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.DMT_N_ADD_RECIPIENT_SCREEN);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.6.h),
                        decoration: BoxDecoration(
                          color: ColorsForApp.primaryColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_circle_rounded,
                              size: 20,
                              color: ColorsForApp.whiteColor,
                            ),
                            width(5),
                            Text(
                              'Add ',
                              style: TextHelper.size14.copyWith(
                                fontFamily: mediumGoogleSansFont,
                                color: ColorsForApp.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            height(1.h),
            Obx(
              () => dmtNController.recipientList.isEmpty
                  ? Expanded(
                      child: notFoundText(
                        text: 'Recipients not found',
                      ),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                        color: ColorsForApp.primaryColor,
                        onRefresh: () async {
                          isLoading.value = true;
                          await Future.delayed(const Duration(seconds: 1), () async {
                            // Call for fetch updated balance
                            await dmtNController.validateRemitter(isLoaderShow: false);
                            // Call for fetch updated recipient list
                            await dmtNController.getRecipientList(isLoaderShow: false);
                          });
                          isLoading.value = false;
                        },
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          itemCount: dmtNController.recipientList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            RecipientListModel recipientData = dmtNController.recipientList[index];
                            return GestureDetector(
                              onTap: () async {
                                dmtNController.selectedRecipientId.value = recipientData.recipientId.toString();
                                await Get.toNamed(
                                  Routes.DMT_N_TRANSACTION_SCREEN,
                                  arguments: recipientData,
                                );
                                await dmtNController.validateRemitter();
                              },
                              child: customCard(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              recipientData.name != null && recipientData.name!.isNotEmpty ? recipientData.name! : '-',
                                              style: TextHelper.size15.copyWith(
                                                fontFamily: boldGoogleSansFont,
                                                color: ColorsForApp.primaryColor,
                                              ),
                                            ),
                                          ),
                                          // Remove recipient
                                          IconButton(
                                            onPressed: () {
                                              dmtNController.selectedRecipientId.value = recipientData.recipientId.toString();
                                              if (Get.isSnackbarOpen) {
                                                Get.back();
                                              }
                                              // Confirmation dailog before remove recipient
                                              removeRecipientDialog(
                                                recipientName: recipientData.name.toString(),
                                                recipientId: recipientData.recipientId.toString(),
                                                mobileNumber: recipientData.mobileNo.toString(),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.delete_forever,
                                              color: ColorsForApp.errorColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Account No. :',
                                            style: TextHelper.size13.copyWith(
                                              fontFamily: mediumGoogleSansFont,
                                              color: ColorsForApp.greyColor,
                                            ),
                                          ),
                                          width(5),
                                          Flexible(
                                            child: Text(
                                              recipientData.accountNo != null && recipientData.accountNo!.isNotEmpty ? recipientData.accountNo! : '-',
                                              textAlign: TextAlign.start,
                                              style: TextHelper.size13.copyWith(
                                                fontFamily: regularGoogleSansFont,
                                                color: ColorsForApp.lightBlackColor,
                                              ),
                                            ),
                                          ),
                                          width(5),
                                          Icon(
                                            recipientData.verified == false ? Icons.verified_outlined : Icons.verified,
                                            color: recipientData.verified == false ? ColorsForApp.greyColor : ColorsForApp.successColor,
                                            size: 4.w,
                                          ),
                                        ],
                                      ),
                                      height(8),
                                      customKeyValueText(
                                        key: 'IFSC Code :',
                                        value: recipientData.ifsc != null && recipientData.ifsc!.isNotEmpty ? recipientData.ifsc! : '-',
                                      ),
                                      customKeyValueText(
                                        key: 'Bank Name :',
                                        value: recipientData.bankName != null && recipientData.bankName!.isNotEmpty ? recipientData.bankName! : '-',
                                      ),
                                      height(1.h),
                                      Visibility(
                                        visible: recipientData.verified == false ? true : false,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'This account is not verified! ',
                                              style: TextHelper.size14.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                                color: ColorsForApp.lightBlackColor,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                showProgressIndicator();
                                                bool result = await dmtNController.verifyAccount(
                                                  recipientName: recipientData.name != null && recipientData.name!.isNotEmpty ? recipientData.name! : '',
                                                  accountNo: recipientData.accountNo != null && recipientData.accountNo!.isNotEmpty ? recipientData.accountNo! : '',
                                                  ifscCode: recipientData.ifsc != null && recipientData.ifsc!.isNotEmpty ? recipientData.ifsc! : '',
                                                  bankName: recipientData.bankName != null && recipientData.bankName!.isNotEmpty ? recipientData.bankName! : '',
                                                  isLoaderShow: false,
                                                );
                                                if (result == true) {
                                                  // Call for fetch updated balance
                                                  await dmtNController.validateRemitter(isLoaderShow: false);
                                                  // Call for fetch updated recipient list
                                                  await dmtNController.getRecipientList(isLoaderShow: false);
                                                  successSnackBar(message: dmtNController.accountVerificationModel.value.message);
                                                }
                                                dismissProgressIndicator();
                                              },
                                              child: Container(
                                                height: 4.h,
                                                width: 20.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(12),
                                                  color: ColorsForApp.primaryColor,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'Verify',
                                                    style: TextHelper.size13.copyWith(
                                                      fontFamily: regularGoogleSansFont,
                                                      color: ColorsForApp.whiteColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Remove recipient dailog
  removeRecipientDialog({required String recipientName, required String recipientId, required String mobileNumber}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Text(
            'Remove Recipient',
            style: TextHelper.size20.copyWith(
              fontFamily: mediumGoogleSansFont,
            ),
          ),
          content: Text(
            'Are you sure you want to remove recipient $recipientName?',
            style: TextHelper.size14.copyWith(
              color: ColorsForApp.lightBlackColor.withOpacity(0.7),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
              child: InkWell(
                onTap: () async {
                  Get.back();
                },
                splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    'Cancel',
                    style: TextHelper.size14.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.primaryColorBlue,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
              child: InkWell(
                onTap: () async {
                  dmtNController.selectedRecipientId.value = recipientId;
                  if (Get.isSnackbarOpen) {
                    Get.back();
                  }
                  showProgressIndicator();
                  bool result = await dmtNController.removeRecipient(mobileNo: mobileNumber, isLoaderShow: false);
                  if (result == true) {
                    // Call for fetch updated recipient list
                    await dmtNController.getRecipientList(isLoaderShow: false);
                    Get.back();
                    successSnackBar(message: dmtNController.removeRecipientModel.value.message);
                  }
                  dismissProgressIndicator();
                },
                splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    'Confirm',
                    style: TextHelper.size14.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.primaryColorBlue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

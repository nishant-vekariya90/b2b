import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/text_styles.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/constant_widgets.dart';
import '../../../../widgets/custom_scaffold.dart';
import '../../../controller/distributor/view_user_controller.dart';
import '../../../model/auth/user_type_model.dart';
import '../../../model/view_user_model.dart';
import '../../../routes/routes.dart';
import '../../../widgets/text_field.dart';
import '../../../widgets/text_field_with_title.dart';

class ViewUserScreen extends StatefulWidget {
  const ViewUserScreen({super.key});

  @override
  State<ViewUserScreen> createState() => _ViewUserScreenState();
}

class _ViewUserScreenState extends State<ViewUserScreen> {
  ViewUserController viewUserController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    showProgressIndicator();
    await viewUserController.getUserType(isLoaderShow: false);
    await viewUserController.getViewUserListApi(
      pageNumber: 1,
      isLoaderShow: false,
    );
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && viewUserController.userCurrentPage.value < viewUserController.userTotalPages.value) {
        viewUserController.userCurrentPage.value++;
        await viewUserController.getViewUserListApi(
          pageNumber: viewUserController.userCurrentPage.value,
          isLoaderShow: false,
        );
      }
    });
    dismissProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 6.5.h,
      title: 'View users',
      isShowLeadingIcon: true,
      action: [
        Obx(
          () => IconButton(
            onPressed: () {
              filterBottomSheet();
            },
            icon: Icon(
              viewUserController.isShowClearFiltersButton.value == true ? Icons.filter_alt_rounded : Icons.filter_alt_outlined,
              color: ColorsForApp.primaryColor,
            ),
          ),
        ),
      ],
      topCenterWidget: SizedBox(
        height: 6.5.h,
        width: 100.w,
        child: Card(
          color: ColorsForApp.whiteColor,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          child: CustomTextField(
            controller: viewUserController.searchUsernameController,
            style: TextHelper.size14.copyWith(
              fontFamily: mediumGoogleSansFont,
            ),
            hintText: 'Search by username...',
            hintTextColor: ColorsForApp.lightBlackColor.withOpacity(0.6),
            focusedBorderColor: ColorsForApp.grayScale500,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            onChange: (value) async {
              if (value.isEmpty) {
                await viewUserController.getViewUserListApi(pageNumber: 1);
              }
            },
            onSubmitted: (value) async {
              if (value.isNotEmpty) {
                if (value.length >= 3) {
                  await viewUserController.getViewUserListApi(username: value, pageNumber: 1);
                } else {
                  errorSnackBar(message: 'Please enter minimum 3 characters');
                }
              }
            },
            suffixIcon: GestureDetector(
              onTap: () async {
                if (viewUserController.searchUsernameController.text.length >= 3) {
                  await viewUserController.getViewUserListApi(username: viewUserController.searchUsernameController.text, pageNumber: 1);
                } else {
                  errorSnackBar(message: 'Please enter minimum 3 characters');
                }
              },
              child: Container(
                height: 1,
                width: 8.h,
                decoration: BoxDecoration(
                  color: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Search',
                  style: TextHelper.size13.copyWith(
                    fontFamily: boldGoogleSansFont,
                    color: ColorsForApp.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      mainBody: Obx(
        () => viewUserController.userList.isEmpty
            ? notFoundText(text: 'No user found')
            : RefreshIndicator(
                color: ColorsForApp.primaryColor,
                onRefresh: () async {
                  isLoading.value = true;
                  viewUserController.searchUsernameController.clear();
                  viewUserController.selectedUserTypeController.clear();
                  viewUserController.selectedUserTypeId.value = '';
                  await Future.delayed(const Duration(seconds: 1), () async {
                    await viewUserController.getViewUserListApi(
                      pageNumber: 1,
                      isLoaderShow: false,
                    );
                  });
                  viewUserController.isShowClearFiltersButton.value = false;
                  isLoading.value = false;
                },
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  itemCount: viewUserController.userList.length,
                  itemBuilder: (context, index) {
                    if (index == viewUserController.userList.length - 1 && viewUserController.userHasNext.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: ColorsForApp.primaryColor,
                        ),
                      );
                    } else {
                      UserData userData = viewUserController.userList[index];
                      return customCard(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: userData.profileName != null && userData.profileName!.isNotEmpty && userData.profileName!.contains('distributor')
                                  ? EdgeInsets.fromLTRB(3.5.w, 1.5.h, 3.5.w, 0)
                                  : EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                              child: InkWell(
                                onTap: () {
                                  if (userData.kycStatus != null && userData.kycStatus == 6) {
                                    Get.toNamed(
                                      Routes.KYC_SCREEN,
                                      arguments: [
                                        true, //Navigate to do user kyc screen
                                        userData.userName, //pass full name
                                        userData.unqID //pass unique id
                                      ],
                                    );
                                  } else {
                                    Get.toNamed(
                                      Routes.PERSONAL_INFO_SCREEN,
                                      arguments: [
                                        true,
                                        userData,
                                      ],
                                    );
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Username
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'User Name: ',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: mediumGoogleSansFont,
                                                  color: ColorsForApp.lightBlackColor,
                                                ),
                                              ),
                                              width(5),
                                              Flexible(
                                                child: Text(
                                                  userData.userName != null && userData.userName!.isNotEmpty ? userData.userName! : '-',
                                                  textAlign: TextAlign.justify,
                                                  style: TextHelper.size13.copyWith(
                                                    fontFamily: mediumGoogleSansFont,
                                                    color: ColorsForApp.lightBlackColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        width(2.w),
                                        // Kyc status
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'KYC: ',
                                              style: TextHelper.size13.copyWith(
                                                fontFamily: mediumGoogleSansFont,
                                                color: ColorsForApp.lightBlackColor,
                                              ),
                                            ),
                                            width(5),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: userData.kycStatus != null && userData.kycStatus! == 1
                                                      ? ColorsForApp.primaryColorBlue
                                                      : userData.kycStatus != null && userData.kycStatus! == 2
                                                          ? ColorsForApp.primaryColorBlue
                                                          : userData.kycStatus != null && userData.kycStatus! == 3
                                                              ? ColorsForApp.successColor
                                                              : userData.kycStatus != null && userData.kycStatus! == 4
                                                                  ? ColorsForApp.chilliRedColor
                                                                  : userData.kycStatus != null && userData.kycStatus! == 5
                                                                      ? ColorsForApp.greyColor
                                                                      : ColorsForApp.greyColor,
                                                  width: 0.2,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                child: Text(
                                                  viewUserController.kycStatus(userData.kycStatus!),
                                                  style: TextHelper.size13.copyWith(
                                                    fontFamily: mediumGoogleSansFont,
                                                    color: userData.kycStatus != null && userData.kycStatus! == 1
                                                        ? ColorsForApp.primaryColorBlue
                                                        : userData.kycStatus != null && userData.kycStatus! == 2
                                                            ? ColorsForApp.primaryColorBlue
                                                            : userData.kycStatus != null && userData.kycStatus! == 3
                                                                ? ColorsForApp.successColor
                                                                : userData.kycStatus != null && userData.kycStatus! == 4
                                                                    ? ColorsForApp.chilliRedColor
                                                                    : userData.kycStatus != null && userData.kycStatus! == 5
                                                                        ? ColorsForApp.greyColor
                                                                        : ColorsForApp.greyColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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
                                    // Owner Name
                                    customKeyValueText(
                                      key: 'Owner Name: ',
                                      value: userData.ownerName != null && userData.ownerName!.isNotEmpty ? userData.ownerName! : '-',
                                    ),
                                    // Company Name
                                    customKeyValueText(
                                      key: 'Company Name: ',
                                      value: userData.companyName != null && userData.companyName!.isNotEmpty ? userData.companyName! : '-',
                                    ),
                                    // Mobile
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Mobile: ',
                                          style: TextHelper.size13.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                            color: ColorsForApp.greyColor,
                                          ),
                                        ),
                                        width(5),
                                        Flexible(
                                          child: Text(
                                            userData.mobile != null && userData.mobile!.isNotEmpty ? userData.mobile! : '-',
                                            textAlign: TextAlign.justify,
                                            style: TextHelper.size13.copyWith(
                                              fontFamily: regularGoogleSansFont,
                                              color: ColorsForApp.lightBlackColor,
                                            ),
                                          ),
                                        ),
                                        width(5),
                                        Icon(
                                          userData.isMobileVerified == true ? Icons.verified : Icons.verified_outlined,
                                          color: userData.isMobileVerified == true ? ColorsForApp.successColor : ColorsForApp.greyColor,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                    height(8),
                                    // Email
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Email: ',
                                          style: TextHelper.size13.copyWith(
                                            fontFamily: mediumGoogleSansFont,
                                            color: ColorsForApp.greyColor,
                                          ),
                                        ),
                                        width(5),
                                        Flexible(
                                          child: Text(
                                            userData.email != null && userData.email!.isNotEmpty ? userData.email! : '-',
                                            textAlign: TextAlign.justify,
                                            style: TextHelper.size13.copyWith(
                                              fontFamily: regularGoogleSansFont,
                                              color: ColorsForApp.lightBlackColor,
                                            ),
                                          ),
                                        ),
                                        width(5),
                                        Icon(
                                          userData.isEmailVerified == true ? Icons.verified : Icons.verified_outlined,
                                          color: userData.isEmailVerified == true ? ColorsForApp.successColor : ColorsForApp.greyColor,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                    height(8),
                                    // Profile
                                    customKeyValueText(
                                      key: 'Profile: ',
                                      value: userData.profileName != null && userData.profileName!.isNotEmpty ? userData.profileName! : '-',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: userData.profileName != null && userData.profileName!.isNotEmpty && userData.profileName!.toLowerCase().contains('distributor'),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    Routes.VIEW_CHILD_USER_SCREEN,
                                    arguments: userData.unqID,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 0.7.h),
                                  decoration: BoxDecoration(
                                    color: ColorsForApp.primaryColor,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(16),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.supervisor_account_rounded,
                                        size: 16,
                                        color: ColorsForApp.whiteColor,
                                      ),
                                      width(5),
                                      Text(
                                        'View Downline',
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
                          ],
                        ),
                      );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return height(0.5.h);
                  },
                ),
              ),
      ),
    );
  }

  // Filter bottomsheet
  Future filterBottomSheet() {
    return customBottomSheet(
      children: [
        // Filter text
        Row(
          children: [
            Icon(
              Icons.filter_alt_rounded,
              color: ColorsForApp.primaryColor,
            ),
            width(5),
            Text(
              'Filter',
              style: TextHelper.size18.copyWith(
                color: ColorsForApp.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Obx(
              () => Visibility(
                visible: viewUserController.isShowClearFiltersButton.value == true ? true : false,
                child: GestureDetector(
                  onTap: () async {
                    Get.back();
                    viewUserController.searchUsernameController.clear();
                    viewUserController.selectedUserTypeController.clear();
                    viewUserController.selectedUserTypeId.value = '';
                    await viewUserController.getViewUserListApi(pageNumber: 1);
                    viewUserController.isShowClearFiltersButton.value = false;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.7,
                        color: ColorsForApp.greyColor.withOpacity(0.4),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Clear Filter',
                      style: TextHelper.size13.copyWith(
                        fontFamily: mediumGoogleSansFont,
                        letterSpacing: 0.5,
                        color: ColorsForApp.primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        height(2.h),
        // Select user type
        CustomTextFieldWithTitle(
          controller: viewUserController.selectedUserTypeController,
          title: 'User type',
          hintText: 'Select user type',
          readOnly: true,
          onTap: () async {
            UserTypeModel selectedUserType = await Get.toNamed(
              Routes.SEARCHABLE_LIST_VIEW_SCREEN,
              arguments: [
                viewUserController.userTypeList, // list
                'userTypeList', // listType
              ],
            );
            if (selectedUserType.name != null && selectedUserType.name!.isNotEmpty) {
              viewUserController.selectedUserTypeController.text = selectedUserType.name!;
              viewUserController.selectedUserTypeId.value = selectedUserType.id!.toString();
            }
          },
          suffixIcon: GestureDetector(
            onTap: () async {
              UserTypeModel selectedUserType = await Get.toNamed(
                Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                arguments: [
                  viewUserController.userTypeList, // list
                  'userTypeList', // listType
                ],
              );
              if (selectedUserType.name != null && selectedUserType.name!.isNotEmpty) {
                viewUserController.selectedUserTypeController.text = selectedUserType.name!;
                viewUserController.selectedUserTypeId.value = selectedUserType.id!.toString();
              }
            },
            child: Icon(
              Icons.keyboard_arrow_right_rounded,
              color: ColorsForApp.greyColor,
            ),
          ),
        ),
        height(8),
      ],
      enableDrag: false,
      isDismissible: false,
      preventToClose: false,
      isScrollControlled: true,
      customButtons: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: CommonButton(
              shadowColor: ColorsForApp.shadowColor,
              onPressed: () {
                Get.back();
              },
              label: 'Cancel',
              border: Border.all(
                color: ColorsForApp.primaryColor,
              ),
              labelColor: ColorsForApp.primaryColor,
              bgColor: ColorsForApp.whiteColor,
            ),
          ),
          width(5.w),
          Expanded(
            child: CommonButton(
              shadowColor: ColorsForApp.shadowColor,
              onPressed: () async {
                if (viewUserController.selectedUserTypeController.text.isNotEmpty) {
                  await viewUserController.getViewUserListApi(username: viewUserController.searchUsernameController.text, pageNumber: 1);
                  viewUserController.isShowClearFiltersButton.value = true;
                  Get.back();
                } else {
                  errorSnackBar(message: 'Please select filter first');
                }
              },
              label: 'Apply',
              labelColor: ColorsForApp.whiteColor,
              bgColor: ColorsForApp.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

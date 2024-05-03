import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/text_styles.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/constant_widgets.dart';
import '../../../../widgets/custom_scaffold.dart';
import '../../../controller/distributor/view_user_controller.dart';
import '../../../model/view_user_model.dart';
import '../../../routes/routes.dart';
import '../../../widgets/text_field.dart';

class ViewChildUserScreen extends StatefulWidget {
  const ViewChildUserScreen({super.key});

  @override
  State<ViewChildUserScreen> createState() => _ViewChildUserScreenState();
}

class _ViewChildUserScreenState extends State<ViewChildUserScreen> {
  ViewUserController viewUserController = Get.find();
  ScrollController scrollController = ScrollController();
  String uniqueId = Get.arguments;

  @override
  void initState() {
    super.initState();
    callAsyncAPI();
  }

  Future<void> callAsyncAPI() async {
    showProgressIndicator();
    await viewUserController.getViewChildUserListApi(
      uniqueId: uniqueId,
      pageNumber: 1,
      isLoaderShow: false,
    );
    scrollController.addListener(() async {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels && viewUserController.userCurrentPage.value < viewUserController.userTotalPages.value) {
        viewUserController.userCurrentPage.value++;
        await viewUserController.getViewChildUserListApi(
          uniqueId: uniqueId,
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
      title: 'View Downline',
      isShowLeadingIcon: true,
      topCenterWidget: Card(
        color: ColorsForApp.whiteColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: CustomTextField(
          controller: viewUserController.searchChildUsernameController,
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
              await viewUserController.getViewChildUserListApi(uniqueId: uniqueId, pageNumber: 1);
            }
          },
          onSubmitted: (value) async {
            if (value.isNotEmpty) {
              if (value.length >= 3) {
                await viewUserController.getViewChildUserListApi(uniqueId: uniqueId, username: value, pageNumber: 1);
              } else {
                errorSnackBar(message: 'Please enter minimum 3 characters');
              }
            }
          },
          suffixIcon: GestureDetector(
            onTap: () async {
              if (viewUserController.searchChildUsernameController.text.length >= 3) {
                await viewUserController.getViewChildUserListApi(
                  uniqueId: uniqueId,
                  username: viewUserController.searchChildUsernameController.text,
                  pageNumber: 1,
                );
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
      mainBody: Obx(
        () => viewUserController.childUserList.isEmpty
            ? notFoundText(text: 'No user found')
            : RefreshIndicator(
                color: ColorsForApp.primaryColor,
                onRefresh: () async {
                  isLoading.value = true;
                  await Future.delayed(const Duration(seconds: 1), () async {
                    viewUserController.searchChildUsernameController.clear();
                    await viewUserController.getViewChildUserListApi(
                      uniqueId: uniqueId,
                      pageNumber: 1,
                      isLoaderShow: false,
                    );
                  });
                  isLoading.value = false;
                },
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  itemCount: viewUserController.childUserList.length,
                  itemBuilder: (context, index) {
                    if (index == viewUserController.childUserList.length - 1 && viewUserController.childUserHasNext.value) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: ColorsForApp.primaryColor,
                        ),
                      );
                    } else {
                      UserData userData = viewUserController.childUserList[index];
                      return customCard(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
                          child: InkWell(
                            onTap: () {
                              if (userData.kycStatus != null && userData.kycStatus == 6) {
                                Get.toNamed(Routes.KYC_SCREEN, arguments: [
                                  true, //Navigate to do user kyc screen
                                  userData.userName, //pass full name
                                  userData.unqID //pass unique id
                                ]);
                              } else {
                                Get.toNamed(
                                  Routes.PERSONAL_INFO_SCREEN,
                                  arguments: [true, userData],
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
}

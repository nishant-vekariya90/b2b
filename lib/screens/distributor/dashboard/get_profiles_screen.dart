import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/text_styles.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/constant_widgets.dart';
import '../../../../widgets/custom_scaffold.dart';
import '../../../controller/distributor/profile_controller.dart';
import '../../../model/create_profile/profile_information_model.dart';

class GetProfilesScreen extends StatefulWidget {
  const GetProfilesScreen({super.key});

  @override
  State<GetProfilesScreen> createState() => _GetProfilesScreenState();
}

class _GetProfilesScreenState extends State<GetProfilesScreen> {
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await profileController.profileInformation();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Profiles',
      isShowLeadingIcon: true,
      mainBody: Obx(
        () => profileController.profilesList.isEmpty
            ? notFoundText(text: 'No Profiles found')
            : Column(
                children: [
                  height(5),
                  Expanded(
                    child: ListView.separated(
                      controller: ScrollController(),
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                      itemCount: profileController.profilesList.length,
                      itemBuilder: (context, index) {
                        Profile profilesList = profileController.profilesList[index];
                        return Card(
                          color: ColorsForApp.whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Card(
                            color: ColorsForApp.whiteColor,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  height(1.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: customKeyValueText(
                                          key: 'Name : ',
                                          value: profilesList.name != null ? profilesList.name! : '-',
                                        ),
                                      ),
                                      width(15),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () async {
                                              await updateStatusDialog(context, profilesList.status!, profilesList.id!);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(
                                                      color: profilesList.status == 0
                                                          ? ColorsForApp.chilliRedColor
                                                          : profilesList.status == 1
                                                              ? ColorsForApp.successColor
                                                              : ColorsForApp.orangeColor,
                                                      width: 0.2)),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8),
                                                child: Text(
                                                  profilesList.status == 0 ? "Deactivate" : "Active",
                                                  style: TextHelper.size13.copyWith(fontFamily: mediumGoogleSansFont, color: profilesList.status == 0 ? ColorsForApp.chilliRedColor : ColorsForApp.successColor),
                                                ),
                                              ),
                                            ),
                                          ),
                                          width(15),
                                          GestureDetector(
                                              onTap: () {
                                                Get.toNamed(Routes.UPDATE_PROFILE_SCREEN, arguments: [
                                                  profilesList.name,
                                                  profilesList.code,
                                                  profilesList.userType,
                                                  profilesList.id,
                                                  profilesList.userTypeID,
                                                ]);
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                size: 20,
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                  height(1.5.h),
                                  Divider(
                                    height: 0,
                                    thickness: 0.2,
                                    color: ColorsForApp.greyColor,
                                  ),
                                  height(1.5.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Number
                                      Expanded(
                                        child: customKeyValueText(
                                          key: 'Code : ',
                                          value: profilesList.code != null ? profilesList.code! : '-',
                                        ),
                                      ),
                                      width(15),
                                      Expanded(
                                        child: customKeyValueText(
                                          key: 'UserType : ',
                                          value: profilesList.userType != null ? profilesList.userType! : '-',
                                        ),
                                      ),
                                      // Amount
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return height(0.5.h);
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsForApp.primaryColor,
        onPressed: () {
          Get.toNamed(Routes.CREATE_PROFILE_SCREEN);
        },
        child: Icon(
          Icons.add,
          color: ColorsForApp.whiteColor,
        ),
      ),
    );
  }

  Future<dynamic> updateStatusDialog(BuildContext context, int status, int id) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Text(
            'Update status confirmation',
            style: TextHelper.size20.copyWith(
              fontFamily: mediumGoogleSansFont,
            ),
          ),
          content: Text(
            "Are you sure you want to change a status to ${status == 1 ? "deactivate" : "active"}?",
            style: TextHelper.size14.copyWith(color: ColorsForApp.lightBlackColor.withOpacity(0.7)),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      if (Get.isSnackbarOpen) {
                        Get.back();
                      }
                      Get.back();
                    },
                    splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                    highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(
                        'No',
                        style: TextHelper.size14.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.primaryColorBlue,
                        ),
                      ),
                    ),
                  ),
                  width(1.w),
                  InkWell(
                    onTap: () async {
                      if (Get.isSnackbarOpen) {
                        Get.back();
                      }
                      showProgressIndicator();
                      await profileController.updateStatus(status: status, id: id);
                      dismissProgressIndicator();
                    },
                    splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                    highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(
                        'Yes',
                        style: TextHelper.size14.copyWith(
                          fontFamily: mediumGoogleSansFont,
                          color: ColorsForApp.primaryColorBlue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget customKeyValueText({required String key, required String value, TextStyle? keyTextStyle, TextStyle? valueTextStyle}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key,
              style: keyTextStyle ??
                  TextHelper.size13.copyWith(
                    fontFamily: boldGoogleSansFont,
                    color: ColorsForApp.lightBlackColor,
                  ),
            ),
            width(5),
            Expanded(
              child: Text(
                value.isNotEmpty ? value : '',
                textAlign: TextAlign.start,
                style: valueTextStyle ??
                    TextHelper.size13.copyWith(
                      fontFamily: regularGoogleSansFont,
                      color: ColorsForApp.lightBlackColor,
                    ),
              ),
            ),
          ],
        ),
        height(8),
      ],
    );
  }
}

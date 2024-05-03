import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../controller/distributor/add_user_controller.dart';
import '../../../controller/distributor/profile_controller.dart';
import '../../../generated/assets.dart';
import '../../../model/auth/user_type_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../../widgets/button.dart';
import '../../../widgets/constant_widgets.dart';
import '../../../widgets/custom_scaffold.dart';
import '../../../widgets/text_field_with_title.dart';
import '../../../routes/routes.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({Key? key}) : super(key: key);

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final GlobalKey<FormState> createProfileFormKey = GlobalKey<FormState>();
  final ProfileController profileController = Get.find();
  final AddUserController addUserController = Get.find();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    await addUserController.getUserType();
  }

  @override
  void dispose() {
    profileController.profileNameTxtController.clear();
    profileController.codeTxtController.clear();
    profileController.userTypeTxtController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 10.h,
      title: 'Create Profile',
      isShowLeadingIcon: true,
      topCenterWidget: Container(
        height: 10.h,
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        decoration: BoxDecoration(
          color: ColorsForApp.whiteColor,
          image: const DecorationImage(
            image: AssetImage(Assets.imagesTopCardBgStart),
            fit: BoxFit.fitWidth,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(2.w),
              child: Image.asset(
                Assets.imagesAddUserTopBg,
              ),
            ),
            width(2.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Profile',
                    style: TextHelper.size14.copyWith(
                      fontFamily: boldGoogleSansFont,
                      color: ColorsForApp.primaryColor,
                    ),
                  ),
                  height(0.5.h),
                  Text(
                    'Create a new user profile with the following details.',
                    maxLines: 3,
                    style: TextHelper.size12.copyWith(
                      color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      mainBody: AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        switchInCurve: Curves.fastOutSlowIn,
        switchOutCurve: Curves.fastOutSlowIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
          return currentChild ?? Container();
        },
        child: Form(
          key: createProfileFormKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                height(2.h),
                CustomTextFieldWithTitle(
                  controller: profileController.userTypeTxtController,
                  title: 'User Type',
                  hintText: 'Select a user type',
                  isCompulsory: true,
                  readOnly: true,
                  suffixIcon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: ColorsForApp.secondaryColor.withOpacity(0.5),
                  ),
                  onTap: () async {
                    UserTypeModel selectedUserType = await Get.toNamed(
                      Routes.SEARCHABLE_LIST_VIEW_SCREEN,
                      arguments: [
                        addUserController.userTypeList, // modelList
                        'userTypeList', // modelName
                      ],
                    );
                    if (selectedUserType.name != null && selectedUserType.name!.isNotEmpty) {
                      profileController.userTypeTxtController.text = selectedUserType.name!;
                      profileController.selectedUserTypeId.value = selectedUserType.id!.toString();
                    }
                  },
                  validator: (value) {
                    if (profileController.userTypeTxtController.text.trim().isEmpty) {
                      return 'Please select user type';
                    }
                    return null;
                  },
                ),
                CustomTextFieldWithTitle(
                  title: 'Profile Name',
                  isCompulsory: true,
                  controller: profileController.profileNameTxtController,
                  hintText: 'Enter Profile Name',
                  maxLength: 50,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (profileController.profileNameTxtController.text.isEmpty) {
                      return 'Please enter profile name';
                    } else if (profileController.profileNameTxtController.text.length < 2) {
                      return 'Minimum 2 characters are required';
                    } else {
                      return null;
                    }
                  },
                ),
                CustomTextFieldWithTitle(
                  title: 'Code',
                  isCompulsory: true,
                  controller: profileController.codeTxtController,
                  hintText: 'Enter Code',
                  maxLength: 10,
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (profileController.codeTxtController.text.isEmpty) {
                      return 'Please enter code';
                    } else {
                      return null;
                    }
                  },
                ),
                height(2.h),
                CommonButton(
                  label: 'Submit',
                  onPressed: () async {
                    if (createProfileFormKey.currentState!.validate()) {
                      showProgressIndicator();
                      bool result = await profileController.createProfile(isLoaderShow: false);
                      if (result) {
                        await profileController.profileInformation();
                      }
                      dismissProgressIndicator();
                    }
                  },
                ),
                height(2.h),
              ],
            ),
          ),
        ),
      ),
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
              style: keyTextStyle ?? TextHelper.size13.copyWith(fontFamily: mediumGoogleSansFont, color: ColorsForApp.lightBlackColor, fontWeight: FontWeight.bold),
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

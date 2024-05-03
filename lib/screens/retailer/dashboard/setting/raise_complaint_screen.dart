import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/setting_controller.dart';
import '../../../../model/dispute_category_model.dart';
import '../../../../model/dispute_child_category_model.dart';
import '../../../../model/dispute_sub_category_model.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/permission_handler.dart';
import '../../../../utils/text_styles.dart';
import '../../../../widgets/base_dropdown.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/constant_widgets.dart';
import '../../../../widgets/custom_scaffold.dart';
import '../../../../widgets/text_field_with_title.dart';

class RaiseComplaintScreen extends StatefulWidget {
  const RaiseComplaintScreen({super.key});

  @override
  State<RaiseComplaintScreen> createState() => _RaiseComplaintScreenState();
}

class _RaiseComplaintScreenState extends State<RaiseComplaintScreen> {
  final SettingController settingController = Get.find();
  final Rx<GlobalKey<FormState>> ticketFormKey = GlobalKey<FormState>().obs;
  File? pickedFile;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await settingController.getDisputeCategoryApi();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'Raise Complaint',
      isShowLeadingIcon: true,
      mainBody: Obx(
        () => SingleChildScrollView(
          child: Form(
            key: ticketFormKey.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height(10),
                      // Select ccategory
                      CustomTextFieldWithTitle(
                        controller: settingController.disputeCategoryController,
                        title: 'Category',
                        hintText: 'Select category',
                        readOnly: true,
                        isCompulsory: true,
                        onTap: () async {
                          DisputeCategoryModel category = await Get.toNamed(
                            Routes.SEARCHABLE_LIST_VIEW_WITH_IMAGE_SCREEN,
                            arguments: [
                              settingController.disputeCategoryList,
                              // modelList
                              'CategoryList',
                              // modelName
                            ],
                          );
                          if (category.name != null && category.name!.isNotEmpty) {
                            settingController.disputeCategoryController.text = category.name!;
                            settingController.selectedCategory.value = category.id!;
                          }
                        },
                        validator: (value) {
                          if (settingController.disputeCategoryController.text.trim().isEmpty) {
                            return 'Please select category';
                          }
                          return null;
                        },
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            DisputeCategoryModel selectedCategory = await Get.toNamed(
                              Routes.SEARCHABLE_LIST_VIEW_WITH_IMAGE_SCREEN,
                              arguments: [
                                settingController.disputeCategoryList,
                                // modelList
                                'CategoryList',
                                // modelName
                              ],
                            );
                            if (selectedCategory.name != null && selectedCategory.name!.isNotEmpty) {
                              settingController.disputeCategoryController.text = selectedCategory.name!;
                              settingController.disputeChildCategoryList.clear();
                              settingController.disputeSubCategoryList.clear();
                            }
                          },
                          child: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: ColorsForApp.greyColor,
                          ),
                        ),
                      ),
                      height(0.5.h),
                      // Select complaint type
                      CustomTextFieldWithTitle(
                        controller: settingController.disputeSubCategoryController,
                        title: 'Complaint Type',
                        hintText: 'Select complaint type',
                        readOnly: true,
                        isCompulsory: true,
                        onTap: () async {
                          try {
                            showProgressIndicator();
                            await settingController.getDisputeSubCategoryApi(isLoaderShow: false);
                            dismissProgressIndicator();
                          } catch (e) {
                            dismissProgressIndicator();
                          }
                          DisputeSubCategoryModel category = await Get.toNamed(
                            Routes.SEARCHABLE_LIST_VIEW_WITH_IMAGE_SCREEN,
                            arguments: [
                              settingController.disputeSubCategoryList,
                              // modelList
                              'SubCategoryList',
                              // modelName
                            ],
                          );
                          if (category.name != null && category.name!.isNotEmpty) {
                            settingController.disputeSubCategoryController.text = category.name!;
                            settingController.selectedSubCategory.value = category.id!;
                          }
                        },
                        validator: (value) {
                          if (settingController.disputeSubCategoryController.text.trim().isEmpty) {
                            return 'Please select complaint type';
                          }
                          return null;
                        },
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            DisputeSubCategoryModel selectedCategory = await Get.toNamed(
                              Routes.SEARCHABLE_LIST_VIEW_WITH_IMAGE_SCREEN,
                              arguments: [
                                settingController.disputeSubCategoryList,
                                // modelList
                                'SubCategoryList',
                                // modelName
                              ],
                            );
                            if (selectedCategory.name != null && selectedCategory.name!.isNotEmpty) {
                              settingController.disputeSubCategoryController.text = selectedCategory.name!;
                            }
                          },
                          child: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: ColorsForApp.greyColor,
                          ),
                        ),
                      ),
                      // Select child category list
                      CustomTextFieldWithTitle(
                        controller: settingController.disputeChildCategoryController,
                        title: 'Subject',
                        hintText: 'Select subject',
                        readOnly: true,
                        isCompulsory: true,
                        onTap: () async {
                          try {
                            showProgressIndicator();
                            await settingController.getDisputeChildCategoryApi(isLoaderShow: false);
                            dismissProgressIndicator();
                          } catch (e) {
                            dismissProgressIndicator();
                          }
                          DisputeChildCategoryModel category = await Get.toNamed(
                            Routes.SEARCHABLE_LIST_VIEW_WITH_IMAGE_SCREEN,
                            arguments: [
                              settingController.disputeChildCategoryList,
                              // modelList
                              'ChildCategoryList',
                              // modelName
                            ],
                          );
                          if (category.name != null && category.name!.isNotEmpty) {
                            settingController.disputeChildCategoryController.text = category.name!;
                            settingController.selectedChildCategory.value = category.id!;
                          }
                        },
                        validator: (value) {
                          if (settingController.disputeChildCategoryController.text.trim().isEmpty) {
                            return 'Please select subject';
                          }
                          return null;
                        },
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            DisputeChildCategoryModel selectedCategory = await Get.toNamed(
                              Routes.SEARCHABLE_LIST_VIEW_WITH_IMAGE_SCREEN,
                              arguments: [
                                settingController.disputeChildCategoryList,
                                // modelList
                                'ChildCategoryList',
                                // modelName
                              ],
                            );
                            if (selectedCategory.name != null && selectedCategory.name!.isNotEmpty) {
                              settingController.disputeChildCategoryController.text = selectedCategory.name!;
                            }
                          },
                          child: Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: ColorsForApp.greyColor,
                          ),
                        ),
                      ),
                      height(5),
                      RichText(
                        text: TextSpan(
                          text: "Priority",
                          style: TextHelper.size14.copyWith(
                            color: ColorsForApp.lightBlackColor,
                          ),
                          children: const [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      height(1.h),
                      BaseDropDown(
                        value: settingController.selectedPriority.value.isEmpty ? null : settingController.selectedPriority.value,
                        options: settingController.priorityList.map(
                          (element) {
                            return element;
                          },
                        ).toList(),
                        hintText: 'Select priority',
                        onChanged: (value) async {
                          // settingController.changeParty(value);
                          settingController.selectedPriority.value = value!;

                          if (kDebugMode) {
                            print(settingController.selectedPriority);
                          }
                        },
                      ),
                      height(1.h),
                      Text(
                        'Upload Document',
                        style: TextHelper.size14,
                      ),
                      height(5),
                      Text(
                        'Document in jpg, png, jpeg format with maximum 6MB can be uploaded.',
                        style: TextHelper.size12.copyWith(
                          color: ColorsForApp.errorColor,
                        ),
                      ),
                      height(10),
                      settingController.raisedDocumentFile.value.path.isNotEmpty
                          ? SizedBox(
                              height: 21.5.w,
                              width: 21.5.w,
                              child: Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      OpenResult openResult = await OpenFile.open(settingController.raisedDocumentFile.value.path);
                                      if (openResult.type != ResultType.done) {
                                        errorSnackBar(message: openResult.message);
                                      }
                                    },
                                    child: Container(
                                      height: 20.w,
                                      width: 20.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 1,
                                          color: ColorsForApp.greyColor.withOpacity(0.7),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(9),
                                        child: Image.file(
                                          settingController.raisedDocumentFile.value,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        settingController.raisedDocumentFile.value = File('');
                                      },
                                      child: Container(
                                        height: 6.w,
                                        width: 6.w,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: ColorsForApp.grayScale200,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.delete_rounded,
                                          color: ColorsForApp.errorColor,
                                          size: 4.5.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                imageSourceDailog(context);
                              },
                              child: Container(
                                width: 100,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: ColorsForApp.primaryColor,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: ColorsForApp.primaryColor,
                                      size: 20,
                                    ),
                                    width(5),
                                    Text(
                                      'Upload',
                                      style: TextHelper.size14.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: ColorsForApp.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                      height(2.h),
                      CustomTextFieldWithTitle(
                        title: "Transaction Id",
                        readOnly: false,
                        hintText: "transaction id",
                        controller: settingController.transactionIdTxtController,
                      ),
                      height(1.h),
                      CustomTextFieldWithTitle(
                          title: 'Message',
                          readOnly: false,
                          maxLength: 250,
                          maxLines: 5,
                          isCompulsory: true,
                          hintText: "message",
                          controller: settingController.messageTxtController,
                          validator: (value) {
                            if (settingController.messageTxtController.text.trim().isEmpty) {
                              return 'Please enter message';
                            }
                            return null;
                          }),
                      height(10),
                      CommonButton(
                        shadowColor: ColorsForApp.whiteColor,
                        onPressed: () async {
                          if (ticketFormKey.value.currentState!.validate()) {
                            if (settingController.selectedPriority.value == "Select priority") {
                              errorSnackBar(message: "Please select priority");
                            } else {
                              FocusScope.of(context).unfocus();
                              if (Get.isSnackbarOpen) {
                                Get.back();
                              }
                              bool result = await settingController.raiseComplaintAPI();
                              if (result == true) {
                                settingController.clearRaiseComplaintVariables();
                                ticketFormKey.value = GlobalKey<FormState>();
                              }
                            }
                          }
                        },
                        label: 'Proceed',
                        labelColor: ColorsForApp.whiteColor,
                        bgColor: ColorsForApp.primaryColor,
                      ),
                      height(10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Image source dailog
  Future<dynamic> imageSourceDailog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Text(
            'Select image source',
            style: TextHelper.size20.copyWith(
              fontFamily: mediumGoogleSansFont,
            ),
          ),
          content: Text(
            'Capture a photo or choose from your phone for quick processing.',
            style: TextHelper.size14.copyWith(
              color: ColorsForApp.lightBlackColor.withOpacity(0.7),
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    File capturedFile = File(await captureImage());
                    if (capturedFile.path.isNotEmpty) {
                      int fileSize = capturedFile.lengthSync();
                      int maxAllowedSize = 6 * 1024 * 1024;
                      if (fileSize > maxAllowedSize) {
                        errorSnackBar(message: 'File size should be less than 6 MB');
                      } else {
                        settingController.raisedDocumentFile.value = capturedFile;
                      }
                    }
                  },
                  splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                  highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                  child: Text(
                    'Take photo',
                    style: TextHelper.size14.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.primaryColorBlue,
                    ),
                  ),
                ),
                width(4.w),
                InkWell(
                  onTap: () async {
                    await PermissionHandlerPermissionService.handlePhotosPermission(context).then(
                      (bool photoPermission) async {
                        if (photoPermission == true) {
                          Get.back();
                          await openImagePicker(ImageSource.gallery).then(
                            (pickedFile) async {
                              if (pickedFile.path.isNotEmpty || pickedFile.path != '') {
                                int fileSize = pickedFile.lengthSync();
                                int maxAllowedSize = 6 * 1024 * 1024;
                                String fileExtension = extension(pickedFile.path);
                                if (fileSize > maxAllowedSize) {
                                  errorSnackBar(message: 'File size should be less than 6 MB');
                                } else {
                                  if (fileExtension.toLowerCase() == '.jpeg' || fileExtension.toLowerCase() == '.jpg' || fileExtension.toLowerCase() == '.png') {
                                    settingController.raisedDocumentFile.value = pickedFile;
                                  } else {
                                    errorSnackBar(message: 'Unsupported Format');
                                  }
                                }
                              }
                            },
                          );
                        }
                      },
                    );
                  },
                  splashColor: ColorsForApp.primaryColorBlue.withOpacity(0.1),
                  highlightColor: ColorsForApp.primaryColorBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(100),
                  child: Text(
                    'Choose from phone',
                    style: TextHelper.size14.copyWith(
                      fontFamily: mediumGoogleSansFont,
                      color: ColorsForApp.primaryColorBlue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

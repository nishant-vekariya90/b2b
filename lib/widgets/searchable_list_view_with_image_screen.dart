import '../controller/setting_controller.dart';
import '../model/dispute_category_model.dart';
import '../model/dispute_child_category_model.dart';
import '../model/dispute_sub_category_model.dart';
import '../widgets/avatar_from_name.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../generated/assets.dart';
import '../model/master/bank_list_model.dart';
import '../model/master/operator_list_model.dart';
import 'button.dart';
import 'constant_widgets.dart';
import 'network_image.dart';
import 'text_field.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';

class SearchAbelListViewWithImageScreen extends StatefulWidget {
  const SearchAbelListViewWithImageScreen({super.key});

  @override
  State<SearchAbelListViewWithImageScreen> createState() => _SearchAbelListViewWithImageScreenState();
}

class _SearchAbelListViewWithImageScreenState extends State<SearchAbelListViewWithImageScreen> {
  late SettingController settingController;
  final List modelList = Get.arguments[0];
  final String modelName = Get.arguments[1];
  RxList searchedList = [].obs;

  @override
  void initState() {
    super.initState();
    if (modelName == 'CategoryList' || modelName == 'SubCategoryList') {
      settingController = Get.find();
    }
    searchedList.assignAll(modelList);
  }

  searchFromOptions(String value) async {
    searchedList.clear();
    if (value.isEmpty) {
      searchedList.assignAll(modelList);
    } else {
      if (modelName == 'operatorList') {
        List<MasterOperatorListModel> masterOperatorListModel = modelList as List<MasterOperatorListModel>;
        List<MasterOperatorListModel> tempList = masterOperatorListModel.where((element) {
          return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
        }).toList();
        searchedList.assignAll(tempList);
      } else if (modelName == 'bankList') {
        List<MasterBankListModel> masterBankListModel = modelList as List<MasterBankListModel>;
        List<MasterBankListModel> tempList = masterBankListModel.where((element) {
          return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
        }).toList();
        searchedList.assignAll(tempList);
      } else if (modelName == 'contactList') {
        List<Contact> contactModelList = modelList as List<Contact>;
        List<Contact> tempList = contactModelList.where((element) {
          return (element.displayName?.toLowerCase().contains(value.toLowerCase()) ?? false) || (element.phones!.isNotEmpty ? element.phones?.first.value!.toLowerCase().contains(value.toLowerCase()) ?? false : false);
        }).toList();
        searchedList.assignAll(tempList);
      } else if (modelName == 'CategoryList') {
        List<DisputeCategoryModel> categoryListModel = modelList as List<DisputeCategoryModel>;
        List<DisputeCategoryModel> tempList = categoryListModel.where((element) {
          return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
        }).toList();
        searchedList.assignAll(tempList);
      } else if (modelName == 'SubCategoryList') {
        List<DisputeSubCategoryModel> categoryListModel = modelList as List<DisputeSubCategoryModel>;
        List<DisputeSubCategoryModel> tempList = categoryListModel.where((element) {
          return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
        }).toList();
        searchedList.assignAll(tempList);
      } else if (modelName == 'ChildCategoryList') {
        List<DisputeChildCategoryModel> categoryListModel = modelList as List<DisputeChildCategoryModel>;
        List<DisputeChildCategoryModel> tempList = categoryListModel.where((element) {
          return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
        }).toList();
        searchedList.assignAll(tempList);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(
          result: modelName == 'operatorList'
              ? MasterOperatorListModel()
              : modelName == 'bankList'
                  ? MasterBankListModel()
                  : modelName == 'contactList'
                      ? Contact()
                      : modelName == 'CategoryList'
                          ? DisputeCategoryModel()
                          : modelName == 'SubCategoryList'
                              ? DisputeSubCategoryModel()
                              : modelName == 'ChildCategoryList'
                                  ? DisputeSubCategoryModel()
                                  : DisputeSubCategoryModel(),
        );
        return false;
      },
      child: Stack(
        children: [
          Container(
            height: AppBar().preferredSize.height + MediaQuery.of(context).padding.top + kToolbarHeight,
            width: 100.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Assets.imagesDashboardBgWithoutCircle,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: GestureDetector(
                  onTap: () {
                    Get.back(
                      result: modelName == 'operatorList'
                          ? MasterOperatorListModel()
                          : modelName == 'bankList'
                              ? MasterBankListModel()
                              : modelName == 'contactList'
                                  ? Contact()
                                  : modelName == 'CategoryList'
                                      ? DisputeCategoryModel()
                                      : modelName == 'SubCategoryList'
                                          ? DisputeSubCategoryModel()
                                          : modelName == 'ChildCategoryList'
                                              ? DisputeSubCategoryModel()
                                              : DisputeSubCategoryModel(),
                    );
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: ColorsForApp.whiteColor,
                  ),
                ),
                centerTitle: true,
                title: CustomTextField(
                  style: TextHelper.size14.copyWith(
                    color: ColorsForApp.whiteColor,
                    fontWeight: FontWeight.normal,
                  ),
                  hintText: 'Search here...',
                  suffixIcon: Icon(
                    Icons.search_rounded,
                    color: ColorsForApp.whiteColor,
                  ),
                  cursorColor: ColorsForApp.whiteColor,
                  hintTextColor: ColorsForApp.whiteColor.withOpacity(0.7),
                  focusedBorderColor: ColorsForApp.whiteColor,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onChange: (value) {
                    searchFromOptions(value);
                  },
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(1.h),
                  child: height(1.h),
                ),
              ),
              body: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  height: 100.h,
                  width: 100.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Obx(
                    () => searchedList.isEmpty
                        ? notFoundText(text: 'No data found')
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                            itemCount: searchedList.length,
                            itemBuilder: (context, index) {
                              if (modelName == 'operatorList') {
                                MasterOperatorListModel masterOperatorListModel = searchedList[index];
                                return InkWell(
                                  onTap: () {
                                    Get.back(result: masterOperatorListModel);
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorsForApp.primaryColor.withOpacity(0.1),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: ColorsForApp.greyColor.withOpacity(0.3),
                                                  width: 1,
                                                ),
                                              ),
                                              child: masterOperatorListModel.fileUrl != null && masterOperatorListModel.fileUrl!.isNotEmpty
                                                  ? ClipRRect(
                                                      borderRadius: BorderRadius.circular(100),
                                                      child: Image.network(
                                                        masterOperatorListModel.fileUrl!,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : AvatarFromName(
                                                      name: masterOperatorListModel.name != null && masterOperatorListModel.name!.isNotEmpty ? masterOperatorListModel.name! : '',
                                                    ),
                                            ),
                                          ),
                                          width(4.w),
                                          Flexible(
                                            child: Text(
                                              masterOperatorListModel.name != null && masterOperatorListModel.name!.isNotEmpty ? masterOperatorListModel.name! : '',
                                              style: TextHelper.size14.copyWith(
                                                color: ColorsForApp.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      height(10),
                                      Row(
                                        children: [
                                          Container(
                                            height: 0,
                                            width: 50 + 4.w,
                                            color: Colors.transparent,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: ColorsForApp.greyColor.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else if (modelName == 'bankList') {
                                MasterBankListModel masterBankListModel = searchedList[index];
                                return InkWell(
                                  onTap: () {
                                    Get.back(result: masterBankListModel);
                                  },
                                  child: Column(
                                    children: [
                                      index == 0 ? height(15) : height(0),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: ShowNetworkImage(
                                              networkUrl: masterBankListModel.fileUrl != null && masterBankListModel.fileUrl!.isNotEmpty ? masterBankListModel.fileUrl! : '',
                                              defaultImagePath: Assets.imagesDefaultBank,
                                            ),
                                          ),
                                          width(4.w),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                masterBankListModel.name != null && masterBankListModel.name!.isNotEmpty ? masterBankListModel.name! : '',
                                                style: TextHelper.size14.copyWith(
                                                  color: ColorsForApp.primaryColor,
                                                ),
                                              ),
                                              height(0.5.h),
                                              Text(
                                                masterBankListModel.accountNumber != null && masterBankListModel.accountNumber!.isNotEmpty ? '(${masterBankListModel.accountNumber})' : '',
                                                style: TextHelper.size13.copyWith(
                                                  color: ColorsForApp.lightBlackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      height(10),
                                      Row(
                                        children: [
                                          Container(
                                            height: 0,
                                            width: 50 + 4.w,
                                            color: Colors.transparent,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: ColorsForApp.greyColor.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else if (modelName == 'contactList') {
                                Contact contactModel = searchedList[index];
                                return InkWell(
                                  onTap: () {
                                    Get.back(result: contactModel);
                                  },
                                  child: Column(
                                    children: [
                                      index == 0 ? height(15) : height(0),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorsForApp.primaryColor.withOpacity(0.1),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: ColorsForApp.greyColor.withOpacity(0.3),
                                                  width: 1,
                                                ),
                                              ),
                                              child: contactModel.avatar != null && contactModel.avatar!.isNotEmpty
                                                  ? ClipRRect(
                                                      borderRadius: BorderRadius.circular(100),
                                                      child: Image.memory(
                                                        contactModel.avatar!,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : AvatarFromName(
                                                      name: contactModel.displayName != null && contactModel.displayName!.isNotEmpty ? contactModel.displayName! : '',
                                                    ),
                                            ),
                                          ),
                                          width(4.w),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                contactModel.displayName != null && contactModel.displayName!.isNotEmpty ? contactModel.displayName! : '',
                                                style: TextHelper.size14.copyWith(
                                                  color: ColorsForApp.primaryColor,
                                                ),
                                              ),
                                              height(0.5.h),
                                              Text(
                                                contactModel.phones!.first.value != null && contactModel.phones!.first.value!.isNotEmpty ? '(${contactModel.phones!.first.value!})' : '',
                                                style: TextHelper.size13.copyWith(
                                                  color: ColorsForApp.lightBlackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      height(10),
                                      Row(
                                        children: [
                                          Container(
                                            height: 0,
                                            width: 50 + 4.w,
                                            color: Colors.transparent,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: ColorsForApp.greyColor.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else if (modelName == 'CategoryList') {
                                DisputeCategoryModel categoryListModel = searchedList[index];
                                return InkWell(
                                  onTap: () {
                                    Get.back(result: categoryListModel);
                                    settingController.disputeSubCategoryController.clear();
                                    settingController.selectedSubCategory.value = 0;
                                    settingController.selectedCategory.value = 0;
                                    settingController.disputeSubCategoryList.clear();
                                    settingController.disputeChildCategoryController.clear();
                                    settingController.disputeChildCategoryList.clear();
                                  },
                                  child: Column(
                                    children: [
                                      index == 0 ? height(15) : height(0),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: ShowNetworkImage(
                                              networkUrl: categoryListModel.icon != null && categoryListModel.icon!.isNotEmpty ? categoryListModel.icon! : '',
                                              defaultImagePath: Assets.iconsRaiseComplaint,
                                            ),
                                          ),
                                          width(4.w),
                                          Flexible(
                                            child: Text(
                                              categoryListModel.name != null && categoryListModel.name!.isNotEmpty ? categoryListModel.name! : '',
                                              style: TextHelper.size14.copyWith(
                                                color: ColorsForApp.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      height(10),
                                      Row(
                                        children: [
                                          Container(
                                            height: 0,
                                            width: 50 + 4.w,
                                            color: Colors.transparent,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: ColorsForApp.greyColor.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else if (modelName == 'SubCategoryList') {
                                DisputeSubCategoryModel categoryListModel = searchedList[index];
                                return InkWell(
                                  onTap: () {
                                    Get.back(result: categoryListModel);
                                    settingController.disputeChildCategoryController.clear();
                                    settingController.disputeChildCategoryList.clear();
                                  },
                                  child: Column(
                                    children: [
                                      index == 0 ? height(15) : height(0),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: ShowNetworkImage(
                                              networkUrl: categoryListModel.icon != null && categoryListModel.icon!.isNotEmpty ? categoryListModel.icon! : '',
                                              defaultImagePath: Assets.iconsRaiseComplaint,
                                            ),
                                          ),
                                          width(4.w),
                                          Flexible(
                                            child: Text(
                                              categoryListModel.name != null && categoryListModel.name!.isNotEmpty ? categoryListModel.name! : '',
                                              style: TextHelper.size14.copyWith(
                                                color: ColorsForApp.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      height(10),
                                      Row(
                                        children: [
                                          Container(
                                            height: 0,
                                            width: 50 + 4.w,
                                            color: Colors.transparent,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: ColorsForApp.greyColor.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else if (modelName == 'ChildCategoryList') {
                                DisputeChildCategoryModel categoryListModel = searchedList[index];
                                return InkWell(
                                  onTap: () {
                                    Get.back(result: categoryListModel);
                                  },
                                  child: Column(
                                    children: [
                                      index == 0 ? height(15) : height(0),
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: ShowNetworkImage(
                                              networkUrl: categoryListModel.icon != null && categoryListModel.icon!.isNotEmpty ? categoryListModel.icon! : '',
                                              defaultImagePath: Assets.iconsRaiseComplaint,
                                            ),
                                          ),
                                          width(4.w),
                                          Flexible(
                                            child: Text(
                                              categoryListModel.name != null && categoryListModel.name!.isNotEmpty ? categoryListModel.name! : '',
                                              style: TextHelper.size14.copyWith(
                                                color: ColorsForApp.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      height(10),
                                      Row(
                                        children: [
                                          Container(
                                            height: 0,
                                            width: 50 + 4.w,
                                            color: Colors.transparent,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: 1,
                                              color: ColorsForApp.greyColor.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return height(10);
                            },
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

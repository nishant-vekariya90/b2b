import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/product_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/product/product_main_category_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/network_image.dart';
import '../../../../../widgets/text_field.dart';

class AllCategoryScreen extends StatefulWidget {
  const AllCategoryScreen({super.key});

  @override
  State<AllCategoryScreen> createState() => _AllCategoryScreenState();
}

class _AllCategoryScreenState extends State<AllCategoryScreen> {
  final ProductController productController = Get.find();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await productController.getCategoryApi();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 6.5.h,
      topCenterWidget: SizedBox(
        height: 6.5.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: 45,
                child: CustomTextField(
                  style: TextHelper.size14.copyWith(
                    fontFamily: mediumGoogleSansFont,
                    color: ColorsForApp.lightBlackColor,
                  ),
                  hintText: 'Search product here...',
                  cursorColor: ColorsForApp.lightBlackColor,
                  suffixIcon: Icon(
                    Icons.search,
                    color: ColorsForApp.primaryColor,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    focusColor: const Color(0xFFFACCCC),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0.5, color: Color(0xFFFACCCC)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0.5, color: Color(0xFFF2F2F7)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0.5, color: Color(0xFFF2F2F7)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Search here',
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  onChange: (value) {
                    productController.searchInCategoryList(value);
                  },
                ),
              ),
            )
          ],
        ),
      ),
      title: 'All Categories',
      onBackIconTap: () {
        productController.filteredCategoryList.clear();
        Get.back();
      },
      isShowLeadingIcon: true,
      mainBody: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [height(2.h), Expanded(child: productController.filteredCategoryList.isNotEmpty ? allCategoryListUI(context) : notFoundText(text: "No category found"))],
        ),
      ),
    );
  }

  Widget allCategoryListUI(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, childAspectRatio: 2 / 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        ProductMainCategoryModel productItem = productController.filteredCategoryList[index];
        return customCard(
          child: InkWell(
            onTap: () {
              productController.selectedCategoryId.value = productItem.id.toString();
              Get.toNamed(Routes.ALL_PRODUCT_SCREEN, arguments: false);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.5.h),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child: ShowNetworkImage(
                    networkUrl: productItem.iconUrl != null && productItem.iconUrl!.isNotEmpty ? productItem.iconUrl! : '',
                    defaultImagePath: Assets.imagesImageNotAvailable,
                    isShowBorder: false,
                    fit: BoxFit.contain,
                    boxShape: BoxShape.rectangle,
                  ),
                ),
                height(1.h),
                Text(
                  productItem.name!,
                  style: TextHelper.size15.copyWith(
                    fontFamily: mediumGoogleSansFont,
                    color: ColorsForApp.primaryColor,
                  ),
                )
              ]),
            ),
          ),
        );
      },
      itemCount: productController.filteredCategoryList.length,
      controller: scrollController,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/product_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/product/all_product_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/network_image.dart';
import '../../../../../widgets/text_field.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  final ProductController productController = Get.find();
  ScrollController scrollController = ScrollController();
  final bool isBestSeller = Get.arguments;

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      if (isBestSeller == true) {
        await productController.getAllProductList(pageNumber: productController.currentPage.value, isBestSeller: 'true');
        scrollController.addListener(() async {
          if (scrollController.position.maxScrollExtent == scrollController.position.pixels && productController.currentPage.value < productController.totalPages.value) {
            productController.currentPage.value++;
            await productController.getAllProductList(
              pageNumber: productController.currentPage.value,
              isBestSeller: 'true',
              isLoaderShow: false,
            );
          }
        });
      } else {
        await productController.getAllProductList(pageNumber: productController.currentPage.value, isBestSeller: '');
        scrollController.addListener(() async {
          if (scrollController.position.maxScrollExtent == scrollController.position.pixels && productController.currentPage.value < productController.totalPages.value) {
            productController.currentPage.value++;
            await productController.getAllProductList(
              pageNumber: productController.currentPage.value,
              isBestSeller: '',
              isLoaderShow: false,
            );
          }
        });
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    productController.resetAllProductsVariables();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarHeight: 6.5.h,
      title: isBestSeller == true ? 'Best Seller products' : 'All Products',
      isShowLeadingIcon: true,
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
                    productController.searchInProductList(value);
                  },
                ),
              ),
            )
          ],
        ),
      ),
      mainBody: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height(2.h),
            Expanded(
              child: productController.filteredProductList.isNotEmpty
                  ? allProductListUI(context)
                  : notFoundText(
                      text: "No products found",
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget allProductListUI(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        AllProductListModel productItem = productController.filteredProductList[index];
        return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(13),
              color: Colors.white,
            ),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                SizedBox(
                  height: 18.h,
                  width: 40.w,
                  child: ShowNetworkImage(
                    networkUrl: productItem.mainImage != null && productItem.mainImage!.isNotEmpty ? productItem.mainImage! : '',
                    defaultImagePath: Assets.imagesImageNotAvailable,
                    isShowBorder: false,
                    fit: BoxFit.contain,
                    boxShape: BoxShape.rectangle,
                  ),
                ),
                Flexible(
                  child: Text(productItem.name!.toTitleCase(), style: TextHelper.size14.copyWith(color: ColorsForApp.lightBlackColor, fontWeight: FontWeight.w400)),
                ),
                Text(productItem.shortDescription!.toTitleCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextHelper.size12.copyWith(
                      color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                    )),
                Wrap(
                  children: [
                    Text("₹ ${productItem.salePrice!.toStringAsFixed(2)}", style: TextHelper.size14.copyWith(color: ColorsForApp.primaryColor, fontWeight: FontWeight.w400)),
                    width(2.w),
                    Text("₹ ${productItem.price!.toStringAsFixed(2)}",
                        style: TextHelper.size13.copyWith(
                          color: ColorsForApp.errorColor,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.lineThrough,
                        )),
                  ],
                ),
                height(1.h),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.PRODUCT_DETAIL_SCREEN, arguments: productItem);
                  },
                  child: Container(
                    height: 5.h,
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        color: ColorsForApp.lightBlueColor.withOpacity(0.3),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                          child: Lottie.asset(
                            Assets.animationsCartAnimation,
                          ),
                        ),
                        Text("Buy Now", style: TextHelper.size14.copyWith(color: ColorsForApp.primaryColor, fontWeight: FontWeight.bold, fontFamily: boldGoogleSansFont)),
                      ],
                    ),
                  ),
                )
              ]),
            ));
      },
      itemCount: productController.filteredProductList.length,
      controller: scrollController,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        mainAxisExtent: 285,
        maxCrossAxisExtent: 200,
      ),
    );
  }
}

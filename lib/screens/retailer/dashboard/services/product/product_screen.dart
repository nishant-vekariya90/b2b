import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/product_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/product/all_product_model.dart';
import '../../../../../model/product/product_main_category_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/string_constants.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/dash_line.dart';
import '../../../../../widgets/network_image.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductController productController = Get.find();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await productController.getCategoryApi();
      await productController.getAllProductList(
        pageNumber: productController.currentPage.value,
        isBestSeller: 'true',
      );
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsForApp.creamColor,
      body: Obx(
        () => CustomScrollView(
          slivers: [
            const SliverPersistentHeader(
              delegate: SliverSearchAppBar(),
              // Set this param so that it won't go off the screen when scrolling
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    width: 100.w,
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextHelper.size15.copyWith(
                            fontFamily: boldGoogleSansFont,
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            // this variable is for mange route stack when we back from order status page
                            productController.isRouteFromBestSeller.value = false;
                            await Get.toNamed(Routes.ALL_CATEGORY_SCREEN);
                            showProgressIndicator();
                            productController.filteredProductList.clear();
                            productController.bestSellerProductList.clear();
                            productController.selectedCategoryId.value = '';
                            await productController.getCategoryApi(isLoaderShow: false);
                            await productController.getAllProductList(
                              pageNumber: productController.currentPage.value,
                              isBestSeller: 'true',
                              isLoaderShow: false,
                            );
                            dismissProgressIndicator();
                          },
                          child: Text(
                            'See all',
                            style: TextHelper.size14.copyWith(
                              fontFamily: mediumGoogleSansFont,
                              color: ColorsForApp.greyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  mainCategoryListView(context),
                  height(2.h),
                  bestSellerUI()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget mainCategoryListView(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 20.h,
        child: productController.filteredCategoryList.isNotEmpty
            ? ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: productController.filteredCategoryList.take(5).length,
                itemBuilder: (context, index) {
                  ProductMainCategoryModel productMainCategoryModel = productController.filteredCategoryList[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      width: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 3,
                            offset: const Offset(3, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  productMainCategoryModel.name!,
                                  style: TextHelper.size14.copyWith(
                                    color: ColorsForApp.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                height(8),
                                ElevatedButton(
                                  onPressed: () async {
                                    // this variable is for mange route stack when we back from order status page
                                    productController.isRouteFromBestSeller.value = false;
                                    productController.selectedCategoryId.value = productMainCategoryModel.id.toString();
                                    await Get.toNamed(
                                      Routes.ALL_PRODUCT_SCREEN,
                                      arguments: false, // pass isBestSeller=false
                                    );
                                    productController.filteredProductList.clear();
                                    productController.bestSellerProductList.clear();
                                    productController.selectedCategoryId.value = '';
                                    await productController.getAllProductList(
                                      pageNumber: productController.currentPage.value,
                                      isBestSeller: 'true',
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorsForApp.primaryColor,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: Text(
                                    'Get Now',
                                    style: TextHelper.size14.copyWith(
                                      color: ColorsForApp.whiteColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                            width: 40.w,
                            child: ShowNetworkImage(
                              networkUrl: productController.filteredCategoryList[index].iconUrl != null && productController.filteredCategoryList[index].iconUrl!.isNotEmpty ? productController.filteredCategoryList[index].iconUrl! : '',
                              defaultImagePath: Assets.imagesImageNotAvailable,
                              isShowBorder: false,
                              fit: BoxFit.contain,
                              boxShape: BoxShape.rectangle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'No category found..',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorsForApp.blueColor,
                  ),
                ),
              ),
      ),
    );
  }

  Widget bestSellerUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100.w,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best Seller',
                style: TextHelper.size15.copyWith(
                  fontFamily: boldGoogleSansFont,
                  color: ColorsForApp.primaryColor,
                ),
              ),
              InkWell(
                onTap: () async {
                  // this variable is for mange route stack when we back from order status page
                  productController.isRouteFromBestSeller.value = false;
                  await Get.toNamed(
                    Routes.ALL_PRODUCT_SCREEN,
                    arguments: true, // pass isBestSeller=true
                  );
                  productController.filteredProductList.clear();
                  productController.bestSellerProductList.clear();
                  productController.selectedCategoryId.value = '';
                  await productController.getAllProductList(
                    pageNumber: productController.currentPage.value,
                    isBestSeller: 'true',
                  );
                },
                child: Text(
                  'See all',
                  style: TextHelper.size14.copyWith(
                    fontFamily: mediumGoogleSansFont,
                    color: ColorsForApp.greyColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        height(1.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DashedLine(
            color: ColorsForApp.greyColor,
            width: 4,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          itemCount: productController.bestSellerProductList.take(4).length,
          itemBuilder: (context, index) {
            AllProductListModel productItem = productController.bestSellerProductList[index];
            return SizedBox(
              width: 100.w,
              child: Container(
                margin: const EdgeInsets.only(top: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(
                    color: ColorsForApp.greyColor.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: const Offset(5, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                      width: 30.w,
                      child: ShowNetworkImage(
                        networkUrl: productItem.mainImage!.isNotEmpty ? productItem.mainImage! : '',
                        defaultImagePath: Assets.imagesImageNotAvailable,
                        isShowBorder: false,
                        fit: BoxFit.contain,
                        boxShape: BoxShape.rectangle,
                      ),
                    ),
                    width(4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productItem.name!.toTitleCase(),
                            style: TextHelper.size14.copyWith(
                              color: ColorsForApp.primaryColor,
                            ),
                          ),
                          Wrap(
                            children: [
                              Text(
                                '₹ ${productItem.isDiscount == true ? productItem.salePrice != null ? productItem.salePrice!.toStringAsFixed(2) : '0.00' : productItem.price != null ? productItem.price!.toStringAsFixed(2) : '0.00'}',
                                style: TextHelper.size14.copyWith(
                                  color: ColorsForApp.primaryColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              width(2.w),
                              Visibility(
                                visible: productItem.isDiscount == true && productItem.price != null ? true : false,
                                child: Text(
                                  '₹ ${productItem.price!.toStringAsFixed(2)}',
                                  style: TextHelper.size13.copyWith(
                                    color: ColorsForApp.errorColor,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(productItem.shortDescription!.toTitleCase(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextHelper.size12.copyWith(
                                color: ColorsForApp.lightBlackColor.withOpacity(0.6),
                              )),
                          height(1.h),
                          InkWell(
                            onTap: () {
                              // this variable is for mange route stack when we back from order status page
                              productController.isRouteFromBestSeller.value = true;
                              Get.toNamed(
                                Routes.PRODUCT_DETAIL_SCREEN,
                                arguments: productItem,
                              );
                            },
                            child: Container(
                              height: 4.h,
                              width: 20.w,
                              margin: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: ColorsForApp.lightBlueColor.withOpacity(0.3),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Buy Now',
                                    style: TextHelper.size13.copyWith(
                                      color: ColorsForApp.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: boldGoogleSansFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        height(1.h),
      ],
    );
  }
}

class SliverSearchAppBar extends SliverPersistentHeaderDelegate {
  const SliverSearchAppBar();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    var adjustedShrinkOffset = shrinkOffset > minExtent ? minExtent : shrinkOffset;
    double offset = (minExtent - adjustedShrinkOffset) * 0.1;
    double topPadding = 2.h;
    // Calculate opacity based on shrinkOffset
    double opacity = 1.0 - (adjustedShrinkOffset / minExtent);
    // Calculate scale factor based on shrinkOffset
    double scale = 1.0 - (adjustedShrinkOffset / minExtent);
    return Stack(
      children: [
        const BackgroundWave(
          height: 280,
        ),
        Positioned(
          top: topPadding + offset,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: ColorsForApp.lightBlackColor,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Hello ${getStoredUserBasicDetails().ownerName}',
                            style: TextHelper.size18.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: boldGoogleSansFont,
                            ),
                          ),
                          Text(
                            'Lets gets somethings?',
                            style: TextHelper.size15.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: Lottie.asset(
                          Assets.animationsShoppingAnimation,
                          height: 9.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SearchBar(),
            ],
          ),
        )
      ],
    );
  }

  @override
  double get maxExtent => 250; //old 280

  @override
  double get minExtent => 160;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
}

class SearchBar extends StatelessWidget {
  final pink = const Color(0xFFFACCCC);
  final grey = const Color(0xFFF2F2F7);
  final ProductController productController = Get.find();
  SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          focusColor: pink,
          focusedBorder: border(pink),
          border: border(grey),
          enabledBorder: border(grey),
          hintText: 'Search here',
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.grey,
          ),
        ),
        onChanged: (value) {
          productController.searchInCategoryList(value);
        },
      ),
    );
  }

  OutlineInputBorder border(Color color) => OutlineInputBorder(
        borderSide: BorderSide(width: 0.5, color: color),
        borderRadius: BorderRadius.circular(12),
      );
}

class BackgroundWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    const minSize = 100.0;

    // when h = max = 280
    // h = 280, p1 = 210, p1Diff = 70
    // when h = min = 140
    // h = 140, p1 = 140, p1Diff = 0
    final p1Diff = ((minSize - size.height) * 0.5).truncate().abs();
    path.lineTo(0.0, size.height - p1Diff);

    final controlPoint = Offset(size.width * 0.4, size.height);
    final endPoint = Offset(size.width, minSize);

    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(BackgroundWaveClipper oldClipper) => oldClipper != this;
}

class BackgroundWave extends StatelessWidget {
  final double height;

  const BackgroundWave({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipPath(
          clipper: BackgroundWaveClipper(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    Assets.imagesAppBarBgImage,
                  ),
                ),
                gradient: LinearGradient(
                  colors: [Color(0xFFFACCCC), Color(0xFFF6EFE9)],
                )),
          )),
    );
  }
}

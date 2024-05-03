import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../controller/product_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../model/product/all_product_model.dart';
import '../../../../../routes/routes.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/network_image.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductController productController = Get.find();
  final AllProductListModel productDetails = Get.arguments;
  RxList productImageList = [].obs;

  @override
  void initState() {
    productController.productNameController.text = productDetails.name!;
    if (productDetails.videoLink != null && productDetails.videoLink!.isNotEmpty && productDetails.videoType == 0) {
      initializeVideoPlayer(productDetails.videoLink!);
      productImageList.add(productDetails.videoLink!);
    }
    if (productDetails.mainImage != null && productDetails.mainImage!.isNotEmpty) {
      productImageList.add(productDetails.mainImage!);
    }
    if (productDetails.subImage1 != null && productDetails.subImage1!.isNotEmpty) {
      productImageList.add(productDetails.subImage1!);
    }
    if (productDetails.subImage2 != null && productDetails.subImage2!.isNotEmpty) {
      productImageList.add(productDetails.subImage2!);
    }
    if (productDetails.subImage3 != null && productDetails.subImage3!.isNotEmpty) {
      productImageList.add(productDetails.subImage3!);
    }
    if (productDetails.subImage4 != null && productDetails.subImage4!.isNotEmpty) {
      productImageList.add(productDetails.subImage4!);
    }
    if (productDetails.subImage5 != null && productDetails.subImage5!.isNotEmpty) {
      productImageList.add(productDetails.subImage5!);
    }
    super.initState();
  }

  void initializeVideoPlayer(String url) {
    productController.videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) async {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    productController.quantity.value = 0;
    productController.totalPrice.value = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsForApp.creamColor,
        extendBodyBehindAppBar: true,
        appBar: appBar,
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  productImageView(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        productDetails.isBestSeller!
                            ? Container(
                                height: 2.h,
                                width: 25.w,
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      Assets.imagesBestSellerBg,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Text(
                                  "#1 Best Seller",
                                  style: TextHelper.size13.copyWith(
                                    color: ColorsForApp.whiteColor,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        height(1.h),
                        Text(
                          productDetails.name!.toTitleCase(),
                          style: TextHelper.size18.copyWith(
                            fontWeight: FontWeight.w700,
                            fontFamily: boldGoogleSansFont,
                          ),
                        ),
                        height(0.5.h),
                        Row(
                          children: [
                            Text(
                              '₹ ${productDetails.isDiscount == true ? productDetails.salePrice != null ? productDetails.salePrice!.toStringAsFixed(2) : '0.00' : productDetails.price != null ? productDetails.price!.toStringAsFixed(2) : '0.00'}',
                              style: TextHelper.size15.copyWith(
                                color: ColorsForApp.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            width(3),
                            Visibility(
                              visible: productDetails.isDiscount == true && productDetails.price != null ? true : false,
                              child: Text(
                                '₹ ${productDetails.price}',
                                style: TextHelper.size13.copyWith(
                                  color: ColorsForApp.errorColor,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                            width(3),
                            const Spacer(),
                            Text(
                              productDetails.isInStock! ? "Available in stock" : "Not in stock",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                        height(0.5.h),
                        // Discount
                        productDetails.discount != null && productDetails.discount! > 0
                            ? Text(
                                '${productDetails.discount!.toStringAsFixed(2)}% Off',
                                style: TextHelper.size13.copyWith(
                                  color: ColorsForApp.successColor,
                                ),
                              )
                            : Container(),
                        height(0.5.h),
                        productDetails.isInStock!
                            ? Text(
                                "Inclusive of all taxes",
                                style: TextHelper.size13.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : const SizedBox(),
                        height(1.h),
                        customTitleWithDetails(
                          'Available Qty',
                          productDetails.availableUnits.toString(),
                        ),
                        height(1.h),
                        Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  splashRadius: 10.0,
                                  onPressed: () => productController.decreaseItemQuantity(productDetails),
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Color(0xFFEC6813),
                                  ),
                                ),
                                AnimatedSwitcherWrapper(
                                  child: Text(
                                    '${productController.quantity.value}',
                                    key: ValueKey<int>(
                                      productController.quantity.value,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  splashRadius: 10.0,
                                  onPressed: () => productController.increaseItemQuantity(productDetails),
                                  icon: const Icon(
                                    Icons.add,
                                    color: Color(0xFFEC6813),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: ColorsForApp.greyColor.withOpacity(0.2),
                        ),
                        Text(
                          "Product Details",
                          style: TextHelper.size15.copyWith(
                            fontWeight: FontWeight.w700,
                            fontFamily: boldGoogleSansFont,
                          ),
                        ),
                        height(0.5.h),
                        productDetails.description!.isNotEmpty && productDetails.description != ''
                            ? ExpandableText(
                                productDetails.description!,
                                expandText: 'Read more',
                                collapseText: 'Read less',
                                maxLines: 2,
                                linkColor: Colors.blue,
                              )
                            : const Text('-'),
                        height(1.h),
                        productDetails.videoType == 1 && productDetails.videoLink != null && productDetails.videoLink!.isNotEmpty
                            ? InkWell(
                                onTap: () {
                                  openUrl(url: productDetails.videoLink!);
                                },
                                child: Text(
                                  productDetails.videoLink!,
                                  style: TextHelper.size12.copyWith(color: Colors.blue),
                                ),
                              )
                            : Container(),
                        height(1.h),
                        customTitleWithDetails('Brand Name', productDetails.brandName!),
                        height(1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            productDetails.isReturnable! ? productConditionUI(icons: Assets.imagesReturnExchnageIcon, title: 'Return & Exchange') : const SizedBox(),
                            productDetails.isCOD! ? productConditionUI(icons: Assets.imagesCashOnDeliverIcon, title: 'Pay On Delivery') : const SizedBox(),
                            productDetails.isCOD! ? productConditionUI(icons: Assets.imagesReturnExchnageIcon, title: 'Cancellable') : const SizedBox(),
                          ],
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          bottomTotalAmountUI(),
                          height(2.h),
                          Obx(
                            () => productController.totalPrice.value > 0
                                ? CommonButton(
                                    onPressed: () {
                                      if (productController.quantity.value < productDetails.minQnty!) {
                                        infoSnackBar(message: "Sorry, please add at least ${productDetails.minQnty} items");
                                      } else {
                                        productController.productUnqId.value = productDetails.unqId!;
                                        Get.toNamed(Routes.ADDRESS_SCREEN);
                                      }
                                    },
                                    label: 'Proceed',
                                  )
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar get appBar {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }

  Widget productImageView() {
    return Container(
        height: 35.h,
        width: 100.w,
        decoration: const BoxDecoration(
          color: Color(0xFFE5E6E8),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(200),
            bottomLeft: Radius.circular(200),
          ),
        ),
        child: Obx(() => Column(
              children: [
                SizedBox(
                  height: 30.h,
                  child: PageView.builder(
                    itemCount: productImageList.length,
                    onPageChanged: (int currentIndex) {
                      productController.currentIndex.value = currentIndex;
                    },
                    itemBuilder: (_, index) {
                      if (productImageList[index].contains(".mp4")) {
                        return Container(
                          height: 10.h,
                          margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: AspectRatio(
                              aspectRatio: productController.videoPlayerController!.value.aspectRatio,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (Get.isSnackbarOpen) {
                                        Get.back(); // Close the current snackbar
                                      }
                                      if (productController.videoPlayerController!.value.isPlaying) {
                                        productController.videoPlayerController!.pause();
                                      } else {
                                        productController.videoPlayerController!.play();
                                      }
                                    },
                                    child: VideoPlayer(productController.videoPlayerController!),
                                  ),
                                  VideoProgressIndicator(
                                    productController.videoPlayerController!,
                                    allowScrubbing: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.h, vertical: 6.h),
                        child: ShowNetworkImage(
                          networkUrl: productImageList[index].isNotEmpty ? productImageList[index] : '',
                          defaultImagePath: Assets.imagesImageNotAvailable,
                          isShowBorder: false,
                          fit: BoxFit.contain,
                          boxShape: BoxShape.rectangle,
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    productImageList.toList().length,
                    (index) {
                      return Container(
                        margin: const EdgeInsets.all(3),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: productController.currentIndex.value == index ? Colors.deepOrange : Colors.black26,
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ),
              ],
            )));
  }

  Widget productConditionUI({required String icons, required String title}) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 2.2.h,
            backgroundColor: Colors.transparent,
            child: Image.asset(
              icons,
            ),
          ),
          Text(
            title,
            style: TextHelper.size12.copyWith(color: ColorsForApp.primaryColor),
          )
        ],
      ),
    );
  }

  Widget bottomTotalAmountUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Total",
          style: TextHelper.size18.copyWith(fontWeight: FontWeight.w400),
        ),
        Obx(
          () {
            return AnimatedSwitcherWrapper(
              child: Text(
                "₹${productController.totalPrice.value}",
                key: ValueKey<int>(productController.totalPrice.value),
                style: TextHelper.size18.copyWith(color: ColorsForApp.primaryColor, fontFamily: boldGoogleSansFont, fontWeight: FontWeight.bold),
              ),
            );
          },
        )
      ],
    );
  }

  Row customTitleWithDetails(String label, String details) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: TextHelper.size14.copyWith(fontWeight: FontWeight.bold, color: ColorsForApp.lightBlackColor.withOpacity(0.8)),
        ),
        details.isNotEmpty && details != ''
            ? Expanded(
                child: Text(details),
              )
            : const Text('-'),
      ],
    );
  }
}

class AnimatedSwitcherWrapper extends StatelessWidget {
  final Widget child;

  const AnimatedSwitcherWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: child,
    );
  }
}

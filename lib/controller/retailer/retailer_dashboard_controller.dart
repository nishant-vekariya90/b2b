import 'dart:io';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../api/api_manager.dart';
import '../../generated/assets.dart';
import '../../model/auth/latest_version_model.dart';
import '../../model/auth/user_basic_details_model.dart';
import '../../model/category_for_tpin_model.dart';
import '../../model/news_model.dart';
import '../../model/operation_model.dart';
import '../../model/operation_wise_model.dart';
import '../../model/success_model.dart';
import '../../model/wallet_balance_model.dart';
import '../../model/website_content_model.dart';
import '../../repository/retailer/retailer_dashboard_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class RetailerDashboardController extends GetxController {
  RetailerDashboardRepository retailerDashboardRepository = RetailerDashboardRepository(APIManager());
  final CarouselController newsCarouselController = CarouselController();
  RxInt currentNewsIndex = 0.obs;
  VideoPlayerController? videoPlayerController;
  RxList<OperationWiseModel> bankingServiceList = <OperationWiseModel>[].obs;
  RxList<OperationWiseModel> rechargeAndBillServiceList = <OperationWiseModel>[].obs;
  RxList<OperationWiseModel> valueAddedServiceList = <OperationWiseModel>[].obs;
  RxList<OperationWiseModel> otherServiceList = <OperationWiseModel>[].obs;
  late PageController pageController;
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(viewportFraction: 1, initialPage: 0);
    pageController.addListener(() {
      currentIndex.value = pageController.page?.round() ?? 0;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void startAutoSlide() {
    if (pageController.hasClients && appBannerList.isNotEmpty) {
      Future.delayed(
        const Duration(seconds: 3),
        () {
          final nextIndex = (currentIndex.value + 1) % appBannerList.length;
          pageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      );
    }
  }

  // Generate video thumbnail
  Future<Uint8List?> generateThumbnailFromUrl(String videoUrl) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      quality: 100,
      imageFormat: ImageFormat.PNG,
    );
    return uint8list;
  }

  // Get latest version
  Rx<GetLatestVersionModel> getVersionModel = GetLatestVersionModel().obs;
  Future<bool> getLatestVersion({bool isLoaderShow = true}) async {
    try {
      GetLatestVersionModel getLatestVersionModel = await retailerDashboardRepository.getLatestVersionApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (getLatestVersionModel.status == 1) {
        getVersionModel.value = getLatestVersionModel;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get wallet balance
  Rx<WalletBalanceModel> walletBalance = WalletBalanceModel().obs;
  RxBool isWalletBalanceLoaded = false.obs;
  Future<void> getWalletBalance({bool isLoaderShow = true}) async {
    try {
      walletBalance.value = await retailerDashboardRepository.getWalletBalanceApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (walletBalance.value.wallet2Name != null && walletBalance.value.wallet2Name!.isNotEmpty) {
        isShowAEPSWalletPassbook.value = true;
      } else {
        isShowAEPSWalletPassbook.value = false;
      }
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // Change profile picture
  Rx<File> profilePictureFile = File('').obs;
  RxString profilePictureName = ''.obs;
  RxString profilePictureExtension = ''.obs;
  Future<bool> changeProfilePicture({bool isLoaderShow = true}) async {
    try {
      SuccessModel successModel = await retailerDashboardRepository.changeProfilePictureApiCall(
        params: {
          'fileBytes': profilePictureFile.value.path.isNotEmpty ? await convertFileToBase64(profilePictureFile.value) : null,
          'fileBytesFormat': profilePictureFile.value.path.isNotEmpty ? extension(profilePictureFile.value.path) : null,
        },
        isLoaderShow: isLoaderShow,
      );
      if (successModel.statusCode == 1) {
        await getUserBasicDetailsAPI(isLoaderShow: false);
        return true;
      } else {
        errorSnackBar(message: successModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get user basic details
  Rx<UserBasicDetailsModel> userBasicDetails = UserBasicDetailsModel().obs;
  Future<bool> getUserBasicDetailsAPI({bool isLoaderShow = true}) async {
    try {
      UserBasicDetailsModel userBasicDetailsModel = await retailerDashboardRepository.userBasicDetailsApiCall(isLoaderShow: isLoaderShow);
      if (userBasicDetailsModel.userType != null && userBasicDetailsModel.userType!.isNotEmpty) {
        userBasicDetails.value = userBasicDetailsModel;
        GetStorage().write(userDataKey, userBasicDetailsModel.toJson());
        GetStorage().write(mobileNumber, userBasicDetailsModel.mobile);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get website content
  RxString appLogo = ''.obs;
  RxString appBanner = ''.obs;
  List<String> appBannerList = [];
  Future<bool> getWebsiteContent({required int contentType, bool isLoaderShow = true}) async {
    try {
      List<WebsiteContentModel> websiteContentModel = await retailerDashboardRepository.getWebsiteContentApiCall(
        contentType: contentType,
        isLoaderShow: isLoaderShow,
      );
      if (websiteContentModel.isNotEmpty) {
        for (var element in websiteContentModel) {
          // For app logo and banner
          if (contentType == 7) {
            if (element.name!.toLowerCase() == 'primarylogo') {
              appLogo.value = element.fileURL!;
              appIcon.value = element.fileURL!;
            } else if (element.name!.toLowerCase() == 'appbanner') {
              appBanner.value = element.fileURL!;
              appBannerList.add(element.fileURL!);
            } else if (element.name!.toLowerCase() == 'appbanner2') {
              appBanner.value = element.fileURL!;
              appBannerList.add(element.fileURL!);
            }
          }
          // For social medial
          else if (contentType == 6) {
            if (element.name!.toLowerCase() == 'googleplus') {
              apkLink.value = element.value!;
            }
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get category for tpin
  Future<bool> getCategoryForTpin({bool isLoaderShow = true}) async {
    try {
      List<CategoryForTpinModel> categoryForTpinListModel = await retailerDashboardRepository.getCategoryForTpinApiCall(isLoaderShow: isLoaderShow);
      if (categoryForTpinListModel.isNotEmpty) {
        categoryForTpinList.clear();
        for (CategoryForTpinModel element in categoryForTpinListModel) {
          if (element.status == 1) {
            categoryForTpinList.add(element);
          }
        }
        return true;
      } else {
        categoryForTpinList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get operation
  RxList<Operations> operationsList = <Operations>[].obs;
  RxBool isServicesLoaded = false.obs;
  Future<void> getOperation({bool isLoaderShow = true}) async {
    isServicesLoaded.value = false;
    try {
      List<OperationModel> operationListModel = await retailerDashboardRepository.getOperationApiCall(isLoaderShow: isLoaderShow);
      bankingServiceList.clear();
      rechargeAndBillServiceList.clear();
      valueAddedServiceList.clear();
      otherServiceList.clear();
      settlementServiceList.clear();
      otherServiceList.add(OperationWiseModel(icon: Assets.iconsKyc, title: 'KYC', code: 'KYC', rank: 3, isAccess: true));
      otherServiceList.add(OperationWiseModel(icon: Assets.iconsCommission, title: 'Commission', code: 'COMMISSION', rank: 4, isAccess: true));
      valueAddedServiceList.add(OperationWiseModel(icon: Assets.iconsBus, title: 'Bus', code: 'BUS', rank: 7, isAccess: true));
      valueAddedServiceList.add(OperationWiseModel(icon: Assets.iconsFlight, title: 'Flight', code: 'FLIGHT', rank: 6, isAccess: true));
      if (operationListModel.isNotEmpty) {
        for (OperationModel element in operationListModel) {
          if (element.activeCount! > 0) {
            if (element.operationType == 'Payin' && element.activeCount! > 0) {
              otherServiceList.add(OperationWiseModel(
                icon: Assets.iconsAddMoney,
                title: 'Payment Gateway',
                code: 'ADDMONEY',
                rank: 5,
                isAccess: true,
              ));
            }
            for (Operations operation in element.operations!) {
              // Add banking services
              if (operation.code == 'AEPS' && operation.status == 1) {
                bankingServiceList.add(OperationWiseModel(
                  icon: Assets.iconsAepsIcon,
                  title: 'AEPS',
                  code: operation.code,
                  rank: 1,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'AADHARPAY' && operation.status == 1) {
                bankingServiceList.add(OperationWiseModel(
                  icon: Assets.iconsAadharPay,
                  title: 'Aadhar Pay',
                  code: operation.code,
                  rank: 2,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'DMT' && operation.status == 1) {
                bankingServiceList.add(OperationWiseModel(
                  icon: Assets.iconsDmt,
                  title: 'DMT',
                  code: operation.code,
                  rank: 3,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'DMTB' && operation.status == 1) {
                bankingServiceList.add(OperationWiseModel(
                  icon: Assets.iconsDmt,
                  title: 'DMTB',
                  code: operation.code,
                  rank: 4,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'DMTE' && operation.status == 1) {
                bankingServiceList.add(OperationWiseModel(
                  icon: Assets.iconsDmt,
                  title: 'DMTE',
                  code: operation.code,
                  rank: 5,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'DMTI' && operation.status == 1) {
                bankingServiceList.add(OperationWiseModel(
                  icon: Assets.iconsDmt,
                  title: 'DMTI',
                  code: operation.code,
                  rank: 6,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'DMTN' && operation.status == 1) {
                bankingServiceList.add(OperationWiseModel(
                  icon: Assets.iconsDmt,
                  title: 'DMTN',
                  code: operation.code,
                  rank: 7,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'DMTO' && operation.status == 1) {
                bankingServiceList.add(OperationWiseModel(
                  icon: Assets.iconsDmt,
                  title: 'DMTO',
                  code: operation.code,
                  rank: 8,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'DMTP' && operation.status == 1) {
                bankingServiceList.add(OperationWiseModel(
                  icon: Assets.iconsDmt,
                  title: 'DMTP',
                  code: operation.code,
                  rank: 9,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'UPIPAYMENT' && operation.status == 1) {
                bankingServiceList.add(OperationWiseModel(
                  icon: Assets.iconsDmt,
                  title: 'UPI Payment',
                  code: operation.code,
                  rank: 10,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'MATM' && operation.status == 1) {
                bankingServiceList.add(OperationWiseModel(
                  icon: Assets.iconsMicroAtm,
                  title: 'MATM',
                  code: operation.code,
                  rank: 11,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'CMSP' && operation.status == 1) {
                bankingServiceList.add(OperationWiseModel(
                  icon: Assets.iconsCms,
                  title: 'CMS',
                  code: operation.code,
                  rank: 12,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              // Add recharge & bill service
              if (operation.code == 'Recharge' && operation.status == 1) {
                rechargeAndBillServiceList.add(OperationWiseModel(
                  icon: Assets.iconsMobileRecharge,
                  title: 'Mobile',
                  code: 'MOBILE',
                  rank: 1,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
                rechargeAndBillServiceList.add(OperationWiseModel(
                  icon: Assets.iconsDthRecharge,
                  title: 'DTH',
                  code: 'DTH',
                  rank: 2,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
                rechargeAndBillServiceList.add(OperationWiseModel(
                  icon: Assets.iconsPostPaid,
                  title: 'Postpaid',
                  code: 'POSTPAID',
                  rank: 3,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'BBPS' && operation.status == 1) {
                rechargeAndBillServiceList.add(OperationWiseModel(
                  icon: Assets.imagesBbpsIcon,
                  title: 'BBPS',
                  code: operation.code,
                  rank: 4,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'BBPSOFFLINE' && operation.status == 1) {
                rechargeAndBillServiceList.add(OperationWiseModel(
                  icon: Assets.imagesBbpsIcon,
                  title: 'BBPS O',
                  code: operation.code,
                  rank: 5,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'CREDITCARDP' && operation.status == 1) {
                rechargeAndBillServiceList.add(OperationWiseModel(
                  icon: Assets.iconsCreditCard,
                  title: 'Credit Card P',
                  code: operation.code,
                  rank: 6,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'CREDITCARDM' && operation.status == 1) {
                rechargeAndBillServiceList.add(OperationWiseModel(
                  icon: Assets.iconsCreditCard,
                  title: 'Credit Card M',
                  code: operation.code,
                  rank: 7,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'CREDITCARDO' && operation.status == 1) {
                rechargeAndBillServiceList.add(OperationWiseModel(
                  icon: Assets.iconsCreditCard,
                  title: 'Credit Card O',
                  code: operation.code,
                  rank: 8,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'CREDITCARDI' && operation.status == 1) {
                rechargeAndBillServiceList.add(OperationWiseModel(
                  icon: Assets.iconsCreditCard,
                  title: 'Credit Card I',
                  code: operation.code,
                  rank: 9,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              // Add value added service
              if (operation.code == 'PRODUCT' && operation.status == 1) {
                valueAddedServiceList.add(OperationWiseModel(
                  icon: Assets.iconsProductIcon,
                  title: 'Product',
                  code: operation.code,
                  rank: 1,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'GIFTCARDBS' && operation.status == 1) {
                valueAddedServiceList.add(OperationWiseModel(
                  icon: Assets.iconsGiftCardIcon,
                  title: 'Gift Card BS',
                  code: operation.code,
                  rank: 1,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'GIFTCARDSF' && operation.status == 1) {
                valueAddedServiceList.add(OperationWiseModel(
                  icon: Assets.iconsGiftCardIcon,
                  title: 'Gift Card SF',
                  code: operation.code,
                  rank: 1,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'PAN' && operation.status == 1) {
                valueAddedServiceList.add(OperationWiseModel(
                  icon: Assets.iconsPancardIcon,
                  title: 'Pancard',
                  code: operation.code,
                  rank: 2,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'GIFTCARD' && operation.status == 1) {
                valueAddedServiceList.add(OperationWiseModel(
                  icon: Assets.iconsGiftCardIcon,
                  title: 'Gift Cards',
                  code: operation.code,
                  rank: 3,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'ECOLLECT' && operation.status == 1) {
                valueAddedServiceList.add(OperationWiseModel(
                  icon: Assets.iconsCredit,
                  title: 'E-Collection',
                  code: operation.code,
                  rank: 4,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'PAYTMWALLET' && operation.status == 1) {
                valueAddedServiceList.add(OperationWiseModel(
                  icon: Assets.iconsMainWallet,
                  title: 'Paytm Wallet',
                  code: operation.code,
                  rank: 5,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'SIP' && operation.status == 1) {
                valueAddedServiceList.add(OperationWiseModel(
                  icon: Assets.iconsPancardIcon,
                  title: 'Axis SIP',
                  code: operation.code,
                  rank: 6,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }

              // Add other service
              if (operation.code == 'TOPUPRQST' && operation.status == 1) {
                otherServiceList.add(OperationWiseModel(
                  icon: Assets.iconsTopup,
                  title: 'Top-up Request',
                  code: operation.code,
                  rank: 1,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'TOPUPHISTORY' && operation.status == 1) {
                otherServiceList.add(OperationWiseModel(
                  icon: Assets.iconsTopupHistory,
                  title: 'Top-up History',
                  code: operation.code,
                  rank: 2,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'PAYMENTPAGE' && operation.status == 1) {
                otherServiceList.add(OperationWiseModel(
                  icon: Assets.iconsPaymentPageIcon,
                  title: 'Payment Page',
                  code: operation.code,
                  rank: 6,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'PAYMENTLINK' && operation.status == 1) {
                otherServiceList.add(OperationWiseModel(
                  icon: Assets.iconsPaymentLinkIcon,
                  title: 'Payment Link',
                  code: operation.code,
                  rank: 7,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'SCAN_PAY' && operation.status == 1) {
                otherServiceList.add(OperationWiseModel(
                  icon: Assets.iconsAddMoney,
                  title: 'Scan & Pay',
                  code: operation.code,
                  rank: 8,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'INTERNAL_TRANSFER' && operation.status == 1) {
                otherServiceList.add(OperationWiseModel(
                  icon: Assets.iconsInternalTransfer,
                  title: 'Internal Transfer',
                  code: operation.code,
                  rank: 10,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'OFFLINEPOS' && operation.status == 1) {
                otherServiceList.add(OperationWiseModel(
                  icon: Assets.iconsOfflinePosIcon,
                  title: 'Offline POS',
                  code: operation.code,
                  rank: 11,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'OFFLINEPANTOKEN' && operation.status == 1) {
                otherServiceList.add(OperationWiseModel(
                  icon: Assets.iconsPancardIcon,
                  title: 'Pancard Token',
                  code: operation.code,
                  rank: 12,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'OFFLINEDSC' && operation.status == 1) {
                otherServiceList.add(OperationWiseModel(
                  icon: Assets.iconsDigitalSignatureTokenIcon,
                  title: 'Digital Signature',
                  code: operation.code,
                  rank: 13,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              // Settlement service
              if (operation.code == 'WALLETTOBANK' && operation.status == 1) {
                settlementServiceList.add(OperationWiseModel(
                  icon: Assets.iconsAepsToMainWallet,
                  title: 'To Bank',
                  code: operation.code,
                  rank: 1,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'WALLETTODIRECTBANK' && operation.status == 1) {
                settlementServiceList.add(OperationWiseModel(
                  icon: Assets.iconsDirectBank,
                  title: 'To Direct Bank',
                  code: operation.code,
                  rank: 2,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'WALLETTOWALLET' && operation.status == 1) {
                settlementServiceList.add(OperationWiseModel(
                  icon: Assets.iconsMainWallet,
                  title: 'To Main Wallet',
                  code: operation.code,
                  rank: 3,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'SETTLEMENTHISTORY' && operation.status == 1) {
                settlementServiceList.add(OperationWiseModel(
                  icon: Assets.iconsAepsHistory,
                  title: 'History',
                  code: operation.code,
                  rank: 4,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
            }
          }
        }
        if (settlementServiceList.isNotEmpty) {
          otherServiceList.add(OperationWiseModel(
            icon: Assets.iconsSettlement,
            title: 'Settlement',
            code: 'SETTLEMENT',
            rank: 9,
            isAccess: true,
          ));
        }
        if (bankingServiceList.isNotEmpty) {
          bankingServiceList.sort((a, b) => a.rank!.compareTo(b.rank!));
        }
        if (rechargeAndBillServiceList.isNotEmpty) {
          rechargeAndBillServiceList.sort((a, b) => a.rank!.compareTo(b.rank!));
        }
        if (valueAddedServiceList.isNotEmpty) {
          valueAddedServiceList.sort((a, b) => a.rank!.compareTo(b.rank!));
        }
        if (otherServiceList.isNotEmpty) {
          otherServiceList.sort((a, b) => a.rank!.compareTo(b.rank!));
        }
        if (settlementServiceList.isNotEmpty) {
          settlementServiceList.sort((a, b) => a.rank!.compareTo(b.rank!));
        }
      }
    } catch (e) {
      dismissProgressIndicator();
    } finally {
      Future.delayed(const Duration(seconds: 1), () {
        isServicesLoaded.value = true;
      });
    }
  }

  // Get news list
  RxList<NewsModel> newsList = <NewsModel>[].obs;
  RxString scrollNews = ''.obs;
  Future<bool> getNews({bool isLoaderShow = true}) async {
    try {
      List<NewsModel> newsModel = await retailerDashboardRepository.getNewsApiCall(isLoaderShow: isLoaderShow);
      newsList.clear();
      if (newsModel.isNotEmpty) {
        for (NewsModel element in newsModel) {
          if (element.contentType == 'Video' && element.fileUrl != null && element.status != 0) {
            NewsModel newsModel = NewsModel(
              id: element.id,
              userTypeId: element.userTypeId,
              newsType: element.newsType,
              contentType: element.contentType,
              value: element.value,
              fileUrl: element.fileUrl,
              createdOn: element.createdOn,
              modifiedOn: element.modifiedOn,
              status: element.status,
              isDeleted: element.isDeleted,
              userTypeName: element.userTypeName,
              priority: element.priority,
              videoThumbnailImage: await generateThumbnailFromUrl(element.fileUrl!),
            );
            newsList.add(newsModel);
          } else if (element.status != 0 && element.newsType == 'Scroller' && element.contentType == 'Text' && element.value != null) {
            scrollNews.value = convertHtmlToPlainText(element.value!);
          } else if (element.status != 0) {
            newsList.add(element);
          }
        }
        return true;
      } else {
        newsList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}

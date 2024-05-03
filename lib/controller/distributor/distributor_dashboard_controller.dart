import 'dart:io';
import 'dart:typed_data';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
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
import '../../repository/distributor/distributor_dashboard_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class DistributorDashboardController extends GetxController {
  DistributorDashboardRepository distributorDashboardRepository = DistributorDashboardRepository(APIManager());
  final CarouselController newsCarouselController = CarouselController();
  RxInt currentNewsIndex = 0.obs;
  RxList<OperationWiseModel> manageUserServiceList = <OperationWiseModel>[].obs;
  RxList<OperationWiseModel> supportServiceList = <OperationWiseModel>[].obs;
  RxBool isShowAllReport = false.obs;
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
      GetLatestVersionModel getLatestVersionModel = await distributorDashboardRepository.getLatestVersionApiCall(
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
  Future<void> getWalletBalance({bool isLoaderShow = true}) async {
    try {
      walletBalance.value = await distributorDashboardRepository.getWalletBalanceApiCall(
        isLoaderShow: isLoaderShow,
      );
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
      SuccessModel successModel = await distributorDashboardRepository.changeProfilePictureApiCall(
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

  // Get website content
  RxString appLogo = ''.obs;
  RxString appBanner = ''.obs;
  List<String> appBannerList = [];
  Future<bool> getWebsiteContent({required int contentType, bool isLoaderShow = true}) async {
    try {
      List<WebsiteContentModel> websiteContentModel = await distributorDashboardRepository.getWebsiteContentApiCall(
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

  // Get user basic details
  Rx<UserBasicDetailsModel> userBasicDetails = UserBasicDetailsModel().obs;
  Future<bool> getUserBasicDetailsAPI({bool isLoaderShow = true}) async {
    try {
      UserBasicDetailsModel userBasicDetailsModel = await distributorDashboardRepository.userBasicDetailsApiCall(isLoaderShow: isLoaderShow);
      if (userBasicDetailsModel.userType != null && userBasicDetailsModel.userType!.isNotEmpty) {
        userBasicDetails.value = userBasicDetailsModel;
        GetStorage().write(userDataKey, userBasicDetailsModel.toJson());
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
      List<CategoryForTpinModel> categoryForTpinListModel = await distributorDashboardRepository.getCategoryForTpinApiCall(isLoaderShow: isLoaderShow);
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
    try {
      List<OperationModel> operationListModel = await distributorDashboardRepository.getOperationApiCall(isLoaderShow: isLoaderShow);
      manageUserServiceList.clear();
      supportServiceList.clear();
      settlementServiceList.clear();
      manageUserServiceList.add(OperationWiseModel(icon: Assets.iconsKyc, title: 'KYC', code: 'KYC', rank: 7, isAccess: true));
      supportServiceList.add(OperationWiseModel(icon: Assets.iconsCommission, title: 'Commission', code: 'COMMISSION', rank: 9, isAccess: true));
      if (operationListModel.isNotEmpty) {
        for (OperationModel element in operationListModel) {
          if (element.activeCount! > 0) {
            if(element.operationType=='Payin' && element.activeCount! >0){
              supportServiceList.add(OperationWiseModel(
                icon: Assets.iconsAddMoney,
                title: 'Payment Gateway',
                code: 'ADDMONEY',
                rank: 6,
                isAccess: true,
              ));
            }
            for (Operations operation in element.operations!) {
              // Add manage user services
              if (operation.code == 'ADDUSER' && operation.status == 1) {
                manageUserServiceList.add(OperationWiseModel(
                  icon: Assets.iconsAddUser,
                  title: 'Add User',
                  code: 'ADDUSER',
                  rank: 1,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
                manageUserServiceList.add(OperationWiseModel(
                  icon: Assets.iconsViewUser,
                  title: 'View Users',
                  code: 'VIEWUSER',
                  rank: 2,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'PROFILECREATION' && operation.status == 1) {
                manageUserServiceList.add(OperationWiseModel(
                  icon: Assets.iconsCredit,
                  title: 'Profiles',
                  code: operation.code,
                  rank: 3,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'OSMANAGEMENT' && operation.status == 1) {
                manageUserServiceList.add(OperationWiseModel(
                  icon: Assets.iconsCredit,
                  title: 'O/S Collection',
                  code: operation.code,
                  rank: 4,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'DEBITCREDIT' && operation.status == 1) {
                manageUserServiceList.add(OperationWiseModel(
                  icon: Assets.iconsCredit,
                  title: 'Credit Debit',
                  code: operation.code,
                  rank: 5,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'DEBITHISTORY' && operation.status == 1) {
                manageUserServiceList.add(OperationWiseModel(
                  icon: Assets.iconsCredit,
                  title: 'Credit Debit History',
                  code: operation.code,
                  rank: 6,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              // Add support services
              if (operation.code == 'TOPUPRQST' && operation.status == 1) {
                supportServiceList.add(OperationWiseModel(
                  icon: Assets.iconsTopup,
                  title: 'Top-up Request',
                  code: operation.code,
                  rank: 1,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'TOPUPHISTORY' && operation.status == 1) {
                supportServiceList.add(OperationWiseModel(
                  icon: Assets.iconsTopupHistory,
                  title: 'Top-up History',
                  code: operation.code,
                  rank: 2,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'PAYMENTREQUEST' && operation.status == 1) {
                supportServiceList.add(OperationWiseModel(
                  icon: Assets.iconsTopup,
                  title: 'Payment Request',
                  code: operation.code,
                  rank: 3,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'PAYMENTHISTORY' && operation.status == 1) {
                supportServiceList.add(OperationWiseModel(
                  icon: Assets.iconsTopupHistory,
                  title: 'Payment History',
                  code: operation.code,
                  rank: 4,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'PAYMENTBANK' && operation.status == 1) {
                supportServiceList.add(OperationWiseModel(
                  icon: Assets.iconsPaymentBank,
                  title: 'Payment Bank',
                  code: operation.code,
                  rank: 5,
                  isAccess: operation.isUIOperationWise != null && operation.isUIOperationWise == true ? false : true,
                ));
              }
              if (operation.code == 'INTERNAL_TRANSFER' && operation.status == 1) {
                supportServiceList.add(OperationWiseModel(
                  icon: Assets.iconsInternalTransfer,
                  title: 'Internal Transafer',
                  code: operation.code,
                  rank: 7,
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
          supportServiceList.add(OperationWiseModel(
            icon: Assets.iconsSettlement,
            title: 'Settlement',
            code: 'SETTLEMENT',
            rank: 8,
            isAccess: true,
          ));
        }
        if (manageUserServiceList.isNotEmpty) {
          manageUserServiceList.sort((a, b) => a.rank!.compareTo(b.rank!));
        }
        if (supportServiceList.isNotEmpty) {
          supportServiceList.sort((a, b) => a.rank!.compareTo(b.rank!));
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
      List<NewsModel> newsModel = await distributorDashboardRepository.getNewsApiCall(
        isLoaderShow: isLoaderShow,
      );
      newsList.clear();
      if (newsModel.isNotEmpty) {
        for (var element in newsModel) {
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

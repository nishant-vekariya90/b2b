import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../controller/report_controller.dart';
import '../controller/retailer/gift_card_b_controller.dart';
import '../controller/transaction_report_controller.dart';
import '../generated/assets.dart';
import '../model/add_money/settlement_cycles_model.dart';
import '../model/aeps/master/bank_list_model.dart';
import '../model/aeps_settlement/aeps_bank_list_model.dart';
import '../model/auth/block_model.dart';
import '../model/auth/cities_model.dart';
import '../model/auth/entity_type_model.dart';
import '../model/auth/states_model.dart';
import '../model/auth/user_type_model.dart';
import '../model/bbps/bbps_operator_grouping_list_model.dart';
import '../model/bus/bus_from_cities_model.dart';
import '../model/create_profile/profile_information_model.dart';
import '../model/credit_debit/payment_mode_model.dart';
import '../model/credit_debit/user_list_model.dart';
import '../model/credit_debit/wallet_type_model.dart';
import '../model/credopay/device_model.dart';
import '../model/credopay/merchant_category_model.dart';
import '../model/credopay/merchant_type_model.dart';
import '../model/credopay/terminal_type_model.dart';
import '../model/flight/airline_model.dart';
import '../model/flight/country_model.dart';
import '../model/gift_card_b/bank_sathi_category_model.dart';
import '../model/gift_card_b/company_model.dart';
import '../model/gift_card_b/occupation_model.dart';
import '../model/gift_card_b/pincode_model.dart';
import '../model/kyc/kyc_bank_list_model.dart';
import '../model/master/circle_list_model.dart';
import '../model/money_transfer/recipient_deposit_bank_model.dart';
import '../model/product/all_product_model.dart';
import '../model/product/product_child_category_model.dart';
import '../model/report/category_model.dart';
import '../model/report/service_model.dart';
import '../model/view_user_model.dart' as child_user_list;
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import 'button.dart';
import 'constant_widgets.dart';
import 'text_field.dart';

class SearchabelListViewScreen extends StatefulWidget {
  const SearchabelListViewScreen({super.key});

  @override
  State<SearchabelListViewScreen> createState() => _SearchabelListViewScreenState();
}

class _SearchabelListViewScreenState extends State<SearchabelListViewScreen> {
  late ReportController reportController;
  late TransactionReportController transactionReportController;
  late GiftCardBController giftCardBController;
  final List modelList = Get.arguments[0];
  final String modelName = Get.arguments[1] ?? '';
  RxList searchedList = [].obs;

  @override
  void initState() {
    super.initState();
    if (modelName == 'StatementUserList') {
      reportController = Get.find();
    } else if (modelName == 'userListTransaction') {
      transactionReportController = Get.find();
    } else if (modelName == 'pinCodeList' || modelName == 'firmList') {
      giftCardBController = Get.find();
    }
    searchedList.assignAll(modelList);
  }

  searchFromOptions(String value) async {
    searchedList.clear();
    if (value.isEmpty) {
      searchedList.assignAll(modelList);
    } else {
      if (modelName == 'string') {
        List<String> masterCircleListModel = modelList as List<String>;
        List<String> tempList = masterCircleListModel.where((element) {
          return element.toLowerCase().contains(value.toLowerCase());
        }).toList();
        searchedList.assignAll(tempList);
      } else {
        if (modelName == 'circleList') {
          List<MasterCircleListModel> masterCircleListModel = modelList as List<MasterCircleListModel>;
          List<MasterCircleListModel> tempList = masterCircleListModel.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'bankList') {
          List<MasterBankListModel> masterBankListModel = modelList as List<MasterBankListModel>;
          List<MasterBankListModel> tempList = masterBankListModel.where((element) {
            return element.bankName?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'kycBankList') {
          List<KYCBankListModel> masterKycBankListModel = modelList as List<KYCBankListModel>;
          List<KYCBankListModel> tempList = masterKycBankListModel.where((element) {
            return element.bankName?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'aepsBankList') {
          List<AepsBankListModel> masterBankListModel = modelList as List<AepsBankListModel>;
          List<AepsBankListModel> tempList = masterBankListModel.where((element) {
            return element.bankName?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'depositBankList') {
          List<RecipientDepositBankModel> masterBankListModel = modelList as List<RecipientDepositBankModel>;
          List<RecipientDepositBankModel> tempList = masterBankListModel.where((element) {
            return element.bankName?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'userTypeList') {
          List<UserTypeModel> userTypeList = modelList as List<UserTypeModel>;
          List<UserTypeModel> tempList = userTypeList.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'entityTypeList') {
          List<EntityTypeModel> entityTypeList = modelList as List<EntityTypeModel>;
          List<EntityTypeModel> tempList = entityTypeList.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'StatementUserList') {
          List<UserData> userTypeList = modelList as List<UserData>;
          List<UserData> tempList = userTypeList.where((element) {
            return element.ownerName?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'userListTransaction') {
          if (value.length >= 3) {
            await transactionReportController.getUserListVaiSearch(
              searchText: value,
              userTypeId: transactionReportController.selectedUserTypeId.value,
              pageNumber: 1,
            );
          } else if (value.length == 2) {
            await transactionReportController.getUserListVaiUserType(
              userTypeId: transactionReportController.selectedUserTypeId.value,
              pageNumber: 1,
            );
          }
          if (transactionReportController.userList.isNotEmpty) {
            List<UserData> tempList = transactionReportController.userList.where((element) {
              return (element.ownerName?.toLowerCase().contains(value.toLowerCase()) ?? false) || (element.userName?.toLowerCase().contains(value.toLowerCase()) ?? false);
            }).toList();
            searchedList.assignAll(tempList);
          }
        } else if (modelName == 'paymentModeList') {
          List<PaymentModeModel> paymentModeList = modelList as List<PaymentModeModel>;
          List<PaymentModeModel> tempList = paymentModeList.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'walletTypeList') {
          List<WalletTypeModel> walletTypeList = modelList as List<WalletTypeModel>;
          List<WalletTypeModel> tempList = walletTypeList.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'operatorGroupingList') {
          List<BbpsOperatorGroupingListModel> masterOperatorGroupingListModel = modelList as List<BbpsOperatorGroupingListModel>;
          List<BbpsOperatorGroupingListModel> tempList = masterOperatorGroupingListModel.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'blockList') {
          List<BlockModel> blockModel = modelList as List<BlockModel>;
          List<BlockModel> tempList = blockModel.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'statesList') {
          List<StatesModel> statesModel = modelList as List<StatesModel>;
          List<StatesModel> tempList = statesModel.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'citiesList') {
          List<CitiesModel> citiesModel = modelList as List<CitiesModel>;
          List<CitiesModel> tempList = citiesModel.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'categoryList') {
          List<CategoryModel> categoryModel = modelList as List<CategoryModel>;
          List<CategoryModel> tempList = categoryModel.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'serviceList') {
          List<ServiceModel> serviceModel = modelList as List<ServiceModel>;
          List<ServiceModel> tempList = serviceModel.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'profileList') {
          List<Profile> profileModel = modelList as List<Profile>;
          List<Profile> tempList = profileModel.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'settlementCycle') {
          List<SettlementCyclesModel> settlementCycleModel = modelList as List<SettlementCyclesModel>;
          List<SettlementCyclesModel> tempList = settlementCycleModel.where((element) {
            return element.settlementType?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'childUserList') {
          List<child_user_list.UserData> childUserModel = modelList as List<child_user_list.UserData>;
          List<child_user_list.UserData> tempList = childUserModel.where((element) {
            return element.ownerName?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'merchantCategoryList') {
          List<CategoryListModel> categoryListModel = modelList as List<CategoryListModel>;
          List<CategoryListModel> tempList = categoryListModel.where((element) {
            return element.description?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'merchantTypeList') {
          List<MerchantTypeData> merchantTypeListModel = modelList as List<MerchantTypeData>;
          List<MerchantTypeData> tempList = merchantTypeListModel.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'terminalTypeList') {
          List<TerminalTypeListModel> terminalTypeListModel = modelList as List<TerminalTypeListModel>;
          List<TerminalTypeListModel> tempList = terminalTypeListModel.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'deviceModelList') {
          List<DeviceListModel> deviceListModel = modelList as List<DeviceListModel>;
          List<DeviceListModel> tempList = deviceListModel.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'tokenTypeList') {
          List<ProductChildCategoryModel> productChildCategoryModel = modelList as List<ProductChildCategoryModel>;
          List<ProductChildCategoryModel> tempList = productChildCategoryModel.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'productDetailsList') {
          List<AllProductListModel> allProductListModel = modelList as List<AllProductListModel>;
          List<AllProductListModel> tempList = allProductListModel.where((element) {
            return element.name?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'bankSathiCategoryList') {
          List<BKCategoryListModel> categoryModel = modelList as List<BKCategoryListModel>;
          List<BKCategoryListModel> tempList = categoryModel.where((element) {
            return element.title?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'firmList') {
          if (value.length >= 2) {
            await giftCardBController.getCompanyListApi(
              searchKey: value,
            );
          }
          if (giftCardBController.companyList.isNotEmpty) {
            List<CompanyListModel> tempList = giftCardBController.companyList.where((element) {
              return (element.companyName?.toLowerCase().contains(value.toLowerCase()) ?? false) || (element.companyName?.toLowerCase().contains(value.toLowerCase()) ?? false);
            }).toList();
            searchedList.assignAll(tempList);
          }
        } else if (modelName == 'occupationList') {
          List<OccupationListModel> occupationModel = modelList as List<OccupationListModel>;
          List<OccupationListModel> tempList = occupationModel.where((element) {
            return element.occuTitle?.toLowerCase().contains(value.toLowerCase()) ?? false;
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'pinCodeList') {
          if (value.length >= 3) {
            await giftCardBController.getPinCodeListApi(
              searchKey: value,
            );
          }
          if (giftCardBController.pinCodeList.isNotEmpty) {
            List<PinCodeListModel> tempList = giftCardBController.pinCodeList.where((element) {
              return (element.pinCode?.toLowerCase().contains(value.toLowerCase()) ?? false) || (element.pinCode?.toLowerCase().contains(value.toLowerCase()) ?? false);
            }).toList();
            searchedList.assignAll(tempList);
          }
        } else if (modelName == 'masterAirlineList') {
          List<AirlineModel> airportListModel = modelList as List<AirlineModel>;
          List<AirlineModel> tempList = airportListModel.where((element) {
            return (element.name?.toLowerCase().contains(value.toLowerCase()) ?? false) ||
                (element.country?.toLowerCase().contains(value.toLowerCase()) ?? false) ||
                (element.code?.toLowerCase().contains(value.toLowerCase()) ?? false);
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'masterBusFromLocationList') {
          List<BusCities> airportListModel = modelList as List<BusCities>;
          List<BusCities> tempList = airportListModel.where((element) {
            return (element.name?.toLowerCase().contains(value.toLowerCase()) ?? false);
          }).toList();
          searchedList.assignAll(tempList);
        } else if (modelName == 'masterCountryList') {
          List<CountryModel> countryListModel = modelList as List<CountryModel>;
          List<CountryModel> tempList = countryListModel.where((element) {
            return (element.name?.toLowerCase().contains(value.toLowerCase()) ?? false);
          }).toList();
          searchedList.assignAll(tempList);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        Get.back(
            result: modelName == 'string'
                ? ''
                : modelName == 'circleList'
                    ? MasterCircleListModel()
                    : modelName == 'bankList'
                        ? MasterBankListModel()
                        : modelName == 'aepsBankList'
                            ? AepsBankListModel()
                            : modelName == 'depositBankList'
                                ? RecipientDepositBankModel()
                                : modelName == 'userTypeList'
                                    ? UserTypeModel()
                                    : modelName == 'entityTypeList'
                                        ? EntityTypeModel()
                                        : modelName == 'userListTransaction'
                                            ? UserData()
                                            : modelName == 'StatementUserList'
                                                ? UserData()
                                                : modelName == 'walletTypeList'
                                                    ? WalletTypeModel()
                                                    : modelName == 'paymentModeList'
                                                        ? PaymentModeModel()
                                                        : modelName == 'operatorGroupingList'
                                                            ? BbpsOperatorGroupingListModel()
                                                            : modelName == "blockList"
                                                                ? BlockModel()
                                                                : modelName == "statesList"
                                                                    ? StatesModel()
                                                                    : modelName == "citiesList"
                                                                        ? CitiesModel()
                                                                        : modelName == 'categoryList'
                                                                            ? CategoryModel()
                                                                            : modelName == 'serviceList'
                                                                                ? ServiceModel()
                                                                                : modelName == "profileList"
                                                                                    ? Profile()
                                                                                    : modelName == 'kycBankList'
                                                                                        ? KYCBankListModel()
                                                                                        : modelName == 'merchantCategoryList'
                                                                                            ? CategoryListModel()
                                                                                            : modelName == 'merchantTypeList'
                                                                                                ? MerchantTypeData()
                                                                                                : modelName == 'terminalTypeList'
                                                                                                    ? TerminalTypeListModel()
                                                                                                    : modelName == 'deviceModelList'
                                                                                                        ? DeviceListModel()
                                                                                                        : modelName == 'settlementCycle'
                                                                                                            ? SettlementCyclesModel()
                                                                                                            : modelName == 'childUserList'
                                                                                                                ? UserData()
                                                                                                                : modelName == 'tokenTypeList'
                                                                                                                    ? ProductChildCategoryModel()
                                                                                                                    : modelName == 'productDetailsList'
                                                                                                                        ? AllProductListModel()
                                                                                                                        : modelName == 'bankSathiCategoryList'
                                                                                                                            ? BKCategoryListModel()
                                                                                                                            : modelName == 'firmList'
                                                                                                                                ? CompanyListModel()
                                                                                                                                : modelName == 'occupationList'
                                                                                                                                    ? OccupationListModel()
                                                                                                                                    : modelName == 'pinCodeList'
                                                                                                                                        ? PinCodeListModel()
                                                                                                                                        : modelName == 'masterAirportList'
                                                                                                                                            ? AirlineModel()
                                                                                                                                            : modelName == 'masterBusFromLocationList'
                                                                                                                                                ? BusCities()
                                                                                                                                                : modelName == 'masterCountryList'
                                                                                                                                                    ? CountryModel()
                                                                                                                                                    : CountryModel());
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
                leading: InkWell(
                  onTap: () {
                    Get.back(
                      result: modelName == 'string'
                          ? ''
                          : modelName == 'circleList'
                              ? MasterCircleListModel()
                              : modelName == 'bankList'
                                  ? MasterBankListModel()
                                  : modelName == 'aepsBankList'
                                      ? AepsBankListModel()
                                      : modelName == 'depositBankList'
                                          ? RecipientDepositBankModel()
                                          : modelName == 'userTypeList'
                                              ? UserTypeModel()
                                              : modelName == 'entityTypeList'
                                                  ? EntityTypeModel()
                                                  : modelName == 'userListTransaction'
                                                      ? UserData()
                                                      : modelName == 'StatementUserList'
                                                          ? UserData()
                                                          : modelName == 'walletTypeList'
                                                              ? WalletTypeModel()
                                                              : modelName == 'paymentModeList'
                                                                  ? PaymentModeModel()
                                                                  : modelName == 'operatorGroupingList'
                                                                      ? BbpsOperatorGroupingListModel()
                                                                      : modelName == "blockList"
                                                                          ? BlockModel()
                                                                          : modelName == "statesList"
                                                                              ? StatesModel()
                                                                              : modelName == "citiesList"
                                                                                  ? CitiesModel()
                                                                                  : modelName == 'categoryList'
                                                                                      ? CategoryModel()
                                                                                      : modelName == 'serviceList'
                                                                                          ? ServiceModel()
                                                                                          : modelName == "profileList"
                                                                                              ? Profile()
                                                                                              : modelName == 'kycBankList'
                                                                                                  ? KYCBankListModel()
                                                                                                  : modelName == 'merchantCategoryList'
                                                                                                      ? CategoryListModel()
                                                                                                      : modelName == 'merchantTypeList'
                                                                                                          ? MerchantTypeData()
                                                                                                          : modelName == 'terminalTypeList'
                                                                                                              ? TerminalTypeListModel()
                                                                                                              : modelName == 'deviceModelList'
                                                                                                                  ? DeviceListModel()
                                                                                                                  : modelName == 'settlementCycle'
                                                                                                                      ? SettlementCyclesModel()
                                                                                                                      : modelName == "childUserList"
                                                                                                                          ? UserData()
                                                                                                                          : modelName == 'tokenTypeList'
                                                                                                                              ? ProductChildCategoryModel()
                                                                                                                              : modelName == 'productDetailsList'
                                                                                                                                  ? AllProductListModel()
                                                                                                                                  : modelName == 'bankSathiCategoryList'
                                                                                                                                      ? BKCategoryListModel()
                                                                                                                                      : modelName == 'firmList'
                                                                                                                                          ? CompanyListModel()
                                                                                                                                          : modelName == 'occupationList'
                                                                                                                                              ? OccupationListModel()
                                                                                                                                              : modelName == 'pinCodeList'
                                                                                                                                                  ? PinCodeListModel()
                                                                                                                                                  : modelName == 'masterAirportList'
                                                                                                                                                      ? AirlineModel()
                                                                                                                                                      : modelName == 'masterBusFromLocationList'
                                                                                                                                                          ? BusCities()
                                                                                                                                                          : modelName == 'masterCountryList'
                                                                                                                                                              ? CountryModel()
                                                                                                                                                              : CountryModel(),
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
                  padding: const EdgeInsets.only(top: 3),
                  decoration: BoxDecoration(
                    color: ColorsForApp.whiteColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Obx(
                    () => searchedList.isEmpty
                        ? notFoundText(
                            text: modelName == 'pinCodeList' || modelName == 'firmList' ? 'Please enter some keywords to get data.' : 'No data found',
                          )
                        : modelName == 'string'
                            ? ListView.builder(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                itemCount: searchedList.length,
                                itemBuilder: (context, index) {
                                  String value = searchedList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Get.back(result: value);
                                    },
                                    child: Card(
                                      elevation: 1,
                                      color: ColorsForApp.whiteColor,
                                      shadowColor: ColorsForApp.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 0.5,
                                          color: ColorsForApp.grayScale200,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        child: Text(
                                          value,
                                          style: TextHelper.size15.copyWith(
                                            color: ColorsForApp.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                itemCount: searchedList.length,
                                itemBuilder: (context, index) {
                                  switch (modelName) {
                                    case 'circleList':
                                      MasterCircleListModel masterCircleListModel = searchedList[index];
                                      return customTitleCard(
                                        title: masterCircleListModel.name != null && masterCircleListModel.name!.isNotEmpty ? masterCircleListModel.name! : '-',
                                        onTap: () {
                                          Get.back(result: masterCircleListModel);
                                        },
                                      );
                                    case 'bankList':
                                      MasterBankListModel masterBankListModel = searchedList[index];
                                      return customTitleCard(
                                        title: masterBankListModel.bankName != null && masterBankListModel.bankName!.isNotEmpty ? masterBankListModel.bankName! : '-',
                                        onTap: () {
                                          Get.back(result: masterBankListModel);
                                        },
                                      );
                                    case 'kycBankList':
                                      KYCBankListModel masterKycBankListModel = searchedList[index];
                                      return customTitleCard(
                                        title: masterKycBankListModel.bankName != null && masterKycBankListModel.bankName!.isNotEmpty ? masterKycBankListModel.bankName! : '-',
                                        onTap: () {
                                          Get.back(result: masterKycBankListModel);
                                        },
                                      );
                                    case 'operatorGroupingList':
                                      BbpsOperatorGroupingListModel bbpsOperatorGroupingListModel = searchedList[index];
                                      return customTitleCard(
                                        title: bbpsOperatorGroupingListModel.name != null && bbpsOperatorGroupingListModel.name!.isNotEmpty ? bbpsOperatorGroupingListModel.name! : '-',
                                        onTap: () {
                                          Get.back(result: bbpsOperatorGroupingListModel);
                                        },
                                      );
                                    case 'aepsBankList':
                                      AepsBankListModel aepsBankListModel = searchedList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Get.back(result: aepsBankListModel);
                                        },
                                        child: Card(
                                          elevation: 1,
                                          color: ColorsForApp.whiteColor,
                                          shadowColor: ColorsForApp.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 0.5,
                                              color: ColorsForApp.grayScale200,
                                            ),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                modelName == 'aepsBankList' && aepsBankListModel.method == 0
                                                    ? Text(
                                                        aepsBankListModel.bankName != null && aepsBankListModel.bankName!.isNotEmpty ? aepsBankListModel.bankName! : '-',
                                                        style: TextHelper.size15.copyWith(
                                                          color: ColorsForApp.primaryColor,
                                                        ),
                                                      )
                                                    : Text(
                                                        aepsBankListModel.upiid != null && aepsBankListModel.upiid!.isNotEmpty ? aepsBankListModel.upiid! : '-',
                                                        style: TextHelper.size15.copyWith(
                                                          color: ColorsForApp.primaryColor,
                                                        ),
                                                      ),
                                                modelName == 'aepsBankList'
                                                    ? Text(
                                                        aepsBankListModel.accountNumber != null && aepsBankListModel.accountNumber!.isNotEmpty ? ' (${aepsBankListModel.accountNumber!})' : '',
                                                        style: TextHelper.size15.copyWith(
                                                          color: ColorsForApp.greyColor,
                                                        ),
                                                      )
                                                    : const Text(''),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    case 'StatementUserList':
                                      UserData userModel = searchedList[index];
                                      return customTitleCard(
                                        title: userModel.ownerName != null && userModel.ownerName!.isNotEmpty ? userModel.ownerName! : '',
                                        onTap: () {
                                          Get.back(result: userModel);
                                        },
                                      );
                                    case 'depositBankList':
                                      RecipientDepositBankModel masterBankListModel = searchedList[index];
                                      return customTitleCard(
                                        title: masterBankListModel.bankName != null && masterBankListModel.bankName!.isNotEmpty ? masterBankListModel.bankName! : '',
                                        onTap: () {
                                          Get.back(result: masterBankListModel);
                                        },
                                      );
                                    case 'userTypeList':
                                      UserTypeModel userTypeModel = searchedList[index];
                                      return customTitleCard(
                                        title: userTypeModel.name != null && userTypeModel.name!.isNotEmpty ? userTypeModel.name! : '',
                                        onTap: () {
                                          Get.back(result: userTypeModel);
                                        },
                                      );
                                    case 'entityTypeList':
                                      EntityTypeModel entityTypeModel = searchedList[index];
                                      return customTitleCard(
                                        title: entityTypeModel.name != null && entityTypeModel.name!.isNotEmpty ? entityTypeModel.name! : '',
                                        onTap: () {
                                          Get.back(result: entityTypeModel);
                                        },
                                      );
                                    case 'userListTransaction':
                                      UserData userListData = searchedList[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Get.back(result: userListData);
                                        },
                                        child: Card(
                                          elevation: 1.5,
                                          color: ColorsForApp.whiteColor,
                                          shadowColor: ColorsForApp.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 0.5,
                                              color: ColorsForApp.grayScale200,
                                            ),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  userListData.ownerName != null && userListData.ownerName!.isNotEmpty ? userListData.ownerName! : '',
                                                  style: TextHelper.size15.copyWith(
                                                    color: ColorsForApp.primaryColor,
                                                  ),
                                                ),
                                                height(0.5.h),
                                                Text(
                                                  userListData.userName != null && userListData.userName!.isNotEmpty ? '(${userListData.userName!})' : '',
                                                  style: TextHelper.size13.copyWith(
                                                    color: ColorsForApp.lightBlackColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    case 'paymentModeList':
                                      PaymentModeModel paymentModeModel = searchedList[index];
                                      return customTitleCard(
                                        title: paymentModeModel.name != null && paymentModeModel.name!.isNotEmpty ? paymentModeModel.name! : '',
                                        onTap: () {
                                          Get.back(result: paymentModeModel);
                                        },
                                      );
                                    case 'walletTypeList':
                                      WalletTypeModel walletTypeModel = searchedList[index];
                                      return customTitleCard(
                                        title: walletTypeModel.name != null && walletTypeModel.name!.isNotEmpty ? walletTypeModel.name! : '',
                                        onTap: () {
                                          Get.back(result: walletTypeModel);
                                        },
                                      );
                                    case 'statesList':
                                      StatesModel statesModel = searchedList[index];
                                      return customTitleCard(
                                        title: statesModel.name != null && statesModel.name!.isNotEmpty ? statesModel.name! : '',
                                        onTap: () {
                                          Get.back(result: statesModel);
                                        },
                                      );
                                    case 'citiesList':
                                      CitiesModel citiesModel = searchedList[index];
                                      return customTitleCard(
                                        title: citiesModel.name != null && citiesModel.name!.isNotEmpty ? citiesModel.name! : '',
                                        onTap: () {
                                          Get.back(result: citiesModel);
                                        },
                                      );
                                    case 'blockList':
                                      BlockModel blockModel = searchedList[index];
                                      return customTitleCard(
                                        title: blockModel.name != null && blockModel.name!.isNotEmpty ? blockModel.name! : '',
                                        onTap: () {
                                          Get.back(result: blockModel);
                                        },
                                      );
                                    case 'profileList':
                                      Profile profileModel = searchedList[index];
                                      return customTitleCard(
                                        title: profileModel.name != null && profileModel.name!.isNotEmpty ? profileModel.name! : '',
                                        onTap: () {
                                          Get.back(result: profileModel);
                                        },
                                      );
                                    case 'categoryList':
                                      CategoryModel categoryModel = searchedList[index];
                                      return customTitleCard(
                                        title: categoryModel.name != null && categoryModel.name!.isNotEmpty ? categoryModel.name! : '-',
                                        onTap: () {
                                          Get.back(result: categoryModel);
                                        },
                                      );
                                    case 'serviceList':
                                      ServiceModel serviceModel = searchedList[index];
                                      return customTitleCard(
                                        title: serviceModel.name != null && serviceModel.name!.isNotEmpty ? serviceModel.name! : '-',
                                        onTap: () {
                                          Get.back(result: serviceModel);
                                        },
                                      );
                                    case 'settlementCycle':
                                      SettlementCyclesModel settlementCyclesModel = searchedList[index];
                                      return customTitleCard(
                                        title: settlementCyclesModel.settlementType != null && settlementCyclesModel.settlementType!.isNotEmpty ? settlementCyclesModel.settlementType! : '-',
                                        onTap: () {
                                          Get.back(result: settlementCyclesModel);
                                        },
                                      );
                                    case 'childUserList':
                                      child_user_list.UserData childUserData = searchedList[index];
                                      return customTitleCard(
                                        title: childUserData.ownerName != null && childUserData.ownerName!.isNotEmpty ? childUserData.ownerName! : '-',
                                        onTap: () {
                                          Get.back(result: childUserData);
                                        },
                                      );
                                    case 'merchantCategoryList':
                                      CategoryListModel categoryListModel = searchedList[index];
                                      return customTitleCard(
                                        title: categoryListModel.description != null && categoryListModel.description!.isNotEmpty ? categoryListModel.description! : '-',
                                        onTap: () {
                                          Get.back(result: categoryListModel);
                                        },
                                      );
                                    case 'merchantTypeList':
                                      MerchantTypeData merchantTypeListModel = searchedList[index];
                                      return customTitleCard(
                                        title: merchantTypeListModel.name != null && merchantTypeListModel.name!.isNotEmpty ? merchantTypeListModel.name! : '-',
                                        onTap: () {
                                          Get.back(result: merchantTypeListModel);
                                        },
                                      );
                                    case 'terminalTypeList':
                                      TerminalTypeListModel terminalTypeListModel = searchedList[index];
                                      return customTitleCard(
                                        title: terminalTypeListModel.name != null && terminalTypeListModel.name!.isNotEmpty ? terminalTypeListModel.name! : '-',
                                        onTap: () {
                                          Get.back(result: terminalTypeListModel);
                                        },
                                      );
                                    case 'deviceModelList':
                                      DeviceListModel deviceListModel = searchedList[index];
                                      return customTitleCard(
                                        title: deviceListModel.name != null && deviceListModel.name!.isNotEmpty ? deviceListModel.name! : '-',
                                        onTap: () {
                                          Get.back(result: deviceListModel);
                                        },
                                      );
                                    case 'tokenTypeList':
                                      ProductChildCategoryModel productChildCategoryModel = searchedList[index];
                                      return customTitleCard(
                                        title: productChildCategoryModel.name != null && productChildCategoryModel.name!.isNotEmpty ? productChildCategoryModel.name! : '-',
                                        onTap: () {
                                          Get.back(result: productChildCategoryModel);
                                        },
                                      );
                                    case 'productDetailsList':
                                      AllProductListModel allProductListModel = searchedList[index];
                                      return customTitleCard(
                                        title: allProductListModel.name != null && allProductListModel.name!.isNotEmpty ? allProductListModel.name! : '-',
                                        onTap: () {
                                          Get.back(result: allProductListModel);
                                        },
                                      );
                                    case 'bankSathiCategoryList':
                                      BKCategoryListModel categoryModel = searchedList[index];
                                      return customTitleCard(
                                        title: categoryModel.title != null && categoryModel.title!.isNotEmpty ? categoryModel.title! : '-',
                                        onTap: () {
                                          Get.back(result: categoryModel);
                                        },
                                      );
                                    case 'firmList':
                                      CompanyListModel companyModel = searchedList[index];
                                      return customTitleCard(
                                        title: companyModel.companyName != null && companyModel.companyName!.isNotEmpty ? companyModel.companyName! : '-',
                                        onTap: () {
                                          Get.back(result: companyModel);
                                        },
                                      );
                                    case 'occupationList':
                                      OccupationListModel occupationModel = searchedList[index];
                                      return customTitleCard(
                                        title: occupationModel.occuTitle != null && occupationModel.occuTitle!.isNotEmpty ? occupationModel.occuTitle! : '-',
                                        onTap: () {
                                          Get.back(result: occupationModel);
                                        },
                                      );
                                    case 'pinCodeList':
                                      PinCodeListModel pinCodeList = searchedList[index];
                                      return customTitleCard(
                                        title: pinCodeList.pinCode != null && pinCodeList.pinCode!.isNotEmpty ? pinCodeList.pinCode! : '-',
                                        onTap: () {
                                          Get.back(result: pinCodeList);
                                        },
                                      );
                                    case 'masterAirlineList':
                                      AirlineModel airlineModel = searchedList[index];
                                      return InkWell(
                                        onTap: () {
                                          Get.back(result: airlineModel);
                                        },
                                        child: Card(
                                          elevation: 2,
                                          color: ColorsForApp.whiteColor,
                                          surfaceTintColor: ColorsForApp.whiteColor,
                                          shadowColor: ColorsForApp.primaryColor.withOpacity(0.7),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 0.5,
                                              color: ColorsForApp.grayScale200,
                                            ),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${airlineModel.name ?? ''}, ${airlineModel.country ?? ''}',
                                                      style: TextHelper.size14.copyWith(
                                                        fontFamily: boldNunitoFont,
                                                      ),
                                                    ),
                                                    Text(
                                                      airlineModel.code ?? '',
                                                      style: TextHelper.size13.copyWith(
                                                        fontFamily: mediumNunitoFont,
                                                        color: ColorsForApp.lightBlackColor.withOpacity(0.7),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    case 'masterBusFromLocationList':
                                      BusCities locationModel = searchedList[index];
                                      return InkWell(
                                        onTap: () {
                                          Get.back(result: locationModel);
                                        },
                                        child: Card(
                                          elevation: 2,
                                          color: ColorsForApp.whiteColor,
                                          surfaceTintColor: ColorsForApp.whiteColor,
                                          shadowColor: ColorsForApp.primaryColor.withOpacity(0.7),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 0.5,
                                              color: ColorsForApp.grayScale200,
                                            ),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.directions_bus,
                                                      color: ColorsForApp.primaryColor.withOpacity(0.3),
                                                    ),
                                                    width(2.w),
                                                    Text(
                                                      locationModel.name ?? '',
                                                      style: TextHelper.size14.copyWith(
                                                        fontFamily: mediumNunitoFont,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    case 'masterCountryList':
                                      CountryModel countryModel = searchedList[index];
                                      return customTitleCard(
                                        title: countryModel.name != null && countryModel.name!.isNotEmpty ? countryModel.name! : '',
                                        onTap: () {
                                          Get.back(result: countryModel);
                                        },
                                      );
                                    default:
                                      return Container();
                                  }
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

  Widget customTitleCard({required String title, required Function()? onTap}) {
    return GestureDetector(
      onTap: onTap!,
      child: Card(
        elevation: 2,
        color: ColorsForApp.whiteColor,
        shadowColor: ColorsForApp.primaryColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.5,
            color: ColorsForApp.grayScale200,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(
            title,
            style: TextHelper.size15.copyWith(
              color: ColorsForApp.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

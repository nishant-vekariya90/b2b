import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../controller/retailer/aeps_settlement_controller.dart';
import '../controller/distributor/credit_debit_controller.dart';
import '../controller/retailer/flight_controller.dart';
import '../generated/assets.dart';
import '../model/aeps_settlement/aeps_bank_list_model.dart';
import '../model/credit_debit/user_list_model.dart';
import '../model/flight/airport_model.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import 'button.dart';
import 'constant_widgets.dart';
import 'text_field.dart';

class SearchabelListViewPaginationScreen extends StatefulWidget {
  const SearchabelListViewPaginationScreen({super.key});

  @override
  State<SearchabelListViewPaginationScreen> createState() => _SearchabelListViewPaginationScreenState();
}

class _SearchabelListViewPaginationScreenState extends State<SearchabelListViewPaginationScreen> {
  late CreditDebitController creditDebitController;
  late AepsSettlementController aepsSettlementController;
  late FlightController flightController;
  ScrollController scrollController = ScrollController();
  final String listType = Get.arguments ?? '';
  RxList searchedList = [].obs;

  @override
  void initState() {
    super.initState();
    if (listType == 'userList') {
      creditDebitController = Get.find();
      userListAsynApi();
    } else if (listType == 'aepsBankList') {
      aepsSettlementController = Get.find();
      aepsBankListAsynApi();
    } else if (listType == 'aepsUpiList') {
      aepsSettlementController = Get.find();
      aepsUpiListAsynApi();
    } else if (listType == 'masterAirportList') {
      flightController = Get.find();
      masterAirportListAsynApi();
    }
  }

  // userList
  Future<void> userListAsynApi() async {
    try {
      await creditDebitController.getUserListVaiUserType(
        userTypeId: creditDebitController.selectedUserTypeId.value,
        pageNumber: 1,
      );
      searchedList.assignAll(creditDebitController.userList);
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels && creditDebitController.currentPage.value < creditDebitController.totalPages.value) {
          creditDebitController.currentPage.value++;
          await creditDebitController.getUserListVaiUserType(
            userTypeId: creditDebitController.selectedUserTypeId.value,
            pageNumber: creditDebitController.currentPage.value,
            isLoaderShow: false,
          );
        }
        searchedList.assignAll(creditDebitController.userList);
      });
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // aepsBankList
  Future<void> aepsBankListAsynApi() async {
    try {
      await aepsSettlementController.getAepsBankList(pageNumber: 1);
      searchedList.assignAll(aepsSettlementController.successAepsBankList);
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels && aepsSettlementController.currentPage.value < aepsSettlementController.totalPages.value) {
          aepsSettlementController.currentPage.value++;
          await aepsSettlementController.getAepsBankList(
            pageNumber: aepsSettlementController.currentPage.value,
            isLoaderShow: false,
          );
        }
        searchedList.assignAll(aepsSettlementController.successAepsBankList);
      });
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // aepsUpiList
  Future<void> aepsUpiListAsynApi() async {
    try {
      await aepsSettlementController.getAepsBankList(pageNumber: 1);
      searchedList.assignAll(aepsSettlementController.successAepsUpiList);
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels && aepsSettlementController.currentPage.value < aepsSettlementController.totalPages.value) {
          aepsSettlementController.currentPage.value++;
          await aepsSettlementController.getAepsBankList(
            pageNumber: aepsSettlementController.currentPage.value,
            isLoaderShow: false,
          );
        }
        searchedList.assignAll(aepsSettlementController.successAepsUpiList);
      });
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  // masterAirportList
  Future<void> masterAirportListAsynApi() async {
    try {
      await flightController.getAirportList(pageNumber: 1);
      searchedList.assignAll(flightController.masterAirportList);
      scrollController.addListener(() async {
        if (scrollController.position.maxScrollExtent == scrollController.position.pixels && flightController.currentPage.value < flightController.totalPages.value) {
          flightController.currentPage.value++;
          await flightController.getAirportList(
            pageNumber: flightController.currentPage.value,
            isLoaderShow: false,
          );
        }
        searchedList.assignAll(flightController.masterAirportList);
      });
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  searchFromOptions(String value) async {
    searchedList.clear();
    if (listType == 'userList') {
      if (value.length >= 3) {
        await creditDebitController.getUserListVaiSearch(
          text: value,
          userTypeId: creditDebitController.selectedUserTypeId.value,
          pageNumber: 1,
        );
      } else if (value.isEmpty || value.length == 2) {
        await creditDebitController.getUserListVaiUserType(
          userTypeId: creditDebitController.selectedUserTypeId.value,
          pageNumber: 1,
        );
        searchedList.assignAll(creditDebitController.userList);
      }
      if (creditDebitController.userList.isNotEmpty) {
        List<UserData> tempList = creditDebitController.userList.where((element) {
          return (element.ownerName?.toLowerCase().contains(value.toLowerCase()) ?? false) || (element.userName?.toLowerCase().contains(value.toLowerCase()) ?? false);
        }).toList();
        searchedList.assignAll(tempList);
      }
    } else if (listType == 'aepsBankList') {
      if (value.isEmpty) {
        await aepsSettlementController.getAepsBankList(
          pageNumber: 1,
          isLoaderShow: false,
        );
        searchedList.assignAll(aepsSettlementController.successAepsBankList);
      } else {
        if (aepsSettlementController.successAepsBankList.isNotEmpty) {
          List<AepsBankListModel> tempList = aepsSettlementController.successAepsBankList.where((element) {
            return (element.bankName?.toLowerCase().contains(value.toLowerCase()) ?? false);
          }).toList();
          searchedList.assignAll(tempList);
        }
      }
    } else if (listType == 'aepsUpiList') {
      if (value.isEmpty) {
        await aepsSettlementController.getAepsBankList(
          pageNumber: 1,
          isLoaderShow: false,
        );
        searchedList.assignAll(aepsSettlementController.successAepsUpiList);
      } else {
        if (aepsSettlementController.successAepsUpiList.isNotEmpty) {
          List<AepsBankListModel> tempList = aepsSettlementController.successAepsUpiList.where((element) {
            return (element.upiid?.toLowerCase().contains(value.toLowerCase()) ?? false);
          }).toList();
          searchedList.assignAll(tempList);
        }
      }
    } else if (listType == 'masterAirportList') {
      if (value.isEmpty || value.length >= 3) {
        await flightController.getAirportList(
          searchText: value,
          pageNumber: 1,
        );
      }
      searchedList.assignAll(flightController.masterAirportList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(
          result: listType == 'userList'
              ? UserData()
              : listType == 'aepsBankList'
                  ? AepsBankListModel()
                  : listType == 'aepsUpiList'
                      ? AepsBankListModel()
                      : listType == 'masterAirportList'
                          ? AirportData()
                          : AirportData(),
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
                      result: listType == 'userList'
                          ? UserData()
                          : listType == 'aepsBankList'
                              ? AepsBankListModel()
                              : listType == 'aepsUpiList'
                                  ? AepsBankListModel()
                                  : listType == 'masterAirportList'
                                      ? AirportData()
                                      : AirportData(),
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
                        : ListView.builder(
                            controller: scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            itemCount: searchedList.length,
                            itemBuilder: (context, index) {
                              switch (listType) {
                                case 'userList':
                                  if (searchedList.length > 15 && index == searchedList.length - 1 && creditDebitController.hasNext.value) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: ColorsForApp.primaryColor,
                                        ),
                                      ),
                                    );
                                  } else {
                                    UserData userListData = searchedList[index] as UserData;
                                    return GestureDetector(
                                      onTap: () {
                                        Get.back(result: userListData);
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
                                  }
                                case 'aepsBankList':
                                  if (searchedList.length > 15 && index == searchedList.length - 1 && aepsSettlementController.hasNext.value) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: ColorsForApp.primaryColor,
                                        ),
                                      ),
                                    );
                                  } else {
                                    AepsBankListModel aepsBankListData = searchedList[index] as AepsBankListModel;
                                    return GestureDetector(
                                      onTap: () {
                                        Get.back(result: aepsBankListData);
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
                                              Text(
                                                aepsBankListData.bankName != null && aepsBankListData.bankName!.isNotEmpty ? aepsBankListData.bankName! : '-',
                                                style: TextHelper.size15.copyWith(
                                                  color: ColorsForApp.primaryColor,
                                                ),
                                              ),
                                              Text(
                                                aepsBankListData.accountNumber != null && aepsBankListData.accountNumber!.isNotEmpty ? ' (${aepsBankListData.accountNumber!})' : '',
                                                style: TextHelper.size15.copyWith(
                                                  color: ColorsForApp.greyColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                case 'aepsUpiList':
                                  if (searchedList.length > 15 && index == searchedList.length - 1 && aepsSettlementController.hasNext.value) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: ColorsForApp.primaryColor,
                                        ),
                                      ),
                                    );
                                  } else {
                                    AepsBankListModel aepsBankListData = searchedList[index] as AepsBankListModel;
                                    return GestureDetector(
                                      onTap: () {
                                        Get.back(result: aepsBankListData);
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
                                              Text(
                                                aepsBankListData.upiid != null && aepsBankListData.upiid!.isNotEmpty ? aepsBankListData.upiid! : '-',
                                                style: TextHelper.size15.copyWith(
                                                  color: ColorsForApp.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                case 'masterAirportList':
                                  if (searchedList.length > 25 && index == searchedList.length - 1 && flightController.hasNext.value) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: ColorsForApp.primaryColor,
                                        ),
                                      ),
                                    );
                                  } else {
                                    AirportData airportData = searchedList[index] as AirportData;
                                    return GestureDetector(
                                      onTap: () {
                                        Get.back(result: airportData);
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
                                                    '${airportData.cityName ?? ''}, ${airportData.countryName ?? ''}',
                                                    style: TextHelper.size14.copyWith(
                                                      fontFamily: boldNunitoFont,
                                                    ),
                                                  ),
                                                  Text(
                                                    airportData.airportCode ?? '',
                                                    style: TextHelper.size13.copyWith(
                                                      fontFamily: mediumNunitoFont,
                                                      color: ColorsForApp.lightBlackColor.withOpacity(0.7),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                airportData.airportName ?? '',
                                                style: TextHelper.size13.copyWith(
                                                  fontFamily: regularNunitoFont,
                                                  color: ColorsForApp.greyColor.withOpacity(0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
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
}

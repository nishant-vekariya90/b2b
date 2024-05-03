import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../api/api_manager.dart';
import '../model/auth/adress_by_pincode_model.dart';
import '../model/auth/cities_model.dart';
import '../model/auth/states_model.dart';
import '../model/product/all_product_model.dart';
import '../model/product/order_placed_model.dart';
import '../model/product/product_main_category_model.dart';
import '../repository/product_repository.dart';
import '../utils/string_constants.dart';
import '../widgets/constant_widgets.dart';

class ProductController extends GetxController {
  ProductRepository productRepository = ProductRepository(APIManager());

  RxBool isRouteFromBestSeller = false.obs;

  // Get all categories
  RxList<ProductMainCategoryModel> filteredCategoryList = <ProductMainCategoryModel>[].obs;
  RxList<ProductMainCategoryModel> categoryList = <ProductMainCategoryModel>[].obs;
  Future<bool> getCategoryApi({bool isLoaderShow = true}) async {
    try {
      List<ProductMainCategoryModel> mainProductModel = await productRepository.getMainProductApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (mainProductModel.isNotEmpty) {
        filteredCategoryList.clear();
        categoryList.clear();
        for (ProductMainCategoryModel element in mainProductModel) {
          if (element.status == 1 && element.isVisible == true) {
            filteredCategoryList.add(element);
            categoryList.add(element);
          }
        }
        return true;
      } else {
        filteredCategoryList.clear();
        categoryList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

    // search filter in category
    searchInCategoryList(String searchQuery) {
      if (searchQuery.isNotEmpty) {
        filteredCategoryList.value = categoryList.where((item) {
          final query = searchQuery.toLowerCase();
          return item.name!.toLowerCase().contains(query);
        }).toList();
      } else {
        filteredCategoryList.value = categoryList;
      }
    }

  // Get all product list
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  RxBool hasNext = false.obs;
  RxString selectedCategoryId = ''.obs;

  RxList<AllProductListModel> filteredProductList = <AllProductListModel>[].obs;
  RxList<AllProductListModel> allProductList = <AllProductListModel>[].obs;
  RxList<AllProductListModel> bestSellerProductList = <AllProductListModel>[].obs;
  Future<bool> getAllProductList({required int pageNumber, required String isBestSeller, bool isLoaderShow = true}) async {
    try {
      AllProductModel allProductModel = await productRepository.getAllProductApiCall(
        isBestSeller: isBestSeller,
        pageNumber: pageNumber,
        isLoaderShow: isLoaderShow,
        categoryID: selectedCategoryId.value,
      );
      if (allProductModel.statusCode == 1) {
        if (allProductModel.pagination!.currentPage == 1) {
          allProductList.clear();
          filteredProductList.clear();
          bestSellerProductList.clear();
        }
        for (AllProductListModel element in allProductModel.data!) {
          if (element.status == 1) {
            if (element.isDiscount == true && element.price != null && element.salePrice != null && element.price! > element.salePrice!) {
              element.discount = ((element.price! - element.salePrice!) / element.price!) * 100;
            }
            allProductList.add(element);
            filteredProductList.add(element);
            if (element.isBestSeller == true) {
              bestSellerProductList.add(element);
            }
          }
        }
        currentPage.value = allProductModel.pagination!.currentPage!;
        totalPages.value = allProductModel.pagination!.totalPages!;
        hasNext.value = allProductModel.pagination!.hasNext!;
        return true;
      } else if (allProductModel.statusCode == 0) {
        allProductList.clear();
        filteredProductList.clear();
        bestSellerProductList.clear();
        return true;
      } else {
        allProductList.clear();
        filteredProductList.clear();
        bestSellerProductList.clear();
        errorSnackBar(message: allProductModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // search filter in all products
  searchInProductList(String searchQuery) {
    if (searchQuery.isNotEmpty) {
      filteredProductList.value = allProductList.where((item) {
        final query = searchQuery.toLowerCase();
        return item.name!.toLowerCase().contains(query);
      }).toList();
    } else {
      filteredProductList.value = allProductList;
    }
  }

  resetAllProductsVariables() {
    filteredProductList.clear();
  }

  // Product details
  VideoPlayerController? videoPlayerController;
  RxInt currentIndex = 0.obs;
  RxInt quantity = 0.obs;
  RxInt totalPrice = 0.obs;
  TextEditingController productNameController = TextEditingController();
  void increaseItemQuantity(AllProductListModel product) {
    // If we have availableUnits=20 and maxQty=10 then we check quantity  must be less than maxQty
    if (product.availableUnits! <= product.maxQnty!) {
      if (quantity.value < product.availableUnits!) {
        quantity.value++;
        calculateTotalPrice(product);
        update();
      } else {
        infoSnackBar(message: "Sorry, you can't add more than ${product.availableUnits} items");
      }
    }
    // If we have maxQty=10 and  availableUnits=4 then we check quantity must be less than availableUnits
    else {
      if (quantity.value < product.maxQnty!) {
        quantity.value++;
        calculateTotalPrice(product);
        update();
      } else {
        infoSnackBar(message: "Sorry, you can't add more than ${product.maxQnty} items");
      }
    }
  }

  void decreaseItemQuantity(AllProductListModel product) {
    if (quantity.value > 0) {
      quantity.value--;
      calculateTotalPrice(product);
      update();
    }
  }

  void calculateTotalPrice(AllProductListModel product) {
    totalPrice.value = 0;
    totalPrice.value += (quantity.value * product.salePrice!).toInt();
  }

  // For address form
  RxBool isShowTpinField = false.obs;
  RxBool isShowTpin = true.obs;
  TextEditingController nameTxtController = TextEditingController();
  TextEditingController mobileTxtController = TextEditingController();
  TextEditingController altMobileTxtController = TextEditingController();
  TextEditingController emailTxtController = TextEditingController();
  TextEditingController addressTxtController = TextEditingController();
  TextEditingController address2TxtController = TextEditingController();
  TextEditingController houseNumberTxtController = TextEditingController();
  TextEditingController districtTxtController = TextEditingController();
  TextEditingController stateTxtController = TextEditingController();
  TextEditingController cityTxtController = TextEditingController();
  TextEditingController pinCodeTxtController = TextEditingController();
  TextEditingController tPinTxtController = TextEditingController();

  RxList<StatesModel> statesList = <StatesModel>[].obs;
  RxList<CitiesModel> citiesList = <CitiesModel>[].obs;
  RxString selectedBlockId = ''.obs;
  RxString selectedStateId = ''.obs;
  RxString selectedDistrictId = ''.obs;
  RxString selectedCityId = ''.obs;
  RxString productUnqId = ''.obs;
  RxInt orderStatus = (-1).obs;
  Rx<StateCityBlockModel> getCityStateBlockData = StateCityBlockModel().obs;

  // Fetch state,city by pinCode
  Future<bool> getStateCityByPinCodeAPI({bool isLoaderShow = true, required String pinCode}) async {
    try {
      StateCityBlockModel response = await productRepository.stateCityBlockApiCall(
        isLoaderShow: isLoaderShow,
        pinCode: pinCode,
      );
      if (response.status == 1) {
        getCityStateBlockData.value = response;
        return true;
      } else {
        errorSnackBar(message: response.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // States api call
  Future<bool> getStatesAPI({bool isLoaderShow = true}) async {
    try {
      List<StatesModel> response = await productRepository.statesApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (response.isNotEmpty) {
        statesList.value = [];
        for (StatesModel element in response) {
          if (element.status == 1) {
            statesList.add(element);
          }
        }
        return true;
      } else {
        statesList.value = [];
        // errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Cities api call
  Future<bool> getCitiesAPI({bool isLoaderShow = true}) async {
    try {
      List<CitiesModel> response = await productRepository.citiesApiCall(
        isLoaderShow: isLoaderShow,
        stateId: selectedStateId.value,
      );
      if (response.isNotEmpty) {
        citiesList.value = [];
        for (CitiesModel element in response) {
          if (element.status == 1) {
            citiesList.add(element);
          }
        }
        return true;
      } else {
        citiesList.value = [];
        // errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Order place api
  Rx<OrderPlacedModel> orderPlacedModel = OrderPlacedModel().obs;
  Future<int> orderPlace({bool isLoaderShow = true}) async {
    try {
      orderPlacedModel.value = await productRepository.orderPlaceApiCall(
        params: {
          "productUnqId": productUnqId.value,
          "quantity": quantity.value,
          "amount": totalPrice.value,
          "name": nameTxtController.text.trim(),
          "email": emailTxtController.text.trim(),
          "contact": mobileTxtController.text.trim(),
          "address": addressTxtController.text.trim(),
          "address2": address2TxtController.text.trim(),
          "houseNo": houseNumberTxtController.text.trim(),
          "city": cityTxtController.text.trim(),
          "pincode": pinCodeTxtController.text.trim(),
          "district": districtTxtController.text.trim(),
          "state": stateTxtController.text.trim(),
          "altContact": altMobileTxtController.text.trim(),
          "channel": channelID,
          "orderId": 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          "tpin": tPinTxtController.text.isNotEmpty ? tPinTxtController.text.trim() : null,
          "latitude": latitude,
          "longitude": longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (orderPlacedModel.value.statusCode != null) {
        return orderPlacedModel.value.statusCode!;
      } else {
        errorSnackBar(message: orderPlacedModel.value.message);
        return -1;
      }
    } catch (e) {
      dismissProgressIndicator();
      return -1;
    }
  }

  resetAddressVariables() {
    isShowTpinField.value = false;
    isShowTpin.value = true;
    nameTxtController.clear();
    mobileTxtController.clear();
    altMobileTxtController.clear();
    emailTxtController.clear();
    addressTxtController.clear();
    address2TxtController.clear();
    houseNumberTxtController.clear();
    districtTxtController.clear();
    stateTxtController.clear();
    cityTxtController.clear();
    pinCodeTxtController.clear();
    tPinTxtController.clear();
    statesList.clear();
    citiesList.clear();
    selectedBlockId.value = '';
    selectedStateId.value = '';
    selectedDistrictId.value = '';
    selectedCityId.value = '';
    productUnqId.value = '';
  }

  resetProductDetailsVariables() {
    currentIndex.value = 0;
    quantity.value = 0;
    totalPrice.value = 0;
    isShowTpinField.value = false;
    isShowTpin.value = true;
    nameTxtController.clear();
    mobileTxtController.clear();
    altMobileTxtController.clear();
    emailTxtController.clear();
    addressTxtController.clear();
    address2TxtController.clear();
    houseNumberTxtController.clear();
    districtTxtController.clear();
    stateTxtController.clear();
    cityTxtController.clear();
    pinCodeTxtController.clear();
    tPinTxtController.clear();
    statesList.clear();
    citiesList.clear();
    selectedBlockId.value = '';
    selectedStateId.value = '';
    selectedDistrictId.value = '';
    selectedCityId.value = '';
    productUnqId.value = '';
  }
}

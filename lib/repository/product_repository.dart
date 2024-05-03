import '../api/api_manager.dart';
import '../model/auth/adress_by_pincode_model.dart';
import '../model/auth/cities_model.dart';
import '../model/auth/states_model.dart';
import '../model/product/all_product_model.dart';
import '../model/product/order_placed_model.dart';
import '../model/product/product_main_category_model.dart';
import '../utils/string_constants.dart';

class ProductRepository {
  final APIManager apiManager;
  ProductRepository(this.apiManager);

  // Get main product list api call
  Future<List<ProductMainCategoryModel>> getMainProductApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/productmaincategory',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<ProductMainCategoryModel> object = response.map((e) => ProductMainCategoryModel.fromJson(e)).toList();
    return object;
  }

  // Get all product list api call
  Future<AllProductModel> getAllProductApiCall({required String isBestSeller, required String categoryID, required int pageNumber, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/productdata?CategoryID=$categoryID&IsBestSeller=$isBestSeller&PageNumber=$pageNumber&PageSize=10',
      isLoaderShow: isLoaderShow,
    );
    var response = AllProductModel.fromJson(jsonData);
    return response;
  }

  //Get states list
  Future<List<StatesModel>> statesApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/states',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<StatesModel> objects = response.map((jsonMap) => StatesModel.fromJson(jsonMap)).toList();
    return objects;
  }

  //Get cities list
  Future<List<CitiesModel>> citiesApiCall({bool isLoaderShow = true, required String stateId}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/cities?StateID=$stateId',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<CitiesModel> objects = response.map((jsonMap) => CitiesModel.fromJson(jsonMap)).toList();
    return objects;
  }

  // State city block api call
  Future<StateCityBlockModel> stateCityBlockApiCall({bool isLoaderShow = true, required String pinCode}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/master-module/pinCodes/pincode-block-city-state?pincode=$pinCode',
      isLoaderShow: isLoaderShow,
    );
    var response = StateCityBlockModel.fromJson(jsonData);
    return response;
  }

  // Order place api call
  Future<OrderPlacedModel> orderPlaceApiCall({required Map<String, dynamic> params, bool isLoaderShow = true}) async {
    var jsonData = await apiManager.postAPICall(
      url: '${baseUrl}transaction/api/transaction-module/Product/place-order',
      params: params,
      isLoaderShow: isLoaderShow,
    );
    var response = OrderPlacedModel.fromJson(jsonData);
    return response;
  }
}

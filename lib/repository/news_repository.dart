import '../api/api_manager.dart';
import '../model/news_model.dart';
import '../utils/string_constants.dart';

class NewsRepository {
  final APIManager apiManager;
  NewsRepository(this.apiManager);

  // Get news api call
  Future<List<NewsModel>> getNewsApiCall({bool isLoaderShow = true}) async {
    var jsonData = await apiManager.getAPICall(
      url: '${baseUrl}masterdata/api/new-Api/settingsnews/user-type-list-news',
      isLoaderShow: isLoaderShow,
    );
    var response = jsonData as List;
    List<NewsModel> objects = response.map((e) => NewsModel.fromJson(e)).toList();
    return objects;
  }
}

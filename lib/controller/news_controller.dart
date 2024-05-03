import 'package:get/get.dart';
import '../api/api_manager.dart';
import '../model/news_model.dart';
import '../repository/news_repository.dart';
import '../widgets/constant_widgets.dart';

class NewsController extends GetxController {
  NewsRepository newsRepository = NewsRepository(APIManager());

  // Get news list
  RxList<NewsModel> newsList = <NewsModel>[].obs;
  RxString scrollNews = ''.obs;
  Future<bool> getNews({bool isLoaderShow = true}) async {
    try {
      List<NewsModel> newsModel = await newsRepository.getNewsApiCall(
        isLoaderShow: isLoaderShow,
      );
      newsList.clear();
      if (newsModel.isNotEmpty) {
        for (NewsModel element in newsModel) {
          if (element.contentType == 'Video' && element.fileUrl != null && element.status != 1) {
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
          } else if (element.status != 1 && element.newsType == 'Scroller' && element.contentType == 'Text' && element.value != null) {
            scrollNews.value = convertHtmlToPlainText(element.value!);
            newsList.add(element);
          } else if (element.status != 1) {
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

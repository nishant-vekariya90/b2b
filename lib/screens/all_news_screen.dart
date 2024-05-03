import 'dart:typed_data';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_html_css/simple_html_css.dart';
import 'package:sizer/sizer.dart';
import '../controller/news_controller.dart';
import '../generated/assets.dart';
import '../model/news_model.dart';
import '../utils/app_colors.dart';
import '../utils/text_styles.dart';
import '../widgets/button.dart';
import '../widgets/constant_widgets.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/network_image.dart';

class AllNewsScreen extends StatefulWidget {
  const AllNewsScreen({super.key});

  @override
  State<AllNewsScreen> createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  final NewsController newsController = Get.find();

  @override
  void initState() {
    super.initState();
    callAsyncApi();
  }

  Future<void> callAsyncApi() async {
    try {
      await newsController.getNews();
    } catch (e) {
      dismissProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'All News',
      isShowLeadingIcon: true,
      mainBody: Obx(
        () => newsController.newsList.isNotEmpty
            ? ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                itemCount: newsController.newsList.length,
                itemBuilder: (context, index) {
                  NewsModel newsData = newsController.newsList[index];
                  if (newsData.contentType == 'Video' && newsData.fileUrl != null) {
                    return videoSlide(newsData);
                  } else if (newsData.contentType == 'Text' && newsData.value != null) {
                    return textSlide(newsData);
                  } else if (newsData.contentType == 'Image' && newsData.fileUrl != null) {
                    return imageSlide(newsData);
                  } else {
                    // Handle other content types if needed
                    return Container();
                  }
                },
                separatorBuilder: (BuildContext context, int index) {
                  return height(1.h);
                },
              )
            : notFoundText(text: 'No data found'),
      ),
    );
  }

  Widget textSlide(NewsModel newsData) {
    TextPainter textPainter = TextPainter(
      text: HTML.toTextSpan(
        context,
        newsData.value!,
        overrideStyle: {
          'p': const TextStyle(
            fontFamily: 'DMSans',
          ),
          'ul': const TextStyle(
            fontFamily: 'DMSans',
            wordSpacing: 1,
          ),
          'li': const TextStyle(
            fontFamily: 'DMSans',
            wordSpacing: 1,
          ),
        },
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);
    bool isShowReadMore = textPainter.didExceedMaxLines;
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorsForApp.greyColor.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(
            () => Column(
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      HTML.toTextSpan(
                        context,
                        newsData.value!,
                        overrideStyle: {
                          'p': const TextStyle(
                            fontFamily: 'DMSans',
                          ),
                          'ul': const TextStyle(
                            fontFamily: 'DMSans',
                            wordSpacing: 1,
                          ),
                          'li': const TextStyle(
                            fontFamily: 'DMSans',
                            wordSpacing: 1,
                          ),
                        },
                      ),
                      TextSpan(
                        text: newsData.isExpanded!.value ? ' Read less' : '',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            newsData.isExpanded!.value = !newsData.isExpanded!.value;
                          },
                      ),
                    ],
                  ),
                  maxLines: newsData.isExpanded!.value ? null : 3,
                  overflow: newsData.isExpanded!.value ? TextOverflow.clip : TextOverflow.ellipsis,
                ),
                Visibility(
                  visible: isShowReadMore == true && newsData.isExpanded!.value == false ? true : false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          newsData.isExpanded!.value = !newsData.isExpanded!.value;
                        },
                        child: Text(
                          newsData.isExpanded!.value ? '' : 'Read more',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      width(5),
                    ],
                  ),
                ),
              ],
            ),
          ),
          height(5),
          newsData.createdOn != null
              ? Text(
                  'Posted on ${formatDateTime(newsData.createdOn!)}',
                  style: TextHelper.size12.copyWith(
                    color: ColorsForApp.lightBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : const SizedBox(),
          height(5),
        ],
      ),
    );
  }

  Widget imageSlide(NewsModel newsData) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorsForApp.greyColor.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              openUrl(url: newsData.fileUrl!);
            },
            child: AspectRatio(
              aspectRatio: 16 / 5,
              child: ShowNetworkImage(
                networkUrl: newsData.fileUrl != null && newsData.fileUrl!.isNotEmpty ? newsData.fileUrl! : '',
                defaultImagePath: Assets.imagesDashboardTopBgImage,
                boxShape: BoxShape.rectangle,
              ),
            ),
          ),
          height(5),
          newsData.createdOn != null
              ? Text(
                  'Posted on ${formatDateTime(newsData.createdOn!)}',
                  style: TextHelper.size12.copyWith(
                    color: ColorsForApp.lightBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : const SizedBox(),
          height(5),
        ],
      ),
    );
  }

  Widget videoSlide(NewsModel newsData) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorsForApp.greyColor.withOpacity(0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  openUrl(url: newsData.fileUrl!);
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    // child: Text('Tap to play video',style: TextHelper.size14.copyWith(color: Colors.white),),
                    child: Image.memory(newsData.videoThumbnailImage as Uint8List)),
              ),
              // Play Button
              InkWell(
                onTap: () {
                  openUrl(url: newsData.fileUrl!);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorsForApp.whiteColor.withOpacity(0.7),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: ColorsForApp.lightBlackColor.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          /*InkWell(
             onTap: (){
               openUrl(url: newsData.fileUrl!);
             },
             child: AspectRatio(
                            aspectRatio: 16 / 5,
                            child: ShowNetworkImage(
                              networkUrl:
                              newsData.fileUrl != null && newsData.fileUrl!.isNotEmpty ? newsData.fileUrl! : '',
                              defaultImagePath: Assets.imagesDashboardTopBgImage,
                              boxShape: BoxShape.rectangle,
                            ),
                          ),
           ),*/
          height(5),
          newsData.createdOn != null
              ? Text(
                  'Posted on ${formatDateTime(newsData.createdOn!)}',
                  style: TextHelper.size12.copyWith(
                    color: ColorsForApp.lightBlackColor,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : const SizedBox(),
          height(5),
        ],
      ),
    );
  }
}

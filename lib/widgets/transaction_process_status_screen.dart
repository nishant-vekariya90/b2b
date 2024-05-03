import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../generated/assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/network_image.dart';

class TransactionProcessStatusScreen extends StatefulWidget {
  const TransactionProcessStatusScreen({super.key});

  @override
  State<TransactionProcessStatusScreen> createState() => _TransactionProcessStatusScreenState();
}

class _TransactionProcessStatusScreenState extends State<TransactionProcessStatusScreen> with SingleTickerProviderStateMixin {
  final String progressHeroTag = 'processHero';
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Container(
        key: const ValueKey<int>(4),
        child: Hero(
          tag: progressHeroTag,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
              width: 100.w,
              height: 100.h,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30.h,
                    child: const ShowNetworkImage(
                      networkUrl: Assets.imagesProcessingImg,
                      isAssetImage: true,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  height(2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '  Processing',
                        style: TextHelper.size20.copyWith(
                          fontFamily: boldGoogleSansFont,
                          color: ColorsForApp.primaryColor,
                        ),
                      ),
                      DotAnimation(
                        child: Text(
                          '.',
                          style: TextHelper.h1.copyWith(
                            color: ColorsForApp.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height(0.5.h),
                  Text(
                    'Please Wait',
                    style: TextHelper.size15.copyWith(
                      color: ColorsForApp.greyColor,
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
}

class DotAnimation extends StatefulWidget {
  final Widget child;
  final int numberOfDots;

  const DotAnimation({
    super.key,
    required this.child,
    this.numberOfDots = 3,
  });
  @override
  State<DotAnimation> createState() => _DotAnimationState();
}

class _DotAnimationState extends State<DotAnimation> with TickerProviderStateMixin {
  List<AnimationController>? animationControllers;
  List<Animation<double>> animations = [];

  @override
  void initState() {
    super.initState();
    initAnimation();
  }

  @override
  void dispose() {
    for (var controller in animationControllers!) {
      controller.dispose();
    }
    super.dispose();
  }

  void initAnimation() {
    animationControllers = List.generate(
      widget.numberOfDots,
      (index) {
        return AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 250),
        );
      },
    ).toList();

    for (int i = 0; i < widget.numberOfDots; i++) {
      animations.add(
        Tween<double>(begin: 0, end: -10).animate(
          animationControllers![i],
        ),
      );
    }

    for (int i = 0; i < widget.numberOfDots; i++) {
      animationControllers![i].addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationControllers![i].reverse();
          if (i != widget.numberOfDots - 1) {
            animationControllers![i + 1].forward();
          }
        }
        if (i == widget.numberOfDots - 1 && status == AnimationStatus.dismissed) {
          animationControllers![0].forward();
          Future.delayed(const Duration(milliseconds: 0), () {
            if (mounted) {
              animationControllers![0].forward();
            }
          });
        }
      });
    }
    animationControllers!.first.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Row(
          children: List.generate(widget.numberOfDots, (index) {
            return AnimatedBuilder(
              animation: animationControllers![index],
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, animations[index].value),
                  child: widget.child,
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../../controller/sip_controller.dart';
import '../../../../../generated/assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/constant_widgets.dart';
import '../../../../../widgets/custom_scaffold.dart';
import '../../../../../widgets/text_field_with_title.dart';

class AxisSipScreen extends StatefulWidget {
  const AxisSipScreen({super.key});

  @override
  State<AxisSipScreen> createState() => _AxisSipScreenState();
}

class _AxisSipScreenState extends State<AxisSipScreen> {
  SipController sipController = SipController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    resetSipVariables();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        title: 'Axis SIP',
        isShowLeadingIcon: true,
        mainBody: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: 2.h,horizontal: 4.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(Assets.imagesPancardIllustration,height: 20.h,fit: BoxFit.fitHeight),
                    height(5.h),
                    // Name
                    CustomTextFieldWithTitle(
                      controller: sipController.nameTxtController,
                      title: 'Name',
                      hintText: 'Enter name',
                      isCompulsory: true,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      textInputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                      ],
                      validator: (value) {
                        if (sipController.nameTxtController.text.trim().isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                    height(1.h),
                    // pan card number
                    CustomTextFieldWithTitle(
                      controller: sipController.panCardTxtController,
                      title: 'Pan Card Number',
                      hintText: 'Enter pan card number',
                      maxLength: 19,
                      isCompulsory: true,
                      textCapitalization: TextCapitalization.characters,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        RegExp regex = RegExp("[A-Z]{5}[0-9]{4}[A-Z]{1}");
                        if (sipController.panCardTxtController.text.trim().isEmpty) {
                          return 'Please enter pan card number';
                        } else if(!regex.hasMatch(sipController.panCardTxtController.text.trim())){
                          return 'Please enter valid pan card number';
                        }
                        return null;
                      },
                    ),
                    height(1.h),
                    //Mobile number
                    CustomTextFieldWithTitle(
                      controller: sipController.mobileNoTxtController,
                      title: 'Mobile Number',
                      hintText: 'Enter mobile number',
                      maxLength: 10,
                      isCompulsory: true,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (value) {
                        if (sipController.mobileNoTxtController.text.trim().isEmpty) {
                          return 'Please enter mobile number';
                        } else if (sipController.mobileNoTxtController.text.length < 10) {
                          return 'Please enter valid mobile number';
                        }
                        return null;
                      },
                    ),
                    height(5.h),
                    CommonButton(
                        onPressed: () async {
                          if(formKey.currentState!.validate()){
                            bool result = await sipController.axisSipApi();
                            result?confirmOrderDialog(context):const SizedBox.shrink();
                            }
                          },
                        label: "Proceed"
                    )
                  ],
                ),
              ),
            ),
          ),
    );
  }

  resetSipVariables(){
    sipController.sipUrlLinkTxtController.clear();
    sipController.panCardTxtController.clear();
    sipController.nameTxtController.clear();
    sipController.mobileNoTxtController.clear();
  }

  // Confirm order dialog
  Future<dynamic> confirmOrderDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Confirm Order',
                style: TextHelper.size20.copyWith(
                  fontFamily: mediumGoogleSansFont,
                ),
              ),
              GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: const Icon(Icons.clear_rounded))
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: ColorsForApp.lightBlueColor,
                      borderRadius: BorderRadius.circular(10)
                  ),
                padding: EdgeInsets.all(2.h),
                  child: SelectableText(sipController.sipUrlLinkTxtController.text)),
              height(2.h),
              Row(
                children: [
                  GestureDetector(
                      onTap: () async{
                        String url = 'https://www.facebook.com/sharer/sharer.php?u=${sipController.sipUrlLinkTxtController.text}';
                        await openUrl(url: url);
                      },
                      child: Image.asset(Assets.iconsFacebook,height: 5.h,fit: BoxFit.fitHeight)),
                  GestureDetector(
                      onTap: () async{
                        String url = 'whatsapp://send?text=${sipController.sipUrlLinkTxtController.text}';
                        await openUrl(url: url);
                      },
                      child: Image.asset(Assets.imagesIconwhatsapp,height: 5.h,fit: BoxFit.fitHeight)),
                  Spacer(),
                  GestureDetector(onTap: (){
                    Clipboard.setData(ClipboardData(text: sipController.sipUrlLinkTxtController.text)).then((value) => {
                      successSnackBar(message: "Link copied successfully!")
                    });
                  },
                    child: Container(
                      padding: EdgeInsets.all(1.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorsForApp.grayScale500),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text("Copy",style: TextHelper.size14.copyWith(fontWeight: FontWeight.bold),)),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

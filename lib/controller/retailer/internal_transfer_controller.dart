import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../api/api_manager.dart';
import '../../model/internal_transfer/add_fav_model.dart';
import '../../model/internal_transfer/fav_user_list_model.dart';
import '../../model/internal_transfer/internal_transfer_model.dart';
import '../../model/internal_transfer/remove_fav_user_model.dart';
import '../../model/internal_transfer/validate_username.dart';
import '../../repository/retailer/internal_transfer_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class InternalTransferController extends GetxController {
  InternalTransferRepository internalTransferRepository = InternalTransferRepository(APIManager());

  TextEditingController usernameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  RxString amountIntoWords = ''.obs;
  TextEditingController remarkController = TextEditingController();
  TextEditingController tpinController = TextEditingController();
  Rx<ValidateUsernameModel> validUserModel = ValidateUsernameModel().obs;
  RxBool isShowTpin = true.obs;
  RxBool isValidUser = false.obs;
  RxBool isVerify = false.obs;
  RxBool isValidateUser = false.obs;
  Rx<String> otpRefNumber = ''.obs;
  Rx<String> addFavUserId = ''.obs;

  RxBool clearOtp = false.obs;
  RxBool isResendButtonShow = false.obs;
  Timer? resendTimer;
  RxInt otpTotalSecond = 120.obs;
  RxString enteredOTP = ''.obs;
  RxString autoReadOtp = ''.obs;

  // verify/resend  otp timer
  startTimer() {
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      otpTotalSecond.value--;
      if (otpTotalSecond.value == 0) {
        resendTimer!.cancel();
        isResendButtonShow.value = true;
      }
    });
  }

  // reset  timer
  resetTimer() {
    resendTimer!.cancel();
    otpTotalSecond.value = 120;
    isResendButtonShow.value = false;
    clearOtp.value = true;
  }

  // validate username for internal transfer
  Future<bool> validateUsername({bool isLoaderShow = true, required String username}) async {
    try {
      ValidateUsernameModel validateUsernameModel = await internalTransferRepository.validateUsernameApiCall(isLoaderShow: isLoaderShow, username: username);
      if (validateUsernameModel.statusCode == 1) {
        isValidateUser.value = true;
        validUserModel.value = validateUsernameModel;
        addFavUserId.value = validUserModel.value.userId.toString();
        usernameController.text = validUserModel.value.userName.toString();

        successSnackBar(message: validateUsernameModel.message);
        return true;
      } else {
        errorSnackBar(message: validateUsernameModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Send otp for internal transfer
  Future<bool> sendOtpForInternalTransfer({bool isLoaderShow = true}) async {
    try {
      InternalTransferModel internalTransferModel = await internalTransferRepository.internalTransferApiCall(
        params: {
          'transferUserId': validUserModel.value.userId,
          'amount': amountController.text.trim(),
          'comment': remarkController.text.trim(),
          'wallet': 1,
          "orderId": DateTime.now().millisecondsSinceEpoch.toString(),
          'channel': channelID,
          'tpin': tpinController.text.isNotEmpty ? tpinController.text.trim() : null,
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (internalTransferModel.statusCode == 1) {
        isVerify.value = internalTransferModel.isVerify!;
        if(isVerify.value == true){
          otpRefNumber.value = internalTransferModel.otpRefNo!;
        }
        successSnackBar(message: internalTransferModel.message);
        return true;
      } else {
        errorSnackBar(message: internalTransferModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // confirm internal transfer
  Future<bool> confirmInternalTransfer({bool isLoaderShow = true}) async {
    try {
      InternalTransferModel internalTransferModel = await internalTransferRepository.confirmInternalTransferApiCall(
        params: {
          'transferUserId': validUserModel.value.userId,
          'amount': amountController.text.trim(),
          'comment': remarkController.text,
          'wallet': 1,
          'channel': channelID,
          'tpin': tpinController.text.isNotEmpty ? tpinController.text.trim() : null,
          'orderId': 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
          'otp': enteredOTP.value.trim(),
          'refNumber': otpRefNumber.value.trim(),
          'ipAddress': ipAddress,
          'latitude': latitude,
          'longitude': longitude,
        },
        isLoaderShow: isLoaderShow,
      );
      if (internalTransferModel.statusCode == 1) {
        Get.back();
        successSnackBar(message: internalTransferModel.message);
        return true;
      } else {
        errorSnackBar(message: internalTransferModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Send otp for internal transfer
  Future<bool> addFavouriteUserApi({bool isLoaderShow = true}) async {
    try {
      AddFavouriteModel addFavouriteModel = await internalTransferRepository.addFavouriteApiCall(
        params: {"favUserID": addFavUserId.value.trim().isEmpty ? '' : addFavUserId.value.trim()},
        isLoaderShow: isLoaderShow,
      );
      if (addFavouriteModel.statusCode == 1) {
        successSnackBar(message: addFavouriteModel.message);
        return true;
      } else {
        errorSnackBar(message: addFavouriteModel.message!);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get favourite user list Api call
  RxList<FavouriteUserListModel> favUserList = <FavouriteUserListModel>[].obs;
  Future<bool> getFavUserListApi({bool isLoaderShow = true}) async {
    try {
      List<FavouriteUserListModel> favLModelList = await internalTransferRepository.favUserListApiCall(
        isLoaderShow: isLoaderShow,
      );
      if (favLModelList.isNotEmpty) {
        favUserList.clear();
        for (FavouriteUserListModel element in favLModelList) {
          favUserList.add(element);
        }
        return true;
      } else {
        favUserList.clear();
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //delete Fav user api
  Future<bool> removeFavouriteUser({bool isLoaderShow = true, required int id}) async {
    try {
      RemoveFavouriteModel removeFavouriteModel = await internalTransferRepository.removeFavUserApiCall(
        isLoaderShow: isLoaderShow,
        id: id,
      );
      if (removeFavouriteModel.statusCode == 1) {
        Get.back();
        successSnackBar(message: removeFavouriteModel.message);
        return true;
      } else {
        errorSnackBar(message: removeFavouriteModel.message);
        return false;
      }
    } catch (e) {
      errorSnackBar(message: e.toString());
      dismissProgressIndicator();
      return false;
    }
  }

  clearInternalTransferVariable() {
    usernameController.clear();
    amountController.clear();
    amountIntoWords.value = '';
    remarkController.clear();
    tpinController.clear();
    isShowTpin.value = true;
    isValidUser.value = false;
    otpRefNumber.value = '';
    clearOtp.value = false;
    isResendButtonShow.value = false;
    validUserModel.value = ValidateUsernameModel();
  }
}

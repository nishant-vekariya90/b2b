import 'dart:async';
import 'package:intl/intl.dart';
import '../model/auth/login_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../model/auth/user_basic_details_model.dart';
import '../model/category_for_tpin_model.dart';
import '../model/operation_wise_model.dart';
import '../model/receipt_model.dart';
import '../routes/routes.dart';
import '../widgets/constant_widgets.dart';

// For Local
String domainUrl = 'https://newapi.webplat.in';
// Tharpay UAT
// String domainUrl = 'https://uatapi.tharpay.co.in';
// Tharpay Live
// String domainUrl = 'https://api.tharpay.co.in';
// We2Pay
// String domainUrl = 'https://api.we2pay.org';
// Pay99
// String domainUrl = 'https://api1.pay99.co.in';
// SlenPay
// String domainUrl = 'https://api.slenpay.in';
// AppanDukan
// String domainUrl = 'https://api.appandukan.com';
// GraamConnect
// String domainUrl = 'https://api.graamconnect.com';
// Pay5x
// String domainUrl = 'https://api.pay5x.com';
// Bankbox
// String domainUrl = 'https://api.bankbox.in';

String tenantId = '1';
String appName = 'B2B';
int channelID = 2;
String baseUrl = "$domainUrl/";

// Variables for DMTP
String dmtPAddress = 'Pune';
String dmtPPincode = '411041';
String dmtPDob = DateFormat('dd/MM/yyyy').format(DateTime.now().subtract(const Duration(days: 20 * 365)));

const platformMethodChannel = MethodChannel('intent_method_channel');
dynamic sdkInt;
String ipAddress = '192.168.0.123';
String latitude = '';
String longitude = '';
String os = '';
String device = '';
String deviceId = '';
String ownerName = '';
String flightDateFormat = 'dd-MM-yyyy';
String flightCurrency = 'INR';

List<CategoryForTpinModel> categoryForTpinList = <CategoryForTpinModel>[];
RxList<OperationWiseModel> settlementServiceList = <OperationWiseModel>[].obs;
ReceiptModel rechargeReceipt = ReceiptModel();
late PackageInfo packageInfo;
RxString apkLink = ''.obs;
RxString appIcon = ''.obs;
RxBool isTokenValid = false.obs;
RxBool isInternetAvailable = false.obs;
RxBool isGPSAvailable = false.obs;
RxBool isLocationAvailable = false.obs;
RxBool isShowAEPSWalletPassbook = false.obs;
RxBool isTransactionInit = false.obs;
RxBool isSettlementBankAccountVerify = false.obs;
RxBool isMiniApiOnBalanceEnquiry = false.obs;
List<String> biomatricDeviceList = ['MANTRA', 'MANTRA IRIS', 'MORPHO', 'STARTEK', 'SECUGEN'];

// Get storage keys
const isAppInstallKey = 'isAppInstall';
const loginTypeKey = 'loginType';
const businessTypeKey = 'loginType';
const loginDataKey = 'loginDataKey';
const userDataKey = 'userDataKey';
const mobileNumber = 'mobileNumber';
const isFromLoginPage = 'isFromLoginPage';
const isRememberMeKey = 'isRememberMe';
const rememberedEmailKey = 'rememberedEmail';
const rememberedPasswordKey = 'rememberedPassword';
const apiTimeOutMsg = 'Request timeout, please try again!';
const noInternetMsg = 'Please check your internet connection';

// Get stored login details
LoginModel getStoredLoginDetails() {
  LoginModel loginModel = LoginModel();
  var data = GetStorage().read(loginDataKey);
  if (data != null) {
    loginModel = LoginModel.fromJson(GetStorage().read(loginDataKey));
  }
  return loginModel;
}

// Get stored user basic details
UserBasicDetailsModel getStoredUserBasicDetails() {
  UserBasicDetailsModel userBasicDetailsModel = UserBasicDetailsModel();
  var data = GetStorage().read(userDataKey);
  if (data != null) {
    userBasicDetailsModel = UserBasicDetailsModel.fromJson(GetStorage().read(userDataKey));
  }
  return userBasicDetailsModel;
}

// Get stored user auth token
String getAuthToken() {
  LoginModel loginModel = getStoredLoginDetails();
  if (loginModel.accessToken != null && loginModel.accessToken!.isNotEmpty) {
    bool isTokenExpired = JwtDecoder.isExpired(loginModel.accessToken!);
    if (isTokenExpired == true) {
      isTokenValid.value = false;
      Timer(const Duration(seconds: 1), () {
        Get.offNamed(Routes.AUTH_SCREEN);
        errorSnackBar(message: 'Your session has expired!');
      });
      return '';
    } else {
      isTokenValid.value = true;
      return loginModel.accessToken!;
    }
  } else {
    isTokenValid.value = false;
    return '';
  }
}

String jsonApiData = '';

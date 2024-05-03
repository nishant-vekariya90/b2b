import 'dart:io';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../api/api_manager.dart';
import '../../../model/credopay/change_password_model.dart';
import '../../../model/credopay/credopay_transaction_model.dart';
import '../../../model/credopay/device_model.dart';
import '../../../model/credopay/documents_model.dart';
import '../../../model/credopay/kyc_documents_model.dart';
import '../../../model/credopay/merchant_category_model.dart';
import '../../../model/credopay/merchant_onboarding_model.dart';
import '../../../model/credopay/merchant_type_model.dart';
import '../../../model/credopay/pin_code_model.dart';
import '../../../model/credopay/submit_model.dart';
import '../../../model/credopay/terminal_onboarding_model.dart';
import '../../../model/credopay/terminal_type_model.dart';
import '../../../model/credopay/verify_account_model.dart';
import '../../../model/matm/matm_auth_detail_model.dart';
import '../../../repository/retailer/matm/credo_pay_repository.dart';
import '../../../utils/string_constants.dart';
import '../../../widgets/constant_widgets.dart';

class CredoPayController extends GetxController {
  CredoPayRepository credoPayRepository = CredoPayRepository(APIManager());

  //credo-pay transaction
  RxString selectedBiometricDevice = 'Select biometric device'.obs;
  RxString selectedPaymentGateway = ''.obs;
  RxString capturedFingerData = ''.obs;
  RxString refNumber = ''.obs;
  RxString pinCodeID = ''.obs;
  RxString ifscId = ''.obs;
  RxString referenceNumber = ''.obs;
  RxInt selectedServiceType = 0.obs;
  String newPasswordForCredo = '';
  String? mobileNum = GetStorage().read(mobileNumber);

  TextEditingController amountController = TextEditingController();
  RxString amountIntoWords = ''.obs;
  List<String> serviceTypeList = [
    'Balance Enquiry',
    'Mini Statements',
    'Purchase Product',
  ];
  Rx<File> document = File('').obs;
  RxInt activeStep = 0.obs;
  RxString selectedMerchantCategoryId = "".obs;
  RxString selectedMerchantTypeId = "".obs;
  RxString selectedDeviceModelId = "".obs;
  RxString selectedTerminalTypeId = "".obs;
  RxList<EasyStep> onBoardingDynamicStep = <EasyStep>[].obs;
  Rx<File> transactionSlipFile = File('').obs;
  TextEditingController terminalTypeController = TextEditingController();
  RxBool isPinCodeVerified = false.obs;
  RxBool isAccountVerified = false.obs;
  TextEditingController deviceModelController = TextEditingController();

  RxString selectedBusinessType = 'Select Business Type'.obs;
  RxList<String> businessTypeList = <String>[
    'individual',
    'proprietorship',
    'partnership',
    'private',
    'public',
    'trust',
    'pg'
  ].obs;

  //company
  TextEditingController deviceSerialNumberController = TextEditingController();
  TextEditingController firmNameTxtController = TextEditingController();
  TextEditingController firmMobileNoTxtController = TextEditingController();
  TextEditingController firmGSTINTxtController = TextEditingController();
  TextEditingController firmBusinessNatureTxtController =
  TextEditingController();
  TextEditingController firmEstablishedYearTxtController =
  TextEditingController();
  TextEditingController firmPanNumberTxtController = TextEditingController();
  TextEditingController merchantTypeTxtController = TextEditingController();
  TextEditingController merchantCategoryTxtController = TextEditingController();
  TextEditingController firmEmailTxtController = TextEditingController();
  TextEditingController firmAreaPinCodeTxtController = TextEditingController();
  TextEditingController firmStateTxtController = TextEditingController();
  TextEditingController firmCityTxtController = TextEditingController();
  TextEditingController firmAddressTxtController = TextEditingController();

  //personal
  TextEditingController firstNameTxtController = TextEditingController();
  TextEditingController lastNameTxtController = TextEditingController();
  TextEditingController nationalityTxtController = TextEditingController();
  TextEditingController dobTxtController = TextEditingController();
  TextEditingController addressDetailsTxtController = TextEditingController();
  TextEditingController ifscCodeTxtController = TextEditingController();
  TextEditingController bankNameTxtController = TextEditingController();
  TextEditingController branchNameTxtController = TextEditingController();
  TextEditingController accountNoTxtController = TextEditingController();

  RxList bankTypeList = ["saving", "current", "loan", "overdraft"].obs;
  RxString selectedBankType = 'Select bank type'.obs;

  RxList titleList = ["Mr", "Mrs"].obs;
  RxString selectedTitle = 'Select title'.obs;

  RxString selectedAccountTypeRadio = "".obs;
  RxString city = "".obs;
  RxString state = "".obs;


  String merchantStatus(int intStatus) {
    String status = '';
    if (intStatus == 0) {
      status = 'InProcess';
    } else if (intStatus == 1) {
      status = 'Pending';
    } else if (intStatus == 2) {
      status = 'Registered';
    } else if (intStatus == 3) {
      status = 'Updated';
    } else if (intStatus == 4) {
      status = 'Submitted';
    } else if (intStatus == 6) {
      status = 'Deactivated';
    } else if (intStatus == 7) {
      status = 'Approved';
    } else if (intStatus == 9) {
      status = 'Revision';
    } else if (intStatus == 11) {
      status = 'ReferBack';
    }
    return status;
  }

  String kycStatus(int intStatus) {
    String status = '';
    if (intStatus == 1) {
      status = 'Submitted';
    } else if (intStatus == 2) {
      status = 'Not Submitted';
    } else if (intStatus == 3) {
      status = 'Approved';
    } else if (intStatus == 4) {
      status = 'Rejected';
    } else if (intStatus == 5) {
      status = 'Revision';
    } else if (intStatus == 6) {
      status = 'Registered';
    } else if (intStatus == 7) {
      status = 'Accepted';
    } else if (intStatus == 8) {
      status = 'Pending';
    }
    return status;
  }

  // Get PinCode Details
  RxList<Docs> pinCodeDetailsList = <Docs>[].obs;

  Future<bool> getPinCodeDetails({bool isLoaderShow = true}) async {
    try {
      PinCodeModel pinCodeModel =
      await credoPayRepository.getPinCodeDetailsApiCall(
        pinCode: firmAreaPinCodeTxtController.value.text,
        isLoaderShow: isLoaderShow,
      );
      if (pinCodeModel.totalDocs! > 0) {
        for (Docs element in pinCodeModel.docs!) {
          pinCodeDetailsList.add(element);
          firmCityTxtController.text = element.city!;
          firmStateTxtController.text = element.state!;
          pinCodeID.value = element.id!;
        }
        return true;
      } else if (pinCodeModel.totalDocs == 0) {
        errorSnackBar(message: 'Pincode details not found');
        return false;
      } else {
        pinCodeDetailsList.clear();
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      errorSnackBar(message: e.toString());
      dismissProgressIndicator();
      return false;
    }
  }

  // Get Merchant Category
  RxList<CategoryListModel> merchantCategoryList = <CategoryListModel>[].obs;

  Future<bool> getMerchantCategories({bool isLoaderShow = true}) async {
    try {
      MerchantCategoryModel merchantCategoryModel =
      await credoPayRepository.getMerchantCategoryAPiCall(
        isLoaderShow: isLoaderShow,
      );
      if (merchantCategoryModel.totalDocs! > 0) {
        for (CategoryListModel element
        in merchantCategoryModel.merchantCategoryList!) {
          merchantCategoryList.add(element);
        }
        return true;
      } else {
        merchantCategoryList.clear();
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get Merchant Type
  RxList<MerchantTypeData> merchantTypeList = <MerchantTypeData>[].obs;

  Future<bool> getMerchantType({bool isLoaderShow = true}) async {
    try {
      MerchantTypeModel merchantTypeModel =
      await credoPayRepository.getMerchantTypeAPiCall(
        isLoaderShow: isLoaderShow,
      );
      if (merchantTypeModel.totalDocs! > 0) {
        for (MerchantTypeData element in merchantTypeModel.docs!) {
          merchantTypeList.add(element);
        }
        return true;
      } else {
        merchantTypeList.clear();
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  // Get Account Details
  RxList<AccountDetailsListModel> accountDetailsList =
      <AccountDetailsListModel>[].obs;

  Future<bool> verifyAccountDetailsApi({bool isLoaderShow = true}) async {
    try {
      VerifyAccountModel verifyAccountModel =
      await credoPayRepository.getAccountDetailsAPiCall(
        ifscCode: ifscCodeTxtController.text.toString(),
        bankName: bankNameTxtController.text.toString(),
        branch: branchNameTxtController.text.toString(),
        isLoaderShow: isLoaderShow,
      );
      if (verifyAccountModel.totalDocs! > 0) {
        for (AccountDetailsListModel element
        in verifyAccountModel.accountDetailsList!) {
          accountDetailsList.add(element);
          ifscCodeTxtController.text = element.ifsc.toString();
          ifscId.value = element.id.toString();
          bankNameTxtController.text = element.bank.toString();
          branchNameTxtController.text = element.branch.toString();
        }
        return true;
      } else {
        accountDetailsList.clear();
        errorSnackBar(message: 'Enter valid account details!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //Merchant Onboarding Api
  Rx<MerchantOnboardingModel> merchantOnboardingResponse =
      MerchantOnboardingModel().obs;

  Future<bool> merchantOnboardingAPI({bool isLoaderShow = true}) async {
    try {
      MerchantOnboardingModel onboardingModel = await credoPayRepository
          .merchantOnboardingApiCall(isLoaderShow: isLoaderShow, params: {
        "firmName": firmNameTxtController.text.trim().toString(),
        "firmAddress": firmAddressTxtController.text.trim().toString(),
        "firmPinCode": pinCodeID.value.trim().toString(),
        "firmState": firmStateTxtController.text.trim().toString(),
        "firmCity": firmCityTxtController.text.trim().toString(),
        "firmPanNo": firmPanNumberTxtController.text.trim().toString(),
        "firmGSTIN": firmGSTINTxtController.text.trim().toString(),
        "businessType": selectedBusinessType.value.trim().toString(),
        "establishedYear":
        firmEstablishedYearTxtController.text.trim().toString(),
        "businessNature":
        firmBusinessNatureTxtController.text.trim().toString(),
        "merchantCategoryCodeId":
        selectedMerchantCategoryId.value.trim().toString(),
        "merchantTypeId": selectedMerchantTypeId.value.trim().toString(),
        "contactMobile": firmMobileNoTxtController.text.trim().toString(),
        "contactEmail": firmEmailTxtController.text.trim().toString(),
        "title": selectedTitle.value.trim().toString(),
        "firstName": firstNameTxtController.text.trim().toString(),
        "lastName": lastNameTxtController.text.trim().toString(),
        "address": addressDetailsTxtController.text.trim().toString(),
        "pinCode": pinCodeID.value.trim().toString(),
        "nationality": nationalityTxtController.text.trim().toString(),
        "isOwnHouse": selectedAccountTypeRadio.value.trim().toString() == "No"
            ? false
            : true,
        "accountNumber": accountNoTxtController.text.trim().toString(),
        "ifscCode": ifscId.value.trim().toString(),
        "accountType": selectedBankType.value.trim().toString(),
        "registeredNumber": selectedBusinessType.value == "proprietorship"
            ? firmGSTINTxtController.text.trim().toString()
            : "",
        "dob": dobTxtController.text.trim().toString(),
        "channel": channelID,
        "userId": 0,
        "userName": "",
        "ipAddress": ipAddress
      });
      if (onboardingModel.statusCode == 1) {
        refNumber.value = onboardingModel.refNumber.toString();
        successSnackBar(message: onboardingModel.message);
        return true;
      } else {
        errorSnackBar(message: onboardingModel.message!);
        return false;
      }
    } catch (e) {
      errorSnackBar(message: e.toString());
      dismissProgressIndicator();
      return false;
    }
  }

  // Get Terminal Type
  RxList<TerminalTypeListModel> terminalTypeList =
      <TerminalTypeListModel>[].obs;
  RxList<Terminals> terminalList = <Terminals>[].obs;

  Future<bool> getTerminalType({bool isLoaderShow = true}) async {
    try {
      TerminalTypeModel terminalTypeModel =
      await credoPayRepository.getTerminalTypeApiCall(
        merchantType: merchantTypeTxtController.text.trim().toString(),
        isLoaderShow: isLoaderShow,
      );
      if (terminalTypeModel.totalDocs! > 0) {
        for (TerminalTypeListModel element
        in terminalTypeModel.terminalTypeList!) {
          terminalTypeList.add(element);
        }
        return true;
      } else if (terminalTypeModel.totalDocs == 0) {
        errorSnackBar(message: 'No data found');
        return false;
      } else {
        pinCodeDetailsList.clear();
        errorSnackBar(message: 'Something went wrong!');
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      errorSnackBar(message: e.toString());
      return false;
    }
  }

  // Get Device Model
  RxList<DeviceListModel> deviceModelList = <DeviceListModel>[].obs;

  Future<bool> getDeviceModelApi({bool isLoaderShow = true}) async {
    try {
      DeviceModel deviceModel = await credoPayRepository.getDeviceModelAPiCall(
        isLoaderShow: isLoaderShow,
      );
      if (deviceModel.totalDocs! > 0) {
        for (DeviceListModel element in deviceModel.deviceModelList!) {
          deviceModelList.add(element);
        }
        return true;
      } else {
        deviceModelList.clear();
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      errorSnackBar(message: e.toString());
      return false;
    }
  }

  //Terminal Onboarding Api
  Rx<TerminalOnboardingModel> terminalOnboardingResponse =
      TerminalOnboardingModel().obs;

  Future<bool> terminalOnboardingAPI({bool isLoaderShow = true}) async {
    try {
      TerminalOnboardingModel onboardingModel = await credoPayRepository
          .terminalOnboardingApiCall(isLoaderShow: isLoaderShow, params: {
        "channel": 1,
        "mobileNumber": mobileNum,
        "merchantId": referenceNumber.value.trim().toString(),
        "location": "",
        "address": addressDetailsTxtController.text.trim().toString(),
        "pincode": "",
        "simNumber": deviceSerialNumberController.text.trim().toString(),
        "terminalType": selectedTerminalTypeId.value.trim().toString(),
        "deviceModel": selectedDeviceModelId.value.trim().toString(),
        "userId": 1,
        "userName": "",
        "ipAddress": ipAddress
      });
      if (onboardingModel.statusCode == 1) {
        successSnackBar(message: onboardingModel.message);
        return true;
      } else {
        errorSnackBar(message: onboardingModel.message!);
        return false;
      }
    } catch (e) {
      errorSnackBar(message: e.toString());
      dismissProgressIndicator();
      return false;
    }
  }

  RxList<dynamic> kycDocumentsList = <dynamic>[].obs;
  List finalDocsStepObjList = [];

  Future<bool> getKycDocuments(
      {bool isLoaderShow = true, required String businessType}) async {
    try {
      kycDocumentsList.clear();
      KycDocumentsModel kycDocumentsModel =
      await credoPayRepository.getKycDocumentsApiCall(
        isLoaderShow: isLoaderShow,
      );
      switch (businessType) {
        case "individual":
        /*IndividualData element =IndividualData(type:4,name: 'Aadhaar back',required: true,file: File('').obs);
          kycDocumentsList.add(element);*/

          for (IndividualData element in kycDocumentsModel.individual!) {
            if(element.name!.contains('PAN Card')||element.name!.contains('Aadhaar')||element.name!.contains('Cancelled Cheque')||element.name!.contains('Passbook')||element.name!.contains('Bank Statement')){
              element.required=true;
              kycDocumentsList.add(element);
            }else if(element.name!.contains('VOTER_ID')||element.name!.contains('DRIVING_LICENCE')){
              element.required=false;
              kycDocumentsList.add(element);
            }
          }
          break;
        case "proprietorship":
        /* IndividualData element =IndividualData(type:4,name: 'Aadhaar back',required: true,file: File('').obs);
          kycDocumentsList.add(element);*/
          for (ProprietorshipData element
          in kycDocumentsModel.proprietorship!) {
            if(element.name!.contains('PAN Card')||element.name!.contains('GST Registration Certificate')||element.name!.contains('Aadhaar')||element.name!.contains('Passport')||element.name!.contains('Rationcard')||element.name!.contains('Voters ID')||element.name!.contains('Cancelled Cheque')){
              element.required=true;
              kycDocumentsList.add(element);
            }else if(element.name!.contains('Aggregator and Merchant Agreement')){
              element.required=false;
              kycDocumentsList.add(element);
            }
          }
          break;
        case "partnership":
        /*IndividualData element =IndividualData(type:4,name: 'Aadhaar back',required: true,file: File('').obs);
          kycDocumentsList.add(element);*/
          for (PartnershipData element in kycDocumentsModel.partnership!) {
            if(element.name!.contains('Partnership Deed (with registration certificate, if the deed is registered)')||element.name!.contains('PAN Card in the name of the Firm and Partners')||element.name!.contains('Aadhaar')||element.name!.contains('Passport')||element.name!.contains('Rationcard')||element.name!.contains('Voters ID')||element.name!.contains('Cancelled Cheque')){
              element.required=true;
              kycDocumentsList.add(element);
            }else if(element.name!.contains('Aggregator and Merchant Agreement')){
              element.required=false;
              kycDocumentsList.add(element);
            }
          }
          break;
        case "private":
        /*IndividualData element =IndividualData(type:4,name: 'Aadhaar back',required: true,file: File('').obs);
          kycDocumentsList.add(element);*/
          for (PrivateData element in kycDocumentsModel.private!) {
            if(element.name!.contains('Certified True Copy of Certificate of Incorporation')||element.name!.contains('Board Resolution and List of Directors')||element.name!.contains('Aadhaar')||element.name!.contains('Passport')||element.name!.contains('Rationcard')||element.name!.contains('Voters ID of directors')||element.name!.contains('Cancelled Cheque')){
              element.required=true;
              kycDocumentsList.add(element);
            }else if(element.name!.contains('GST Registration Certificate')||element.name!.contains('Aggregator and Merchant Agreement')||element.name!.contains('PAN Card of Directors and Firm')){
              element.required=false;
              kycDocumentsList.add(element);
            }
          }
          break;
        case "public":
        /*IndividualData element =IndividualData(type:4,name: 'Aadhaar back',required: true,file: File('').obs);
          kycDocumentsList.add(element);*/
          for (PublicData element in kycDocumentsModel.public!) {
            if(element.name!.contains('Certified True Copy of Certificate of Incorporation')||element.name!.contains('Certified True Copy of Memorandum & Article of Association')||element.name!.contains('Board Resolution and List of Directors')||element.name!.contains('Aadhaar')||element.name!.contains('Passport')||element.name!.contains('Rationcard')||element.name!.contains('Voters ID of directors')||element.name!.contains('Cancelled Cheque')){
              element.required=true;
              kycDocumentsList.add(element);
            }else if(element.name!.contains('GST Registration Certificate')||element.name!.contains('Aggregator and Merchant Agreement')||element.name!.contains('PAN Card of Directors and Firm')){
              element.required=false;
              kycDocumentsList.add(element);
            }
          }
          break;
        case "trust":
        /*IndividualData element =IndividualData(type:4,name: 'Aadhaar back',required: true,file: File('').obs);
          kycDocumentsList.add(element);*/
          for (TrustData element in kycDocumentsModel.trust!) {
            if(element.name!.contains('Certified True Copy of Trust Deed')||element.name!.contains('Managing Trustee ID and Address Proof')||element.name!.contains('Address Proof of Premises (Electricity Bill, Telephone Bill)')||element.name!.contains('Cancelled Cheque')){
              element.required=true;
              kycDocumentsList.add(element);
            }else if(element.name!.contains('PAN Card for Trustees')||element.name!.contains('Aggregator and Merchant Agreement')){
              element.required=false;
              kycDocumentsList.add(element);
            }
          }
          break;
        default:
          break;
      }
      return true;
    } catch (e) {
      kycDocumentsList.clear();
      dismissProgressIndicator();
      return false;
    }
  }

  //upload document api
  Future<bool> uploadDocumentsApi(
      {bool isLoaderShow = true, required String refNumber}) async {
    try {
      DocumentsModel documentsModel =
      await credoPayRepository.documentUploadApiCall(
          isLoaderShow: isLoaderShow,
          params: finalDocsStepObjList,
          refNumber: refNumber);

      if (documentsModel.statusCode == 1) {
        referenceNumber.value = documentsModel.refNumber!;
        successSnackBar(message: documentsModel.message);
        printLogsInChunks('finalDocList -----> ${finalDocsStepObjList.toString()}');
        return true;
      } else {
        errorSnackBar(message: documentsModel.message);
        printLogsInChunks('finalDocList -----> ${finalDocsStepObjList.toString()}');
        return false;
      }
    } catch (e) {
      errorSnackBar(message: e.toString());
      dismissProgressIndicator();
      return false;
    }
  }

  void printLogsInChunks(String logs) {
    const chunkSize = 400; // Set the desired chunk size

    for (int i = 0; i < logs.length; i += chunkSize) {
      int end = i + chunkSize;
      if (end > logs.length) {
        end = logs.length;
      }
    }
  }
  //Merchant Onboarding Api
  Rx<SubmitModel> submitApiResponse = SubmitModel().obs;

  Future<bool> submitAPI({bool isLoaderShow = true}) async {
    try {
      SubmitModel submitModel = await credoPayRepository
          .submitApiCall(isLoaderShow: isLoaderShow, params: {
        "channel": 1,
        "mobileNumber": mobileNum,
        "userId": 0,
        "userName": "",
        "ipAddress": ipAddress
      });
      if (submitModel.statusCode == 1) {
        successSnackBar(message: submitModel.message);
        return true;
      } else {
        errorSnackBar(message: submitModel.message!);
        return false;
      }
    } catch (e) {
      errorSnackBar(message: e.toString());
      dismissProgressIndicator();
      return false;
    }
  }

  //Credo-pay Transaction Api
  Rx<CredoPayTransactionModel> credoPayTransactionResponse =
      CredoPayTransactionModel().obs;
  String txnType = '';
  String amount = '';
  String credoTxnOrderId = '';

  Future<bool> credoPayTransactionAPI(
      {bool isLoaderShow = true,
        required String simNumber,
        required String amount}) async {
    if (selectedServiceType.value == 0) {
      txnType = 'CW';
    } else if (selectedServiceType.value == 1) {
      txnType = 'BE';
      amount = '0';
    } else if (selectedServiceType.value == 2) {
      txnType = 'PU';
    }
    try {
      CredoPayTransactionModel onboardModel = await credoPayRepository
          .transactionApiCall(isLoaderShow: isLoaderShow, params: {
        "channel": 1,
        "transactionType": txnType,
        "amount": amount,
        "simNumber": simNumber,
        "orderId": 'App${DateTime.now().millisecondsSinceEpoch.toString()}',
        "tpin": '',
        "userId": 0,
        "userName": "",
        "ipAddress": "",
        "latitude": "",
        "longitude": ""
      });
      if (onboardModel.statusCode == 1) {
        credoTxnOrderId = onboardModel.orderId!;
        successSnackBar(message: onboardModel.message);
        return true;
      } else {
        errorSnackBar(message: onboardModel.message!);
        return false;
      }
    } catch (e) {
      errorSnackBar(message: e.toString());
      dismissProgressIndicator();
      return false;
    }
  }

  Future<bool> changePasswordApi({bool isLoaderShow = true,required String contactMobile,required String loginID,required String password}) async {
    try {
      ChangePasswordModel changePasswordModel = await credoPayRepository.changePasswordApiCall(isLoaderShow: isLoaderShow,contactMobile: contactMobile,loginID: loginID,password: password);

      if (changePasswordModel.statusCode == 1) {
        successSnackBar(message: changePasswordModel.message);
        return true;
      } else {
        errorSnackBar(message: changePasswordModel.message);
        return false;
      }
    } catch (e) {
      errorSnackBar(message: e.toString());
      dismissProgressIndicator();
      return false;
    }
  }
}

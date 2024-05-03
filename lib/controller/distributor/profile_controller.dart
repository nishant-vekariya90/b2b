import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_manager.dart';
import '../../model/create_profile/create_profile_model.dart';
import '../../model/create_profile/profile_information_model.dart';
import '../../model/create_profile/update_profile_model.dart';
import '../../model/success_model.dart';
import '../../repository/distributor/profile_repository.dart';
import '../../utils/string_constants.dart';
import '../../widgets/constant_widgets.dart';

class ProfileController extends GetxController {
  ProfileRepository profileRepository = ProfileRepository(APIManager());

  //for create profile
  TextEditingController userTypeTxtController = TextEditingController();
  TextEditingController profileNameTxtController = TextEditingController();
  TextEditingController codeTxtController = TextEditingController();

  //for update profile
  TextEditingController userTypeUpdateTxtController = TextEditingController();
  TextEditingController profileNameUpdateTxtController = TextEditingController();
  TextEditingController codeUpdateTxtController = TextEditingController();

  RxString selectedUserType = ''.obs;
  RxString selectedUserTypeId = ''.obs; //for create profile
  RxString selectedUserTypeIdUpdate = ''.obs; //for update profile
  RxList<Profile> profilesList = <Profile>[].obs;
  RxList<Profile> activeProfilesList = <Profile>[].obs;

  //Create Profile API
  Future<bool> createProfile({bool isLoaderShow = true}) async {
    try {
      CreateProfileModel createProfileModel = await profileRepository.createProfileApiCall(
        params: {
          'name': profileNameTxtController.text,
          'userTypeID': int.parse(selectedUserTypeId.value),
          'code': codeTxtController.text,
          'isSignupProfile': false,
          'channels': channelID,
        },
        isLoaderShow: isLoaderShow,
      );
      if (createProfileModel.statusCode == 1) {
        Get.back();
        successSnackBar(message: createProfileModel.message);
        await profileInformation();
        return true;
      } else {
        errorSnackBar(message: createProfileModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //All profile information API
  Future<bool> profileInformation({bool isLoaderShow = true}) async {
    try {
      ProfileInformationModel profileInformationModel = await profileRepository.profileInformationApiCall(
        isLoaderShow: isLoaderShow,
        selectedUserTypeId: selectedUserTypeId.value,
      );
      if (profileInformationModel.status == 1) {
        profilesList.clear();
        activeProfilesList.clear();
        for (Profile element in profileInformationModel.profile!) {
          if (element.status == 1) {
            activeProfilesList.add(element);
          }
          profilesList.add(element);
        }
        return true;
      } else if (profileInformationModel.status == 0) {
        profilesList.clear();
        activeProfilesList.clear();
        return false;
      } else {
        // errorSnackBar(message: profileInformationModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //Update information API
  Future<bool> updateProfile({bool isLoaderShow = true, required int id, required int userTypeId}) async {
    try {
      UpdateProfileModel updateProfileModel = await profileRepository.updateProfileApiCall(
        params: {
          'name': profileNameUpdateTxtController.text,
          'userTypeID': selectedUserTypeIdUpdate.value.isEmpty ? userTypeId : selectedUserTypeIdUpdate.value,
          'code': codeUpdateTxtController.text,
          'isSignupProfile': false,
          'channels': channelID
        },
        isLoaderShow: isLoaderShow,
        id: id,
      );
      if (updateProfileModel.statusCode == 1) {
        Get.back();
        successSnackBar(message: updateProfileModel.message);
        await profileInformation();
        return true;
      } else {
        errorSnackBar(message: updateProfileModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }

  //Update status API
  Future<bool> updateStatus({bool isLoaderShow = true, required int status, required int id}) async {
    try {
      SuccessModel successModel = await profileRepository.updateStatusApiCall(
        params: {'status': status == 1 ? 0 : 1},
        isLoaderShow: isLoaderShow,
        id: id,
      );
      if (successModel.statusCode == 1) {
        Get.back();
        successSnackBar(message: successModel.message);
        await profileInformation();
        return true;
      } else {
        errorSnackBar(message: successModel.message);
        return false;
      }
    } catch (e) {
      dismissProgressIndicator();
      return false;
    }
  }
}

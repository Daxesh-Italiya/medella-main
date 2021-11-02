import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:medella/family_details.dart';
import 'package:medella/helper/toast.dart';
import 'package:medella/models/getoneFamily_model.dart';
import 'package:medella/models/service/add_familiy_member_service.dart';

import '../get_family_model.dart';

class AddMemberFamilyController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isAddMemberLoading = false.obs;
  RxBool MemberLoading = false.obs;
  Rx<GetAllFamily> getAllFamilyModel = GetAllFamily().obs;
  Rx<GetOneFamily> getOneFamilyModel = GetOneFamily().obs;

  Future<GetAllFamily?>? getAllFamily() async {
    try {
      isLoading.value = true;
      final result = await AuthenticationService.getAllFamily();
      if (result != null) {
        isLoading.value = false;
        getAllFamilyModel.value = GetAllFamily.fromJson(result);
        print("result   --  >  ${getAllFamilyModel.value}");
        return getAllFamilyModel.value;
      }
    } catch (e) {
      print("e --->$e");
      isLoading.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<GetOneFamily?>? getOneFamily(int id) async {
    try {
      MemberLoading.value = true;
      final result = await AuthenticationService.getOneFamily(id);
      if (result != null) {
        getOneFamilyModel.value = GetOneFamily.fromJson(result);
        print("result   --  >  ${getAllFamilyModel.value}");

        Get.to(() => FamilyDetail())!.then((value) {
          getAllFamily();
        });
        MemberLoading.value = false;
        return getOneFamilyModel.value;
      }
    } catch (e) {
      print("e --->$e");
      MemberLoading.value = false;
      rethrow;
    } finally {
      MemberLoading.value = false;
    }
  }

  Future addMember({
    required String userName,
    required String dob,
    required String socialSecurity,
    String? moNumber,
    File? userImage,
    File? userConsent,
    File? userId,
  }) async {
    try {
      isAddMemberLoading.value = true;
      final result = await AuthenticationService.addMember(
          moNumber: moNumber,
          userImage: userImage,
          userConsent: userConsent,
          userId: userId,
          userName: userName,
          dob: dob,
          socialSecurity: socialSecurity);
      if (result != null) {
        log("result---->$result");
        getAllFamily();
        AppToast.toastMessage('add member successfully');
        isAddMemberLoading.value = false;
      } else {
        AppToast.toastMessage(result['status']);
      }
    } catch (e) {
      print("e --->$e");
      isAddMemberLoading.value = false;
      rethrow;
    } finally {
      isAddMemberLoading.value = false;
    }
  }

  @override
  void onInit() {
    getAllFamily();
    // TODO: implement onInit
    super.onInit();
  }
}

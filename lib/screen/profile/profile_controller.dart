import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final IProfileRepository profileRepository;
  final AccountService accountService;

  ProfileController({required this.profileRepository, required this.accountService});

  var account = Account().obs;
  final ValueNotifier<bool> isEditAccountVisible = ValueNotifier<bool>(false);
  final ImagePicker imagePicker = ImagePicker();

  late TextEditingController nameController;
  var selectedGender = ''.obs;

  var isLoadingupdate = false.obs;

  void handleClick(String gender) {
    account.update((val) {
      val!.gender = gender;
    });
    selectedGender.value = gender;
  }

  @override
  void onInit() {
    getProfile();
    nameController = TextEditingController();
    ever(account, (_) {
      nameController.text = account.value.name ?? '';
      selectedGender.value = account.value.gender ?? '';
    });
    super.onInit();
  }

  Future<void> signOut() async {
    try {
      await profileRepository.signOut();
    } on AuthException catch (error) {
      print(error.message);
    } catch (error) {
      print(error);
    } finally {
      Get.offAllNamed(Routes.SIGNIN);
    }
  }

  void getProfile() async {
    Account? data = await profileRepository.getProfile();
    if (data != null) {
      account.value = data;
    }
  }

  void updateProfile() async {
    try {
      isLoadingupdate(true);

      await profileRepository.updateProfile(nameController.text, selectedGender.value);
      getProfile();

      isLoadingupdate(false);
    } catch (error) {
      print(error);
    } finally {
      isLoadingupdate(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    isEditAccountVisible.dispose();
    nameController.dispose();
  }
}

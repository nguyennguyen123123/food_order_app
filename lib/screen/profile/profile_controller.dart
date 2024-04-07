import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/routes/pages.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final IProfileRepository profileRepository;
  final AccountService accountService;

  ProfileController({required this.profileRepository, required this.accountService});

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  var account = Account().obs;

  Future<void> signOut() async {
    try {
      profileRepository.signOut();
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
}

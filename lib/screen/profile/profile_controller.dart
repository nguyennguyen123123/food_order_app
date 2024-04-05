import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final IProfileRepository profileRepository;
  final AccountService accountService;

  ProfileController({required this.profileRepository, required this.accountService});
}

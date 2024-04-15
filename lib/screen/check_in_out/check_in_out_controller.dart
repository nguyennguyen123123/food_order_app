import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/models/check_in_out.dart';
import 'package:food_delivery_app/resourese/check_in_out/icheck_in_out_repository.dart';
import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:get/get.dart';

class CheckInOutController extends GetxController {
  final ICheckInOutRepository checkInOutRepository;
  final IProfileRepository profileRepository;
  final AccountService accountService;

  CheckInOutController(
      {required this.checkInOutRepository, required this.profileRepository, required this.accountService});

  var isLoadingCheckIn = false.obs;
  var isLoadingCheckOut = false.obs;

  var listCheckInOut = <CheckInOut>[].obs;

  Account? get myAccount => accountService.myAccount;

  @override
  void onInit() {
    super.onInit();
    getListCheckInOut();
  }

  Future<void> getListCheckInOut() async {
    final result = await checkInOutRepository.getListCheckInOut();

    if (result != null) {
      listCheckInOut.assignAll(result);
    } else {
      listCheckInOut.clear();
    }
  }

  Future<void> checkInUser() async {
    try {
      isLoadingCheckIn(true);

      final result = await checkInOutRepository.checkInUser();

      if (result != null) {
        final data = await profileRepository.getProfile();
        if (data != null) {
          accountService.account.value = data;
        }

        DialogUtils.showSuccessDialog(content: "Check In thành công".tr);
      }

      isLoadingCheckIn(false);
    } catch (error) {
      print(error);
      DialogUtils.showInfoErrorDialog(content: "Check In thất bại".tr);
    } finally {
      isLoadingCheckIn(false);
    }
  }

  Future<void> checkOutUser() async {
    try {
      isLoadingCheckOut(true);

      final result = await checkInOutRepository.checkOutUser();

      if (result != null) {
        final data = await profileRepository.getProfile();
        if (data != null) {
          accountService.account.value = data;
        }

        DialogUtils.showSuccessDialog(content: "Check Out thành công".tr);
      }

      isLoadingCheckOut(false);
    } catch (error) {
      print(error);
      DialogUtils.showInfoErrorDialog(content: "Check Out thất bại".tr);
    } finally {
      isLoadingCheckOut(false);
    }
  }
}

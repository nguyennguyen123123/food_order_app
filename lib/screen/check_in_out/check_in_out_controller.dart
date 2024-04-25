import 'package:food_delivery_app/constant/app_constant_key.dart';
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

  Account? get account => accountService.myAccount;

  CheckInOutController(
      {required this.checkInOutRepository, required this.profileRepository, required this.accountService});

  var isLoadingCheckIn = false.obs;
  var isLoadingCheckOut = false.obs;

  var listCheckInOut = Rx<List<CheckInOut>?>([]);

  int page = 0;
  int limit = LIMIT;

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  Future<void> onRefresh() async {
    page = 0;
    listCheckInOut.value = null;

    final result =
        await checkInOutRepository.getListCheckInOut(account?.role == USER_ROLE.ADMIN, page: page, limit: limit);

    listCheckInOut.value = result;
  }

  Future<bool> onLoadMoreCheckInOut() async {
    final user = await profileRepository.getProfile();

    final length = (listCheckInOut.value ?? []).length;
    if (length < LIMIT * (page + 1)) return false;
    page += 1;

    final result =
        await checkInOutRepository.getListCheckInOut(user?.role == USER_ROLE.ADMIN, page: page, limit: limit);

    listCheckInOut.update((val) => val?.addAll(result));
    if (result.length < limit) return false;
    return true;
  }

  Future<void> checkInUser() async {
    try {
      isLoadingCheckIn(true);

      final result = await checkInOutRepository.checkInUser();

      if (result != null) {
        accountService.account.value = result;

        DialogUtils.showSuccessDialog(content: "check_in_successful".tr);
      }

      isLoadingCheckIn(false);
    } catch (error) {
      print(error);
      DialogUtils.showInfoErrorDialog(content: "check_in_failed".tr);
    } finally {
      isLoadingCheckIn(false);
    }
  }

  Future<void> checkOutUser() async {
    try {
      isLoadingCheckOut(true);

      final result = await checkInOutRepository.checkOutUser();

      if (result != null) {
        accountService.account.value = result;
        onRefresh();

        DialogUtils.showSuccessDialog(content: "check_out_successful".tr);
      }

      isLoadingCheckOut(false);
    } catch (error) {
      print(error);
      DialogUtils.showInfoErrorDialog(content: "check_out_failed".tr);
    } finally {
      isLoadingCheckOut(false);
    }
  }
}

import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/models/check_in_out.dart';
import 'package:food_delivery_app/resourese/check_in_out/icheck_in_out_repository.dart';
import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:get/get.dart';

class CheckInOutController extends GetxController {
  final ICheckInOutRepository checkInOutRepository;
  final IProfileRepository profileRepository;

  CheckInOutController({required this.checkInOutRepository, required this.profileRepository});

  var isLoadingCheckIn = false.obs;
  var isLoadingCheckOut = false.obs;

  var listCheckInOut = <CheckInOut>[].obs;
  var account = Account().obs;

  @override
  void onInit() {
    super.onInit();
    getProfile();
    getListCheckInOut();
  }

  void getProfile() async {
    Account? data = await profileRepository.getProfile();
    if (data != null) {
      account.value = data;
    }
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
        getProfile();

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
        getProfile();

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

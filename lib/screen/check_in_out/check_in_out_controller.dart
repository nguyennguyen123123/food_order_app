import 'package:flutter/material.dart';
import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/models/check_in_out.dart';
import 'package:food_delivery_app/resourese/check_in_out/icheck_in_out_repository.dart';
import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/utils/dialog_util.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';

class CheckInOutController extends GetxController with GetSingleTickerProviderStateMixin {
  final ICheckInOutRepository checkInOutRepository;
  final IProfileRepository profileRepository;
  final AccountService accountService;

  Account? get account => accountService.myAccount;

  CheckInOutController(
      {required this.checkInOutRepository, required this.profileRepository, required this.accountService});

  var isLoadingCheckIn = false.obs;
  var isLoadingCheckOut = false.obs;

  var listCheckInOut = Rx<List<CheckInOut>?>([]);

  final selectedCheckinCheckout = Rx<List<int>>([]);
  final currentTab = Rx<int>(0);
  final tab = [Tab(text: 'view'.tr), Tab(text: 'edit'.tr)];
  late final tabCtr = TabController(length: 2, vsync: this);

  int page = 0;
  int limit = LIMIT;

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  @override
  void onClose() {
    selectedCheckinCheckout.close();
    currentTab.close();
    tabCtr.dispose();
    super.onClose();
  }

  void onChangeTab(int tab) {
    currentTab.value = tab;
    selectedCheckinCheckout.value = [];
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

  void onUpdateCurrentOrderSelect(bool isSelect, int id) {
    if (isSelect) {
      selectedCheckinCheckout.update((val) => val?.add(id));
    } else {
      selectedCheckinCheckout.update((val) => val?.remove(id));
    }
    selectedCheckinCheckout.refresh();
  }

  Future<void> onDeleteOrder() async {
    if (currentTab.value == 0) {
      excute(() async {
        final result = await checkInOutRepository.onDeleteAll();
        if (result) {
          listCheckInOut.value = [];
        }
      });
    } else {
      if (selectedCheckinCheckout.value.isEmpty) return;
      excute(() async {
        final result = await checkInOutRepository.onDeleteCheckinOut(selectedCheckinCheckout.value);
        if (result) {
          final list = [...listCheckInOut.value!];
          list.removeWhere((element) => selectedCheckinCheckout.value.contains(element.id));
          listCheckInOut.value = list;
        }
      });
    }
  }
}

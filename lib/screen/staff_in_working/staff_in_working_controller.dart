import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/models/summarize_order.dart';
import 'package:food_delivery_app/resourese/auth_repository/iauth_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/resourese/summarize/isummarize_repository.dart';
import 'package:get/get.dart';

class StaffInWorkingController extends GetxController {
  final ISummarizeRepository summarizeRepository;
  final IAuthRepository authRepository;
  final AccountService accountService;

  final summarizeOrder = Rx<SummarizeOrder?>(null);
  final accountList = Rx<List<Account>?>(null);
  int page = 0;
  int limit = 50;

  StaffInWorkingController({
    required this.accountService,
    required this.authRepository,
    required this.summarizeRepository,
  });

  @override
  void onClose() {
    summarizeOrder.close();
    accountList.close();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  Future<void> onRefresh() async {
    page = 0;
    accountList.value = null;
    summarizeOrder.value = null;
    accountList.value = await authRepository.getListAccountInWorking(page: page, limit: limit);
    summarizeOrder.value = await summarizeRepository.getTodaySummarize();
  }
}

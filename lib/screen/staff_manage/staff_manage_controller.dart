import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/auth_repository/iauth_repository.dart';
import 'package:get/get.dart';

class StaffManageController extends GetxController {
  final IAuthRepository authRepository;

  StaffManageController({required this.authRepository});

  final accounts = Rx<List<Account>?>([]);
  int page = 0;
  int limit = LIMIT;

  @override
  void onInit() {
    onRefresh();
    super.onInit();
  }

  Future<void> onRefresh() async {
    accounts.value = await authRepository.getListAccount(page: page, limit: LIMIT);
    print(accounts.value);
  }

  Future<void> onAddAccount(Account account) async {
    final id = await authRepository.createAuthentication(account.email ?? '', account.name ?? '');
    if (id != null) {
      account.userId = id;
      final result = await authRepository.addAccount(account);
      if (result != null) {
        accounts.update((val) => val?.insert(0, result));
      }
    }
  }
}

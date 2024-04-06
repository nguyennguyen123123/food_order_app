import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/auth_repository/iauth_repository.dart';
import 'package:food_delivery_app/widgets/loading.dart';
import 'package:get/get.dart';
import 'package:mock_data/mock_data.dart';

class StaffManageController extends GetxController {
  final IAuthRepository authRepository;

  StaffManageController({required this.authRepository});

  final accounts = Rx<List<Account>?>([]);
  int page = 0;
  int limit = 30;

  @override
  void onInit() {
    onRefresh();
    super.onInit();
  }

  Future<void> onRefresh() async {
    page = 0;
    accounts.value = null;
    accounts.value = await authRepository.getListAccount(page: page, limit: limit);
  }

  Future<bool> onLoadMore() async {
    final length = (accounts.value ?? []).length;
    if (length < (page + 1) * limit) return false;
    page += 1;
    final result = await authRepository.getListAccount(page: page, limit: limit);
    accounts.update((val) => val?.addAll(result));
    if (result.length < limit) {
      return false;
    }

    return true;
  }

  Future<void> onAddRandomAccount() async {
    excute(() async {
      await Future.wait(List.generate(30, (index) async {
        final account = Account(
          name: mockName(),
          email: mockName().replaceAll(" ", "") + '@gmail.com',
          role: USER_ROLE.STAFF,
          gender: GENDER.MAN,
        );
        await onAddAccount(account);
      }));
    });
  }

  Future<void> onAddAccount(Account account) async {
    excute(() async {
      final id = await authRepository.createAuthentication(account.email ?? '', account.name ?? '');
      if (id != null) {
        account.userId = id;
        final result = await authRepository.addAccount(account);
        if (result != null) {
          accounts.update((val) => val?.insert(0, result));
        }
      }
    });
  }

  Future<void> onRemoveAccount(int index, Account account) async {
    excute(() async {
      final result = await authRepository.deleteAccount(account.userId ?? '');
      if (result == true) {
        accounts.update((val) => val?.removeAt(index));
      }
    });
  }

  Future<void> updateAccount(int index, Account account) async {
    excute(() async {
      final result = await authRepository.updateAccount(account);
      if (result != null) {
        accounts.update((val) => val?[index] = result);
      }
    });
  }
}

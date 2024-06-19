import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/auth_repository/iauth_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository extends IAuthRepository {
  final BaseService baseService;
  final AccountService accountService;

  AuthRepository({
    required this.baseService,
    required this.accountService,
  });

  @override
  Future<User?> login(String email, String password) async {
    try {
      final response = await baseService.client.auth.signInWithPassword(email: email, password: password);
      return response.user;
    } catch (e) {
      handleError(e);

      return null;
    }
  }

  @override
  Future<Account?> getAccountById(String userId) async {
    try {
      final response = await baseService.client
          .from(TABLE_NAME.ACCOUNT)
          .select()
          .eq("user_id", userId)
          .withConverter((data) => data.map((e) => Account.fromJson(e)).toList());
      return response.first;
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  @override
  Future<Account?> addAccount(Account account) async {
    try {
      final map = {
        'name': account.name,
        'role': account.role,
        'gender': account.gender,
        'email': account.email,
        'user_id': account.userId,
      };
      final response = await baseService.client
          .from(TABLE_NAME.ACCOUNT)
          .insert(map)
          .select()
          .withConverter((data) => data.map((e) => Account.fromJson(e)).toList());
      return response.first;
    } catch (e) {
      handleError(e);

      return null;
    }
  }

  @override
  Future<String?> createAuthentication(String email, String name, String password) async {
    try {
      final response = await baseService.client.functions.invoke("create_user", body: {
        "email": email,
        "name": name,
        "password": password.isEmpty ? '123456' : password,
      });
      return response.data['id'];
    } catch (e) {
      handleError(e);

      return null;
    }
  }

  @override
  Future<List<Account>> getListAccount({int limit = LIMIT, int page = 0}) async {
    try {
      final response = await baseService.client
          .from(TABLE_NAME.ACCOUNT)
          .select()
          .filter("user_id", "neq", accountService.myAccount?.userId ?? '')
          .limit(limit)
          .range(page * limit + page, (page + 1) * limit + page)
          .withConverter((data) => data.map((e) => Account.fromJson(e)).toList());
      return response;
    } catch (e) {
      handleError(e);

      return [];
    }
  }

  @override
  Future<bool> deleteAccount(String userId) async {
    try {
      final result = await baseService.client.functions.invoke("delete_user", body: {'user_id': userId});
      if (result.data['result'] == true) {
        await baseService.client.from(TABLE_NAME.ACCOUNT).delete().eq("user_id", userId);
        return true;
      }
      return false;
    } catch (e) {
      handleError(e);

      return false;
    }
  }

  @override
  Future<Account?> updateAccount(Account account) async {
    try {
      final result = await baseService.client
          .from(TABLE_NAME.ACCOUNT)
          .update(account.toMap())
          .eq("user_id", account.userId ?? '')
          .select()
          .withConverter((data) => data.map((e) => Account.fromJson(e)).toList());
      return result.first;
    } catch (e) {
      handleError(e);
      return null;
    }
  }

  @override
  Future<List<Account>> getListAccountInWorking({int limit = LIMIT, int page = 0}) async {
    try {
      final result = await baseService.client
          .from(TABLE_NAME.ACCOUNT)
          .select()
          // .eq("role", USER_ROLE.STAFF)
          .not("check_in_time", 'is', null)
          .limit(limit)
          .range(page * limit + page, (page + 1) * limit + page)
          .withConverter((data) => data.map((e) => Account.fromJson(e)).toList());
      return result;
    } catch (e) {
      handleError(e);
      return [];
    }
  }
}

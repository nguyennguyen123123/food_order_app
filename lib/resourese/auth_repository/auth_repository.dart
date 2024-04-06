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
  Future<String?> createAuthentication(String email, String name) async {
    try {
      final response = await baseService.client.functions.invoke("create_user", body: {"email": email, "name": name});
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
          .range(page * LIMIT, (page + 1) * LIMIT)
          .withConverter((data) => data.map((e) => Account.fromJson(e)).toList());
      return response;
    } catch (e) {
      handleError(e);

      return [];
    }
  }
}

import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/auth_repository/iauth_repository.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository extends IAuthRepository {
  final BaseService baseService;

  AuthRepository({required this.baseService});

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
}

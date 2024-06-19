import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthRepository extends IBaseRepository {
  Future<User?> login(String email, String password);
  Future<Account?> getAccountById(String userId);
  Future<String?> createAuthentication(String email, String name, String password);
  Future<Account?> addAccount(Account account);
  Future<List<Account>> getListAccount({int limit = LIMIT, int page = 0});
  Future<bool> deleteAccount(String userId);
  Future<Account?> updateAccount(Account account);
  Future<List<Account>> getListAccountInWorking({int limit = LIMIT, int page = 0});
}

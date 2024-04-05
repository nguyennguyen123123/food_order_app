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
}

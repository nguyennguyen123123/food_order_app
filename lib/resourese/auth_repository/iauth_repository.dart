import 'package:food_delivery_app/resourese/ibase_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class IAuthRepository extends IBaseRepository {
  Future<User?> login(String email, String password);
}

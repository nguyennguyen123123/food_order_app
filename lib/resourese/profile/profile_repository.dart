import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository extends IProfileRepository {
  final BaseService baseService;

  ProfileRepository({
    required this.baseService,
  });

  @override
  Future<void> signOut() async {
    try {
      await baseService.client.auth.signOut();
    } catch (error) {
      handleError(error);
      print(error);
    }
  }

  @override
  Future<Account?> getProfile() async {
    try {
      final userId = baseService.client.auth.currentSession!.user.id;
      final data = await baseService.client.from(TABLE_NAME.ACCOUNT).select().eq('user_id', userId).single();

      return Account.fromJson(data);
    } on PostgrestException catch (error) {
      print(error.message);

      return null;
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Future<Account?> updateProfile(String name, String gender) async {
    try {
      final userId = baseService.client.auth.currentSession!.user.id;

      final updates = {
        'user_id': userId,
        'name': name,
        'gender': gender,
      };

      final result = await baseService.client.from(TABLE_NAME.ACCOUNT).upsert(updates);

      return result;
    } on PostgrestException catch (error) {
      print(error.message);
      return null;
    } catch (error) {
      handleError(error);
      print(error);
      return null;
    }
  }

  @override
  Future<void> updateNumberOfOrder(String userId, int number) async {
    await baseService.client.from(TABLE_NAME.ACCOUNT).update({'number_of_order': number}).eq('user_id', userId);
  }

  @override
  Future<Account?> updateTotalPriceInWorkingTime(String userId, double totalPrice) async {
    try {
      final account = await baseService.client
          .from(TABLE_NAME.ACCOUNT)
          .select()
          .eq('user_id', userId)
          .single()
          .withConverter((data) => Account.fromJson(data));
      final price = account.totalOrderPrice + totalPrice;
      final result = await baseService.client
          .from(TABLE_NAME.ACCOUNT)
          .update({'total_order_price': price})
          .eq('user_id', userId)
          .select('*')
          .single()
          .withConverter((data) => Account.fromJson(data));
      return result;
    } catch (e) {
      print(e);
    }
    return null;
  }
}

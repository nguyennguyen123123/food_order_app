import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRepository extends IProfileRepository {
  final BaseService baseService;
  final AccountService accountService;

  ProfileRepository({
    required this.baseService,
    required this.accountService,
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
      print(error);
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
  Future<void> updateNumberOfOrder(int number) async {
    await baseService.client.from(TABLE_NAME.ACCOUNT).upsert({'number_of_order': number});
    accountService.account.value = accountService.myAccount?.copyWith(numberOfOrder: number);
  }
}

import 'dart:math';

import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/account.dart';
import 'package:food_delivery_app/models/check_in_out.dart';
import 'package:food_delivery_app/resourese/check_in_out/icheck_in_out_repository.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';

class CheckInOutRepository extends ICheckInOutRepository {
  final BaseService baseService;

  CheckInOutRepository({required this.baseService});

  @override
  Future<Account?> checkInUser() async {
    try {
      final userId = baseService.client.auth.currentSession!.user.id;

      final result = await baseService.client
          .from(TABLE_NAME.ACCOUNT)
          .update({
            'check_in_time': DateTime.now().toString(),
          })
          .eq('user_id', userId)
          .select('*')
          .single()
          .withConverter((data) => Account.fromJson(data));

      return result;
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Future<Account?> checkOutUser() async {
    try {
      final userId = baseService.client.auth.currentSession!.user.id;

      int generateRandomIntFromString() {
        final random = Random();
        String randomString = '';
        const validChars = '0123456789abcdefghijklmnopqrstuvwxyz';

        for (int i = 0; i < 8; i++) {
          final randomCharIndex = random.nextInt(validChars.length);
          randomString += validChars[randomCharIndex];
        }

        return int.parse(randomString, radix: 36);
      }

      final myUser = await baseService.client
          .from(TABLE_NAME.ACCOUNT)
          .select('*')
          .eq('user_id', userId)
          .select()
          .single()
          .withConverter((map) => Account.fromJson(map));

      final CheckInOut checkInOutModel = CheckInOut(
        id: generateRandomIntFromString(),
        userId: userId,
        checkInTime: myUser.checkInTime,
        checkOutTime: DateTime.now().toString(),
        totalOrders: myUser.numberOfOrder,
        totalPrice: myUser.totalOrderPrice,
      );

      final response = await baseService.client.from(TABLE_NAME.CHECKINOUT).insert(checkInOutModel.toJson()).select();

      if (response.isNotEmpty) {
        final account = await baseService.client
            .from(TABLE_NAME.ACCOUNT)
            .update({
              'check_in_time': null,
              'number_of_order': 0,
              'total_order_price': 0,
            })
            .eq('user_id', userId)
            .select('*')
            .single()
            .withConverter((data) => Account.fromJson(data));

        return account;
      }

      return null;
    } catch (error) {
      handleError(error);

      return null;
    }
  }

  @override
  Future<List<CheckInOut>> getListCheckInOut(bool role, {int page = 0, int limit = LIMIT}) async {
    try {
      // final role = baseService.client.auth.currentSession!.user.role;
      final userId = baseService.client.auth.currentSession!.user.id;

      if (role) {
        final dataAdmin = baseService.client.from(TABLE_NAME.CHECKINOUT).select("*, user_id (*)");

        final response = await dataAdmin
            .limit(20)
            .range(page * limit + page, (page + 1) * limit + page)
            .withConverter((data) => data.map((e) => CheckInOut.fromJson(e)).toList());

        return response;
      } else {
        final dataUser = baseService.client.from(TABLE_NAME.CHECKINOUT).select("*, user_id (*)").eq('user_id', userId);

        final response = await dataUser
            .limit(limit)
            .range(page * limit + page, (page + 1) * limit + page)
            .withConverter((data) => data.map((e) => CheckInOut.fromJson(e)).toList());

        return response;
      }
    } catch (error) {
      handleError(error);

      return [];
    }
  }

  @override
  Future<bool> onDeleteAll() async {
    try {
      await baseService.client.from(TABLE_NAME.CHECKINOUT).delete().neq('id', 0);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  Future<bool> onDeleteCheckinOut(List<int> ids) async {
    try {
      await baseService.client.from(TABLE_NAME.CHECKINOUT).delete().inFilter('id', ids);
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}

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
  Future<Map<String, dynamic>?> checkInUser() async {
    try {
      final userId = baseService.client.auth.currentSession!.user.id;

      final result = await baseService.client.from(TABLE_NAME.ACCOUNT).upsert({
        'user_id': userId,
        'check_in_time': DateTime.now().toString(),
      }).select();

      return result.first;
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> checkOutUser() async {
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

      final checkInUser = await baseService.client
          .from(TABLE_NAME.ACCOUNT)
          .select('check_in_time')
          .eq('user_id', userId)
          .select()
          .withConverter((data) => data.map((e) => Account.fromJson(e)));

      final CheckInOut checkInOutModel = CheckInOut(
        id: generateRandomIntFromString(),
        userId: userId,
        checkInTime: checkInUser.first.checkInTime,
        checkOutTime: DateTime.now().toString(),
        totalOrders: 0,
      );

      final response = await baseService.client.from(TABLE_NAME.CHECKINOUT).insert(checkInOutModel.toJson()).select();

      if (response.isNotEmpty) {
        await baseService.client.from(TABLE_NAME.ACCOUNT).upsert({
          'user_id': userId,
          'check_in_time': null,
          'number_of_order': null,
        });

        return response.first;
      }

      return response.first;
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
}

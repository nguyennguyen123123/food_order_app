import 'package:food_delivery_app/constant/app_constant_key.dart';
import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/resourese/area/iarea_repository.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';

class AreaRepository extends IAreaRepository {
  final BaseService baseService;

  AreaRepository({required this.baseService});

  @override
  Future<Map<String, dynamic>?> addArea(Area area) async {
    try {
      final response = await baseService.client.from(TABLE_NAME.AREA).insert(area.toJson()).select();

      return response.first;
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>?> deleteArea(String areaId) async {
    try {
      final data = await baseService.client.from(TABLE_NAME.AREA).delete().match({'area_id': areaId}).select();

      return data.first;
    } catch (error) {
      handleError(error);
      return null;
    }
  }

  @override
  Future<Area?> editArea(Area area, String areaId) async {
    try {
      final response = await baseService.client
          .from(TABLE_NAME.AREA)
          .update(area.toJson())
          .eq('area_id', areaId)
          .select()
          .withConverter((data) => data.map((e) => Area.fromJson(e)).toList());

      return response.first;
    } catch (error) {
      handleError(error);

      return null;
    }
  }

  @override
  Future<List<Area>> getArea() async {
    try {
      final response = await baseService.client
          .from(TABLE_NAME.AREA)
          .select()
          .withConverter((data) => data.map((e) => Area.fromJson(e)).toList());

      return response;
    } catch (error) {
      handleError(error);
      rethrow;
    }
  }
}

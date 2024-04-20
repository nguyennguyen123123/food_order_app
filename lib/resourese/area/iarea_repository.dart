import 'package:food_delivery_app/models/area.dart';
import 'package:food_delivery_app/resourese/ibase_repository.dart';

abstract class IAreaRepository extends IBaseRepository {
  Future<Map<String, dynamic>?> addArea(Area area);
  Future<List<Area>> getArea();
  Future<Map<String, dynamic>?> deleteArea(String areaId);
  Future<Area?> editArea(Area area, String areaId);
}

import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';

class ProfileRepository extends IProfileRepository {
  final BaseService baseService;

  ProfileRepository({required this.baseService});
}

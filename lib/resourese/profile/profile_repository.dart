import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';

class ProfileRepository extends IProfileRepository {
  final BaseService baseService;

  ProfileRepository({required this.baseService});

  @override
  Future<void> signOut() async {
    try {
      await baseService.client.auth.signOut();
    } catch (error) {
      handleError(error);
      print(error);
    }
  }
}

import 'package:food_delivery_app/constant/storage_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // late final FlutterSecureStorage _secureStorage;
  late final SharedPreferences _preferences;

  StorageService();

  Future<void> initService() async {
    // _secureStorage = const FlutterSecureStorage();
    _preferences = await SharedPreferences.getInstance();
  }

  Future saveUid(String userId) async {
    return _preferences.setString(StorageKey.USER_UID, userId);
  }

  Future saveAccountType(String type) async {
    return _preferences.setString(StorageKey.ACCOUNT_TYPE, type);
  }

  Future saveSessionId(String id) =>
      _preferences.setString(StorageKey.SESSION_ID, id);

  Future clear() async {
    await _preferences.clear();
  }
}

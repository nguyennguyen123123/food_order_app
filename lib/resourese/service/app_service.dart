import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_delivery_app/constant/app_config.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/resourese/service/storage_service.dart';
import 'package:get/get.dart';

class AppService {
  /// init your service here for global using
  static Future<void> initAppService() async {
    await dotenv.load(fileName: 'assets/.env');
    final appConfig = AppConfig(
      supabaseApiKey: dotenv.get('SUPABASE_API_KEY'),
      supabaseUrl: dotenv.get('SUPABASE_URL'),
    );
    Get.put<AppConfig>(appConfig);

    final storage = StorageService();
    await storage.initService();
    Get.put<StorageService>(storage);

    final server = BaseService(storageService: Get.find(), appConfig: Get.find());
    await server.init();

    Get.put<BaseService>(server);

    // locator.registerSingleton<IAuthenRepository>(
    //     AuthenRepository(serverService: locator.get()));
    // locator.registerSingleton<IUploadRepository>(
    //     UploadRepository(serverService: server));

    // locator.registerSingleton<IAccountRepository>(AccountRepository());
    // locator.registerSingleton<IEmployeeRepository>(EmployeeRepository(
    //     serverService: locator.get(), uploadRepository: locator.get()));
    // locator.registerSingleton<IHeartMeasureRepository>(
    //     HeartMeasureRepository(serverService: locator.get()));
    // locator.registerSingleton<AccountService>(AccountService(
    //   storageService: locator.get(),
    //   serverService: locator.get(),
    // ));
  }
}

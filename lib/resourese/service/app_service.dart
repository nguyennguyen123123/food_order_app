import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:food_delivery_app/constant/app_config.dart';
import 'package:food_delivery_app/resourese/area/area_repository.dart';
import 'package:food_delivery_app/resourese/area/iarea_repository.dart';
import 'package:food_delivery_app/resourese/auth_repository/auth_repository.dart';
import 'package:food_delivery_app/resourese/auth_repository/iauth_repository.dart';
import 'package:food_delivery_app/resourese/check_in_out/check_in_out_repository.dart';
import 'package:food_delivery_app/resourese/check_in_out/icheck_in_out_repository.dart';
import 'package:food_delivery_app/resourese/food/food_repository.dart';
import 'package:food_delivery_app/resourese/food/ifood_repository.dart';
import 'package:food_delivery_app/resourese/order/iorder_repository.dart';
import 'package:food_delivery_app/resourese/order/order_repository.dart';
import 'package:food_delivery_app/resourese/printer/iprinter_repository.dart';
import 'package:food_delivery_app/resourese/printer/printer_repository.dart';
import 'package:food_delivery_app/resourese/profile/iprofile_repository.dart';
import 'package:food_delivery_app/resourese/profile/profile_repository.dart';
import 'package:food_delivery_app/resourese/service/account_service.dart';
import 'package:food_delivery_app/resourese/service/base_service.dart';
import 'package:food_delivery_app/resourese/service/order_cart_service.dart';
import 'package:food_delivery_app/resourese/service/printer_service.dart';
import 'package:food_delivery_app/resourese/service/storage_service.dart';
import 'package:food_delivery_app/resourese/table/itable_repository.dart';
import 'package:food_delivery_app/resourese/table/table_repository.dart';
import 'package:food_delivery_app/resourese/voucher/ivoucher_repository.dart';
import 'package:food_delivery_app/resourese/voucher/voucher_repository.dart';
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

    Get.put<IPrinterRepository>(PrinterRepository(baseService: Get.find()));
    Get.put<PrinterService>(PrinterService(printerRepository: Get.find()));
    Get.put<OrderCartService>(OrderCartService());
    Get.put<IProfileRepository>(ProfileRepository(baseService: Get.find()));
    Get.put(AccountService(
        storageService: Get.find(),
        baseService: Get.find(),
        printerService: Get.find(),
        profileRepository: Get.find(),
        cartService: Get.find()));
    Get.put<IAuthRepository>(AuthRepository(baseService: Get.find(), accountService: Get.find()));
    Get.put<IFoodRepository>(FoodRepository(baseService: Get.find()));
    Get.put<ITableRepository>(TableRepository(baseService: Get.find()));
    Get.put<IOrderRepository>(OrderRepository(
      baseService: Get.find(),
      accountService: Get.find(),
      profileRepository: Get.find(),
      tableRepository: Get.find(),
    ));
    Get.put<IVoucherRepository>(VoucherRepository(baseService: Get.find()));
    Get.put<ICheckInOutRepository>(CheckInOutRepository(baseService: Get.find()));
    Get.put<IAreaRepository>(AreaRepository(baseService: Get.find()));
  }
}

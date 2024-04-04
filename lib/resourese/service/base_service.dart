import 'package:food_delivery_app/constant/app_config.dart';
import 'package:food_delivery_app/resourese/service/storage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BaseService {
  final StorageService storageService;
  final AppConfig appConfig;
  late final Supabase supabase;

  SupabaseClient get supabaseClient => supabase.client;

  BaseService({required this.storageService, required this.appConfig});

  init() async {
    supabase = await Supabase.initialize(
      url: appConfig.supabaseUrl,
      anonKey: appConfig.supabaseApiKey,
      postgrestOptions: const PostgrestClientOptions(),
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
      realtimeClientOptions: const RealtimeClientOptions(
        logLevel: RealtimeLogLevel.info,
      ),
      storageOptions: const StorageClientOptions(retryAttempts: 10),
    );
  }
}

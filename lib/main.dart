import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simu/app/app.dart';
import 'package:simu/core/logging/app_logger.dart';
import 'package:simu/core/logging/logger_impl.dart';
import 'package:simu/core/services/analytics/analytics_service.dart';
import 'package:simu/core/services/analytics/log_analytics_service.dart';
import 'package:simu/core/services/storage/key_value_storage.dart';
import 'package:simu/core/services/storage/shared_preferences_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Core service initializations
  const AppLogger logger = AppLoggerImpl();
  final sharedPreferences = await SharedPreferences.getInstance();
  final keyValueStorage = SharedPreferencesStorage(sharedPreferences);
  const analyticsService = LogAnalyticsService(logger: logger);

  logger.info('Simu initializing...', tag: 'Bootstrap');

  runApp(
    ProviderScope(
      overrides: [
        keyValueStorageProvider.overrideWithValue(keyValueStorage),
        analyticsServiceProvider.overrideWithValue(analyticsService),
      ],
      child: const SimuApp(),
    ),
  );
}

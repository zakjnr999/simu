import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/app/config/environment.dart';

/// Application configuration data.
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableAnalytics,
    required this.enableLogging,
  });

  final Environment environment;
  final String apiBaseUrl;
  final bool enableAnalytics;
  final bool enableLogging;

  factory AppConfig.dev() {
    return const AppConfig(
      environment: Environment.dev,
      apiBaseUrl: 'https://api.dev.simu.app',
      enableAnalytics: true,
      enableLogging: true,
    );
  }

  factory AppConfig.staging() {
    return const AppConfig(
      environment: Environment.staging,
      apiBaseUrl: 'https://api.staging.simu.app',
      enableAnalytics: true,
      enableLogging: true,
    );
  }

  factory AppConfig.prod() {
    return const AppConfig(
      environment: Environment.prod,
      apiBaseUrl: 'https://api.simu.app',
      enableAnalytics: true,
      enableLogging: false,
    );
  }
}

/// Global provider for application configuration.
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.dev();
});

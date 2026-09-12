import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstract interface for tracking product analytics events, screen views, and user properties.
abstract class AnalyticsService {
  Future<void> trackEvent(String eventName, [Map<String, dynamic>? parameters]);
  Future<void> setCurrentScreen(String screenName);
  Future<void> setUserProperty(String name, String value);
  Future<void> setUserId(String? userId);
}

/// Global provider for AnalyticsService, overridden in main.dart / bootstrap.
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  throw UnimplementedError(
      'analyticsServiceProvider must be initialized in main()');
});

import 'package:simu/core/logging/app_logger.dart';
import 'package:simu/core/services/analytics/analytics_service.dart';

/// Console logging implementation of [AnalyticsService] for development & testing.
class LogAnalyticsService implements AnalyticsService {
  const LogAnalyticsService({required this.logger});

  final AppLogger logger;

  @override
  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? parameters]) async {
    logger.debug('Analytics Event: $eventName, params: $parameters',
        tag: 'Analytics');
  }

  @override
  Future<void> setCurrentScreen(String screenName) async {
    logger.debug('Analytics Screen: $screenName', tag: 'Analytics');
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    logger.debug('Analytics UserProperty: $name = $value', tag: 'Analytics');
  }

  @override
  Future<void> setUserId(String? userId) async {
    logger.debug('Analytics UserId: $userId', tag: 'Analytics');
  }
}

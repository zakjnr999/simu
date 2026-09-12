import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Hook for application route guard evaluation.
class RouteGuards {
  const RouteGuards._();

  static Future<String?> checkOnboardingAndAuth(
    BuildContext context,
    GoRouterState state,
  ) async {
    // Scaffold guard hook: returns null to allow normal navigation
    return null;
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Minimum splash display time — override in tests for faster navigation.
final splashMinDisplayDurationProvider = Provider<Duration>(
  (ref) => const Duration(milliseconds: 2500),
);

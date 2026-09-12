import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Debug-only logging for splash bootstrap and asset preloading.
abstract final class BootstrapDebugLog {
  static int? _runStartedMs;

  static void startRun() {
    if (!kDebugMode) {
      return;
    }

    _runStartedMs = DateTime.now().millisecondsSinceEpoch;
    debugPrint('[Bootstrap] ========== START ==========');
  }

  static void endRun({
    required bool onboardingComplete,
    required int imageSuccessCount,
    required int imageFailCount,
    required int imageTotal,
    required int fontCount,
  }) {
    if (!kDebugMode) {
      return;
    }

    final elapsed = _elapsedMs();
    final cache = PaintingBinding.instance.imageCache;

    debugPrint(
      '[Bootstrap] summary '
      'onboardingComplete=$onboardingComplete '
      'images=$imageSuccessCount/$imageTotal failed=$imageFailCount '
      'fonts=$fontCount '
      'elapsed=${elapsed}ms',
    );
    debugPrint(
      '[Bootstrap] imageCache '
      'entries=${cache.currentSize} '
      'bytes=${cache.currentSizeBytes} '
      'live=${cache.liveImageCount}',
    );
    debugPrint('[Bootstrap] ========== DONE (${elapsed}ms) ==========');
    _runStartedMs = null;
  }

  static void phase(String message) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('[Bootstrap] ${_elapsedLabel()} $message');
  }

  static void assetOk({
    required int index,
    required int total,
    required String path,
    required int durationMs,
  }) {
    if (!kDebugMode) {
      return;
    }

    debugPrint(
      '[Bootstrap][Asset] [$index/$total] ok (${durationMs}ms) $path',
    );
  }

  static void assetFail({
    required int index,
    required int total,
    required String path,
    required Object error,
  }) {
    if (!kDebugMode) {
      return;
    }

    debugPrint(
      '[Bootstrap][Asset] [$index/$total] FAIL $path — $error',
    );
  }

  static void fontOk(String family, int durationMs) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('[Bootstrap][Font] ok (${durationMs}ms) $family');
  }

  static void fontFail(String family, Object error) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('[Bootstrap][Font] FAIL $family — $error');
  }

  static void progress(double value, String message) {
    if (!kDebugMode) {
      return;
    }

    final percent = (value.clamp(0, 1) * 100).toStringAsFixed(0);
    debugPrint('[Bootstrap][Progress] $percent% — $message');
  }

  static String _elapsedLabel() {
    final ms = _elapsedMs();
    return '(${ms}ms)';
  }

  static int _elapsedMs() {
    final started = _runStartedMs;
    if (started == null) {
      return 0;
    }

    return DateTime.now().millisecondsSinceEpoch - started;
  }
}

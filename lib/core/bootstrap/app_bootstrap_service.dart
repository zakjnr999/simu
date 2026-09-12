import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/app/config/app_config.dart';
import 'package:simu/core/bootstrap/bootstrap_debug_log.dart';
import 'package:simu/core/services/assets/asset_manifest.dart';
import 'package:simu/core/services/assets/asset_preload_service.dart';
import 'package:simu/core/services/storage/key_value_storage.dart';
import 'package:simu/features/onboarding/data/repositories/onboarding_repository_impl.dart';

typedef BootstrapProgressCallback = void Function(
  double progress,
  String message,
);

/// Result of splash-time startup work.
class AppBootstrapResult {
  const AppBootstrapResult({
    required this.onboardingComplete,
    required this.imageSuccessCount,
    required this.imageFailCount,
    required this.imageTotal,
    required this.fontCount,
    required this.durationMs,
  });

  final bool onboardingComplete;
  final int imageSuccessCount;
  final int imageFailCount;
  final int imageTotal;
  final int fontCount;
  final int durationMs;
}

/// Runs storage checks, font warm-up, and image precaching during splash.
class AppBootstrapService {
  const AppBootstrapService(this._ref);

  final Ref _ref;

  static const double _initWeight = 0.12;
  static const double _fontWeight = 0.08;
  static const double _assetWeight = 0.80;

  Future<AppBootstrapResult> run({
    required BuildContext context,
    BootstrapProgressCallback? onProgress,
  }) async {
    final startedAt = DateTime.now();
    BootstrapDebugLog.startRun();
    BootstrapDebugLog.phase(
      'manifest splashPreload=${SimuAssetManifest.splashPreload.length} assets',
    );

    _reportProgress(onProgress, 0);

    BootstrapDebugLog.phase('init: warming services');
    _ref.read(appConfigProvider);
    _ref.read(keyValueStorageProvider);

    final repository = _ref.read(onboardingRepositoryProvider);
    final onboardingResult = await repository.isOnboardingComplete();
    final onboardingComplete = onboardingResult.dataOrNull ?? false;

    BootstrapDebugLog.phase('init: onboardingComplete=$onboardingComplete');
    _reportProgress(onProgress, _initWeight);

    final assetPreload = _ref.read(assetPreloadServiceProvider);
    final fontCount = await assetPreload.preloadFonts();

    _reportProgress(onProgress, _initWeight + _fontWeight);

    if (!context.mounted) {
      return AppBootstrapResult(
        onboardingComplete: onboardingComplete,
        imageSuccessCount: 0,
        imageFailCount: 0,
        imageTotal: 0,
        fontCount: fontCount,
        durationMs: 0,
      );
    }

    final assets = SimuAssetManifest.splashPreload;
    final imageResult = await assetPreload.preloadImages(
      context,
      assets,
      onProgress: (loaded, total) {
        if (total == 0) {
          return;
        }

        final assetProgress = loaded / total;
        final overall =
            _initWeight + _fontWeight + (_assetWeight * assetProgress);
        _reportProgress(onProgress, overall);
      },
    );

    _reportProgress(onProgress, 1);

    final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
    BootstrapDebugLog.endRun(
      onboardingComplete: onboardingComplete,
      imageSuccessCount: imageResult.successCount,
      imageFailCount: imageResult.failCount,
      imageTotal: imageResult.total,
      fontCount: fontCount,
    );

    return AppBootstrapResult(
      onboardingComplete: onboardingComplete,
      imageSuccessCount: imageResult.successCount,
      imageFailCount: imageResult.failCount,
      imageTotal: imageResult.total,
      fontCount: fontCount,
      durationMs: durationMs,
    );
  }

  void _reportProgress(BootstrapProgressCallback? onProgress, double value) {
    final message = messageForProgress(value);
    BootstrapDebugLog.progress(value, message);
    onProgress?.call(value, message);
  }

  @visibleForTesting
  static String messageForProgress(double progress) {
    if (progress < 0.35) {
      return 'Preparing your adventure...';
    }
    if (progress < 0.70) {
      return 'Loading resources...';
    }
    if (progress < 0.95) {
      return 'Preparing your personal arena...';
    }
    return 'Ready to level up!';
  }
}

final appBootstrapServiceProvider = Provider<AppBootstrapService>(
  (ref) => AppBootstrapService(ref),
);

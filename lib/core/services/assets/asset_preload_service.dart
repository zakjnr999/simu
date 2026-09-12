import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/core/bootstrap/bootstrap_debug_log.dart';
import 'package:simu/core/services/assets/asset_manifest.dart'
    show SimuAssetManifest;

typedef AssetPreloadProgress = void Function(int loaded, int total);

/// Result of an image preload batch.
class AssetPreloadResult {
  const AssetPreloadResult({
    required this.successCount,
    required this.failCount,
    required this.total,
    required this.durationMs,
  });

  final int successCount;
  final int failCount;
  final int total;
  final int durationMs;
}

/// Decodes images and fonts into memory so later screens avoid first-frame jank.
class AssetPreloadService {
  const AssetPreloadService();

  /// Loads [paths] into Flutter's image cache via [precacheImage].
  Future<AssetPreloadResult> preloadImages(
    BuildContext context,
    List<String> paths, {
    AssetPreloadProgress? onProgress,
  }) async {
    if (paths.isEmpty) {
      onProgress?.call(0, 0);
      BootstrapDebugLog.phase('image preload skipped (empty manifest)');
      return const AssetPreloadResult(
        successCount: 0,
        failCount: 0,
        total: 0,
        durationMs: 0,
      );
    }

    final batchStarted = DateTime.now();
    var loaded = 0;
    var successCount = 0;
    var failCount = 0;
    final total = paths.length;

    BootstrapDebugLog.phase('image preload start (total=$total)');

    onProgress?.call(loaded, total);

    for (final path in paths) {
      loaded++;
      final assetStarted = DateTime.now();

      try {
        await precacheImage(AssetImage(path), context);
        successCount++;
        BootstrapDebugLog.assetOk(
          index: loaded,
          total: total,
          path: path,
          durationMs: DateTime.now().difference(assetStarted).inMilliseconds,
        );
      } catch (error) {
        failCount++;
        BootstrapDebugLog.assetFail(
          index: loaded,
          total: total,
          path: path,
          error: error,
        );
      }

      onProgress?.call(loaded, total);
    }

    final durationMs = DateTime.now().difference(batchStarted).inMilliseconds;
    BootstrapDebugLog.phase(
      'image preload done success=$successCount fail=$failCount (${durationMs}ms)',
    );

    return AssetPreloadResult(
      successCount: successCount,
      failCount: failCount,
      total: total,
      durationMs: durationMs,
    );
  }

  /// Warms text layout for bundled fonts so first styled text is instant.
  Future<int> preloadFonts() async {
    const families = SimuAssetManifest.fontFamilies;
    BootstrapDebugLog.phase('font preload start (total=${families.length})');

    var successCount = 0;
    for (final family in families) {
      final started = DateTime.now();

      try {
        final builder = ui.ParagraphBuilder(
          ui.ParagraphStyle(fontFamily: family, fontSize: 14),
        )..addText('Simu');
        final paragraph = builder.build()
          ..layout(const ui.ParagraphConstraints(width: 48));
        paragraph.dispose();
        successCount++;
        BootstrapDebugLog.fontOk(
          family,
          DateTime.now().difference(started).inMilliseconds,
        );
      } catch (error) {
        BootstrapDebugLog.fontFail(family, error);
      }
    }

    BootstrapDebugLog.phase(
        'font preload done success=$successCount/${families.length}');
    return successCount;
  }

  /// Verifies an asset exists in the bundle (cheap sanity check).
  Future<bool> assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final assetPreloadServiceProvider = Provider<AssetPreloadService>(
  (ref) => const AssetPreloadService(),
);

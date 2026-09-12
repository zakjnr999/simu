import 'package:flutter_test/flutter_test.dart';
import 'package:simu/core/services/assets/asset_manifest.dart';

void main() {
  test('splashPreload contains unique non-empty asset paths', () {
    final assets = SimuAssetManifest.splashPreload;

    expect(assets, isNotEmpty);
    expect(assets.toSet().length, assets.length);

    for (final path in assets) {
      expect(path.startsWith('assets/'), isTrue);
      expect(
        path.endsWith('.png') || path.endsWith('.jpg'),
        isTrue,
        reason: '$path should be a raster image',
      );
    }
  });

  test('splash preload includes onboarding heavy hitters', () {
    final assets = SimuAssetManifest.splashPreload;

    expect(assets, contains('assets/illustrations/onboarding/onboarding_world.png'));
    expect(assets, contains('assets/illustrations/onboarding/curtains/curtain_left.png'));
    expect(assets, contains('assets/illustrations/onboarding/meet_ace/meet_ace_background.png'));
    expect(assets, contains('assets/illustrations/onboarding/journey/milestones/milestone_01_flag.png'));
  });
}

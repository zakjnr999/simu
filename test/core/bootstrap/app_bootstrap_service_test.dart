import 'package:flutter_test/flutter_test.dart';
import 'package:simu/core/bootstrap/app_bootstrap_service.dart';

void main() {
  test('bootstrap status messages cover progress ranges', () {
    expect(AppBootstrapService.messageForProgress(0), 'Preparing your adventure...');
    expect(AppBootstrapService.messageForProgress(0.5), 'Loading resources...');
    expect(AppBootstrapService.messageForProgress(0.8), 'Preparing your personal arena...');
    expect(AppBootstrapService.messageForProgress(1), 'Ready to level up!');
  });
}

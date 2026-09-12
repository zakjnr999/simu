import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/app/app.dart';
import 'package:simu/core/bootstrap/splash_timing.dart';
import 'package:simu/core/services/assets/asset_manifest.dart';
import 'package:simu/core/services/assets/asset_preload_service.dart';
import 'package:simu/core/errors/app_failure.dart';
import 'package:simu/core/result/result.dart';
import 'package:simu/core/services/analytics/analytics_service.dart';
import 'package:simu/core/services/storage/key_value_storage.dart';
import 'package:simu/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:simu/features/home/presentation/widgets/simu_bottom_nav_bar.dart';
import 'package:simu/features/onboarding/presentation/widgets/splash_loading_panel.dart';

class MockStorage implements KeyValueStorage {
  final Map<String, dynamic> data = {};

  @override
  Future<void> clear() async => data.clear();

  @override
  Future<bool> containsKey(String key) async => data.containsKey(key);

  @override
  Future<bool?> getBool(String key) async => data[key] as bool?;

  @override
  Future<int?> getInt(String key) async => data[key] as int?;

  @override
  Future<String?> getString(String key) async => data[key] as String?;

  @override
  Future<List<String>?> getStringList(String key) async =>
      data[key] as List<String>?;

  @override
  Future<void> remove(String key) async => data.remove(key);

  @override
  Future<void> setBool(String key, bool value) async => data[key] = value;

  @override
  Future<void> setInt(String key, int value) async => data[key] = value;

  @override
  Future<void> setString(String key, String value) async => data[key] = value;

  @override
  Future<void> setStringList(String key, List<String> value) async =>
      data[key] = value;
}

class FakeAnalyticsService implements AnalyticsService {
  @override
  Future<void> setCurrentScreen(String screenName) async {}

  @override
  Future<void> setUserId(String? userId) async {}

  @override
  Future<void> setUserProperty(String name, String value) async {}

  @override
  Future<void> trackEvent(String eventName,
      [Map<String, dynamic>? parameters]) async {}
}

class FakeOnboardingRepository implements OnboardingRepository {
  FakeOnboardingRepository({this.isComplete = false});

  final bool isComplete;

  @override
  Future<Result<void, AppFailure>> completeOnboarding() async =>
      const Result.success(null);

  @override
  Future<Result<UserGoalCategory?, AppFailure>> getSelectedGoal() async =>
      const Result.success(null);

  @override
  Future<Result<void, AppFailure>> saveSelectedMasteryGoal(
          String masteryGoalId) async =>
      const Result.success(null);

  @override
  Future<Result<String?, AppFailure>> getSelectedMasteryGoal() async =>
      const Result.success(null);

  @override
  Future<Result<void, AppFailure>> saveSelectedExperience(
          String experienceId) async =>
      const Result.success(null);

  @override
  Future<Result<String?, AppFailure>> getSelectedExperience() async =>
      const Result.success(null);

  @override
  Future<Result<void, AppFailure>> saveSelectedPersonalGoal(
          String personalGoalId) async =>
      const Result.success(null);

  @override
  Future<Result<String?, AppFailure>> getSelectedPersonalGoal() async =>
      const Result.success(null);

  @override
  Future<Result<void, AppFailure>> saveSelectedCommitment(
          String commitmentId) async =>
      const Result.success(null);

  @override
  Future<Result<String?, AppFailure>> getSelectedCommitment() async =>
      const Result.success(null);

  @override
  Future<Result<bool, AppFailure>> isOnboardingComplete() async =>
      Result.success(isComplete);

  @override
  Future<Result<void, AppFailure>> saveSelectedGoal(
          UserGoalCategory category) async =>
      const Result.success(null);
}

class FakeAssetPreloadService extends AssetPreloadService {
  @override
  Future<int> preloadFonts() async => SimuAssetManifest.fontFamilies.length;

  @override
  Future<AssetPreloadResult> preloadImages(
    BuildContext context,
    List<String> paths, {
    AssetPreloadProgress? onProgress,
  }) async {
    onProgress?.call(paths.length, paths.length);
    return AssetPreloadResult(
      successCount: paths.length,
      failCount: 0,
      total: paths.length,
      durationMs: 0,
    );
  }
}

void main() {
  testWidgets(
      'App boots on Splash and transitions to Welcome when onboarding is incomplete',
      (tester) async {
    final mockStorage = MockStorage();
    final fakeAnalytics = FakeAnalyticsService();
    final fakeRepo = FakeOnboardingRepository(isComplete: false);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyValueStorageProvider.overrideWithValue(mockStorage),
          analyticsServiceProvider.overrideWithValue(fakeAnalytics),
          onboardingRepositoryProvider.overrideWithValue(fakeRepo),
          splashMinDisplayDurationProvider.overrideWithValue(Duration.zero),
          assetPreloadServiceProvider.overrideWithValue(FakeAssetPreloadService()),
        ],
        child: const SimuApp(),
      ),
    );

    // Initial Splash Screen with LoadingPanel
    expect(find.byType(SplashLoadingPanel), findsOneWidget);

    // Advance past the slow initialization phases and settle navigation
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Welcome Screen
    expect(find.textContaining('Ace'), findsOneWidget);
    expect(find.text("Let's Begin the Journey!"), findsOneWidget);
  });

  testWidgets(
      'App boots on Splash and transitions to Home when onboarding is complete',
      (tester) async {
    final mockStorage = MockStorage();
    final fakeAnalytics = FakeAnalyticsService();
    final fakeRepo = FakeOnboardingRepository(isComplete: true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyValueStorageProvider.overrideWithValue(mockStorage),
          analyticsServiceProvider.overrideWithValue(fakeAnalytics),
          onboardingRepositoryProvider.overrideWithValue(fakeRepo),
          splashMinDisplayDurationProvider.overrideWithValue(Duration.zero),
          assetPreloadServiceProvider.overrideWithValue(FakeAssetPreloadService()),
        ],
        child: const SimuApp(),
      ),
    );

    // Initial Splash Screen with LoadingPanel
    expect(find.byType(SplashLoadingPanel), findsOneWidget);

    // Advance past the slow initialization phases and settle navigation
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Home screen with bottom navigation
    expect(find.byType(SimuBottomNavBar), findsOneWidget);
    expect(find.text('Journey'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}

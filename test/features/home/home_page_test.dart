import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/core/services/storage/key_value_storage.dart';
import 'package:simu/core/services/user/user_display_name_provider.dart';
import 'package:simu/features/home/presentation/pages/home_page.dart';
import 'package:simu/features/home/presentation/widgets/home_level_progress_card.dart';
import 'package:simu/features/home/presentation/widgets/home_todays_challenge_card.dart';
import 'package:simu/features/home/presentation/widgets/home_your_progress_card.dart';
import 'package:simu/features/home/presentation/widgets/home_header_bar.dart';
import 'package:simu/features/home/presentation/widgets/home_hero_section.dart';
import 'package:simu/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:simu/features/onboarding/presentation/state/onboarding_state.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_xp_badge.dart';

class _FakeStorage implements KeyValueStorage {
  final Map<String, dynamic> data;

  _FakeStorage(this.data);

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

class _TestOnboardingController extends OnboardingController {
  @override
  OnboardingState build() => const OnboardingState(
        availableGoals: [],
        availableMasteryGoals: [],
        availableExperienceLevels: [],
        availablePersonalGoals: [],
        availableCommitments: [],
      );
}

void main() {
  testWidgets('HomePage shows greeting, XP, and notification badge', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyValueStorageProvider.overrideWithValue(_FakeStorage({})),
          userDisplayNameProvider.overrideWith((ref) async => 'Alex'),
          onboardingControllerProvider.overrideWith(_TestOnboardingController.new),
        ],
        child: const MaterialApp(home: HomePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(HomeHeaderBar), findsOneWidget);
    expect(find.byType(HomeHeroSection), findsOneWidget);
    expect(find.byType(HomeLevelProgressCard), findsOneWidget);
    expect(find.byType(HomeTodaysChallengeCard), findsOneWidget);
    expect(find.byType(HomeYourProgressCard), findsOneWidget);
    expect(find.text('Start Challenge'), findsOneWidget);
    expect(find.textContaining("TODAY'S CHALLENGE"), findsOneWidget);
    expect(find.textContaining('YOUR PROGRESS'), findsOneWidget);
    expect(find.text('View Journey'), findsOneWidget);
    expect(find.byType(OnboardingXpBadge), findsOneWidget);
    expect(find.byType(RichText), findsWidgets);
    expect(find.text('Day Streak'), findsOneWidget);
    expect(find.text('350 / 600 XP'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/core/services/storage/key_value_storage.dart';
import 'package:simu/core/services/user/user_display_name_provider.dart';
import 'package:simu/features/journey/presentation/pages/your_journey_page.dart';
import 'package:simu/features/journey/presentation/providers/your_journey_provider.dart';
import 'package:simu/features/onboarding/domain/entities/daily_commitment.dart';
import 'package:simu/features/onboarding/domain/entities/experience_level.dart';
import 'package:simu/features/onboarding/domain/entities/mastery_goal.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:simu/features/onboarding/presentation/state/onboarding_state.dart';
import 'package:simu/features/onboarding/presentation/widgets/onboarding_primary_cta.dart';

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
  _TestOnboardingController(this.initial);

  final OnboardingState initial;

  @override
  OnboardingState build() => initial;
}

OnboardingState onboardingWithGoal(UserGoalCategory category) {
  final goal =
      UserGoal.predefinedGoals.firstWhere((g) => g.category == category);

  return OnboardingState(
    availableGoals: UserGoal.predefinedGoals,
    selectedGoal: goal,
    availableMasteryGoals: MasteryGoal.predefinedGoals,
    selectedMasteryGoal: MasteryGoal.predefinedGoals.first,
    availableExperienceLevels: ExperienceLevel.predefinedLevels,
    selectedExperienceLevel: ExperienceLevel.predefinedLevels.first,
    availablePersonalGoals: const [],
    availableCommitments: DailyCommitment.predefinedCommitments,
    selectedCommitment: DailyCommitment.predefinedCommitments[1],
  );
}

void main() {
  test('yourJourneyUiModelProvider maps onboarding selections', () async {
    final container = ProviderContainer(
      overrides: [
        keyValueStorageProvider.overrideWithValue(_FakeStorage({})),
        userDisplayNameProvider.overrideWith((ref) async => 'Alex'),
      ],
    );
    addTearDown(container.dispose);

    await container.read(userDisplayNameProvider.future);
    final model = container.read(yourJourneyUiModelProvider);
    expect(model, isNotNull);
    expect(model!.displayName, 'Alex');
    expect(model.summaryItems, hasLength(4));
    expect(model.previewMilestones, hasLength(4));
    expect(model.practiceCategory, UserGoalCategory.interviews);
  });

  testWidgets('YourJourneyPage renders summary, milestones, and CTA',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyValueStorageProvider.overrideWithValue(_FakeStorage({})),
          userDisplayNameProvider.overrideWith((ref) async => 'Alex'),
        ],
        child: const MaterialApp(
          home: YourJourneyPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Enter My Journey'), findsOneWidget);
    expect(find.byType(OnboardingPrimaryCta), findsOneWidget);
    expect(find.text('The First Impression'), findsOneWidget);
    expect(find.text('Interviews Practice'), findsOneWidget);
    expect(find.textContaining("Here's Your Summary"), findsOneWidget);
  });

  testWidgets('communication goal shows communication milestones', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          keyValueStorageProvider.overrideWithValue(_FakeStorage({})),
          userDisplayNameProvider.overrideWith((ref) async => 'Alex'),
          onboardingControllerProvider.overrideWith(
            () => _TestOnboardingController(
              onboardingWithGoal(UserGoalCategory.communication),
            ),
          ),
        ],
        child: const MaterialApp(
          home: YourJourneyPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Speak Clearly'), findsOneWidget);
    expect(find.text('Communication Practice'), findsOneWidget);
  });
}

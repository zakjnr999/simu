import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/journey/domain/journey_configs.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';

void main() {
  group('JourneyConfigs', () {
    test('defines a journey for every practice category', () {
      for (final category in UserGoalCategory.values) {
        final journey = JourneyConfigs.forCategory(category);
        expect(journey.category, category);
        expect(journey.milestones.length, greaterThanOrEqualTo(4));
      }
    });

    test('previewMilestones returns first four milestones', () {
      final journey = JourneyConfigs.forCategory(UserGoalCategory.interviews);
      final preview = journey.previewMilestones();

      expect(preview, hasLength(4));
      expect(preview.first.title, 'The First Impression');
      expect(preview.first.isActive, isTrue);
      expect(preview.last.isLocked, isTrue);
    });

    test('interviews journey supports more than four milestones internally', () {
      final journey = JourneyConfigs.forCategory(UserGoalCategory.interviews);
      expect(journey.milestones.length, greaterThan(4));
    });

    test('communication milestones match category content', () {
      final preview = JourneyConfigs.forCategory(UserGoalCategory.communication)
          .previewMilestones();

      expect(preview.first.title, 'Speak Clearly');
      expect(preview.last.title, 'Communicate With Confidence');
    });
  });
}

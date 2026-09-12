import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simu/features/simulation/data/repositories/mock_simulation_repository.dart';
import 'package:simu/features/simulation/domain/entities/simulation_turn.dart';
import 'package:simu/features/simulation/presentation/controllers/simulation_controller.dart';
import 'package:simu/features/simulation/presentation/state/simulation_state.dart';

void main() {
  group('SimulationController', () {
    late ProviderContainer container;
    const scenarioId = 'interview-tell-me-about-yourself';

    setUp(() {
      container = ProviderContainer(
        overrides: [
          simulationRepositoryProvider.overrideWithValue(MockSimulationRepository()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initializes with scenario details and seeds opening interviewer turn', () async {
      container.read(simulationControllerProvider(scenarioId).notifier);

      // Allow async scenario initialization
      await Future<void>.delayed(const Duration(milliseconds: 150));

      final state = container.read(simulationControllerProvider(scenarioId));
      expect(state.scenario.id, scenarioId);
      expect(state.turns.length, 1);
      expect(state.turns.first.speaker, TurnSpeaker.interviewer);
      expect(state.status, SimulationStatus.ready);
    });

    test('submitUserResponse advances turns and triggers interviewer reply', () async {
      final controller =
          container.read(simulationControllerProvider(scenarioId).notifier);
      await Future<void>.delayed(const Duration(milliseconds: 150));

      await controller.submitUserResponse(
        'I am a product designer with 5 years experience.',
      );

      final state = container.read(simulationControllerProvider(scenarioId));
      expect(state.turns.length, 3); // 1: opening, 2: user, 3: interviewer reply
      expect(state.turns[1].speaker, TurnSpeaker.user);
      expect(state.turns[2].speaker, TurnSpeaker.interviewer);
      expect(state.status, SimulationStatus.ready);
    });

    test('reaches completed state with evaluation after maxTurns', () async {
      final controller =
          container.read(simulationControllerProvider(scenarioId).notifier);
      await Future<void>.delayed(const Duration(milliseconds: 150));

      // Turn 1
      await controller.submitUserResponse('My first answer.');
      // Turn 2
      await controller.submitUserResponse('My second answer.');
      // Turn 3 (final)
      await controller.submitUserResponse('My third answer.');

      final state = container.read(simulationControllerProvider(scenarioId));
      expect(state.status, SimulationStatus.completed);
      expect(state.isCompleted, isTrue);
      expect(state.evaluation, isNotNull);
      expect(state.evaluation!.overallScore, greaterThanOrEqualTo(80));
      expect(state.evaluation!.xpEarned, state.scenario.xpReward);
    });

    test('toggleCoachHint flips visibility state', () {
      final controller =
          container.read(simulationControllerProvider(scenarioId).notifier);

      expect(container.read(simulationControllerProvider(scenarioId)).coachHintVisible, isTrue);
      controller.toggleCoachHint();
      expect(container.read(simulationControllerProvider(scenarioId)).coachHintVisible, isFalse);
    });
  });
}

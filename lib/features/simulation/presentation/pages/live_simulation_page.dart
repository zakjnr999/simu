import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/progress/simu_progress_bar.dart';
import 'package:simu/features/simulation/domain/entities/simulation_turn.dart';
import 'package:simu/features/simulation/presentation/controllers/simulation_controller.dart';
import 'package:simu/features/simulation/presentation/state/simulation_state.dart';
import 'package:simu/features/simulation/presentation/widgets/simulation_coach_bar.dart';
import 'package:simu/features/simulation/presentation/widgets/simulation_dialogue_bubble.dart';
import 'package:simu/features/simulation/presentation/widgets/simulation_input_panel.dart';
import 'package:simu/features/simulation/presentation/widgets/simulation_interviewer_stage.dart';

/// Interactive live simulation screen running the multi-turn scenario state machine.
class LiveSimulationPage extends ConsumerStatefulWidget {
  const LiveSimulationPage({
    super.key,
    required this.scenarioId,
  });

  final String scenarioId;

  @override
  ConsumerState<LiveSimulationPage> createState() => _LiveSimulationPageState();
}

class _LiveSimulationPageState extends ConsumerState<LiveSimulationPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _confirmExit(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Simulation?'),
        content: const Text(
          'Your current progress in this challenge will be reset.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldExit == true && context.mounted) {
      ref.read(simulationControllerProvider(widget.scenarioId).notifier).resetSimulation();
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(simulationControllerProvider(widget.scenarioId));
    final controller =
        ref.read(simulationControllerProvider(widget.scenarioId).notifier);

    // Auto-navigate to results upon completion
    ref.listen<SimulationState>(
      simulationControllerProvider(widget.scenarioId),
      (prev, next) {
        if (next.isCompleted && !(prev?.isCompleted ?? false)) {
          final resultsRoute = RouteNames.simulationResults
              .replaceAll(':id', widget.scenarioId);
          context.pushReplacement(resultsRoute);
        } else if (next.turns.length != (prev?.turns.length ?? 0)) {
          _scrollToBottom();
        }
      },
    );

    final userTurnCount =
        state.turns.where((t) => t.speaker == TurnSpeaker.user).length;
    final progress =
        (userTurnCount / state.scenario.maxTurns).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.x, color: AppColors.textPrimary),
          onPressed: () => _confirmExit(context),
        ),
        title: Column(
          children: [
            Text(
              state.scenario.title,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Turn ${userTurnCount + 1} of ${state.scenario.maxTurns}',
              style: AppTypography.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: SimuProgressBar(
            progress: progress,
            height: 4,
            backgroundColor: AppColors.borderLight,
            fillColor: AppColors.primary,
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. Scenario partner stage card
          SimulationInterviewerStage(
            scenario: state.scenario,
            status: state.status,
          ),

          // 2. Ace coaching advice banner (collapsible)
          SimulationCoachBar(
            coachTip: state.scenario.aceGuidance,
            isVisible: state.coachHintVisible,
            onToggle: controller.toggleCoachHint,
          ),

          // 3. Dialogue Stream
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.turns.length +
                  (state.status == SimulationStatus.thinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.turns.length) {
                  return SimulationThinkingBubble(
                    interviewerName: state.scenario.interviewerName,
                  );
                }
                final turn = state.turns[index];
                return SimulationDialogueBubble(
                  turn: turn,
                  interviewerName: state.scenario.interviewerName,
                  interviewerRole: state.scenario.interviewerRole,
                );
              },
            ),
          ),

          // 4. Interactive Input Panel (Voice & Text)
          SimulationInputPanel(
            status: state.status,
            isVoiceMode: state.isVoiceMode,
            isMicActive: state.isMicActive,
            currentText: state.currentInputText,
            suggestions: state.scenario.turnSuggestions[userTurnCount + 1] ?? const [],
            onTextChanged: controller.updateInputText,
            onSubmit: (text) => controller.submitUserResponse(
              text,
              isVoice: state.isVoiceMode,
            ),
            onToggleVoiceMode: controller.toggleVoiceMode,
            onToggleMic: controller.toggleMic,
          ),
        ],
      ),
    );
  }
}

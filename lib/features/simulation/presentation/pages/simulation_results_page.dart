import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/actions/simu_primary_action.dart';
import 'package:simu/design_system/components/actions/simu_secondary_action.dart';
import 'package:simu/design_system/components/badges/simu_badge.dart';
import 'package:simu/design_system/components/layout/simu_page_header.dart';
import 'package:simu/design_system/components/layout/simu_scaffold.dart';
import 'package:simu/design_system/components/mascot/simu_mascot.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_state.dart';
import 'package:simu/design_system/components/progress/simu_progress_bar.dart';
import 'package:simu/design_system/components/cards/simu_tactile_card.dart';
import 'package:simu/features/progression/presentation/providers/user_progression_provider.dart';
import 'package:simu/features/simulation/domain/entities/simulation_evaluation.dart';
import 'package:simu/features/simulation/presentation/controllers/simulation_controller.dart';

/// Screen — Structured simulation results & feedback separating emotional payoff from analysis.
class SimulationResultsPage extends ConsumerWidget {
  const SimulationResultsPage({
    super.key,
    required this.scenarioId,
  });

  final String scenarioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(simulationControllerProvider(scenarioId));
    final evaluation = state.evaluation;

    // Fallback if accessed directly
    final eval = evaluation ??
        SimulationEvaluation(
          evaluationId: 'eval-fallback',
          scenarioId: scenarioId,
          overallScore: 88,
          headline: 'Impressive Poise & Structure!',
          summary:
              'You established authority early, avoided rambling, and anchored your answers to concrete impact.',
          dimensions: const [
            EvaluationDimension(
              name: 'Clarity & Structure',
              score: 92,
              feedback: 'Concise, clean narrative flow with zero filler words.',
            ),
            EvaluationDimension(
              name: 'Executive Presence',
              score: 85,
              feedback: 'Confident tone, active listening, and calm pacing.',
            ),
            EvaluationDimension(
              name: 'Relevance & Value',
              score: 87,
              feedback: 'Directly linked past achievements to the company mission.',
            ),
          ],
          strengths: const [
            'Used a crisp Present-Past-Future structure.',
            'Quickly quantified impact instead of just listing duties.',
            'Maintained composure during follow-up questioning.',
          ],
          weaknesses: const [
            'Could tighten the transition between your second and third points.',
            'Consider pausing briefly before answering tough follow-ups.',
          ],
          improvedExamples: const [
            'Instead of: "I did a lot of cross-functional alignment..."\nTry: "I unified three engineering squads around a single quarterly launch goal."',
          ],
          recommendedDrillTitle: '30-Second Concise Impact Drill',
          recommendedDrillDescription:
              'Practice condensing multi-month projects into 3 punchy sentences.',
          xpEarned: 180,
        );

    return SimuScaffold(
      bottomAction: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SimuPrimaryAction(
            label: 'Claim +${eval.xpEarned} XP & Continue',
            icon: const Icon(LucideIcons.sparkles, color: Colors.white, size: 18),
            onPressed: () {
              ref.read(userProgressionProvider.notifier).claimReward(
                    scenarioId: scenarioId,
                    amount: eval.xpEarned,
                    reason: eval.headline,
                  );
              context.go(RouteNames.home);
            },
          ),
          const SizedBox(height: 8),
          SimuSecondaryAction(
            label: 'Practice Again',
            onPressed: () {
              ref
                  .read(simulationControllerProvider(scenarioId).notifier)
                  .resetSimulation();
              context.pushReplacement(
                RouteNames.simulation.replaceAll(':id', scenarioId),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimuPageHeader(
            title: 'Performance Review',
            subtitle: state.scenario.title,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Emotional Payoff Section (Ace celebration & XP burst)
                  SimuTactileCard(
                    showOuterShadow: false,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SimuMascot(
                          size: 80,
                          state: MascotState.celebrating,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          eval.headline,
                          textAlign: TextAlign.center,
                          style: AppTypography.heading1.copyWith(
                            fontSize: 22,
                            color: const Color(0xFF262554),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          eval.summary,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentYellowLight,
                                borderRadius: AppRadii.roundedPill,
                                border: Border.all(
                                  color: AppColors.accentYellow,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    LucideIcons.sparkles,
                                    size: 16,
                                    color: AppColors.depthYellow,
                                  ),
                                  const SizedBox(width: 6),
                                  _AnimatedXpCounter(targetXp: eval.xpEarned),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: AppRadii.roundedPill,
                                border: Border.all(
                                  color: AppColors.primaryLight,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    LucideIcons.award,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${eval.overallScore} / 100',
                                    style: AppTypography.titleSmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 2. Analytical Dimension Breakdown
                  SimuTactileCard(
                    showOuterShadow: false,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.barChart3,
                              size: 16,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'SKILL BREAKDOWN',
                              style: AppTypography.caption.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...eval.dimensions.map((dim) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      dim.name,
                                      style: AppTypography.titleSmall.copyWith(
                                        fontSize: 13,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '${dim.score}%',
                                      style: AppTypography.titleSmall.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                SimuProgressBar(
                                  progress: dim.score / 100.0,
                                  height: 6,
                                  fillColor: dim.score >= 90
                                      ? AppColors.accentGreen
                                      : AppColors.primary,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dim.feedback,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 3. What Went Well & Areas for Growth
                  SimuTactileCard(
                    showOuterShadow: false,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Strengths
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.checkCircle2,
                              size: 16,
                              color: AppColors.accentGreen,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'KEY STRENGTHS',
                              style: AppTypography.caption.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: AppColors.depthGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...eval.strengths.map((strength) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ',
                                    style: TextStyle(
                                        color: AppColors.accentGreen,
                                        fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    strength,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 12),
                        const Divider(color: AppColors.borderLight, height: 1),
                        const SizedBox(height: 12),

                        // Growth Areas
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.lightbulb,
                              size: 16,
                              color: AppColors.accentYellow,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'AREAS FOR GROWTH',
                              style: AppTypography.caption.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                color: AppColors.depthYellow,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...eval.weaknesses.map((weakness) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ',
                                    style: TextStyle(
                                        color: AppColors.accentYellow,
                                        fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    weakness,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 4. Targeted Micro-Drill Recommendation (Actionable closing)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCream,
                      borderRadius: AppRadii.roundedLg,
                      border: Border.all(
                        color: AppColors.accentYellowLight,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.accentYellowLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.accentYellow,
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            LucideIcons.zap,
                            size: 20,
                            color: AppColors.depthYellow,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 6,
                                runSpacing: 2,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'RECOMMENDED DRILL',
                                    style: AppTypography.caption.copyWith(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.depthYellow,
                                    ),
                                  ),
                                  const SimuBadge(
                                    text: '3 min',
                                    backgroundColor: Colors.white,
                                    textColor: AppColors.textPrimary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                eval.recommendedDrillTitle,
                                style: AppTypography.titleSmall.copyWith(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                eval.recommendedDrillDescription,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedXpCounter extends StatelessWidget {
  const _AnimatedXpCounter({required this.targetXp});

  final int targetXp;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: targetXp),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Text(
          '+$value XP',
          style: AppTypography.xp.copyWith(
            fontSize: 16,
            color: AppColors.depthYellow,
          ),
        );
      },
    );
  }
}

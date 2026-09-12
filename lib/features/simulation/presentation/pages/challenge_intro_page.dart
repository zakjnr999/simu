import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/actions/simu_primary_action.dart';
import 'package:simu/design_system/components/badges/simu_badge.dart';
import 'package:simu/design_system/components/cards/simu_tactile_card.dart';
import 'package:simu/design_system/components/layout/simu_page_header.dart';
import 'package:simu/design_system/components/layout/simu_scaffold.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_guidance_bar.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_state.dart';
import 'package:simu/features/simulation/data/repositories/mock_simulation_repository.dart';
import 'package:simu/features/simulation/domain/entities/challenge_scenario.dart';

/// Screen — Challenge Intro establishing mission context, objective, reward, and Ace tips.
class ChallengeIntroPage extends ConsumerWidget {
  const ChallengeIntroPage({
    super.key,
    required this.scenarioId,
  });

  final String scenarioId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(simulationRepositoryProvider);

    return FutureBuilder<ChallengeScenario?>(
      future: repository.getScenario(scenarioId),
      builder: (context, snapshot) {
        final scenario = snapshot.data;

        if (scenario == null) {
          return const SimuScaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return SimuScaffold(
          bottomAction: SimuPrimaryAction(
            label: 'Start Simulation',
            icon: const Icon(LucideIcons.play, color: Colors.white, size: 18),
            onPressed: () {
              context.push(RouteNames.simulation.replaceAll(':id', scenario.id));
            },
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SimuPageHeader(
                title: 'Mission Brief',
                subtitle: scenario.category.displayName,
                onBack: () => context.pop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Hero Scenario Title Card
                      SimuTactileCard(
                        showOuterShadow: false,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SimuBadge(
                                  text: scenario.category.displayName.toUpperCase(),
                                  backgroundColor: AppColors.primaryContainer,
                                  textColor: AppColors.onPrimaryContainer,
                                ),
                                const Spacer(),
                                SimuBadge(
                                  text: '+${scenario.xpReward} XP',
                                  backgroundColor: AppColors.accentYellowLight,
                                  textColor: AppColors.depthYellow,
                                  icon: const Icon(
                                    LucideIcons.sparkles,
                                    size: 12,
                                    color: AppColors.accentYellow,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              scenario.title,
                              style: AppTypography.displayLarge.copyWith(
                                fontSize: 24,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              scenario.situationSetup,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 2. Mission Quest / Objective
                      SimuTactileCard(
                        showOuterShadow: false,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  LucideIcons.target,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'YOUR MISSION OBJECTIVE',
                                  style: AppTypography.caption.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              scenario.userObjective,
                              style: AppTypography.bodyLargeSemiBold.copyWith(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(color: AppColors.borderLight, height: 1),
                            const SizedBox(height: 12),
                            Text(
                              'Skills Focused In This Challenge',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textTertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: scenario.skillsPracticed.map((skill) {
                                return SimuBadge(
                                  text: skill,
                                  backgroundColor: AppColors.surfaceMuted,
                                  textColor: AppColors.textPrimary,
                                  borderColor: AppColors.border,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 3. Scenario Partner Info Card
                      SimuTactileCard(
                        showOuterShadow: false,
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  scenario.interviewerName.isNotEmpty
                                      ? scenario.interviewerName[0]
                                      : 'I',
                                  style: AppTypography.heading2.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Interviewer / Partner',
                                    style: AppTypography.caption.copyWith(
                                      fontSize: 10,
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                  Text(
                                    '${scenario.interviewerName} • ${scenario.interviewerRole}',
                                    style: AppTypography.titleSmall.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    scenario.interviewerCompany,
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 4. Ace's Strategic Tip
                      SimuMascotGuidanceBar(
                        message: scenario.aceGuidance,
                        mascotSize: 50,
                        mascotState: MascotState.encouraging,
                        backgroundColor: AppColors.surfaceCream,
                        borderColor: AppColors.accentYellowLight,
                        textColor: const Color(0xFF5D4037),
                      ),

                      const SizedBox(height: 16),

                      // 5. Quick Metadata Pills (Difficulty, Est. Time)
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                borderRadius: AppRadii.roundedMd,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'DIFFICULTY',
                                    style: AppTypography.caption.copyWith(
                                      fontSize: 9,
                                      color: AppColors.textTertiary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    scenario.difficulty.label,
                                    style: AppTypography.titleSmall.copyWith(
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceMuted,
                                borderRadius: AppRadii.roundedMd,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'EST. DURATION',
                                    style: AppTypography.caption.copyWith(
                                      fontSize: 9,
                                      color: AppColors.textTertiary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${scenario.durationMinutes} minutes',
                                    style: AppTypography.titleSmall.copyWith(
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

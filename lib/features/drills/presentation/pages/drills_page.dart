import 'package:flutter/material.dart';
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
import 'package:simu/features/drills/domain/entities/drill_item.dart';
import 'package:simu/features/simulation/domain/entities/challenge_scenario.dart';

/// Screen — Targeted Drills hub for rapid micro-practice sessions.
class DrillsPage extends StatefulWidget {
  const DrillsPage({super.key});

  @override
  State<DrillsPage> createState() => _DrillsPageState();
}

class _DrillsPageState extends State<DrillsPage> {
  String _selectedFilter = 'All';

  static const List<DrillItem> _allDrills = [
    DrillItem(
      id: 'drill-star-rapid',
      title: 'STAR Method Rapid Fire',
      targetWeakness: 'Rambling past the situation setup without stating results',
      framework: 'STAR FRAMEWORK',
      durationSeconds: 45,
      difficulty: ChallengeDifficulty.intermediate,
      xpReward: 40,
      iconEmoji: '⚡',
      scenarioId: 'interview-tell-me-about-yourself',
      description:
          'Deliver Situation, Task, Action, and quantifiable Result in under 45 seconds.',
    ),
    DrillItem(
      id: 'drill-pitch-30',
      title: '30-Second Executive Pitch',
      targetWeakness: 'Unclear opening value proposition',
      framework: 'PRESENT-PAST-FUTURE',
      durationSeconds: 30,
      difficulty: ChallengeDifficulty.beginner,
      xpReward: 35,
      iconEmoji: '⏱️',
      scenarioId: 'interview-tell-me-about-yourself',
      description:
          'Hook the interviewer in 3 sentences: who you are, what you accomplished, and why you are here.',
    ),
    DrillItem(
      id: 'drill-salary-anchor',
      title: 'Salary Anchor Rebuttal',
      targetWeakness: 'Freezing when confronted with an initial below-market offer',
      framework: 'VALUE ANCHORING',
      durationSeconds: 60,
      difficulty: ChallengeDifficulty.advanced,
      xpReward: 50,
      iconEmoji: '🤝',
      scenarioId: 'negotiation-respond-to-low-offer',
      description:
          'Acknowledge the offer positively, pivot to market data, and anchor higher without sounding confrontational.',
    ),
    DrillItem(
      id: 'drill-technical-clarify',
      title: 'Clarifying Ambiguity Drill',
      targetWeakness: 'Jumping straight to code before understanding constraints',
      framework: 'FIVE WHYS',
      durationSeconds: 45,
      difficulty: ChallengeDifficulty.beginner,
      xpReward: 40,
      iconEmoji: '💻',
      scenarioId: 'technical-clarify-requirements',
      description:
          'Identify the 3 missing requirements in the client specification before proposing an architecture.',
    ),
    DrillItem(
      id: 'drill-simple-explanation',
      title: 'ELIF5 Tech Concept',
      targetWeakness: 'Over-indexing on jargon when speaking to non-technical stakeholders',
      framework: 'EXECUTIVE EMPATHY',
      durationSeconds: 60,
      difficulty: ChallengeDifficulty.intermediate,
      xpReward: 45,
      iconEmoji: '💬',
      scenarioId: 'communication-speak-clearly',
      description:
          'Explain an API or distributed queue to a VP of Marketing using a real-world everyday metaphor.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredDrills = _filterDrills();

    return SimuScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimuPageHeader(
            title: 'Targeted Drills',
            subtitle: 'Rapid 30–90 second conversational workouts',
            onBack: () => context.pop(),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                // 1. Ace Coach Advice
                const SimuMascotGuidanceBar(
                  mascotSize: 48,
                  message:
                      'Micro-drills sharpen muscle memory! Isolate a single conversational reflex and repeat it until second nature.',
                ),

                const SizedBox(height: 16),

                // 2. Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('⚡ 30–45s'),
                      _buildFilterChip('🎯 Structural'),
                      _buildFilterChip('🤝 Negotiation'),
                      _buildFilterChip('💻 Technical'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3. Drill Cards List
                ...filteredDrills.map((drill) => _buildDrillCard(context, drill)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<DrillItem> _filterDrills() {
    if (_selectedFilter == '⚡ 30–45s') {
      return _allDrills.where((d) => d.durationSeconds <= 45).toList();
    }
    if (_selectedFilter == '🎯 Structural') {
      return _allDrills.where((d) => d.framework.contains('STAR') || d.framework.contains('PRESENT')).toList();
    }
    if (_selectedFilter == '🤝 Negotiation') {
      return _allDrills.where((d) => d.framework.contains('ANCHOR')).toList();
    }
    if (_selectedFilter == '💻 Technical') {
      return _allDrills.where((d) => d.framework.contains('FIVE') || d.framework.contains('EMPATHY')).toList();
    }
    return _allDrills;
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: AppTypography.caption.copyWith(
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.surfaceMuted,
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: 1,
        ),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.roundedPill),
        onSelected: (_) => setState(() => _selectedFilter = label),
      ),
    );
  }

  Widget _buildDrillCard(BuildContext context, DrillItem drill) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: SimuTactileCard(
        showOuterShadow: false,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                SimuBadge(
                  text: drill.framework,
                  backgroundColor: AppColors.primaryContainer,
                  textColor: AppColors.primary,
                ),
                SimuBadge(
                  text: drill.durationLabel,
                  backgroundColor: AppColors.surfaceMuted,
                  textColor: AppColors.textSecondary,
                  icon: const Icon(LucideIcons.timer, size: 11, color: AppColors.textSecondary),
                ),
                SimuBadge(
                  text: '+${drill.xpReward} XP',
                  backgroundColor: AppColors.accentYellowLight,
                  textColor: AppColors.depthYellow,
                  icon: const Icon(LucideIcons.sparkles, size: 11, color: AppColors.accentYellow),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(drill.iconEmoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    drill.title,
                    style: AppTypography.heading3.copyWith(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              drill.description,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: AppRadii.roundedSm,
                border: Border.all(color: const Color(0xFFFFE082), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.target, size: 13, color: Color(0xFFF57F17)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Targets: ${drill.targetWeakness}',
                      style: AppTypography.caption.copyWith(
                        color: const Color(0xFFF57F17),
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SimuPrimaryAction(
              label: 'Start Micro-Drill (${drill.durationLabel})',
              icon: const Icon(LucideIcons.play, color: Colors.white, size: 16),
              onPressed: () {
                context.push(
                  RouteNames.simulationIntro.replaceAll(':id', drill.scenarioId),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

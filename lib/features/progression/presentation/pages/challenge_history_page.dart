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
import 'package:simu/design_system/components/states/simu_empty_state.dart';
import 'package:simu/design_system/components/cards/simu_tactile_card.dart';
import 'package:simu/features/progression/domain/entities/practice_history_item.dart';
import 'package:simu/features/progression/presentation/providers/user_progression_provider.dart';

/// Screen — Filterable list of previous practice sessions with replay & review capabilities.
class ChallengeHistoryPage extends ConsumerStatefulWidget {
  const ChallengeHistoryPage({super.key});

  @override
  ConsumerState<ChallengeHistoryPage> createState() =>
      _ChallengeHistoryPageState();
}

class _ChallengeHistoryPageState extends ConsumerState<ChallengeHistoryPage> {
  PracticeHistoryStatus? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final progression = ref.watch(userProgressionProvider);
    final history = progression.history;

    final filteredList = _selectedFilter == null
        ? history
        : history.where((item) => item.status == _selectedFilter).toList();

    return SimuScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimuPageHeader(
            title: 'Practice History',
            subtitle: 'Review performance insights and replay past simulations',
            onBack: () => context.pop(),
          ),

          // 1. Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'All (${history.length})',
                  isSelected: _selectedFilter == null,
                  onSelected: () => setState(() => _selectedFilter = null),
                ),
                const SizedBox(width: 8),
                ...PracticeHistoryStatus.values.map((status) {
                  final count =
                      history.where((item) => item.status == status).length;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildFilterChip(
                      label: '${status.label} ($count)',
                      isSelected: _selectedFilter == status,
                      onSelected: () => setState(() => _selectedFilter = status),
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // 2. History List
          Expanded(
            child: filteredList.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      return _HistorySessionCard(
                        item: item,
                        onReview: () {
                          context.push(
                            RouteNames.simulationResults
                                .replaceAll(':id', item.scenarioId),
                          );
                        },
                        onReplay: () {
                          context.push(
                            RouteNames.simulationIntro
                                .replaceAll(':id', item.scenarioId),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
  }) {
    return ActionChip(
      label: Text(
        label,
        style: AppTypography.caption.copyWith(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: isSelected ? AppColors.primary : AppColors.surface,
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
        width: 1.5,
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.roundedPill),
      onPressed: onSelected,
    );
  }

  Widget _buildEmptyState() {
    return SimuEmptyState(
      title: 'No Sessions Found',
      description: 'You have no sessions matching the selected filter.',
      actionLabel: 'Show All Sessions',
      onAction: () => setState(() => _selectedFilter = null),
    );
  }
}

class _HistorySessionCard extends StatelessWidget {
  const _HistorySessionCard({
    required this.item,
    required this.onReview,
    required this.onReplay,
  });

  final PracticeHistoryItem item;
  final VoidCallback onReview;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SimuTactileCard(
        showOuterShadow: false,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row: Category & Status Badges
            Wrap(
              spacing: 6,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SimuBadge(
                  text: item.category.displayName.toUpperCase(),
                  backgroundColor: AppColors.primaryContainer,
                  textColor: AppColors.primary,
                ),
                SimuBadge(
                  text: item.status.label.toUpperCase(),
                  backgroundColor: item.status == PracticeHistoryStatus.completed
                      ? AppColors.accentGreen.withValues(alpha: 0.15)
                      : AppColors.surfaceMuted,
                  textColor: item.status == PracticeHistoryStatus.completed
                      ? AppColors.accentGreen
                      : AppColors.textSecondary,
                ),
                SimuBadge(
                  text: '+${item.xpEarned} XP',
                  backgroundColor: AppColors.accentYellowLight,
                  textColor: AppColors.depthYellow,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Scenario Title & Score
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.scenarioTitle,
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.headline,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: AppRadii.roundedMd,
                    border: Border.all(color: AppColors.primaryLight, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${item.score}',
                        style: AppTypography.titleSmall.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'SCORE',
                        style: AppTypography.caption.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Highlights
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.checkCircle2,
                        size: 14, color: AppColors.accentGreen),
                    const SizedBox(width: 4),
                    Text(
                      '${item.strengthsCount} Strengths',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.trendingUp,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${item.growthCount} Growth Areas',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Actions
            Row(
              children: [
                Expanded(
                  child: SimuSecondaryAction(
                    label: 'Review Feedback',
                    icon: const Icon(LucideIcons.clipboardList, size: 15),
                    onPressed: onReview,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SimuPrimaryAction(
                    label: 'Replay Practice',
                    icon: const Icon(LucideIcons.rotateCcw, color: Colors.white, size: 15),
                    onPressed: onReplay,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

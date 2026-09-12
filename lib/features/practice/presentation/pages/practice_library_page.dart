import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/badges/simu_badge.dart';
import 'package:simu/design_system/components/layout/simu_scaffold.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_guidance_bar.dart';
import 'package:simu/features/home/presentation/widgets/home_header_bar.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/design_system/components/cards/simu_tactile_card.dart';
import 'package:simu/features/practice/presentation/providers/practice_provider.dart';
import 'package:simu/features/practice/presentation/widgets/practice_category_card.dart';
import 'package:simu/features/progression/presentation/providers/user_progression_provider.dart';

/// Screen — Explore Practice Hub enabling multi-practice discovery.
class PracticeLibraryPage extends ConsumerStatefulWidget {
  const PracticeLibraryPage({super.key});

  @override
  ConsumerState<PracticeLibraryPage> createState() => _PracticeLibraryPageState();
}

class _PracticeLibraryPageState extends ConsumerState<PracticeLibraryPage> {
  UserGoalCategory? _selectedCategoryFilter;

  @override
  Widget build(BuildContext context) {
    final summaries = ref.watch(practiceSummariesProvider);
    final progression = ref.watch(userProgressionProvider);

    final filteredSummaries = _selectedCategoryFilter == null
        ? summaries
        : summaries
            .where((s) => s.definition.category == _selectedCategoryFilter)
            .toList();

    final primarySummary = summaries.firstWhere(
      (s) => s.isPrimary,
      orElse: () => summaries.first,
    );

    return SimuScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Home Header Bar (XP & Notification Bell)
          HomeHeaderBar(
            totalXp: progression.totalXp,
            unreadNotificationCount: 2,
          ),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                // 2. Hero Ace Coaching Header
                _buildHeroBanner(),

                const SizedBox(height: 12),

                // 2b. Quick Micro-Drills Banner
                SimuTactileCard(
                  showOuterShadow: false,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  onTap: () => context.push(RouteNames.drills),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: AppRadii.roundedMd,
                        ),
                        child: const Center(
                          child: Text('⚡', style: TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Targeted Micro-Drills (30–60s)',
                              style: AppTypography.titleSmall.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Practice single reflexes with time pressure',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.chevronRight,
                          size: 18, color: AppColors.primary),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // 3. Category Filter Chips
                _buildCategoryFilters(summaries),

                const SizedBox(height: 16),

                // 4. Primary Journey Quick Highlight
                if (_selectedCategoryFilter == null ||
                    _selectedCategoryFilter == primarySummary.definition.category)
                  _buildPrimaryHighlightCard(context, primarySummary),

                const SizedBox(height: 16),

                // 5. Practice Catalog List
                Text(
                  'ALL PRACTICE CATEGORIES',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),

                ...filteredSummaries.map(
                  (summary) => PracticeCategoryCard(
                    summary: summary,
                    onTap: () {
                      context.push(
                        RouteNames.practiceCategory.replaceAll(
                          ':category',
                          summary.definition.category.name,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner() {
    return const SimuMascotGuidanceBar(
      mascotSize: 52,
      message:
          'Explore other domains anytime! Your primary journey remains saved and active.',
    );
  }

  Widget _buildCategoryFilters(List<PracticeProgressSummary> summaries) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildFilterChip(
            label: 'All (${summaries.length})',
            isSelected: _selectedCategoryFilter == null,
            onSelected: () => setState(() => _selectedCategoryFilter = null),
          ),
          const SizedBox(width: 8),
          ...summaries.map((s) {
            final cat = s.definition.category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterChip(
                label: '${s.definition.iconEmoji} ${s.definition.title}',
                isSelected: _selectedCategoryFilter == cat,
                onSelected: () => setState(() => _selectedCategoryFilter = cat),
              ),
            );
          }),
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

  Widget _buildPrimaryHighlightCard(
    BuildContext context,
    PracticeProgressSummary primary,
  ) {
    return SimuTactileCard(
      showOuterShadow: false,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: AppRadii.roundedMd,
              border: Border.all(color: AppColors.primaryLight, width: 1.5),
            ),
            child: Center(
              child: Text(
                primary.definition.iconEmoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    const SimuBadge(
                      text: 'YOUR MAIN FOCUS',
                      backgroundColor: AppColors.primaryContainer,
                      textColor: AppColors.primary,
                    ),
                    Text(
                      '${primary.completedCount}/${primary.totalCount} Done',
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  primary.definition.title,
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(LucideIcons.arrowUpRight, color: AppColors.primary, size: 20),
            onPressed: () => context.go(RouteNames.journeyHub),
          ),
        ],
      ),
    );
  }
}

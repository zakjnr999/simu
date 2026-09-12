import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/router/route_names.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/badges/simu_badge.dart';
import 'package:simu/design_system/components/cards/simu_tactile_card.dart';
import 'package:simu/design_system/components/layout/simu_scaffold.dart';
import 'package:simu/design_system/components/mascot/simu_mascot.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_state.dart';
import 'package:simu/features/home/presentation/widgets/home_header_bar.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';
import 'package:simu/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:simu/features/practice/domain/entities/practice_category_definition.dart';
import 'package:simu/features/practice/domain/practice_catalog.dart';
import 'package:simu/features/progression/presentation/providers/user_progression_provider.dart';

/// Screen — User Profile, statistics shortcuts, learning track, and practice settings.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _hapticsEnabled = true;
  bool _voiceDictationEnabled = true;
  bool _soundEffectsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final onboarding = ref.watch(onboardingControllerProvider);
    final progression = ref.watch(userProgressionProvider);
    final primaryCategory =
        onboarding.selectedGoal?.category ?? UserGoalCategory.interviews;
    final primaryPractice = PracticeCatalog.getByCategory(primaryCategory);

    return SimuScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Top Bar with XP & Notifications
          HomeHeaderBar(
            totalXp: progression.totalXp,
            unreadNotificationCount: 2,
          ),

          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              children: [
                // 2. Identity Hero Card
                _buildIdentityHero(progression),

                const SizedBox(height: 16),

                // 3. Primary Learning Track Card
                _buildPrimaryTrackCard(context, primaryPractice),

                const SizedBox(height: 20),

                // 4. Growth & Records Shortcuts
                Text(
                  'GROWTH & COLLECTIONS',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),

                _buildNavigationTile(
                  context,
                  title: 'My Growth & Stats',
                  subtitle: 'Competency breakdown and streak calendar',
                  icon: LucideIcons.chartColumn,
                  accentColor: AppColors.primary,
                  onTap: () => context.push(RouteNames.progress),
                ),
                _buildNavigationTile(
                  context,
                  title: 'Practice History',
                  subtitle:
                      '${progression.history.length} completed & replayable sessions',
                  icon: LucideIcons.history,
                  accentColor: const Color(0xFF00B894),
                  onTap: () => context.push(RouteNames.challengeHistory),
                ),
                _buildNavigationTile(
                  context,
                  title: 'Trophy Vault',
                  subtitle:
                      '${progression.unlockedAchievementsCount} of ${progression.achievements.length} achievements unlocked',
                  icon: LucideIcons.trophy,
                  accentColor: AppColors.depthYellow,
                  onTap: () => context.push(RouteNames.achievements),
                ),

                const SizedBox(height: 20),

                // 5. Practice & Device Preferences
                Text(
                  'PRACTICE PREFERENCES',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),

                SimuTactileCard(
                  showOuterShadow: false,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      _buildSwitchRow(
                        title: 'Tactile Haptic Feedback',
                        subtitle: 'Feel button taps & interactive responses',
                        icon: LucideIcons.smartphone,
                        value: _hapticsEnabled,
                        onChanged: (val) =>
                            setState(() => _hapticsEnabled = val),
                      ),
                      const Divider(height: 1, color: AppColors.borderLight),
                      _buildSwitchRow(
                        title: 'Voice Dictation Input',
                        subtitle: 'Allow speaking answers directly to AI partner',
                        icon: LucideIcons.mic,
                        value: _voiceDictationEnabled,
                        onChanged: (val) =>
                            setState(() => _voiceDictationEnabled = val),
                      ),
                      const Divider(height: 1, color: AppColors.borderLight),
                      _buildSwitchRow(
                        title: 'Sound Effects & Audio',
                        subtitle: 'Simulation ambiance and reward chimes',
                        icon: LucideIcons.volume2,
                        value: _soundEffectsEnabled,
                        onChanged: (val) =>
                            setState(() => _soundEffectsEnabled = val),
                      ),
                      const Divider(height: 1, color: AppColors.borderLight),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(LucideIcons.settings,
                            color: AppColors.primary, size: 20),
                        title: Text(
                          'Advanced Settings & Privacy',
                          style: AppTypography.titleSmall.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        subtitle: Text(
                          'Reminders schedule, cache & data controls',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        trailing: const Icon(LucideIcons.chevronRight,
                            size: 18, color: AppColors.textTertiary),
                        onTap: () => context.push(RouteNames.settings),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 6. App Info & Version
                Center(
                  child: Column(
                    children: [
                      const SimuMascot(
                        state: MascotState.idle,
                        size: 38,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Simu v1.0.0 (Build 42)',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textTertiary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Practice makes presence • Personal development platform',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 11,
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
    );
  }

  Widget _buildIdentityHero(UserProgressionState progression) {
    return SimuTactileCard(
      showOuterShadow: false,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryLight, width: 2),
            ),
            child: const Center(
              child: SimuMascot(
                state: MascotState.happy,
                size: 44,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alex Morgan',
                  style: AppTypography.heading3.copyWith(
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    SimuBadge(
                      text: 'LEVEL ${progression.userLevel} • Rising Star',
                      backgroundColor: AppColors.primaryContainer,
                      textColor: AppColors.primary,
                    ),
                    SimuBadge(
                      text: '${progression.streakDays}-Day Streak 🔥',
                      backgroundColor: const Color(0xFFFFECEB),
                      textColor: const Color(0xFFFF5252),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryTrackCard(
    BuildContext context,
    PracticeCategoryDefinition primaryPractice,
  ) {
    return SimuTactileCard(
      showOuterShadow: false,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primaryPractice.accentBgColor,
              borderRadius: AppRadii.roundedMd,
              border: Border.all(
                color: primaryPractice.accentColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                primaryPractice.iconEmoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SimuBadge(
                  text: 'PRIMARY LEARNING TRACK',
                  backgroundColor: AppColors.primaryContainer,
                  textColor: AppColors.primary,
                ),
                const SizedBox(height: 4),
                Text(
                  primaryPractice.title,
                  style: AppTypography.titleSmall.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.arrowRight, color: AppColors.primary),
            onPressed: () => context.go(RouteNames.practice),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: onTap,
        child: SimuTactileCard(
          showOuterShadow: false,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: AppRadii.roundedMd,
                ),
                child: Center(
                  child: Icon(icon, color: accentColor, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleSmall.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

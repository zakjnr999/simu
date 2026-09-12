import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/design_system/components/actions/simu_primary_action.dart';
import 'package:simu/design_system/components/badges/simu_badge.dart';
import 'package:simu/design_system/components/cards/simu_tactile_card.dart';
import 'package:simu/design_system/components/layout/simu_page_header.dart';
import 'package:simu/design_system/components/layout/simu_scaffold.dart';
import 'package:simu/design_system/components/mascot/simu_mascot.dart';
import 'package:simu/design_system/components/mascot/simu_mascot_state.dart';

/// Screen — Comprehensive settings for practice cadence, privacy retention, and account management.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Practice Cadence
  bool _remindersEnabled = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 30);
  final Set<int> _activeDays = {1, 2, 3, 4, 5}; // Mon-Fri
  bool _streakFreezeAlerts = true;

  // Audio & Haptics
  bool _voiceDictation = true;
  bool _autoSpeakAi = true;
  bool _haptics = true;
  bool _soundEffects = true;

  // Privacy & Retention
  String _transcriptRetention = '30 Days';

  final List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return SimuScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SimuPageHeader(
            title: 'Settings & Privacy',
            subtitle: 'Cadence, audio preferences, and data privacy',
            onBack: () => context.pop(),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                // 1. Practice Cadence & Schedule
                _buildSectionHeader('PRACTICE REMINDER SCHEDULE'),
                SimuTactileCard(
                  showOuterShadow: false,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSwitchTile(
                        title: 'Daily Practice Reminders',
                        subtitle: 'Ace notifies you to protect your streak',
                        icon: LucideIcons.bell,
                        value: _remindersEnabled,
                        onChanged: (val) => setState(() => _remindersEnabled = val),
                      ),
                      if (_remindersEnabled) ...[
                        const Divider(height: 20, color: AppColors.borderLight),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Reminder Time',
                                style: AppTypography.titleSmall.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _pickTime,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                              ),
                              icon: const Icon(LucideIcons.clock, size: 15, color: AppColors.primary),
                              label: Text(
                                _reminderTime.format(context),
                                style: AppTypography.titleSmall.copyWith(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Active Practice Days',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(7, (index) {
                            final isSelected = _activeDays.contains(index + 1);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    if (_activeDays.length > 1) {
                                      _activeDays.remove(index + 1);
                                    }
                                  } else {
                                    _activeDays.add(index + 1);
                                  }
                                });
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.surfaceMuted,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                    width: 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    _dayLabels[index],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const Divider(height: 20, color: AppColors.borderLight),
                        _buildSwitchTile(
                          title: 'Streak Freeze Alert',
                          subtitle: 'Warn before midnight if streak is at risk',
                          icon: LucideIcons.flame,
                          value: _streakFreezeAlerts,
                          onChanged: (val) => setState(() => _streakFreezeAlerts = val),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 2. Audio & Speech Settings
                _buildSectionHeader('SPEECH & INTERACTION'),
                SimuTactileCard(
                  showOuterShadow: false,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildSwitchTile(
                        title: 'Voice Dictation Input',
                        subtitle: 'Speak responses directly via microphone',
                        icon: LucideIcons.mic,
                        value: _voiceDictation,
                        onChanged: (val) => setState(() => _voiceDictation = val),
                      ),
                      const Divider(height: 16, color: AppColors.borderLight),
                      _buildSwitchTile(
                        title: 'Interviewer Voice Audio',
                        subtitle: 'Simulate conversational speech playback',
                        icon: LucideIcons.volume2,
                        value: _autoSpeakAi,
                        onChanged: (val) => setState(() => _autoSpeakAi = val),
                      ),
                      const Divider(height: 16, color: AppColors.borderLight),
                      _buildSwitchTile(
                        title: 'Tactile Haptic Feedback',
                        subtitle: 'Device vibrations on interactions',
                        icon: LucideIcons.smartphone,
                        value: _haptics,
                        onChanged: (val) => setState(() => _haptics = val),
                      ),
                      const Divider(height: 16, color: AppColors.borderLight),
                      _buildSwitchTile(
                        title: 'Sound Effects & Chimes',
                        subtitle: 'Reward celebrations and feedback tones',
                        icon: LucideIcons.sparkles,
                        value: _soundEffects,
                        onChanged: (val) => setState(() => _soundEffects = val),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Privacy & Transcript Retention
                _buildSectionHeader('PRIVACY & DATA GOVERNANCE'),
                SimuTactileCard(
                  showOuterShadow: false,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Transcript Retention',
                                  style: AppTypography.titleSmall.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Automatic deletion window for session transcripts',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DropdownButton<String>(
                            value: _transcriptRetention,
                            underline: const SizedBox(),
                            icon: const Icon(LucideIcons.chevronDown, size: 16),
                            style: AppTypography.titleSmall.copyWith(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                            items: const [
                              DropdownMenuItem(value: '7 Days', child: Text('7 Days')),
                              DropdownMenuItem(value: '30 Days', child: Text('30 Days')),
                              DropdownMenuItem(value: 'Indefinite', child: Text('Indefinite')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _transcriptRetention = val);
                            },
                          ),
                        ],
                      ),
                      const Divider(height: 20, color: AppColors.borderLight),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(LucideIcons.trash2, color: AppColors.textSecondary),
                        title: Text(
                          'Clear Simulation Cache',
                          style: AppTypography.titleSmall.copyWith(fontSize: 14),
                        ),
                        subtitle: Text(
                          'Free up temporary audio & session cache',
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                        ),
                        trailing: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Simulation cache cleared.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: const Text('Clear'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 4. Account & Danger Zone
                _buildSectionHeader('ACCOUNT & MEMBERSHIP'),
                SimuTactileCard(
                  showOuterShadow: false,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: AppRadii.roundedMd,
                            ),
                            child: const Center(
                              child: SimuMascot(
                                state: MascotState.idle,
                                size: 30,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SimuBadge(
                                  text: 'GUEST LEARNER',
                                  backgroundColor: AppColors.surfaceMuted,
                                  textColor: AppColors.textSecondary,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Local storage mode',
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => _showCloudSyncModal(context),
                            child: const Text('Link Account'),
                          ),
                        ],
                      ),
                      const Divider(height: 20, color: AppColors.borderLight),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(LucideIcons.userX, color: Color(0xFFFF5252)),
                        title: const Text(
                          'Delete Account & Data',
                          style: TextStyle(
                            color: Color(0xFFFF5252),
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: const Text(
                          'Irreversible purge of progress and session history',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        onTap: () => _showDeleteAccountDialog(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 5. Legal & About
                Center(
                  child: Wrap(
                    spacing: 16,
                    children: [
                      TextButton(
                        onPressed: () => _showInfoModal(context, 'Terms of Service', 'Simu Terms of Service:\n\nSimu is a practice platform designed to build communication and conversation skills through AI simulations. All simulation content and feedback are provided as learning aids and practice rubrics.'),
                        child: const Text('Terms of Service', style: TextStyle(fontSize: 12)),
                      ),
                      TextButton(
                        onPressed: () => _showInfoModal(context, 'Privacy Policy', 'Simu Privacy Policy:\n\nWe prioritize data minimization. Transcripts are stored locally and governed by your retention preferences. No microphone audio is stored without explicit opt-in.'),
                        child: const Text('Privacy Policy', style: TextStyle(fontSize: 12)),
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: AppTypography.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
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
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );
    if (picked != null) {
      setState(() => _reminderTime = picked);
    }
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Account & Data?'),
        content: const Text(
          'This action is irreversible. All completed simulations, XP, streaks, and achievements will be permanently erased.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account data purge completed.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );
  }

  void _showCloudSyncModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Link Account & Cloud Backup',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Safeguard your streaks and practice history across devices.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),
            SimuPrimaryAction(
              label: 'Continue with Apple',
              icon: const Icon(LucideIcons.apple, color: Colors.white, size: 18),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: const RoundedRectangleBorder(borderRadius: AppRadii.roundedMd),
              ),
              child: const Text('Continue with Google'),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoModal(BuildContext context, String title, String body) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTypography.heading3),
            const SizedBox(height: 12),
            Text(body, style: AppTypography.bodySmall.copyWith(height: 1.5)),
            const SizedBox(height: 20),
            SimuPrimaryAction(
              label: 'Close',
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

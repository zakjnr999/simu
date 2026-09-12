import 'package:flutter/material.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/features/simulation/domain/entities/challenge_scenario.dart';
import 'package:simu/features/simulation/presentation/state/simulation_state.dart';

/// Top stage card presenting the scenario partner and real-time state.
class SimulationInterviewerStage extends StatelessWidget {
  const SimulationInterviewerStage({
    super.key,
    required this.scenario,
    required this.status,
  });

  final ChallengeScenario scenario;
  final SimulationStatus status;

  String get _statusLabel {
    switch (status) {
      case SimulationStatus.listening:
        return 'Listening to you...';
      case SimulationStatus.thinking:
        return 'Thinking...';
      case SimulationStatus.speaking:
        return 'Speaking';
      case SimulationStatus.transcribing:
        return 'Processing audio...';
      case SimulationStatus.completed:
        return 'Interview Complete';
      default:
        return 'In Session';
    }
  }

  Color get _statusColor {
    switch (status) {
      case SimulationStatus.listening:
        return AppColors.accentGreen;
      case SimulationStatus.thinking:
        return AppColors.accentYellow;
      case SimulationStatus.speaking:
        return AppColors.primary;
      case SimulationStatus.completed:
        return AppColors.accentGreen;
      default:
        return AppColors.textTertiary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.roundedLg,
        border: Border.all(color: AppColors.border, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x081E1B4B),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
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
                    : 'P',
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      scenario.interviewerName,
                      style: AppTypography.titleMedium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: AppRadii.roundedPill,
                      ),
                      child: Text(
                        scenario.interviewerCompany,
                        style: AppTypography.caption.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  scenario.interviewerRole,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Live status chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.12),
              borderRadius: AppRadii.roundedPill,
              border: Border.all(
                color: _statusColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  _statusLabel,
                  style: AppTypography.caption.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/features/simulation/domain/entities/simulation_turn.dart';

/// Animated dialogue bubble for AI interviewer and user turns.
class SimulationDialogueBubble extends StatelessWidget {
  const SimulationDialogueBubble({
    super.key,
    required this.turn,
    required this.interviewerName,
    required this.interviewerRole,
  });

  final SimulationTurn turn;
  final String interviewerName;
  final String interviewerRole;

  bool get isUser => turn.speaker == TurnSpeaker.user;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutQuad,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 8 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              _InterviewerAvatar(name: interviewerName),
              const SizedBox(width: 10),
            ],
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 290),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isUser ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(AppRadii.lg),
                    topRight: const Radius.circular(AppRadii.lg),
                    bottomLeft:
                        Radius.circular(isUser ? AppRadii.lg : AppRadii.xs),
                    bottomRight:
                        Radius.circular(isUser ? AppRadii.xs : AppRadii.lg),
                  ),
                  border: isUser
                      ? null
                      : Border.all(
                          color: AppColors.border,
                          width: 1.5,
                        ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A1E1B4B),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isUser) ...[
                      Row(
                        children: [
                          Text(
                            interviewerName,
                            style: AppTypography.titleSmall.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '• $interviewerRole',
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.caption.copyWith(
                                fontSize: 10,
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                    ],
                    Text(
                      turn.text,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isUser ? Colors.white : AppColors.textPrimary,
                        height: 1.45,
                        fontWeight: isUser ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                    if (isUser && turn.inputMode == TurnInputMode.voice) ...[
                      const SizedBox(height: 4),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            LucideIcons.mic,
                            size: 11,
                            color: Color(0xFFD1C4E9),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Spoken',
                            style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 10,
                              color: Color(0xFFD1C4E9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (isUser) ...[
              const SizedBox(width: 10),
              const _UserAvatar(),
            ],
          ],
        ),
      ),
    );
  }
}

/// Animated 3-dot thinking indicator bubble displayed while interviewer is speaking/thinking.
class SimulationThinkingBubble extends StatefulWidget {
  const SimulationThinkingBubble({
    super.key,
    required this.interviewerName,
  });

  final String interviewerName;

  @override
  State<SimulationThinkingBubble> createState() =>
      _SimulationThinkingBubbleState();
}

class _SimulationThinkingBubbleState extends State<SimulationThinkingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InterviewerAvatar(name: widget.interviewerName),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadii.lg),
                topRight: Radius.circular(AppRadii.lg),
                bottomLeft: Radius.circular(AppRadii.xs),
                bottomRight: Radius.circular(AppRadii.lg),
              ),
              border: Border.all(color: AppColors.border, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A1E1B4B),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final delay = index * 0.2;
                    final progress = (_controller.value - delay) % 1.0;
                    final scale = 0.6 +
                        (0.4 *
                            (1.0 - (progress - 0.5).abs() * 2)
                                .clamp(0.0, 1.0));
                    return Container(
                      margin: EdgeInsets.only(right: index < 2 ? 5 : 0),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withValues(alpha: 0.3 + (0.7 * scale)),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _InterviewerAvatar extends StatelessWidget {
  const _InterviewerAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0] : 'S',
          style: AppTypography.heading3.copyWith(
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primaryLight, width: 1.5),
      ),
      child: const Center(
        child: Icon(
          LucideIcons.user,
          size: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

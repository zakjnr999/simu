import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/app/theme/app_colors.dart';
import 'package:simu/app/theme/app_radii.dart';
import 'package:simu/app/theme/app_typography.dart';
import 'package:simu/features/simulation/presentation/state/simulation_state.dart';

/// Visual states for the voice interaction state machine.
enum VoiceInputState {
  idle,
  listening,
  transcribing,
  review,
  thinking,
  speaking,
  permissionDenied,
  micUnavailable,
}

/// Interactive dual-mode input panel (Voice + Text) with complete voice interaction states.
class SimulationInputPanel extends StatefulWidget {
  const SimulationInputPanel({
    super.key,
    required this.status,
    required this.isVoiceMode,
    required this.isMicActive,
    required this.currentText,
    required this.onTextChanged,
    required this.onSubmit,
    required this.onToggleVoiceMode,
    required this.onToggleMic,
    this.suggestions = const [],
    this.forcedVoiceState,
  });

  final SimulationStatus status;
  final bool isVoiceMode;
  final bool isMicActive;
  final String currentText;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<String> onSubmit;
  final VoidCallback onToggleVoiceMode;
  final VoidCallback onToggleMic;
  final List<String> suggestions;
  final VoiceInputState? forcedVoiceState;

  @override
  State<SimulationInputPanel> createState() => _SimulationInputPanelState();
}

class _SimulationInputPanelState extends State<SimulationInputPanel>
    with TickerProviderStateMixin {
  late final TextEditingController _textController;
  late final AnimationController _pulseController;
  late final AnimationController _waveController;

  VoiceInputState _voiceState = VoiceInputState.idle;
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  String _reviewedTranscript = '';

  static const List<String> _defaultSuggestions = [
    'Present-Past-Future structure',
    'Quantify impact (+35% efficiency)',
    'Connect experience to company mission',
  ];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.currentText);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _updateVoiceState();
  }

  @override
  void didUpdateWidget(covariant SimulationInputPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentText != _textController.text) {
      _textController.text = widget.currentText;
    }
    if (widget.status != oldWidget.status ||
        widget.isMicActive != oldWidget.isMicActive ||
        widget.isVoiceMode != oldWidget.isVoiceMode ||
        widget.forcedVoiceState != oldWidget.forcedVoiceState) {
      _updateVoiceState();
    }
  }

  void _updateVoiceState() {
    if (widget.forcedVoiceState != null) {
      setState(() => _voiceState = widget.forcedVoiceState!);
      return;
    }

    if (widget.status == SimulationStatus.thinking) {
      _stopRecordingTimer();
      setState(() => _voiceState = VoiceInputState.thinking);
      return;
    }

    if (widget.status == SimulationStatus.speaking) {
      _stopRecordingTimer();
      setState(() => _voiceState = VoiceInputState.speaking);
      return;
    }

    if (widget.isMicActive) {
      if (_voiceState != VoiceInputState.listening) {
        _startRecordingTimer();
        setState(() => _voiceState = VoiceInputState.listening);
      }
    } else {
      _stopRecordingTimer();
      if (_voiceState == VoiceInputState.listening) {
        // Transition to review state with recognized mock speech
        setState(() {
          _voiceState = VoiceInputState.review;
          _reviewedTranscript = _textController.text.isNotEmpty
              ? _textController.text
              : 'I structure major initiatives with clear milestones and measurable business outcomes.';
        });
      } else if (_voiceState != VoiceInputState.review &&
          _voiceState != VoiceInputState.permissionDenied &&
          _voiceState != VoiceInputState.micUnavailable) {
        setState(() => _voiceState = VoiceInputState.idle);
      }
    }
  }

  void _startRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingSeconds = 0;
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _recordingSeconds++);
      }
    });
  }

  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _textController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmit(text);
      _textController.clear();
      setState(() => _voiceState = VoiceInputState.idle);
    }
  }

  void _handleSendReview() {
    final transcript = _reviewedTranscript.isNotEmpty
        ? _reviewedTranscript
        : 'I structure major initiatives with clear milestones and measurable business outcomes.';
    widget.onSubmit(transcript);
    setState(() {
      _reviewedTranscript = '';
      _voiceState = VoiceInputState.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isThinking = widget.status == SimulationStatus.thinking;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x0C1E1B4B),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Quick suggestion chips
              if (_voiceState != VoiceInputState.listening &&
                  _voiceState != VoiceInputState.review)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: (widget.suggestions.isNotEmpty
                            ? widget.suggestions
                            : _defaultSuggestions)
                        .map((suggestion) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6, bottom: 8),
                        child: ActionChip(
                          label: Text(
                            suggestion,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                          backgroundColor:
                              AppColors.primaryContainer.withValues(alpha: 0.5),
                          side: const BorderSide(
                            color: AppColors.borderLight,
                            width: 1,
                          ),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          onPressed: isThinking
                              ? null
                              : () {
                                  _textController.text =
                                      'Currently, I lead cross-functional initiatives focused on $suggestion.';
                                  widget.onTextChanged(_textController.text);
                                },
                        ),
                      );
                    }).toList(),
                  ),
                ),

              // 2. Main Input Area (Voice Mode vs Text Mode)
              if (widget.isVoiceMode)
                _buildVoiceArea(isThinking)
              else
                _buildTextArea(isThinking),

              const SizedBox(height: 6),

              // 3. Mode Switcher
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.isVoiceMode
                          ? '🎙️ Voice Practice Active'
                          : '⌨️ Text Response Mode',
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: isThinking ? null : widget.onToggleVoiceMode,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: Icon(
                      widget.isVoiceMode
                          ? LucideIcons.keyboard
                          : LucideIcons.mic,
                      size: 13,
                      color: AppColors.primary,
                    ),
                    label: Text(
                      widget.isVoiceMode ? 'Type instead' : 'Speak instead',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextArea(bool isThinking) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: _textController,
            enabled: !isThinking,
            maxLines: 4,
            minLines: 1,
            textCapitalization: TextCapitalization.sentences,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: isThinking
                  ? 'Interviewer is speaking...'
                  : 'Speak or type your response...',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              filled: true,
              fillColor: AppColors.surfaceMuted,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: const OutlineInputBorder(
                borderRadius: AppRadii.roundedLg,
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: AppRadii.roundedLg,
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
            onChanged: widget.onTextChanged,
            onSubmitted: (_) => _handleSend(),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isThinking ? AppColors.depthSecondary : AppColors.primary,
            borderRadius: AppRadii.roundedMd,
            boxShadow: isThinking
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x336C5CE7),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
          ),
          child: IconButton(
            tooltip: 'Send response',
            icon: isThinking
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(LucideIcons.send, color: Colors.white, size: 18),
            onPressed: isThinking ? null : _handleSend,
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceArea(bool isThinking) {
    switch (_voiceState) {
      case VoiceInputState.listening:
        return _buildListeningState();
      case VoiceInputState.transcribing:
        return _buildTranscribingState();
      case VoiceInputState.review:
        return _buildReviewState();
      case VoiceInputState.thinking:
        return _buildThinkingState();
      case VoiceInputState.speaking:
        return _buildSpeakingState();
      case VoiceInputState.permissionDenied:
        return _buildPermissionDeniedState();
      case VoiceInputState.micUnavailable:
        return _buildMicUnavailableState();
      case VoiceInputState.idle:
        return _buildIdleVoiceState(isThinking);
    }
  }

  Widget _buildIdleVoiceState(bool isThinking) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadii.roundedLg,
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: isThinking ? null : widget.onToggleMic,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x336C5CE7),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(LucideIcons.mic, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tap mic to start speaking',
                  style: AppTypography.titleSmall.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Natural speech-to-simulation practice',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListeningState() {
    final mins = (_recordingSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_recordingSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: AppRadii.roundedLg,
        border: Border.all(color: AppColors.accentCoral, width: 1.5),
      ),
      child: Row(
        children: [
          // Pulsing stop recording button
          GestureDetector(
            onTap: widget.onToggleMic,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.12),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      color: AppColors.accentCoral,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x44F43F5E),
                          blurRadius: 14,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(LucideIcons.square,
                        color: Colors.white, size: 20),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          // Waveform bars
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return Row(
                children: List.generate(5, (index) {
                  final height = 12.0 +
                      (16.0 *
                          ((_waveController.value + (index * 0.2)) % 1.0));
                  return Container(
                    width: 3.5,
                    height: height,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentCoral,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.accentCoral,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Recording $mins:$secs',
                      style: AppTypography.titleSmall.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentCoral,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Tap square when done',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: widget.onToggleMic,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentCoral,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.roundedMd,
              ),
            ),
            child: const Text('Done', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscribingState() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.3),
        borderRadius: AppRadii.roundedLg,
        border: Border.all(color: AppColors.primaryLight, width: 1.5),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Ace is transcribing your spoken answer...',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewState() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F7FF),
        borderRadius: AppRadii.roundedLg,
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.sparkles, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'VOICE TRANSCRIPT REVIEW',
                style: AppTypography.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => setState(() => _voiceState = VoiceInputState.listening),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: const Icon(LucideIcons.rotateCcw, size: 11, color: AppColors.textSecondary),
                label: const Text('Re-record', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '"$_reviewedTranscript"',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  _textController.text = _reviewedTranscript;
                  widget.onToggleVoiceMode();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                ),
                child: const Text('Edit as Text', style: TextStyle(fontSize: 11)),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _handleSendReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  minimumSize: Size.zero,
                ),
                icon: const Icon(LucideIcons.send, size: 13),
                label: const Text('Send Response', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThinkingState() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadii.roundedLg,
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Interviewer is listening & analyzing...',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakingState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.4),
        borderRadius: AppRadii.roundedLg,
        border: Border.all(color: AppColors.primaryLight, width: 1),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.volume2, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Interviewer audio speaking • 0:08',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Replay audio',
            icon: const Icon(LucideIcons.rotateCcw, size: 15, color: AppColors.primary),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Skip audio',
            icon: const Icon(LucideIcons.skipForward, size: 15, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedState() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECEB),
        borderRadius: AppRadii.roundedLg,
        border: Border.all(color: const Color(0xFFFF5252), width: 1),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.micOff, size: 20, color: Color(0xFFFF5252)),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Microphone Access Denied',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB71C1C),
                  ),
                ),
                Text(
                  'Enable microphone in Settings to speak',
                  style: TextStyle(fontSize: 10, color: Color(0xFFC62828)),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: widget.onToggleVoiceMode,
            child: const Text('Use Text', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildMicUnavailableState() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: AppRadii.roundedLg,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.alertCircle, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'No microphone detected on this device',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: widget.onToggleVoiceMode,
            child: const Text('Switch to Text', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

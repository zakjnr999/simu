import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:simu/features/simulation/presentation/state/simulation_state.dart';
import 'package:simu/features/simulation/presentation/widgets/simulation_input_panel.dart';

void main() {
  group('SimulationInputPanel Voice Interaction States', () {
    testWidgets('Renders idle voice mode and initiates recording when tapped',
        (tester) async {
      bool micToggled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimulationInputPanel(
              status: SimulationStatus.ready,
              isVoiceMode: true,
              isMicActive: false,
              currentText: '',
              onTextChanged: (_) {},
              onSubmit: (_) {},
              onToggleVoiceMode: () {},
              onToggleMic: () => micToggled = true,
            ),
          ),
        ),
      );

      expect(find.text('Tap mic to start speaking'), findsOneWidget);
      expect(find.text('🎙️ Voice Practice Active'), findsOneWidget);

      await tester.tap(find.byIcon(LucideIcons.mic));
      expect(micToggled, isTrue);
    });

    testWidgets('Renders active recording state with timer and waveform',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimulationInputPanel(
              status: SimulationStatus.ready,
              isVoiceMode: true,
              isMicActive: true,
              currentText: '',
              onTextChanged: (_) {},
              onSubmit: (_) {},
              onToggleVoiceMode: () {},
              onToggleMic: () {},
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.textContaining('Recording'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('Renders review transcript state with quick send',
        (tester) async {
      String submittedText = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimulationInputPanel(
              status: SimulationStatus.ready,
              isVoiceMode: true,
              isMicActive: false,
              currentText: '',
              forcedVoiceState: VoiceInputState.review,
              onTextChanged: (_) {},
              onSubmit: (val) => submittedText = val,
              onToggleVoiceMode: () {},
              onToggleMic: () {},
            ),
          ),
        ),
      );

      expect(find.text('VOICE TRANSCRIPT REVIEW'), findsOneWidget);
      expect(find.text('Send Response'), findsOneWidget);

      await tester.tap(find.text('Send Response'));
      expect(submittedText, isNotEmpty);
    });

    testWidgets('Renders permission denied state with fallback to text button',
        (tester) async {
      bool voiceToggled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SimulationInputPanel(
              status: SimulationStatus.ready,
              isVoiceMode: true,
              isMicActive: false,
              currentText: '',
              forcedVoiceState: VoiceInputState.permissionDenied,
              onTextChanged: (_) {},
              onSubmit: (_) {},
              onToggleVoiceMode: () => voiceToggled = true,
              onToggleMic: () {},
            ),
          ),
        ),
      );

      expect(find.text('Microphone Access Denied'), findsOneWidget);
      expect(find.text('Use Text'), findsOneWidget);

      await tester.tap(find.text('Use Text'));
      expect(voiceToggled, isTrue);
    });
  });
}

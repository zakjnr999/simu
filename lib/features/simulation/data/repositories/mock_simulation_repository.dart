import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simu/features/simulation/domain/entities/challenge_scenario.dart';
import 'package:simu/features/simulation/domain/entities/simulation_evaluation.dart';
import 'package:simu/features/simulation/domain/entities/simulation_turn.dart';
import 'package:simu/features/simulation/domain/repositories/simulation_repository.dart';

final simulationRepositoryProvider = Provider<SimulationRepository>((ref) {
  return MockSimulationRepository();
});

class MockSimulationRepository implements SimulationRepository {
  static const List<ChallengeScenario> _allScenarios = [
    ChallengeScenario(
      id: 'interview-tell-me-about-yourself',
      category: ChallengeCategory.interviews,
      title: 'Tell Me About Yourself',
      situationSetup:
          'You are in the first 5 minutes of a behavioral round with a VP at Aurora Tech.',
      userObjective:
          'Introduce your background with poise, highlight key achievements, and hook the interviewer.',
      interviewerName: 'Sarah Chen',
      interviewerRole: 'VP of Product',
      interviewerCompany: 'Aurora Tech',
      skillsPracticed: ['Clarity', 'Confidence', 'Story Hook'],
      difficulty: ChallengeDifficulty.beginner,
      durationMinutes: 8,
      xpReward: 180,
      aceGuidance:
          'Keep it under 90 seconds! Use Present-Past-Future: what you do now, a highlight from your journey, and why you are excited for this role.',
      openingPrompt:
          "Thanks for joining today! Let's kick things off — tell me a bit about yourself and your journey.",
      maxTurns: 3,
      turnSuggestions: {
        1: [
          'Present-Past-Future structure',
          'Lead with recent senior product leadership',
          'Connect background to Aurora Tech',
        ],
        2: [
          'Quantify impact (+40% user growth)',
          'Managing technical trade-offs under deadlines',
          'Mentoring cross-functional squads',
        ],
        3: [
          'Alignment with high-scale architecture',
          'Excited about user-centric product culture',
          'Eager to drive developer experience forward',
        ],
      },
    ),
    ChallengeScenario(
      id: 'communication-speak-clearly',
      category: ChallengeCategory.communication,
      title: 'Explain a Difficult Idea Simply',
      situationSetup:
          'Your executive stakeholder asks why a database migration took two weeks longer than estimated.',
      userObjective:
          'Translate a complex technical setback into plain business terms without sounding defensive.',
      interviewerName: 'Marcus Vance',
      interviewerRole: 'Chief Operations Officer',
      interviewerCompany: 'Global Logistics',
      skillsPracticed: ['Brevity', 'Executive Empathy', 'Non-defensiveness'],
      difficulty: ChallengeDifficulty.intermediate,
      durationMinutes: 10,
      xpReward: 200,
      aceGuidance:
          'Acknowledge the delay immediately, explain the root cause in one plain sentence, and pivot to how it protects data integrity.',
      openingPrompt:
          'I saw the rollout slipped 14 days. Walk me through why this happened in terms our board can digest.',
      maxTurns: 3,
      turnSuggestions: {
        1: [
          'Acknowledge the 14-day delay directly',
          'Explain data integrity validation in plain words',
          'Reassure board on zero customer data loss',
        ],
        2: [
          'Automated validation guards put in place',
          'Proactive weekly stakeholder check-ins',
          'Safe migration completed with zero downtime',
        ],
        3: [
          'Summary report ready for board review',
          'Long-term risk permanently mitigated',
          'Platform now fully primed for peak quarter',
        ],
      },
    ),
    ChallengeScenario(
      id: 'negotiation-respond-to-low-offer',
      category: ChallengeCategory.negotiation,
      title: 'Respond to a Low Offer',
      situationSetup:
          'The recruiter presents an offer that is 15% below your target compensation range.',
      userObjective:
          'Express enthusiasm for the team while professionally anchoring to your target range with market evidence.',
      interviewerName: 'Elena Rostova',
      interviewerRole: 'Head of Talent Acquisition',
      interviewerCompany: 'VentureScale',
      skillsPracticed: ['Value Anchoring', 'Tactful Pushback', 'Composure'],
      difficulty: ChallengeDifficulty.intermediate,
      durationMinutes: 10,
      xpReward: 220,
      aceGuidance:
          "Never say 'that's too low'. Instead say: 'I'm thrilled about the opportunity, but based on my recent impact and current market data, I was expecting closer to \$X.'",
      openingPrompt:
          "We loved meeting you! We're excited to extend an offer with a base salary of \$125k. How does that feel to you?",
      maxTurns: 3,
      turnSuggestions: {
        1: [
          'Express genuine excitement for the team',
          'Anchor to market rate (\$145k base)',
          'Cite recent quantifiable project achievements',
        ],
        2: [
          'Explore equity and sign-on bonus flexibility',
          'Propose accelerated 6-month performance review',
          'Reiterate high dedication to multi-year impact',
        ],
        3: [
          'Affirm alignment on package details',
          'Confirm proposed start date and next steps',
          'Express gratitude for thoughtful collaboration',
        ],
      },
    ),
    ChallengeScenario(
      id: 'technical-clarify-requirements',
      category: ChallengeCategory.technical,
      title: 'Clarify Requirements First',
      situationSetup:
          'A staff architect gives you an open-ended system prompt: "Design a URL shortener like Bitly".',
      userObjective:
          'Ask crucial clarifying questions about scale, lifecycle, and analytics before proposing architecture.',
      interviewerName: 'David Kim',
      interviewerRole: 'Principal Architect',
      interviewerCompany: 'CloudMatrix',
      skillsPracticed: ['Scope Definition', 'Requirement Extraction', 'Active Inquiry'],
      difficulty: ChallengeDifficulty.advanced,
      durationMinutes: 12,
      xpReward: 250,
      aceGuidance:
          "Don't draw boxes yet! First ask: 'What is the read-to-write ratio? Do links expire? What is our latency SLA?'",
      openingPrompt:
          "Hi! Today I'd like you to design a scalable URL shortener. Where would you begin?",
      maxTurns: 3,
      turnSuggestions: {
        1: [
          'Ask for read-to-write ratio & QPS',
          'Clarify link expiration & lifecycle rules',
          'Inquire if custom short URLs are supported',
        ],
        2: [
          'Determine latency SLA (p99 < 100ms)',
          'Confirm multi-region distribution needs',
          'Address analytics & real-time click tracking',
        ],
        3: [
          'Propose base62 hashing with Redis cache',
          'Outline distributed database strategy',
          'Identify top bottlenecks and mitigation',
        ],
      },
    ),
  ];

  @override
  Future<ChallengeScenario?> getScenario(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    try {
      return _allScenarios.firstWhere((s) => s.id == id);
    } catch (_) {
      return _allScenarios.first;
    }
  }

  @override
  Future<List<ChallengeScenario>> getScenariosByCategory(
      ChallengeCategory category) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _allScenarios.where((s) => s.category == category).toList();
  }

  @override
  Future<String> getNextInterviewerResponse({
    required ChallengeScenario scenario,
    required List<SimulationTurn> previousTurns,
    required String userReply,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final turnCount = previousTurns.where((t) => t.speaker == TurnSpeaker.user).length;

    if (scenario.id == 'interview-tell-me-about-yourself') {
      if (turnCount == 1) {
        return "That's a compelling trajectory. What stood out as the single most challenging milestone in your recent work?";
      } else if (turnCount == 2) {
        return 'Great context. How do you see that specific experience helping you succeed here at Aurora Tech?';
      }
    } else if (scenario.id == 'communication-speak-clearly') {
      if (turnCount == 1) {
        return 'I appreciate the transparency. If the board asks whether this delay prevents future incidents, how do we reassure them?';
      } else if (turnCount == 2) {
        return "Understood. That sounds like a solid risk mitigation strategy. Let's make sure that's clear in the briefing.";
      }
    } else if (scenario.id == 'negotiation-respond-to-low-offer') {
      if (turnCount == 1) {
        return 'I hear you on the market data. We do have some flexibility on equity or a sign-on bonus. Would that help bridge the gap?';
      } else if (turnCount == 2) {
        return 'Understood. Let me take this package back to the hiring manager and see what we can adjust.';
      }
    }

    return 'Thank you for walking me through that. You presented your thoughts clearly and held your ground nicely.';
  }

  @override
  Future<SimulationEvaluation> evaluateSession({
    required ChallengeScenario scenario,
    required List<SimulationTurn> turns,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    return SimulationEvaluation(
      evaluationId: 'eval-${DateTime.now().millisecondsSinceEpoch}',
      scenarioId: scenario.id,
      overallScore: 88,
      headline: 'Impressive Poise & Structure!',
      summary:
          'You established authority early, avoided rambling, and anchored your answers to concrete impact.',
      dimensions: const [
        EvaluationDimension(
          name: 'Clarity & Structure',
          score: 92,
          feedback: 'Concise, clean narrative flow with zero filler words.',
        ),
        EvaluationDimension(
          name: 'Executive Presence',
          score: 85,
          feedback: 'Confident tone, active listening, and calm pacing.',
        ),
        EvaluationDimension(
          name: 'Relevance & Value',
          score: 87,
          feedback: 'Directly linked past achievements to the company mission.',
        ),
      ],
      strengths: const [
        'Used a crisp Present-Past-Future structure.',
        'Quickly quantified impact instead of just listing duties.',
        'Maintained composure during follow-up questioning.',
      ],
      weaknesses: const [
        'Could tighten the transition between your second and third points.',
        'Consider pausing briefly before answering tough follow-ups.',
      ],
      improvedExamples: const [
        'Instead of: "I did a lot of cross-functional alignment..."\nTry: "I unified three engineering squads around a single quarterly launch goal."',
      ],
      recommendedDrillTitle: '30-Second Concise Impact Drill',
      recommendedDrillDescription:
          'Practice condensing multi-month projects into 3 punchy sentences.',
      xpEarned: scenario.xpReward,
    );
  }
}

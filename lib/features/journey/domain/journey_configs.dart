import 'package:simu/features/journey/domain/entities/journey_milestone.dart';
import 'package:simu/features/journey/domain/entities/milestone_challenge.dart';
import 'package:simu/features/journey/domain/journey_milestone_assets.dart';
import 'package:simu/features/onboarding/domain/entities/user_goal.dart';

/// Full journey definition for a practice category.
class JourneyDefinition {
  const JourneyDefinition({
    required this.category,
    required this.milestones,
  });

  final UserGoalCategory category;
  final List<JourneyMilestone> milestones;

  /// First [count] milestones shown on the journey preview screen.
  List<JourneyMilestone> previewMilestones({int count = 4}) {
    if (milestones.length <= count) {
      return milestones;
    }
    return milestones.sublist(0, count);
  }
}

/// Data-driven journey content keyed by onboarding practice category.
abstract final class JourneyConfigs {
  static JourneyMilestone _milestone({
    required int position,
    required String id,
    required String title,
    required JourneyMilestoneDifficulty difficulty,
    required int xpReward,
    String description = '',
    List<MilestoneChallenge> challenges = const [],
    bool isLocked = false,
    bool isActive = false,
    bool isCompleted = false,
  }) {
    return JourneyMilestone(
      id: id,
      title: title,
      difficulty: difficulty,
      xpReward: xpReward,
      iconAssetPath: JourneyMilestoneAssets.forPreviewPosition(position),
      description: description,
      challenges: challenges,
      isLocked: isLocked,
      isActive: isActive,
      isCompleted: isCompleted,
    );
  }

  static final Map<UserGoalCategory, JourneyDefinition> byCategory = {
    UserGoalCategory.interviews: JourneyDefinition(
      category: UserGoalCategory.interviews,
      milestones: [
        _milestone(
          position: 1,
          id: 'interviews_1',
          title: 'The First Impression',
          difficulty: JourneyMilestoneDifficulty.easy,
          xpReward: 150,
          isActive: true,
          description:
              'Master the first 60 seconds with poise, presence, and authentic warmup rapport.',
          isCompleted: true,
          challenges: const [
            MilestoneChallenge(
              id: 'int_1_1',
              title: 'Opening Pitch & Warmup',
              description:
                  'Set a positive tone with a crisp, confident greeting and tone.',
              durationMinutes: 5,
              xpReward: 75,
              difficulty: 'Easy',
              isCompleted: true,
              scenarioId: 'interview-tell-me-about-yourself',
            ),
            MilestoneChallenge(
              id: 'int_1_2',
              title: 'Establish Rapport',
              description:
                  'Break the ice naturally and show active listening cues.',
              durationMinutes: 6,
              xpReward: 75,
              difficulty: 'Easy',
              isCompleted: true,
              scenarioId: 'interview-tell-me-about-yourself',
            ),
          ],
        ),
        _milestone(
          position: 2,
          id: 'interviews_2',
          title: 'Tell Me About Yourself',
          difficulty: JourneyMilestoneDifficulty.easy,
          xpReward: 180,
          isActive: true,
          description:
              'Structure your background using Present-Past-Future and anchor your narrative with metrics.',
          challenges: const [
            MilestoneChallenge(
              id: 'int_2_1',
              title: 'Present-Past-Future Structure',
              description:
                  'Lead with recent senior impact, past growth, and excitement for the role.',
              durationMinutes: 8,
              xpReward: 90,
              difficulty: 'Easy',
              isCompleted: false,
              scenarioId: 'interview-tell-me-about-yourself',
            ),
            MilestoneChallenge(
              id: 'int_2_2',
              title: 'Executive Follow-ups',
              description:
                  'Handle clarifying questions on technical scale and team collaboration.',
              durationMinutes: 10,
              xpReward: 90,
              difficulty: 'Medium',
              isCompleted: false,
              scenarioId: 'interview-tell-me-about-yourself',
            ),
          ],
        ),
        _milestone(
          position: 3,
          id: 'interviews_3',
          title: 'Handling Tough Questions',
          difficulty: JourneyMilestoneDifficulty.medium,
          xpReward: 200,
          description:
              'Answer behavioral stress questions with calm composure, self-awareness, and clear ownership.',
          isLocked: true,
          challenges: const [
            MilestoneChallenge(
              id: 'int_3_1',
              title: 'Tell Me About a Failure',
              description:
                  'Address a setback constructively without shifting blame.',
              durationMinutes: 10,
              xpReward: 100,
              difficulty: 'Medium',
              isLocked: true,
              scenarioId: 'interview-tell-me-about-yourself',
            ),
            MilestoneChallenge(
              id: 'int_3_2',
              title: 'Navigating Cross-Functional Conflict',
              description:
                  'Demonstrate diplomacy and finding common ground under pressure.',
              durationMinutes: 12,
              xpReward: 100,
              difficulty: 'Hard',
              isLocked: true,
              scenarioId: 'interview-tell-me-about-yourself',
            ),
          ],
        ),
        _milestone(
          position: 4,
          id: 'interviews_4',
          title: 'Nail the Final Interview',
          difficulty: JourneyMilestoneDifficulty.hard,
          xpReward: 250,
          description:
              'Simulate a comprehensive capstone session with executive partners.',
          isLocked: true,
          challenges: const [
            MilestoneChallenge(
              id: 'int_4_1',
              title: 'VP Executive Vision Sync',
              description:
                  'Articulate 1-year product vision and business alignment.',
              durationMinutes: 15,
              xpReward: 125,
              difficulty: 'Hard',
              isLocked: true,
              scenarioId: 'interview-tell-me-about-yourself',
            ),
            MilestoneChallenge(
              id: 'int_4_2',
              title: 'Final Cultural Alignment',
              description:
                  'Demonstrate mentorship, curiosity, and high agency values.',
              durationMinutes: 15,
              xpReward: 125,
              difficulty: 'Hard',
              isLocked: true,
              scenarioId: 'interview-tell-me-about-yourself',
            ),
          ],
        ),
        _milestone(
          position: 4,
          id: 'interviews_5',
          title: 'Negotiate Your Offer',
          difficulty: JourneyMilestoneDifficulty.hard,
          xpReward: 280,
          description:
              'Turn an initial offer into a top-of-market compensation package with tact.',
          isLocked: true,
          challenges: const [
            MilestoneChallenge(
              id: 'int_5_1',
              title: 'Value Anchoring & Pushback',
              description:
                  'Anchor to market rate with evidence without sounding contentious.',
              durationMinutes: 12,
              xpReward: 140,
              difficulty: 'Hard',
              isLocked: true,
              scenarioId: 'negotiation-respond-to-low-offer',
            ),
          ],
        ),
      ],
    ),
    UserGoalCategory.communication: JourneyDefinition(
      category: UserGoalCategory.communication,
      milestones: [
        _milestone(
          position: 1,
          id: 'communication_1',
          title: 'Speak Clearly',
          difficulty: JourneyMilestoneDifficulty.easy,
          xpReward: 150,
          isActive: true,
          description:
              'Translate intricate thoughts into crisp, accessible language for any audience.',
          challenges: const [
            MilestoneChallenge(
              id: 'comm_1_1',
              title: 'Explain a Difficult Idea Simply',
              description:
                  'Deconstruct a complex setback with calm clarity and executive empathy.',
              durationMinutes: 10,
              xpReward: 150,
              difficulty: 'Easy',
              isCompleted: true,
              scenarioId: 'communication-speak-clearly',
            ),
          ],
        ),
        _milestone(
          position: 2,
          id: 'communication_2',
          title: 'Listen Better',
          difficulty: JourneyMilestoneDifficulty.easy,
          xpReward: 180,
          description:
              'Detect underlying concerns, summarize intent, and validate key stakeholders.',
          challenges: const [
            MilestoneChallenge(
              id: 'comm_2_1',
              title: 'Active Listening & Mirroring',
              description:
                  'Reflect back stakeholder requirements accurately to build immediate trust.',
              durationMinutes: 8,
              xpReward: 90,
              difficulty: 'Easy',
              isCompleted: false,
              scenarioId: 'communication-speak-clearly',
            ),
          ],
        ),
        _milestone(
          position: 3,
          id: 'communication_3',
          title: 'Handle Difficult Conversations',
          difficulty: JourneyMilestoneDifficulty.medium,
          xpReward: 200,
          isLocked: true,
          description:
              'Deliver constructive feedback and navigate emotionally charged disagreements.',
          challenges: const [
            MilestoneChallenge(
              id: 'comm_3_1',
              title: 'Constructive Upward Feedback',
              description:
                  'Frame sensitive operational challenges constructively without confrontation.',
              durationMinutes: 12,
              xpReward: 100,
              difficulty: 'Medium',
              isLocked: true,
              scenarioId: 'communication-speak-clearly',
            ),
          ],
        ),
        _milestone(
          position: 4,
          id: 'communication_4',
          title: 'Communicate With Confidence',
          difficulty: JourneyMilestoneDifficulty.hard,
          xpReward: 250,
          isLocked: true,
          description:
              'Deliver persuasive executive briefings that drive alignment and decisive action.',
          challenges: const [
            MilestoneChallenge(
              id: 'comm_4_1',
              title: 'Executive All-Hands Briefing',
              description:
                  'Present a strategic pivot to organizational leadership with conviction.',
              durationMinutes: 15,
              xpReward: 125,
              difficulty: 'Hard',
              isLocked: true,
              scenarioId: 'communication-speak-clearly',
            ),
          ],
        ),
      ],
    ),
    UserGoalCategory.negotiation: JourneyDefinition(
      category: UserGoalCategory.negotiation,
      milestones: [
        _milestone(
          position: 1,
          id: 'negotiation_1',
          title: 'Know Your Value',
          difficulty: JourneyMilestoneDifficulty.easy,
          xpReward: 150,
          isActive: true,
          description:
              'Benchmark compensation packages, identify leverage points, and set walk-away criteria.',
          challenges: const [
            MilestoneChallenge(
              id: 'neg_1_1',
              title: 'Respond to a Low Offer',
              description:
                  'Anchor to market rate with poise and quantifiable impact evidence.',
              durationMinutes: 10,
              xpReward: 150,
              difficulty: 'Easy',
              isCompleted: false,
              scenarioId: 'negotiation-respond-to-low-offer',
            ),
          ],
        ),
        _milestone(
          position: 2,
          id: 'negotiation_2',
          title: 'Make Your Case',
          difficulty: JourneyMilestoneDifficulty.easy,
          xpReward: 180,
          description:
              'Frame value from the employer perspective to justify top-tier remuneration.',
          challenges: const [
            MilestoneChallenge(
              id: 'neg_2_1',
              title: 'Value Framing & Scope Alignment',
              description:
                  'Demonstrate how your unique competencies prevent multi-million dollar delays.',
              durationMinutes: 10,
              xpReward: 90,
              difficulty: 'Easy',
              isCompleted: false,
              scenarioId: 'negotiation-respond-to-low-offer',
            ),
          ],
        ),
        _milestone(
          position: 3,
          id: 'negotiation_3',
          title: 'Handle Pushback',
          difficulty: JourneyMilestoneDifficulty.medium,
          xpReward: 200,
          isLocked: true,
          description:
              'Defuse salary cap objections and expand the package across non-salary levers.',
          challenges: const [
            MilestoneChallenge(
              id: 'neg_3_1',
              title: 'Multi-Variable Package Structuring',
              description:
                  'Negotiate equity, signing bonuses, and accelerated review timelines.',
              durationMinutes: 12,
              xpReward: 100,
              difficulty: 'Medium',
              isLocked: true,
              scenarioId: 'negotiation-respond-to-low-offer',
            ),
          ],
        ),
        _milestone(
          position: 4,
          id: 'negotiation_4',
          title: 'Close the Deal',
          difficulty: JourneyMilestoneDifficulty.hard,
          xpReward: 250,
          isLocked: true,
          description:
              'Secure the finalized offer agreement cordially while cementing strong partnerships.',
          challenges: const [
            MilestoneChallenge(
              id: 'neg_4_1',
              title: 'Final Term Harmonization',
              description:
                  'Finalize package terms and establish mutual excitement before signing.',
              durationMinutes: 14,
              xpReward: 125,
              difficulty: 'Hard',
              isLocked: true,
              scenarioId: 'negotiation-respond-to-low-offer',
            ),
          ],
        ),
      ],
    ),
    UserGoalCategory.technical: JourneyDefinition(
      category: UserGoalCategory.technical,
      milestones: [
        _milestone(
          position: 1,
          id: 'technical_1',
          title: 'Understand the Problem',
          difficulty: JourneyMilestoneDifficulty.easy,
          xpReward: 150,
          isActive: true,
          description:
              'Dissect open-ended technical prompts by asking critical scope & SLA questions.',
          challenges: const [
            MilestoneChallenge(
              id: 'tech_1_1',
              title: 'Clarify Requirements First',
              description:
                  'Probe throughput, data lifecycles, and SLA targets before proposing architecture.',
              durationMinutes: 12,
              xpReward: 150,
              difficulty: 'Easy',
              isCompleted: false,
              scenarioId: 'technical-clarify-requirements',
            ),
          ],
        ),
        _milestone(
          position: 2,
          id: 'technical_2',
          title: 'Break It Down',
          difficulty: JourneyMilestoneDifficulty.easy,
          xpReward: 180,
          description:
              'Partition large systems into distinct services, data layers, and caching tiers.',
          challenges: const [
            MilestoneChallenge(
              id: 'tech_2_1',
              title: 'System Component Decomposition',
              description:
                  'Design high-scale caching, indexing, and persistent database partitions.',
              durationMinutes: 14,
              xpReward: 90,
              difficulty: 'Medium',
              isCompleted: false,
              scenarioId: 'technical-clarify-requirements',
            ),
          ],
        ),
        _milestone(
          position: 3,
          id: 'technical_3',
          title: 'Explain Your Approach',
          difficulty: JourneyMilestoneDifficulty.medium,
          xpReward: 200,
          isLocked: true,
          description:
              'Articulate design trade-offs (CAP theorem, latency vs consistency) with precision.',
          challenges: const [
            MilestoneChallenge(
              id: 'tech_3_1',
              title: 'Architectural Trade-Off Defense',
              description:
                  'Justify asynchronous event-driven design versus synchronous REST APIs.',
              durationMinutes: 15,
              xpReward: 100,
              difficulty: 'Hard',
              isLocked: true,
              scenarioId: 'technical-clarify-requirements',
            ),
          ],
        ),
        _milestone(
          position: 4,
          id: 'technical_4',
          title: 'Solve Under Pressure',
          difficulty: JourneyMilestoneDifficulty.hard,
          xpReward: 250,
          isLocked: true,
          description:
              'Diagnose live distributed bottlenecks and re-architect failover mechanisms.',
          challenges: const [
            MilestoneChallenge(
              id: 'tech_4_1',
              title: 'High-Load Incident Troubleshooting',
              description:
                  'Resolve cascading database connection pool depletion under 10x traffic surge.',
              durationMinutes: 15,
              xpReward: 125,
              difficulty: 'Hard',
              isLocked: true,
              scenarioId: 'technical-clarify-requirements',
            ),
          ],
        ),
      ],
    ),
  };

  static JourneyDefinition forCategory(UserGoalCategory category) {
    return byCategory[category] ?? byCategory[UserGoalCategory.interviews]!;
  }
}

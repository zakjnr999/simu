/// Strongly-typed route constants for Simu application.
class RouteNames {
  const RouteNames._();

  static const String splash = '/splash';
  static const String welcome = '/onboarding';
  static const String onboardingGoal = '/onboarding/goal';
  static const String onboardingExperience = '/onboarding/experience';
  static const String onboardingPersonalGoal = '/onboarding/personal-goal';
  static const String onboardingCommitment = '/onboarding/commitment';
  static const String onboardingMascot = '/onboarding/mascot';
  static const String onboardingJourney = '/onboarding/journey';
  static const String onboardingHowItWorks = '/onboarding/how-it-works';
  static const String onboardingFirstChallenge = '/onboarding/first-challenge';

  static const String home = '/home';
  static const String journeyHub = '/journey';

  static const String practice = '/practice';
  static const String practiceCategory = '/practice/:category';
  static const String practiceScenario = '/practice/:category/:scenario';

  static const String simulationIntro = '/simulation/:id/intro';
  static const String simulation = '/simulation/:id';
  static const String simulationResults = '/simulation/:id/results';

  static const String drills = '/drills';
  static const String progress = '/progress';
  static const String challengeHistory = '/history';
  static const String achievements = '/achievements';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
}

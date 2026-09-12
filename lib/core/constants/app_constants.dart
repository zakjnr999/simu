/// Global application constants.
class AppConstants {
  const AppConstants._();

  static const String appName = 'Simu';
  static const String appTagline = 'Practice today, level up tomorrow.';

  // Storage Keys
  static const String keyOnboardingComplete = 'simu_onboarding_complete';
  static const String keySelectedGoal = 'simu_selected_goal';
  static const String keySelectedMasteryGoal = 'simu_selected_mastery_goal';
  static const String keySelectedExperience = 'simu_selected_experience';
  static const String keySelectedPersonalGoal = 'simu_selected_personal_goal';
  static const String keySelectedCommitment = 'simu_selected_commitment';
  static const String keyUserDisplayName = 'simu_user_display_name';
  static const String keyUserToken = 'simu_user_token';

  // Animation Defaults (ms)
  static const int animationDurationFast = 150;
  static const int animationDurationNormal = 250;
  static const int animationDurationSlow = 400;
}

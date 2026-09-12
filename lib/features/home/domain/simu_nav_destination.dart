/// Primary bottom-navigation destinations in the main Simu app.
enum SimuNavDestination {
  home,
  journey,
  practice,
  profile,
}

extension SimuNavDestinationX on SimuNavDestination {
  String get label => switch (this) {
        SimuNavDestination.home => 'Home',
        SimuNavDestination.journey => 'Journey',
        SimuNavDestination.practice => 'Practice',
        SimuNavDestination.profile => 'Profile',
      };
}

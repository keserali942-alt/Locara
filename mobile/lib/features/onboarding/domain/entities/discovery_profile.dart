class DiscoveryProfile {
  const DiscoveryProfile({
    required this.activities,
    required this.budgetTier,
    required this.companions,
    required this.priorities,
    required this.walkingPreference,
    required this.tripPace,
  });

  final List<String> activities;
  final String budgetTier;
  final List<String> companions;
  final List<String> priorities;
  final String walkingPreference;
  final String tripPace;
}

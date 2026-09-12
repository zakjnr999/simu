/// Represents an XP reward earned from a challenge or drill.
class XPReward {
  const XPReward({
    required this.amount,
    required this.sourceId,
    required this.reason,
    required this.timestamp,
  });

  final int amount;
  final String sourceId;
  final String reason;
  final DateTime timestamp;
}

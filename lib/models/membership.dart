class Membership {
  final String tier;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? stripeSubscriptionId;

  const Membership({
    required this.tier,
    required this.status,
    this.startDate,
    this.endDate,
    this.stripeSubscriptionId,
  });

  bool get isActive => status == 'active';

  bool get isCancelled => status == 'cancelled';

  bool get isPending => status == 'pending';

  String get displayTier {
    if (tier == 'monthly') return 'Monthly Member';
    if (tier == 'yearly') return 'Yearly Member';
    return 'Member';
  }

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      tier: json['tier'] as String? ?? 'monthly',
      status: json['status'] as String? ?? 'pending',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
      stripeSubscriptionId: json['stripeSubscriptionId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'tier': tier,
    'status': status,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'stripeSubscriptionId': stripeSubscriptionId,
  };
}

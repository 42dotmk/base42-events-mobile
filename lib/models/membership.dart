import 'dart:developer' as developer;

class Membership {
  final String tier;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? stripeSubscriptionId;

  static const _activeStatuses = [
    'active',
    'trialing',
    'past_due',
    'unpaid',
  ];

  const Membership({
    required this.tier,
    required this.status,
    this.startDate,
    this.endDate,
    this.stripeSubscriptionId,
  });

  bool get isActive => _activeStatuses.contains(status);

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
      status: (json['status'] as String? ?? 'pending').toLowerCase().trim(),
      startDate: json['startDate'] != null
          ? _parseDate(json['startDate'] as String, field: 'startDate')
          : null,
      endDate: json['endDate'] != null
          ? _parseDate(json['endDate'] as String, field: 'endDate')
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

  static DateTime? _parseDate(String value, {required String field}) {
    final result = DateTime.tryParse(value);
    if (result == null) {
      developer.log(
        'Failed to parse $field: "$value"',
        name: 'Membership',
      );
    }
    return result;
  }
}

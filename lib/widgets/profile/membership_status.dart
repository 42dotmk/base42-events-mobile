import 'package:flutter/material.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/utils/date_formatters.dart';
import 'package:base42_events_mobile/widgets/profile/membership_card.dart';

class MembershipStatus extends StatelessWidget {
  final AuthProvider authProvider;

  const MembershipStatus({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    final user = authProvider.currentUser;
    if (user == null) return const SizedBox.shrink();

    final membership = user.activeMembership;

    if (user.isMember && membership != null) {
      final startDate = membership.startDate != null
          ? formatDateMedium(membership.startDate!)
          : null;
      final tierLabel = membership.tier == 'monthly' ? 'Monthly' : 'Yearly';
      final String nextCycle;
      if (membership.endDate != null) {
        nextCycle = formatMonthDay(membership.endDate!);
      } else {
        final base = membership.startDate ?? DateTime.now();
        final next = membership.tier == 'yearly'
            ? DateTime(base.year + 1, base.month, base.day)
            : DateTime(base.year, base.month + 1, base.day);
        nextCycle = formatMonthDay(next);
      }
      return MembershipCard(
        title: tierLabel,
        subtitle: startDate != null ? 'Member since $startDate' : tierLabel,
        badgeLabel: 'ACTIVE',
        nextCycleDate: nextCycle,
      );
    }

    if (user.isVolunteer) {
      return MembershipCard(
        title: 'Volunteer',
        subtitle: 'Contributing member access',
        badgeLabel: 'ACTIVE',
      );
    }

    return MembershipCard(
      title: 'Free',
      subtitle: 'Basic access',
      badgeLabel: 'UPGRADE',
    );
  }
}

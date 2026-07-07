import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/utils.dart';
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
          ? DateFormat('MMM d, yyyy').format(membership.startDate!)
          : null;
      final tierLabel = membership.tier == 'monthly' ? 'Monthly' : 'Yearly';
      final nextCycle = formatNextCycleDate(
        endDate: membership.endDate,
        startDate: membership.startDate,
        tier: membership.tier,
      );
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

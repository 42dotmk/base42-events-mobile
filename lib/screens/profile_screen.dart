import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/booking_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum _BookingFilter { upcoming, past }

enum _BookingStatus { confirmed, pending, completed, cancelled }

class _BookingItem {
  final String roomName;
  final String floorName;
  final DateTime date;
  final String timeStart;
  final String timeEnd;
  final _BookingStatus status;

  const _BookingItem({
    required this.roomName,
    required this.floorName,
    required this.date,
    required this.timeStart,
    required this.timeEnd,
    required this.status,
  });
}

class _AccountMenuItem {
  final IconData icon;
  final String label;
  final String description;
  final String? route;

  const _AccountMenuItem({
    required this.icon,
    required this.label,
    required this.description,
    this.route,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isKeycloakLoading = false;
  _BookingFilter _bookingFilter = _BookingFilter.upcoming;

  static final List<_BookingItem> _bookings = [
    _BookingItem(
      roomName: 'Main Open Workspace',
      floorName: 'First Floor',
      date: DateTime(2026, 2, 12),
      timeStart: '09:00',
      timeEnd: '17:00',
      status: _BookingStatus.confirmed,
    ),
    _BookingItem(
      roomName: 'Open Space Northeast',
      floorName: 'Ground Floor',
      date: DateTime(2026, 2, 14),
      timeStart: '14:00',
      timeEnd: '16:00',
      status: _BookingStatus.confirmed,
    ),
    _BookingItem(
      roomName: 'Quiet Pod 3',
      floorName: 'First Floor',
      date: DateTime(2026, 1, 18),
      timeStart: '10:00',
      timeEnd: '12:00',
      status: _BookingStatus.completed,
    ),
    _BookingItem(
      roomName: 'Meeting Room B',
      floorName: 'Second Floor',
      date: DateTime(2026, 1, 10),
      timeStart: '15:00',
      timeEnd: '16:00',
      status: _BookingStatus.cancelled,
    ),
  ];

  static const List<_AccountMenuItem> _menuItems = [
    _AccountMenuItem(
      icon: Icons.credit_card_outlined,
      label: 'Membership & Billing',
      description: 'Manage your plan',
    ),
    _AccountMenuItem(
      icon: Icons.notifications_none_rounded,
      label: 'Notifications',
      description: 'Event reminders, booking updates',
    ),
    _AccountMenuItem(
      icon: Icons.settings_outlined,
      label: 'Settings',
      description: 'App preferences',
      route: AppRoutes.settings,
    ),
    _AccountMenuItem(
      icon: Icons.help_outline_rounded,
      label: 'Help & Support',
      description: 'FAQ, contact support',
    ),
  ];

  Future<void> _logout(BuildContext context) async {
    try {
      setState(() => _isKeycloakLoading = true);
      await Provider.of<AuthProvider>(context, listen: false).logout();
      if (!context.mounted) return;
      context.go(AppRoutes.home);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isKeycloakLoading = false);
    }
  }

  String _formatDisplayName(String? username) {
    final raw = (username ?? '').trim();
    if (raw.isEmpty) return 'Guest User';

    final segments = raw
        .split(RegExp(r'[\s._-]+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (segments.isEmpty) return 'Guest User';

    return segments
        .map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase())
        .join(' ');
  }

  String _buildInitials(String displayName) {
    final parts = displayName.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
    return letters.isEmpty ? 'GU' : letters;
  }

  List<_BookingItem> _getUpcomingBookings() {
    return _bookings
        .where(
          (booking) =>
              booking.status == _BookingStatus.confirmed ||
              booking.status == _BookingStatus.pending,
        )
        .toList();
  }

  List<_BookingItem> _getPastBookings() {
    return _bookings
        .where(
          (booking) =>
              booking.status == _BookingStatus.completed ||
              booking.status == _BookingStatus.cancelled,
        )
        .toList();
  }

  (Color, Color, String) _bookingStatusMeta(
    _BookingStatus status,
    BrandTheme brand,
  ) {
    switch (status) {
      case _BookingStatus.confirmed:
        return (
          brand.bookingStatusConfirmedText,
          brand.bookingStatusConfirmedBackground,
          'Confirmed',
        );
      case _BookingStatus.pending:
        return (
          brand.bookingStatusPendingText,
          brand.bookingStatusPendingBackground,
          'Pending',
        );
      case _BookingStatus.completed:
        return (
          brand.bookingStatusCompletedText,
          brand.bookingStatusCompletedBackground,
          'Completed',
        );
      case _BookingStatus.cancelled:
        return (
          brand.bookingStatusCancelledText,
          brand.bookingStatusCancelledBackground,
          'Cancelled',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final authProvider = context.watch<AuthProvider>();

    final displayName = _formatDisplayName(authProvider.currentUser?.username);
    final email = authProvider.currentUser?.email ?? 'Sign in to your account';
    final initials = _buildInitials(displayName);

    final upcomingBookings = _getUpcomingBookings();
    final pastBookings = _getPastBookings();
    final visibleBookings = _bookingFilter == _BookingFilter.upcoming
        ? upcomingBookings
        : pastBookings;

    //FIXME: Replace static code with components
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        color: (brand?.neonYellow ?? colorScheme.secondary)
                            .withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: (brand?.neonYellow ?? colorScheme.secondary)
                              .withValues(alpha: 0.45),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        initials,
                        style: context.textStyles.headlineMedium?.bold
                            .withColor(
                              brand?.neonYellow ?? colorScheme.secondary,
                            ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: context.textStyles.headlineSmall?.semiBold
                                .withColor(Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: context.textStyles.titleLarge?.withColor(
                              Colors.white.withValues(alpha: 0.48),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.62,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (brand?.neonYellow ?? colorScheme.secondary)
                          .withValues(alpha: 0.25),
                    ),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: (brand?.neonYellow ?? colorScheme.secondary)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.workspace_premium_outlined,
                          color: brand?.neonYellow ?? colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly Member',
                              style: context.textStyles.titleLarge?.semiBold
                                  .withColor(Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Member since Sep 15, 2025',
                              style: context.textStyles.titleMedium?.withColor(
                                Colors.white.withValues(alpha: 0.46),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withValues(alpha: 0.24),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        value: '${_bookings.length}',
                        label: 'Bookings',
                        valueColor:
                            brand?.neonYellow.withValues(alpha: 0.85) ??
                            colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatTile(
                        value: '${upcomingBookings.length}',
                        label: 'Upcoming',
                        valueColor: brand?.neonCyan ?? colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatTile(
                        value: '${pastBookings.length}',
                        label: 'Completed',
                        valueColor: Colors.white.withValues(alpha: 0.56),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  'MY BOOKINGS',
                  style: context.textStyles.headlineSmall?.semiBold
                      .withSize(38 / 2)
                      .withColor(Colors.white.withValues(alpha: 0.8)),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _FilterChip(
                      label: 'Upcoming (${upcomingBookings.length})',
                      selected: _bookingFilter == _BookingFilter.upcoming,
                      onTap: () => setState(
                        () => _bookingFilter = _BookingFilter.upcoming,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Past (${pastBookings.length})',
                      selected: _bookingFilter == _BookingFilter.past,
                      onTap: () =>
                          setState(() => _bookingFilter = _BookingFilter.past),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (visibleBookings.isEmpty)
                  _EmptyBookingsState(filter: _bookingFilter)
                else
                  ...visibleBookings.map((booking) {
                    final (
                      statusTextColor,
                      statusBackgroundColor,
                      statusLabel,
                    ) = _bookingStatusMeta(
                      booking.status,
                      brand!,
                    );
                    final dateText = DateFormat(
                      'MMM d, yyyy',
                    ).format(booking.date);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: BookingCard(
                        spaceName: booking.roomName,
                        floor: booking.floorName,
                        status: statusLabel,
                        date: dateText,
                        timeRange: '${booking.timeStart} - ${booking.timeEnd}',
                        statusTextColor: statusTextColor,
                        statusBackgroundColor: statusBackgroundColor,
                      ),
                    );
                  }),
                const SizedBox(height: 26),
                Text(
                  'ACCOUNT',
                  style: context.textStyles.headlineSmall?.semiBold
                      .withSize(38 / 2)
                      .withColor(Colors.white.withValues(alpha: 0.8)),
                ),
                const SizedBox(height: 10),
                ..._menuItems.map((item) => _AccountMenuTile(item: item)),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _isKeycloakLoading ? null : () => _logout(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 6,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFB44949,
                            ).withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: _isKeycloakLoading
                              ? const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.logout_rounded,
                                  color: Color(0xFFF16464),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Sign Out',
                          style: context.textStyles.headlineSmall?.semiBold
                              .withSize(37 / 2)
                              .withColor(const Color(0xFFF16464)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 34),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Base42 Mobile v0.1.0',
                        style: context.textStyles.bodySmall?.withColor(
                          Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Made with love in Skopje',
                        style: context.textStyles.bodySmall?.withColor(
                          Colors.white.withValues(alpha: 0.16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _StatTile({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: context.textStyles.headlineMedium?.bold.withColor(
              valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: context.textStyles.titleMedium?.withColor(
              Colors.white.withValues(alpha: 0.44),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? (brand?.neonYellow ?? colorScheme.secondary).withValues(
                  alpha: 0.18,
                )
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? (brand?.neonYellow ?? colorScheme.secondary).withValues(
                    alpha: 0.6,
                  )
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: context.textStyles.titleMedium?.semiBold.withColor(
            selected
                ? brand?.neonYellow ?? colorScheme.secondary
                : Colors.white.withValues(alpha: 0.44),
          ),
        ),
      ),
    );
  }
}

class _AccountMenuTile extends StatelessWidget {
  final _AccountMenuItem item;

  const _AccountMenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        if (item.route != null) context.push(item.route!);
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.62,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                item.icon,
                color: Colors.white.withValues(alpha: 0.48),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: context.textStyles.headlineSmall?.semiBold
                        .withSize(37 / 2)
                        .withColor(Colors.white),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.description,
                    style: context.textStyles.titleLarge?.withColor(
                      Colors.white.withValues(alpha: 0.46),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.22),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyBookingsState extends StatelessWidget {
  final _BookingFilter filter;

  const _EmptyBookingsState({required this.filter});

  @override
  Widget build(BuildContext context) {
    final text = filter == _BookingFilter.upcoming
        ? 'No upcoming bookings'
        : 'No past bookings';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event_busy_outlined,
            color: Colors.white.withValues(alpha: 0.45),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: context.textStyles.titleMedium?.withColor(
              Colors.white.withValues(alpha: 0.56),
            ),
          ),
        ],
      ),
    );
  }
}

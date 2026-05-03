import 'package:base42_events_mobile/consts/api.dart';
import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/providers/my_bookings_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/types.dart';
import 'package:base42_events_mobile/widgets/booking/booking_card.dart';
import 'package:base42_events_mobile/widgets/profile/account_menu_tile.dart';
import 'package:base42_events_mobile/widgets/profile/booking_filter_switch.dart';
import 'package:base42_events_mobile/widgets/profile/membership_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum _BookingFilter { upcoming, past }

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

  static const List<_AccountMenuItem> _menuItems = [
    _AccountMenuItem(
      icon: Icons.credit_card_outlined,
      label: 'Membership & Billing',
      description: 'Manage your plan',
    ),
    _AccountMenuItem(
      icon: Icons.settings_outlined,
      label: 'Settings',
      description: 'App preferences',
      route: AppRoutes.settings,
    ),
    _AccountMenuItem(
      icon: Icons.info_outline_rounded,
      label: 'About Base42',
      description: 'Location, contacts, and rules',
      route: AppRoutes.about,
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

  String _formatDisplayName(String? name) {
    final raw = (name ?? '').trim();
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

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final authProvider = context.watch<AuthProvider>();
    final myBookingsProvider = context.watch<MyBookingsProvider>();
    final filteredBookings = _bookingFilter == _BookingFilter.upcoming
        ? myBookingsProvider.upcomingBookings
        : myBookingsProvider.pastBookings;

    final displayName = _formatDisplayName(
      authProvider.currentUser?.firstName ?? authProvider.currentUser?.username,
    );
    final email = authProvider.currentUser?.email ?? 'Sign in to your account';
    final initials = _buildInitials(displayName);
    final profilePicture = authProvider.currentUser?.profilePicture;

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
                        color: (colorScheme.secondary).withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: (colorScheme.primary).withValues(alpha: 0.45),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: profilePicture != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Image.network(
                                profilePicture.getMediumUrl(baseUrl) ?? '',
                                width: 86,
                                height: 86,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Text(
                                      initials,
                                      style: context
                                          .textStyles
                                          .headlineMedium
                                          ?.bold
                                          .withColor(colorScheme.secondary),
                                    ),
                              ),
                            )
                          : Text(
                              initials,
                              style: context.textStyles.headlineMedium?.bold
                                  .withColor(colorScheme.secondary),
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
                                .withColor(colorScheme.onSurface),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: context.textStyles.titleMedium?.withColor(
                              colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: colorScheme.primary,
                      ),
                      onPressed: () => context.push(AppRoutes.editProfile),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const MembershipCard(
                  title: 'Monthly Member',
                  subtitle: 'Member since Sep 15, 2025',
                ),
                const SizedBox(height: 30),
                Text(
                  'MY BOOKINGS',
                  style: context.textStyles.titleMedium?.semiBold.withColor(
                    colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 14),
                BookingFilterSwitch(
                  upcomingLabel: 'Upcoming',
                  pastLabel: 'Past',
                  showUpcoming: _bookingFilter == _BookingFilter.upcoming,
                  onUpcomingTap: () {
                    setState(() => _bookingFilter = _BookingFilter.upcoming);
                  },
                  onPastTap: () {
                    setState(() => _bookingFilter = _BookingFilter.past);
                  },
                ),
                const SizedBox(height: 12),
                _MyBookingsSection(
                  filter: _bookingFilter,
                  bookings: filteredBookings,
                ),
                const SizedBox(height: 26),
                Text(
                  'ACCOUNT',
                  style: context.textStyles.titleMedium?.semiBold.withColor(
                    colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 10),
                ..._menuItems.map(
                  (item) => AccountMenuTile(
                    icon: item.icon,
                    label: item.label,
                    description: item.description,
                    onTap: () {
                      if (item.route != null) {
                        context.push(item.route!);
                      }
                    },
                  ),
                ),
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
                          width: 50,
                          height: 50,
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
                              : Icon(
                                  Icons.logout_rounded,
                                  color: colorScheme.error,
                                ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Sign Out',
                          style: context.textStyles.titleMedium?.semiBold
                              .withColor(colorScheme.error),
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
                          colorScheme.onSurface.withValues(alpha: 0.35),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Made with love in Skopje',
                        style: context.textStyles.bodySmall?.withColor(
                          colorScheme.onSurface.withValues(alpha: 0.3),
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

class _EmptyBookingsState extends StatelessWidget {
  final _BookingFilter filter;

  const _EmptyBookingsState({required this.filter});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.event_busy_outlined,
            color: colorScheme.onSurface.withValues(alpha: 0.55),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: context.textStyles.titleMedium?.withColor(
              colorScheme.onSurface.withValues(alpha: 0.62),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyBookingsSection extends StatelessWidget {
  final _BookingFilter filter;
  final List<MyBooking> bookings;

  const _MyBookingsSection({required this.filter, required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return _EmptyBookingsState(filter: filter);
    }

    return Column(
      children: bookings
          .map(
            (booking) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: BookingCard(
                spaceName: _resolveSpaceName(booking),
                floor: _resolveFloorLabel(booking),
                status: booking.statusLabel,
                date: DateFormat('MMM d, yyyy').format(booking.startDateTime),
                timeRange: _formatTimeRange(
                  booking.startDateTime,
                  booking.endDateTime,
                ),
                statusBackgroundColor: _statusBackgroundColor(context, booking),
              ),
            ),
          )
          .toList(),
    );
  }

  String _resolveSpaceName(MyBooking booking) {
    final eventType = booking.eventType.trim();
    if (eventType.isNotEmpty) {
      return eventType;
    }

    final eventName = booking.eventName.trim();
    if (eventName.isNotEmpty) {
      return eventName;
    }

    final organizer = booking.organizerEntity.trim();
    if (organizer.isNotEmpty) {
      return organizer;
    }

    return 'Event request';
  }

  String _resolveFloorLabel(MyBooking booking) {
    final organizer = booking.organizerEntity.trim();
    if (organizer.isNotEmpty) {
      return organizer;
    }

    final eventType = booking.eventType.trim();
    if (eventType.isNotEmpty) {
      return eventType;
    }

    return 'Booking request';
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    final formatter = DateFormat('HH:mm');
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }

  Color _statusBackgroundColor(BuildContext context, MyBooking booking) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    switch (booking.status) {
      case MyBookingStatus.pending:
        return brand?.bookingStatusPendingBackground ??
            colorScheme.secondaryContainer;
      case MyBookingStatus.confirmed:
        return brand?.bookingStatusConfirmedBackground ??
            colorScheme.primaryContainer;
      case MyBookingStatus.completed:
        return brand?.bookingStatusCompletedBackground ??
            colorScheme.tertiaryContainer;
      case MyBookingStatus.cancelled:
        return brand?.bookingStatusCancelledBackground ??
            colorScheme.errorContainer;
    }
  }
}

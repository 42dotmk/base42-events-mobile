import 'package:base42_events_mobile/consts/api.dart';
import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/utils.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/providers/my_bookings_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/profile/empty_booking_state.dart';
import 'package:base42_events_mobile/widgets/profile/event_attendance_section.dart';
import 'package:base42_events_mobile/widgets/profile/my_bookings_section.dart';
import 'package:base42_events_mobile/widgets/profile/account_menu_tile.dart';
import 'package:base42_events_mobile/widgets/profile/booking_filter_switch.dart';
import 'package:base42_events_mobile/widgets/profile/membership_status.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
  BookingFilter _bookingFilter = BookingFilter.upcoming;

  static const List<_AccountMenuItem> _menuItems = [
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

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final authProvider = context.watch<AuthProvider>();
    final myBookingsProvider = context.watch<MyBookingsProvider>();
    final filteredBookings = _bookingFilter == BookingFilter.upcoming
        ? myBookingsProvider.upcomingBookings
        : myBookingsProvider.pastBookings;

    final displayName = buildUserDisplayName(authProvider.currentUser);
    final email = authProvider.currentUser?.email ?? 'Sign in to your account';
    final initials = buildUserInitials(displayName);
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
                Text(
                  'MEMBERSHIP',
                  style: context.textStyles.titleMedium?.semiBold.withColor(
                    colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.membershipBilling),
                  child: MembershipStatus(authProvider: authProvider),
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
                  showUpcoming: _bookingFilter == BookingFilter.upcoming,
                  onUpcomingTap: () {
                    setState(() => _bookingFilter = BookingFilter.upcoming);
                  },
                  onPastTap: () {
                    setState(() => _bookingFilter = BookingFilter.past);
                  },
                ),
                const SizedBox(height: 12),
                MyBookingsSection(
                  filter: _bookingFilter,
                  bookings: filteredBookings,
                ),
                const SizedBox(height: 26),
                const EventAttendanceSection(),
                const SizedBox(height: 26),
                Text(
                  'OTHER',
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

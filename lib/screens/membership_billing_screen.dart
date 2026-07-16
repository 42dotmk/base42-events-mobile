import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/services/user_service.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/widgets/common/page_header.dart';
import 'package:base42_events_mobile/widgets/membership/current_plan_card.dart';
import 'package:base42_events_mobile/widgets/membership/upgrade_cta_card.dart';

class MembershipBillingScreen extends StatefulWidget {
  const MembershipBillingScreen({super.key});

  @override
  State<MembershipBillingScreen> createState() => _MembershipBillingScreenState();
}

class _MembershipBillingScreenState extends State<MembershipBillingScreen> with WidgetsBindingObserver {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().refreshCurrentUser().catchError((_) {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<AuthProvider>().refreshCurrentUser().catchError((_) {});
    }
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.home);
  }

  Future<void> _openPortal() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      final token = await auth.getAuthToken();

      if (token == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please log in first')),
        );
        return;
      }

      final userService = UserService();
      final portalUrl = await userService.createPortalSession(token);

      if (!mounted) return;

      if (portalUrl != null) {
        final uri = Uri.parse(portalUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open portal')),
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open subscription portal')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final surface = colorScheme.surface;
    final onSurface = colorScheme.onSurface;
    final auth = context.watch<AuthProvider>();
    final activeMembership = auth.activeMembership;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = brand?.neonCyan ?? colorScheme.primary;
    final secondaryAccent = brand?.neonYellow ?? colorScheme.secondary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Membership & Billing',
                onBack: () => _handleBack(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CURRENT PLAN OVERVIEW',
                        style: context.textStyles.titleSmall?.semiBold
                            .withColor(
                              onSurface.withValues(alpha: 0.55),
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      CurrentPlanCard(
                        isMember: auth.isMember,
                        isVolunteer: auth.isVolunteer,
                        activeMembership: activeMembership,
                        accentColor: accentColor,
                        secondaryAccent: secondaryAccent,
                        onSurface: onSurface,
                      ),
                      if (auth.isMember) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'SUBSCRIPTION',
                          style: context.textStyles.titleSmall?.semiBold
                              .withColor(onSurface.withValues(alpha: 0.55)),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? colorScheme.surfaceContainerHighest
                                : Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            border: Border.all(
                              color: onSurface.withValues(alpha: 0.08),
                            ),
                          ),
                          child: InkWell(
                            onTap: _isLoading ? null : _openPortal,
                            borderRadius: BorderRadius.circular(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: colorScheme.surfaceContainerHighest
                                        .withValues(alpha: 0.62),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.credit_card_rounded,
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.55),
                                  ),
                                ),
                              const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    'Manage Subscription',
                                    style: context.textStyles.titleMedium
                                        ?.semiBold
                                        .withColor(colorScheme.onSurface),
                                  ),
                                ),
                                if (_isLoading)
                                  const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                else
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ] else if (auth.isVolunteer) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'VOLUNTEER ACCESS',
                          style: context.textStyles.titleSmall?.semiBold
                              .withColor(onSurface.withValues(alpha: 0.55)),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: isDark
                                ? colorScheme.surfaceContainerHighest
                                : Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.xl),
                            border: Border.all(
                              color: onSurface.withValues(alpha: 0.08),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.volunteer_activism_outlined,
                                  color: accentColor,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  'Contributing member access',
                                  style: context.textStyles.titleMedium
                                      ?.semiBold
                                      .withColor(colorScheme.onSurface),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.sm,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: (brand?.successGreen ?? const Color(0xFF69D976))
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'ACTIVE',
                                  style: TextStyle(
                                    color: brand?.successGreen ?? const Color(0xFF69D976),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: AppSpacing.md),
                        UpgradeCTACard(
                          accentColor: accentColor,
                          secondaryAccent: secondaryAccent,
                          onSurface: onSurface,
                          surface: surface,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

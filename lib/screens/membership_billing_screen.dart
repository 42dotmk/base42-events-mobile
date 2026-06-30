import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
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

class _MembershipBillingScreenState extends State<MembershipBillingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().refreshCurrentUser().catchError((_) {});
    });
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final surface = colorScheme.surface;
    final onSurface = colorScheme.onSurface;
    final auth = context.watch<AuthProvider>();
    final userType = auth.currentUser?.userType ?? 'user';
    final activeMembership = auth.activeMembership;
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
                    children: [
                      CurrentPlanCard(
                        userType: userType,
                        activeMembership: activeMembership,
                        accentColor: accentColor,
                        onSurface: onSurface,
                      ),
                      if (userType != 'member') ...[
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

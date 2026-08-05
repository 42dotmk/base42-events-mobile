import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/services/user_service.dart';
import 'package:base42_events_mobile/widgets/common/page_header.dart';
import 'package:base42_events_mobile/consts/membership_pricing.dart';
import 'package:base42_events_mobile/widgets/membership/plan_card.dart';
import 'package:base42_events_mobile/widgets/common/auth_prompt_dialog.dart';
import 'package:base42_events_mobile/widgets/common/custom_button.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> with WidgetsBindingObserver {
  bool _isLoading = false;
  bool _isYearly = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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

  Future<void> _handleUpgrade() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final auth = context.read<AuthProvider>();
      final token = await auth.getAuthToken();

      if (token == null) {
        if (!mounted) return;
        AuthPromptDialog.show(
          context,
          message: 'Sign in to become a member',
        );
        return;
      }

      final userService = UserService();
      final checkoutUrl = await userService.createCheckoutSession(
        token,
        tier: _isYearly ? 'yearly' : 'monthly',
      );

      if (!mounted) return;

      if (checkoutUrl != null) {
        final uri = Uri.parse(checkoutUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open payment page')),
          );
        }
      } else {
          if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create checkout session'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Something went wrong: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = colorScheme.onSurface;

    final accent = brand?.neonYellow ?? colorScheme.secondary;
    final effectiveAccent = _isYearly
        ? (brand?.neonYellow ?? colorScheme.secondary)
        : (brand?.neonCyan ?? colorScheme.primary);

    final perks = [
      '24/7 Base Access',
      if (_isYearly)
        'Free tickets for all Base42 hosted Conferences'
      else
        'Free drinks and snacks',
      '3D Printer Access',
      'Electronics Lab',
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Become Member',
                onBack: () => _handleBack(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: ClipRect(
                          child: Image.asset(
                            'assets/images/marvin-rocket.png',
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'BASE42 MEMBER',
                        style: context.textStyles.headlineSmall?.bold.withColor(
                          accent,
                        ),
                      ),
                      const SizedBox(height: 28),
                      ...perks.map(
                        (perk) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 18,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: accent,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  perk,
                                  style: context.textStyles.bodyLarge?.withColor(
                                    onSurface.withValues(alpha: 0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: [
                            PlanCard(
                              label: 'Yearly',
                              price: MembershipPricing.displayForTier('yearly'),
                              perMonth: '${MembershipPricing.monthlyPerMonth}/${MembershipPricing.monthlyInterval}',
                              savingsLabel: 'Save ~18%',
                              isSelected: _isYearly,
                              onTap: () => setState(() => _isYearly = true),
                              effectiveAccent: effectiveAccent,
                            ),
                            const SizedBox(height: 12),
                            PlanCard(
                              label: 'Monthly',
                              price: MembershipPricing.displayForTier('monthly'),
                              isSelected: !_isYearly,
                              onTap: () => setState(() => _isYearly = false),
                              effectiveAccent: effectiveAccent,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Cancel anytime via your subscription portal.',
                        style: context.textStyles.bodySmall?.withColor(
                          onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: CustomButton.action(
                          label: 'Become a Member',
                          variant: ButtonVariant.solid,
                          onTap: _isLoading ? null : _handleUpgrade,
                          isLoading: _isLoading,
                        ),
                      ),
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

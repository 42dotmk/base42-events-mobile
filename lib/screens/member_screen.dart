import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/member/membership_card.dart';
import 'package:base42_events_mobile/widgets/member/member_perk_card.dart';

class MemberScreen extends StatelessWidget {
  const MemberScreen({super.key});

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
    final onSurface = colorScheme.onSurface;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;


    final perks = [
      const MemberPerk(
        icon: Icons.print_outlined,
        title: '3D Printer Access',
        description: 'Use professional-grade 3D printers for your projects anytime',
      ),
      const MemberPerk(
        icon: Icons.memory,
        title: 'Electronics Lab',
        description: 'Access to components, tools, and electronics workstations',
      ),
      const MemberPerk(
        icon: Icons.access_time_rounded,
        title: '24/7 Base Access',
        description: 'Round-the-clock entry to the hackerspace with your membership',
      ),
      const MemberPerk(
        icon: Icons.groups_outlined,
        title: 'Community Events',
        description: 'Priority access to workshops, meetups, and hackathons',
      ),
      const MemberPerk(
        icon: Icons.workspace_premium_outlined,
        title: 'Dedicated Workspace',
        description: 'Reserve a spot in our collaborative work environment',
      ),
      const MemberPerk(
        icon: Icons.network_ping_outlined,
        title: 'Networking',
        description: 'Connect with developers, makers, and innovators',
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 18, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: onSurface,
                      ),
                      onPressed: () => _handleBack(context),
                    ),
                    Text(
                      'MEMBERSHIP',
                      style: context.textStyles.headlineSmall?.bold
                          .withColor(onSurface),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MembershipCard(
                        accentColor: brand?.neonCyan ?? colorScheme.primary,
                        secondaryAccent:
                            brand?.neonYellow ?? colorScheme.secondary,
                        onSurface: onSurface,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'MEMBER PERKS',
                        style: context.textStyles.titleSmall?.semiBold
                            .withColor(
                              onSurface.withValues(alpha: 0.55),
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...perks.map(
                        (perk) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: MemberPerkCard(
                            icon: perk.icon,
                            title: perk.title,
                            description: perk.description,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Membership registration coming soon!',
                                  style: context.textStyles.bodyMedium?.withColor(
                                    colorScheme.onInverseSurface,
                                  ),
                                ),
                                backgroundColor: colorScheme.inverseSurface,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Text('Become a Member',
                           style: isDark ? TextStyle(color: Colors.black) :  TextStyle(color: Colors.white) ,
                            
                          ),
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

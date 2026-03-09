import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const HeaderWidget(),
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeroSection(context, brand, textTheme),
              _buildAboutSection(context, brand, textTheme),
              _buildFeaturesGrid(context, brand, textTheme),
              _buildCallToActionSection(context, brand, textTheme),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(
    BuildContext context,
    BrandTheme? brand,
    TextTheme textTheme,
  ) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Come and build',
          style: textTheme.displayMedium?.copyWith(
            color: brand?.neonCyan,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'Base42 with us!',
          style: textTheme.displayMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'A place for builders, and the curious',
          style: textTheme.titleMedium?.copyWith(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAboutSection(
    BuildContext context,
    BrandTheme? brand,
    TextTheme textTheme,
  ) {
    return Container(
      margin: AppSpacing.horizontalLg + AppSpacing.verticalLg,
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: brand?.deepTeal.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color:
              brand?.neonCyan.withValues(alpha: 0.3) ??
              Colors.cyan.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.terminal, color: brand?.neonCyan, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '> What is Base42?',
                style: textTheme.titleLarge?.copyWith(
                  color: brand?.neonCyan,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Started with the idea that knowledge should be proliferated as much as possible, '
            'as often as possible and reach as many people as possible.',
            style: textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'The goal of Base42 is to help enable people and encourage communities to be created, '
            'give them the tools to grow, get together and focus on achieving that goal: '
            'to build together, not alone.',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(
    BuildContext context,
    BrandTheme? brand,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: AppSpacing.horizontalLg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.verticalMd,
            child: Text(
              '> Facilities',
              style: textTheme.headlineSmall?.copyWith(
                color: brand?.neonYellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildFeatureCard(
            context,
            brand,
            textTheme,
            Icons.view_in_ar_rounded,
            '3D Printing Workspace',
            'Access to 3D printers and tools for your projects',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildFeatureCard(
            context,
            brand,
            textTheme,
            Icons.event_seat_rounded,
            'Events Hall',
            'Configurable space for holding events and meetups',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildFeatureCard(
            context,
            brand,
            textTheme,
            Icons.construction_rounded,
            'Workshops Space',
            'Dedicated area for hands-on workshops and experiments',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildFeatureCard(
            context,
            brand,
            textTheme,
            Icons.coffee_rounded,
            'Lounge',
            'Relax and connect with fellow builders',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    BrandTheme? brand,
    TextTheme textTheme,
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      padding: AppSpacing.paddingMd,
      decoration: BoxDecoration(
        color: brand?.deepNavy.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color:
              brand?.neonCyan.withValues(alpha: 0.2) ??
              Colors.cyan.withValues(alpha: .2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: brand?.neonCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: brand?.neonCyan, size: 32),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallToActionSection(
    BuildContext context,
    BrandTheme? brand,
    TextTheme textTheme,
  ) {
    return Container(
      margin: AppSpacing.horizontalLg + AppSpacing.verticalXl,
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            brand?.neonCyan.withValues(alpha: 0.1) ??
                Colors.cyan.withValues(alpha: .1),
            brand?.neonYellow.withValues(alpha: 0.1) ??
                Colors.yellow.withValues(alpha: .1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color:
              brand?.neonCyan.withValues(alpha: 0.5) ??
              Colors.cyan.withValues(alpha: .5),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Ready to start building?',
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Join our community and explore upcoming events',
            style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTerminalButton(
                context,
                './EVENTS.SH',
                brand?.neonYellow ?? Colors.yellow,
                () {
                  context.go(AppRoutes.events);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalButton(
    BuildContext context,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.2),
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          side: BorderSide(color: color, width: 2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(Icons.arrow_forward, size: 20, color: color),
        ],
      ),
    );
  }
}

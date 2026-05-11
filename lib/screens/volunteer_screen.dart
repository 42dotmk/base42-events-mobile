import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/volunteer/volunteer_benefit_card.dart';
import 'package:base42_events_mobile/widgets/volunteer/volunteer_image_carousel.dart';
import 'package:base42_events_mobile/widgets/volunteer/volunteer_application_form.dart';

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

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

    final images = const [
      VolunteerImageItem(
        assetPath: 'assets/images/workshop-space.jpg',
        caption: 'Collaborative workshop spaces',
      ),
      VolunteerImageItem(
        assetPath: 'assets/images/electronics.jpg',
        caption: 'Electronics lab & prototyping',
      ),
      VolunteerImageItem(
        assetPath: 'assets/images/whole-space.jpeg',
        caption: 'Our vibrant community hub',
      ),
    ];

    final benefits = [
      VolunteerBenefitItem(
        icon: Icons.build_outlined,
        title: 'Build Real Skills',
        description: 'Hands-on experience with cutting-edge tools and technologies',
      ),
      VolunteerBenefitItem(
        icon: Icons.people_outline,
        title: 'Join a Community',
        description: 'Connect with like-minded makers, developers, and creators',
      ),
      VolunteerBenefitItem(
        icon: Icons.school_outlined,
        title: 'Learn & Teach',
        description: 'Share your knowledge and learn from experienced members',
      ),
      VolunteerBenefitItem(
        icon: Icons.emoji_events_outlined,
        title: 'Make an Impact',
        description: 'Help grow and shape the Base42 hackerspace for everyone',
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
                      'VOLUNTEER',
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
                      Text(
                        'Shape the Future of Base42',
                        style: context.textStyles.headlineMedium?.bold
                            .withColor(onSurface),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Volunteering at Base42 is more than giving time — it\'s an investment in yourself and the community. Gain hands-on experience, build lasting connections, and help create a space where innovation thrives.',
                        style: context.textStyles.bodyLarge?.withColor(
                          onSurface.withValues(alpha: 0.72),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      VolunteerImageCarousel(images: images),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'WHY VOLUNTEER?',
                        style: context.textStyles.titleSmall?.semiBold
                            .withColor(
                              onSurface.withValues(alpha: 0.55),
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...benefits.map(
                        (b) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: VolunteerBenefitCard(
                            icon: b.icon,
                            title: b.title,
                            description: b.description,
                            accentColor: brand?.neonCyan ?? colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'APPLICATION FORM',
                        style: context.textStyles.titleSmall?.semiBold
                            .withColor(
                              onSurface.withValues(alpha: 0.55),
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const VolunteerApplicationForm(),
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

import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/about/about_location_map.dart';
import 'package:base42_events_mobile/widgets/common/custom_button.dart';
import 'package:base42_events_mobile/widgets/common/page_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _locationText = 'Rimska 25, Skopje';
  static const String _hoursText = 'Mon - Sat, 10:00 - 22:00';
  static const String _emailText = 'hello@base42.mk';
  static const double _locationLatitude = 41.997554241311256;
  static const double _locationLongitude = 21.407689842327894;

  Future<void> _openExternalLink(BuildContext context, String rawUrl) async {
    final uri = Uri.parse(rawUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Could not open the link.')));
  }

  void _handleBack(BuildContext context) {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'About Base42',
                onBack: () => _handleBack(context),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _InfoListItem(
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        value: _locationText,
                      ),
                      const SizedBox(height: 10),
                      const AboutLocationMap(
                        latitude: _locationLatitude,
                        longitude: _locationLongitude,
                      ),
                      const SizedBox(height: 10),
                      _InfoListItem(
                        icon: Icons.schedule_rounded,
                        label: 'Open Hours',
                        value: _hoursText,
                      ),
                      const SizedBox(height: 10),
                      _InfoListItem(
                        icon: Icons.alternate_email_rounded,
                        label: 'Email',
                        value: _emailText,
                        onTap: () =>
                            _openExternalLink(context, 'mailto:$_emailText'),
                      ),
                      const SizedBox(height: 24),
                      CustomButton.action(
                        icon: Icons.rule_rounded,
                        label: 'Rules',
                        variant: ButtonVariant.solid,
                        onTap: () => context.push(AppRoutes.rules),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'SOCIALS',
                        style: context.textStyles.titleMedium?.semiBold
                            .withColor(
                          colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _SocialSquareButton(
                              icon: Icons.camera_alt_outlined,
                              label: 'Instagram',
                              onTap: () => _openExternalLink(
                                context,
                                'https://www.instagram.com/42dotmk/',
                              ),
                            ),
                            _SocialSquareButton(
                              icon: Icons.facebook_outlined,
                              label: 'Facebook',
                              onTap: () => _openExternalLink(
                                context,
                                'https://www.facebook.com/42dotmk/',
                              ),
                            ),
                            _SocialSquareButton(
                              icon: Icons.business_center_outlined,
                              label: 'LinkedIn',
                              onTap: () => _openExternalLink(
                                context,
                                'https://www.linkedin.com/company/42-mk/',
                              ),
                            ),
                            _SocialSquareButton(
                              icon: Icons.forum_outlined,
                              label: 'Discord',
                              onTap: () => _openExternalLink(
                                context,
                                'https://discord.com/invite/424xxTZVYX',
                              ),
                            ),
                          ],
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

class _InfoListItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoListItem({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final content = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textStyles.titleSmall?.withColor(
                    colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: context.textStyles.titleMedium?.semiBold.withColor(
                    colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            Icon(
              Icons.open_in_new_rounded,
              size: 18,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(padding: const EdgeInsets.all(6), child: content),
    );
  }
}

class _SocialSquareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialSquareButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 84,
      height: 84,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.24),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: colorScheme.onSurface),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: context.textStyles.labelSmall?.withColor(
                  colorScheme.onSurface.withValues(alpha: 0.82),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

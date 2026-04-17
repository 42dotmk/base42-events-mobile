import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _locationText = 'Rimska 25, Skopje';
  static const String _hoursText = 'Mon - Sat, 10:00 - 22:00';
  static const String _emailText = 'hello@base42.mk';

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
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.profile);
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

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
                        color: colorScheme.onSurface,
                      ),
                      onPressed: () => _handleBack(context),
                    ),
                    Text(
                      'About Base42',
                      style: context.textStyles.headlineSmall?.bold.withColor(
                        colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BASE42',
                        style: context.textStyles.titleMedium?.semiBold
                            .withColor(
                              colorScheme.onSurface.withValues(alpha: 0.8),
                            ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.62,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.location_on_outlined,
                              label: 'Location',
                              value: _locationText,
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.schedule_rounded,
                              label: 'Open Hours',
                              value: _hoursText,
                            ),
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.alternate_email_rounded,
                              label: 'Email',
                              value: _emailText,
                              onTap: () => _openExternalLink(
                                context,
                                'mailto:$_emailText',
                              ),
                            ),
                          ],
                        ),
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
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _SocialButton(
                            icon: Icons.camera_alt_outlined,
                            label: 'Instagram',
                            onTap: () => _openExternalLink(
                              context,
                              'https://www.instagram.com/base42.mk/',
                            ),
                          ),
                          _SocialButton(
                            icon: Icons.facebook_outlined,
                            label: 'Facebook',
                            onTap: () => _openExternalLink(
                              context,
                              'https://www.facebook.com/',
                            ),
                          ),
                          _SocialButton(
                            icon: Icons.business_center_outlined,
                            label: 'LinkedIn',
                            onTap: () => _openExternalLink(
                              context,
                              'https://www.linkedin.com/',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => context.push(AppRoutes.rules),
                          icon: const Icon(Icons.rule_rounded),
                          label: const Text('Rules'),
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

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final content = Row(
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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.onSurface,
        side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.24)),
        backgroundColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.45,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    );
  }
}

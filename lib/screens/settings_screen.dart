import 'package:base42_events_mobile/providers/settings_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/common/page_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final settings = context.watch<SettingsProvider>();
    final dividerColor = colorScheme.outline.withValues(alpha: 0.2);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeader(
                title: 'Settings',
                onBack: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 24, 18, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PREFERENCES',
                        style: context.textStyles.headlineSmall?.semiBold
                            .withSize(38 / 2)
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
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                14,
                                12,
                                14,
                              ),
                              child: Row(
                                children: [
                                  _SettingIcon(
                                    Icons.notifications_none_rounded,
                                    colorScheme,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Notifications',
                                          style: context
                                              .textStyles
                                              .headlineSmall
                                              ?.semiBold
                                              .withSize(37 / 2)
                                              .withColor(colorScheme.onSurface),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Event reminders & booking updates',
                                          style: context.textStyles.titleSmall
                                              ?.withColor(
                                                colorScheme.onSurface
                                                    .withValues(alpha: 0.46),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: settings.notificationsEnabled,
                                    onChanged: settings.setNotificationsEnabled,
                                    activeThumbColor: colorScheme.primary,
                                    activeTrackColor: colorScheme.primary
                                        .withValues(alpha: 0.28),
                                    inactiveThumbColor: colorScheme.onSurface
                                        .withValues(alpha: 0.38),
                                    inactiveTrackColor: colorScheme.onSurface
                                        .withValues(alpha: 0.1),
                                    trackOutlineColor: WidgetStateProperty.all(
                                      Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: 1,
                              color: dividerColor,
                              indent: 18,
                              endIndent: 18,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                14,
                                18,
                                14,
                              ),
                              child: Row(
                                children: [
                                  _SettingIcon(
                                    Icons.palette_outlined,
                                    colorScheme,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      'Theme',
                                      style: context
                                          .textStyles
                                          .headlineSmall
                                          ?.semiBold
                                          .withSize(37 / 2)
                                          .withColor(colorScheme.onSurface),
                                    ),
                                  ),
                                  _ThemeSegmentedButton(settings: settings),
                                ],
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

class _SettingIcon extends StatelessWidget {
  final IconData icon;
  final ColorScheme colorScheme;

  const _SettingIcon(this.icon, this.colorScheme);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 20,
        color: colorScheme.onSurface.withValues(alpha: 0.48),
      ),
    );
  }
}

class _ThemeSegmentedButton extends StatelessWidget {
  final SettingsProvider settings;

  const _ThemeSegmentedButton({required this.settings});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = colorScheme.primary;

    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(
          value: ThemeMode.system,
          icon: Icon(Icons.brightness_auto_rounded, size: 16),
          tooltip: 'System',
        ),
        ButtonSegment(
          value: ThemeMode.light,
          icon: Icon(Icons.light_mode_outlined, size: 16),
          tooltip: 'Light',
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          icon: Icon(Icons.dark_mode_outlined, size: 16),
          tooltip: 'Dark',
        ),
      ],
      selected: {settings.themeMode},
      onSelectionChanged: (value) => settings.setThemeMode(value.first),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return activeColor.withValues(alpha: 0.18);
          }
          return colorScheme.surfaceContainerHighest.withValues(alpha: 0.35);
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return activeColor;
          return colorScheme.onSurface.withValues(alpha: 0.55);
        }),
        iconColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return activeColor;
          return colorScheme.onSurface.withValues(alpha: 0.55);
        }),
        side: WidgetStateProperty.all(
          BorderSide(color: colorScheme.outline.withValues(alpha: 0.25)),
        ),
        visualDensity: VisualDensity.compact,
      ),
      showSelectedIcon: false,
    );
  }
}

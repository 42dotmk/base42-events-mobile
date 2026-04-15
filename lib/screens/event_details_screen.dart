import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/event_info_row.dart';
import 'package:base42_events_mobile/widgets/tag_chip.dart';
import 'package:base42_events_mobile/widgets/event_media_hero.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy • hh:mm a');
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? colorScheme.secondary : colorScheme.primary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.shadow.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: colorScheme.onSurface,
                  ),
                ),
                onPressed: () => context.pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    EventMediaHero(event: event),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colorScheme.shadow.withValues(alpha: 0.0),
                            colorScheme.shadow.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.paddingLg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: context.textStyles.headlineMedium?.bold.withColor(
                        colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    EventInfoRow(
                      icon: Icons.calendar_today_rounded,
                      text: dateFormat.format(event.start),
                      colorScheme: colorScheme,
                    ),
                    if (event.tags.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: event.tags
                            .map((tag) => EventTagChip(label: tag.tagName))
                            .toList(),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        color: colorScheme.surface,
                      ),
                      child: Html(
                        data: event.description,
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.all(AppSpacing.lg),
                            fontSize: FontSize(FontSizes.bodyMedium),
                            lineHeight: const LineHeight(1.6),
                          ),
                          "h1": Style(
                            fontSize: FontSize(FontSizes.headlineMedium),
                            fontWeight: FontWeight.w600,
                            margin: Margins.only(
                              top: AppSpacing.lg,
                              bottom: AppSpacing.md,
                            ),
                          ),
                          "h2": Style(
                            fontSize: FontSize(FontSizes.headlineSmall),
                            fontWeight: FontWeight.w600,
                            margin: Margins.only(
                              top: AppSpacing.lg,
                              bottom: AppSpacing.md,
                            ),
                          ),
                          "h3": Style(
                            fontSize: FontSize(FontSizes.titleLarge),
                            fontWeight: FontWeight.w600,
                            margin: Margins.only(
                              top: AppSpacing.md,
                              bottom: AppSpacing.sm,
                            ),
                          ),
                          "p": Style(
                            margin: Margins.only(bottom: AppSpacing.md),
                          ),
                          "img": Style(
                            width: Width(double.infinity),
                            margin: Margins.symmetric(vertical: AppSpacing.md),
                          ),
                          "a": Style(
                            color: colorScheme.primary,
                            textDecoration: TextDecoration.underline,
                          ),
                        },
                        onLinkTap: (url, _, __) {
                          if (url != null) _launchUrl(url);
                        },
                      ),
                    ),
                    if (event.registerLink != null) ...[
                      const SizedBox(height: AppSpacing.xl),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _launchUrl(event.registerLink!),
                          icon: const Icon(Icons.open_in_new_rounded),
                          label: const Text('Register for Event'),
                          style: FilledButton.styleFrom(
                            backgroundColor: primaryAccent,
                            foregroundColor: colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                              horizontal: AppSpacing.lg,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:base42_events_mobile/nav.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/event_info_row.dart';
import 'package:base42_events_mobile/widgets/tag_chip.dart';
import 'package:base42_events_mobile/widgets/event_media_hero.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy • hh:mm a');
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? colorScheme.secondary : colorScheme.primary;
    final descriptionPreview = _buildDescriptionPreview(
      widget.event.description,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBackNavigation(context);
      },
      child: Scaffold(
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
                    child: Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                  onPressed: () => _handleBackNavigation(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      EventMediaHero(event: widget.event),
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
                        widget.event.title,
                        style: context.textStyles.headlineMedium?.bold
                            .withColor(colorScheme.onSurface),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      EventInfoRow(
                        icon: Icons.calendar_today_rounded,
                        text: dateFormat.format(widget.event.start),
                        colorScheme: colorScheme,
                      ),
                      if (widget.event.tags.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.lg),
                        Wrap(
                          spacing: AppSpacing.sm,
                          runSpacing: AppSpacing.sm,
                          children: widget.event.tags
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
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            initiallyExpanded: false,
                            onExpansionChanged: (expanded) {
                              setState(() => _isDescriptionExpanded = expanded);
                            },
                            tilePadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                            ),
                            childrenPadding: const EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              0,
                              AppSpacing.lg,
                              AppSpacing.lg,
                            ),
                            iconColor: colorScheme.primary,
                            collapsedIconColor: colorScheme.onSurfaceVariant,
                            title: Text(
                              'Description',
                              style: context.textStyles.titleMedium?.semiBold
                                  .withColor(colorScheme.onSurface),
                            ),
                            subtitle: _isDescriptionExpanded
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      top: AppSpacing.sm,
                                    ),
                                    child: Stack(
                                      children: [
                                        Text(
                                          descriptionPreview,
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textStyles.bodyMedium
                                              ?.withColor(
                                                colorScheme.onSurfaceVariant,
                                              ),
                                        ),
                                        Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: IgnorePointer(
                                            child: Container(
                                              height: 24,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    colorScheme.surface
                                                        .withValues(alpha: 0),
                                                    colorScheme.surface,
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            children: [
                              Html(
                                data: widget.event.description,
                                style: {
                                  "body": Style(
                                    margin: Margins.zero,
                                    fontSize: FontSize(FontSizes.bodyMedium),
                                    lineHeight: const LineHeight(1.6),
                                  ),
                                  "h1": Style(
                                    fontSize: FontSize(
                                      FontSizes.headlineMedium,
                                    ),
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
                                    margin: Margins.symmetric(
                                      vertical: AppSpacing.md,
                                    ),
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
                            ],
                          ),
                        ),
                      ),
                      if (widget.event.registerLink != null) ...[
                        const SizedBox(height: AppSpacing.xl),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () =>
                                _launchUrl(widget.event.registerLink!),
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
      ),
    );
  }

  void _handleBackNavigation(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.events);
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _buildDescriptionPreview(String html) {
    final withoutBreaks = html
        .replaceAll(RegExp(r'<\s*br\s*/?>', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'</\s*p\s*>', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'</\s*li\s*>', caseSensitive: false), ' ');
    final withoutTags = withoutBreaks.replaceAll(RegExp(r'<[^>]*>'), ' ');
    return withoutTags.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}

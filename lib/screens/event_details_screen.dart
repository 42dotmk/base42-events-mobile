import 'package:base42_events_mobile/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/services/event_service.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/event_info_row.dart';
import 'package:base42_events_mobile/widgets/tag_chip.dart';
import 'package:base42_events_mobile/widgets/event_media_hero.dart';

class EventDetailsScreen extends StatefulWidget {
  final Event? event;
  final String? eventId;

  const EventDetailsScreen({super.key, this.event, this.eventId})
    : assert(
        event != null || eventId != null,
        'Either event or eventId must be provided',
      );

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final EventService _eventService = EventService();
  Event? _event;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _event = widget.event;
    } else {
      _fetchEvent();
    }
  }

  @override
  void didUpdateWidget(covariant EventDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.eventId != null && widget.eventId != oldWidget.eventId) {
      _fetchEvent();
    }
  }

  Future<void> _fetchEvent() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final identifier = widget.eventId!;
      final event = await _eventService.fetchEventByIdentifier(identifier);
      if (mounted) {
        setState(() {
          _event = event;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        final isNotFound = e.toString().contains('not found');
        if (isNotFound) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Event not found'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading event: ${e.toString()}'),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(label: 'Retry', onPressed: _fetchEvent),
            ),
          );
        }
        context.go(AppRoutes.events);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _event == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final event = _event!;
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy • hh:mm a');
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();

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
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => context.go(AppRoutes.events),
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
                            Colors.black.withValues(alpha: 0.0),
                            Colors.black.withValues(alpha: 0.5),
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
                        Colors.white,
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
                            backgroundColor: brand?.neonCyan,
                            foregroundColor: Colors.black,
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

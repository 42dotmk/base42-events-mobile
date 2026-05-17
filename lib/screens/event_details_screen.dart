import 'package:base42_events_mobile/nav.dart';
import 'package:base42_events_mobile/consts/enum.dart';
import 'package:base42_events_mobile/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/services/event_service.dart';
import 'package:base42_events_mobile/providers/attendance_provider.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/utils.dart';
import 'package:base42_events_mobile/widgets/event_info_row.dart';
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
  bool _isUpdatingAttendance = false;
  bool _isDescriptionExpanded = false;

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
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
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

  Future<void> _setAttendance(EventAttendanceStatus status) async {
    final authProvider = context.read<AuthProvider>();
    final currentStatus = context.read<AttendanceProvider>().getStatus(
      _event!.id,
    );
    final isAlreadySelected = currentStatus == status.name;

    if (!authProvider.isAuthenticated ||
        authProvider.token == null ||
        authProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to mark your attendance.')),
      );
      return;
    }

    if (mounted) setState(() => _isUpdatingAttendance = true);
    try {
      if (isAlreadySelected) {
        await context.read<AttendanceProvider>().cancelAttendance(
          token: authProvider.token!,
          userId: authProvider.currentUser!.id,
          eventId: _event!.id,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Attendance cancelled!')),
          );
        }
      } else {
        await context.read<AttendanceProvider>().updateEventAttendanceStatus(
          token: authProvider.token!,
          userId: authProvider.currentUser!.id,
          event: _event!,
          status: status,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                status == EventAttendanceStatus.interested
                    ? 'Marked as Interested!'
                    : 'Marked as Going!',
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not update attendance: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdatingAttendance = false);
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _handleBackNavigation(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.events);
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
    final primaryAccent = colorScheme.primary;
    final descriptionPreview = buildEventDescriptionPreview(event.description);
    final descriptionHtml = buildEventDescriptionHtml(event.description);
    final currentStatus = context.watch<AttendanceProvider>().getStatus(
      event.id,
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
                        style: context.textStyles.headlineMedium?.bold
                            .withColor(colorScheme.onSurface),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          CustomButton.attendance(
                            icon: Icons.star_rounded,
                            label: 'Interested',
                            isActive:
                                currentStatus ==
                                EventAttendanceStatus.interested.name,
                            color: brand?.neonYellow ?? colorScheme.secondary,
                            isLoading: _isUpdatingAttendance,
                            onTap: () => _setAttendance(
                              EventAttendanceStatus.interested,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          CustomButton.attendance(
                            icon: Icons.check_circle_rounded,
                            label: 'Going',
                            isActive:
                                currentStatus ==
                                EventAttendanceStatus.going.name,
                            color: brand?.neonCyan ?? colorScheme.primary,
                            isLoading: _isUpdatingAttendance,
                            onTap: () =>
                                _setAttendance(EventAttendanceStatus.going),
                          ),
                        ],
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
                              .map(
                                (tag) => _EventFilterStyleTagChip(
                                  label: tag.tagName,
                                ),
                              )
                              .toList(),
                        ),
                      ],

                      const SizedBox(height: AppSpacing.lg),
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
                              if (mounted) {
                                setState(
                                  () => _isDescriptionExpanded = expanded,
                                );
                              }
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
                                              )
                                              .copyWith(
                                                fontWeight: FontWeight.w400,
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
                                data: descriptionHtml,
                                style: {
                                  "body": Style(
                                    margin: Margins.zero,
                                    fontSize: FontSize(FontSizes.bodyMedium),
                                    fontWeight: FontWeight.w400,
                                    lineHeight: const LineHeight(1.6),
                                  ),
                                  "h1": Style(
                                    fontSize: FontSize(
                                      FontSizes.headlineMedium,
                                    ),
                                    fontWeight: FontWeight.w400,
                                    margin: Margins.only(
                                      top: AppSpacing.lg,
                                      bottom: AppSpacing.md,
                                    ),
                                  ),
                                  "h2": Style(
                                    fontSize: FontSize(FontSizes.headlineSmall),
                                    fontWeight: FontWeight.w400,
                                    margin: Margins.only(
                                      top: AppSpacing.lg,
                                      bottom: AppSpacing.md,
                                    ),
                                  ),
                                  "h3": Style(
                                    fontSize: FontSize(FontSizes.titleLarge),
                                    fontWeight: FontWeight.w400,
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
                                onLinkTap: (url, _, _) {
                                  if (url != null) _launchUrl(url);
                                },
                              ),
                            ],
                          ),
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
      ),
    );
  }
}

class _EventFilterStyleTagChip extends StatelessWidget {
  final String label;

  const _EventFilterStyleTagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accent = colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.6)),
      ),
      child: Text(
        label,
        style: context.textStyles.labelMedium?.medium.withColor(accent),
      ),
    );
  }
}

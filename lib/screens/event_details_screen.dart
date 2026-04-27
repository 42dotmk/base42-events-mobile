import 'package:base42_events_mobile/consts/enum.dart';
import 'package:base42_events_mobile/widgets/common/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/providers/attendance_provider.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
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
  bool _isUpdatingAttendance = false;

  Future<void> _setAttendance(EventAttendanceStatus status) async {
    final authProvider = context.read<AuthProvider>();

    if (!authProvider.isAuthenticated ||
        authProvider.token == null ||
        authProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to mark your attendance.')),
      );
      return;
    }

    setState(() => _isUpdatingAttendance = true);
    try {
      await context.read<AttendanceProvider>().updateEventAttendanceStatus(
        token: authProvider.token!,
        userId: authProvider.currentUser!.id,
        event: widget.event,
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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy • hh:mm a');
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();
    final currentStatus = context.watch<AttendanceProvider>().getStatus(
      widget.event.id,
    );

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
                onPressed: () => context.pop(),
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
                      widget.event.title,
                      style: context.textStyles.headlineMedium?.bold.withColor(
                        Colors.white,
                      ),
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
                          onTap: () =>
                              _setAttendance(EventAttendanceStatus.interested),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        CustomButton.attendance(
                          icon: Icons.check_circle_rounded,
                          label: 'Going',
                          isActive:
                              currentStatus == EventAttendanceStatus.going.name,
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
                      child: Html(
                        data: widget.event.description,
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
}

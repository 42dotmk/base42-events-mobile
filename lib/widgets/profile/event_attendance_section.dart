import 'package:base42_events_mobile/consts/enum.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/providers/attendance_provider.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/profile/attendance_action_modal.dart';
import 'package:base42_events_mobile/widgets/profile/attendance_filter_chip.dart';
import 'package:base42_events_mobile/widgets/profile/event_attendance_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventAttendanceSection extends StatefulWidget {
  const EventAttendanceSection({super.key});

  @override
  State<EventAttendanceSection> createState() => _EventAttendanceSectionState();
}

class _EventAttendanceSectionState extends State<EventAttendanceSection> {
  EventAttendanceStatus _filter = EventAttendanceStatus.interested;

  EventAttendanceStatus _nextStatus(EventAttendanceStatus status) {
    switch (status) {
      case EventAttendanceStatus.interested:
        return EventAttendanceStatus.going;
      case EventAttendanceStatus.going:
        return EventAttendanceStatus.interested;
    }
  }

  Color _statusColor(EventAttendanceStatus status, BrandTheme? brand) {
    switch (status) {
      case EventAttendanceStatus.interested:
        return brand?.neonYellow ?? Theme.of(context).colorScheme.secondary;
      case EventAttendanceStatus.going:
        return brand?.neonCyan ?? Theme.of(context).colorScheme.primary;
    }
  }

  void _showAttendanceModal(
    BuildContext context,
    Event event,
    EventAttendanceStatus currentStatus,
  ) {
    showDialog(
      context: context,
      builder: (_) => AttendanceActionModal(
        currentStatus: currentStatus,
        onSwitch: () => _updateStatus(context, event, currentStatus),
        onCancel: () => _cancelAttendance(context, event),
      ),
    );
  }

  Future<void> _updateStatus(
    BuildContext context,
    Event event,
    EventAttendanceStatus currentStatus,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign in to update your attendance status.'),
          ),
        );
      }
      return;
    }

    final next = _nextStatus(currentStatus);
    try {
      await context.read<AttendanceProvider>().updateEventAttendanceStatus(
        token: token,
        userId: authProvider.currentUser!.id,
        event: event,
        status: next,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not update attendance: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _cancelAttendance(BuildContext context, Event event) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign in to manage your attendance.')),
        );
      }
      return;
    }

    try {
      await context.read<AttendanceProvider>().cancelAttendance(
        token: token,
        userId: authProvider.currentUser!.id,
        eventId: event.id,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attendance cancelled successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not cancel attendance: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final authProvider = context.watch<AuthProvider>();
    final entries = context.watch<AttendanceProvider>().attendanceEntries;

    final visibleEvents = entries.where((e) {
      final status = e.value.toLowerCase();
      return status == _filter.name;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EVENT ATTENDANCE',
          style: context.textStyles.titleMedium?.semiBold.withColor(
            colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: EventAttendanceStatus.values.map((status) {
            final isFirst = status == EventAttendanceStatus.values.first;
            return Expanded(
              child: Row(
                children: [
                  if (!isFirst) const SizedBox(width: 8),
                  Expanded(
                    child: AttendanceFilterChip(
                      label: eventAttendanceStatusLabel(status),
                      selected: _filter == status,
                      onTap: () => setState(() => _filter = status),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        if (visibleEvents.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.55,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Text(
              authProvider.isAuthenticated
                  ? 'No events in this attendance category yet.'
                  : 'Sign in to manage your event attendance.',
              style: context.textStyles.titleMedium?.withColor(
                colorScheme.onSurface.withValues(alpha: 0.62),
              ),
            ),
          )
        else
          ...visibleEvents.map((entry) {
            final event = entry.key;
            final rawStatus = entry.value.toLowerCase();
            final status = EventAttendanceStatus.values.firstWhere(
              (value) => value.name == rawStatus,
              orElse: () => EventAttendanceStatus.interested,
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: EventAttendanceTile(
                event: event,
                statusColor: _statusColor(status, brand),
                actionLabel: changeEventAttendanceStatus(status),
                isActionEnabled: authProvider.isAuthenticated,
                onActionTap: () => _showAttendanceModal(context, event, status),
              ),
            );
          }),
      ],
    );
  }
}

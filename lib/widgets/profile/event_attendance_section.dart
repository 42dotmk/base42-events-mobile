import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/providers/auth_provider.dart';
import 'package:base42_events_mobile/services/event_service.dart';
import 'package:base42_events_mobile/services/user_service.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/profile/attendance_filter_chip.dart';
import 'package:base42_events_mobile/widgets/error_view.dart';
import 'package:base42_events_mobile/widgets/profile/event_attendance_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum EventAttendanceStatus { interested, going, attended }

class _AttendanceItem {
  final Event event;
  final EventAttendanceStatus status;

  const _AttendanceItem({required this.event, required this.status});
}

class EventAttendanceSection extends StatefulWidget {
  const EventAttendanceSection({super.key});

  @override
  State<EventAttendanceSection> createState() => _EventAttendanceSectionState();
}

class _EventAttendanceSectionState extends State<EventAttendanceSection> {
  EventAttendanceStatus _filter = EventAttendanceStatus.interested;
  final EventService _eventService = EventService();
  final UserService _userService = UserService();
  List<_AttendanceItem> _items = [];
  bool _isLoading = true;
  bool _isChanging = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAttendanceEvents();
  }

  Future<void> _loadAttendanceEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final events = await _eventService.fetchEvents();
      final itemCount = events.length < 6 ? events.length : 6;
      final items = List.generate(itemCount, (index) {
        final event = events[index];
        final status = switch (index % 3) {
          0 => EventAttendanceStatus.interested,
          1 => EventAttendanceStatus.going,
          _ => EventAttendanceStatus.attended,
        };
        return _AttendanceItem(event: event, status: status);
      });

      if (mounted) {
        setState(() {
          _items = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String _statusLabel(EventAttendanceStatus status) {
    switch (status) {
      case EventAttendanceStatus.interested:
        return 'Interested';
      case EventAttendanceStatus.going:
        return 'Going';
      case EventAttendanceStatus.attended:
        return 'Attended';
    }
  }

  String _actionLabel(EventAttendanceStatus status) {
    switch (status) {
      case EventAttendanceStatus.interested:
        return 'Going';
      case EventAttendanceStatus.going:
        return 'Attended';
      case EventAttendanceStatus.attended:
        return 'Going';
    }
  }

  EventAttendanceStatus _nextStatus(EventAttendanceStatus status) {
    switch (status) {
      case EventAttendanceStatus.interested:
        return EventAttendanceStatus.going;
      case EventAttendanceStatus.going:
        return EventAttendanceStatus.attended;
      case EventAttendanceStatus.attended:
        return EventAttendanceStatus.going;
    }
  }

  Color _statusColor(EventAttendanceStatus status, BrandTheme? brand) {
    switch (status) {
      case EventAttendanceStatus.interested:
        return brand?.neonYellow ?? Theme.of(context).colorScheme.secondary;
      case EventAttendanceStatus.going:
        return brand?.neonCyan ?? Theme.of(context).colorScheme.primary;
      case EventAttendanceStatus.attended:
        return Colors.white.withValues(alpha: 0.74);
    }
  }

  List<_AttendanceItem> get _visibleItems =>
      _items.where((item) => item.status == _filter).toList();

  Future<void> _updateStatus(BuildContext context, _AttendanceItem item) async {
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

    final next = _nextStatus(item.status);
    setState(() => _isChanging = true);

    try {
      await _userService.changeAttendanceStatus(
        token: token,
        eventId: item.event.id,
        userId: authProvider.currentUser?.id,
        status: _statusLabel(next).toLowerCase(),
      );

      if (mounted) {
        setState(() {
          _items = _items.map((existing) {
            if (existing.event.id == item.event.id) {
              return _AttendanceItem(event: existing.event, status: next);
            }
            return existing;
          }).toList();
        });
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
      if (mounted) setState(() => _isChanging = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final authProvider = context.watch<AuthProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EVENT ATTENDANCE',
          style: context.textStyles.headlineSmall?.semiBold
              .withSize(38 / 2)
              .withColor(Colors.white.withValues(alpha: 0.8)),
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
                      label: _statusLabel(status),
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
        if (_isLoading)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(color: colorScheme.primary),
            ),
          )
        else if (_error != null)
          ErrorView(message: _error!, onRetry: _loadAttendanceEvents)
        else if (_visibleItems.isEmpty)
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
                Colors.white.withValues(alpha: 0.62),
              ),
            ),
          )
        else
          ..._visibleItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: EventAttendanceTile(
                event: item.event,
                statusLabel: _statusLabel(item.status),
                statusColor: _statusColor(item.status, brand),
                actionLabel: _actionLabel(item.status),
                isActionEnabled: authProvider.isAuthenticated && !_isChanging,
                onActionTap: () => _updateStatus(context, item),
              ),
            );
          }),
      ],
    );
  }
}

import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/types.dart';
import 'package:base42_events_mobile/widgets/booking/booking_card.dart';
import 'package:base42_events_mobile/widgets/profile/empty_booking_state.dart';
import 'package:flutter/material.dart';
import 'package:base42_events_mobile/utils/date_formatters.dart';

class MyBookingsSection extends StatelessWidget {
  final BookingFilter filter;
  final List<MyBooking> bookings;

  const MyBookingsSection({
    super.key,
    required this.filter,
    required this.bookings,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return EmptyBookingsState(filter: filter);
    }

    return Column(
      children: bookings
          .map(
            (booking) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: BookingCard(
                spaceName: _resolveSpaceName(booking),
                floor: _resolveFloorLabel(booking),
                status: booking.statusLabel,
                date: formatDateMedium(booking.startDateTime),
                timeRange: _formatTimeRange(
                  booking.startDateTime,
                  booking.endDateTime,
                ),
                statusBackgroundColor: _statusBackgroundColor(context, booking),
              ),
            ),
          )
          .toList(),
    );
  }

  String _resolveSpaceName(MyBooking booking) {
    final eventType = booking.eventType.trim();
    if (eventType.isNotEmpty) {
      return eventType;
    }

    final eventName = booking.eventName.trim();
    if (eventName.isNotEmpty) {
      return eventName;
    }

    final organizer = booking.organizerEntity.trim();
    if (organizer.isNotEmpty) {
      return organizer;
    }

    return 'Event request';
  }

  String _resolveFloorLabel(MyBooking booking) {
    final organizer = booking.organizerEntity.trim();
    if (organizer.isNotEmpty) {
      return organizer;
    }

    final eventType = booking.eventType.trim();
    if (eventType.isNotEmpty) {
      return eventType;
    }

    return 'Booking request';
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    return '${formatTime24(start)} - ${formatTime24(end)}';
  }

  Color _statusBackgroundColor(BuildContext context, MyBooking booking) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

    switch (booking.status) {
      case MyBookingStatus.pending:
        return brand?.bookingStatusPendingBackground ??
            colorScheme.secondaryContainer;
      case MyBookingStatus.confirmed:
        return brand?.bookingStatusConfirmedBackground ??
            colorScheme.primaryContainer;
      case MyBookingStatus.completed:
        return brand?.bookingStatusCompletedBackground ??
            colorScheme.tertiaryContainer;
      case MyBookingStatus.cancelled:
        return brand?.bookingStatusCancelledBackground ??
            colorScheme.errorContainer;
    }
  }
}

import 'package:base42_events_mobile/providers/booking_draft_provider.dart';
import 'package:base42_events_mobile/providers/my_bookings_provider.dart';
import 'package:base42_events_mobile/services/booking_service.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/types.dart';
import 'package:base42_events_mobile/utils.dart';
import 'package:base42_events_mobile/widgets/booking/booking_form_fields.dart';
import 'package:base42_events_mobile/widgets/custom_text_field.dart';
import 'package:base42_events_mobile/widgets/booking/booking_result_dialog.dart';
import 'package:base42_events_mobile/widgets/booking/selected_space_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _BookingTimeSlot {
  final String value;
  final String label;
  final String startTime;
  final String endTime;

  const _BookingTimeSlot({
    required this.value,
    required this.label,
    required this.startTime,
    required this.endTime,
  });

  String get uiLabel => '$label ($startTime - $endTime)';
}

class HostEventSection extends StatefulWidget {
  const HostEventSection({super.key});

  @override
  State<HostEventSection> createState() => _HostEventSectionState();
}

class _HostEventSectionState extends State<HostEventSection> {
  static const List<_BookingTimeSlot> _timeSlots = [
    _BookingTimeSlot(
      value: 'morning',
      label: 'Morning',
      startTime: '09:00',
      endTime: '13:00',
    ),
    _BookingTimeSlot(
      value: 'afternoon',
      label: 'Afternoon',
      startTime: '13:00',
      endTime: '17:00',
    ),
    _BookingTimeSlot(
      value: 'evening',
      label: 'Evening',
      startTime: '17:00',
      endTime: '22:00',
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  final _service = BookingService();

  late final TextEditingController _organizationController;
  late final TextEditingController _emailController;
  late final TextEditingController _expectedAttendeesController;
  late final TextEditingController _eventDescriptionController;

  _BookingTimeSlot? _selectedTimeSlot;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final draft = context.read<BookingDraftProvider>();

    _organizationController = TextEditingController(
      text: draft.organizerEntity,
    );
    _emailController = TextEditingController(text: draft.email);
    _expectedAttendeesController = TextEditingController(
      text: draft.expectedGuests,
    );
    _eventDescriptionController = TextEditingController(
      text: draft.eventAgenda,
    );

    _selectedTimeSlot = _resolveTimeSlot(
      startTime: draft.startTime,
      endTime: draft.endTime,
    );
  }

  @override
  void dispose() {
    _organizationController.dispose();
    _emailController.dispose();
    _expectedAttendeesController.dispose();
    _eventDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final draft = context.read<BookingDraftProvider>();
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      initialDate: draft.eventDate ?? now,
    );
    if (picked != null) {
      draft.setEventDate(picked);
    }
  }

  void _onTimeSlotChanged(String? value) {
    final draft = context.read<BookingDraftProvider>();
    final slot = _findTimeSlotByValue(value);

    setState(() => _selectedTimeSlot = slot);

    if (slot == null) {
      draft.setStartTime(null);
      draft.setEndTime(null);
      return;
    }

    draft.setStartTime(_parseTime(slot.startTime));
    draft.setEndTime(_parseTime(slot.endTime));
  }

  Future<void> _submit() async {
    final draft = context.read<BookingDraftProvider>();
    if (!_formKey.currentState!.validate()) return;

    final eventType = _resolvedEventType(draft);

    if (draft.eventDate == null || _selectedTimeSlot == null) {
      _showSnackBar('Please choose a date and time slot.');
      return;
    }

    final payload = BookingRequestPayload(
      organizerEntity: _organizationController.text.trim(),
      initiatorName: '',
      email: _emailController.text.trim(),
      phone: '',
      companyName: '',
      eventType: eventType,
      eventName: '',
      eventTheme: '',
      eventPurpose: '',
      eventAgenda: _eventDescriptionController.text.trim(),
      eventDate: bookingFormatDateForApi(draft.eventDate!),
      eventStartTime: _selectedTimeSlot!.startTime,
      eventEndTime: _selectedTimeSlot!.endTime,
      physicalPresence: '',
      expectedGuests: _expectedAttendeesController.text.trim(),
    );

    setState(() => _isSubmitting = true);
    try {
      final response = await _service.submitBookingRequest(payload);

      if (!mounted) return;

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        context.read<MyBookingsProvider>().addFromRequest(payload);
        showBookingResultDialog(
          context: context,
          type: BookingResultType.success,
        );
        _formKey.currentState!.reset();
        draft.clear();
        _organizationController.clear();
        _emailController.clear();
        _expectedAttendeesController.clear();
        _eventDescriptionController.clear();
        setState(() => _selectedTimeSlot = null);
      } else {
        showBookingResultDialog(
          context: context,
          type: BookingResultType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String? _requiredEmailValidator(String? value) {
    final requiredFieldResult = bookingRequiredFieldValidator(value);
    if (requiredFieldResult != null) {
      return requiredFieldResult;
    }
    return bookingEmailValidator(value);
  }

  String? _expectedAttendeesValidator(String? value) {
    final requiredFieldResult = bookingRequiredFieldValidator(value);
    if (requiredFieldResult != null) {
      return requiredFieldResult;
    }

    final parsed = int.tryParse(value!.trim());
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid number of attendees';
    }
    return null;
  }

  _BookingTimeSlot? _resolveTimeSlot({
    required TimeOfDay? startTime,
    required TimeOfDay? endTime,
  }) {
    if (startTime == null || endTime == null) {
      return null;
    }

    final startText = bookingFormatTime(startTime);
    final endText = bookingFormatTime(endTime);
    for (final slot in _timeSlots) {
      if (slot.startTime == startText && slot.endTime == endText) {
        return slot;
      }
    }
    return null;
  }

  _BookingTimeSlot? _findTimeSlotByValue(String? value) {
    if (value == null) {
      return null;
    }

    for (final slot in _timeSlots) {
      if (slot.value == value) {
        return slot;
      }
    }
    return null;
  }

  HostEventSpaceOption? _findSelectedSpace(String? eventType) {
    return findHostEventSpaceOption(eventType);
  }

  String _resolvedEventType(BookingDraftProvider draft) {
    final eventType = draft.eventType?.trim();
    if (eventType == null || eventType.isEmpty) {
      return hostEventSpaceOptions.first.value;
    }
    return eventType;
  }

  TimeOfDay _parseTime(String input) {
    final parts = input.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = int.tryParse(parts.last) ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<BookingDraftProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final eventType = _resolvedEventType(draft);
    final selectedSpace = _findSelectedSpace(eventType);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectedSpacePreviewCard(space: selectedSpace),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: eventType,
            decoration: bookingInputDecoration(context, 'Space *'),
            dropdownColor: colorScheme.surfaceContainerHighest,
            items: hostEventSpaceOptions
                .map(
                  (space) => DropdownMenuItem<String>(
                    value: space.value,
                    child: Text(space.label),
                  ),
                )
                .toList(),
            onChanged: draft.setEventType,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Required field';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          Text(
            'Fill in the Details',
            style: context.textStyles.titleMedium?.semiBold.withColor(
              colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          CustomTextField(
            controller: _organizationController,
            label: 'Organization *',
            validator: bookingRequiredFieldValidator,
            onChanged: draft.setOrganizerEntity,
          ),
          CustomTextField(
            controller: _emailController,
            label: 'Contact Email *',
            validator: _requiredEmailValidator,
            onChanged: draft.setEmail,
            textCapitalization: TextCapitalization.none,
          ),
          BookingDateTimeButtonField(
            label: 'Preferred Date *',
            value: draft.eventDate == null
                ? 'mm/dd/yyyy'
                : bookingFormatDate(draft.eventDate!),
            onTap: _pickDate,
          ),
          DropdownButtonFormField<String>(
            initialValue: _selectedTimeSlot?.value,
            decoration: bookingInputDecoration(context, 'Time *'),
            dropdownColor: colorScheme.surfaceContainerHighest,
            items: _timeSlots
                .map(
                  (slot) => DropdownMenuItem<String>(
                    value: slot.value,
                    child: Text(slot.uiLabel),
                  ),
                )
                .toList(),
            onChanged: _onTimeSlotChanged,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Required field';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: _expectedAttendeesController,
            label: 'Expected Attendees *',
            validator: _expectedAttendeesValidator,
            onChanged: draft.setExpectedGuests,
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.none,
          ),
          CustomTextField(
            controller: _eventDescriptionController,
            label: 'Event Description *',
            validator: bookingRequiredFieldValidator,
            onChanged: draft.setEventAgenda,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              'Base42 is a community space. Bookings are typically '
              'free for community events and meetups.',
              style: context.textStyles.bodyMedium?.withColor(
                colorScheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: _isSubmitting
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : const Icon(Icons.send_outlined),
              label: Text(
                _isSubmitting ? 'Submitting...' : 'Submit Booking Request',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

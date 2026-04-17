import 'package:base42_events_mobile/providers/booking_draft_provider.dart';
import 'package:base42_events_mobile/providers/my_bookings_provider.dart';
import 'package:base42_events_mobile/services/booking_service.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/types.dart';
import 'package:base42_events_mobile/utils.dart';
import 'package:base42_events_mobile/widgets/booking/booking_form_fields.dart';
import 'package:base42_events_mobile/widgets/booking/booking_result_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostEventSection extends StatefulWidget {
  const HostEventSection({super.key});

  @override
  State<HostEventSection> createState() => _HostEventSectionState();
}

class _HostEventSectionState extends State<HostEventSection> {
  final _formKey = GlobalKey<FormState>();
  final _service = BookingService();

  late final TextEditingController _organizerEntityController;
  late final TextEditingController _initiatorNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _companyNameController;
  late final TextEditingController _eventNameController;
  late final TextEditingController _eventThemeController;
  late final TextEditingController _eventPurposeController;
  late final TextEditingController _eventAgendaController;
  late final TextEditingController _expectedGuestsController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final draft = context.read<BookingDraftProvider>();
    _organizerEntityController = TextEditingController(
      text: draft.organizerEntity,
    );
    _initiatorNameController = TextEditingController(text: draft.initiatorName);
    _emailController = TextEditingController(text: draft.email);
    _phoneController = TextEditingController(text: draft.phone);
    _companyNameController = TextEditingController(text: draft.companyName);
    _eventNameController = TextEditingController(text: draft.eventName);
    _eventThemeController = TextEditingController(text: draft.eventTheme);
    _eventPurposeController = TextEditingController(text: draft.eventPurpose);
    _eventAgendaController = TextEditingController(text: draft.eventAgenda);
    _expectedGuestsController = TextEditingController(
      text: draft.expectedGuests,
    );
  }

  @override
  void dispose() {
    _organizerEntityController.dispose();
    _initiatorNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyNameController.dispose();
    _eventNameController.dispose();
    _eventThemeController.dispose();
    _eventPurposeController.dispose();
    _eventAgendaController.dispose();
    _expectedGuestsController.dispose();
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

  Future<void> _pickStartTime() async {
    final draft = context.read<BookingDraftProvider>();
    final picked = await showTimePicker(
      context: context,
      initialTime: draft.startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      draft.setStartTime(picked);
    }
  }

  Future<void> _pickEndTime() async {
    final draft = context.read<BookingDraftProvider>();
    final picked = await showTimePicker(
      context: context,
      initialTime: draft.endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      draft.setEndTime(picked);
    }
  }

  Future<void> _submit() async {
    final draft = context.read<BookingDraftProvider>();
    if (!_formKey.currentState!.validate()) return;

    if (draft.eventDate == null ||
        draft.startTime == null ||
        draft.endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill date and time fields.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final payload = BookingRequestPayload(
        organizerEntity: _organizerEntityController.text.trim(),
        initiatorName: _initiatorNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        companyName: _companyNameController.text.trim(),
        eventName: _eventNameController.text.trim(),
        eventTheme: _eventThemeController.text.trim(),
        eventPurpose: _eventPurposeController.text.trim(),
        eventAgenda: _eventAgendaController.text.trim(),
        eventType: draft.eventType ?? '',
        eventDate: bookingFormatDateForApi(draft.eventDate!),
        eventStartTime: bookingFormatTime(draft.startTime!),
        eventEndTime: bookingFormatTime(draft.endTime!),
        physicalPresence: draft.physicalPresence,
        expectedGuests: _expectedGuestsController.text.trim(),
      );
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
        _organizerEntityController.clear();
        _initiatorNameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _companyNameController.clear();
        _eventNameController.clear();
        _eventThemeController.clear();
        _eventPurposeController.clear();
        _eventAgendaController.clear();
        _expectedGuestsController.clear();
      } else {
        showBookingResultDialog(
          context: context,
          type: BookingResultType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<BookingDraftProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark ? colorScheme.secondary : colorScheme.primary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome_outlined, color: primaryAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Host your event at Base42',
                    style: context.textStyles.titleMedium?.semiBold.withColor(
                      colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Please fill in the event information and submit your request.',
              style: context.textStyles.bodySmall?.withColor(
                colorScheme.onSurface.withValues(alpha: 0.62),
              ),
            ),
            const SizedBox(height: 14),
            BookingHostTextField(
              controller: _organizerEntityController,
              label: 'Entity that\'s organizing the event *',
              validator: bookingRequiredFieldValidator,
              onChanged: draft.setOrganizerEntity,
            ),
            BookingHostTextField(
              controller: _initiatorNameController,
              label: 'Full name of the initiator *',
              validator: bookingRequiredFieldValidator,
              onChanged: draft.setInitiatorName,
            ),
            BookingHostTextField(
              controller: _emailController,
              label: 'E-mail',
              validator: bookingEmailValidator,
              onChanged: draft.setEmail,
              textCapitalization: TextCapitalization.none,
            ),
            BookingHostTextField(
              controller: _phoneController,
              label: 'Phone number',
              onChanged: draft.setPhone,
              textCapitalization: TextCapitalization.none,
            ),
            BookingHostTextField(
              controller: _companyNameController,
              label: 'Organization name *',
              validator: bookingRequiredFieldValidator,
              onChanged: draft.setCompanyName,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: draft.eventType,
              decoration: bookingInputDecoration(context, 'Type of event *'),
              dropdownColor: colorScheme.surfaceContainerHighest,
              items: const [
                DropdownMenuItem(value: 'Meetup', child: Text('Meetup')),
                DropdownMenuItem(value: 'Workshop', child: Text('Workshop')),
                DropdownMenuItem(
                  value: 'Conference',
                  child: Text('Conference'),
                ),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: draft.setEventType,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required field' : null,
            ),
            const SizedBox(height: 10),
            BookingHostTextField(
              controller: _eventNameController,
              label: 'Name of the event *',
              validator: bookingRequiredFieldValidator,
              onChanged: draft.setEventName,
            ),
            BookingHostTextField(
              controller: _eventThemeController,
              label: 'Theme of the event *',
              validator: bookingRequiredFieldValidator,
              onChanged: draft.setEventTheme,
            ),
            BookingHostTextField(
              controller: _eventPurposeController,
              label: 'Purpose of the event *',
              validator: bookingRequiredFieldValidator,
              onChanged: draft.setEventPurpose,
            ),
            BookingDateTimeButtonField(
              label: 'Date of the event *',
              value: draft.eventDate == null
                  ? 'mm/dd/yyyy'
                  : bookingFormatDate(draft.eventDate!),
              onTap: _pickDate,
            ),
            Row(
              children: [
                Expanded(
                  child: BookingDateTimeButtonField(
                    label: 'Start time *',
                    value: draft.startTime == null
                        ? '--:--'
                        : bookingFormatTime(draft.startTime!),
                    onTap: _pickStartTime,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BookingDateTimeButtonField(
                    label: 'End time *',
                    value: draft.endTime == null
                        ? '--:--'
                        : bookingFormatTime(draft.endTime!),
                    onTap: _pickEndTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Physical presence event *',
              style: context.textStyles.labelLarge?.withColor(
                colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'yes',
                  label: Text(
                    'Yes',
                    style: context.textStyles.bodyMedium?.semiBold,
                  ),
                ),
                ButtonSegment(
                  value: 'no',
                  label: Text(
                    'No',
                    style: context.textStyles.bodyMedium?.semiBold,
                  ),
                ),
              ],
              selected: {draft.physicalPresence},
              onSelectionChanged: (selection) {
                draft.setPhysicalPresence(selection.first);
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return primaryAccent;
                  }
                  return colorScheme.onSurface.withValues(alpha: 0.7);
                }),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return primaryAccent.withValues(alpha: 0.16);
                  }
                  return colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.35,
                  );
                }),
                side: WidgetStateProperty.all(
                  BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            BookingHostTextField(
              controller: _eventAgendaController,
              label: 'Event agenda *',
              validator: bookingRequiredFieldValidator,
              onChanged: draft.setEventAgenda,
              maxLines: 4,
            ),
            BookingHostTextField(
              controller: _expectedGuestsController,
              label: 'Expected number of guests',
              onChanged: draft.setExpectedGuests,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.none,
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your spam folder if you do not see the confirmation email in your inbox.',
              style: context.textStyles.bodySmall?.withColor(
                colorScheme.onSurface.withValues(alpha: 0.56),
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
                label: Text(_isSubmitting ? 'Submitting...' : 'Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

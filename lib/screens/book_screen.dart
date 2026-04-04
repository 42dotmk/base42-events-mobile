import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/services/booking_service.dart';
import 'package:base42_events_mobile/widgets/booking_form_fields.dart';
import 'package:base42_events_mobile/widgets/booking_result_dialog.dart';
import 'package:flutter/material.dart';

enum _BookMode { coworking, hostEvent }

enum _FloorType { ground, first }

class _BookableSpace {
  final String name;
  final String type;
  final int capacity;
  final String availability;
  final String price;
  final List<String> amenities;
  final IconData icon;

  const _BookableSpace({
    required this.name,
    required this.type,
    required this.capacity,
    required this.availability,
    required this.price,
    required this.amenities,
    required this.icon,
  });
}

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  _BookMode _mode = _BookMode.hostEvent;
  _FloorType _activeFloor = _FloorType.ground;

  static const List<_BookableSpace> _groundFloorSpaces = [
    _BookableSpace(
      name: 'Main Open Workspace',
      type: 'Hot desk',
      capacity: 24,
      availability: 'Available',
      price: '150 MKD/hour',
      amenities: ['Wi-Fi', 'Power', 'Whiteboard'],
      icon: Icons.monitor_outlined,
    ),
    _BookableSpace(
      name: 'Meeting Room A',
      type: 'Meeting room',
      capacity: 8,
      availability: 'Limited',
      price: '600 MKD/hour',
      amenities: ['Display', 'Camera', 'Speaker'],
      icon: Icons.slideshow_outlined,
    ),
  ];

  static const List<_BookableSpace> _firstFloorSpaces = [
    _BookableSpace(
      name: 'Quiet Pod 2',
      type: 'Call room',
      capacity: 2,
      availability: 'Available',
      price: '250 MKD/hour',
      amenities: ['Soundproof', 'Wi-Fi'],
      icon: Icons.phone_in_talk_outlined,
    ),
    _BookableSpace(
      name: 'Team Room North',
      type: 'Team room',
      capacity: 12,
      availability: 'Busy',
      price: '900 MKD/hour',
      amenities: ['TV', 'Whiteboard', 'HDMI'],
      icon: Icons.groups_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Book a Space',
                      style: context.textStyles.headlineSmall?.bold.withColor(
                        Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Reserve your spot at Base42',
                      style: context.textStyles.bodySmall?.withColor(
                        Colors.white.withValues(alpha: 0.56),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _ModeSwitcher(
                      mode: _mode,
                      onChanged: (mode) => setState(() => _mode = mode),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
                  child: _mode == _BookMode.coworking
                      ? _CoworkingSection(
                          activeFloor: _activeFloor,
                          onFloorChanged: (floor) =>
                              setState(() => _activeFloor = floor),
                          spaces: _activeFloor == _FloorType.ground
                              ? _groundFloorSpaces
                              : _firstFloorSpaces,
                        )
                      : const _HostEventSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeSwitcher extends StatelessWidget {
  final _BookMode mode;
  final ValueChanged<_BookMode> onChanged;

  const _ModeSwitcher({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();

    Widget buildButton(_BookMode buttonMode, String label, IconData icon) {
      final selected = mode == buttonMode;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(buttonMode),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? (buttonMode == _BookMode.coworking
                        ? brand?.neonCyan ?? colorScheme.primary
                        : brand?.neonYellow ?? colorScheme.secondary)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: selected
                      ? Colors.black
                      : Colors.white.withValues(alpha: 0.56),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: context.textStyles.labelLarge?.semiBold.withColor(
                    selected
                        ? Colors.black
                        : Colors.white.withValues(alpha: 0.56),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          buildButton(
            _BookMode.hostEvent,
            'Booking',
            Icons.event_note_outlined,
          ),
          const SizedBox(width: 4),
          buildButton(_BookMode.coworking, 'Coworking', Icons.monitor_outlined),
        ],
      ),
    );
  }
}

class _CoworkingSection extends StatelessWidget {
  final _FloorType activeFloor;
  final ValueChanged<_FloorType> onFloorChanged;
  final List<_BookableSpace> spaces;

  const _CoworkingSection({
    required this.activeFloor,
    required this.onFloorChanged,
    required this.spaces,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _FloorChip(
                label: 'Ground Floor',
                selected: activeFloor == _FloorType.ground,
                onTap: () => onFloorChanged(_FloorType.ground),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _FloorChip(
                label: 'First Floor',
                selected: activeFloor == _FloorType.first,
                onTap: () => onFloorChanged(_FloorType.first),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...spaces.map(
          (space) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _BookableSpaceCard(space: space),
          ),
        ),
      ],
    );
  }
}

class _FloorChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FloorChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: selected
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.9)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? Colors.white.withValues(alpha: 0.24)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: context.textStyles.labelLarge?.semiBold.withColor(
            selected ? Colors.white : Colors.white.withValues(alpha: 0.62),
          ),
        ),
      ),
    );
  }
}

class _BookableSpaceCard extends StatelessWidget {
  final _BookableSpace space;

  const _BookableSpaceCard({required this.space});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();

    Color availabilityColor;
    switch (space.availability) {
      case 'Available':
        availabilityColor = const Color(0xFF69D976);
      case 'Limited':
        availabilityColor = brand?.neonYellow ?? colorScheme.secondary;
      default:
        availabilityColor = const Color(0xFFE27B7B);
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: (brand?.neonCyan ?? colorScheme.primary).withValues(
                    alpha: 0.18,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  space.icon,
                  color: brand?.neonCyan ?? colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      space.name,
                      style: context.textStyles.titleMedium?.semiBold.withColor(
                        Colors.white,
                      ),
                    ),
                    Text(
                      space.type,
                      style: context.textStyles.bodySmall?.withColor(
                        Colors.white.withValues(alpha: 0.56),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: availabilityColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  space.availability,
                  style: context.textStyles.labelSmall?.semiBold.withColor(
                    availabilityColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${space.capacity} seats • ${space.price}',
            style: context.textStyles.bodySmall?.medium.withColor(
              Colors.white.withValues(alpha: 0.62),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: space.amenities
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item,
                      style: context.textStyles.labelSmall?.withColor(
                        Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _HostEventSection extends StatefulWidget {
  const _HostEventSection();

  @override
  State<_HostEventSection> createState() => _HostEventSectionState();
}

class _HostEventSectionState extends State<_HostEventSection> {
  final _formKey = GlobalKey<FormState>();
  final _service = BookingService();

  final _organizerEntityController = TextEditingController();
  final _initiatorNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _eventNameController = TextEditingController();
  final _eventThemeController = TextEditingController();
  final _eventPurposeController = TextEditingController();
  final _eventAgendaController = TextEditingController();
  final _expectedGuestsController = TextEditingController();

  String? _eventType;
  DateTime? _eventDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _physicalPresence = 'yes';
  bool _isSubmitting = false;

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

  String _formatDate(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    return '$mm/$dd/$yyyy';
  }

  String _formatDateForApi(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    final dd = date.day.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    return '$yyyy-$mm-$dd';
  }

  String _formatTime(TimeOfDay time) {
    final hh = time.hour.toString().padLeft(2, '0');
    final mm = time.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      initialDate: _eventDate ?? now,
    );
    if (picked != null) {
      setState(() => _eventDate = picked);
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _endTime = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_eventDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill date and time fields.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final response = await _service.submitBookingRequest(
        BookingRequestPayload(
          organizerEntity: _organizerEntityController.text.trim(),
          initiatorName: _initiatorNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          companyName: _companyNameController.text.trim(),
          eventType: _eventType ?? '',
          eventName: _eventNameController.text.trim(),
          eventTheme: _eventThemeController.text.trim(),
          eventPurpose: _eventPurposeController.text.trim(),
          eventAgenda: _eventAgendaController.text.trim(),
          eventDate: _formatDateForApi(_eventDate!),
          eventStartTime: _formatTime(_startTime!),
          eventEndTime: _formatTime(_endTime!),
          physicalPresence: _physicalPresence,
          expectedGuests: _expectedGuestsController.text.trim(),
        ),
      );

      if (!mounted) return;

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        showBookingResultDialog(
          context: context,
          type: BookingResultType.success,
        );
        _formKey.currentState!.reset();
        setState(() {
          _eventType = null;
          _eventDate = null;
          _startTime = null;
          _endTime = null;
          _physicalPresence = 'yes';
        });
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

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required field';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brand = Theme.of(context).extension<BrandTheme>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome_outlined,
                  color: brand?.neonYellow ?? colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Host your event at Base42',
                    style: context.textStyles.titleMedium?.semiBold.withColor(
                      Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Please fill in the event information and submit your request.',
              style: context.textStyles.bodySmall?.withColor(
                Colors.white.withValues(alpha: 0.62),
              ),
            ),
            const SizedBox(height: 14),
            BookingHostTextField(
              controller: _organizerEntityController,
              label: 'Entity that\'s organizing the event *',
              validator: _required,
            ),
            BookingHostTextField(
              controller: _initiatorNameController,
              label: 'Full name of the initiator *',
              validator: _required,
            ),
            BookingHostTextField(
              controller: _emailController,
              label: 'E-mail',
              textCapitalization: TextCapitalization.none,
            ),
            BookingHostTextField(
              controller: _phoneController,
              label: 'Phone number',
              textCapitalization: TextCapitalization.none,
            ),
            BookingHostTextField(
              controller: _companyNameController,
              label: 'Organization name *',
              validator: _required,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _eventType,
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
              onChanged: (value) => setState(() => _eventType = value),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Required field' : null,
            ),
            const SizedBox(height: 10),
            BookingHostTextField(
              controller: _eventNameController,
              label: 'Name of the event *',
              validator: _required,
            ),
            BookingHostTextField(
              controller: _eventThemeController,
              label: 'Theme of the event *',
              validator: _required,
            ),
            BookingHostTextField(
              controller: _eventPurposeController,
              label: 'Purpose of the event *',
              validator: _required,
            ),
            BookingDateTimeButtonField(
              label: 'Date of the event *',
              value: _eventDate == null
                  ? 'mm/dd/yyyy'
                  : _formatDate(_eventDate!),
              onTap: _pickDate,
            ),
            Row(
              children: [
                Expanded(
                  child: BookingDateTimeButtonField(
                    label: 'Start time *',
                    value: _startTime == null
                        ? '--:--'
                        : _formatTime(_startTime!),
                    onTap: _pickStartTime,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BookingDateTimeButtonField(
                    label: 'End time *',
                    value: _endTime == null ? '--:--' : _formatTime(_endTime!),
                    onTap: _pickEndTime,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Physical presence event *',
              style: context.textStyles.labelLarge?.withColor(
                Colors.white.withValues(alpha: 0.72),
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
              selected: {_physicalPresence},
              onSelectionChanged: (selection) {
                setState(() => _physicalPresence = selection.first);
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return brand?.neonYellow ?? colorScheme.secondary;
                  }
                  return Colors.white.withValues(alpha: 0.7);
                }),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return (brand?.neonYellow ?? colorScheme.secondary)
                        .withValues(alpha: 0.16);
                  }
                  return colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.35,
                  );
                }),
                side: WidgetStateProperty.all(
                  BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
              ),
            ),
            const SizedBox(height: 10),
            BookingHostTextField(
              controller: _eventAgendaController,
              label: 'Event agenda *',
              validator: _required,
              maxLines: 4,
            ),
            BookingHostTextField(
              controller: _expectedGuestsController,
              label: 'Expected number of guests',
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.none,
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your spam folder if you do not see the confirmation email in your inbox.',
              style: context.textStyles.bodySmall?.withColor(
                Colors.white.withValues(alpha: 0.56),
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

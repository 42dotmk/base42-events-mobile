import 'package:base42_events_mobile/providers/booking_draft_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/booking/coworking_section.dart';
import 'package:base42_events_mobile/widgets/booking/booking_draft_dialog.dart';
import 'package:base42_events_mobile/widgets/booking/host_event_section.dart';
import 'package:base42_events_mobile/widgets/booking/mode_switcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  BookMode _mode = BookMode.hostEvent;
  FloorType _activeFloor = FloorType.ground;

  static const List<BookableSpace> _groundFloorSpaces = [
    BookableSpace(
      name: 'Main Open Workspace',
      type: 'Hot desk',
      capacity: 24,
      availability: 'Available',
      price: '150 MKD/hour',
      amenities: ['Wi-Fi', 'Power', 'Whiteboard'],
      icon: Icons.monitor_outlined,
    ),
    BookableSpace(
      name: 'Meeting Room A',
      type: 'Meeting room',
      capacity: 8,
      availability: 'Limited',
      price: '600 MKD/hour',
      amenities: ['Display', 'Camera', 'Speaker'],
      icon: Icons.slideshow_outlined,
    ),
  ];

  static const List<BookableSpace> _firstFloorSpaces = [
    BookableSpace(
      name: 'Quiet Pod 2',
      type: 'Call room',
      capacity: 2,
      availability: 'Available',
      price: '250 MKD/hour',
      amenities: ['Soundproof', 'Wi-Fi'],
      icon: Icons.phone_in_talk_outlined,
    ),
    BookableSpace(
      name: 'Team Room North',
      type: 'Team room',
      capacity: 12,
      availability: 'Busy',
      price: '900 MKD/hour',
      amenities: ['TV', 'Whiteboard', 'HDMI'],
      icon: Icons.groups_outlined,
    ),
  ];

  Future<void> _handleModeChanged(BookMode nextMode) async {
    if (nextMode == _mode) return;

    final draft = context.read<BookingDraftProvider>();
    final leavingHostEvent = _mode == BookMode.hostEvent;

    if (leavingHostEvent && draft.hasDraft) {
      final decision = await showBookingDraftDialog(context: context);
      if (!mounted) return;
      if (decision == BookingDraftDecision.discardDraft) {
        draft.clear();
      }
    }

    if (!mounted) return;
    setState(() => _mode = nextMode);
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;

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
                        colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ModeSwitcher(mode: _mode, onChanged: _handleModeChanged),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
                  child: _mode == BookMode.coworking
                      ? CoworkingSection(
                          activeFloor: _activeFloor,
                          onFloorChanged: (floor) =>
                              setState(() => _activeFloor = floor),
                          spaces: _activeFloor == FloorType.ground
                              ? _groundFloorSpaces
                              : _firstFloorSpaces,
                        )
                      : const HostEventSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

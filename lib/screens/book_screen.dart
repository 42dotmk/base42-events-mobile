import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/booking/host_event_section.dart';
import 'package:base42_events_mobile/widgets/common/page_header.dart';
import 'package:flutter/material.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key});

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
              const PageHeader(
                title: 'Book a Space',
                subtitle: 'Reserve a space for your event, workshop, or meetup',
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
                  child: const HostEventSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

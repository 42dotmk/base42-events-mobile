import 'package:base42_events_mobile/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/services/event_service.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/event_card.dart';
import 'package:base42_events_mobile/widgets/error_view.dart';
import 'package:base42_events_mobile/widgets/empty_view.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final EventService _eventService = EventService();
  List<Event> _events = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final events = await _eventService.fetchEvents();
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = _query.trim().isEmpty
        ? _events
        : _events
              .where(
                (e) =>
                    e.title.toLowerCase().contains(_query.toLowerCase()) ||
                    e.summary.toLowerCase().contains(_query.toLowerCase()) ||
                    e.tags.any(
                      (t) => t.tagName.toLowerCase().contains(
                        _query.toLowerCase(),
                      ),
                    ),
              )
              .toList();

    return Scaffold(
      appBar: const HeaderWidget(),
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: context.textStyles.bodyMedium?.withColor(
                        Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search…',
                        hintStyle: context.textStyles.bodyMedium?.withColor(
                          colorScheme.onSurfaceVariant,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () => setState(() => _query = ''),
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      )
                    : _errorMessage != null
                    ? ErrorView(message: _errorMessage!, onRetry: _loadEvents)
                    : filtered.isEmpty
                    ? const EmptyView()
                    : RefreshIndicator(
                        onRefresh: _loadEvents,
                        color: colorScheme.primary,
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: AppSpacing.lg),
                          itemBuilder: (context, index) => EventCard(
                            event: filtered[index],
                            onTap: () => context.push(
                              '/event/${filtered[index].id}',
                              extra: filtered[index],
                            ),
                          ),
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

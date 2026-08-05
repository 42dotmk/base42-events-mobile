import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:base42_events_mobile/models/event.dart';
import 'package:base42_events_mobile/providers/event_provider.dart';
import 'package:base42_events_mobile/theme.dart';
import 'package:base42_events_mobile/widgets/error_view.dart';
import 'package:base42_events_mobile/widgets/event_list_content.dart';

class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _activeTag = 'All';

  List<String> _extractTags(List<Event> events) {
    final allTags = <String>['All'];
    final seenLowerTags = <String>{'all'};

    for (final event in events) {
      for (final tag in event.tags) {
        final normalized = tag.tagName.trim();
        if (normalized.isEmpty) continue;
        final lower = normalized.toLowerCase();
        if (seenLowerTags.add(lower)) {
          allTags.add(normalized);
        }
      }
    }

    return allTags;
  }

  bool _hasTag(List<String> tags, String candidate) {
    final normalizedCandidate = candidate.trim().toLowerCase();
    return tags.any((tag) => tag.trim().toLowerCase() == normalizedCandidate);
  }

  String _capitalizeFirst(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventProvider = context.read<EventProvider>();
      if (eventProvider.events.isEmpty && !eventProvider.isLoading) {
        eventProvider.loadEvents();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>();
    final colorScheme = Theme.of(context).colorScheme;
    final eventProvider = context.watch<EventProvider>();

    final events = eventProvider.events;
    final isLoading = eventProvider.isLoading;
    final errorMessage = eventProvider.errorMessage;

    final allTags = _extractTags(events);
    final primaryAccent = colorScheme.primary;
    final activeTag = _hasTag(allTags, _activeTag) ? _activeTag : 'All';

    final filtered = events.where((e) {
      final query = _query.trim().toLowerCase();
      final matchesSearch =
          query.isEmpty ||
          e.title.toLowerCase().contains(query) ||
          e.summary.toLowerCase().contains(query) ||
          e.tags.any((t) => t.tagName.toLowerCase().contains(query));

      final matchesTag =
          activeTag.trim().toLowerCase() == 'all' ||
          e.tags.any(
            (t) =>
                t.tagName.trim().toLowerCase() ==
                activeTag.trim().toLowerCase(),
          );

      return matchesSearch && matchesTag;
    }).toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: brand?.backdropGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      'Events',
                      style: context.textStyles.headlineSmall?.bold.withColor(
                        colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Where builders and curious minds gather',
                      style: context.textStyles.bodySmall?.withColor(
                        colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                      style: context.textStyles.bodyMedium?.withColor(
                        colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search events...',
                        hintStyle: context.textStyles.bodyMedium?.withColor(
                          colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        filled: true,
                        fillColor: colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.35),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _query = '');
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.outline.withValues(alpha: 0.25),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.outline.withValues(alpha: 0.25),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: colorScheme.primary.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ),
                  ],
                    ),
              ),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  itemCount: allTags.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final tag = allTags[index];
                    final isActive =
                        tag.trim().toLowerCase() ==
                        activeTag.trim().toLowerCase();
                    return ChoiceChip(
                      label: Text(_capitalizeFirst(tag)),
                      selected: isActive,
                      onSelected: (_) => setState(() => _activeTag = tag),
                      showCheckmark: false,
                      labelStyle: context.textStyles.labelMedium?.medium
                          .withColor(
                            isActive
                                ? colorScheme.surface
                                : colorScheme.onSurface.withValues(alpha: 0.75),
                          ),
                      selectedColor: primaryAccent,
                      backgroundColor: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.32),
                      side: BorderSide(
                        color: isActive
                            ? Colors.transparent
                            : colorScheme.outline.withValues(alpha: 0.25),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      visualDensity: VisualDensity.compact,
                    );
                  },
                ),
              ),
              Expanded(
child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                        )
                      : errorMessage != null
                      ? ErrorView(
                          message: errorMessage,
                          onRetry: () =>
                              context.read<EventProvider>().loadEvents(),
                        )
                      : filtered.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 42,
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.45,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'No events found',
                                  style: context.textStyles.titleMedium
                                      ?.withColor(
                                        colorScheme.onSurface.withValues(
                                          alpha: 0.72,
                                        ),
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Try adjusting your filters',
                                  style: context.textStyles.bodySmall?.withColor(
                                    colorScheme.onSurface.withValues(alpha: 0.52),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : EventListContent(
                          events: filtered,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

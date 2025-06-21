import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/events/events_bloc.dart';
import '../blocs/events/events_event.dart';
import '../blocs/events/events_state.dart';

class SearchAndFilters extends StatefulWidget {
  const SearchAndFilters({super.key});

  @override
  State<SearchAndFilters> createState() => _SearchAndFiltersState();
}

class _SearchAndFiltersState extends State<SearchAndFilters> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Searchbar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search events...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<EventsBloc>().add(
                              const SearchEvents(query: ''),
                            );
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {}); // To update suffixIcon...
                  context.read<EventsBloc>().add(
                    SearchEvents(query: value),
                  );
                },
              ),
              
              const SizedBox(height: 12),
              
              // Filter
              Row(
                children: [
                  // Category filter
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: state.selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('All Categories'),
                        ),
                        ...state.categories.map((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }),
                      ],
                      onChanged: (String? value) {
                        if (value == null) {
                          context.read<EventsBloc>().add(const ClearFilters());
                        } else {
                          context.read<EventsBloc>().add(
                            FilterEventsByCategory(category: value),
                          );
                        }
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Date filter button
                  ElevatedButton.icon(
                    onPressed: () => _showDateRangeFilter(context),
                    icon: const Icon(Icons.date_range, size: 20),
                    label: const Text('Date'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
              
              // Show active filters
              if (state.selectedCategory != null || 
                  state.startDateFilter != null ||
                  state.searchQuery.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      const Text(
                        'Active filters: ',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Expanded(
                        child: Wrap(
                          spacing: 4,
                          children: [
                            if (state.searchQuery.isNotEmpty)
                              Chip(
                                label: Text('Search: "${state.searchQuery}"'),
                                onDeleted: () {
                                  _searchController.clear();
                                  context.read<EventsBloc>().add(
                                    const SearchEvents(query: ''),
                                  );
                                },
                              ),
                            if (state.selectedCategory != null)
                              Chip(
                                label: Text(state.selectedCategory!),
                                onDeleted: () {
                                  context.read<EventsBloc>().add(
                                    const ClearFilters(),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _searchController.clear();
                          context.read<EventsBloc>().add(const ClearFilters());
                        },
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDateRangeFilter(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      currentDate: DateTime.now(),
    );

    if (picked != null && context.mounted) {
      context.read<EventsBloc>().add(
        FilterEventsByDateRange(
          startDate: picked.start,
          endDate: picked.end,
        ),
      );
    }
  }
}
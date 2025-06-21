import 'package:equatable/equatable.dart';
import '../../../domain/models/event.dart';

enum EventsStatus { initial, loading, success, failure }

class EventsState extends Equatable {
  const EventsState({
    this.status = EventsStatus.initial,
    this.events = const [],
    this.filteredEvents = const [],
    this.categories = const [],
    this.selectedCategory,
    this.searchQuery = '',
    this.startDateFilter,
    this.endDateFilter,
    this.errorMessage,
  });

  final EventsStatus status;
  final List<Event> events;
  final List<Event> filteredEvents;
  final List<String> categories;
  final String? selectedCategory;
  final String searchQuery;
  final DateTime? startDateFilter;
  final DateTime? endDateFilter;
  final String? errorMessage;

  // Getter for the events to display (filtered or all)
  List<Event> get displayEvents => filteredEvents.isNotEmpty ? filteredEvents : events;

  EventsState copyWith({
    EventsStatus? status,
    List<Event>? events,
    List<Event>? filteredEvents,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    DateTime? startDateFilter,
    DateTime? endDateFilter,
    String? errorMessage,
  }) {
    return EventsState(
      status: status ?? this.status,
      events: events ?? this.events,
      filteredEvents: filteredEvents ?? this.filteredEvents,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      startDateFilter: startDateFilter ?? this.startDateFilter,
      endDateFilter: endDateFilter ?? this.endDateFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  EventsState clearFilters() {
    return EventsState(
      status: status,
      events: events,
      filteredEvents: const [],
      categories: categories,
      selectedCategory: null,
      searchQuery: '',
      startDateFilter: null,
      endDateFilter: null,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        events,
        filteredEvents,
        categories,
        selectedCategory,
        searchQuery,
        startDateFilter,
        endDateFilter,
        errorMessage,
      ];
}
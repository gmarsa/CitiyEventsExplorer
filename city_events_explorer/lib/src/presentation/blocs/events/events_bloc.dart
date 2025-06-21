import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/models/event.dart';
import '../../../domain/repositories/events_repository.dart';
import 'events_event.dart';
import 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc({required this.eventsRepository}) : super(const EventsState()) {
    on<LoadEvents>(_onLoadEvents);
    on<RefreshEvents>(_onRefreshEvents);
    on<FilterEventsByCategory>(_onFilterEventsByCategory);
    on<FilterEventsByDateRange>(_onFilterEventsByDateRange);
    on<SearchEvents>(_onSearchEvents);
    on<ClearFilters>(_onClearFilters);
  }

  final EventsRepository eventsRepository;

  Future<void> _onLoadEvents(
    LoadEvents event,
    Emitter<EventsState> emit,
  ) async {
    emit(state.copyWith(status: EventsStatus.loading));

    try {
      final List<Event> events = await eventsRepository.getEvents();
      final List<String> categories = await eventsRepository.getCategories();

      emit(state.copyWith(
        status: EventsStatus.success,
        events: events,
        categories: categories,
        filteredEvents: const [],
      ));
    } catch (error) {
      emit(state.copyWith(
        status: EventsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onRefreshEvents(
    RefreshEvents event,
    Emitter<EventsState> emit,
  ) async {
    // Para refresh, mantenemos los datos actuales mientras cargamos
    try {
      final List<Event> events = await eventsRepository.getEvents();
      final List<String> categories = await eventsRepository.getCategories();

      emit(state.copyWith(
        status: EventsStatus.success,
        events: events,
        categories: categories,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: EventsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onFilterEventsByCategory(
    FilterEventsByCategory event,
    Emitter<EventsState> emit,
  ) async {
    try {
      if (event.category.isEmpty) {
        emit(state.copyWith(
          filteredEvents: const [],
          selectedCategory: null,
        ));
        return;
      }

      final List<Event> filteredEvents = 
          await eventsRepository.filterEventsByCategory(event.category);

      emit(state.copyWith(
        filteredEvents: filteredEvents,
        selectedCategory: event.category,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: EventsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onFilterEventsByDateRange(
    FilterEventsByDateRange event,
    Emitter<EventsState> emit,
  ) async {
    try {
      final List<Event> filteredEvents = 
          await eventsRepository.filterEventsByDateRange(
            event.startDate,
            event.endDate,
          );

      emit(state.copyWith(
        filteredEvents: filteredEvents,
        startDateFilter: event.startDate,
        endDateFilter: event.endDate,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: EventsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  Future<void> _onSearchEvents(
    SearchEvents event,
    Emitter<EventsState> emit,
  ) async {
    try {
      if (event.query.isEmpty) {
        emit(state.copyWith(
          filteredEvents: const [],
          searchQuery: '',
        ));
        return;
      }

      final List<Event> searchResults = 
          await eventsRepository.searchEvents(event.query);

      emit(state.copyWith(
        filteredEvents: searchResults,
        searchQuery: event.query,
      ));
    } catch (error) {
      emit(state.copyWith(
        status: EventsStatus.failure,
        errorMessage: error.toString(),
      ));
    }
  }

  void _onClearFilters(
    ClearFilters event,
    Emitter<EventsState> emit,
  ) {
    emit(state.clearFilters());
  }
}
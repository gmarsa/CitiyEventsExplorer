import 'package:equatable/equatable.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoadEvents extends EventsEvent {
  const LoadEvents();
}

class RefreshEvents extends EventsEvent {
  const RefreshEvents();
}

class FilterEventsByCategory extends EventsEvent {
  const FilterEventsByCategory({required this.category});

  final String category;

  @override
  List<Object?> get props => <Object?>[category];
}

class FilterEventsByDateRange extends EventsEvent {
  const FilterEventsByDateRange({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => <Object?>[startDate, endDate];
}

class SearchEvents extends EventsEvent {
  const SearchEvents({required this.query});

  final String query;

  @override
  List<Object?> get props => <Object?>[query];
}

class ClearFilters extends EventsEvent {
  const ClearFilters();
}
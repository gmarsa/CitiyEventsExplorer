import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:city_events_explorer/src/domain/models/event.dart';
import 'package:city_events_explorer/src/domain/models/location.dart';
import 'package:city_events_explorer/src/domain/repositories/events_repository.dart';
import 'package:city_events_explorer/src/presentation/blocs/events/events_bloc.dart';
import 'package:city_events_explorer/src/presentation/blocs/events/events_event.dart';
import 'package:city_events_explorer/src/presentation/blocs/events/events_state.dart';

import 'events_bloc_test.mocks.dart';

@GenerateMocks([EventsRepository])
void main() {
  group('EventsBloc', () {
    late EventsBloc eventsBloc;
    late MockEventsRepository mockRepository;

    setUp(() {
      mockRepository = MockEventsRepository();
      eventsBloc = EventsBloc(eventsRepository: mockRepository);
    });

    tearDown(() {
      eventsBloc.close();
    });

    final testEvents = [
      Event(
        id: '1',
        title: 'Test Event 1',
        description: 'Description 1',
        category: 'Technology',
        startDate: DateTime(2025, 7, 1, 18, 0),
        endDate: DateTime(2025, 7, 1, 19, 0),
        imageUrl: 'https://example.com/image1.jpg',
        location: const Location(
          name: 'Test Location 1',
          lat: 40.7589,
          lng: -73.9851,
        ),
      ),
    ];

    test('initial state is correct', () {
      expect(eventsBloc.state, const EventsState());
      expect(eventsBloc.state.status, EventsStatus.initial);
    });

    test('LoadEvents emits success state when repository succeeds', () async {
      // Arrange
      when(mockRepository.getEvents()).thenAnswer((_) async => testEvents);
      when(mockRepository.getCategories()).thenAnswer((_) async => ['Technology']);

      // Act
      eventsBloc.add(const LoadEvents());
      
      // Wait for the bloc to process the event
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(eventsBloc.state.status, EventsStatus.success);
      expect(eventsBloc.state.events, testEvents);
      expect(eventsBloc.state.categories, ['Technology']);
      
      verify(mockRepository.getEvents()).called(1);
      verify(mockRepository.getCategories()).called(1);
    });

    test('LoadEvents emits failure state when repository throws exception', () async {
      // Arrange
      when(mockRepository.getEvents()).thenThrow(Exception('Failed to load events'));

      // Act
      eventsBloc.add(const LoadEvents());
      
      // Wait for the bloc to process the event
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(eventsBloc.state.status, EventsStatus.failure);
      expect(eventsBloc.state.errorMessage, contains('Failed to load events'));
    });

    test('SearchEvents updates search query and filtered events', () async {
      // Arrange
      when(mockRepository.searchEvents('Technology')).thenAnswer((_) async => testEvents);

      // Act
      eventsBloc.add(const SearchEvents(query: 'Technology'));
      
      // Wait for the bloc to process the event
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert
      expect(eventsBloc.state.searchQuery, 'Technology');
      expect(eventsBloc.state.filteredEvents, testEvents);
      
      verify(mockRepository.searchEvents('Technology')).called(1);
    });

    test('ClearFilters resets all filters', () {
      // Act
      eventsBloc.add(const ClearFilters());

      // Assert
      expect(eventsBloc.state.filteredEvents, isEmpty);
      expect(eventsBloc.state.selectedCategory, isNull);
      expect(eventsBloc.state.searchQuery, isEmpty);
    });
  });
}
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:city_events_explorer/src/data/datasources/events_local_datasource.dart';
import 'package:city_events_explorer/src/data/repositories/events_repository_impl.dart';
import 'package:city_events_explorer/src/domain/models/event.dart';
import 'package:city_events_explorer/src/domain/models/location.dart';

import 'events_repository_test.mocks.dart';

@GenerateMocks([EventsLocalDataSource])
void main() {
  group('EventsRepositoryImpl', () {
    late EventsRepositoryImpl repository;
    late MockEventsLocalDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockEventsLocalDataSource();
      repository = EventsRepositoryImpl(localDataSource: mockDataSource);
    });

    final testEvents = [
      Event(
        id: '1',
        title: 'Test Event 1',
        description: 'Description 1',
        category: 'Technology',  // ← Con 'T' mayúscula
        startDate: DateTime(2025, 7, 1, 18, 0),
        endDate: DateTime(2025, 7, 1, 19, 0),
        imageUrl: 'https://example.com/image1.jpg',
        location: const Location(
          name: 'Test Location 1',
          lat: 40.7589,
          lng: -73.9851,
        ),
      ),
      Event(
        id: '2',
        title: 'Test Event 2',
        description: 'Description 2',
        category: 'Sports',
        startDate: DateTime(2025, 7, 2, 10, 0),
        endDate: DateTime(2025, 7, 2, 12, 0),
        imageUrl: 'https://example.com/image2.jpg',
        location: const Location(
          name: 'Test Location 2',
          lat: 40.7614,
          lng: -73.9776,
        ),
      ),
    ];

    group('getEvents', () {
      test('should return list of events when data source succeeds', () async {
        // Arrange
        when(mockDataSource.getEvents()).thenAnswer((_) async => testEvents);

        // Act
        final result = await repository.getEvents();

        // Assert
        expect(result, equals(testEvents));
        verify(mockDataSource.getEvents()).called(1);
      });

      test('should throw exception when data source fails', () async {
        // Arrange
        when(mockDataSource.getEvents()).thenThrow(Exception('Data source error'));

        // Act & Assert
        expect(() => repository.getEvents(), throwsA(isA<Exception>()));
      });
    });

    group('searchEvents', () {
      test('should return filtered events by title', () async {
        // Arrange
        when(mockDataSource.getEvents()).thenAnswer((_) async => testEvents);

        // Act
        final result = await repository.searchEvents('Test Event 1');

        // Assert
        expect(result.length, 1);
        expect(result.first.title, 'Test Event 1');
      });

      test('should return filtered events by category', () async {
        // Arrange
        when(mockDataSource.getEvents()).thenAnswer((_) async => testEvents);

        // Act
        final result = await repository.searchEvents('Technology');

        // Assert
        expect(result.length, 1);
        expect(result.first.category, 'Technology');
      });

      test('should return all events when query is empty', () async {
        // Arrange
        when(mockDataSource.getEvents()).thenAnswer((_) async => testEvents);

        // Act
        final result = await repository.searchEvents('');

        // Assert
        expect(result, equals(testEvents));
      });

      test('should return empty list when no matches found', () async {
        // Arrange
        when(mockDataSource.getEvents()).thenAnswer((_) async => testEvents);

        // Act
        final result = await repository.searchEvents('Non-existent');

        // Assert
        expect(result, isEmpty);
      });
    });

    group('filterEventsByCategory', () {
      test('should return events with matching category', () async {
        // Arrange
        when(mockDataSource.getEvents()).thenAnswer((_) async => testEvents);

        // Act
        final result = await repository.filterEventsByCategory('Technology');

        // Assert
        expect(result.length, 1);
        expect(result.first.category, 'Technology');
      });

      test('should be case insensitive', () async {
        // Arrange
        when(mockDataSource.getEvents()).thenAnswer((_) async => testEvents);

        // Act - Buscar con 'technology' en minúsculas
        final result = await repository.filterEventsByCategory('technology');

        // Assert - Debe encontrar el evento con categoría 'Technology' (con T mayúscula)
        expect(result.length, 1);
        expect(result.first.category, 'Technology');
        expect(result.first.id, '1');
      });
    });

    group('getCategories', () {
      test('should return unique sorted categories', () async {
        // Arrange
        when(mockDataSource.getEvents()).thenAnswer((_) async => testEvents);

        // Act
        final result = await repository.getCategories();

        // Assert
        expect(result, ['Sports', 'Technology']); // Alphabetically sorted
        expect(result.toSet().length, result.length); // No duplicates
      });
    });
  });
}
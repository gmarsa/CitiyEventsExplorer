import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:city_events_explorer/src/domain/models/event.dart';
import 'package:city_events_explorer/src/domain/models/location.dart';
import 'package:city_events_explorer/src/domain/repositories/favourites_repository.dart';
import 'package:city_events_explorer/src/presentation/blocs/favourites/favourites_bloc.dart';
import 'package:city_events_explorer/src/presentation/blocs/favourites/favourites_state.dart';
import 'package:city_events_explorer/src/presentation/widgets/event_card.dart';

import 'event_card_test.mocks.dart';

@GenerateMocks([FavouritesRepository])
void main() {
  group('EventCard Widget Tests', () {
    late MockFavouritesRepository mockFavouritesRepository;
    late FavouritesBloc favouritesBloc;

    setUp(() {
      mockFavouritesRepository = MockFavouritesRepository();
      favouritesBloc = FavouritesBloc(favouritesRepository: mockFavouritesRepository);
    });

    tearDown(() {
      favouritesBloc.close();
    });

    final testEvent = Event(
      id: '1',
      title: 'Test Event',
      description: 'This is a test event description',
      category: 'Technology',
      startDate: DateTime(2025, 7, 1, 18, 0),
      endDate: DateTime(2025, 7, 1, 19, 0),
      imageUrl: 'https://example.com/image.jpg',
      location: const Location(
        name: 'Test Location',
        lat: 40.7589,
        lng: -73.9851,
      ),
    );

    Widget createWidgetUnderTest({
      required Event event,
      required VoidCallback onTap,
      bool isFavourite = false,
    }) {
      return MaterialApp(
        home: BlocProvider<FavouritesBloc>.value(
          value: favouritesBloc,
          child: Scaffold(
            body: EventCard(
              event: event,
              onTap: onTap,
            ),
          ),
        ),
      );
    }

    testWidgets('displays event information correctly', (WidgetTester tester) async {
      // Arrange
      bool onTapCalled = false;
      when(mockFavouritesRepository.getFavouriteEventIds()).thenAnswer((_) async => <String>{});

      // Act
      await tester.pumpWidget(
        createWidgetUnderTest(
          event: testEvent,
          onTap: () => onTapCalled = true,
        ),
      );
      await tester.pump(); // Allow any async operations to complete

      // Assert
      expect(find.text('Test Event'), findsOneWidget);
      expect(find.text('This is a test event description'), findsOneWidget);
      expect(find.text('Technology'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
    });

    testWidgets('calls onTap when card is tapped', (WidgetTester tester) async {
      // Arrange
      bool onTapCalled = false;
      when(mockFavouritesRepository.getFavouriteEventIds()).thenAnswer((_) async => <String>{});

      await tester.pumpWidget(
        createWidgetUnderTest(
          event: testEvent,
          onTap: () => onTapCalled = true,
        ),
      );
      await tester.pump();

      // Act
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Assert
      expect(onTapCalled, isTrue);
    });

    testWidgets('shows filled heart icon when event is favourite', (WidgetTester tester) async {
      // Arrange
      when(mockFavouritesRepository.getFavouriteEventIds()).thenAnswer((_) async => {'1'});
      
      // Update the bloc state to reflect the favourite
      when(mockFavouritesRepository.isFavourite('1')).thenAnswer((_) async => true);

      await tester.pumpWidget(
        createWidgetUnderTest(
          event: testEvent,
          onTap: () {},
        ),
      );

      // Wait for the bloc to load favourites
      await tester.pump();

      // Act - We need to manually set the state since we're testing the widget
      // In a real scenario, this would be handled by the bloc
      favouritesBloc.emit(const FavouritesState(
        status: FavouritesStatus.success,
        favouriteEventIds: {'1'},
      ));
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('shows empty heart icon when event is not favourite', (WidgetTester tester) async {
      // Arrange
      when(mockFavouritesRepository.getFavouriteEventIds()).thenAnswer((_) async => <String>{});

      await tester.pumpWidget(
        createWidgetUnderTest(
          event: testEvent,
          onTap: () {},
        ),
      );
      await tester.pump();

      // Assert
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('displays category chip with correct styling', (WidgetTester tester) async {
      // Arrange
      when(mockFavouritesRepository.getFavouriteEventIds()).thenAnswer((_) async => <String>{});

      await tester.pumpWidget(
        createWidgetUnderTest(
          event: testEvent,
          onTap: () {},
        ),
      );
      await tester.pump();

      // Assert
      final categoryWidget = find.text('Technology');
      expect(categoryWidget, findsOneWidget);
      
      // Verify the category chip container exists
      expect(find.byType(Container), findsWidgets);
    });
  });
}
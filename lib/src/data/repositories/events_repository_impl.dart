import '../../domain/models/event.dart';
import '../../domain/repositories/events_repository.dart';
import '../datasources/events_local_datasource.dart';

class EventsRepositoryImpl implements EventsRepository {
  const EventsRepositoryImpl({
    required this.localDataSource,
  });

  final EventsLocalDataSource localDataSource;

  @override
  Future<List<Event>> getEvents() async {
    try {
      return await localDataSource.getEvents();
    } catch (e) {
      throw Exception('Failed to get events: $e');
    }
  }

  @override
  Future<List<Event>> searchEvents(String query) async {
    try {
      final List<Event> allEvents = await localDataSource.getEvents();
      
      if (query.isEmpty) {
        return allEvents;
      }
      
      final String lowerQuery = query.toLowerCase();
      
      return allEvents.where((Event event) {
        return event.title.toLowerCase().contains(lowerQuery) ||
               event.description.toLowerCase().contains(lowerQuery) ||
               event.category.toLowerCase().contains(lowerQuery) ||
               event.location.name.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      throw Exception('Failed to search events: $e');
    }
  }

  @override
  Future<List<Event>> filterEventsByCategory(String category) async {
    try {
      final List<Event> allEvents = await localDataSource.getEvents();
      
      return allEvents.where((Event event) {
        return event.category.toLowerCase().trim() == category.toLowerCase().trim();
      }).toList();
    } catch (e) {
      throw Exception('Failed to filter events by category: $e');
    }
  }

  @override
  Future<List<Event>> filterEventsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final List<Event> allEvents = await localDataSource.getEvents();
      
      return allEvents.where((Event event) {
        final DateTime eventStart = event.startDate;
        return eventStart.isAfter(startDate.subtract(const Duration(days: 1))) &&
               eventStart.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    } catch (e) {
      throw Exception('Failed to filter events by date range: $e');
    }
  }

  @override  
  Future<List<String>> getCategories() async {
    try {
      final List<Event> allEvents = await localDataSource.getEvents();
      
      final Set<String> categories = allEvents
          .map((Event event) => event.category)
          .toSet();
      
      final List<String> categoriesList = categories.toList();
      categoriesList.sort();
      
      return categoriesList;
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }
}
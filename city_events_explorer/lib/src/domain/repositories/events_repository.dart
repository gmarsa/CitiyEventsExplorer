import '../models/event.dart';

abstract class EventsRepository {
  Future<List<Event>> getEvents();
  Future<List<Event>> searchEvents(String query);
  Future<List<Event>> filterEventsByCategory(String category);
  Future<List<Event>> filterEventsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<String>> getCategories();
}
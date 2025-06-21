import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/models/event.dart';

abstract class EventsLocalDataSource {
  Future<List<Event>> getEvents();
}

class EventsLocalDataSourceImpl implements EventsLocalDataSource {
  static const String _eventsPath = 'assets/data/events.json';

  @override
  Future<List<Event>> getEvents() async {
    try {
      final String jsonString = await rootBundle.loadString(_eventsPath);
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      
      return jsonList
          .map((dynamic json) => Event.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load events: $e');
    }
  }
}
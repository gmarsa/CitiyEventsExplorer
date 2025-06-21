import 'package:json_annotation/json_annotation.dart';
import 'location.dart';

part 'event.g.dart';
//To generate FromJson and ToJson 
@JsonSerializable()
class Event {
  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.location,
  });

  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime startDate;
  final DateTime endDate;
  final String imageUrl;
  final Location location;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);

  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? startDate,
    DateTime? endDate,
    String? imageUrl,
    Location? location,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Event &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.category == category &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.imageUrl == imageUrl &&
        other.location == location;
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        description,
        category,
        startDate,
        endDate,
        imageUrl,
        location,
      );

  @override
  String toString() {
    return 'Event(id: $id, title: $title, category: $category, startDate: $startDate, endDate: $endDate)';
  }
}
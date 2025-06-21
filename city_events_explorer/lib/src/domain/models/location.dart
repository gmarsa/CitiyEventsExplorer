import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';
//To automaticly generate json - object
@JsonSerializable()
class Location {
  const Location({
    required this.name,
    required this.lat,
    required this.lng,
  });

  final String name;
  final double lat;
  final double lng;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Location &&
        other.name == name &&
        other.lat == lat &&
        other.lng == lng;
  }

  @override
  int get hashCode => Object.hash(name, lat, lng);

  @override
  String toString() => 'Location(name: $name, lat: $lat, lng: $lng)';
}
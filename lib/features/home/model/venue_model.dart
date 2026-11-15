import 'package:equatable/equatable.dart';

/// A co-working venue stored in the `venues` collection.
class VenueModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String imageUrl;
  final int roomsCount;
  final double lat;
  final double lng;

  const VenueModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.imageUrl,
    required this.roomsCount,
    required this.lat,
    required this.lng,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      roomsCount: _asInt(json['roomsCount']),
      lat: _asDouble(json['lat']),
      lng: _asDouble(json['lng']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
        'roomsCount': roomsCount,
        'lat': lat,
        'lng': lng,
      };

  String get coordinatesLabel =>
      '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        categoryId,
        imageUrl,
        roomsCount,
        lat,
        lng,
      ];
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return 0;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return 0;
}

import 'package:equatable/equatable.dart';

/// Model representing a co-working venue/space.
class VenueModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String location;
  final String categoryId;
  final int totalRooms;
  final String vendorId;

  const VenueModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.categoryId,
    required this.totalRooms,
    required this.vendorId,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      location: json['location'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      totalRooms: json['totalRooms'] as int? ?? 0,
      vendorId: json['vendorId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'location': location,
        'categoryId': categoryId,
        'totalRooms': totalRooms,
        'vendorId': vendorId,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        location,
        categoryId,
        totalRooms,
        vendorId,
      ];
}

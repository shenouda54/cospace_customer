import 'package:equatable/equatable.dart';

/// A room booking stored in the `bookings` collection.
class BookingModel extends Equatable {
  final String id;
  final String venueId;
  final String venueName;
  final String customerId;
  final int roomNumber;
  final int seatsCount;
  final String date;
  final String timeSlot;
  final DateTime? createdAt;

  const BookingModel({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.customerId,
    required this.roomNumber,
    required this.seatsCount,
    required this.date,
    required this.timeSlot,
    this.createdAt,
  });

  /// Document id that locks one room to one date and time slot.
  String get uniqueSlotLockId => '${venueId}_room${roomNumber}_${date}_$timeSlot';

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String? ?? '',
      venueId: json['venueId'] as String? ?? '',
      venueName: json['venueName'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      roomNumber: _asInt(json['roomNumber'], fallback: 1),
      seatsCount: _asInt(json['seatsCount'], fallback: 1),
      date: json['date'] as String? ?? '',
      timeSlot: json['timeSlot'] as String? ?? '',
      createdAt: _parseCreatedAt(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'venueId': venueId,
        'venueName': venueName,
        'customerId': customerId,
        'roomNumber': roomNumber,
        'seatsCount': seatsCount,
        'date': date,
        'timeSlot': timeSlot,
        if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        venueId,
        venueName,
        customerId,
        roomNumber,
        seatsCount,
        date,
        timeSlot,
        createdAt,
      ];
}

int _asInt(dynamic value, {required int fallback}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return fallback;
}

DateTime? _parseCreatedAt(dynamic value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  try {
    final dynamic stamp = value;
    final result = stamp?.toDate();
    if (result is DateTime) return result;
  } catch (_) {}
  return null;
}

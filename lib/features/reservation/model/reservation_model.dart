import 'package:equatable/equatable.dart';

/// Model representing a room reservation (booking).
class ReservationModel extends Equatable {
  final String id;
  final String venueId;
  final String venueName;
  final String customerId;
  final int roomNumber;
  final int seatsCount; // 1 to 6 max
  final String reservationDate; // YYYY-MM-DD
  final String timeSlot; // One of the 5 fixed daily slots

  const ReservationModel({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.customerId,
    required this.roomNumber,
    required this.seatsCount,
    required this.reservationDate,
    required this.timeSlot,
  });

  /// Composite unique key to prevent double-booking the same room+date+slot.
  String get uniqueSlotLockId =>
      '${venueId}_room${roomNumber}_${reservationDate}_$timeSlot';

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'] as String? ?? '',
      venueId: json['venueId'] as String? ?? '',
      venueName: json['venueName'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      roomNumber: json['roomNumber'] as int? ?? 1,
      seatsCount: json['seatsCount'] as int? ?? 1,
      reservationDate: json['reservationDate'] as String? ?? '',
      timeSlot: json['timeSlot'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'venueId': venueId,
        'venueName': venueName,
        'customerId': customerId,
        'roomNumber': roomNumber,
        'seatsCount': seatsCount,
        'reservationDate': reservationDate,
        'timeSlot': timeSlot,
      };

  @override
  List<Object?> get props => [
        id,
        venueId,
        venueName,
        customerId,
        roomNumber,
        seatsCount,
        reservationDate,
        timeSlot,
      ];
}

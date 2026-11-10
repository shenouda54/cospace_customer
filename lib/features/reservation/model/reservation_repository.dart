import 'package:cospace_customer/core/constants/app_constants.dart';
import 'package:cospace_customer/core/services/firebase_service.dart';
import 'package:cospace_customer/features/reservation/model/reservation_model.dart';

/// Custom exception when a slot is already booked.
class SlotAlreadyBookedException implements Exception {
  const SlotAlreadyBookedException();

  @override
  String toString() => 'This time slot is already booked.';
}

/// Repository for managing reservations with real-time concurrency control.
class ReservationRepository {
  final _firebase = FirebaseService.instance;

  /// Atomically book a room using a Firestore Transaction.
  /// Throws [SlotAlreadyBookedException] if the slot is taken.
  Future<void> bookRoomInRealTime(ReservationModel reservation) async {
    // ── Server-side validation (Hostile Client Mindset) ──
    assert(
      reservation.seatsCount >= AppConstants.minSeatsPerRoom &&
          reservation.seatsCount <= AppConstants.maxSeatsPerRoom,
      'Seats must be between ${AppConstants.minSeatsPerRoom} and ${AppConstants.maxSeatsPerRoom}',
    );
    assert(
      AppConstants.dailyFixedTimeSlots.contains(reservation.timeSlot),
      'Invalid time slot: ${reservation.timeSlot}',
    );

    final docRef = _firebase.reservationsRef.doc(reservation.uniqueSlotLockId);

    await _firebase.firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (snapshot.exists) {
        throw const SlotAlreadyBookedException();
      }
      transaction.set(docRef, reservation.toJson());
    });
  }

  /// Stream of reservations for a specific venue and date (real-time updates).
  Stream<List<ReservationModel>> watchReservations({
    required String venueId,
    required String reservationDate,
  }) {
    return _firebase.reservationsRef
        .where('venueId', isEqualTo: venueId)
        .where('reservationDate', isEqualTo: reservationDate)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) =>
                ReservationModel.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }
}

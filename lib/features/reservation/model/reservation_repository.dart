import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cospace_customer/core/constants/app_constants.dart';
import 'package:cospace_customer/core/services/firebase_service.dart';
import 'package:cospace_customer/features/reservation/model/booking_model.dart';

/// Thrown when the same room, date, and time slot is already booked.
class SlotAlreadyBookedException implements Exception {
  const SlotAlreadyBookedException();
}

/// Reads and writes the shared `bookings` collection.
class ReservationRepository {
  ReservationRepository({FirebaseService? firebase})
      : _firebase = firebase ?? FirebaseService.instance;

  final FirebaseService _firebase;
  static final List<BookingModel> _localBookings = [];

  /// Books a room with a transaction so two customers cannot take the same slot.
  Future<void> bookRoomInRealTime(BookingModel booking) async {
    if (booking.customerId.isEmpty) {
      throw ArgumentError('Customer must be logged in.');
    }
    if (booking.seatsCount < AppConstants.minSeatsPerRoom ||
        booking.seatsCount > AppConstants.maxSeatsPerRoom) {
      throw ArgumentError('Invalid seat count.');
    }
    if (!AppConstants.dailyFixedTimeSlots.contains(booking.timeSlot)) {
      throw ArgumentError('Invalid time slot.');
    }
    if (booking.roomNumber < 1) {
      throw ArgumentError('Invalid room number.');
    }

    final lockId = booking.uniqueSlotLockId;

    if (!_firebase.isInitialized) {
      final taken = _localBookings.any((item) => item.uniqueSlotLockId == lockId);
      if (taken) throw const SlotAlreadyBookedException();
      _localBookings.add(
        BookingModel(
          id: lockId,
          venueId: booking.venueId,
          venueName: booking.venueName,
          customerId: booking.customerId,
          roomNumber: booking.roomNumber,
          seatsCount: booking.seatsCount,
          date: booking.date,
          timeSlot: booking.timeSlot,
          createdAt: DateTime.now(),
        ),
      );
      return;
    }

    final docRef = _firebase.bookingsRef.doc(lockId);
    await _firebase.firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (snapshot.exists) {
        throw const SlotAlreadyBookedException();
      }
      transaction.set(docRef, {
        ...booking.toJson(),
        'id': lockId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Live bookings for one venue. Date and room are filtered by the cubit.
  Stream<List<BookingModel>> watchVenueBookings({required String venueId}) {
    if (!_firebase.isInitialized) {
      final matches =
          _localBookings.where((item) => item.venueId == venueId).toList();
      return Stream.value(matches);
    }

    return _firebase.bookingsRef
        .where('venueId', isEqualTo: venueId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => BookingModel.fromJson({...doc.data(), 'id': doc.id}),
              )
              .toList(),
        );
  }
}

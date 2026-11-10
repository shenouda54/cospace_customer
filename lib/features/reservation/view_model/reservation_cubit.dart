import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/core/constants/app_constants.dart';
import 'package:cospace_customer/core/services/firebase_service.dart';
import 'package:cospace_customer/core/services/vendor_notification_dispatcher.dart';
import 'package:cospace_customer/features/reservation/model/reservation_model.dart';
import 'package:cospace_customer/features/reservation/model/reservation_repository.dart';
import 'package:cospace_customer/features/reservation/view_model/reservation_state.dart';

/// Cubit managing the reservation flow with real-time slot updates.
class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit({ReservationRepository? reservationRepository})
      : _repository = reservationRepository ?? ReservationRepository(),
        super(const ReservationInitial());

  final ReservationRepository _repository;
  StreamSubscription? _reservationSubscription;

  /// Start listening to real-time reservation updates for a venue and date.
  void watchSlots({
    required String venueId,
    required String reservationDate,
  }) {
    _reservationSubscription?.cancel();
    _reservationSubscription = _repository
        .watchReservations(venueId: venueId, reservationDate: reservationDate)
        .listen(
      (reservations) {
        final currentState = state;
        if (currentState is ReservationSlotsLoaded) {
          emit(currentState.copyWith(existingReservations: reservations));
        } else {
          emit(ReservationSlotsLoaded(existingReservations: reservations));
        }
      },
      onError: (error) => emit(ReservationError(error.toString())),
    );
  }

  /// Select a room number.
  void selectRoomNumber(int roomNumber) {
    final currentState = state;
    if (currentState is ReservationSlotsLoaded) {
      emit(currentState.copyWith(
        selectedRoomNumber: roomNumber,
        selectedTimeSlot: null, // Reset time slot when room changes
      ));
    }
  }

  /// Increment guest seats (max 6).
  void incrementGuestSeats() {
    final currentState = state;
    if (currentState is ReservationSlotsLoaded) {
      if (currentState.seatsCount < AppConstants.maxSeatsPerRoom) {
        emit(currentState.copyWith(
          seatsCount: currentState.seatsCount + 1,
        ));
      }
    }
  }

  /// Decrement guest seats (min 1).
  void decrementGuestSeats() {
    final currentState = state;
    if (currentState is ReservationSlotsLoaded) {
      if (currentState.seatsCount > AppConstants.minSeatsPerRoom) {
        emit(currentState.copyWith(
          seatsCount: currentState.seatsCount - 1,
        ));
      }
    }
  }

  /// Select a date.
  void selectDate(String date) {
    final currentState = state;
    if (currentState is ReservationSlotsLoaded) {
      emit(currentState.copyWith(selectedDate: date));
    }
  }

  /// Select a time slot.
  void selectTimeSlot(String timeSlot) {
    final currentState = state;
    if (currentState is ReservationSlotsLoaded) {
      // Validate the slot is one of the fixed slots
      if (!AppConstants.dailyFixedTimeSlots.contains(timeSlot)) return;

      // Check it's not already booked
      if (currentState.selectedRoomNumber != null &&
          currentState.isSlotBooked(
              currentState.selectedRoomNumber!, timeSlot)) {
        return;
      }

      emit(currentState.copyWith(selectedTimeSlot: timeSlot));
    }
  }

  /// Confirm the booking atomically.
  Future<void> confirmRealtimeBooking({
    required String venueId,
    required String venueName,
  }) async {
    final currentState = state;
    if (currentState is! ReservationSlotsLoaded) return;

    // ── Validation (Hostile Client Mindset) ──
    final customerId =
        FirebaseService.instance.currentUser?.uid ?? 'demo_customer_1';
    if (currentState.selectedRoomNumber == null ||
        currentState.selectedDate == null ||
        currentState.selectedTimeSlot == null) {
      emit(const ReservationError('Please complete all booking details.'));
      return;
    }
    if (currentState.seatsCount < AppConstants.minSeatsPerRoom ||
        currentState.seatsCount > AppConstants.maxSeatsPerRoom) {
      emit(const ReservationError('Invalid seat count.'));
      return;
    }
    if (!AppConstants.dailyFixedTimeSlots
        .contains(currentState.selectedTimeSlot)) {
      emit(const ReservationError('Invalid time slot.'));
      return;
    }

    emit(const ReservationLoading());
    try {
      final reservation = ReservationModel(
        id: '',
        venueId: venueId,
        venueName: venueName,
        customerId: customerId,
        roomNumber: currentState.selectedRoomNumber!,
        seatsCount: currentState.seatsCount,
        reservationDate: currentState.selectedDate!,
        timeSlot: currentState.selectedTimeSlot!,
      );

      await _repository.bookRoomInRealTime(reservation);

      // Dispatch notification to Vendor app
      await VendorNotificationDispatcher.instance.dispatchBookingNotification(
        venueId: venueId,
        venueName: venueName,
        customerName: '', // Will be filled from user profile
        roomNumber: currentState.selectedRoomNumber!,
        reservationDate: currentState.selectedDate!,
        timeSlot: currentState.selectedTimeSlot!,
      );

      emit(const ReservationBookingSuccess());
    } on SlotAlreadyBookedException {
      emit(const ReservationError('This time slot is already booked.'));
    } catch (e) {
      emit(ReservationError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _reservationSubscription?.cancel();
    return super.close();
  }
}

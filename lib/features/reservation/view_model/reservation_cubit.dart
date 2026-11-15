import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/core/constants/app_constants.dart';
import 'package:cospace_customer/core/utils/extensions/date_extensions.dart';
import 'package:cospace_customer/features/reservation/model/booking_model.dart';
import 'package:cospace_customer/features/reservation/model/reservation_repository.dart';
import 'package:cospace_customer/features/reservation/view_model/reservation_state.dart';

/// Cubit for room selection and real-time slot booking.
class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit({ReservationRepository? reservationRepository})
      : _repository = reservationRepository ?? ReservationRepository(),
        super(const ReservationInitial());

  final ReservationRepository _repository;
  StreamSubscription<List<BookingModel>>? _bookingSubscription;

  /// Starts a booking session and listens to this venue's bookings.
  void startBooking({required String venueId}) {
    _bookingSubscription?.cancel();
    emit(ReservationSlotsLoaded(
      venueId: venueId,
      bookings: const [],
      selectedDate: DateTime.now().toFirestoreDate(),
    ));

    _bookingSubscription = _repository
        .watchVenueBookings(venueId: venueId)
        .listen(
      (bookings) {
        final current = state;
        if (current is ReservationSlotsLoaded && current.venueId == venueId) {
          emit(current.copyWith(bookings: bookings));
        }
      },
      onError: (_) => _notify(BookingNotice.failed),
    );
  }

  void stopWatching() {
    _bookingSubscription?.cancel();
    _bookingSubscription = null;
  }

  void selectRoomNumber(int roomNumber) {
    final current = state;
    if (current is! ReservationSlotsLoaded) return;
    emit(current.copyWith(
      selectedRoomNumber: roomNumber,
      clearTimeSlot: true,
    ));
  }

  void incrementGuestSeats() {
    final current = state;
    if (current is! ReservationSlotsLoaded) return;
    if (current.seatsCount >= AppConstants.maxSeatsPerRoom) return;
    emit(current.copyWith(seatsCount: current.seatsCount + 1));
  }

  void decrementGuestSeats() {
    final current = state;
    if (current is! ReservationSlotsLoaded) return;
    if (current.seatsCount <= AppConstants.minSeatsPerRoom) return;
    emit(current.copyWith(seatsCount: current.seatsCount - 1));
  }

  void selectDate(String date) {
    final current = state;
    if (current is! ReservationSlotsLoaded) return;
    emit(current.copyWith(selectedDate: date, clearTimeSlot: true));
  }

  void selectTimeSlot(String timeSlot) {
    final current = state;
    if (current is! ReservationSlotsLoaded) return;
    if (!AppConstants.dailyFixedTimeSlots.contains(timeSlot)) return;
    final roomNumber = current.selectedRoomNumber;
    if (roomNumber == null) return;
    if (current.isSlotBooked(roomNumber, timeSlot)) return;
    emit(current.copyWith(selectedTimeSlot: timeSlot));
  }

  Future<void> confirmRealtimeBooking({
    required String venueId,
    required String venueName,
    required String customerId,
  }) async {
    final current = state;
    if (current is! ReservationSlotsLoaded || current.isSubmitting) return;

    if (customerId.isEmpty) {
      _notify(BookingNotice.loginRequired);
      return;
    }
    if (current.selectedRoomNumber == null ||
        current.selectedDate == null ||
        current.selectedTimeSlot == null) {
      _notify(BookingNotice.incomplete);
      return;
    }
    if (current.seatsCount < AppConstants.minSeatsPerRoom ||
        current.seatsCount > AppConstants.maxSeatsPerRoom) {
      _notify(BookingNotice.invalidSeats);
      return;
    }
    if (!AppConstants.dailyFixedTimeSlots.contains(current.selectedTimeSlot)) {
      _notify(BookingNotice.invalidSlot);
      return;
    }
    if (current.isSlotBooked(
      current.selectedRoomNumber!,
      current.selectedTimeSlot!,
    )) {
      _notify(BookingNotice.slotTaken);
      return;
    }

    emit(current.copyWith(isSubmitting: true, clearNotice: true));
    try {
      await _repository.bookRoomInRealTime(
        BookingModel(
          id: '',
          venueId: venueId,
          venueName: venueName,
          customerId: customerId,
          roomNumber: current.selectedRoomNumber!,
          seatsCount: current.seatsCount,
          date: current.selectedDate!,
          timeSlot: current.selectedTimeSlot!,
        ),
      );
      _notify(BookingNotice.success, isSubmitting: false);
    } on SlotAlreadyBookedException {
      _notify(BookingNotice.slotTaken, isSubmitting: false, clearTimeSlot: true);
    } catch (_) {
      _notify(BookingNotice.failed, isSubmitting: false);
    }
  }

  void _notify(
    BookingNotice notice, {
    bool isSubmitting = false,
    bool clearTimeSlot = false,
  }) {
    final current = state;
    if (current is! ReservationSlotsLoaded) return;
    emit(current.copyWith(
      notice: notice,
      noticeId: current.noticeId + 1,
      isSubmitting: isSubmitting,
      clearTimeSlot: clearTimeSlot,
    ));
  }

  @override
  Future<void> close() {
    _bookingSubscription?.cancel();
    return super.close();
  }
}

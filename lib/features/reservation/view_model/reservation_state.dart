import 'package:equatable/equatable.dart';
import 'package:cospace_customer/features/reservation/model/booking_model.dart';

/// One-shot result of a booking attempt, shown by the screen listener.
enum BookingNotice {
  success,
  slotTaken,
  incomplete,
  invalidSeats,
  invalidSlot,
  loginRequired,
  failed,
}

/// Reservation screen states.
abstract class ReservationState extends Equatable {
  const ReservationState();

  @override
  List<Object?> get props => [];
}

class ReservationInitial extends ReservationState {
  const ReservationInitial();
}

class ReservationSlotsLoaded extends ReservationState {
  final String venueId;
  final List<BookingModel> bookings;
  final int? selectedRoomNumber;
  final int seatsCount;
  final String? selectedDate;
  final String? selectedTimeSlot;
  final bool isSubmitting;
  final BookingNotice? notice;
  final int noticeId;

  const ReservationSlotsLoaded({
    required this.venueId,
    required this.bookings,
    this.selectedRoomNumber,
    this.seatsCount = 1,
    this.selectedDate,
    this.selectedTimeSlot,
    this.isSubmitting = false,
    this.notice,
    this.noticeId = 0,
  });

  @override
  List<Object?> get props => [
        venueId,
        bookings,
        selectedRoomNumber,
        seatsCount,
        selectedDate,
        selectedTimeSlot,
        isSubmitting,
        notice,
        noticeId,
      ];

  ReservationSlotsLoaded copyWith({
    List<BookingModel>? bookings,
    int? selectedRoomNumber,
    int? seatsCount,
    String? selectedDate,
    String? selectedTimeSlot,
    bool clearTimeSlot = false,
    bool? isSubmitting,
    BookingNotice? notice,
    bool clearNotice = false,
    int? noticeId,
  }) {
    return ReservationSlotsLoaded(
      venueId: venueId,
      bookings: bookings ?? this.bookings,
      selectedRoomNumber: selectedRoomNumber ?? this.selectedRoomNumber,
      seatsCount: seatsCount ?? this.seatsCount,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot:
          clearTimeSlot ? null : (selectedTimeSlot ?? this.selectedTimeSlot),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      notice: clearNotice ? null : (notice ?? this.notice),
      noticeId: noticeId ?? this.noticeId,
    );
  }

  /// A slot is taken when this room is already booked on the selected date.
  bool isSlotBooked(int roomNumber, String timeSlot) {
    final date = selectedDate;
    if (date == null) return false;
    return bookings.any(
      (booking) =>
          booking.roomNumber == roomNumber &&
          booking.date == date &&
          booking.timeSlot == timeSlot,
    );
  }
}

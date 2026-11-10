import 'package:equatable/equatable.dart';
import 'package:cospace_customer/features/reservation/model/reservation_model.dart';

/// Reservation screen states.
abstract class ReservationState extends Equatable {
  const ReservationState();

  @override
  List<Object?> get props => [];
}

class ReservationInitial extends ReservationState {
  const ReservationInitial();
}

class ReservationLoading extends ReservationState {
  const ReservationLoading();
}

class ReservationSlotsLoaded extends ReservationState {
  final List<ReservationModel> existingReservations;
  final int? selectedRoomNumber;
  final int seatsCount;
  final String? selectedDate;
  final String? selectedTimeSlot;

  const ReservationSlotsLoaded({
    required this.existingReservations,
    this.selectedRoomNumber,
    this.seatsCount = 1,
    this.selectedDate,
    this.selectedTimeSlot,
  });

  @override
  List<Object?> get props => [
        existingReservations,
        selectedRoomNumber,
        seatsCount,
        selectedDate,
        selectedTimeSlot,
      ];

  ReservationSlotsLoaded copyWith({
    List<ReservationModel>? existingReservations,
    int? selectedRoomNumber,
    int? seatsCount,
    String? selectedDate,
    String? selectedTimeSlot,
  }) {
    return ReservationSlotsLoaded(
      existingReservations:
          existingReservations ?? this.existingReservations,
      selectedRoomNumber: selectedRoomNumber ?? this.selectedRoomNumber,
      seatsCount: seatsCount ?? this.seatsCount,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
    );
  }

  /// Check if a specific room+slot combo is already booked.
  bool isSlotBooked(int roomNumber, String timeSlot) {
    return existingReservations.any(
      (r) => r.roomNumber == roomNumber && r.timeSlot == timeSlot,
    );
  }
}

class ReservationBookingSuccess extends ReservationState {
  const ReservationBookingSuccess();
}

class ReservationError extends ReservationState {
  final String message;
  const ReservationError(this.message);

  @override
  List<Object?> get props => [message];
}

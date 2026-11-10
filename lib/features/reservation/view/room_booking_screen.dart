import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/core/constants/app_icons.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/core/utils/extensions/date_extensions.dart';
import 'package:cospace_customer/features/home/model/venue_model.dart';
import 'package:cospace_customer/features/reservation/view_model/reservation_cubit.dart';
import 'package:cospace_customer/features/reservation/view_model/reservation_state.dart';
import 'package:cospace_customer/features/reservation/widgets/guests_seat_counter.dart';
import 'package:cospace_customer/features/reservation/widgets/reservation_date_picker.dart';
import 'package:cospace_customer/features/reservation/widgets/realtime_time_slots_wrap.dart';
import 'package:cospace_customer/shared/custom_button.dart';

/// Booking configuration screen (Figure 4).
class RoomBookingScreen extends StatefulWidget {
  const RoomBookingScreen({
    super.key,
    required this.venue,
    required this.roomNumber,
  });

  final VenueModel venue;
  final int roomNumber;

  @override
  State<RoomBookingScreen> createState() => _RoomBookingScreenState();
}

class _RoomBookingScreenState extends State<RoomBookingScreen> {
  @override
  void initState() {
    super.initState();
    // Start watching today's reservations for this venue by default
    final today = DateTime.now().toFirestoreDate();
    context.read<ReservationCubit>().watchSlots(
          venueId: widget.venue.id,
          reservationDate: today,
        );
    context.read<ReservationCubit>().selectDate(today);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${context.l10n.rooms} ${widget.roomNumber}'),
        leading: IconButton(
          icon: const Icon(AppIcons.arrowBack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<ReservationCubit, ReservationState>(
        listener: (context, state) {
          if (state is ReservationBookingSuccess) {
            context.showSnackBar(context.l10n.bookingSuccess);
            Navigator.of(context).pop();
          } else if (state is ReservationError) {
            context.showSnackBar(state.message, isError: true);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsetsDirectional.all(AppSizes.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Amount of Guests / Seats ──
                Text(
                  context.l10n.amountOfGuests,
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: AppFonts.semiBold,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: AppSizes.v12),
                GuestsSeatCounter(
                  currentCount: state is ReservationSlotsLoaded
                      ? state.seatsCount
                      : 1,
                  onIncrement: () =>
                      context.read<ReservationCubit>().incrementGuestSeats(),
                  onDecrement: () =>
                      context.read<ReservationCubit>().decrementGuestSeats(),
                ),
                SizedBox(height: AppSizes.v24),

                // ── Reservation Date ──
                Text(
                  context.l10n.reservationDate,
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: AppFonts.semiBold,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: AppSizes.v12),
                ReservationDatePicker(
                  selectedDate: state is ReservationSlotsLoaded
                      ? state.selectedDate
                      : null,
                  onDateSelected: (date) {
                    context.read<ReservationCubit>().selectDate(date);
                    context.read<ReservationCubit>().watchSlots(
                          venueId: widget.venue.id,
                          reservationDate: date,
                        );
                  },
                ),
                SizedBox(height: AppSizes.v24),

                // ── Available Time Slots ──
                Text(
                  context.l10n.availableTimeSlots,
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: AppFonts.semiBold,
                    color: context.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: AppSizes.v12),
                RealtimeTimeSlotsWrap(
                  roomNumber: widget.roomNumber,
                  state: state is ReservationSlotsLoaded ? state : null,
                  onSlotSelected: (slot) {
                    context.read<ReservationCubit>().selectTimeSlot(slot);
                  },
                ),
                SizedBox(height: AppSizes.v32),

                // ── Confirm Booking Button ──
                CustomButton(
                  text: context.l10n.confirmBooking,
                  isLoading: state is ReservationLoading,
                  onPressed: () {
                    context.read<ReservationCubit>().confirmRealtimeBooking(
                          venueId: widget.venue.id,
                          venueName: widget.venue.name,
                        );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

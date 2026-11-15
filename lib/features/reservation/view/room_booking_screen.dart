import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/core/constants/app_icons.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/services/firebase_service.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/features/auth/view_model/auth_cubit.dart';
import 'package:cospace_customer/features/auth/view_model/auth_state.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<ReservationCubit>();
      cubit.startBooking(venueId: widget.venue.id);
      cubit.selectRoomNumber(widget.roomNumber);
    });
  }

  @override
  void dispose() {
    // Don't cancel here — the cubit lives above this screen.
    super.dispose();
  }

  String _noticeMessage(BuildContext context, BookingNotice notice) {
    switch (notice) {
      case BookingNotice.success:
        return context.l10n.bookingSuccess;
      case BookingNotice.slotTaken:
        return context.l10n.slotAlreadyBooked;
      case BookingNotice.incomplete:
        return context.l10n.selectTimeSlot;
      case BookingNotice.invalidSeats:
        return context.l10n.maxSeatsReached;
      case BookingNotice.invalidSlot:
        return context.l10n.selectTimeSlot;
      case BookingNotice.loginRequired:
        return context.l10n.loginRequired;
      case BookingNotice.failed:
        return context.l10n.bookingFailed;
    }
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
        listenWhen: (previous, current) {
          if (current is! ReservationSlotsLoaded) return false;
          if (previous is! ReservationSlotsLoaded) return current.notice != null;
          return current.notice != null &&
              current.noticeId != previous.noticeId;
        },
        listener: (context, state) {
          if (state is! ReservationSlotsLoaded || state.notice == null) return;
          final notice = state.notice!;
          if (notice == BookingNotice.success) {
            context.showSnackBar(context.l10n.bookingSuccess);
            Navigator.of(context).pop();
          } else {
            context.showSnackBar(
              _noticeMessage(context, notice),
              isError: true,
            );
          }
        },
        builder: (context, state) {
          final loaded = state is ReservationSlotsLoaded ? state : null;
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
                  currentCount: loaded?.seatsCount ?? 1,
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
                  selectedDate: loaded?.selectedDate,
                  onDateSelected: (date) {
                    context.read<ReservationCubit>().selectDate(date);
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
                  state: loaded,
                  onSlotSelected: (slot) {
                    context.read<ReservationCubit>().selectTimeSlot(slot);
                  },
                ),
                SizedBox(height: AppSizes.v32),

                // ── Confirm Booking Button ──
                CustomButton(
                  text: context.l10n.confirmBooking,
                  isLoading: loaded?.isSubmitting ?? false,
                  onPressed: () {
                    final authState = context.read<AuthCubit>().state;
                    final customerId = authState is AuthAuthenticated
                        ? authState.user.uid
                        : (FirebaseService.instance.currentUser?.uid ?? '');
                    context.read<ReservationCubit>().confirmRealtimeBooking(
                          venueId: widget.venue.id,
                          venueName: widget.venue.name,
                          customerId: customerId,
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

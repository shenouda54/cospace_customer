import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/core/constants/app_icons.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/features/auth/view_model/auth_cubit.dart';
import 'package:cospace_customer/features/auth/view_model/auth_state.dart';
import 'package:cospace_customer/features/home/model/venue_model.dart';
import 'package:cospace_customer/features/home/widgets/venue_image.dart';
import 'package:cospace_customer/features/reservation/view_model/reservation_cubit.dart';
import 'package:cospace_customer/features/reservation/view_model/reservation_state.dart';
import 'package:cospace_customer/features/reservation/widgets/guests_seat_counter.dart';
import 'package:cospace_customer/features/reservation/widgets/interactive_room_table_map.dart';
import 'package:cospace_customer/features/reservation/widgets/realtime_time_slots_wrap.dart';
import 'package:cospace_customer/features/reservation/widgets/reservation_date_picker.dart';
import 'package:cospace_customer/shared/custom_button.dart';

/// Venue details plus the live booking form (room map, seats, date, slots).
class VenueDetailsScreen extends StatefulWidget {
  const VenueDetailsScreen({super.key, required this.venue});

  final VenueModel venue;

  @override
  State<VenueDetailsScreen> createState() => _VenueDetailsScreenState();
}

class _VenueDetailsScreenState extends State<VenueDetailsScreen> {
  late final ReservationCubit _reservationCubit;

  @override
  void initState() {
    super.initState();
    _reservationCubit = context.read<ReservationCubit>();
    _reservationCubit.startBooking(venueId: widget.venue.id);
  }

  @override
  void dispose() {
    _reservationCubit.stopWatching();
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
        return context.l10n.slotAlreadyBooked;
      case BookingNotice.loginRequired:
        return context.l10n.loginRequired;
      case BookingNotice.failed:
        return context.l10n.bookingFailed;
    }
  }

  void _confirm() {
    final authState = context.read<AuthCubit>().state;
    final customerId =
        authState is AuthAuthenticated ? authState.user.uid : '';
    context.read<ReservationCubit>().confirmRealtimeBooking(
          venueId: widget.venue.id,
          venueName: widget.venue.name,
          customerId: customerId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.venueDetails),
        leading: IconButton(
          icon: const Icon(AppIcons.arrowBack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<ReservationCubit, ReservationState>(
        listenWhen: (previous, current) {
          if (current is! ReservationSlotsLoaded) return false;
          if (previous is! ReservationSlotsLoaded) return current.notice != null;
          return current.noticeId != previous.noticeId;
        },
        listener: (context, state) {
          if (state is! ReservationSlotsLoaded || state.notice == null) return;
          final notice = state.notice!;
          context.showSnackBar(
            _noticeMessage(context, notice),
            isError: notice != BookingNotice.success,
          );
          if (notice == BookingNotice.success) {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          final loaded = state is ReservationSlotsLoaded ? state : null;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VenueImage(
                  imageUrl: widget.venue.imageUrl,
                  width: double.infinity,
                  height: 200.h,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.all(AppSizes.p16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.venue.name,
                        style: TextStyle(
                          fontSize: AppFonts.heading2,
                          fontWeight: AppFonts.bold,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: AppSizes.v8),
                      Row(
                        children: [
                          Icon(
                            AppIcons.location,
                            size: AppSizes.iconSmall,
                            color: context.colorScheme.primary,
                          ),
                          SizedBox(width: AppSizes.p4),
                          Expanded(
                            child: Text(
                              widget.venue.coordinatesLabel,
                              style: TextStyle(
                                fontSize: AppFonts.bodyMedium,
                                color: context.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.v16),
                      Text(
                        context.l10n.description,
                        style: TextStyle(
                          fontSize: AppFonts.bodyLarge,
                          fontWeight: AppFonts.semiBold,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: AppSizes.v8),
                      Text(
                        widget.venue.description,
                        style: TextStyle(
                          fontSize: AppFonts.bodyMedium,
                          color: context.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                      ),
                      SizedBox(height: AppSizes.v24),
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
                      Text(
                        context.l10n.selectRoom,
                        style: TextStyle(
                          fontSize: AppFonts.bodyLarge,
                          fontWeight: AppFonts.semiBold,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: AppSizes.v12),
                      InteractiveRoomTableMap(
                        roomsCount: widget.venue.roomsCount,
                        selectedRoomNumber: loaded?.selectedRoomNumber,
                        onRoomSelected: (roomNumber) {
                          context
                              .read<ReservationCubit>()
                              .selectRoomNumber(roomNumber);
                        },
                      ),
                      SizedBox(height: AppSizes.v24),
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
                        onIncrement: () => context
                            .read<ReservationCubit>()
                            .incrementGuestSeats(),
                        onDecrement: () => context
                            .read<ReservationCubit>()
                            .decrementGuestSeats(),
                      ),
                      SizedBox(height: AppSizes.v24),
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
                      CustomButton(
                        text: context.l10n.confirmBooking,
                        isLoading: loaded?.isSubmitting ?? false,
                        onPressed: loaded == null ? null : _confirm,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

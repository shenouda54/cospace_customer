import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_constants.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/features/reservation/view_model/reservation_state.dart';

/// Wrap of time-slot chips matching Figure 4.
/// Available slots are clickable; selected slot is elevated with shadow;
/// booked slots are disabled in real-time.
class RealtimeTimeSlotsWrap extends StatelessWidget {
  const RealtimeTimeSlotsWrap({
    super.key,
    required this.roomNumber,
    required this.state,
    required this.onSlotSelected,
  });

  final int roomNumber;
  final ReservationSlotsLoaded? state;
  final ValueChanged<String> onSlotSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.p12,
      runSpacing: AppSizes.v12,
      children: AppConstants.dailyFixedTimeSlots.map((slot) {
        final isBooked = state?.isSlotBooked(roomNumber, slot) ?? false;
        final isSelected = state?.selectedTimeSlot == slot;

        return GestureDetector(
          onTap: isBooked ? null : () => onSlotSelected(slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.surface
                  : isBooked
                      ? const Color(0xFFF2F4F7)
                      : const Color(0xFFF4F6F9),
              borderRadius: BorderRadius.circular(AppSizes.r12),
              border: isSelected
                  ? Border.all(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                      width: 1.5,
                    )
                  : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              slot,
              style: TextStyle(
                fontSize: AppFonts.bodyMedium,
                fontWeight: isSelected ? AppFonts.bold : AppFonts.medium,
                color: isSelected
                    ? Theme.of(context).colorScheme.onSurface
                    : isBooked
                        ? const Color(0xFFBAC2CE)
                        : const Color(0xFF8C98A8),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

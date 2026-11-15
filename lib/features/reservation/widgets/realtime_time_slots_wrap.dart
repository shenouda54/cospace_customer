import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_constants.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/features/reservation/view_model/reservation_state.dart';

/// Fixed daily slots. A slot already stored for the selected room and date is disabled.
class RealtimeTimeSlotsWrap extends StatelessWidget {
  const RealtimeTimeSlotsWrap({
    super.key,
    required this.state,
    required this.onSlotSelected,
  });

  final ReservationSlotsLoaded? state;
  final ValueChanged<String> onSlotSelected;

  @override
  Widget build(BuildContext context) {
    final roomNumber = state?.selectedRoomNumber;

    return Wrap(
      spacing: AppSizes.p12,
      runSpacing: AppSizes.v12,
      children: AppConstants.dailyFixedTimeSlots.map((slot) {
        final isBooked = roomNumber != null &&
            (state?.isSlotBooked(roomNumber, slot) ?? false);
        final isSelected = state?.selectedTimeSlot == slot && !isBooked;
        final canSelect = roomNumber != null && !isBooked;

        final background = isSelected
            ? context.colorScheme.primary
            : isBooked
                ? context.colorScheme.surfaceContainerHighest
                : context.colorScheme.surface;
        final foreground = isSelected
            ? context.colorScheme.onPrimary
            : isBooked
                ? context.colorScheme.onSurface.withValues(alpha: 0.38)
                : context.colorScheme.onSurface;

        return GestureDetector(
          onTap: canSelect ? () => onSlotSelected(slot) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSizes.p20,
              vertical: AppSizes.v12,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppSizes.r12),
              border: Border.all(
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.outline,
              ),
            ),
            child: Text(
              slot,
              style: TextStyle(
                fontSize: AppFonts.bodyMedium,
                fontWeight: isSelected ? AppFonts.bold : AppFonts.medium,
                color: foreground,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';

/// Grid of rooms. Each cell is a table with chairs, sized by [roomsCount].
class InteractiveRoomTableMap extends StatelessWidget {
  const InteractiveRoomTableMap({
    super.key,
    required this.roomsCount,
    required this.selectedRoomNumber,
    required this.onRoomSelected,
  });

  final int roomsCount;
  final int? selectedRoomNumber;
  final ValueChanged<int> onRoomSelected;

  @override
  Widget build(BuildContext context) {
    final count = roomsCount < 1 ? 1 : roomsCount;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.v16,
        crossAxisSpacing: AppSizes.p16,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final roomNumber = index + 1;
        final isSelected = selectedRoomNumber == roomNumber;
        return GestureDetector(
          onTap: () => onRoomSelected(roomNumber),
          child: _RoomTable(
            roomNumber: roomNumber,
            isSelected: isSelected,
          ),
        );
      },
    );
  }
}

class _RoomTable extends StatelessWidget {
  const _RoomTable({
    required this.roomNumber,
    required this.isSelected,
  });

  final int roomNumber;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final selectedColor = context.colorScheme.primary;
    final tableColor = isSelected
        ? selectedColor
        : context.colorScheme.surfaceContainerHighest;
    final chairColor = isSelected
        ? selectedColor
        : context.colorScheme.outline;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ChairRow(color: chairColor),
        SizedBox(height: AppSizes.v4),
        Container(
          width: 72,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tableColor,
            borderRadius: BorderRadius.circular(AppSizes.r12),
            border: Border.all(
              color: isSelected
                  ? selectedColor
                  : context.colorScheme.outline,
            ),
          ),
          child: Text(
            '$roomNumber',
            style: TextStyle(
              fontSize: AppFonts.bodyMedium,
              fontWeight: AppFonts.bold,
              color: isSelected
                  ? context.colorScheme.onPrimary
                  : context.colorScheme.onSurface,
            ),
          ),
        ),
        SizedBox(height: AppSizes.v4),
        _ChairRow(color: chairColor),
      ],
    );
  }
}

class _ChairRow extends StatelessWidget {
  const _ChairRow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Chair(color: color),
        SizedBox(width: AppSizes.p8),
        _Chair(color: color),
        SizedBox(width: AppSizes.p8),
        _Chair(color: color),
      ],
    );
  }
}

class _Chair extends StatelessWidget {
  const _Chair({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

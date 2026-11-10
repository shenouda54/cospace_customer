import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';

/// Interactive visual map of rooms/tables with surrounding chairs on left & right (Figure 3).
class InteractiveRoomTableMap extends StatefulWidget {
  const InteractiveRoomTableMap({
    super.key,
    required this.totalRooms,
    required this.onRoomSelected,
    this.initialSelectedRoom,
  });

  final int totalRooms;
  final ValueChanged<int> onRoomSelected;
  final int? initialSelectedRoom;

  @override
  State<InteractiveRoomTableMap> createState() =>
      _InteractiveRoomTableMapState();
}

class _InteractiveRoomTableMapState extends State<InteractiveRoomTableMap> {
  int? _selectedRoom;

  @override
  void initState() {
    super.initState();
    _selectedRoom = widget.initialSelectedRoom;
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.totalRooms <= 0 ? 6 : widget.totalRooms;
    final leftCount = (count / 2).ceil();
    final rightCount = count - leftCount;

    return Center(
      child: Container(
        padding: EdgeInsetsDirectional.all(AppSizes.p16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.r16),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column of Workstations
            Column(
              children: List.generate(leftCount, (i) {
                final roomNum = i * 2 + 1;
                final isLarge = (i % 2 == 1) || (i == leftCount - 1 && leftCount > 2);
                return _buildTableItem(
                  roomNum: roomNum,
                  chairsPerSide: isLarge ? 3 : 1,
                  isLarge: isLarge,
                );
              }),
            ),

            // Middle corridor space
            SizedBox(width: AppSizes.p24),

            // Right Column of Workstations
            Column(
              children: List.generate(rightCount, (i) {
                final roomNum = (i + 1) * 2;
                final isLarge = i == rightCount - 1;
                return _buildTableItem(
                  roomNum: roomNum,
                  chairsPerSide: isLarge ? 2 : 1,
                  isLarge: isLarge,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableItem({
    required int roomNum,
    required int chairsPerSide,
    required bool isLarge,
  }) {
    final isSelected = _selectedRoom == roomNum;

    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: AppSizes.v16),
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedRoom = roomNum);
          widget.onRoomSelected(roomNum);
        },
        child: _Figure3Workstation(
          roomNumber: roomNum,
          chairsPerSide: chairsPerSide,
          isLarge: isLarge,
          isSelected: isSelected,
        ),
      ),
    );
  }
}

/// A single workstation table with chairs on the left and right (matching Figure 3).
class _Figure3Workstation extends StatelessWidget {
  const _Figure3Workstation({
    required this.roomNumber,
    required this.chairsPerSide,
    required this.isLarge,
    required this.isSelected,
  });

  final int roomNumber;
  final int chairsPerSide;
  final bool isLarge;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    // Colors matching Figure 3:
    // Selected: Solid vibrant blue (#4D82F3)
    // Available: Sleek metallic/light-grey gradient (#D8DFE8 to #EAEEF3)
    const selectedColor = Color(0xFF4D82F3);
    const unselectedTableGradient = [
      Color(0xFFE2E7ED),
      Color(0xFFECEFF4),
    ];
    const unselectedChairColor = Color(0xFFD3DBE4);

    final tableHeight = isLarge ? 84.0 : 48.0;
    const tableWidth = 52.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Chairs
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            chairsPerSide,
            (_) => _ChairWidget(
              isLeft: true,
              color: isSelected ? selectedColor : unselectedChairColor,
            ),
          ),
        ),

        const SizedBox(width: 4),

        // Central Table
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: tableWidth,
          height: tableHeight,
          decoration: BoxDecoration(
            color: isSelected ? selectedColor : null,
            gradient: isSelected
                ? null
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: unselectedTableGradient,
                  ),
            borderRadius: BorderRadius.circular(AppSizes.r12),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? selectedColor.withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: isSelected ? 12 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            '$roomNumber',
            style: TextStyle(
              fontSize: AppFonts.bodySmall,
              fontWeight: AppFonts.bold,
              color: isSelected ? Colors.white : const Color(0xFF6B7A8D),
            ),
          ),
        ),

        const SizedBox(width: 4),

        // Right Chairs
        Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            chairsPerSide,
            (_) => _ChairWidget(
              isLeft: false,
              color: isSelected ? selectedColor : unselectedChairColor,
            ),
          ),
        ),
      ],
    );
  }
}

/// A single chair facing inward toward the table (matching Figure 3).
class _ChairWidget extends StatelessWidget {
  const _ChairWidget({
    required this.isLeft,
    required this.color,
  });

  final bool isLeft;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        width: 14,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: isLeft ? const Radius.circular(5) : const Radius.circular(2),
            bottomLeft:
                isLeft ? const Radius.circular(5) : const Radius.circular(2),
            topRight:
                isLeft ? const Radius.circular(2) : const Radius.circular(5),
            bottomRight:
                isLeft ? const Radius.circular(2) : const Radius.circular(5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}

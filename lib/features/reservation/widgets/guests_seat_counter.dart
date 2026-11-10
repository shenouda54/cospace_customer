import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_constants.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';

/// Guest/seat counter widget with [count +] pill and [-] button (Figure 4).
class GuestsSeatCounter extends StatelessWidget {
  const GuestsSeatCounter({
    super.key,
    required this.currentCount,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int currentCount;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final isMin = currentCount <= AppConstants.minSeatsPerRoom;
    final isMax = currentCount >= AppConstants.maxSeatsPerRoom;

    const accentColor = Color(0xFF6B8DF2);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pill with count and '+' (matching Figure 4)
        GestureDetector(
          onTap: isMax ? null : onIncrement,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isMax
                  ? accentColor.withValues(alpha: 0.6)
                  : accentColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$currentCount',
                  style: TextStyle(
                    fontSize: AppFonts.bodyLarge,
                    fontWeight: AppFonts.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.add,
                  size: 18,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 14),

        // Circular '-' button (matching Figure 4)
        GestureDetector(
          onTap: isMin ? null : onDecrement,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE9ECF2),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.remove,
              size: 18,
              color: isMin
                  ? const Color(0xFFB0B7C3)
                  : const Color(0xFF5A6678),
            ),
          ),
        ),
      ],
    );
  }
}

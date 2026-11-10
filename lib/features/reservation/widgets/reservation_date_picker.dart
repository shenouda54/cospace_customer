import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/core/utils/extensions/date_extensions.dart';

/// Date picker widget matching Figure 4 (elevated rounded pill with shadow).
class ReservationDatePicker extends StatelessWidget {
  const ReservationDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final String? selectedDate;
  final ValueChanged<String> onDateSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 90)),
        );
        if (picked != null) {
          onDateSelected(picked.toFirestoreDate());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          selectedDate != null
              ? _formatDisplayDate(selectedDate!)
              : context.l10n.selectDate,
          style: TextStyle(
            fontSize: AppFonts.bodyMedium,
            fontWeight: AppFonts.semiBold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  String _formatDisplayDate(String yyyyMmDd) {
    try {
      final dt = DateTime.parse(yyyyMmDd);
      return dt.toReadableDate();
    } catch (_) {
      return yyyyMmDd;
    }
  }
}

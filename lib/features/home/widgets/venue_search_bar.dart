import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_icons.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';

/// Search bar for searching venues by name.
class VenueSearchBar extends StatelessWidget {
  const VenueSearchBar({super.key, required this.onSearch});

  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearch,
      decoration: InputDecoration(
        hintText: context.l10n.searchByVenueName,
        prefixIcon: const Icon(AppIcons.search),
        filled: true,
        fillColor: context.colorScheme.surface,
        contentPadding: EdgeInsetsDirectional.symmetric(
          horizontal: AppSizes.p16,
          vertical: AppSizes.v12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r24),
          borderSide: BorderSide(color: context.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r24),
          borderSide: BorderSide(color: context.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.r24),
          borderSide: BorderSide(color: context.colorScheme.primary),
        ),
      ),
    );
  }
}

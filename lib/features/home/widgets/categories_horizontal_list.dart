import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/features/home/model/category_model.dart';

/// Horizontal scrollable list of workspace categories.
class CategoriesHorizontalList extends StatelessWidget {
  const CategoriesHorizontalList({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<CategoryModel> categories;
  final String? selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(horizontal: AppSizes.p16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: AppSizes.p8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == selectedCategoryId;

          return GestureDetector(
            onTap: () => onCategorySelected(category.id),
            child: Container(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: AppSizes.p16,
                vertical: AppSizes.v8,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppSizes.r24),
                border: Border.all(
                  color: isSelected
                      ? context.colorScheme.primary
                      : context.colorScheme.outline,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: AppFonts.bodySmall,
                  fontWeight: AppFonts.medium,
                  color: isSelected
                      ? context.colorScheme.onPrimary
                      : context.colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

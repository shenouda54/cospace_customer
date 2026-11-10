import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_icons.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';

/// Displays an empty-state placeholder (e.g. no search results).
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key, required this.message, this.icon});

  final String message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? AppIcons.empty,
            size: AppSizes.iconLarge * 2,
            color: context.colorScheme.onSurface.withValues(alpha: 0.38),
          ),
          SizedBox(height: AppSizes.v16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays an error-state placeholder with an optional retry button.
class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AppIcons.error,
            size: AppSizes.iconLarge * 2,
            color: context.colorScheme.error,
          ),
          SizedBox(height: AppSizes.v16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFonts.bodyLarge,
              color: context.colorScheme.error,
            ),
          ),
          if (onRetry != null) ...[
            SizedBox(height: AppSizes.v16),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}

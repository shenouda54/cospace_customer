import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';

/// Reusable shimmer/skeleton loading widget.
class AppShimmer extends StatelessWidget {
  const AppShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colorScheme.surfaceContainerHighest,
      highlightColor: context.colorScheme.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(borderRadius ?? AppSizes.r8),
        ),
      ),
    );
  }
}

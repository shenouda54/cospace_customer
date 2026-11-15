import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_icons.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';

/// Renders a venue photo from a network URL or a Base64 string.
class VenueImage extends StatelessWidget {
  const VenueImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final image = _buildImage(context);
    if (borderRadius == null) return image;
    return ClipRRect(borderRadius: borderRadius!, child: image);
  }

  Widget _buildImage(BuildContext context) {
    if (imageUrl.isEmpty) return _placeholder(context);

    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(context),
      );
    }

    try {
      final payload = imageUrl.contains(',')
          ? imageUrl.split(',').last
          : imageUrl;
      return Image.memory(
        base64Decode(payload),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(context),
      );
    } catch (_) {
      return _placeholder(context);
    }
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(
        AppIcons.room,
        size: AppSizes.iconLarge,
        color: context.colorScheme.onSurface.withValues(alpha: 0.38),
      ),
    );
  }
}

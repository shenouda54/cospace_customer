import 'package:flutter/material.dart';
import 'package:cospace_customer/core/constants/app_icons.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/features/home/model/venue_model.dart';
import 'package:cospace_customer/features/reservation/view/venue_details_screen.dart';

/// Card displaying a venue summary in the home list.
class CustomerVenueCard extends StatelessWidget {
  const CustomerVenueCard({super.key, required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VenueDetailsScreen(venue: venue),
          ),
        );
      },
      child: Container(
        margin: EdgeInsetsDirectional.only(bottom: AppSizes.v12),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.r12),
          border: Border.all(color: context.colorScheme.outline),
        ),
        child: Row(
          children: [
            // Venue Image
            ClipRRect(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(AppSizes.r12),
                bottomStart: Radius.circular(AppSizes.r12),
              ),
              child: venue.imageUrl.isNotEmpty
                  ? Image.network(
                      venue.imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _imagePlaceholder(context),
                    )
                  : _imagePlaceholder(context),
            ),
            SizedBox(width: AppSizes.p12),
            // Venue Info
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  vertical: AppSizes.v12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venue.name,
                      style: TextStyle(
                        fontSize: AppFonts.bodyLarge,
                        fontWeight: AppFonts.semiBold,
                        color: context.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSizes.v4),
                    Row(
                      children: [
                        Icon(
                          AppIcons.location,
                          size: AppSizes.iconSmall,
                          color: context.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        SizedBox(width: AppSizes.p4),
                        Expanded(
                          child: Text(
                            venue.location,
                            style: TextStyle(
                              fontSize: AppFonts.bodySmall,
                              color: context.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSizes.v4),
                    Row(
                      children: [
                        Icon(
                          AppIcons.room,
                          size: AppSizes.iconSmall,
                          color: context.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                        SizedBox(width: AppSizes.p4),
                        Text(
                          '${venue.totalRooms} ${context.l10n.rooms}',
                          style: TextStyle(
                            fontSize: AppFonts.bodySmall,
                            color: context.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(end: AppSizes.p12),
              child: Icon(
                AppIcons.arrowBack,
                size: AppSizes.iconSmall,
                color: context.colorScheme.onSurface.withValues(alpha: 0.38),
                textDirection: TextDirection.ltr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(
        AppIcons.room,
        size: AppSizes.iconLarge,
        color: context.colorScheme.onSurface.withValues(alpha: 0.38),
      ),
    );
  }
}

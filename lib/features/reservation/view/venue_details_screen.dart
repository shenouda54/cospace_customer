import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/core/constants/app_fonts.dart';
import 'package:cospace_customer/core/constants/app_icons.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/features/home/model/venue_model.dart';
import 'package:cospace_customer/features/reservation/view/room_booking_screen.dart';
import 'package:cospace_customer/features/reservation/view_model/reservation_cubit.dart';
import 'package:cospace_customer/features/reservation/widgets/interactive_room_table_map.dart';

/// Screen showing venue details and the interactive room map (Figure 3).
class VenueDetailsScreen extends StatelessWidget {
  const VenueDetailsScreen({super.key, required this.venue});

  final VenueModel venue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.venueDetails),
        leading: IconButton(
          icon: const Icon(AppIcons.arrowBack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Venue Image
            if (venue.imageUrl.isNotEmpty)
              Image.network(
                venue.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: double.infinity,
                  height: 200,
                  color: context.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    AppIcons.room,
                    size: AppSizes.iconLarge * 2,
                    color:
                        context.colorScheme.onSurface.withValues(alpha: 0.38),
                  ),
                ),
              ),

            Padding(
              padding: EdgeInsetsDirectional.all(AppSizes.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Venue Name
                  Text(
                    venue.name,
                    style: TextStyle(
                      fontSize: AppFonts.heading2,
                      fontWeight: AppFonts.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: AppSizes.v8),

                  // Location
                  Row(
                    children: [
                      Icon(AppIcons.location,
                          size: AppSizes.iconSmall,
                          color: context.colorScheme.primary),
                      SizedBox(width: AppSizes.p4),
                      Expanded(
                        child: Text(
                          venue.location,
                          style: TextStyle(
                            fontSize: AppFonts.bodyMedium,
                            color: context.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.v16),

                  // Description
                  Text(
                    context.l10n.description,
                    style: TextStyle(
                      fontSize: AppFonts.bodyLarge,
                      fontWeight: AppFonts.semiBold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: AppSizes.v8),
                  Text(
                    venue.description,
                    style: TextStyle(
                      fontSize: AppFonts.bodyMedium,
                      color: context.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: AppSizes.v24),

                  // Interactive Room Map (Figure 3)
                  Text(
                    context.l10n.selectRoom,
                    style: TextStyle(
                      fontSize: AppFonts.bodyLarge,
                      fontWeight: AppFonts.semiBold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: AppSizes.v12),
                  InteractiveRoomTableMap(
                    totalRooms: venue.totalRooms,
                    onRoomSelected: (roomNumber) {
                      context
                          .read<ReservationCubit>()
                          .selectRoomNumber(roomNumber);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => RoomBookingScreen(
                            venue: venue,
                            roomNumber: roomNumber,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: AppSizes.v24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

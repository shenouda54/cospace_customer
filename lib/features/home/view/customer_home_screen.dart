import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/core/constants/app_icons.dart';
import 'package:cospace_customer/core/constants/app_sizes.dart';
import 'package:cospace_customer/core/theme/theme_cubit.dart';
import 'package:cospace_customer/core/utils/locale_cubit.dart';
import 'package:cospace_customer/core/utils/extensions/context_extensions.dart';
import 'package:cospace_customer/features/auth/view_model/auth_cubit.dart';
import 'package:cospace_customer/features/home/view_model/home_cubit.dart';
import 'package:cospace_customer/features/home/view_model/home_state.dart';
import 'package:cospace_customer/features/home/widgets/categories_horizontal_list.dart';
import 'package:cospace_customer/features/home/widgets/venue_search_bar.dart';
import 'package:cospace_customer/features/home/widgets/customer_venue_card.dart';
import 'package:cospace_customer/shared/app_shimmer.dart';
import 'package:cospace_customer/shared/empty_error_states.dart';

/// Main home screen for customers to browse categories and search venues.
class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appTitle),
        actions: [
          IconButton(
            tooltip: context.l10n.theme,
            icon: Icon(
              context.watch<ThemeCubit>().isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
          IconButton(
            tooltip: context.l10n.language,
            icon: const Icon(Icons.language),
            onPressed: () => context.read<LocaleCubit>().toggleLocale(),
          ),
          IconButton(
            tooltip: context.l10n.logout,
            icon: const Icon(AppIcons.logout),
            onPressed: () => context.read<AuthCubit>().logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: AppSizes.p16,
                vertical: AppSizes.v8,
              ),
              child: VenueSearchBar(
                onSearch: (query) {
                  context.read<HomeCubit>().searchVenuesByName(query);
                },
              ),
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoaded) {
                  return CategoriesHorizontalList(
                    categories: state.categories,
                    selectedCategoryId: state.selectedCategoryId,
                    onCategorySelected: (categoryId) {
                      context.read<HomeCubit>().selectCategory(categoryId);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            SizedBox(height: AppSizes.v8),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return ListView.builder(
                      padding: EdgeInsetsDirectional.all(AppSizes.p16),
                      itemCount: 5,
                      itemBuilder: (_, _) => Padding(
                        padding: EdgeInsetsDirectional.only(
                          bottom: AppSizes.v12,
                        ),
                        child: AppShimmer(
                          width: double.infinity,
                          height: 120,
                          borderRadius: AppSizes.r12,
                        ),
                      ),
                    );
                  }

                  if (state is HomeError) {
                    return ErrorStateWidget(
                      message: state.message,
                      onRetry: () =>
                          context.read<HomeCubit>().loadCategories(),
                    );
                  }

                  if (state is HomeLoaded) {
                    if (state.venues.isEmpty) {
                      return EmptyStateWidget(
                        message: state.searchQuery.isEmpty
                            ? context.l10n.noVenuesAvailable
                            : context.l10n.noResultsFound,
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsetsDirectional.all(AppSizes.p16),
                      itemCount: state.venues.length,
                      itemBuilder: (context, index) {
                        return CustomerVenueCard(venue: state.venues[index]);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

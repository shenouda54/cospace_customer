import 'package:equatable/equatable.dart';
import 'package:cospace_customer/features/home/model/category_model.dart';
import 'package:cospace_customer/features/home/model/venue_model.dart';

/// Home screen states.
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<CategoryModel> categories;
  final List<VenueModel> venues;
  final String? selectedCategoryId;
  final String searchQuery;

  const HomeLoaded({
    required this.categories,
    required this.venues,
    this.selectedCategoryId,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props =>
      [categories, venues, selectedCategoryId, searchQuery];

  HomeLoaded copyWith({
    List<CategoryModel>? categories,
    List<VenueModel>? venues,
    String? selectedCategoryId,
    String? searchQuery,
  }) {
    return HomeLoaded(
      categories: categories ?? this.categories,
      venues: venues ?? this.venues,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

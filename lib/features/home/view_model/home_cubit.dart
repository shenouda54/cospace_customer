import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/features/home/model/home_repository.dart';
import 'package:cospace_customer/features/home/view_model/home_state.dart';

/// Cubit managing home screen state: categories and venues.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({HomeRepository? homeRepository})
      : _homeRepository = homeRepository ?? HomeRepository(),
        super(const HomeInitial());

  final HomeRepository _homeRepository;

  /// Load all categories and the venues of the first category.
  Future<void> loadCategories() async {
    emit(const HomeLoading());
    try {
      final categories = await _homeRepository.fetchCategories();
      if (categories.isEmpty) {
        emit(const HomeLoaded(categories: [], venues: []));
        return;
      }

      final firstCategoryId = categories.first.id;
      final venues =
          await _homeRepository.fetchVenuesByCategory(firstCategoryId);

      emit(HomeLoaded(
        categories: categories,
        venues: venues,
        selectedCategoryId: firstCategoryId,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  /// Select a category and load its venues.
  Future<void> selectCategory(String categoryId) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    emit(const HomeLoading());
    try {
      final venues =
          await _homeRepository.fetchVenuesByCategory(categoryId);
      emit(currentState.copyWith(
        venues: venues,
        selectedCategoryId: categoryId,
      ));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  /// Search venues by name.
  Future<void> searchVenuesByName(String query) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    if (query.isEmpty) {
      if (currentState.selectedCategoryId != null) {
        await selectCategory(currentState.selectedCategoryId!);
      }
      return;
    }

    emit(const HomeLoading());
    try {
      final venues = await _homeRepository.searchVenuesByName(query);
      emit(currentState.copyWith(venues: venues));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}

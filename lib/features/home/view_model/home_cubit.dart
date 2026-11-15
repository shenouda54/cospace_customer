import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cospace_customer/features/home/model/home_repository.dart';
import 'package:cospace_customer/features/home/view_model/home_state.dart';

/// Cubit managing home screen state: categories and venues.
class HomeCubit extends Cubit<HomeState> {
  HomeCubit({HomeRepository? homeRepository})
      : _homeRepository = homeRepository ?? HomeRepository(),
        super(const HomeInitial());

  final HomeRepository _homeRepository;

  Future<void> loadCategories() async {
    emit(const HomeLoading());
    try {
      final categories = await _homeRepository.fetchCategories();
      if (categories.isEmpty) {
        emit(const HomeLoaded(categories: [], venues: []));
        return;
      }

      final firstCategoryId = categories.first.id;
      final venues = await _homeRepository.fetchVenues(
        categoryId: firstCategoryId,
      );
      emit(HomeLoaded(
        categories: categories,
        venues: venues,
        selectedCategoryId: firstCategoryId,
      ));
    } catch (error) {
      emit(HomeError(error.toString()));
    }
  }

  Future<void> selectCategory(String categoryId) async {
    final current = state;
    if (current is! HomeLoaded) return;

    try {
      final venues = await _homeRepository.fetchVenues(categoryId: categoryId);
      emit(current.copyWith(
        venues: venues,
        selectedCategoryId: categoryId,
        searchQuery: '',
      ));
    } catch (error) {
      emit(HomeError(error.toString()));
    }
  }

  Future<void> searchVenuesByName(String query) async {
    final current = state;
    if (current is! HomeLoaded) return;

    final trimmed = query.trim();
    try {
      if (trimmed.isEmpty) {
        final venues = await _homeRepository.fetchVenues(
          categoryId: current.selectedCategoryId,
        );
        emit(current.copyWith(venues: venues, searchQuery: ''));
        return;
      }

      final venues = await _homeRepository.fetchVenues(query: trimmed);
      emit(current.copyWith(venues: venues, searchQuery: trimmed));
    } catch (error) {
      emit(HomeError(error.toString()));
    }
  }
}

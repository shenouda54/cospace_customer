import 'package:cospace_customer/core/services/firebase_service.dart';
import 'package:cospace_customer/features/home/model/category_model.dart';
import 'package:cospace_customer/features/home/model/venue_model.dart';

/// Loads categories and venues shared with the Vendor app.
class HomeRepository {
  HomeRepository({FirebaseService? firebase})
      : _firebase = firebase ?? FirebaseService.instance;

  final FirebaseService _firebase;

  static const List<CategoryModel> previewCategories = [
    CategoryModel(id: 'cat_study', name: 'Silent Study Rooms'),
    CategoryModel(id: 'cat_podcast', name: 'Podcast Studios'),
    CategoryModel(id: 'cat_conference', name: 'Executive Conference Rooms'),
  ];

  static const List<VenueModel> previewVenues = [
    VenueModel(
      id: 'venue_1',
      name: 'The Hive Workspace',
      description:
          'A quiet workspace with focused study rooms and fast internet.',
      categoryId: 'cat_study',
      imageUrl: '',
      roomsCount: 6,
      lat: 30.0444,
      lng: 31.2357,
    ),
    VenueModel(
      id: 'venue_2',
      name: 'VoiceWave Audio Studio',
      description: 'Soundproof podcast rooms with recording desks.',
      categoryId: 'cat_podcast',
      imageUrl: '',
      roomsCount: 4,
      lat: 30.0500,
      lng: 31.2400,
    ),
    VenueModel(
      id: 'venue_3',
      name: 'Summit Executive Suites',
      description: 'Conference rooms for team meetings.',
      categoryId: 'cat_conference',
      imageUrl: '',
      roomsCount: 6,
      lat: 30.0600,
      lng: 31.2200,
    ),
  ];

  Future<List<CategoryModel>> fetchCategories() async {
    if (!_firebase.isInitialized) return previewCategories;

    final snapshot = await _firebase.categoriesRef.get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  Future<List<VenueModel>> fetchVenues({
    String? categoryId,
    String? query,
  }) async {
    final trimmedQuery = query?.trim().toLowerCase() ?? '';

    if (!_firebase.isInitialized) {
      return previewVenues.where((venue) {
        final matchesCategory =
            categoryId == null || venue.categoryId == categoryId;
        final matchesQuery =
            trimmedQuery.isEmpty || venue.name.toLowerCase().contains(trimmedQuery);
        return matchesCategory && matchesQuery;
      }).toList();
    }

    final snapshot = categoryId == null
        ? await _firebase.venuesRef.get()
        : await _firebase.venuesRef
            .where('categoryId', isEqualTo: categoryId)
            .get();

    final venues = snapshot.docs
        .map((doc) => VenueModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();

    if (trimmedQuery.isEmpty) return venues;
    return venues
        .where((venue) => venue.name.toLowerCase().contains(trimmedQuery))
        .toList();
  }
}

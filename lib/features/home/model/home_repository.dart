import 'package:cospace_customer/core/services/firebase_service.dart';
import 'package:cospace_customer/features/home/model/category_model.dart';
import 'package:cospace_customer/features/home/model/venue_model.dart';

/// Repository for fetching categories and venues from Firestore
/// with graceful fallback sample data for initial offline/demo preview.
class HomeRepository {
  final _firebase = FirebaseService.instance;

  // ── Sample Data matching Project Specifications ──
  static const List<CategoryModel> defaultCategories = [
    CategoryModel(
      id: 'cat_study',
      name: 'Silent Study Rooms',
      imageUrl: '',
    ),
    CategoryModel(
      id: 'cat_podcast',
      name: 'Podcast Studios',
      imageUrl: '',
    ),
    CategoryModel(
      id: 'cat_conference',
      name: 'Executive Conference Rooms',
      imageUrl: '',
    ),
  ];

  static const List<VenueModel> defaultVenues = [
    VenueModel(
      id: 'venue_1',
      name: 'The Hive Workspace',
      description:
          'A modern, quiet workspace equipped with high-speed internet, ergonomic desks, and focused study pods.',
      imageUrl: '',
      location: 'Downtown, 5th Avenue',
      categoryId: 'cat_study',
      totalRooms: 6,
      vendorId: 'vendor_101',
    ),
    VenueModel(
      id: 'venue_2',
      name: 'Silicon Hub Workstations',
      description:
          'Dedicated private desks and meeting rooms with audio isolation and creative environment.',
      imageUrl: '',
      location: 'Tech District, Tower 3',
      categoryId: 'cat_study',
      totalRooms: 8,
      vendorId: 'vendor_102',
    ),
    VenueModel(
      id: 'venue_3',
      name: 'VoiceWave Audio Studio',
      description:
          'Professional podcast studio with soundproofing, condenser mics, and broadcast stations.',
      imageUrl: '',
      location: 'Media City, Building 12',
      categoryId: 'cat_podcast',
      totalRooms: 4,
      vendorId: 'vendor_103',
    ),
    VenueModel(
      id: 'venue_4',
      name: 'Summit Executive Suites',
      description:
          'Luxury conference rooms with smart presentation boards and ergonomic chairs for executive boards.',
      imageUrl: '',
      location: 'Financial Center, Floor 18',
      categoryId: 'cat_conference',
      totalRooms: 6,
      vendorId: 'vendor_104',
    ),
  ];

  /// Fetch all workspace categories.
  Future<List<CategoryModel>> fetchCategories() async {
    if (!_firebase.isInitialized) {
      return defaultCategories;
    }

    try {
      final snapshot = await _firebase.categoriesRef.get();
      if (snapshot.docs.isEmpty) {
        return defaultCategories;
      }
      return snapshot.docs
          .map((doc) => CategoryModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (_) {
      return defaultCategories;
    }
  }

  /// Fetch venues filtered by category ID.
  Future<List<VenueModel>> fetchVenuesByCategory(String categoryId) async {
    if (!_firebase.isInitialized) {
      return defaultVenues
          .where((v) => v.categoryId == categoryId)
          .toList();
    }

    try {
      final snapshot = await _firebase.venuesRef
          .where('categoryId', isEqualTo: categoryId)
          .get();
      if (snapshot.docs.isEmpty) {
        return defaultVenues
            .where((v) => v.categoryId == categoryId)
            .toList();
      }
      return snapshot.docs
          .map((doc) => VenueModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (_) {
      return defaultVenues
          .where((v) => v.categoryId == categoryId)
          .toList();
    }
  }

  /// Search venues by name (case-insensitive prefix match).
  Future<List<VenueModel>> searchVenuesByName(String query) async {
    final lower = query.toLowerCase().trim();
    if (!_firebase.isInitialized) {
      return defaultVenues
          .where((v) => v.name.toLowerCase().contains(lower))
          .toList();
    }

    try {
      final snapshot = await _firebase.venuesRef
          .orderBy('name')
          .startAt([lower])
          .endAt(['$lower\uf8ff'])
          .get();
      if (snapshot.docs.isEmpty) {
        return defaultVenues
            .where((v) => v.name.toLowerCase().contains(lower))
            .toList();
      }
      return snapshot.docs
          .map((doc) => VenueModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (_) {
      return defaultVenues
          .where((v) => v.name.toLowerCase().contains(lower))
          .toList();
    }
  }
}

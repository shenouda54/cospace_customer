import 'package:cospace_customer/core/services/firebase_service.dart';
import 'package:cospace_customer/features/home/model/category_model.dart';
import 'package:cospace_customer/features/home/model/venue_model.dart';

/// Repository for fetching categories and venues from Firestore.
class HomeRepository {
  final _firebase = FirebaseService.instance;

  /// Fetch all workspace categories.
  Future<List<CategoryModel>> fetchCategories() async {
    final snapshot = await _firebase.categoriesRef.get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  /// Fetch venues filtered by category ID.
  Future<List<VenueModel>> fetchVenuesByCategory(String categoryId) async {
    final snapshot = await _firebase.venuesRef
        .where('categoryId', isEqualTo: categoryId)
        .get();
    return snapshot.docs
        .map((doc) => VenueModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  /// Search venues by name (case-insensitive prefix match).
  Future<List<VenueModel>> searchVenuesByName(String query) async {
    final snapshot = await _firebase.venuesRef
        .orderBy('name')
        .startAt([query.toLowerCase()])
        .endAt(['${query.toLowerCase()}\uf8ff'])
        .get();
    return snapshot.docs
        .map((doc) => VenueModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }
}

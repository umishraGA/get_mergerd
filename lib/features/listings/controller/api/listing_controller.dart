
import 'listing_models.dart';
import 'listing_service.dart';

class ListingController {
  ListingController({ListingService? service}) : _service = service ?? ListingService();

  final ListingService _service;

  Future<ListingResult> fetchListings({
    required String keyword,
    required String userLat,
    required String userLng,
    required String authToken,
  }) async {
    try {
      final list = await _service.searchListings(
        keyword: keyword,
        userLat: userLat,
        userLng: userLng,
        authToken: authToken,
      );
      final models = list.map((e) => ListingItemModel.fromJson(e)).toList();
      return ListingResult(items: models);
    } catch (e) {
      return ListingResult(items: const [], errorMessage: e.toString());
    }
  }
}

class ListingResult {
  final List<ListingItemModel> items;
  final String? errorMessage;
  const ListingResult({required this.items, this.errorMessage});
}



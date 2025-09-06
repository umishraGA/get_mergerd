import 'package:flutter/foundation.dart';

class SearchResult {
  final String title;
  final String subtitle;

  SearchResult({required this.title, required this.subtitle});
}

class SearchProvider with ChangeNotifier {
  List<SearchResult> _searchResults = [];
  bool _isLoading = false;
  String _currentQuery = '';

  List<SearchResult> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get currentQuery => _currentQuery;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _currentQuery = query;
    _isLoading = true;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    // TODO: Replace with actual search implementation
    // This is a mock implementation
    _searchResults = [
      SearchResult(title: 'Result 1 for $query', subtitle: 'Description 1'),
      SearchResult(title: 'Result 2 for $query', subtitle: 'Description 2'),
      SearchResult(title: 'Result 3 for $query', subtitle: 'Description 3'),
    ];

    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _searchResults = [];
    _currentQuery = '';
    notifyListeners();
  }
}

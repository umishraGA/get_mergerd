import '../../../utils/dio/api_service.dart';
import '../models/story_response_models.dart';
import '../repository/story_repository.dart';

class StoryViewModel {
  final StoryRepository storyRepository;

  StoryViewModel() : storyRepository = StoryRepository(apiService: ApiService());

  /// Fetch stories from API
  Future<StoryResponse> fetchStories({int pageNo = 1, int pageSize = 10}) async {
    try {
      return await storyRepository.getStories(pageNo: pageNo, pageSize: pageSize);
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Fetch stories with error handling and validation
  Future<StoryResponse> fetchStoriesSafe({int pageNo = 1, int pageSize = 10}) async {
    try {
      final response = await storyRepository.getStories(pageNo: pageNo, pageSize: pageSize);
      
      // Validate response
      if (response.success == true) {
        throw Exception('API returned unsuccessful response: ${response.message}');
      }
      
      if (response.statusCode != 200) {
        throw Exception('API returned status code: ${response.statusCode}');
      }
      
      return response;
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }

  /// Get static/fallback stories using existing service
  List<StoryItem> getStaticStories() {
    // Convert StoryModel to StoryItem for compatibility
    return List.empty();
  }

  /// Fetch user's own stories
  Future<StoryResponse> fetchUserStories(String userId, {int pageNo = 1, int pageSize = 10}) async {
    try {
      return await storyRepository.getUserStories(userId, pageNo: pageNo, pageSize: pageSize);
    } catch (e) {
      throw Exception('Service error: $e');
    }
  }
}